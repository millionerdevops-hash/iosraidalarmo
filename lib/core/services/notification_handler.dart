import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/database_service.dart';
import '../../core/router/app_router.dart';
import 'package:isar/isar.dart';
import '../../data/models/fcm_credential.dart';
import '../../data/models/smart_device.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../features/devices/device_pairing_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'fcm_service.dart';

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
      
      // 2. Request Firebase Permission (Still needed for some services)
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // 3. Setup Firebase Messaging Handlers (Fallback)
      FirebaseMessaging.onMessage.listen((message) {
        _handleData(message.data);
      });

      // 4. Setup OneSignal Handlers (Primary)
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        // Prevent default display if we handle it manually or just let it show
        // and process the data
        _handleData(event.notification.additionalData);
      });

      OneSignal.Notifications.addClickListener((result) {
        _handleData(result.notification.additionalData);
      });

      // 5. Initial Sync (optional)
      unawaited(FcmService().syncServersToServer());

    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Init Error: $e");
    }
  }

  static Future<void> _handleData(Map<String, dynamic>? data) async {
    if (data == null) return;
    
    // Normalize data (handle stringified body if sent as push)
    final Map<String, dynamic> normalizedData = Map.from(data);
    if (normalizedData.containsKey('body')) {
      try {
        final bodyJson = jsonDecode(normalizedData['body'] as String);
        if (bodyJson is Map<String, dynamic>) {
          normalizedData.addAll(bodyJson);
        }
      } catch (e) {}
    }
    
    if (normalizedData.containsKey('entityId')) {
      if (normalizedData.containsKey('entityType')) {
         await _handleDevicePairing(normalizedData);
      } else {
         // Show local alert or just rely on push
      }
    } else if (normalizedData.containsKey('ip') && normalizedData.containsKey('playerToken')) {
      await _handlePairingNotification(normalizedData);
    }
  }
  
  static Future<void> _handleDevicePairing(Map<String, dynamic> data) async {
    try {
      final int entityId = int.parse(data['entityId'].toString());
      final int entityType = int.parse(data['entityType'].toString());
      
      final context = AppRouter.router.routerDelegate.navigatorKey.currentContext;
      if (context != null) {
         final dbService = DatabaseService();
         final isar = await dbService.db;
         final server = await isar.serverInfos.filter().isSelectedEqualTo(true).findFirst() 
                        ?? await isar.serverInfos.where().findFirst();
                        
         if (server != null) {
            // Show pairing sheet
            showMaterialModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => DevicePairingScreen(
                serverId: server.id,
                entityId: entityId,
                entityType: entityType,
                initialName: data['name'],
              ),
            );
         }
      }
    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Pairing Error: $e");
    }
  }
  
  static Future<void> _handlePairingNotification(Map<String, dynamic> data) async {
    try {
      final serverInfo = ServerInfo()
        ..ip = data['ip']
        ..port = data['port'].toString()
        ..playerId = data['playerId']
        ..playerToken = data['playerToken']
        ..name = data['name'] ?? "New Server (${data['ip']})";

      final dbService = DatabaseService();
      final isar = await dbService.db;
      
      await isar.writeTxn(() async {
        final existing = await isar.serverInfos
            .filter()
            .ipEqualTo(serverInfo.ip)
            .portEqualTo(serverInfo.port)
            .findFirst();
            
        if (existing != null) {
          serverInfo.id = existing.id;
        }
        await isar.serverInfos.put(serverInfo);
      });

      // Sync updated server list to central server
      unawaited(FcmService().syncServersToServer());
      
    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Server Pairing Error: $e");
    }
  }
}
