import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import '../../core/services/database_service.dart';
import '../../data/models/server_info.dart';
import '../../data/models/fcm_credential.dart';
import '../../core/services/rust_api_service.dart';

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
      debugPrint("[ServerList] Scanning for servers via Rust+ API...");
      await api.checkHistoryForPairing(cred.steamToken!);
      // Stream will auto-update
    } else {
      debugPrint("[ServerList] Cannot scan: No credentials found. Please login first.");
    }
  }
}
