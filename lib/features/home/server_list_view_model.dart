import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import '../../core/services/database_service.dart';
import '../../data/models/server_info.dart';
import '../../data/models/steam_credential.dart';
import '../../core/services/api_service.dart';
import '../../data/models/smart_device.dart';
part 'server_list_view_model.g.dart';

@riverpod
class ServerListViewModel extends _$ServerListViewModel {
  @override
  Stream<List<ServerInfo>> build() async* {
    final dbService = DatabaseService();
    final isar = await dbService.db;
    yield* isar.collection<ServerInfo>().where().watch(fireImmediately: true);
  }
  
  Future<void> scanForServers() async {
    final dbService = DatabaseService();
    final isar = await dbService.db;
    
    // Get Steam ID from local database
    final cred = await isar.steamCredentials.get(1);
    if (cred == null || cred.steamId == null) return;
    
    // Fetch from backend
    final servers = await ApiService.fetchPairedServers(cred.steamId!);

    if (servers.isNotEmpty) {
      await isar.writeTxn(() async {
        for (final s in servers) {
          final existing = await isar.collection<ServerInfo>()
              .filter()
              .ipEqualTo(s['ip'])
              .portEqualTo(s['port'].toString())
              .findFirst();

          if (existing == null) {
            final newServer = ServerInfo()
              ..ip = s['ip']
              ..port = s['port'].toString()
              ..playerId = s['player_id'].toString()
              ..playerToken = s['player_token'].toString()
              ..name = s['name'] ?? '${s['ip']}:${s['port']}';
            await isar.collection<ServerInfo>().put(newServer);
          } else {
             // Update if token changed
             existing.playerToken = s['player_token'].toString();
             existing.name = s['name'] ?? existing.name;
             await isar.collection<ServerInfo>().put(existing);
          }
        }
      });
      
      // NEW: Also restore paired devices for these servers to ensure full sync
      try {
        final devices = await ApiService.fetchPairedDevices(cred.steamId!);
        if (devices.isNotEmpty) {
          final serverList = await isar.collection<ServerInfo>().where().findAll();
          final serverMap = {for (var s in serverList) "${s.ip}:${s.port}": s.id};
          
          await isar.writeTxn(() async {
            for (final d in devices) {
              final key = "${d['server_ip']}:${d['server_port']}";
              final sId = serverMap[key];
              if (sId != null) {
                // Check if device already in Isar
                final exists = await isar.collection<SmartDevice>()
                    .filter()
                    .serverIdEqualTo(sId)
                    .entityIdEqualTo(d['entity_id'] as int)
                    .findFirst();
                
                if (exists == null) {
                  final newDevice = SmartDevice()
                    ..serverId = sId
                    ..entityId = d['entity_id'] as int
                    ..entityType = d['entity_type'] as int
                    ..name = d['name'] ?? "Smart Device"
                    ..isActive = d['is_active'] == true;
                  await isar.collection<SmartDevice>().put(newDevice);
                }
              }
            }
          });
          debugPrint("[ServerList] ✅ Restored ${devices.length} devices from backend");
        }
      } catch (e) {
        debugPrint("[ServerList] ⚠️ Device restoration failed: $e");
      }
    }
  }

  Future<void> deleteServer(int serverId) async {
    final dbService = DatabaseService();
    final isar = await dbService.db;
    
    // Get SteamID before transaction (needed for sync)
    final cred = await isar.steamCredentials.get(1);
    final steamId = cred?.steamId;

    await isar.writeTxn(() async {
      // Cascade delete: Remove all devices linked to this server
      await isar.collection<SmartDevice>().filter().serverIdEqualTo(serverId).deleteAll();
      
      // Finally delete the server itself
      await isar.collection<ServerInfo>().delete(serverId);
    });

    // Valid sync request to remove from backend
    if (steamId != null) {
      await ApiService.syncServersToServer(steamId);
      await ApiService.syncDevicesToServer(steamId); // Sync device deletions too
    }
  }
}
