import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/fcm_credential.dart';
import '../../data/models/server_info.dart';
import '../../data/models/smart_device.dart';
import '../services/database_service.dart';
import 'package:isar/isar.dart';

class RustApiService {
  static const String baseUrl = 'https://companion-rust.facepunch.com:443/api';
  
  Future<void> checkHistoryForPairing(String authToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/history/read'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'AuthToken': authToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('messages')) {
          final messages = data['messages'] as List;
          // Process form newest to oldest usually, but we want to catch all
          for (var msg in messages) {
             // msg structure matches the push payload 'data' + 'title' + 'body'
             /*
               Example msg:
               {
                 "id": "...",
                 "type": "server", // or "entity"
                 "title": "...",
                 "body": "...",
                 "data": {
                    "ip": "...", "port": "...", "playerToken": "..."
                 }
               }
             */
             if (msg['type'] == 'server') {
               await _saveServer(msg['data']);
             } else if (msg['type'] == 'entity') {
               await _saveEntity(msg['data']);
             }
          }
        }
      } else {
        // History API Error
      }
    } catch (e) {
      // Error fetching history
    }
  }

  Future<void> _saveServer(Map<String, dynamic> data) async {
    try {
      final String ip = data['ip'];
      final String port = data['port'].toString();
      final String playerId = data['playerId'];
      final String playerToken = data['playerToken'];
      final String? name = data['name']; // Sometimes 'title' in msg has name

      final dbService = DatabaseService();
      final isar = await dbService.db;

      await isar.writeTxn(() async {
        final existing = await isar.serverInfos
            .filter()
            .ipEqualTo(ip)
            .portEqualTo(port)
            .findFirst();

        final serverInfo = existing ?? ServerInfo();
        serverInfo
          ..ip = ip
          ..port = port
          ..playerId = playerId
          ..playerToken = playerToken
          ..name = name ?? "New Server ($ip)";

        await isar.serverInfos.put(serverInfo);
      });

    } catch (e) {
      // Error saving server from history
    }
  }

  Future<void> _saveEntity(Map<String, dynamic> data) async {
     try {
       final int entityId = int.parse(data['entityId']);
       final int entityType = int.parse(data['entityType']);
       final String? name = data['entityName'] ?? data['name']; // Checking both
       
       // Need to find which server this belongs to?
       // The 'entity' message might NOT contain server IP if it assumes context.
       // Does history 'entity' message contain server info? 
       // API.md says Data contains: ip, port, ... entityId, entityType.
       // So YES, it should contain server info too.
       
       final String? ip = data['ip'];
       final String? port = data['port']?.toString();
       
       if (ip == null || port == null) return;

       final dbService = DatabaseService();
       final isar = await dbService.db;
       
       // Find server
       final server = await isar.serverInfos
          .filter()
          .ipEqualTo(ip)
          .portEqualTo(port)
          .findFirst();
          
       if (server == null) {
         // Should we create it? Maybe. For now skip.
         return;
       }
       
       await isar.writeTxn(() async {
          // Check duplicate
          final existing = await isar.smartDevices
            .filter()
            .serverIdEqualTo(server.id)
            .entityIdEqualTo(entityId)
            .findFirst();
            
          final device = existing ?? SmartDevice();
          device
            ..serverId = server.id
            ..entityId = entityId
            ..entityType = entityType
            ..name = name ?? "Unknown Device";
            
            await isar.smartDevices.put(device);
       });


     } catch(e) {
        // Error saving entity from history
     }
  }
}
