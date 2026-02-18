import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/router/app_router.dart';
import 'package:isar/isar.dart';
import '../../data/models/server_info.dart';
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
import '../../data/repositories/settings_repository.dart';
import '../../services/alarm_service.dart';

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
      
      // 3. Trigger Alarm and Fake Call (Android specific, iOS handles via AppDelegate VoIP)
      if (defaultTargetPlatform == TargetPlatform.android) {
        final settingsRepo = SettingsRepository(db);
        final settings = await settingsRepo.getAlarmSettings();
        
        if (settings.alarmEnabled) {
          final alarmService = AlarmService();
          await alarmService.triggerAlarm();
          
          if (settings.fakeCallEnabled) {
            await alarmService.triggerFakeCall(
              id: 'rust_alarm_${timestamp}',
              callerName: notification.title,
              subtitle: notification.body,
            );
          }
        }
      }
      
      debugPrint("[NotificationHandler] ⚔️ Attack recorded & saved to history (Alarm triggered if Android)");
    } catch (e) {
      debugPrint("[NotificationHandler] ❌ Error handling alarm: $e");
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
