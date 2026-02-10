package com.raidalarm

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat

object NotificationHelper {
    
    private const val CHANNEL_ID = "raidalarm_service_status"
    private const val NOTIFICATION_ID_SERVICE_DISABLED = 1001
    private const val NOTIFICATION_ID_SERVICE_ACTIVE = 1002
    private const val NOTIFICATION_ID_ATTACK_DETECTED = 1003
    
    /**
     * Bildirimlerin açık olup olmadığını kontrol eder.
     * Android 13+ için NotificationManager.areNotificationsEnabled() kullanır.
     * Android < 13 için NotificationManagerCompat.areNotificationsEnabled() kullanır.
     */
    fun areNotificationsEnabled(context: Context): Boolean {
        return try {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                // Android 13+ için
                notificationManager.areNotificationsEnabled()
            } else {
                // Android < 13 için NotificationManagerCompat kullan
                androidx.core.app.NotificationManagerCompat.from(context).areNotificationsEnabled()
            }
        } catch (e: Exception) {
            Log.e("NotificationHelper", "Error checking notification enabled: ${e.message}", e)
            false
        }
    }
    
    fun createNotificationChannel(context: Context) {
        NotificationChannelHelper.createServiceStatusChannel(context)
        Log.d("NotificationHelper", "createServiceStatusChannel() called")
    }
    
    fun showServiceDisabledNotification(context: Context) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                if (!notificationManager.areNotificationsEnabled()) {
                    Log.d("NotificationHelper", "areNotificationsEnabled() returned false")
                    return
                }
            }
            
            createNotificationChannel(context)
            
            val settingsIntent = Intent(context, MainActivity::class.java).apply {
                action = "com.raidalarm.OPEN_NOTIFICATION_SETTINGS"
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            
            // FLAG_IMMUTABLE: API 31+ için zorunlu, API 28-30 için önerilir
            // MinSdk 28 olduğu için direkt kullanabiliriz
            val pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                settingsIntent,
                pendingIntentFlags
            )
            Log.d("NotificationHelper", "PendingIntent.getActivity() called for service disabled")
            
            val largeIcon = try {
                BitmapFactory.decodeResource(context.resources, R.mipmap.ic_launcher)
            } catch (e: Exception) {
                null
            }
            if (largeIcon != null) {
                Log.d("NotificationHelper", "BitmapFactory.decodeResource() called for large icon")
            }
            
            val notificationBuilder = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(context.getString(R.string.notification_service_disabled_title))
                .setContentText(context.getString(R.string.notification_service_disabled_text))
                .setStyle(NotificationCompat.BigTextStyle()
                    .bigText(context.getString(R.string.notification_service_disabled_big_text)))
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_STATUS)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .addAction(
                    android.R.drawable.ic_menu_preferences,
                    context.getString(R.string.notification_service_disabled_action),
                    pendingIntent
                )
            
            if (largeIcon != null) {
                notificationBuilder.setLargeIcon(largeIcon)
            }
            
            val notification = notificationBuilder.build()
            
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.notify(NOTIFICATION_ID_SERVICE_DISABLED, notification)
            Log.d("NotificationHelper", "notificationManager.notify() called for service disabled")
        } catch (e: Exception) {
            Log.e("NotificationHelper", "Error showing service disabled notification: ${e.message}", e)
        }
    }
    
    fun cancelServiceDisabledNotification(context: Context) {
        try {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.cancel(NOTIFICATION_ID_SERVICE_DISABLED)
            Log.d("NotificationHelper", "notificationManager.cancel() called for service disabled")
        } catch (e: Exception) {
            Log.e("NotificationHelper", "Error canceling service disabled notification: ${e.message}", e)
        }
    }
    
    fun showServiceActiveNotification(context: Context, showHeadsUp: Boolean = false) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                if (!notificationManager.areNotificationsEnabled()) {
                    Log.d("NotificationHelper", "areNotificationsEnabled() returned false")
                    return
                }
            }
            
            if (showHeadsUp) {
                NotificationChannelHelper.createServiceStatusHeadsUpChannel(context)
                Log.d("NotificationHelper", "createServiceStatusHeadsUpChannel() called")
            } else {
                createNotificationChannel(context)
            }
            
            val homeIntent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_MAIN
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            
            // FLAG_IMMUTABLE: API 31+ için zorunlu, API 28-30 için önerilir
            // MinSdk 28 olduğu için direkt kullanabiliriz
            val pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                homeIntent,
                pendingIntentFlags
            )
            Log.d("NotificationHelper", "PendingIntent.getActivity() called for service active")
            
            val largeIcon = try {
                BitmapFactory.decodeResource(context.resources, R.mipmap.ic_launcher)
            } catch (e: Exception) {
                null
            }
            if (largeIcon != null) {
                Log.d("NotificationHelper", "BitmapFactory.decodeResource() called for large icon")
            }
            
            val channelId = if (showHeadsUp) {
                "raidalarm_service_status_headsup"
            } else {
                CHANNEL_ID
            }
            
            val notificationBuilder = NotificationCompat.Builder(context, channelId)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(context.getString(R.string.notification_service_active_title))
                .setContentText(context.getString(R.string.notification_service_active_text))
                .setStyle(NotificationCompat.BigTextStyle()
                    .bigText(context.getString(R.string.notification_service_active_text)))
                .setPriority(if (showHeadsUp) NotificationCompat.PRIORITY_MAX else NotificationCompat.PRIORITY_LOW)
                .setCategory(NotificationCompat.CATEGORY_STATUS)
                .setOngoing(true)
                .setAutoCancel(false)
                .setShowWhen(false)
                .setOnlyAlertOnce(!showHeadsUp) // Heads-up için her seferinde göster
                .setContentIntent(pendingIntent)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            
            if (showHeadsUp) {
                // Heads-up bildirim: Ses çıkar ve görünür ol
                notificationBuilder
                    .setSilent(false)
                    .setSound(android.media.RingtoneManager.getDefaultUri(android.media.RingtoneManager.TYPE_NOTIFICATION))
                    .setVibrate(longArrayOf(0, 250, 250, 250))
                    .setDefaults(NotificationCompat.DEFAULT_LIGHTS)
            } else {
                notificationBuilder.setSilent(true)
            }
            
            if (largeIcon != null) {
                notificationBuilder.setLargeIcon(largeIcon)
            }
            
            val notification = notificationBuilder.build()
            
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.notify(NOTIFICATION_ID_SERVICE_ACTIVE, notification)
            Log.d("NotificationHelper", "notificationManager.notify() called for service active")
        } catch (e: Exception) {
            Log.e("NotificationHelper", "Error showing service active notification: ${e.message}", e)
        }
    }
    
    fun cancelServiceActiveNotification(context: Context) {
        try {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.cancel(NOTIFICATION_ID_SERVICE_ACTIVE)
            Log.d("NotificationHelper", "notificationManager.cancel() called for service active")
        } catch (e: Exception) {
            Log.e("NotificationHelper", "Error canceling service active notification: ${e.message}", e)
        }
    }
    
    fun showAttackDetectedNotification(context: Context) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                if (!notificationManager.areNotificationsEnabled()) {
                    Log.d("NotificationHelper", "areNotificationsEnabled() returned false")
                    return
                }
            }
            
            NotificationChannelHelper.createAttackDetectedChannel(context)
            Log.d("NotificationHelper", "createAttackDetectedChannel() called")
            
            // KRİTİK: setContentIntent kaldırıldı - bildirime tıklandığında hiçbir şey olmayacak
            // Kullanıcı bildirime tıklayınca ekran kapanmamalı, hiçbir işlem yapılmamalı
            
            val largeIcon = try {
                BitmapFactory.decodeResource(context.resources, R.mipmap.ic_launcher)
            } catch (e: Exception) {
                null
            }
            if (largeIcon != null) {
                Log.d("NotificationHelper", "BitmapFactory.decodeResource() called for large icon")
            }
            
            val notificationBuilder = NotificationCompat.Builder(context, "raidalarm_attack_detected")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(context.getString(R.string.attack_detected_title))
                .setContentText(context.getString(R.string.attack_detected_message))
                .setPriority(NotificationCompat.PRIORITY_MAX) // Maksimum öncelik - heads-up için gerekli
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setAutoCancel(true)
                // setContentIntent YOK - bildirime tıklandığında hiçbir şey olmayacak
                .setSilent(false) // Silent false - heads-up bildirimler için gerekli
                .setSound(null) // Ses yok ama silent false - heads-up gözüksün
                .setVibrate(longArrayOf(0, 250, 250, 250))
                .setDefaults(NotificationCompat.DEFAULT_LIGHTS)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC) // Her zaman görünür
                .setOnlyAlertOnce(false) // Her bildirimde heads-up göster
            
            if (largeIcon != null) {
                notificationBuilder.setLargeIcon(largeIcon)
            }
            
            val notification = notificationBuilder.build()
            
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            // Sabit ID kullan - mevcut bildirimi güncelle, yeni bildirim oluşturma
            notificationManager.notify(NOTIFICATION_ID_ATTACK_DETECTED, notification)
            Log.d("NotificationHelper", "notificationManager.notify() called for attack detected (ID: $NOTIFICATION_ID_ATTACK_DETECTED)")
        } catch (e: Exception) {
            Log.e("NotificationHelper", "Error showing attack detected notification: ${e.message}", e)
        }
    }
    
    /**
     * Tam ekran aktivite açıldığında bildirimi heads-up olarak gösterir.
     * Bu fonksiyon, tam ekran aktivitelerde bile heads-up bildirimlerin gözükmesini sağlar.
     * 
     * @param activity Tam ekran aktivite (AlarmStopActivity veya FakeCallActivity)
     * @param delayMs Bildirimin gösterilmesi için gecikme (ms). Varsayılan: 0ms (hemen göster)
     */
    fun showAttackDetectedNotificationForFullScreenActivity(activity: android.app.Activity, delayMs: Long = 0) {
        if (delayMs <= 0) {
            try {
                showAttackDetectedNotification(activity)
                Log.d("NotificationHelper", "showAttackDetectedNotificationForFullScreenActivity() - heads-up bildirim hemen gösterildi")
            } catch (e: Exception) {
                Log.e("NotificationHelper", "Failed to show attack detected notification for full screen activity: ${e.message}", e)
            }
        } else {
            // Gecikme ile göster
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    showAttackDetectedNotification(activity)
                    Log.d("NotificationHelper", "showAttackDetectedNotificationForFullScreenActivity() - heads-up bildirim gösterildi (gecikme: ${delayMs}ms)")
                } catch (e: Exception) {
                    Log.e("NotificationHelper", "Failed to show attack detected notification for full screen activity: ${e.message}", e)
                }
            }, delayMs)
        }
    }
}
