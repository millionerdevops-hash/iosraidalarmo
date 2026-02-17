import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/router/app_router.dart';
import 'package:isar/isar.dart';
import '../../data/models/server_info.dart';
import '../../data/models/smart_device.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'database_service.dart';
import '../../data/models/notification_data.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/attack_statistics_repository.dart';
import '../../data/database/app_database.dart';
import 'dart:async'; // For Completer
import '../../core/services/connection_manager.dart'; // Import ConnectionManager
import '../../core/proto/rustplus.pb.dart';

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      // 1. Initialize Local Notifications
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      
      await _localNotifications.initialize(
        initSettings,
      );
      
      // 2. Setup OneSignal Handlers (Primary)
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        _handleData(event.notification.additionalData);
      });

      OneSignal.Notifications.addClickListener((result) {
        _handleData(result.notification.additionalData);
      });

      // Server handles sync automatically

    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Init Error: $e");
    }
  }

  static Future<void> _handleData(Map<String, dynamic>? data) async {
    if (data == null) return;
    
    debugPrint("[NotificationHandler] 📩 Received Payload: ${jsonEncode(data)}");

    try {
      final Map<String, dynamic> normalizedData = Map.from(data);
      if (normalizedData.containsKey('body')) {
        try {
          final bodyJson = jsonDecode(normalizedData['body'] as String);
          if (bodyJson is Map<String, dynamic>) {
            normalizedData.addAll(bodyJson);
          }
        } catch (e) {
          debugPrint("[NotificationHandler] ⚠️ Body parse error (non-fatal): $e");
        }
      }

      final type = normalizedData['type']?.toString();
      debugPrint("[NotificationHandler] 🔍 Processing notification type: $type");

      // 1. Handle server pairing
      if (type == 'server_pairing') {
        await _handleServerPairing(normalizedData);
        return;
      }
      
      // 2. Handle device pairing
      if (type == 'device_pairing' || (normalizedData.containsKey('entityId') && normalizedData.containsKey('entityType'))) {
        await _handleDevicePairing(normalizedData);
        return;
      }

      // 3. Handle Alarms (Raid or Alarm)
      if (type == 'raid' || type == 'alarm' || normalizedData['channelId'] == 'alarm') {
        await _handleAlarmNotification(normalizedData);
        return;
      }

      // 4. Legacy / Fallback
      if (normalizedData.containsKey('ip') && normalizedData.containsKey('playerToken')) {
        await _handleServerPairing(normalizedData);
      }
    } catch (e, stack) {
      debugPrint("[NotificationHandler] ❌ Error in _handleData: $e\n$stack");
    }
  }

  static Future<void> _handleAlarmNotification(Map<String, dynamic> data) async {
    try {
      final db = AppDatabase();
      final statsRepo = AttackStatisticsRepository(db);
      final notifRepo = NotificationRepository(db);
      
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      
      // 1. Record Statistics
      await statsRepo.recordAttack(timestamp);
      
      // 2. Save Notification History
      final notification = NotificationData(
        title: data['title'] ?? 'Alarm',
        body: data['message'] ?? 'Your base is under attack!',
        timestamp: timestamp,
        packageName: 'com.raidalarm', // Internal package name
        channelId: 'alarm',
      );
      
      await notifRepo.saveNotification(notification);
      
      debugPrint("[NotificationHandler] ⚔️ Attack recorded & saved to history");
    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Error handling alarm: $e");
    }
  }
  
  static Future<void> _handleDevicePairing(Map<String, dynamic> data) async {
    try {
      final int entityId = int.parse(data['entityId'].toString());
      final int entityType = int.parse(data['entityType'].toString());
      
      // Critical Fix #3: Use server IP/port from payload
      final String? serverIp = data['server_ip'];
      final String? serverPort = data['server_port']?.toString();

      final dbService = DatabaseService();
      final isar = await dbService.db;

      // Find server by IP/Port from payload
      ServerInfo? server;
      if (serverIp != null && serverPort != null) {
        server = await isar.collection<ServerInfo>()
            .filter()
            .ipEqualTo(serverIp)
            .portEqualTo(serverPort)
            .findFirst();
      }
      
      // Fallback to selected/first server if not found
      server ??= await isar.collection<ServerInfo>()
          .filter().isSelectedEqualTo(true).findFirst() 
          ?? await isar.collection<ServerInfo>().where().findFirst();
          
      if (server == null) {
        debugPrint("[NotificationHandler] ❌ No server found for device pairing");
        return;
      }

      // 1. Check if device is already paired
      final existingDevice = await isar.collection<SmartDevice>()
          .filter()
          .serverIdEqualTo(server.id)
          .entityIdEqualTo(entityId)
          .findFirst();

      if (existingDevice != null) {
        // Device exists -> Update state silently
        debugPrint("[NotificationHandler] 🔄 Device ${existingDevice.name} already paired. Updating state...");
        
        try {
          if (data.containsKey('value')) {
            final newState = data['value'].toString() == 'true' || data['value'].toString() == '1';
            await isar.writeTxn(() async {
               existingDevice.isActive = newState;
               await isar.collection<SmartDevice>().put(existingDevice);
            });
          }
        } catch (e) {
           debugPrint("Error updating state in handler: $e");
        }
        return; // EXIT, do not show dialog
      }

      // 2. Not paired -> Auto-pair
      debugPrint("[NotificationHandler] 📱 Auto-pairing device for ${server.name} (Entity: $entityId)");
      
      final device = SmartDevice()
        ..serverId = server.id
        ..entityId = entityId
        ..entityType = entityType
        ..name = _getDefaultNameForType(entityType);

      await isar.writeTxn(() async {
        await isar.collection<SmartDevice>().put(device);
      });

      debugPrint("[NotificationHandler] ✅ Device auto-paired successfully: ${device.name}");
      
      // Immediately fetch status if possible (fire and forget)
      _syncDeviceStatus(server.id, entityId);
    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Pairing Error: $e");
    }
  }

  static String _getDefaultNameForType(int typeVal) {
     // Mirroring logic from DevicePairingScreen
     // 1: Switch, 2: Alarm
     if (typeVal == 1) return "Smart Switch";
     if (typeVal == 2) return "Smart Alarm";
     return "Smart Device";
  }

  static Future<void> _syncDeviceStatus(int serverId, int entityId) async {
    ConnectionManager? manager;
    try {
       // 1. Get Server Info
       final dbService = DatabaseService();
       final isar = await dbService.db;
       final server = await isar.collection<ServerInfo>().get(serverId);
       
       if (server == null) return;

       debugPrint("[NotificationHandler] 🔄 Syncing status for Entity: $entityId on Server: ${server.name}...");

       // 2. Create a temporary ConnectionManager
       manager = ConnectionManager(server);
       
       // 3. Connect and Fetch Info
       await manager.connect();
       
       // 4. Send Request (getEntityInfo)
       // We need to listen to the stream to get the actual data update? 
       // ConnectionManager broadcasts messages. 
       // In this temporary context, we can listen to the stream manually.
       
       final completer = Completer<void>();
       
       final sub = manager.messageStream.listen((message) async {
          if (message.hasBroadcast() && message.broadcast.hasEntityChanged()) {
             final change = message.broadcast.entityChanged;
             if (change.entityId == entityId) {
                // Update Database
                await isar.writeTxn(() async {
                   final device = await isar.collection<SmartDevice>().filter()
                       .serverIdEqualTo(serverId)
                       .entityIdEqualTo(entityId)
                       .findFirst();
                   
                   if (device != null) {
                     device.isActive = change.payload.value;
                     await isar.collection<SmartDevice>().put(device);
                     debugPrint("[NotificationHandler] ✅ Status Synced: ${device.name} is ${device.isActive ? 'ON' : 'OFF'}");
                   }
                });
                if (!completer.isCompleted) completer.complete();
             }
          }
       });

       // Trigger the request
       await manager.getEntityInfo(entityId);
       
       // Wait for a response or timeout (short timeout since we just want a quick check)
       await completer.future.timeout(const Duration(seconds: 3));
       await sub.cancel();

    } catch (e) {
       debugPrint("[NotificationHandler] ⚠️ Sync warning: $e");
    } finally {
       manager?.disconnect();
    }
  }
  
  static Future<void> _handleServerPairing(Map<String, dynamic> data) async {
    try {
      final serverInfo = ServerInfo()
        ..ip = data['ip']
        ..port = data['port'].toString()
        ..playerId = data['playerId'].toString()
        ..playerToken = data['playerToken'].toString()
        ..name = data['name'] ?? "New Server (${data['ip']})";

      final dbService = DatabaseService();
      final isar = await dbService.db;
      
      await isar.writeTxn(() async {
        final existing = await isar.collection<ServerInfo>()
            .filter()
            .ipEqualTo(serverInfo.ip)
            .portEqualTo(serverInfo.port)
            .findFirst();
            
        if (existing != null) {
          serverInfo.id = existing.id;
        }
        await isar.collection<ServerInfo>().put(serverInfo);
      });

      debugPrint("[NotificationHandler] ✅ Server paired successfully: ${serverInfo.name}");
    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Server Pairing Error: $e");
    }
  }
}
