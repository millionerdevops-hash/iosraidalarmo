import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/database_service.dart';
import '../dashboard/connection_provider.dart';
import '../../data/models/smart_device.dart';
import '../../core/proto/rustplus.pbenum.dart'; // Import for Enum

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

  Future<void> _pairDevice() async {
    final name = _nameController.text;
    if (name.isEmpty) return;

    final dbService = DatabaseService();
    final isar = await dbService.db;

    final device = SmartDevice()
      ..serverId = widget.serverId
      ..entityId = widget.entityId
      ..entityType = widget.entityType
      ..name = name;

    await isar.writeTxn(() async {
      await isar.smartDevices.put(device);
    });

    debugPrint("[DevicePairing] Paired Device: $name (ID: ${widget.entityId})");

    // Subscribe to the new device immediately
    try {
      final manager = await ref.read(connectionManagerProvider(widget.serverId).future);
      debugPrint("[DevicePairing] Subscribing to new device...");
      await manager.getEntityInfo(widget.entityId);
    } catch (e) {
      debugPrint("[DevicePairing] Failed to subscribe to new device (will retry on reconnect): $e");
    }

    if (mounted) {
      context.go('/'); // Return to dashboard/list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Paired $name successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("PAIR DEVICE"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               // Icon Placeholder (Image 1)
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent, // Transparent to show PNG shape
                child: _getImageForType(widget.entityType),
              ),
              const SizedBox(height: 16),
              
              // Title (Image 1)
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
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "DEVICE NAME",
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1E1E1E),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E1E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("CANCEL"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextButton(
                      onPressed: _pairDevice,
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF5A7E3E), // Rust Green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("PAIR DEVICE"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getImageForType(int typeVal) {
    // AppEntityType.valueOf(typeVal)
    final type = AppEntityType.valueOf(typeVal) ?? AppEntityType.Switch;
    String assetName = 'smart-switch.png';
    switch (type) {
      case AppEntityType.Switch: assetName = 'smart-switch.png'; break;
      case AppEntityType.Alarm: assetName = 'smart-alarm.png'; break;
      case AppEntityType.StorageMonitor: assetName = 'furnace-large.png'; break;
      default: assetName = 'smart-switch.png';
    }
    return Image.asset('assets/png/items/$assetName', width: 64, height: 64);
  }

  String _getTitleForType(int typeVal) {
     final type = AppEntityType.valueOf(typeVal) ?? AppEntityType.Switch;
     switch (type) {
       case AppEntityType.Switch: return "Smart Switch";
       case AppEntityType.Alarm: return "Smart Alarm";
       case AppEntityType.StorageMonitor: return "Storage Monitor";
       default: return "Smart Device";
     }
  }
}
