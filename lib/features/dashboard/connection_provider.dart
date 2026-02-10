import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; // Added missing import for extensions
import '../../core/services/connection_manager.dart';
import '../../data/models/server_info.dart';
import '../../core/services/database_service.dart';
import '../../core/services/automation_service.dart';
import '../../data/models/smart_device.dart';

final connectionManagerProvider = FutureProvider.autoDispose.family<ConnectionManager, int>((ref, serverId) async {
  final dbService = DatabaseService();
  final isar = await dbService.db;
  final serverInfo = await isar.serverInfos.get(serverId);
  
  if (serverInfo == null) {
    throw Exception("Server not found");
  }
  
  final manager = ConnectionManager(serverInfo);

  try {
    await manager.connect();
    
    ref.read(automationServiceProvider).watchServer(serverId, manager);
    
    final subscription = manager.messageStream.listen((message) async {
       if (message.hasBroadcast() && message.broadcast.hasEntityChanged()) {
         final change = message.broadcast.entityChanged;
         final val = change.payload.value; // Access payload.value
         
         await isar.writeTxn(() async {
            final device = await isar.smartDevices.filter()
                .serverIdEqualTo(serverId)
                .entityIdEqualTo(change.entityId)
                .findFirst();
                
            if (device != null) {
              device.isActive = val;
              await isar.smartDevices.put(device);
            }
         });
       }
    });
    
    final savedDevices = await isar.smartDevices.filter().serverIdEqualTo(serverId).findAll();
    for (var device in savedDevices) {
       manager.getEntityInfo(device.entityId).then((response) {
          if (response.hasResponse() && response.response.hasEntityInfo()) {
            final info = response.response.entityInfo;
            final val = info.payload.value; // Access payload.value
            isar.writeTxn(() async {
               device.isActive = val; // Assuming boolean for now, storage monitors need capacity logic later
               await isar.smartDevices.put(device);
            });
          }
       }).catchError((e) {
          // Failed to subscribe
       });
    }

    ref.onDispose(() {
      ref.read(automationServiceProvider).stopWatching(serverId);
      subscription.cancel();
      manager.disconnect();
    });

  } catch (e) {
    rethrow;
  }
  
  return manager;
});
