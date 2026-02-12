import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/router/app_router.dart';
import 'package:isar/isar.dart';
import '../../data/models/server_info.dart';
import '../../data/models/smart_device.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../features/devices/device_pairing_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'fcm_service.dart';
import 'database_service.dart';
import '../../data/models/notification_data.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/attack_statistics_repository.dart';
import '../../data/database/app_database.dart';
import 'dart:async';

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

      // 3. Initial Sync
      unawaited(FcmService().syncServersToServer());

    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Init Error: $e");
    }
  }

  static Future<void> _handleData(Map<String, dynamic>? data) async {
    if (data == null) return;
    
    final Map<String, dynamic> normalizedData = Map.from(data);
    if (normalizedData.containsKey('body')) {
      try {
        final bodyJson = jsonDecode(normalizedData['body'] as String);
        if (bodyJson is Map<String, dynamic>) {
          normalizedData.addAll(bodyJson);
        }
      } catch (e) {}
    }
    
    if (normalizedData.containsKey('entityId') && normalizedData.containsKey('entityType')) {
      await _handleDevicePairing(normalizedData);
    } else if (normalizedData.containsKey('ip') && normalizedData.containsKey('playerToken')) {
      await _handlePairingNotification(normalizedData);
    } else if (normalizedData['type'] == 'alarm') {
      await _handleAlarmNotification(normalizedData);
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
      
      final dbService = DatabaseService();
      final isar = await dbService.db;

      // 1. Check if device is already paired
      final existingDevice = await isar.smartDevices
          .filter()
          .entityIdEqualTo(entityId)
          .findFirst();

      if (existingDevice != null) {
        // Device exists -> Update state silently
        debugPrint("[NotificationHandler] 🔄 Device ${existingDevice.name} already paired. Updating state...");
        
        // Extract value from payload content if available
        bool newState = existingDevice.isActive; // Default to current
        
        try {
           // Rust+ Fcm payload structure varies, usually:
           // message: "Switch 'X' state changed."
           // But key data is usually needed.
           // If we can't determine state from push, we might need to fetch it.
           // However, let's assume if we get a notification, we can at least try to pull the new state via ConnectionManager if app is open
           // Or just leave it to the app resume logic.
           
           // For now, we mainly prevent the annoyance of the Dialog popping up.
           // We can optimistically toggle if we knew the prev state, but that's risky.
           
           // If the payload has "value" or "active", use it.
           if (data.containsKey('value')) {
             newState = data['value'] == 'true' || data['value'] == true || data['value'] == '1';
             await isar.writeTxn(() async {
                existingDevice.isActive = newState;
                await isar.smartDevices.put(existingDevice);
             });
           }
        } catch (e) {
           debugPrint("Error updating state in handler: $e");
        }
        return; // EXIT, do not show dialog
      }

      // 2. Not paired -> Show Pairing Dialog
      final context = AppRouter.router.routerDelegate.navigatorKey.currentContext;
      if (context != null) {
         final server = await isar.collection<ServerInfo>().filter().isSelectedEqualTo(true).findFirst() 
                        ?? await isar.collection<ServerInfo>().where().findFirst();
                        
         if (server != null) {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: "Pair Device",
              barrierColor: Colors.black54,
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, anim1, anim2) {
                return Center(
                  child: Material(
                    color: Colors.transparent,
                    child: DevicePairingScreen(
                      serverId: server.id,
                      entityId: entityId,
                      entityType: entityType,
                    ),
                  ),
                );
              },
              transitionBuilder: (context, anim1, anim2, child) {
                return Transform.scale(
                  scale: Curves.easeOutBack.transform(anim1.value),
                  child: child,
                );
              },
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

      unawaited(FcmService().syncServersToServer());
      
    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Server Pairing Error: $e");
    }
  }
}
