package com.raidalarm

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.RingtoneManager
import android.net.Uri
import android.util.Log

object NotificationChannelHelper {
    
    fun createAlarmChannel(context: Context) {
        createChannel(
            context = context,
            channelId = "rust_alarm_active_channel",
            channelName = context.getString(R.string.channel_name_alarm),
            description = context.getString(R.string.channel_description_alarm),
            importance = NotificationManager.IMPORTANCE_MAX
        )
    }
    
    fun createServiceStatusChannel(context: Context) {
        createChannel(
            context = context,
            channelId = "raidalarm_service_status",
            channelName = context.getString(R.string.channel_name_service_status),
            description = context.getString(R.string.channel_description_service_status),
            importance = NotificationManager.IMPORTANCE_MIN
        )
    }
    
    fun createServiceStatusHeadsUpChannel(context: Context) {
        createChannel(
            context = context,
            channelId = "raidalarm_service_status_headsup",
            channelName = context.getString(R.string.channel_name_service_status),
            description = context.getString(R.string.channel_description_service_status_headsup),
            importance = NotificationManager.IMPORTANCE_MAX
        )
    }
    
    fun createAttackDetectedChannel(context: Context) {
        createChannel(
            context = context,
            channelId = "raidalarm_attack_detected",
            channelName = context.getString(R.string.channel_name_attack_detected),
            description = context.getString(R.string.channel_description_attack_detected),
            importance = NotificationManager.IMPORTANCE_MAX
        )
    }

    fun createPlayerTrackingChannel(context: Context) {
        createChannel(
            context = context,
            channelId = "raidalarm_player_tracking",
            channelName = context.getString(R.string.channel_name_player_tracking),
            description = context.getString(R.string.channel_description_player_tracking),
            importance = NotificationManager.IMPORTANCE_HIGH
        )
    }
    
    private fun createChannel(
        context: Context,
        channelId: String,
        channelName: String,
        description: String,
        importance: Int
    ) {
        try {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            
            // Mevcut channel varsa tekrar oluşturma
            val existingChannel = notificationManager.getNotificationChannel(channelId)
            if (existingChannel != null) {
                Log.d("NotificationChannelHelper", "Channel already exists: $channelId")
                return
            }
            
            val channel = NotificationChannel(
                channelId,
                channelName,
                importance
            ).apply {
                this.description = description
                
                if (importance == NotificationManager.IMPORTANCE_MIN) {
                    // Minimum önem: sessiz, titreşim yok, badge yok
                    enableLights(false)
                    enableVibration(false)
                    setShowBadge(false)
                } else {
                    // Yüksek önem: ışık, badge açık
                    enableLights(true)
                    setShowBadge(true)
                    
                    when (channelId) {
                        "raidalarm_attack_detected" -> {
                            // Saldırı tespit edildi: titreşim, DND bypass, lockscreen'de göster
                            enableVibration(true)
                            setSound(null, null)
                            setBypassDnd(true)
                            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                        }
                        "raidalarm_service_status_headsup" -> {
                            // Heads-up bildirim: titreşim, ses, DND bypass, lockscreen'de göster
                            enableVibration(true)
                            val defaultSoundUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                            setSound(defaultSoundUri, null)
                            setBypassDnd(true)
                            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                        }
                        "raidalarm_player_tracking" -> {
                             enableVibration(true)
                             val defaultSoundUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                             setSound(defaultSoundUri, null)
                             lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                        }
                        else -> {
                            // Diğer yüksek önemli kanallar: titreşim
                            enableVibration(true)
                        }
                    }
                }
            }
            
            notificationManager.createNotificationChannel(channel)
            Log.d("NotificationChannelHelper", "NotificationChannel created: $channelId")
        } catch (e: Exception) {
            Log.e("NotificationChannelHelper", "Error creating notification channel ($channelId): ${e.message}", e)
        }
    }
}
