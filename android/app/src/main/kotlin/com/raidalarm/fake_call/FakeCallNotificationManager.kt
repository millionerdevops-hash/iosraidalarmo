package com.raidalarm.fake_call

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.raidalarm.R
import kotlinx.coroutines.*

object FakeCallNotificationManager {
    
    private const val NOTIFICATION_CHANNEL_ID_FAKE_CALL = FakeCallConstants.NOTIFICATION_CHANNEL_ID_FAKE_CALL
    
    private var soundPlayer: FakeCallSoundPlayer? = null
    private var fakeCallActive: Boolean = false
    private var fakeCallDurationJob: Job? = null
    
    fun setSoundPlayer(player: FakeCallSoundPlayer?): FakeCallSoundPlayer? {
        val oldPlayer = soundPlayer
        soundPlayer = player
        Log.d("FakeCallNotificationManager", "setSoundPlayer() called")
        return oldPlayer
    }
    
    fun isFakeCallActive(): Boolean {
        return fakeCallActive
    }
    
    /**
     * Start a fake call with the given duration.
     * Sets the active state and starts the duration timer.
     */
    fun startFakeCall(context: Context, duration: Long) {
        try {
            fakeCallActive = true
            Log.d("FakeCallNotificationManager", "Fake call started - active state set to true")
            
            // Start duration job
            if (duration > 0) {
                fakeCallDurationJob = CoroutineScope(Dispatchers.Main).launch {
                    delay(duration)
                    Log.d("FakeCallNotificationManager", "Fake call duration completed - $duration ms")
                    
                    // Duration finished - end fake call
                    endFakeCall(context)
                    
                    // Send broadcast to close activity
                    val closeIntent = android.content.Intent("com.raidalarm.FAKE_CALL_DURATION_FINISHED")
                    context.sendBroadcast(closeIntent)
                    Log.d("FakeCallNotificationManager", "FAKE_CALL_DURATION_FINISHED broadcast sent")
                }
                Log.d("FakeCallNotificationManager", "Fake call duration job started - $duration ms")
            }
        } catch (e: Exception) {
            Log.e("FakeCallNotificationManager", "Error starting fake call: ${e.message}", e)
        }
    }
    
    /**
     * Reset the fake call duration timer without restarting the screen or sound.
     * This is called when a new notification arrives while fake call is already active.
     */
    fun resetFakeCallDuration(context: Context, duration: Long) {
        try {
            // Cancel existing duration job
            fakeCallDurationJob?.cancel()
            Log.d("FakeCallNotificationManager", "Existing fake call duration job cancelled")
            
            // Start new duration job
            if (duration > 0) {
                fakeCallDurationJob = CoroutineScope(Dispatchers.Main).launch {
                    delay(duration)
                    Log.d("FakeCallNotificationManager", "Fake call duration reset completed - $duration ms")
                    
                    // Duration finished - end fake call
                    endFakeCall(context)
                    
                    // Send broadcast to close activity
                    val closeIntent = android.content.Intent("com.raidalarm.FAKE_CALL_DURATION_FINISHED")
                    context.sendBroadcast(closeIntent)
                    Log.d("FakeCallNotificationManager", "FAKE_CALL_DURATION_FINISHED broadcast sent after reset")
                }
                Log.d("FakeCallNotificationManager", "Fake call duration timer reset to $duration ms")
            }
        } catch (e: Exception) {
            Log.e("FakeCallNotificationManager", "Error resetting fake call duration: ${e.message}", e)
        }
    }
    
    /**
     * End the fake call and clean up resources.
     */
    fun endFakeCall(context: Context? = null) {
        try {
            // Cancel duration job
            fakeCallDurationJob?.cancel()
            fakeCallDurationJob = null
            
            // Stop sound player
            soundPlayer?.stop()
            soundPlayer = null
            
            // Clear active state
            fakeCallActive = false
            
            Log.d("FakeCallNotificationManager", "Fake call ended - state cleared")
        } catch (e: Exception) {
            Log.e("FakeCallNotificationManager", "Error ending fake call: ${e.message}", e)
        }
    }
    
    @Suppress("MissingPermission")
    fun showIncomingNotification(context: Context, data: android.os.Bundle) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                if (!notificationManager.areNotificationsEnabled()) {
                    Log.d("FakeCallNotificationManager", "areNotificationsEnabled() returned false")
                    return
                }
            }
            
            createNotificationChannel(context)
            
            val soundPlayerInstance = FakeCallSoundPlayer(context)
            setSoundPlayer(soundPlayerInstance)
            
            val notificationId = FakeCallConstants.NOTIFICATION_ID_FAKE_CALL
            val callerName = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_NAME_CALLER, "")
            val duration = data.getLong(FakeCallConstants.EXTRA_FAKE_CALL_DURATION, 0L)
            val backgroundColor = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_BACKGROUND_COLOR, "#1E1E1E")
            val actionColor = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_ACTION_COLOR, "#4CAF50")
            val textColor = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_TEXT_COLOR, "#ffffff")
            val acceptText = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_TEXT_ACCEPT, context.getString(R.string.text_accept))
            val declineText = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_TEXT_DECLINE, context.getString(R.string.text_decline))
            val subtitle = data.getString(FakeCallConstants.EXTRA_FAKE_CALL_SUBTITLE, "")
            
            data.putLong("EXTRA_TIME_START_CALL", System.currentTimeMillis())
            
            val activityIntent = FakeCallActivity.getIntent(context, data)
            
            // FLAG_IMMUTABLE: API 31+ için zorunlu, API 28-30 için önerilir
            // MinSdk 28 olduğu için direkt kullanabiliriz
            val pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            
            val fullScreenPendingIntent = PendingIntent.getActivity(
                context,
                0,
                activityIntent,
                pendingIntentFlags
            )
            Log.d("FakeCallNotificationManager", "FullScreenPendingIntent created")
            
            // KRİTİK: contentPendingIntent kaldırıldı - bildirime tıklandığında hiçbir şey olmamalı
            // Fake call ekranı zaten açık, bildirime tıklanınca ekran kapanmamalı
            // Sadece action button'lar (Accept/Decline) çalışacak
            
            val acceptPendingIntent = PendingIntent.getBroadcast(
                context,
                2,
                FakeCallBroadcastReceiver.getIntentAccept(context, data),
                pendingIntentFlags
            )
            Log.d("FakeCallNotificationManager", "AcceptPendingIntent created")
            
            val declinePendingIntent = PendingIntent.getBroadcast(
                context,
                3,
                FakeCallBroadcastReceiver.getIntentDecline(context, data),
                pendingIntentFlags
            )
            Log.d("FakeCallNotificationManager", "DeclinePendingIntent created")
            
            val timeoutPendingIntent = PendingIntent.getBroadcast(
                context,
                4,
                FakeCallBroadcastReceiver.getIntentTimeout(context, data),
                pendingIntentFlags
            )
            Log.d("FakeCallNotificationManager", "TimeoutPendingIntent created")
            
            val notificationBuilder = NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID_FAKE_CALL)
                .setSmallIcon(R.drawable.ic_stat_r)
                .setContentTitle(callerName)
                .setContentText(if (subtitle.isNotEmpty()) subtitle else "")
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setCategory(NotificationCompat.CATEGORY_CALL)
                .setFullScreenIntent(fullScreenPendingIntent, true)
                // setContentIntent kaldırıldı - bildirime tıklandığında hiçbir şey olmayacak
                .setAutoCancel(false)
                .setOngoing(true)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setDeleteIntent(timeoutPendingIntent)
                .setTimeoutAfter(duration)
                .setOnlyAlertOnce(true)
                .setSound(null)
                .setDefaults(NotificationCompat.DEFAULT_VIBRATE)
                .setVibrate(longArrayOf(0, 250, 250, 250))
                .setWhen(System.currentTimeMillis())
                .setShowWhen(true)
            
            try {
                notificationBuilder.color = Color.parseColor(actionColor)
            } catch (e: Exception) {
                Log.e("FakeCallNotificationManager", "Failed to parse action color: ${e.message}", e)
            }
            
            val notification = notificationBuilder.build()
            Log.d("FakeCallNotificationManager", "Notification built")
            
            val notificationManager = NotificationManagerCompat.from(context)
            notificationManager.notify(notificationId, notification)
            Log.d("FakeCallNotificationManager", "Notification shown - ID: $notificationId")
            
            soundPlayer?.play(data)
        } catch (e: Exception) {
            Log.e("FakeCallNotificationManager", "Error showing notification: ${e.message}", e)
        }
    }
    
    fun clearIncomingNotification(context: Context, data: android.os.Bundle, isAccepted: Boolean) {
        soundPlayer?.stop()
        Log.d("FakeCallNotificationManager", "Sound player stopped")
        
        context.sendBroadcast(FakeCallActivity.getIntentEnded(context, isAccepted))
        Log.d("FakeCallNotificationManager", "Ended broadcast sent - accepted: $isAccepted")
        
        val notificationManager = NotificationManagerCompat.from(context)
        notificationManager.cancel(FakeCallConstants.NOTIFICATION_ID_FAKE_CALL)
        Log.d("FakeCallNotificationManager", "Notification cancelled")
    }
    
    private fun createNotificationChannel(context: Context) {
        try {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                var channel = notificationManager.getNotificationChannel(NOTIFICATION_CHANNEL_ID_FAKE_CALL)
                
                if (channel == null) {
                    channel = NotificationChannel(
                        NOTIFICATION_CHANNEL_ID_FAKE_CALL,
                        context.getString(R.string.fake_call_channel_name),
                        NotificationManager.IMPORTANCE_HIGH
                    ).apply {
                        description = context.getString(R.string.fake_call_channel_description)
                        vibrationPattern = longArrayOf(0, 1000, 500, 1000, 500)
                        lightColor = Color.RED
                        enableLights(true)
                        enableVibration(true)
                        setSound(null, null)
                        lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
                    }
                    notificationManager.createNotificationChannel(channel)
                    Log.d("FakeCallNotificationManager", "Notification channel created")
                } else {
                    Log.d("FakeCallNotificationManager", "Notification channel already exists")
                }
        } catch (e: Exception) {
            Log.e("FakeCallNotificationManager", "Error creating notification channel: ${e.message}", e)
        }
    }
}
