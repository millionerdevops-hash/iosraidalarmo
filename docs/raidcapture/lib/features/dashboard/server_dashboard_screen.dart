import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/proto/rustplus.pb.dart' hide Color;
import '../../core/services/connection_manager.dart';
import '../../core/services/database_service.dart';

import 'server_dashboard_view_model.dart';
import 'connection_provider.dart';
import '../../data/models/smart_device.dart';
import '../../config/rust_colors.dart';

class ServerDashboardScreen extends ConsumerWidget {
  final int serverId;
  final String serverName;

  const ServerDashboardScreen({
    super.key,
    required this.serverId,
    required this.serverName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(serverDashboardViewModelProvider(serverId));
    final managerAsync = ref.watch(connectionManagerProvider(serverId));
    
    return Scaffold(
      backgroundColor: RustColors.background,
      appBar: AppBar(
        title: Text(serverName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        backgroundColor: RustColors.surface,
        foregroundColor: RustColors.textPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(serverDashboardViewModelProvider(serverId)),
          ),
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            tooltip: "Automations",
            onPressed: () => context.push('/server/$serverId/automation'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: devicesAsync.when(
              data: (devices) {
                if (devices.isEmpty) {
                  return const Center(
                    child: Text("No devices paired.", style: TextStyle(color: RustColors.textMuted)),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: devices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return _buildDeviceCard(context, ref, device);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: RustColors.primary)),
              error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: RustColors.error))),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDeviceCard(BuildContext context, WidgetRef ref, SmartDevice device) {
    // Determine status color and text based on device type & state
    Color statusColor = RustColors.textMuted;
    String statusText = "OFF";
    bool isActive = device.isActive;

    if (isActive) {
      statusColor = RustColors.accent; // Orange-ish for ON
      statusText = "ON";
    }

    // Custom logic for different types
    if (device.type == AppEntityType.Alarm) {
       statusText = isActive ? "ALARMING" : "INACTIVE";
       statusColor = isActive ? RustColors.error : RustColors.textMuted;
    } else if (device.type == AppEntityType.StorageMonitor) {
       statusText = "TAP TO VIEW CONTENTS";
       statusColor = RustColors.info;
    }

    return GestureDetector(
      onTap: () {
        if (device.type == AppEntityType.StorageMonitor) {
          context.go('/server/$serverId/storage/$serverId/${device.entityId}', extra: {'name': device.name});
        }
      },
      onLongPress: () => _showDeleteConfirmation(context, ref, device),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RustColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: isActive ? Border(left: BorderSide(color: statusColor, width: 4)) : Border.all(color: RustColors.divider),
        ),
        child: Row(
        children: [
          // Icon
          Container(
             padding: const EdgeInsets.all(8),
             child: _getImageForType(device.type),
          ),
          const SizedBox(width: 16),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    device.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: RustColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Action (Switch)
          if (device.type == AppEntityType.Switch)
            Switch(
              value: isActive,
              activeTrackColor: RustColors.primaryDark,
              activeColor: RustColors.primary,
              onChanged: (val) async {
                 // Send Command
                 final managerAsync = ref.read(connectionManagerProvider(serverId));
                 if (managerAsync.hasValue) {
                   try {
                     await managerAsync.value!.setEntityValue(device.entityId, val);
                     // Optimistic update or wait for stream?
                     // Rust+ sends an EntityChanged broadcast back.
                     // For now, we rely on the broadcast handler to update the DB, which updates the UI.
                     debugPrint("[Dashboard] Sent setEntityValue(${device.entityId}, $val)");
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${device.name} ${val ? 'ON' : 'OFF'}")));
                   } catch (e) {
                     debugPrint("[Dashboard] Error sending command: $e");
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
                   }
                 }
              },
            ),
          if (device.type == AppEntityType.StorageMonitor)
            const Icon(Icons.chevron_right, color: RustColors.textMuted, size: 20),
        ],
      ),
    ),
  );
}

  Widget _getImageForType(AppEntityType type) {
    String assetName = 'smart-switch.png';
    switch (type) {
      case AppEntityType.Switch: assetName = 'smart-switch.png'; break;
      case AppEntityType.Alarm: assetName = 'smart-alarm.png'; break;
      case AppEntityType.StorageMonitor: assetName = 'furnace-large.png'; break; // Placeholder for storage
      default: assetName = 'smart-switch.png';
    }
    return Image.asset('assets/png/items/$assetName', width: 48, height: 48);
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, SmartDevice device) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RustColors.surface,
        title: const Text("Delete Device", style: TextStyle(color: RustColors.textPrimary)),
        content: Text("Are you sure you want to delete '${device.name}'?", style: const TextStyle(color: RustColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL", style: TextStyle(color: RustColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final dbService = DatabaseService();
              final isar = await dbService.db;
              await isar.writeTxn(() async {
                await isar.smartDevices.delete(device.id);
              });
              debugPrint("[Dashboard] Deleted device: ${device.name}");
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Deleted ${device.name}"), backgroundColor: RustColors.surface),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: RustColors.error),
            child: const Text("DELETE"),
          ),
        ],
      ),
    );
  }
}
