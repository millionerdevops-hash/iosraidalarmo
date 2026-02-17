import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:fixnum/fixnum.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../proto/rustplus.pb.dart';
import '../services/database_service.dart';
import '../../data/models/server_info.dart';

class ConnectionManager {
  WebSocketChannel? _channel;
  final ServerInfo _serverInfo;
  
  // Stream controller to broadcast messages to the app (e.g. Alarms, Entity Changes)
  final _messageController = StreamController<AppMessage>.broadcast();
  Stream<AppMessage> get messageStream => _messageController.stream;

  // Map to store pending requests (seq -> Completer)
  final Map<int, Completer<AppMessage>> _pendingRequests = {};
  int _seq = 1;

  // Rate Limiting: entityId -> Last request timestamp
  final Map<int, DateTime> _lastEntityRequests = {};
  static const _debounceDuration = Duration(milliseconds: 500);

  ConnectionManager(this._serverInfo);

  bool get isConnected => _channel != null;

  Future<void> connect() async {
    if (isConnected) return;
    
    // Try primary connection method first
    bool wasSuccessful = await _tryConnect(_serverInfo.useProxy);
    
    // If it failed and we weren't already using proxy, try proxy as fallback
    if (!wasSuccessful && !_serverInfo.useProxy) {
      // Direct connection failed. Trying Facepunch Proxy Fallback...
      wasSuccessful = await _tryConnect(true); // Force proxy 
      
      if (wasSuccessful) {

        // Persist the working preference
        final dbService = DatabaseService();
        final isar = await dbService.db;
        await isar.writeTxn(() async {
          _serverInfo.useProxy = true;
          await isar.collection<ServerInfo>().put(_serverInfo);
        });
      }
    }
    
    if (!wasSuccessful) {
      throw Exception("Could not connect to Rust server (tried direct and proxy)");
    }
  }

  Future<bool> _tryConnect(bool useProxy) async {
    final uri = _getConnectionUri(useProxy);

    
    final completer = Completer<bool>();
    
    try {
      _channel = WebSocketChannel.connect(uri);
      
      // Wait for the first message or a timeout to verify connection
      // This is necessary because WebSocketChannel.connect doesn't always throw immediately
      bool firstRecordReceived = false;
      
      _channel!.stream.listen(
        (data) {
          if (!firstRecordReceived) {
            firstRecordReceived = true;
            if (!completer.isCompleted) completer.complete(true);
          }
          _handleMessage(data);
        },
        onError: (error) {
          // WebSocket Error
          if (!completer.isCompleted) completer.complete(false);
          disconnect();
        },
        onDone: () {
          // WebSocket Closed
          if (!completer.isCompleted) completer.complete(false);
          disconnect();
        },
      );

      // Verify connection by sending a simple packet or just waiting
      // We'll wait a bit. If onDone/onError isn't called, it's likely open.
      return await completer.future.timeout(const Duration(seconds: 5), onTimeout: () {
        // If we haven't failed but haven't received data, assume OK if channel still there
        if (_channel != null) {
          if (!completer.isCompleted) completer.complete(true);
          return true;
        }
        return false;
      });
      
    } catch (e) {
      // Connection attempt failed
      return false;
    }
  }

  Uri _getConnectionUri(bool useProxy) {
    if (useProxy) {
      return Uri.parse('wss://companion-rust.facepunch.com/game/${_serverInfo.ip}/${_serverInfo.port}');
    } else {
      return Uri.parse('ws://${_serverInfo.ip}:${_serverInfo.port}');
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    // Fail all pending requests
    for (var completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError("Disconnected");
      }
    }
    _pendingRequests.clear();
  }

  void _handleMessage(dynamic data) {
    try {
      final message = AppMessage.fromBuffer(data as List<int>);
      
      // If it's a response to a request
      if (message.hasResponse() && message.response.hasSeq()) {
        final seq = message.response.seq;
        if (_pendingRequests.containsKey(seq)) {
          _pendingRequests[seq]!.complete(message);
          _pendingRequests.remove(seq);
          return; // Handled as response
        }
      }

      // If not a handled response, broadcast it
      _messageController.add(message);
    } catch (e) {
      // Error decoding message
    }
  }

  Future<AppMessage> sendRequest(AppRequest request) async {
    if (!isConnected) {
      await connect();
    }

    final seq = _seq++;
    request.seq = seq;
    request.playerId = Int64.parseInt(_serverInfo.playerId);
    request.playerToken = int.parse(_serverInfo.playerToken);

    final completer = Completer<AppMessage>();
    _pendingRequests[seq] = completer;

    _channel!.sink.add(request.writeToBuffer());

    // Timeout header
    return completer.future.timeout(const Duration(seconds: 10), onTimeout: () {
      _pendingRequests.remove(seq);
      throw TimeoutException("Request timed out");
    });
  }

  // --- API Methods ---

  /// Toggle Smart Switch
  Future<AppMessage> setEntityValue(int entityId, bool value) async {
    // Spam Prevention: Check if we sent a request for this entity recently
    final now = DateTime.now();
    if (_lastEntityRequests.containsKey(entityId)) {
      final diff = now.difference(_lastEntityRequests[entityId]!);
      if (diff < _debounceDuration) {
        // Rate limit hit
        throw Exception("Rate limit: Please wait before toggling again.");
      }
    }
    _lastEntityRequests[entityId] = now;

    final req = AppRequest()
      ..entityId = entityId
      ..setEntityValue = (AppSetEntityValue()..value = value);
    return sendRequest(req);
  }

  /// Convenience method to turn Smart Switch ON
  Future<AppMessage> turnSmartSwitchOn(int entityId) => setEntityValue(entityId, true);

  /// Convenience method to turn Smart Switch OFF
  Future<AppMessage> turnSmartSwitchOff(int entityId) => setEntityValue(entityId, false);

  /// Get Entity Info (Smart Switch, Alarm, Storage Monitor)
  /// IMPORTANT: You must call this at least once for an entity to receive broadcasts
  Future<AppMessage> getEntityInfo(int entityId) {
    final req = AppRequest()
      ..entityId = entityId
      ..getEntityInfo = AppEmpty();
    return sendRequest(req);
  }


  /// Get Map Data (Image, Monuments)
  Future<AppMessage> getMap() {
    final req = AppRequest()..getMap = AppEmpty();
    return sendRequest(req);
  }

  /// Get Map Markers (Shops, Events, etc)
  Future<AppMessage> getMapMarkers() {
    final req = AppRequest()..getMapMarkers = AppEmpty();
    return sendRequest(req);
  }
}
