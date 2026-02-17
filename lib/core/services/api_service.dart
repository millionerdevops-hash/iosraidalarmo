import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../data/models/server_info.dart';
import 'database_service.dart';
import 'package:isar/isar.dart';
import '../../services/onesignal_service.dart';

class ApiService {
  static const String baseUrl = 'https://raidalarmioscuk.onrender.com';

  /// Wake up Render backend (free tier spins down)
  static Future<void> wakeUpBackend() async {
    try {
      debugPrint("[ApiService] ⏰ Waking up backend...");
      final response = await http.get(Uri.parse('$baseUrl/api/status'));
      debugPrint("[ApiService] ⏰ Backend Status: ${response.statusCode}");
    } catch (e) {
      debugPrint("[ApiService] ⚠️ Wake up failed (might be offline): $e");
    }
  }

  /// Register user with server (Steam login)
  static Future<void> registerUser({
    required String steamId,
    required String steamToken,
    String? iosVoipToken,
  }) async {
    try {
      final String? onesignalId = OneSignalService.getPushId();

      if (onesignalId == null || onesignalId.isEmpty) {
        debugPrint("[ApiService] ⚠️ OneSignal ID not ready yet.");
      }

      final body = {
        'steam_id': steamId,
        'steam_token': steamToken,
        'onesignal_id': onesignalId,
        'platform': defaultTargetPlatform.name.toLowerCase(),
      };

      // Add iOS VoIP token if provided
      if (iosVoipToken != null && iosVoipToken.isNotEmpty) {
        body['ios_voip_token'] = iosVoipToken;
        debugPrint("[ApiService] 📱 Sending iOS VoIP token to server");
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint("[ApiService] ✅ Registration successful");
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMsg = errorData['error'] ?? 'Unknown server error';
        
        // Handle "User already has an active client" or similar non-critical errors
        if (errorMsg.contains("already has an active client") || 
            response.statusCode == 409) {
           debugPrint("[ApiService] ℹ️ User already active, treating as success.");
           return;
        }

        debugPrint("[ApiService] ❌ Registration failed: $errorMsg");
        throw errorMsg;
      }
    } catch (e) {
      debugPrint("[ApiService] ❌ Error: $e");
      rethrow;
    }
  }

  /// Sync servers to backend
  static Future<void> syncServersToServer(String steamId) async {
    try {
      final dbService = DatabaseService();
      final isar = await dbService.db;

      final servers = await isar.collection<ServerInfo>().where().findAll();

      final serverList = servers.map((s) => {
        'ip': s.ip,
        'port': s.port,
        'player_id': s.playerId,
        'player_token': s.playerToken,
        'name': s.name,
      }).toList();

      await http.post(
        Uri.parse('$baseUrl/api/sync-servers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'steam_id': steamId,
          'servers': serverList,
        }),
      );
      debugPrint("[ApiService] ✅ Servers synced to central server");
    } catch (e) {
      debugPrint("[ApiService] ❌ Sync Servers Error: $e");
    }
  }

  /// Fetch paired servers from backend
  static Future<List<Map<String, dynamic>>> fetchPairedServers(String steamId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/servers?steam_id=$steamId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['servers'] != null) {
          return List<Map<String, dynamic>>.from(data['servers']);
        }
      }
      return [];
    } catch (e) {
      debugPrint("[ApiService] ❌ Fetch Servers Error: $e");
      return [];
    }
  }
}
