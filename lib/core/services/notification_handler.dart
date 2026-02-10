import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/models/server_info.dart';
import '../services/database_service.dart';
import '../../core/router/app_router.dart';
import 'package:isar/isar.dart';
import '../../data/models/fcm_credential.dart';
import '../../data/models/smart_device.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/mcs/gcm_service.dart';
import '../services/mcs/mcs_client.dart';
import 'fcm_service.dart'; // Added missing import
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../features/devices/device_pairing_screen.dart';



class NotificationHandler {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static McsClient? _mcsClient;
  static String? customToken; // Exposed for FcmService

  static Future<void> _startMcsClient() async {
    try {

      
      // 1. Check for existing MCS credentials
      final dbService = DatabaseService();
      final isar = await dbService.db;
      final existingCred = await isar.fcmCredentials.get(1);
      
      int androidId;
      int securityToken;
      String token;

      if (existingCred != null && existingCred.androidId != null && existingCred.securityToken != null) {

        androidId = existingCred.androidId!;
        securityToken = existingCred.securityToken!;
        token = existingCred.fcmToken; // Assuming this is still valid
        

      } else {

         final gcm = GcmService();
         
         // 1. Check-in (Get Android ID)
         final checkinData = await gcm.checkIn();
         androidId = checkinData['androidId'];
         securityToken = checkinData['securityToken'];
         
         // 2. Register (Get Token)
         token = await gcm.register(androidId, securityToken);

         
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

             _handleDevicePairing(data);
          } else {

             _showAlarmNotification(null, data); 
          }
        } else if (data.containsKey('ip') && data.containsKey('playerToken')) {

          _handlePairingNotification(data);
        }
      });
      
      // REFRESH REGISTRATIONS (CRITICAL FOR SAVED SERVERS)
      // Now that we have the valid customToken, we must tell Rust+ to send to it.

      await FcmService().refreshServerRegistrations();

      
    } catch (e) {
      // MCS Client Failed
    }
  }

  static Future<void> initialize() async {

    
    // Start MCS Client (Custom FCM)
    _startMcsClient();
    
    try {
      // 1. Initialize Local Notifications
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {

          // Handle navigation if needed
        },
      );
      
      // 2. Request Permission

      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );


      // 3. Setup Handlers

      
      FirebaseMessaging.onMessage.listen((message) {

        _handleMessage(message);
      });
      

    } catch (e, stackTrace) {
      // Error initializing notification handler

      rethrow;
    }
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    Map<String, dynamic> data = Map.from(message.data);
    
    if (data.containsKey('body') && !data.containsKey('ip') && !data.containsKey('entityId')) {
      try {
        final bodyJson = jsonDecode(data['body'] as String);
        if (bodyJson is Map<String, dynamic>) {
          data.addAll(bodyJson);
        }
      } catch (e) {}
    }
    
    if (data.containsKey('entityId')) {
      if (data.containsKey('entityType')) {

         await _handleDevicePairing(data);
      } else {

         await _showAlarmNotification(message, data);
      }
    } else if (data.containsKey('ip') && data.containsKey('playerToken')) {

      await _handlePairingNotification(data);
      
    } else {

    }
  }
  
  static Future<void> _showAlarmNotification(RemoteMessage? message, Map<String, dynamic> data) async {
    final title = message?.notification?.title ?? "Smart Alarm";
    final body = message?.notification?.body ?? "Alarm triggered!";
        
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
      
      final context = AppRouter.router.routerDelegate.navigatorKey.currentContext;
      if (context != null) {
         final dbService = DatabaseService();
         final isar = await dbService.db;
         final server = await isar.serverInfos.filter().isSelectedEqualTo(true).findFirst() 
                        ?? await isar.serverInfos.where().findFirst(); // Using .findFirst because we know it works for ID 
                        
         if (server != null) {
           final existing = await isar.smartDevices
               .filter()
               .serverIdEqualTo(server.id)
               .entityIdEqualTo(entityId)
               .findFirst();

           if (existing != null) {

             return; // Skip navigating to pairing screen
           }

           // Use modal_bottom_sheet to show the pairing screen
           showMaterialModalBottomSheet(
             context: context,
             backgroundColor: Colors.transparent,
             builder: (context) => DevicePairingScreen(
               serverId: server.id,
               entityId: entityId,
               entityType: entityType,
               initialName: data['name'], // Pass name if available (e.g. from smart switch notification body if parsed)
             ),
           );
         } else {

         }
      }
    } catch (e) {
      // Error handling device pairing
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
      
    } catch (e) {
      // Error parsing pairing notification
    }
  }

}
