import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/database_service.dart';
import '../dashboard/connection_provider.dart';
import '../../data/models/smart_device.dart';
import '../../core/proto/rustplus.pbenum.dart'; // Import for Enum
import '../../core/theme/rust_colors.dart';

class DevicePairingScreen extends ConsumerStatefulWidget {
  final int serverId;
  final int entityId;
  final int entityType;
  final String? initialName;

  const DevicePairingScreen({
    super.key,
    required this.serverId,
    required this.entityId,
    required this.entityType,
    this.initialName,
  });

  @override
  ConsumerState<DevicePairingScreen> createState() => _DevicePairingScreenState();
}

class _DevicePairingScreenState extends ConsumerState<DevicePairingScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? "Smart Device");
  }

  bool _isPairing = false;

  Future<void> _connectDevice() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a device name"),
          backgroundColor: RustColors.error,
        ),
      );
      return;
    }

    if (_isPairing) return;

    setState(() {
      _isPairing = true;
    });

    try {
      final dbService = DatabaseService();
      final isar = await dbService.db;

      // Check for duplicate device (same server + entityId) to be safe
      final existing = await isar.smartDevices
          .filter()
          .serverIdEqualTo(widget.serverId)
          .entityIdEqualTo(widget.entityId)
          .findFirst();

      if (existing != null) {
        // Already exists, just update name? or stop?
        // User asked to prevent bugs. Saving duplicate is bad.
        // If it exists, let's just update it.
        await isar.writeTxn(() async {
           existing.name = name;
           await isar.smartDevices.put(existing);
        });
      } else {
        final device = SmartDevice()
          ..serverId = widget.serverId
          ..entityId = widget.entityId
          ..entityType = widget.entityType
          ..name = name;

        await isar.writeTxn(() async {
          await isar.smartDevices.put(device);
        });
      }

      String? connectionError;
      try {
        final manager = await ref.read(connectionManagerProvider(widget.serverId).future);
        await manager.getEntityInfo(widget.entityId);
      } catch (e) {
        connectionError = e.toString();
      }

      if (mounted) {
        context.pop(); // Close bottom sheet
        if (connectionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Device saved, but connection failed: $connectionError"),
              backgroundColor: RustColors.warning,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Connected $name successfully!"),
              backgroundColor: RustColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving device: $e"),
            backgroundColor: RustColors.error,
          ),
        );
        setState(() {
          _isPairing = false; // Re-enable if we didn't pop
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 16,
                offset: Offset(0, 8),
              )
            ],
          ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             // Icon Placeholder
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent, // Transparent to show PNG shape
              child: _getImageForType(widget.entityType),
            ),
            const SizedBox(height: 16),
             
            // Title
            Text(
              _getTitleForType(widget.entityType),
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 24, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Lets you control your electrical contraptions from anywhere.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
             
            // Name Input
            TextField(
              controller: _nameController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "DEVICE NAME",
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _isPairing ? null : _connectDevice(),
            ),
            const SizedBox(height: 24),
  
            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isPairing ? null : () => context.pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E1E),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF1E1E1E).withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("CANCEL"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: _isPairing ? null : _connectDevice,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF5A7E3E), // Rust Green
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF5A7E3E).withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isPairing 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                        )
                      : const Text("CONNECT DEVICE"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Widget _getImageForType(int typeVal) {
    // AppEntityType.valueOf(typeVal)
    final type = AppEntityType.valueOf(typeVal) ?? AppEntityType.Switch;
    String assetName = 'smart-switch.png';
    switch (type) {
      case AppEntityType.Switch: assetName = 'smart-switch.png'; break;
      case AppEntityType.Alarm: assetName = 'smart-alarm.png'; break;
      default: assetName = 'smart-switch.png';
    }
    return Image.asset('assets/png/ingame/pairing/$assetName', width: 64, height: 64);
  }

  String _getTitleForType(int typeVal) {
     final type = AppEntityType.valueOf(typeVal) ?? AppEntityType.Switch;
     switch (type) {
       case AppEntityType.Switch: return "Smart Switch";
       case AppEntityType.Alarm: return "Smart Alarm";
       default: return "Smart Device";
     }
  }
}
