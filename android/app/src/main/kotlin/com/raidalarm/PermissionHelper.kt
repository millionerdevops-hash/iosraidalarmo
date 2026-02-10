package com.raidalarm

import android.app.Activity
import android.app.AlarmManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import android.app.NotificationManager

object PermissionHelper {
    const val REQUEST_CODE_OVERLAY_PERMISSION = 1002
    
    fun canScheduleExactAlarms(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val result = alarmManager.canScheduleExactAlarms()
            Log.d("PermissionHelper", "canScheduleExactAlarms() called: $result")
            return result
        }
        Log.d("PermissionHelper", "canScheduleExactAlarms() called: true (API < 31)")
        return true
    }

    /**
     * Uygulama ayarları sayfasını açar
     */
    fun openAppSettings(activity: Activity) {
        try {
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.fromParts("package", activity.packageName, null)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            activity.startActivity(intent)
            Log.d("PermissionHelper", "openAppSettings() called")
        } catch (e: Exception) {
            Log.e("PermissionHelper", "Error opening app settings: ${e.message}")
        }
    }

    /**
     * Bildirim izni isteği (Android 13+)
     */
    fun requestNotificationPermission(activity: Activity, requestCode: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.requestPermissions(
                arrayOf(android.Manifest.permission.POST_NOTIFICATIONS),
                requestCode
            )
            Log.d("PermissionHelper", "requestPermissions() called for POST_NOTIFICATIONS")
        } else {
            // Android < 13 için izin diyalogu yok, direkt ayarlara yönlendir
            openAppSettings(activity)
        }
    }
    
    fun requestExactAlarmPermission(activity: Activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = activity.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            if (!alarmManager.canScheduleExactAlarms()) {
                val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                    data = Uri.parse("package:${activity.packageName}")
                }
                activity.startActivity(intent)
                Log.d("PermissionHelper", "startActivity() called for exact alarm permission")
            } else {
                Log.d("PermissionHelper", "canScheduleExactAlarms() returned true - no need to request")
            }
        } else {
            Log.d("PermissionHelper", "requestExactAlarmPermission() skipped (API < 31)")
        }
    }
    
    fun requestBatteryOptimizationExemption(activity: Activity): Boolean {
        val powerManager = activity.getSystemService(Context.POWER_SERVICE) as PowerManager
        val packageName = activity.packageName
        
        if (!powerManager.isIgnoringBatteryOptimizations(packageName)) {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                data = Uri.parse("package:$packageName")
            }
            activity.startActivity(intent)
            Log.d("PermissionHelper", "startActivity() called for battery optimization")
            return false
        }
        
        Log.d("PermissionHelper", "isIgnoringBatteryOptimizations() returned true")
        return true
    }
    
    fun isIgnoringBatteryOptimizations(context: Context): Boolean {
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val result = powerManager.isIgnoringBatteryOptimizations(context.packageName)
        Log.d("PermissionHelper", "isIgnoringBatteryOptimizations() called: $result")
        return result
    }
    
    fun canDrawOverlays(context: Context): Boolean {
        val result = Settings.canDrawOverlays(context)
        Log.d("PermissionHelper", "canDrawOverlays() called: $result")
        return result
    }
    
    fun requestDisplayOverOtherAppsPermission(activity: Activity, requestCode: Int = REQUEST_CODE_OVERLAY_PERMISSION): Boolean {
        if (Settings.canDrawOverlays(activity)) {
            Log.d("PermissionHelper", "canDrawOverlays() returned true")
            return true
        }
        
        val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION).apply {
            data = Uri.parse("package:${activity.packageName}")
        }
        activity.startActivity(intent)
        Log.d("PermissionHelper", "startActivity() called for overlay permission")
        return false
    }
    
    /**
     * AutoStart izni kontrolü - gerçek kontrol yapılamaz
     */
    fun checkAutoStartPermission(context: Context): Boolean {
        Log.d("PermissionHelper", "checkAutoStartPermission() called: true")
        return true
    }
    
    /**
     * AutoStart izni isteği - ayarlara yönlendirir
     */
    fun requestAutoStartPermission(activity: Activity) {
        val packageName = activity.packageName
        val manufacturer = Build.MANUFACTURER.lowercase()
        
        try {
            val intent = when {
                manufacturer.contains("xiaomi") || manufacturer.contains("redmi") -> {
                    Intent().setComponent(ComponentName(
                        "com.miui.securitycenter",
                        "com.miui.permcenter.autostart.AutoStartManagementActivity"
                    ))
                }
                manufacturer.contains("huawei") || manufacturer.contains("honor") -> {
                    Intent().setComponent(ComponentName(
                        "com.huawei.systemmanager",
                        "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"
                    ))
                }
                manufacturer.contains("oppo") -> {
                    Intent().setComponent(ComponentName(
                        "com.coloros.safecenter",
                        "com.coloros.safecenter.permission.startup.StartupAppListActivity"
                    ))
                }
                manufacturer.contains("vivo") -> {
                    Intent().setComponent(ComponentName(
                        "com.vivo.permissionmanager",
                        "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"
                    ))
                }
                manufacturer.contains("oneplus") -> {
                    Intent().setComponent(ComponentName(
                        "com.oneplus.security",
                        "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity"
                    ))
                }
                manufacturer.contains("realme") -> {
                    Intent().setComponent(ComponentName(
                        "com.coloros.safecenter",
                        "com.coloros.safecenter.permission.startup.StartupAppListActivity"
                    ))
                }
                manufacturer.contains("asus") -> {
                    Intent().setComponent(ComponentName(
                        "com.asus.mobilemanager",
                        "com.asus.mobilemanager.powersaver.PowerSaverSettings"
                    ))
                }
                manufacturer.contains("meizu") -> {
                    Intent().setComponent(ComponentName(
                        "com.meizu.safe",
                        "com.meizu.safe.permission.SmartBGAppStartActivity"
                    ))
                }
                else -> null
            }
            
            if (intent != null) {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                activity.startActivity(intent)
                Log.d("PermissionHelper", "requestAutoStartPermission() opened for: $manufacturer")
                return
            }
        } catch (e: Exception) {
            Log.d("PermissionHelper", "Manufacturer-specific intent failed: ${e.message}")
        }
        
        // Fallback: Uygulama detay ayarlarına git
        openAppSettings(activity)
    }

    /**
     * Check if the app can use full screen intents (Android 14+)
     */
    fun canUseFullScreenIntent(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            return notificationManager.canUseFullScreenIntent()
        }
        return true
    }

    /**
     * Request full screen intent permission (Android 14+)
     */
    fun requestFullScreenIntentPermission(activity: Activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                data = Uri.parse("package:${activity.packageName}")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            activity.startActivity(intent)
        }
    }
}
