import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'mcs_messages.dart';

class GcmService {
  static const String CHECKIN_URL = 'https://android.clients.google.com/checkin';
  static const String REGISTER_URL = 'https://android.clients.google.com/c2dm/register3';
  
  // Rust+ Firebase Server Key Sender ID
  static const String SENDER_ID = "976529667804";
  
  // Spoofed Package Name for Rust+
  // NOTE: push-receiver uses 'org.chromium.linux' to bypass signature checks!
  static const String SPOOF_PACKAGE = "org.chromium.linux";
  
  Future<Map<String, dynamic>> checkIn({int androidId = 0, int securityToken = 0}) async {

    final request = AndroidCheckinRequest()
      ..id = androidId
      ..securityToken = securityToken;
      
    final response = await http.post(
      Uri.parse(CHECKIN_URL),
      headers: {'Content-Type': 'application/x-protobuf'},
      body: request.toBytes(),
    );
    
    if (response.statusCode == 200) {
      final checkinResp = AndroidCheckinResponse.fromBytes(response.bodyBytes);
      // Check-in Successful
      return {
        'androidId': checkinResp.androidId,
        'securityToken': checkinResp.securityToken
      };
    } else {
      throw Exception("Check-in failed: ${response.statusCode}");
    }
  }
  
  Future<String> register(int androidId, int securityToken) async {

    
    final body = {
      'app': SPOOF_PACKAGE, // Spoofing!
      'X-subtype': SENDER_ID, // Use Sender ID (Project ID) NOT package name here? Wait, push-receiver says X-subtype: appId (which is senderId usually?? No, appId passed to register is senderId in push-receiver sample)
      // Check push-receiver: const gcmSenderId = "976529667804"; AndroidFCM.register(..., gcmSenderId, ...)
      // doRegister(..., appId) => X-subtype: appId. So yes, Sender ID.
      'device': androidId.toString(),
      'sender': SENDER_ID,
    };
    
    final response = await http.post(
      Uri.parse(REGISTER_URL),
      headers: {
        'Authorization': 'AidLogin $androidId:$securityToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    
    final result = response.body;
    if (result.contains("Error=")) {
      throw Exception("Registration failed: $result");
    }
    
    // Response format: token=APA91b...
    final token = result.split('=')[1].trim();

    return token;
  }
}
