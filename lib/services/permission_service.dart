import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final permissionServiceProvider = Provider((ref) => PermissionService());

class PermissionService {
  static const MethodChannel _channel = MethodChannel('com.raidalarm/permission');
  
  static const String _methodCheckNotificationEnabled = 'checkNotificationEnabled';
  static const String _methodRequestNotificationPermission = 'requestNotificationPermission';
  static const String _checkCriticalAlertsPermission = 'checkCriticalAlertsPermission';
  static const String _requestCriticalAlertsPermission = 'requestCriticalAlertsPermission';

  static Future<bool> checkCriticalAlertsPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>(_checkCriticalAlertsPermission);
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> requestCriticalAlertsPermission() async {
    try {
      await _channel.invokeMethod(_requestCriticalAlertsPermission);
    } catch (e) {}
  }

  // Legacy Android checks - returning true/void to avoid breakages during refactor
  // These should eventually be removed from call sites
  static Future<bool> checkNotificationEnabled() async {
     try {
      final result = await _channel.invokeMethod<bool>(_methodCheckNotificationEnabled);
      return result ?? false;
    } catch (e) { return false; }
  }

  static Future<void> requestNotificationPermission() async {
     try { await _channel.invokeMethod(_methodRequestNotificationPermission); } catch (e) {}
  }
}
