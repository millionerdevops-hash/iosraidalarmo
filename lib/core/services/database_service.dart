import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/server_info.dart';
import '../../data/models/smart_device.dart';
import '../../data/models/steam_credential.dart';

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
        SteamCredentialSchema,
        SmartDeviceSchema,
      ],
      directory: dir.path,
    );
  }
}
