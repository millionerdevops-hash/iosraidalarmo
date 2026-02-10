import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
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

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  static const int _android6 = 23;
  static const int _android12 = 31;
  static const int _android13 = 33;
  static const int _android14 = 34;

  static Future<bool> checkNotificationPermission({bool force = false}) async {
    if (!Platform.isAndroid) return true;

    try {
      final db = AppDatabase();
      if (!force) {
        final cachedState = await db.getPermissionState(PermissionTypes.notificationPermission);
        final isCacheValid = await db.isPermissionCacheValid(PermissionTypes.notificationPermission);
        if (cachedState != null && isCacheValid) {
          return cachedState;
        }
      }
      
      final result = await PermissionService.checkNotificationEnabled();
      await db.savePermissionState(PermissionTypes.notificationPermission, result);
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final androidInfo = await _deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= _android13) {
        await PermissionService.requestNotificationPermission();
      } else {
        await PermissionService.openAppSettings();
      }
      return false;
    } catch (e) { return false; }
  }

  static Future<void> openAppSettings() async {
    await PermissionService.openAppSettings();
  }

  static Future<bool> checkNotificationListenerService(dynamic ref, {bool force = false}) async {
    // NotificationListenerService is removed, so we don't need this permission check
    return true;
  }

  static Future<void> openNotificationListenerSettings(Ref ref) async {
    await openAppSettings();
  }

  static Future<bool> checkBatteryOptimization() async {
    if (!Platform.isAndroid) return true;

    try {
      // IMPORTANT: Do NOT cache this permission!
      // isIgnoringBatteryOptimizations() can be unreliable on Xiaomi/MIUI
      // It may return false even after user grants exemption due to MIUI's
      // aggressive battery management. Always check fresh state.
      
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      bool result;
      if (sdkInt >= _android6) {
        result = await PermissionService.checkBatteryOptimization();
      } else {
        result = true;
      }
      return result;
    } catch (e) {
      return false;
    }
  }


  static Future<bool> requestBatteryOptimization() async {
    if (!Platform.isAndroid) return true;

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= _android6) {
        return await PermissionService.requestBatteryOptimizationExemption();
      }
      return true;
    } catch (e) {
      // Battery optimization request failed, continue silently
      return false;
    }
  }

  static Future<bool> shouldShowBatteryOptimization() async {
    if (!Platform.isAndroid) return false;
    final androidInfo = await _deviceInfo.androidInfo;
    // Battery optimizations (Doze mode) started from Android 6.0 (API 23)
    return androidInfo.version.sdkInt >= _android6;
  }

  static Future<bool> checkDisplayOverOtherApps() async {
    if (!Platform.isAndroid) return true;

    try {
      // IMPORTANT: Do NOT cache this permission!
      // canDrawOverlays() can be unreliable on Xiaomi/MIUI
      // - May return false even after user grants permission (requires app restart)
      // - MIUI can auto-enable/disable this permission
      // - Inconsistent behavior across MIUI versions
      // Always check fresh state to ensure accuracy.
      
      final result = await PermissionService.canDrawOverlays();
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> requestDisplayOverOtherApps() async {
    if (!Platform.isAndroid) return true;
    try {
      if (await checkDisplayOverOtherApps()) return true;
      await PermissionService.requestDisplayOverOtherApps();
      return false;
    } catch (e) { return false; }
  }

  static Future<bool> shouldShowNotificationPermission() async {
    if (!Platform.isAndroid) return false;

    try {
      final androidInfo = await _deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      // Android 13+ için notification permission runtime permission olarak gösterilir
      return sdkInt >= _android13;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> shouldShowDisplayOverOtherApps() async {
    if (!Platform.isAndroid) return false;
    final androidInfo = await _deviceInfo.androidInfo;
    // System Alert Window (Overlay) permission started from Android 6.0 (API 23)
    return androidInfo.version.sdkInt >= _android6;
  }

  static Future<bool> checkExactAlarmPermission({bool force = false}) async {
    if (!Platform.isAndroid) return true;

    try {
      final db = AppDatabase();
      if (!force) {
        final cachedState = await db.getPermissionState(PermissionTypes.exactAlarm);
        final isCacheValid = await db.isPermissionCacheValid(PermissionTypes.exactAlarm);
        if (cachedState != null && isCacheValid) {
          return cachedState;
        }
      }
      
      final result = await PermissionService.checkExactAlarmPermission();
      await db.savePermissionState(PermissionTypes.exactAlarm, result);
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final androidInfo = await _deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= _android12) {
        await PermissionService.requestExactAlarmPermission();
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }


  static Future<bool> shouldShowExactAlarm() async {
    if (!Platform.isAndroid) return false;
    final androidInfo = await _deviceInfo.androidInfo;
    // Exact alarm permission is required from Android 12 (API 31)
    return androidInfo.version.sdkInt >= _android12;
  }

  static Future<bool> openRustPlusApp({String packageName = 'com.facepunch.rust.companion'}) async {
    return await PermissionService.openRustPlusApp(packageName);
  }

  static Future<bool> openRustPlusNotificationSettings({String packageName = 'com.facepunch.rust.companion'}) async {
    return await PermissionService.openRustPlusNotificationSettings(packageName);
  }

  /// Autostart izni kontrolü - sadece agresif battery optimization yapan cihazlarda
  /// NOT: AutoStart iznini Android'de programatik olarak kontrol etmenin güvenilir bir yolu yok!
  /// Bu yüzden her zaman TRUE döndürüyoruz. Kullanıcı manuel olarak ayarlardan kontrol etmeli.
  static Future<bool> checkAutoStartPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      // Sadece problematik cihazlarda göster, diğerlerinde her zaman true
      if (!await shouldShowAutoStart()) {
        return true;
      }
      
      // AutoStart iznini kontrol etmenin güvenilir bir yolu yok
      // Her zaman true döndür (kullanıcı izni verdiğini varsay)
      // Eğer izin verilmemişse, uygulama background'da çalışmayabilir
      // ama bu kullanıcının sorumluluğunda
      return true;
    } catch (e) {
      return true; 
    }
  }

  /// Autostart izni isteği - sadece agresif battery optimization yapan cihazlarda
  /// Kullanıcıyı manufacturer-specific ayarlar sayfasına yönlendirir
  static Future<bool> requestAutoStartPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      if (!await shouldShowAutoStart()) return true;
      
      // AutoStart ayarlar sayfasını aç
      // Kullanıcı izni verip vermediğini kontrol edemeyiz, sadece ayarları açabiliriz
      await PermissionService.requestAutoStartPermission();
      
      // Her zaman false döndür (kullanıcı ayarlardan döndü ama izin durumunu bilemiyoruz)
      // setupready.dart'taki polling mekanizması bunu handle edecek
      return false;
    } catch (e) { 
      return false; 
    }
  }

  /// Autostart izninin gösterilip gösterilmeyeceğini kontrol et
  /// Sadece agresif battery optimization yapan cihazlarda göster
  static Future<bool> shouldShowAutoStart() async {
    if (!Platform.isAndroid) return false;

    try {
      final androidInfo = await _deviceInfo.androidInfo;
      final manufacturer = androidInfo.manufacturer.toLowerCase();
      final brand = androidInfo.brand.toLowerCase();
      
      // Agresif battery optimization yapan cihaz markaları
      final problematicBrands = [
        'xiaomi',
        'huawei', 
        'honor',
        'oppo',
        'vivo',
        'oneplus',
        'realme',
        'letv',
        'leeco',
        'asus',
        'nokia', // HMD Global
        'meizu',
        'doogee',
        'oukitel',
      ];
      
      // Manufacturer veya brand kontrolü
      for (final problematicBrand in problematicBrands) {
        if (manufacturer.contains(problematicBrand) || brand.contains(problematicBrand)) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkFullScreenIntentPermission({bool force = false}) async {
    if (!Platform.isAndroid) return true;

    try {
      final db = AppDatabase();
      if (!force) {
        final cachedState = await db.getPermissionState(PermissionTypes.fullScreenIntent);
        final isCacheValid = await db.isPermissionCacheValid(PermissionTypes.fullScreenIntent);
        if (cachedState != null && isCacheValid) {
          return cachedState;
        }
      }
      
      final result = await PermissionService.canUseFullScreenIntent();
      await db.savePermissionState(PermissionTypes.fullScreenIntent, result);
      return result;
    } catch (e) {
      return true;
    }
  }

  static Future<void> requestFullScreenIntentPermission() async {
    if (!Platform.isAndroid) return;
    try {
      await PermissionService.requestFullScreenIntentPermission();
    } catch (e) { }
  }

  static Future<bool> shouldShowFullScreenIntent() async {
    if (!Platform.isAndroid) return false;
    final androidInfo = await _deviceInfo.androidInfo;
    // Full screen intent permission management is introduced in Android 14 (API 34)
    return androidInfo.version.sdkInt >= _android14;
  }

  static Future<bool> checkAllCriticalPermissions(dynamic ref) async {
    final results = await Future.wait([
      checkNotificationPermission(force: true),
      checkNotificationListenerService(ref, force: true),
      shouldShowBatteryOptimization().then((show) => show ? checkBatteryOptimization() : Future.value(true)),
      shouldShowDisplayOverOtherApps().then((show) => show ? checkDisplayOverOtherApps() : Future.value(true)),
      shouldShowExactAlarm().then((show) => show ? checkExactAlarmPermission(force: true) : Future.value(true)),
      shouldShowAutoStart().then((show) => show ? checkAutoStartPermission() : Future.value(true)),
      shouldShowFullScreenIntent().then((show) => show ? checkFullScreenIntentPermission(force: true) : Future.value(true)),
    ]);
    return results.every((r) => r == true);
  }
}
