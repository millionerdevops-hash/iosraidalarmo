import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/database_service.dart';
import '../services/notification_handler.dart';
import 'package:isar/isar.dart'; // Added
import '../../data/models/server_info.dart'; // Added
import '../../data/models/fcm_credential.dart';
import '../../services/onesignal_service.dart';

class FcmService {
  // Constants for Expo and Rust+
  static const String appId = 'com.facepunch.rust.companion';
  static const String projectId = '49451aca-a822-41e6-ad59-955718d0ff9c';

  // Rust+ Firebase Configuration (From Facepunch's public config)
  static const String _rustPlusApiKey = 'AIzaSyB5y2y-Tzqb4-I4Qnlsh_9naYv_TD8pCvY';
  static const String _rustPlusAppId = '1:976529667804:android:d6f1ddeb4403b338fea619';
  static const String _rustPlusMessagingSenderId = '976529667804';
  static const String _rustPlusProjectId = 'rust-companion-app';

  Future<String?> getFcmToken() async {
    try {
      // Check if we have Custom MCS Token (Spoofed)
      if (NotificationHandler.customToken != null) {

        return NotificationHandler.customToken;
      }
      
      // Fallback to native (won't work for Rust+ if wrong package name)
      final token = await FirebaseMessaging.instance.getToken();

      return token;
    } catch (e) {
      // Error getting FCM Token
      return null;
    }
  }

  /// Converts FCM Token to Expo Push Token
  Future<String?> getExpoPushToken(String fcmToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://exp.host/--/api/v2/push/getExpoPushToken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': 'fcm',
          'deviceId': const Uuid().v4(), // Generate a UUID
          'development': false,
          'appId': appId,
          'deviceToken': fcmToken,
          'projectId': projectId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['expoPushToken'] != null) {
          return data['data']['expoPushToken'];
        }
      }
      // Error getting Expo Token
    } catch (e) {
      // Exception getting Expo Token
    }
    return null;
  }

  /// Check if we have existing valid credentials
  Future<FcmCredential?> getExistingCredentials() async {
    try {
      final dbService = DatabaseService();
      final isar = await dbService.db;
      
      // Try to get credential with ID 1 (first one)
      final cred = await isar.fcmCredentials.get(1);
      
      if (cred != null && cred.expoPushToken != null) {
        // Found existing FCM credentials
        return cred;
      }
      

      return null;
    } catch (e) {
      // Error loading credentials
      return null;
    }
  }

  /// Registers the device with Rust Companion API
  Future<bool> registerWithRustPlus(String authToken, String expoPushToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://companion-rust.facepunch.com:443/api/push/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'AuthToken': authToken,
          'DeviceId': 'rustplus.js', // Or custom ID
          'PushKind': 3,
          'PushToken': expoPushToken,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      // Exception registering with Rust+
      return false;
    }
  }

  /// Refreshes registration for all saved servers using the current token
  Future<void> refreshServerRegistrations() async {

    
    // 1. Get Current Token (Prefer MCS)
    final fcmToken = await getFcmToken();
    if (fcmToken == null) {

      return;
    }

    // 2. Get Expo Token (Rust+ uses Expo)
    final expoToken = await getExpoPushToken(fcmToken);
    if (expoToken == null) {

      return;
    }
    


    // 3. Register with Rust+ using stored Facepunch Auth Token
    // We register the USER (steamToken), not per-server.
    try {
      final cred = await getExistingCredentials();
      if (cred == null || cred.steamToken == null) {

        return;
      }
      

      final success = await registerWithRustPlus(cred.steamToken!, expoToken);
      
      if (success) {
         // Device Registration Successful
      } else {
         // Device Registration Failed
      }
      
    } catch (e) {
      // Error refreshing registrations
    }
  }

  /// Synchronizes registration data with our Node.js server
  Future<bool> syncWithServer(FcmCredential cred) async {
    try {
      final String? onesignalId = OneSignalService.getPushId();
      
      final response = await http.post(
        Uri.parse('https://raidalarm-server.onrender.com/api/register'), // TODO: Dynamic URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'steam_id': cred.steamId,
          'steam_token': cred.steamToken,
          'android_id': cred.androidId.toString(),
          'security_token': cred.securityToken.toString(),
          'fcm_token': cred.fcmToken,
          'onesignal_id': onesignalId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("[ServerSync] ❌ Error: $e");
      return false;
    }
  }

  /// Synchronizes paired servers list with the Node.js server
  Future<void> syncServersToServer() async {
    try {
      final dbService = DatabaseService();
      final isar = await dbService.db;
      final cred = await getExistingCredentials();
      
      if (cred == null || cred.steamId == null) return;

      final servers = await isar.serverInfos.where().findAll();
      
      final serverList = servers.map((s) => {
        'ip': s.ip,
        'port': s.port,
        'player_id': s.playerId,
        'player_token': s.playerToken,
        'name': s.name,
      }).toList();

      await http.post(
        Uri.parse('https://raidalarm-server.onrender.com/api/sync-servers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'steam_id': cred.steamId,
          'servers': serverList,
        }),
      );
    } catch (e) {
      debugPrint("[ServerSync] ❌ Sync Servers Error: $e");
    }
  }
}
