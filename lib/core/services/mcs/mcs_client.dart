import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'proto_utils.dart';
import 'mcs_messages.dart';

class McsClient {
  static const String HOST = 'mtalk.google.com';
  static const int PORT = 5228;
  
  // MCS Tags
  static const int kHeartbeatPingTag = 0;
  static const int kHeartbeatAckTag = 1;
  static const int kLoginRequestTag = 2;
  static const int kLoginResponseTag = 3;
  static const int kCloseTag = 4;
  static const int kIqStanzaTag = 7;
  static const int kDataMessageStanzaTag = 8;
  
  final int androidId;
  final int securityToken;
  
  SecureSocket? _socket;
  final _controller = StreamController<DataMessageStanza>.broadcast();
  Stream<DataMessageStanza> get onMessage => _controller.stream;
  
  final List<String> _persistentIds = [];
  
  McsClient(this.androidId, this.securityToken);
  
  Future<void> connect() async {

    
    try {
      _socket = await SecureSocket.connect(HOST, PORT, 
        onBadCertificate: (_) => true // Trust Google
      );
  
      
      // Perform Login
      _sendLogin();
      
      // Listen
      _socket!.listen(
        _onData,
        onError: (e) => null, // Socket Error
        onDone: () => null, // Socket Closed
      );
      
    } catch (e) {
      // MCS Connection Failed
    }
  }
  
  void _sendLogin() {

    final hexId = androidId.toRadixString(16);
    final req = LoginRequest(
      deviceId: "android-$hexId",
      resource: androidId.toString(),
      user: androidId.toString(),
      authToken: securityToken.toString(),
      receivedPersistentIds: _persistentIds,
    );
    
    final protoBytes = req.toBytes();
    _sendPacket(kLoginRequestTag, protoBytes);
  }
  
  void _sendPacket(int tag, List<int> data) {
    final builder = BytesBuilder();
    // Version 41 if LoginRequest
    if (tag == kLoginRequestTag) {
        builder.addByte(41); 
    }
    builder.addByte(tag);
    
    // Write Length Varint
    final lengthWriter = ProtoWriter();
    lengthWriter.writeVarint(data.length);
    builder.add(lengthWriter.toBytes());
    
    builder.add(data);
    
    if (_socket != null) {
      _socket!.add(builder.toBytes());
    }
  }
  
  List<int> _pendingBytes = [];
  bool _versionRead = false;
  
  // State Machine
  int _state = 0; // 0=Tag, 1=Length, 2=Body
  int _currentTag = 0;
  int _currentLength = 0;
  
  void _onData(Uint8List newData) {
     _pendingBytes.addAll(newData);
     
     // Consume Version Byte (41) first time only
     if (!_versionRead) {
       if (_pendingBytes.isNotEmpty) {
         final maxVer = _pendingBytes[0];
         debugPrint("MCS Protocol Version: $maxVer");
         _pendingBytes.removeAt(0);
         _versionRead = true;
       } else {
         return;
       }
     }
     
     _processLoop();
  }
  
  void _processLoop() {
    bool keepGoing = true;
    while(keepGoing) {
      switch (_state) {
        case 0: // Expecting Tag
          if (_pendingBytes.isNotEmpty) {
            _currentTag = _pendingBytes[0];
            _pendingBytes.removeAt(0);
            _state = 1; // Go to Length
          } else {
            keepGoing = false;
          }
          break;
          
        case 1: // Expecting Length Varint
          final result = _readVarint(_pendingBytes);
          if (result != null) {
            _currentLength = result.value;
            // Remove consumed bytes
            _pendingBytes.removeRange(0, result.bytesRead);
            _state = 2; // Go to Body
          } else {
            keepGoing = false; // Need more bytes
          }
          break;
          
        case 2: // Expecting Body
          if (_pendingBytes.length >= _currentLength) {
            final body = _pendingBytes.sublist(0, _currentLength);
            _pendingBytes.removeRange(0, _currentLength);
            
            _handlePacket(_currentTag, body);
            
            _state = 0; // Reset to Tag
          } else {
             keepGoing = false;
          }
          break;
      }
    }
  }
  
  void _handlePacket(int tag, List<int> body) {
    // debugPrint("Received MCS Packet Tag: $tag (Len: ${body.length})");
    
    switch (tag) {
      case kLoginResponseTag:
        // LoginResponse
        break;
        
      case kHeartbeatPingTag:
        // Heartbeat Ping
        _handleHeartbeatPing(body);
        break;
        
      case kHeartbeatAckTag:
        // Heartbeat Ack
        break;
        
      case kCloseTag:
        // Info/Close Packet
        break;
        
      case kIqStanzaTag:
         // debugPrint("[MCS] Received IqStanza (Ignored for now)");
         // TODO: Parse if needed
         break;
         
      case kDataMessageStanzaTag:
        try {
          final msg = DataMessageStanza.fromBytes(body);
          
          if (msg.persistentId.isNotEmpty) {
            if (_persistentIds.contains(msg.persistentId)) {
               // Ignoring duplicate notification
               return;
            }
            _persistentIds.add(msg.persistentId);
            // Keep the list size manageable (e.g. last 100 IDs)
            if (_persistentIds.length > 100) {
              _persistentIds.removeAt(0);
            }
          }


          _controller.add(msg);
        } catch (e) {
          // Failed to parse DataMessage
        }
        break;
        
      default:
        // Unknown Tag
    }
  }
  
  void _handleHeartbeatPing(List<int> body) {
    final ping = HeartbeatPing.fromBytes(body);
    final ack = HeartbeatAck()
      ..streamId = ping.streamId
      ..lastStreamIdReceived = ping.lastStreamIdReceived
      ..status = 0; // OK
      
    _sendPacket(kHeartbeatAckTag, ack.toBytes());
  }

  // Helper: Try to read varint from list. Returns null if incomplete.
  VarintResult? _readVarint(List<int> buffer) {
    int value = 0;
    int shift = 0;
    int bytesRead = 0;
    
    for (int i = 0; i < buffer.length; i++) {
       final byte = buffer[i];
       bytesRead++;
       value |= (byte & 0x7F) << shift;
       if ((byte & 0x80) == 0) {
         return VarintResult(value, bytesRead);
       }
       shift += 7;
    }
    return null; // Incomplete
  }
}

class VarintResult {
  final int value;
  final int bytesRead;
  VarintResult(this.value, this.bytesRead);
}

