import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/server_info.dart';
import '../../data/models/fcm_credential.dart';
import '../../data/models/smart_device.dart';
import '../../data/models/automation_rule.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [
        ServerInfoSchema,
        FcmCredentialSchema,
        SmartDeviceSchema,
        AutomationRuleSchema,
      ],
      directory: dir.path,
    );
  }
}
