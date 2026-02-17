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
    yield* isar.serverInfos.where().watch(fireImmediately: true);
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
          final existing = await isar.serverInfos
              .filter()
              .ipEqualTo(s['ip'])
              .portEqualTo(s['port'])
              .findFirst();

          if (existing == null) {
            final newServer = ServerInfo()
              ..ip = s['ip']
              ..port = s['port'].toString()
              ..playerId = s['player_id']
              ..playerToken = s['player_token']
              ..name = s['name'] ?? '${s['ip']}:${s['port']}';
            await isar.serverInfos.put(newServer);
          } else {
             // Update if token changed
             existing.playerToken = s['player_token'];
             existing.name = s['name'] ?? existing.name;
             await isar.serverInfos.put(existing);
          }
        }
      });
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
      await isar.smartDevices.filter().serverIdEqualTo(serverId).deleteAll();
      
      // Finally delete the server itself
      await isar.serverInfos.delete(serverId);
    });

    // Valid sync request to remove from backend
    if (steamId != null) {
      await ApiService.syncServersToServer(steamId);
      await ApiService.syncDevicesToServer(steamId); // Sync device deletions too
    }
  }
}
