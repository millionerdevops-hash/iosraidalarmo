import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/models/server_info.dart';
import '../services/database_service.dart';
import '../../config/routes/app_router.dart';
import 'package:isar/isar.dart';
import '../../data/models/fcm_credential.dart';
import '../../data/models/smart_device.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/mcs/gcm_service.dart';
import '../services/mcs/mcs_client.dart';
import 'fcm_service.dart'; // Added missing import



class NotificationHandler {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static McsClient? _mcsClient;
  static String? customToken; // Exposed for FcmService

  static Future<void> _startMcsClient() async {
    try {
      debugPrint("[MCS] 🚀 STARTING CUSTOM MCS CLIENT (FCM SPOOFING)...");
      
      // 1. Check for existing MCS credentials
      final dbService = DatabaseService();
      final isar = await dbService.db;
      final existingCred = await isar.fcmCredentials.get(1);
      
      int androidId;
      int securityToken;
      String token;

      if (existingCred != null && existingCred.androidId != null && existingCred.securityToken != null) {
        debugPrint("[MCS] ✅ Found persistent MCS credentials. Reusing identity...");
        androidId = existingCred.androidId!;
        securityToken = existingCred.securityToken!;
        token = existingCred.fcmToken; // Assuming this is still valid
        
        debugPrint("[MCS] Reusing Android ID: $androidId");
      } else {
         debugPrint("[MCS] ⚠️ No persistent credentials. Generating NEW identity...");
         final gcm = GcmService();
         
         // 1. Check-in (Get Android ID)
         final checkinData = await gcm.checkIn();
         androidId = checkinData['androidId'];
         securityToken = checkinData['securityToken'];
         
         // 2. Register (Get Token)
         token = await gcm.register(androidId, securityToken);
         debugPrint("[MCS] 🔥 CUSTOM FCM TOKEN: $token");
         
         // SAVE CREDENTIALS IMMEDIATELY
         await isar.writeTxn(() async {
            final cred = existingCred ?? FcmCredential(); // Update or Create
            cred.androidId = androidId;
            cred.securityToken = securityToken;
            cred.fcmToken = token;
            await isar.fcmCredentials.put(cred);
         });
         debugPrint("[MCS] 💾 Credentials Saved to Isar for next launch.");
      }
      
      customToken = token; // Store globally
      
      // 3. Connect to MCS (Listen for notifications)
      _mcsClient = McsClient(androidId, securityToken);
      await _mcsClient!.connect();
      
      _mcsClient!.onMessage.listen((stanza) {
        debugPrint("[MCS] 📨 MCS NOTIFICATION RECEIVED!");
        debugPrint("[MCS] From: ${stanza.from}");
        
        // Convert AppData to Map
        final data = <String, dynamic>{};
        for (var entry in stanza.appData) {
          data[entry.key] = entry.value;
        }
        
        // Handle Body Json (Issue #75)
        if (data.containsKey('body') && !data.containsKey('ip') && !data.containsKey('entityId')) {
           try {
             final bodyJson = jsonDecode(data['body']);
             data.addAll(bodyJson);
           } catch(e) {}
        }
        
        // REUSE LOGIC:
        // CRITICAL: Check for entityId FIRST
        if (data.containsKey('entityId')) {
          if (data.containsKey('entityType')) {
             debugPrint("[MCS] Detected entity pairing (MCS)");
             _handleDevicePairing(data);
          } else {
             debugPrint("[MCS] Detected Smart Alarm Trigger (MCS)");
             _showAlarmNotification(null, data); 
          }
        } else if (data.containsKey('ip') && data.containsKey('playerToken')) {
          debugPrint("[MCS] Detected server pairing (MCS)");
          _handlePairingNotification(data);
        }
      });
      
      // REFRESH REGISTRATIONS (CRITICAL FOR SAVED SERVERS)
      // Now that we have the valid customToken, we must tell Rust+ to send to it.
      debugPrint("[NotifyHandler] Refreshing server registrations with new token...");
      await FcmService().refreshServerRegistrations();

      
    } catch (e) {
      debugPrint("[MCS] ❌ MCS CLIENT FAILED: $e");
    }
  }

  static Future<void> initialize() async {
    debugPrint("[NotifyHandler] === INITIALIZING NOTIFICATION HANDLER ===");
    
    // Start MCS Client (Custom FCM)
    _startMcsClient();
    
    try {
      // 1. Initialize Local Notifications
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint("[NotifyHandler] Local Notification Clicked: ${details.payload}");
          // Handle navigation if needed
        },
      );
      
      // 2. Request Permission
      debugPrint("[NotifyHandler] Requesting notification permission...");
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint("[NotifyHandler] Permission status: ${settings.authorizationStatus}");

      // 3. Setup Handlers

      
      FirebaseMessaging.onMessage.listen((message) {
        debugPrint("[NotifyHandler] 🔔 FOREGROUND LISTENER TRIGGERED!");
        _handleMessage(message);
      });
      
      debugPrint("[NotifyHandler] === NOTIFICATION HANDLER INITIALIZED SUCCESSFULLY ===");
    } catch (e, stackTrace) {
      debugPrint("[NotifyHandler] ❌ ERROR INITIALIZING NOTIFICATION HANDLER: $e");
      debugPrint("Stack trace: $stackTrace");
      rethrow;
    }
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    debugPrint("[NotifyHandler] === FOREGROUND MESSAGE RECEIVED ===");
    debugPrint("[NotifyHandler] Data: ${message.data}");
    
    // Define data map at function scope level
    Map<String, dynamic> data = Map.from(message.data);
    
    // Logic to handle nested body JSON (Issue #75)
    if (data.containsKey('body') && !data.containsKey('ip') && !data.containsKey('entityId')) {
      try {
        final bodyJson = jsonDecode(data['body'] as String);
        if (bodyJson is Map<String, dynamic>) {
          data.addAll(bodyJson);
        }
      } catch (e) {}
    }
    
    // Logic to route based on data content
    // CRITICAL: Check for entityId FIRST, because entity pairing notifications ALSO contain ip/port.
    if (data.containsKey('entityId')) {
      if (data.containsKey('entityType')) {
         debugPrint("[NotifyHandler] Detected entity pairing notification");
         await _handleDevicePairing(data);
      } else {
         debugPrint("[NotifyHandler] Detected Smart Alarm Trigger (Foreground)");
         await _showAlarmNotification(message, data);
      }
    } else if (data.containsKey('ip') && data.containsKey('playerToken')) {
      debugPrint("[NotifyHandler] Detected server pairing notification");
      await _handlePairingNotification(data);
      
    } else {
      debugPrint("[NotifyHandler] Unknown notification type. Keys: ${data.keys}");
    }
  }
  
  static Future<void> _showAlarmNotification(RemoteMessage? message, Map<String, dynamic> data) async {
    final title = message?.notification?.title ?? "Smart Alarm";
    final body = message?.notification?.body ?? "Alarm triggered!";
    
    // Explicitly check for data if message is null (MCS case) or message.data is empty
    // But we pass 'data' map explicitly now for both cases
    
    const androidDetails = AndroidNotificationDetails(
      'rust_alarm_channel',
      'Smart Alarms',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.red,
      playSound: true,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      const NotificationDetails(android: androidDetails),
      payload: data['entityId'],
    );
  }
  
  static Future<void> _handleDevicePairing(Map<String, dynamic> data) async {
    try {
      final int entityId = int.parse(data['entityId']);
      final int entityType = int.parse(data['entityType']);
      
      // Trigger UI
      final context = appRouter.routerDelegate.navigatorKey.currentContext;
      if (context != null) {
         final dbService = DatabaseService();
         final isar = await dbService.db;
         // Try to find selected server or first server
         final server = await isar.serverInfos.filter().isSelectedEqualTo(true).findFirst() 
                        ?? await isar.serverInfos.where().findFirst(); // Using .findFirst because we know it works for ID 
                        
         if (server != null) {
           // DUPLICATE CHECK: Check if this device is already paired for this server
           final existing = await isar.smartDevices
               .filter()
               .serverIdEqualTo(server.id)
               .entityIdEqualTo(entityId)
               .findFirst();

           if (existing != null) {
             debugPrint("[NotifyHandler] Device ${existing.name} (ID: $entityId) is already paired. Skipping screen.");
             return; // Skip navigating to pairing screen
           }

           appRouter.go('/pair_device', extra: {
             'serverId': server.id,
             'entityId': entityId,
             'entityType': entityType,
           });
         } else {
           debugPrint("[NotifyHandler] No paired server found to attach device to.");
         }
      }
    } catch (e) {
      debugPrint("[NotifyHandler] Error handling device pairing: $e");
    }
  }
  
  static Future<void> _handlePairingNotification(Map<String, dynamic> data) async {
    try {
      final String ip = data['ip'];
      final String port = data['port'].toString();
      final String playerId = data['playerId'];
      final String playerToken = data['playerToken'];
      final String? name = data['name']; 
      
      final serverInfo = ServerInfo()
        ..ip = ip
        ..port = port
        ..playerId = playerId
        ..playerToken = playerToken
        ..name = name ?? "New Server ($ip)";

      final dbService = DatabaseService();
      final isar = await dbService.db;
      
      await isar.writeTxn(() async {
        final existing = await isar.serverInfos
            .filter()
            .ipEqualTo(ip)
            .portEqualTo(port)
            .findFirst();
            
        if (existing != null) {
          serverInfo.id = existing.id;
        }
        await isar.serverInfos.put(serverInfo);
      });
      
      debugPrint("[Pairing] Server Paired & Saved: $ip:$port");
      
    } catch (e) {
      debugPrint("[Pairing] Error parsing pairing notification: $e");
    }
  }

}
