import 'package:isar/isar.dart';

part 'automation_rule.g.dart';

@collection
class AutomationRule {
  Id id = Isar.autoIncrement;

  late int serverId;
  late String name;
  
  // Trigger config
  late int triggerEntityId;
  late int triggerCondition; // 0: Becomes ON, 1: Becomes OFF, 2: Value Less Than, 3: Value Greater Than
  double? triggerThreshold;  // For conditions 2 and 3
  
  // Multiple Actions
  List<AutomationAction> actions = [];
  
  // Time Restrictions (Minutes from midnight: 0 to 1439)
  // Null means no restriction
  int? startTimeMinutes;
  int? endTimeMinutes;
  
  // Advanced features
  bool autoOff = false;      // Reverse action when trigger stops
  int triggerCountThreshold = 1; // 1 means immediate, > 1 means consecutive triggers
  int currentTriggerCount = 0;   // Progress towards threshold
  
  bool playAppAlarm = false;   // Play sound on phone when triggered
  
  bool isEnabled = true;
}

@embedded
class AutomationAction {
  int? actionEntityId;
  int? actionValue;      // 0: Turn OFF, 1: Turn ON, 2: Toggle, 3: Notify Only
  int delaySeconds = 0;  // 0 means immediate
}
