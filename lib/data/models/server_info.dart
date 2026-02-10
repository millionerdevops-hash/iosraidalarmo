import 'package:isar/isar.dart';

part 'server_info.g.dart';

@collection
class ServerInfo {
  Id id = Isar.autoIncrement;

  late String ip;
  late String port;
  late String playerId; // SteamID
  late String playerToken; // The key for this server
  
  String? name;
  String? logoUrl;
  
  // Is this server currently connected or preferred?
  bool isSelected = false;

  // Should we use Facepunch's proxy for this server?
  bool useProxy = false;
}
