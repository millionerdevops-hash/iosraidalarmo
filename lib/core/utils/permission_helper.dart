import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/data/repositories/settings_repository.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/services/permission_service.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/data/database/permission_types.dart';

final permissionHelperProvider = Provider((ref) => PermissionHelper.instance);

class PermissionHelper {
  static final PermissionHelper instance = PermissionHelper._();
  PermissionHelper._();

  static const int _android13 = 33;

  static Future<bool> checkNotificationPermission({bool force = false}) async {
    try {
      final db = AppDatabase();
      if (!force) {
        final cachedState = await db.getPermissionState(PermissionTypes.notificationPermission);
        final isCacheValid = await db.isPermissionCacheValid(PermissionTypes.notificationPermission);
        if (cachedState != null && isCacheValid) {
          return cachedState;
        }
      }
      
      final status = await Permission.notification.status;
      final result = status.isGranted;
      
      await db.savePermissionState(PermissionTypes.notificationPermission, result);
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (e) { return false; }
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  static Future<bool> checkCriticalAlertsPermission() async {
    if (Platform.isIOS) {
      final status = await Permission.criticalAlerts.status;
      return status.isGranted;
    }
    return true;
  }

  static Future<bool> requestCriticalAlertsPermission() async {
    if (Platform.isIOS) {
      final status = await Permission.criticalAlerts.request();
      return status.isGranted;
    }
    return true;
  }

  static Future<bool> checkAllCriticalPermissions(dynamic ref) async {
    final results = await Future.wait([
      checkNotificationPermission(force: true),
      checkCriticalAlertsPermission(),
    ]);
    return results.every((r) => r == true);
  }
}
