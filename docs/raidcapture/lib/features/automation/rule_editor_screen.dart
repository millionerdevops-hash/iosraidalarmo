import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import '../../data/models/automation_rule.dart';
import '../../data/models/smart_device.dart';
import '../../core/services/database_service.dart';
import '../../core/proto/rustplus.pbenum.dart';
import '../../config/rust_colors.dart';

class RuleEditorScreen extends ConsumerStatefulWidget {
  final int serverId;
  final AutomationRule? rule; // Add this

  const RuleEditorScreen({super.key, required this.serverId, this.rule});

  @override
  ConsumerState<RuleEditorScreen> createState() => _RuleEditorScreenState();
}

class _RuleEditorScreenState extends ConsumerState<RuleEditorScreen> {
  final _nameController = TextEditingController();
  
  SmartDevice? _triggerDevice;
  int _triggerCondition = 0; // 0: ON, 1: OFF
  
  List<AutomationAction> _actions = [];
  
  int? _startTimeMinutes;
  int? _endTimeMinutes;
  
  bool _autoOff = false;
  int _threshold = 1;
  bool _playAppAlarm = false;
  
  List<SmartDevice> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.rule != null) {
      _nameController.text = widget.rule!.name;
      _triggerCondition = widget.rule!.triggerCondition;
      _actions = List.from(widget.rule!.actions);
      _startTimeMinutes = widget.rule!.startTimeMinutes;
      _endTimeMinutes = widget.rule!.endTimeMinutes;
      _autoOff = widget.rule!.autoOff;
      _threshold = widget.rule!.triggerCountThreshold;
      _playAppAlarm = widget.rule!.playAppAlarm;
    } else {
      // Default initial action
      _actions.add(AutomationAction()..actionValue = 1);
    }
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    final db = await DatabaseService().db;
    final devices = await db.smartDevices.filter().serverIdEqualTo(widget.serverId).findAll();
    setState(() {
      _devices = devices;
      if (widget.rule != null) {
        _triggerDevice = _devices.where((d) => d.entityId == widget.rule!.triggerEntityId).firstOrNull;
      }
      
      // Safety: If no actions exist, add a default one
      if (_actions.isEmpty) {
        _actions.add(AutomationAction()..actionValue = 1);
      }
      
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RustColors.background,
      appBar: AppBar(
        title: Text(widget.rule == null ? "NEW RULE" : "EDIT RULE"),
        backgroundColor: RustColors.surface,
        foregroundColor: RustColors.textPrimary,
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("1. RULE NAME"),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: RustColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: "e.g. Base Lockdown",
                    hintStyle: const TextStyle(color: RustColors.textMuted),
                    filled: true,
                    fillColor: RustColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildSectionHeader("2. TRIGGER (IF)"),
                _buildDeviceSelector(true),
                if (_triggerDevice != null) ...[
                  const SizedBox(height: 12),
                  _buildConditionSelector(),
                ],
                
                const SizedBox(height: 24),
                
                _buildSectionHeader("3. ACTION SEQUENCE (THEN)"),
                _buildActionSequence(),
                
                const SizedBox(height: 32),
                _buildSectionHeader("4. TIME RESTRICTION (OPTIONAL)"),
                _buildTimeRestriction(),
                
                const SizedBox(height: 32),
                _buildSectionHeader("5. ADVANCED OPTIONS"),
                _buildAdvancedOptions(),
                
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveRule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RustColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      widget.rule == null ? "SAVE AUTOMATION" : "UPDATE AUTOMATION", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(color: RustColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildDeviceSelector(bool isTrigger, {AutomationAction? action}) {
    final selectedEntityId = isTrigger ? _triggerDevice?.entityId : action?.actionEntityId;
    final selected = _devices.where((d) => d.entityId == selectedEntityId).firstOrNull;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: RustColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SmartDevice>(
          value: selected,
          hint: const Text("Select Device", style: TextStyle(color: RustColors.textMuted)),
          dropdownColor: RustColors.cardBackground,
          isExpanded: true,
          items: _devices.map((d) => DropdownMenuItem(
            value: d,
            child: Text(d.name, style: const TextStyle(color: RustColors.textPrimary)),
          )).toList(),
          onChanged: (val) {
            setState(() {
              if (isTrigger) {
                _triggerDevice = val; 
              } else if (action != null) {
                action.actionEntityId = val?.entityId;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildConditionSelector() {
    return Row(
      children: [
        const Text("WHEN IT ", style: TextStyle(color: RustColors.textSecondary)),
        const SizedBox(width: 8),
        _buildSmallDropdown<int>(
          value: _triggerCondition,
          items: const [
            DropdownMenuItem(value: 0, child: Text("Turns ON")),
            DropdownMenuItem(value: 1, child: Text("Turns OFF")),
          ],
          onChanged: (val) => setState(() => _triggerCondition = val!),
        ),
      ],
    );
  }

  Widget _buildActionSequence() {
    return Column(
      children: [
        ..._actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return _buildActionRow(index, action);
        }).toList(),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => setState(() => _actions.add(AutomationAction()..actionValue = 1)),
          icon: const Icon(Icons.add),
          label: const Text("ADD ACTION"),
          style: OutlinedButton.styleFrom(
            foregroundColor: RustColors.accent,
            side: const BorderSide(color: RustColors.accent),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(int index, AutomationAction action) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RustColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RustColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ACTION #${index + 1}", style: const TextStyle(color: RustColors.textMuted, fontWeight: FontWeight.bold, fontSize: 10)),
              if (_actions.length > 1)
                IconButton(
                  icon: const Icon(Icons.close, size: 16, color: RustColors.error),
                  onPressed: () => setState(() => _actions.removeAt(index)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDeviceSelector(false, action: action),
          if (action.actionEntityId != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("DO ", style: TextStyle(color: RustColors.textSecondary)),
                const SizedBox(width: 8),
                _buildSmallDropdown<int>(
                  value: action.actionValue ?? 1,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("Turn ON")),
                    DropdownMenuItem(value: 0, child: Text("Turn OFF")),
                    DropdownMenuItem(value: 2, child: Text("Toggle")),
                    DropdownMenuItem(value: 3, child: Text("Notify")),
                  ],
                  onChanged: (val) => setState(() => action.actionValue = val!),
                ),
                const Spacer(),
                const Icon(Icons.timer_outlined, size: 16, color: RustColors.textMuted),
                const SizedBox(width: 4),
                _buildSmallDropdown<int>(
                  value: action.delaySeconds ?? 0,
                  items: [0, 1, 2, 5, 10, 30, 60].map((s) => DropdownMenuItem(
                    value: s, 
                    child: Text(s == 0 ? "Now" : "${s}s delay")
                  )).toList(),
                  onChanged: (val) => setState(() => action.delaySeconds = val!),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmallDropdown<T>({required T value, required List<DropdownMenuItem<T>> items, required Function(T?) onChanged}) {
    // Safety check: ensure value is in the items list
    T effectiveValue = value;
    if (!items.any((item) => item.value == value)) {
      if (items.isNotEmpty) effectiveValue = items.first.value as T;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: effectiveValue,
          items: items,
          onChanged: onChanged,
          dropdownColor: RustColors.cardBackground,
          style: const TextStyle(color: RustColors.accent, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTimeRestriction() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RustColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RustColors.divider),
      ),
      child: Column(
        children: [
          _buildTimeRow("START TIME", _startTimeMinutes, (val) => setState(() => _startTimeMinutes = val)),
          const Divider(color: RustColors.divider, height: 24),
          _buildTimeRow("END TIME", _endTimeMinutes, (val) => setState(() => _endTimeMinutes = val)),
          if (_startTimeMinutes != null && _endTimeMinutes != null)
             TextButton(
               onPressed: () => setState(() { _startTimeMinutes = null; _endTimeMinutes = null; }),
               child: const Text("CLEAR TIME WINDOW", style: TextStyle(color: RustColors.error, fontSize: 10)),
             )
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, int? currentMins, Function(int) onSelected) {
    final display = currentMins == null ? "Any Time" : _formatMinutes(currentMins);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: RustColors.textPrimary)),
        InkWell(
          onTap: () async {
            final now = TimeOfDay.fromDateTime(DateTime.now());
            final picked = await showTimePicker(
              context: context, 
              initialTime: currentMins == null ? now : TimeOfDay(hour: currentMins ~/ 60, minute: currentMins % 60),
            );
            if (picked != null) {
              onSelected(picked.hour * 60 + picked.minute);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(4)),
            child: Text(display, style: const TextStyle(color: RustColors.accent, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  String _formatMinutes(int mins) {
    final h = mins ~/ 60;
    final m = mins % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
  }

  Future<void> _saveRule() async {
    if (_nameController.text.isEmpty || _triggerDevice == null || _actions.any((a) => a.actionEntityId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final rule = widget.rule ?? AutomationRule();
    rule
      ..serverId = widget.serverId
      ..name = _nameController.text
      ..triggerEntityId = _triggerDevice!.entityId
      ..triggerCondition = _triggerCondition
      ..actions = _actions
      ..startTimeMinutes = _startTimeMinutes
      ..endTimeMinutes = _endTimeMinutes
      ..autoOff = _autoOff
      ..triggerCountThreshold = _threshold
      ..playAppAlarm = _playAppAlarm;

    final db = await DatabaseService().db;
    await db.writeTxn(() async {
      await db.automationRules.put(rule);
    });

    if (mounted) context.pop();
  }

  Widget _buildAdvancedOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RustColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RustColors.divider),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Auto-Off", style: TextStyle(color: RustColors.textPrimary, fontWeight: FontWeight.bold)),
                  Text("Reverse action when trigger stops", style: TextStyle(color: RustColors.textSecondary, fontSize: 11)),
                ],
              ),
              Switch(
                value: _autoOff,
                activeTrackColor: RustColors.primaryDark,
                activeColor: RustColors.primary,
                onChanged: (val) => setState(() => _autoOff = val),
              ),
            ],
          ),
          const Divider(color: RustColors.divider, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Trigger Threshold", style: TextStyle(color: RustColors.textPrimary, fontWeight: FontWeight.bold)),
                  Text("How many hits before activation", style: TextStyle(color: RustColors.textSecondary, fontSize: 11)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: RustColors.textMuted),
                    onPressed: _threshold > 1 ? () => setState(() => _threshold--) : null,
                  ),
                  Text("$_threshold", style: const TextStyle(color: RustColors.accent, fontWeight: FontWeight.bold, fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: RustColors.textMuted),
                    onPressed: () => setState(() => _threshold++),
                  ),
                ],
              ),
            ],
          ),
          if (_threshold > 1)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "NOTE: Persistent lockdown starts after the threshold is hit.",
                style: TextStyle(color: RustColors.warning, fontSize: 10, fontStyle: FontStyle.italic),
              ),
            ),
          const Divider(color: RustColors.divider, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Play Phone Alarm", style: TextStyle(color: RustColors.textPrimary, fontWeight: FontWeight.bold)),
                  Text("Sound audible alarm on your phone", style: TextStyle(color: RustColors.textSecondary, fontSize: 11)),
                ],
              ),
              Switch(
                value: _playAppAlarm,
                activeTrackColor: RustColors.primaryDark,
                activeColor: RustColors.primary,
                onChanged: (val) => setState(() => _playAppAlarm = val),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
