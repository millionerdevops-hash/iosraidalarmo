import 'package:isar/isar.dart';

part 'fcm_credential.g.dart';

@collection
class FcmCredential {
  Id id = Isar.autoIncrement;

  late String fcmToken;
  String? expoPushToken;
  String? steamId;
  String? steamToken;
  
  // Custom MCS Fields
  int? androidId;
  int? securityToken;
}
