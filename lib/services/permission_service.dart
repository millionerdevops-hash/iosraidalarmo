import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final permissionServiceProvider = Provider((ref) => PermissionService());

class PermissionService {
  static const MethodChannel _channel = MethodChannel('com.raidalarm/permission');
  
  static const String _methodCheckBatteryOptimization = 'checkBatteryOptimization';
  static const String _methodRequestBatteryOptimizationExemption = 'requestBatteryOptimizationExemption';
  static const String _methodCheckExactAlarmPermission = 'checkExactAlarmPermission';
  static const String _methodRequestExactAlarmPermission = 'requestExactAlarmPermission';
  static const String _methodCheckNotificationEnabled = 'checkNotificationEnabled';
  static const String _methodRequestNotificationPermission = 'requestNotificationPermission';
  static const String _methodOpenAppSettings = 'openAppSettings';
  static const String _methodCanDrawOverlays = 'canDrawOverlays';
  static const String _methodRequestDisplayOverOtherApps = 'requestDisplayOverOtherAppsPermission';
  static const String _methodCheckAutoStart = 'checkAutoStartPermission';
  static const String _methodRequestAutoStart = 'requestAutoStartPermission';
  static const String _methodOpenRustPlus = 'openRustPlusApp';
  static const String _methodOpenRustPlusSettings = 'openRustPlusNotificationSettings';
  static const String _methodCanUseFullScreenIntent = 'canUseFullScreenIntent';
  static const String _methodRequestFullScreenIntentPermission = 'requestFullScreenIntentPermission';
  
  static Future<bool> checkExactAlarmPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }
    
    try {
      final result = await _channel.invokeMethod<bool>(_methodCheckExactAlarmPermission);
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }
    
    try {
      final result = await _channel.invokeMethod<bool>(_methodRequestExactAlarmPermission);
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> checkBatteryOptimization() async {
    if (!Platform.isAndroid) {
      return true;
    }
    
    try {
      final result = await _channel.invokeMethod<bool>(_methodCheckBatteryOptimization);
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> requestBatteryOptimizationExemption() async {
    if (!Platform.isAndroid) return true;
    try {
      final result = await _channel.invokeMethod<bool>(_methodRequestBatteryOptimizationExemption);
      return result ?? false;
    } catch (e) { return false; }
  }

  static Future<bool> checkNotificationEnabled() async {
    if (!Platform.isAndroid) return true;
    try {
      final result = await _channel.invokeMethod<bool>(_methodCheckNotificationEnabled);
      return result ?? false;
    } catch (e) { return false; }
  }

  static Future<void> requestNotificationPermission() async {
    if (!Platform.isAndroid) return;
    try { await _channel.invokeMethod(_methodRequestNotificationPermission); } catch (e) {}
  }

  static Future<void> openAppSettings() async {
    if (!Platform.isAndroid) return;
    try { await _channel.invokeMethod(_methodOpenAppSettings); } catch (e) {}
  }

  static Future<bool> canDrawOverlays() async {
    if (!Platform.isAndroid) return true;
    try {
      final result = await _channel.invokeMethod<bool>(_methodCanDrawOverlays);
      return result ?? false;
    } catch (e) { return false; }
  }

  static Future<void> requestDisplayOverOtherApps() async {
    if (!Platform.isAndroid) return;
    try { await _channel.invokeMethod(_methodRequestDisplayOverOtherApps); } catch (e) {}
  }

  static Future<bool> checkAutoStartPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final result = await _channel.invokeMethod<bool>(_methodCheckAutoStart);
      return result ?? false;
    } catch (e) { return true; }
  }

  static Future<void> requestAutoStartPermission() async {
    if (!Platform.isAndroid) return;
    try { await _channel.invokeMethod(_methodRequestAutoStart); } catch (e) {}
  }

  static Future<bool> openRustPlusApp(String pkg) async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>(_methodOpenRustPlus, {'packageName': pkg});
      return result ?? false;
    } catch (e) { return false; }
  }

  static Future<bool> openRustPlusNotificationSettings(String pkg) async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>(_methodOpenRustPlusSettings, {'packageName': pkg});
      return result ?? false;
    } catch (e) { return false; }
  }

  static Future<bool> canUseFullScreenIntent() async {
    if (!Platform.isAndroid) return true;
    try {
      final result = await _channel.invokeMethod<bool>(_methodCanUseFullScreenIntent);
      return result ?? true;
    } catch (e) { return true; }
  }

  static Future<void> requestFullScreenIntentPermission() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod(_methodRequestFullScreenIntentPermission);
    } catch (e) { }
  }
}
