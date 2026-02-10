import 'package:isar/isar.dart';
import '../../core/proto/rustplus.pbenum.dart'; // For AppEntityType

part 'smart_device.g.dart';

@collection
class SmartDevice {
  Id id = Isar.autoIncrement;

  late int serverId; // Foreign key to ServerInfo
  late String name;
  late int entityId;
  late int entityType; // Maps to AppEntityType value
  
  // Current state (cached)
  bool isActive = false; // On/Off
  double value = 0.0;    // For storage monitors etc.
  int capacity = 0;      // For storage monitors
  
  // Helper to get enum
  @ignore
  AppEntityType get type => AppEntityType.valueOf(entityType) ?? AppEntityType.Switch;
}
