import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NativeNotificationHelper {
  static const MethodChannel _channel = MethodChannel('com.raidalarm/player_notification');

  static Future<void> showNotification({
    required String playerName,
    required String serverName,
    required bool isOnline,
  }) async {
    try {
      await _channel.invokeMethod('showNotification', {
        'playerName': playerName,
        'serverName': serverName,
        'isOnline': isOnline,
      });
    } catch (e) {
      debugPrint('Error showing native notification: $e');
    }
  }
}
