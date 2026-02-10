import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final oneSignalServiceProvider = Provider((ref) => OneSignalService());

class OneSignalService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    OneSignal.initialize('c1b0af52-be00-48a1-aec6-5f2a040c6ded');
    OneSignal.Notifications.requestPermission(true);

    _initialized = true;
  }

  static void login(String userId) {
    OneSignal.login(userId);
  }

  static void setTag(String key, String value) {
    OneSignal.User.addTagWithKey(key, value);
  }

  static void setTags(Map<String, String> tags) {
    OneSignal.User.addTags(tags);
  }

  static void markAsPremium() {
    OneSignal.User.addTagWithKey('is_premium', 'true');
  }

  static void paywallClosed() {
    setTag('paywall', 'viewed');
  }

  static void purchaseCompleted() {
    markAsPremium();
  }
}
