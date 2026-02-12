import 'package:isar/isar.dart';

part 'steam_credential.g.dart';

@collection
class SteamCredential {
  Id id = 1; // Singleton

  String? steamId;
  String? steamToken;
}
