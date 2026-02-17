import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import '../../core/services/database_service.dart';
import '../../data/models/smart_device.dart';
part 'server_dashboard_view_model.g.dart';

@riverpod
class ServerDashboardViewModel extends _$ServerDashboardViewModel {
  @override
  Stream<List<SmartDevice>> build(int serverId) async* {
    final dbService = DatabaseService();
    final isar = await dbService.db;
    final stream = isar.collection<SmartDevice>()
        .filter()
        .serverIdEqualTo(serverId)
        .watch(fireImmediately: true);
        
    yield* stream;
  }
}
