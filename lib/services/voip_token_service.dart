import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class VoipTokenService {
  static const MethodChannel _channel = MethodChannel('com.raidalarm/voip');
  static String? _voipToken;

  /// Initialize VoIP token listener (iOS only)
  static Future<void> initialize() async {
    if (!Platform.isIOS) return;

    try {
      // Set up method call handler to receive VoIP token from native
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'onVoipToken') {
          _voipToken = call.arguments as String?;
          debugPrint('[VoipTokenService] 📱 VoIP Token received: ${_voipToken?.substring(0, 10)}...');
        }
      });

      // Request VoIP token from native side
      final token = await _channel.invokeMethod<String>('getVoipToken');
      if (token != null && token.isNotEmpty) {
        _voipToken = token;
        debugPrint('[VoipTokenService] 📱 VoIP Token retrieved: ${token.substring(0, 10)}...');
      }
    } catch (e) {
      debugPrint('[VoipTokenService] ⚠️ Failed to get VoIP token: $e');
    }
  }

  /// Get the current VoIP token (iOS only)
  static String? getVoipToken() {
    return _voipToken;
  }

  /// Check if VoIP token is available
  static bool hasVoipToken() {
    return _voipToken != null && _voipToken!.isNotEmpty;
  }
}
