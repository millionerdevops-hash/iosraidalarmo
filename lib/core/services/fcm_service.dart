import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/database_service.dart';
import 'package:isar/isar.dart';
import '../../data/models/fcm_credential.dart';
import '../../services/onesignal_service.dart';

class FcmService {
  // TODO: Move this to a config or .env
  static const String serverUrl = 'https://raidalarm-server.onrender.com';

  /// Check if we have existing valid credentials
  Future<FcmCredential?> getExistingCredentials() async {
    try {
      final dbService = DatabaseService();
      final isar = await dbService.db;
      final cred = await isar.fcmCredentials.get(1);
      return cred;
    } catch (e) {
      return null;
    }
  }

  /// Synchronizes registration data with our Node.js server
  Future<bool> syncWithServer(FcmCredential cred) async {
    try {
      final String? onesignalId = OneSignalService.getPushId();
      
      if (onesignalId == null || onesignalId.isEmpty) {
        debugPrint("[ServerSync] ⚠️ OneSignal ID not ready yet.");
      }

      final response = await http.post(
        Uri.parse('$serverUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'steam_id': cred.steamId,
          'steam_token': cred.steamToken,
          'onesignal_id': onesignalId,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("[ServerSync] ✅ Sync successful");
        return true;
      } else {
        debugPrint("[ServerSync] ❌ Sync failed: ${response.body}");
        return false;
      }
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
        Uri.parse('$serverUrl/api/sync-servers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'steam_id': cred.steamId,
          'servers': serverList,
        }),
      );
      debugPrint("[ServerSync] ✅ Servers synced to central server");
    } catch (e) {
      debugPrint("[ServerSync] ❌ Sync Servers Error: $e");
    }
  }
}
