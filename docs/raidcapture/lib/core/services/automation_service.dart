import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/automation_rule.dart';
import '../proto/rustplus.pb.dart';
import 'database_service.dart';
import 'connection_manager.dart';
import 'package:isar/isar.dart';

final automationServiceProvider = Provider((ref) => AutomationService(ref));

class AutomationService {
  final Ref _ref;
  final Map<int, StreamSubscription> _subscriptions = {};

  AutomationService(this._ref);

  /// Starts listening to device changes for a specific server
  void watchServer(int serverId, ConnectionManager manager) {
    if (_subscriptions.containsKey(serverId)) return;

    debugPrint("[Automation] Starting automation watcher for server $serverId");
    
    _subscriptions[serverId] = manager.messageStream.listen((message) {
      if (message.hasBroadcast() && message.broadcast.hasEntityChanged()) {
        _handleEntityChange(serverId, message.broadcast.entityChanged, manager);
      }
    });
  }

  void stopWatching(int serverId) {
    _subscriptions[serverId]?.cancel();
    _subscriptions.remove(serverId);
  }

  Future<void> _handleEntityChange(int serverId, AppEntityChanged change, ConnectionManager manager) async {
    final db = await _ref.read(databaseServiceProvider).db;
    
    // Fetch enabled rules for this trigger entity on this server
    final rules = await db.automationRules
        .filter()
        .serverIdEqualTo(serverId)
        .triggerEntityIdEqualTo(change.entityId)
        .isEnabledEqualTo(true)
        .findAll();

    if (rules.isEmpty) return;

    final newVal = change.payload.value;
    debugPrint("[Automation] Entity ${change.entityId} changed to $newVal. Checking ${rules.length} rules.");

    for (final rule in rules) {
      bool isTriggerActive = false;
      bool isTriggerEnded = false;
      
      // Check condition
      if (rule.triggerCondition == 0) { // Becomes ON
        if (newVal == true) isTriggerActive = true;
        if (newVal == false) isTriggerEnded = true;
      } else if (rule.triggerCondition == 1) { // Becomes OFF
        if (newVal == false) isTriggerActive = true;
        if (newVal == true) isTriggerEnded = true;
      }

      if (isTriggerActive) {
        // Increment Counter
        await db.writeTxn(() async {
          rule.currentTriggerCount++;
          await db.automationRules.put(rule);
        });

        // Check if threshold reached
        if (rule.currentTriggerCount >= rule.triggerCountThreshold) {
          debugPrint("[Automation] Threshold reached for ${rule.name} (${rule.currentTriggerCount}/${rule.triggerCountThreshold})");
          _executeRule(rule, manager, reverse: false);
        }
      } else if (isTriggerEnded && rule.autoOff) {
        // Only reverse if we haven't hit the "persistent" threshold or if threshold is 1
        if (rule.triggerCountThreshold <= 1 || rule.currentTriggerCount < rule.triggerCountThreshold) {
           debugPrint("[Automation] Trigger ended, reversing action for ${rule.name}");
           _executeRule(rule, manager, reverse: true);
        }
      }
    }
  }

  bool _isRuleInTimeWindow(AutomationRule rule) {
    if (rule.startTimeMinutes == null || rule.endTimeMinutes == null) return true;
    if (rule.startTimeMinutes == 0 && rule.endTimeMinutes == 0) return true;

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    if (rule.startTimeMinutes! <= rule.endTimeMinutes!) {
      // Same day window (e.g. 10:00 - 18:00)
      return currentMinutes >= rule.startTimeMinutes! && currentMinutes <= rule.endTimeMinutes!;
    } else {
      // Overnight window (e.g. 22:00 - 06:00)
      return currentMinutes >= rule.startTimeMinutes! || currentMinutes <= rule.endTimeMinutes!;
    }
  }

  Future<void> _executeRule(AutomationRule rule, ConnectionManager manager, {bool reverse = false}) async {
    debugPrint("[Automation] ${reverse ? 'Reversing' : 'Executing'} rule: ${rule.name}");

    if (!reverse && !_isRuleInTimeWindow(rule)) {
       debugPrint("[Automation] Rule ${rule.name} skipped: Outside of time window.");
       return;
    }

    if (!reverse && rule.playAppAlarm) {
       debugPrint("[Automation] 🚨 PHONE ALARM TRIGGERED for rule: ${rule.name}");
       // TODO: Integrate with a sound player or local notification service here
    }

    // Pro Mode Actions
    final activeActions = rule.actions;

    for (int i = 0; i < activeActions.length; i++) {
       final action = activeActions[i];
       
       // Execute the action
       await _executeSingleAction(rule, action, manager, reverse: reverse);
       
       // If there's another action coming, wait a bit to respect Rust+ tokens
       if (i < activeActions.length - 1) {
         await Future.delayed(const Duration(milliseconds: 150));
       }
    }
  }

  Future<void> _executeSingleAction(AutomationRule rule, AutomationAction action, ConnectionManager manager, {bool reverse = false}) async {
    if (action.actionEntityId == null || action.actionValue == null) return;
    
    if (action.delaySeconds > 0 && !reverse) {
       debugPrint("[Automation] Delaying action for ${action.delaySeconds}s...");
       await Future.delayed(Duration(seconds: action.delaySeconds));
    }

    int actualAction = action.actionValue!;
    if (reverse) {
      // Reverse Turn ON to OFF, or OFF to ON
      if (actualAction == 1) actualAction = 0;
      else if (actualAction == 0) actualAction = 1;
      else return; // Toggle/Notify don't have a direct reverse
    }
    
    try {
      switch (actualAction) {
        case 0: // Turn OFF
          await manager.turnSmartSwitchOff(action.actionEntityId!);
          break;
        case 1: // Turn ON
          await manager.turnSmartSwitchOn(action.actionEntityId!);
          break;
        case 2: // Toggle
          final info = await manager.getEntityInfo(action.actionEntityId!);
          if (info.hasResponse() && info.response.hasEntityInfo()) {
            final current = info.response.entityInfo.payload.value;
            await manager.setEntityValue(action.actionEntityId!, !current);
          }
          break;
        case 3: // Notify Only
          // TODO: Implement local notification trigger
          debugPrint("[Automation] Notification trigger NOT FULLY implemented");
          break;
      }
    } catch (e) {
      debugPrint("[Automation] Failed to execute action on ${action.actionEntityId}: $e");
    }
  }
}

// Helper provider for DatabaseService if not already exists (assuming it exists based on previous work)
final databaseServiceProvider = Provider((ref) => DatabaseService());
