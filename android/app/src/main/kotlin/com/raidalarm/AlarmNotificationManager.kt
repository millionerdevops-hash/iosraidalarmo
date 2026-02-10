package com.raidalarm

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat

object AlarmNotificationManager {
    private const val ALARM_CHANNEL_ID = "rust_alarm_active_channel"
    private const val ALARM_NOTIFICATION_ID = 9999
    
    fun createAlarmNotificationChannel(context: Context) {
        NotificationChannelHelper.createAlarmChannel(context)
        Log.d("AlarmNotificationManager", "NotificationChannelHelper.createAlarmChannel() called")
    }
    
    fun showAlarmNotification(context: Context, intent: Intent) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                Log.d("AlarmNotificationManager", "getSystemService(NOTIFICATION_SERVICE) called")
                if (!notificationManager.areNotificationsEnabled()) {
                    Log.d("AlarmNotificationManager", "areNotificationsEnabled() returned false")
                    return
                }
            }
            
            val isReallyForeground = ActivityUtils.isAppReallyInForeground(context)
            Log.d("AlarmNotificationManager", "isAppReallyInForeground() called: $isReallyForeground")
            if (isReallyForeground) {
                return
            }
            
            val isLocked = isPhoneLocked(context)
            Log.d("AlarmNotificationManager", "isPhoneLocked() called: $isLocked")
            
            // Activity zaten direkt açılıyor, sadece normal notification göster
            showNormalNotification(context, intent)
            Log.d("AlarmNotificationManager", "showNormalNotification() called")
        } catch (e: Exception) {
            Log.e("AlarmNotificationManager", "Error showing alarm notification: ${e.message}", e)
            throw e
        }
    }
    
    private fun showNormalNotification(context: Context, intent: Intent) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                Log.d("AlarmNotificationManager", "getSystemService(NOTIFICATION_SERVICE) called")
                if (!notificationManager.areNotificationsEnabled()) {
                    Log.d("AlarmNotificationManager", "areNotificationsEnabled() returned false")
                    return
                }
            }
            
            createAlarmNotificationChannel(context)
            
            val isReallyForeground = ActivityUtils.isAppReallyInForeground(context)
            Log.d("AlarmNotificationManager", "isAppReallyInForeground() called: $isReallyForeground")
            val shouldShowActionButton = !isReallyForeground
            
            // FLAG_IMMUTABLE: API 31+ için zorunlu, API 28-30 için önerilir
            // MinSdk 28 olduğu için direkt kullanabiliriz
            val pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            
            // Full Screen Intent setup
            val fullScreenIntent = Intent(context, AlarmStopActivity::class.java).apply {
                action = "com.raidalarm.OPEN_ALARM_STOP"
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS
            }
            
            val fullScreenPendingIntent = PendingIntent.getActivity(
                context,
                0,
                fullScreenIntent,
                pendingIntentFlags
            )
            Log.d("AlarmNotificationManager", "fullScreenPendingIntent created")
            
            // KRİTİK: contentPendingIntent kaldırıldı - bildirime tıklandığında hiçbir şey olmamalı
            // Alarm stop screen zaten açık, bildirime tıklanınca ekran kapanmamalı
            // Sadece action button (Dismiss) çalışacak
            
            val notificationBuilder = NotificationCompat.Builder(context, ALARM_CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_stat_r)
                .setContentTitle(context.getString(R.string.alarm_stop_title))
                .setContentText(context.getString(R.string.alarm_playing))
                .setStyle(NotificationCompat.BigTextStyle().bigText(context.getString(R.string.alarm_playing)))
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setFullScreenIntent(fullScreenPendingIntent, true)
                // setContentIntent kaldırıldı - bildirime tıklandığında hiçbir şey olmayacak
                .setAutoCancel(true)
                .setOngoing(true)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setDefaults(NotificationCompat.DEFAULT_VIBRATE)
                .setSound(null)
                .setVibrate(longArrayOf(0, 250, 250, 250))
                .setWhen(System.currentTimeMillis() - 1) // Biraz önceye al - en üstte görünsün
                .setShowWhen(true)
                .setSortKey("000") // Alfabetik sıralama - en üstte görünsün (0 en başta gelir)
            Log.d("AlarmNotificationManager", "NotificationCompat.Builder() created")
            
            if (shouldShowActionButton) {
                val dismissIntent = Intent(context, MainActivity::class.java).apply {
                    action = "com.raidalarm.DISMISS_ALARM"
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP
                }
                Log.d("AlarmNotificationManager", "Intent created - DISMISS_ALARM")
                
                val dismissPendingIntent = PendingIntent.getActivity(
                    context,
                    1,
                    dismissIntent,
                    pendingIntentFlags
                )
                Log.d("AlarmNotificationManager", "PendingIntent.getActivity() called - dismissPendingIntent")
                
                notificationBuilder.addAction(
                    android.R.drawable.ic_menu_close_clear_cancel,
                    context.getString(R.string.alarm_stop_button),
                    dismissPendingIntent
                )
                Log.d("AlarmNotificationManager", "notificationBuilder.addAction() called")
            }
            
            val notification = notificationBuilder.build()
            Log.d("AlarmNotificationManager", "notificationBuilder.build() called")
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.notify(ALARM_NOTIFICATION_ID, notification)
            Log.d("AlarmNotificationManager", "notificationManager.notify() called")
        } catch (e: Exception) {
            Log.e("AlarmNotificationManager", "Error showing alarm notification: ${e.message}", e)
            throw e
        }
    }
    
    private fun isPhoneLocked(context: Context): Boolean {
        val result = DeviceStateHelper.isPhoneLocked(context, "AlarmNotificationManager")
        Log.d("AlarmNotificationManager", "DeviceStateHelper.isPhoneLocked() called: $result")
        return result
    }
    
    fun dismissAlarmNotification(context: Context) {
        try {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            Log.d("AlarmNotificationManager", "getSystemService(NOTIFICATION_SERVICE) called")
            notificationManager.cancel(ALARM_NOTIFICATION_ID)
            Log.d("AlarmNotificationManager", "notificationManager.cancel() called")
        } catch (e: Exception) {
            Log.e("AlarmNotificationManager", "Error dismissing alarm notification: ${e.message}", e)
        }
    }
}
