import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import '../../data/models/automation_rule.dart';
import '../../data/models/smart_device.dart';
import '../../core/services/database_service.dart';
import '../../core/theme/rust_colors.dart';

class AutomationListScreen extends ConsumerWidget {
  final int serverId;

  const AutomationListScreen({super.key, required this.serverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbService = DatabaseService();

    return Scaffold(
      backgroundColor: RustColors.background,
      appBar: AppBar(
        title: const Text("AUTOMATIONS"),
        backgroundColor: RustColors.surface,
        foregroundColor: RustColors.textPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => context.push('/server/$serverId/automation/info'),
          ),
        ],
      ),
      body: StreamBuilder<List<AutomationRule>>(
        stream: _watchRules(dbService),
        builder: (context, ruleSnapshot) {
          if (!ruleSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: RustColors.primary));
          }

          final rules = ruleSnapshot.data!;
          if (rules.isEmpty) return _buildEmptyState(context);

          // Watch device names continuously
          return StreamBuilder<Map<int, String>>(
            stream: _watchDeviceNames(dbService),
            initialData: const {},
            builder: (context, nameSnapshot) {
               // If loading, we can still show IDs or just wait. 
               // initialData handles the "waiting" by giving empty map.
               final nameMap = nameSnapshot.data ?? {};
               
               return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rules.length,
                itemBuilder: (context, index) {
                  final rule = rules[index];
                  return _buildRuleCard(context, dbService, rule, nameMap);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16), // Adjusted for user request
        child: FloatingActionButton(
          onPressed: () => context.push('/server/$serverId/automation/add'),
          backgroundColor: RustColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Stream<List<AutomationRule>> _watchRules(DatabaseService dbService) async* {
    final isar = await dbService.db;
    yield* isar.automationRules
        .filter()
        .serverIdEqualTo(serverId)
        .watch(fireImmediately: true);
  }

  Stream<Map<int, String>> _watchDeviceNames(DatabaseService dbService) async* {
    final isar = await dbService.db;
    yield* isar.smartDevices
        .filter()
        .serverIdEqualTo(serverId)
        .watch(fireImmediately: true)
        .map((devices) => {for (var d in devices) d.entityId: d.name});
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_fix_high, size: 64, color: Colors.white10),
          const SizedBox(height: 16),
          const Text(
            "No active automations",
            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Create a 'Digital Wire' to automate your base. Example: If alarm rings, turn on turrets.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          // Removed manual CREATE RULE button as per user request to keep only FAB
        ],
      ),
    );
  }

  Widget _buildRuleCard(BuildContext context, DatabaseService dbService, AutomationRule rule, Map<int, String> nameMap) {
    return GestureDetector(
      onTap: () => context.push('/server/$serverId/automation/add', extra: {'rule': rule}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: RustColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RustColors.divider.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 6,
                  color: rule.isEnabled ? RustColors.primary : RustColors.textMuted,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                rule.name.toUpperCase(),
                                style: const TextStyle(
                                  color: RustColors.textPrimary, 
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: rule.isEnabled,
                                activeTrackColor: RustColors.primaryDark,
                                activeColor: RustColors.primary,
                                onChanged: (val) async {
                                  final isar = await dbService.db;
                                  await isar.writeTxn(() async {
                                    rule.isEnabled = val;
                                    await isar.automationRules.put(rule);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: RustColors.divider, height: 32),
                        _buildRuleDetails(rule, nameMap),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () => context.push('/server/$serverId/automation/add', extra: {'rule': rule}),
                              icon: const Icon(Icons.edit_outlined, size: 18, color: RustColors.primary),
                              label: const Text("EDIT", style: TextStyle(color: RustColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final isar = await dbService.db;
                                await isar.writeTxn(() async {
                                  await isar.automationRules.delete(rule.id);
                                });
                              },
                              icon: const Icon(Icons.delete_outline, size: 18, color: RustColors.error),
                              label: const Text("REMOVE", style: TextStyle(color: RustColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleDetails(AutomationRule rule, Map<int, String> nameMap) {
    String conditionText = "";
    switch (rule.triggerCondition) {
      case 0: conditionText = "turns ON"; break;
      case 1: conditionText = "turns OFF"; break;
    }

    final triggerName = nameMap[rule.triggerEntityId] ?? "Device ${rule.triggerEntityId}";

    // Pro Mode Actions
    final activeActions = rule.actions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepRow(Icons.sensors, "IF $triggerName $conditionText"),
        const Divider(color: Colors.white10, height: 24),
        ...activeActions.map((action) {
          String actionText = "";
          switch (action.actionValue) {
            case 0: actionText = "Turn OFF"; break;
            case 1: actionText = "Turn ON"; break;
            case 2: actionText = "Toggle Status"; break;
            case 3: actionText = "Just Notification"; break;
          }
          final actionName = nameMap[action.actionEntityId] ?? "Device ${action.actionEntityId}";
          final delayText = action.delaySeconds > 0 ? " (after ${action.delaySeconds}s)" : "";
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildStepRow(Icons.bolt, "THEN $actionText $actionName$delayText"),
          );
        }).toList(),
        if (rule.triggerCountThreshold > 1 || rule.autoOff || (rule.startTimeMinutes != null && rule.endTimeMinutes != null)) ...[
          const SizedBox(height: 12),
          _buildAdvancedInfo(rule),
        ],
      ],
    );
  }

  Widget _buildAdvancedInfo(AutomationRule rule) {
    List<String> labels = [];
    if (rule.autoOff) labels.add("AUTO-OFF");
    if (rule.triggerCountThreshold > 1) labels.add("PERSISTENT (${rule.triggerCountThreshold}x)");
    if (rule.playAppAlarm) labels.add("🔔 PHONE ALARM");
    if (rule.startTimeMinutes != null && rule.endTimeMinutes != null) {
      final start = _formatMinutes(rule.startTimeMinutes!);
      final end = _formatMinutes(rule.endTimeMinutes!);
      labels.add("SCHEDULE: $start - $end");
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: labels.map((l) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: l.startsWith("SCHEDULE") ? RustColors.accent.withOpacity(0.1) : Colors.white10,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: l.startsWith("SCHEDULE") ? RustColors.accent.withOpacity(0.3) : Colors.transparent),
        ),
        child: Text(
          l,
          style: TextStyle(
            color: l.startsWith("SCHEDULE") ? RustColors.accent : Colors.grey, 
            fontSize: 10, 
            fontWeight: FontWeight.bold
          ),
        ),
      )).toList(),
    );
  }

  String _formatMinutes(int mins) {
    final h = mins ~/ 60;
    final m = mins % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
  }

  Widget _buildStepRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: RustColors.accent),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: RustColors.textSecondary)),
      ],
    );
  }
}
