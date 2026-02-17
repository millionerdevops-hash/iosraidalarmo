import 'proto_utils.dart';
import 'dart:convert';

// --- Checkin Messages ---

class AndroidCheckinRequest {
  int userSerialNumber = 0;
  String? checkinType; // Nested message simulation
  int version = 3;
  int id = 0; // AndroidId
  int securityToken = 0;

  List<int> toBytes() {
    final writer = ProtoWriter();
    
    // checkin (tag 4) -> AndroidCheckinProto (nested)
    final checkinProtoWriter = ProtoWriter();
    
    // ChromeBuildProto (tag 1) inside Checkin (should actually be tag 4 inside AndroidCheckinRequest -> tag ? inside AndroidCheckinProto)
    // Looking at push-receiver getCheckinRequest:
    // payload: { checkin: { type: 3, chromeBuild: { platform: 2, chromeVersion: ..., channel: 1 } } }
    // AndroidCheckinRequest: checkin = 4 (AndroidCheckinProto)
    // AndroidCheckinProto: type = 3 (int32 ? tag ?), chrome_build = ?
    
    // Let's reverse engineer from node-gcm code snippet:
    // checkin (4) { type (3) = 3, chromeBuild (nested?) }
    // Actually finding exact field IDs for AndroidCheckinProto is key.
    // Based on open source defs:
    // AndroidCheckinProto:
    //   optional BuildProto build = 1;
    //   optional int64 last_checkin_msec = 2;
    //   repeated EventProto event = 3;
    //   repeated StatProto stat = 4;
    //   optional int32 requested_group = 5;
    //   optional string cell_operator = 6;
    //   optional string sim_operator = 7;
    //   optional string roaming = 8;
    //   optional int32 user_number = 9;
    //   optional int32 type = 10; <--- TYPE
    //   optional ChromeBuildProto chrome_build = 11; <--- CHROME BUILD
    
    // ChromeBuildProto:
    //   optional int32 platform = 1;
    //   optional string chrome_version = 2;
    //   optional int32 channel = 3;

    // So:
    // 1. ChromeBuildProto
    final chromeBuildWriter = ProtoWriter();
    chromeBuildWriter.writeInt32(1, 2); // platform = 2 (Android?)
    chromeBuildWriter.writeString(2, '63.0.3234.0'); // chrome_version
    chromeBuildWriter.writeInt32(3, 1); // channel = 1
    
    // 2. AndroidCheckinProto
    checkinProtoWriter.writeInt32(10, 3); // type = 3
    checkinProtoWriter.writeMessage(11, chromeBuildWriter.toBytes()); // chrome_build
    
    // 3. AndroidCheckinRequest
    writer.writeMessage(4, checkinProtoWriter.toBytes()); // checkin
    writer.writeInt32(14, 3); // version = 3
    
    if (id != 0) writer.writeInt64(2, id);
    if (securityToken != 0) writer.writeInt64(13, securityToken);
    
    return writer.toBytes();
  }
}


class AndroidCheckinResponse {
  int androidId = 0;
  int securityToken = 0;

  static AndroidCheckinResponse fromBytes(List<int> bytes) {
    final reader = ProtoReader(bytes);
    final response = AndroidCheckinResponse();

    while (!reader.isAtEnd) {
      final tag = reader.readTag();
      if (tag == 0) break;
      
      final fieldNumber = reader.getFieldNumber(tag);
      final wireType = reader.getWireType(tag);

      if (fieldNumber == 7 && wireType == 1) { // android_id (fixed64)
        response.androidId = reader.readFixed64();
      } else if (fieldNumber == 8 && wireType == 1) { // security_token (fixed64)
        response.securityToken = reader.readFixed64();
      } else {
        reader.skipField(tag);
      }
    }
    return response;
  }
}


class HeartbeatPing {
  int? streamId;
  int? lastStreamIdReceived;
  int? status;

  static HeartbeatPing fromBytes(List<int> bytes) {
    final reader = ProtoReader(bytes);
    final msg = HeartbeatPing();
    while (!reader.isAtEnd) {
      final tag = reader.readTag();
      if (tag == 0) break;
      final fn = reader.getFieldNumber(tag);
      if (fn == 1) msg.streamId = reader.readVarint();
      else if (fn == 2) msg.lastStreamIdReceived = reader.readVarint();
      else if (fn == 3) msg.status = reader.readVarint(); // int64 treat as varint
      else reader.skipField(tag);
    }
    return msg;
  }
}

class HeartbeatAck {
  int? streamId;
  int? lastStreamIdReceived;
  int? status;

  List<int> toBytes() {
    final writer = ProtoWriter();
    if (streamId != null) writer.writeInt32(1, streamId!);
    if (lastStreamIdReceived != null) writer.writeInt32(2, lastStreamIdReceived!);
    if (status != null) writer.writeInt64(3, status!);
    return writer.toBytes();
  }
}

class Close {
  static Close fromBytes(List<int> bytes) => Close();
}

// --- MCS Messages ---

class LoginRequest {
  String id = 'chrome-63.0.3234.0';
  String domain = 'mcs.android.com';
  String deviceId; // "android-$hexId"
  String resource; // androidId decimal
  String user; // androidId decimal
  String authToken; // securityToken decimal
  List<String> receivedPersistentIds = []; // Tag 10
  
  LoginRequest({
    required this.deviceId,
    required this.resource,
    required this.user,
    required this.authToken,
    this.receivedPersistentIds = const [],
  });

  List<int> toBytes() {
    final writer = ProtoWriter();
    
    writer.writeString(1, id);
    writer.writeString(2, domain);
    writer.writeString(3, user);
    writer.writeString(4, resource);
    writer.writeString(5, authToken);
    writer.writeString(6, deviceId);
    writer.writeInt32(12, 0); // adaptive_heartbeat = false (0)
    writer.writeInt32(16, 2); // auth_service = 2 (ANDROID_ID)
    writer.writeInt32(14, 1); // use_rmq2 = true (1)
    writer.writeInt32(17, 1); // network_type = 1 (WIFI/CONNECTED)
    
    // setting: name="new_vc", value="1"
    final settingWriter = ProtoWriter();
    settingWriter.writeString(1, "new_vc");
    settingWriter.writeString(2, "1");
    writer.writeMessage(8, settingWriter.toBytes());

    for (var pid in receivedPersistentIds) {
      writer.writeString(10, pid);
    }
    
    return writer.toBytes();
  }
}

class DataMessageStanza {
  String from = ""; // Tag 3
  String category = ""; // Tag 5 (package name)
  String persistentId = ""; // Tag 12
  List<MapEntry<String, String>> appData = []; // Tag 7 (repeated AppData)

  static DataMessageStanza fromBytes(List<int> bytes) {
    final reader = ProtoReader(bytes);
    final msg = DataMessageStanza();
    
    while (!reader.isAtEnd) {
      final tag = reader.readTag();
      if (tag == 0) break;
      
      final fieldNumber = reader.getFieldNumber(tag);
      
      if (fieldNumber == 3) { // from
        msg.from = reader.readString();
      } else if (fieldNumber == 5) { // category
        msg.category = reader.readString();
      } else if (fieldNumber == 7) { // app_data (repeated)
        final entryBytes = reader.readBytes();
        final entryReader = ProtoReader(entryBytes);
        String key = "";
        String value = "";
        while(!entryReader.isAtEnd) {
           final subTag = entryReader.readTag();
           if(subTag == 0) break;
           final subFn = entryReader.getFieldNumber(subTag);
           if (subFn == 1) key = entryReader.readString();
           else if (subFn == 2) value = entryReader.readString();
           else entryReader.skipField(subTag);
        }
        msg.appData.add(MapEntry(key, value));
      } else if (fieldNumber == 12) { // persistent_id
        msg.persistentId = reader.readString();
      } else {
        reader.skipField(tag);
      }
    }
    return msg;
  }
}
