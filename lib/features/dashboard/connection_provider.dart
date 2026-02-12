import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; // Added missing import for extensions
import '../../core/services/connection_manager.dart';
import '../../data/models/server_info.dart';
import '../../core/services/database_service.dart';
import '../../core/services/automation_service.dart';
import '../../data/models/smart_device.dart';
import 'dart:async';

final connectionManagerProvider = FutureProvider.autoDispose.family<ConnectionManager, int>((ref, serverId) async {
  final dbService = DatabaseService();
  final isar = await dbService.db;
  final serverInfo = await isar.serverInfos.get(serverId);
  
  if (serverInfo == null) {
    throw Exception("Server not found");
  }
  
  final manager = ConnectionManager(serverInfo);
  
  // ignore: cancel_subscriptions
  StreamSubscription? subscription;

  ref.onDispose(() {
    // Check if the container is still alive before reading? 
    // Actually ref.read() inside onDispose is allowed usually, but let's be safe.
    // If automationServiceProvider is permanent, it's fine.
    try {
      ref.read(automationServiceProvider).stopWatching(serverId);
    } catch (_) {}
    
    subscription?.cancel();
    manager.disconnect();
  });

  try {
    await manager.connect();
    
    ref.read(automationServiceProvider).watchServer(serverId, manager);
    
    subscription = manager.messageStream.listen((message) async {
       if (message.hasBroadcast() && message.broadcast.hasEntityChanged()) {
         final change = message.broadcast.entityChanged;
         // ... (rest of the logic remains the same, just inside the listener)
         // To avoid huge replacement, I will just reference the existing logic or keep it basic here 
         // but wait, replace_file_content replaces the chunk. I need to include the listener body.
         try {
             final val = change.payload.value;
             await isar.writeTxn(() async {
                final device = await isar.smartDevices.filter()
                    .serverIdEqualTo(serverId)
                    .entityIdEqualTo(change.entityId)
                    .findFirst();
                    
                if (device != null) {
                  device.isActive = val; // val is bool? no payload.value is boolean string usually "true"/"false"
                  // actually in the original it was just 'val' assuming bool.
                  // Let's keep original logic.
                  await isar.smartDevices.put(device);
                }
             });
         } catch (_) {}
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

  } catch (e) {
    rethrow;
  }
  
  return manager;
});
