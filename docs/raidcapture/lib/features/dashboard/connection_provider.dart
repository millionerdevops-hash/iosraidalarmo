import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; // Added missing import for extensions
import '../../core/services/connection_manager.dart';
import '../../data/models/server_info.dart';
import '../../core/services/database_service.dart';
import '../../core/services/automation_service.dart';
import '../../data/models/smart_device.dart';

// Provides a ConnectionManager for a specific Server ID
final connectionManagerProvider = FutureProvider.family<ConnectionManager, int>((ref, serverId) async {
  final dbService = DatabaseService();
  final isar = await dbService.db;
  final serverInfo = await isar.serverInfos.get(serverId);
  
  if (serverInfo == null) {
    throw Exception("Server not found");
  }

  // Determine if we need to clean up old connections?
  // ideally we keep one active connection globally or per screen.
  // For simplicity, we create a new manager which connects on demand.
  // In a real app, this should be a singleton or stateful notifier per server.
  
  final manager = ConnectionManager(serverInfo);
  debugPrint("[ConnectionProvider] Created ConnectionManager for ${serverInfo.name} (${serverInfo.ip})");

  // CONNECT & SUBSCRIBE LOGIC
  try {
    await manager.connect();
    
    // 0. Start Automation Watcher
    ref.read(automationServiceProvider).watchServer(serverId, manager);
    
    // 1. Subscribe to Broadcasts (Store in DB -> UI Updates via Isar Watcher)
    final subscription = manager.messageStream.listen((message) async {
       if (message.hasBroadcast() && message.broadcast.hasEntityChanged()) {
         final change = message.broadcast.entityChanged;
         final val = change.payload.value; // Access payload.value
         debugPrint("[ConnectionProvider] Entity Changed Broadcast: ID ${change.entityId}, Value: $val");
         
         await isar.writeTxn(() async {
            final device = await isar.smartDevices.filter()
                .serverIdEqualTo(serverId)
                .entityIdEqualTo(change.entityId)
                .findFirst();
                
            if (device != null) {
              device.isActive = val;
              await isar.smartDevices.put(device);
              debugPrint("[ConnectionProvider] Updated Device ${device.name} -> $val");
            }
         });
       }
    });
    
    // 2. Refresh/Subscribe Key for all saved devices
    final savedDevices = await isar.smartDevices.filter().serverIdEqualTo(serverId).findAll();
    for (var device in savedDevices) {
       debugPrint("[ConnectionProvider] Subscribing to device: ${device.name} (${device.entityId})");
       // Fire and forget, or wait? Better to just send.
       manager.getEntityInfo(device.entityId).then((response) {
         // Optionally update initial state from response
          if (response.hasResponse() && response.response.hasEntityInfo()) {
            final info = response.response.entityInfo;
            final val = info.payload.value; // Access payload.value
            isar.writeTxn(() async {
               device.isActive = val; // Assuming boolean for now, storage monitors need capacity logic later
               await isar.smartDevices.put(device);
               debugPrint("[ConnectionProvider] Initial State for ${device.name} -> $val");
            });
          }
       }).catchError((e) {
          debugPrint("[ConnectionProvider] Failed to subscribe to ${device.name}: $e");
       });
    }

    ref.onDispose(() {
      debugPrint("[ConnectionProvider] Disposing ConnectionManager for ${serverInfo.name}");
      subscription.cancel();
      manager.disconnect();
    });

  } catch (e) {
    debugPrint("[ConnectionProvider] Failed to connect: $e");
    // We still return the manager even if connection fails, user can retry via UI controls if we had them
    // But throwing here makes the provider state 'error', which shows the error UI.
    rethrow;
  }
  
  return manager;
});
