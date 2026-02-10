import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import '../../core/services/database_service.dart';
import '../../data/models/server_info.dart';
import '../../data/models/fcm_credential.dart';
import '../../core/services/rust_api_service.dart';

import '../../data/models/smart_device.dart';
import '../../data/models/automation_rule.dart';

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
    final cred = await isar.fcmCredentials.where().findFirst();
    
    if (cred != null && cred.steamToken != null) {
      final api = RustApiService();
      await api.checkHistoryForPairing(cred.steamToken!);
    } 
  }

  Future<void> deleteServer(int serverId) async {
    final dbService = DatabaseService();
    final isar = await dbService.db;
    await isar.writeTxn(() async {
      // Cascade delete: Remove all devices and automations linked to this server
      await isar.smartDevices.filter().serverIdEqualTo(serverId).deleteAll();
      await isar.automationRules.filter().serverIdEqualTo(serverId).deleteAll();
      
      // Finally delete the server itself
      await isar.serverInfos.delete(serverId);
    });
  }
}
