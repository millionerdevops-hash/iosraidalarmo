import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/proto/rustplus.pb.dart' hide Color;
import '../dashboard/connection_provider.dart';
import '../../config/rust_colors.dart';
import 'dart:async';

class StorageMonitorScreen extends ConsumerStatefulWidget {
  final int serverId;
  final int entityId;
  final String deviceName;

  const StorageMonitorScreen({
    super.key,
    required this.serverId,
    required this.entityId,
    required this.deviceName,
  });

  @override
  ConsumerState<StorageMonitorScreen> createState() => _StorageMonitorScreenState();
}

class _StorageMonitorScreenState extends ConsumerState<StorageMonitorScreen> {
  AppEntityPayload? _payload;
  bool _isLoading = true;
  String? _error;
  Timer? _refreshTimer;

  // Common Rust Item IDs
  static const Map<int, String> _itemNames = {
    365214566: "Wood",
    -1581843485: "Stones",
    695268133: "Metal Fragments",
    317398316: "High Quality Metal",
    -1938052175: "Gun Powder",
    -1542304198: "Explosives",
    -4031221: "Metal Ore",
    605467368: "Sulfur Ore",
    -1157596551: "Sulfur",
    -1518384930: "Low Grade Fuel",
    -1211618504: "Charcoal",
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Refresh every 30 seconds for live monitoring
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final manager = await ref.read(connectionManagerProvider(widget.serverId).future);
      final response = await manager.getEntityInfo(widget.entityId);
      
      if (response.hasResponse() && response.response.hasEntityInfo()) {
        setState(() {
          _payload = response.response.entityInfo.payload;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      debugPrint("[StorageMonitor] Failed to fetch storage info: $e");
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  String _formatDecayTime(int expiry) {
    if (expiry == 0) return "NO PROTECTION";
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final remaining = expiry - now;
    if (remaining <= 0) return "DECAYING!";
    
    final days = remaining ~/ 86400;
    final hours = (remaining % 86400) ~/ 3600;
    final minutes = (remaining % 3600) ~/ 60;
    
    if (days > 0) {
      return "${days}d ${hours}h ${minutes}m";
    }
    return "${hours}h ${minutes}m";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RustColors.background,
      appBar: AppBar(
        title: Text(widget.deviceName.toUpperCase()),
        backgroundColor: RustColors.surface,
        foregroundColor: RustColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchData();
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _payload == null) {
      return const Center(child: CircularProgressIndicator(color: RustColors.primary));
    }

    if (_error != null && _payload == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchData,
              style: ElevatedButton.styleFrom(backgroundColor: RustColors.primary),
              child: const Text("RETRY", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      );
    }

    if (_payload == null) return const Center(child: Text("No Data", style: TextStyle(color: RustColors.textSecondary)));

    final hasDecay = _payload!.hasProtectionExpiry();
    final expiry = _payload!.protectionExpiry;
    final items = _payload!.items;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decay Info Card
          if (hasDecay)
            _buildDecayCard(expiry),
          
          const SizedBox(height: 24),
          
          // Capacity Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "CONTENTS",
                style: TextStyle(color: RustColors.textMuted, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              if (_payload!.hasCapacity())
                Text(
                  "CAPACITY: ${_payload!.capacity} SLOTS",
                  style: const TextStyle(color: RustColors.textMuted, fontSize: 12),
                ),
            ],
          ),
          const Divider(color: RustColors.divider),
          
          // Items Grid
          if (items.isEmpty)
             const Padding(
               padding: EdgeInsets.symmetric(vertical: 40),
               child: Center(child: Text("Empty", style: TextStyle(color: Colors.grey))),
             )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final name = _itemNames[item.itemId] ?? "Unknown Item (${item.itemId})";
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: RustColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: RustColors.divider),
                  ),
                  child: Row(
                    children: [
                      _getItemIcon(name),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(color: RustColors.textPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "x${item.quantity}",
                        style: const TextStyle(color: RustColors.accent, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDecayCard(int expiry) {
    final decayTime = _formatDecayTime(expiry);
    final isCritical = expiry != 0 && (expiry - DateTime.now().millisecondsSinceEpoch ~/ 1000) < 3600 * 2; // Less than 2 hours

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCritical ? RustColors.error.withOpacity(0.1) : RustColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCritical ? RustColors.error : RustColors.divider),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield,
                color: isCritical ? RustColors.error : RustColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "DECAY TIMER",
                style: TextStyle(color: RustColors.textMuted, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            decayTime,
            style: TextStyle(
              color: isCritical ? RustColors.error : RustColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "CRITICAL! REFILL TC NOW",
                style: TextStyle(color: RustColors.error, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _getItemIcon(String name) {
    // We could use icons if we have them, for now a color dot
    Color dotColor = Colors.grey;
    if (name.contains("Wood")) dotColor = const Color(0xFF795548);
    if (name.contains("Stones")) dotColor = const Color(0xFF9E9E9E);
    if (name.contains("Metal")) dotColor = const Color(0xFF607D8B);
    if (name.contains("High Quality")) dotColor = const Color(0xFFFFC107);
    if (name.contains("Sulfur")) dotColor = const Color(0xFFFFF176);
    if (name.contains("Gun Powder")) dotColor = const Color(0xFF455A64);

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
    );
  }
}
