package com.raidalarm

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat

class AlarmForegroundService : Service() {
    
    private var wakeLock: PowerManager.WakeLock? = null
    
    companion object {
        private const val NOTIFICATION_ID = 10000
        private const val CHANNEL_ID = "alarm_foreground_service_channel"
        
        fun startAndLaunchActivity(
            context: Context,
            action: String,
            extras: android.os.Bundle? = null
        ) {
            val serviceIntent = Intent(context, AlarmForegroundService::class.java).apply {
                this.action = action
                if (extras != null) {
                    putExtras(extras)
                }
            }
            Log.d("AlarmForegroundService", "Intent created - action: $action")
            
            context.startForegroundService(serviceIntent)
            Log.d("AlarmForegroundService", "startForegroundService() called")
        }
    }
    
    override fun onCreate() {
        super.onCreate()
        
        createNotificationChannel()
        acquireWakeLock()
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent == null) {
            Log.w("AlarmForegroundService", "onStartCommand - intent is null, stopping service")
            stopSelf()
            return START_NOT_STICKY
        }

        val notification = createNotification()
        Log.d("AlarmForegroundService", "createNotification() called")
        startForeground(NOTIFICATION_ID, notification)
        Log.d("AlarmForegroundService", "startForeground() called")
        
        val activityIntent = Intent(this, MainActivity::class.java).apply {
            this.action = intent.action
            this.flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            if (intent.extras != null) {
                putExtras(intent.extras!!)
            }
            if (!hasExtra("intent_timestamp")) {
                putExtra("intent_timestamp", System.currentTimeMillis())
            }
        }
        Log.d("AlarmForegroundService", "Intent created - MainActivity")
        
        try {
            startActivity(activityIntent)
            Log.d("AlarmForegroundService", "startActivity() called")
            
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                try {
                    ActivityUtils.moveActivityToFront(this, delayMs = 0, logTag = "AlarmForegroundService")
                    Log.d("AlarmForegroundService", "ActivityUtils.moveActivityToFront() called - attempt 1")
                } catch (e: Exception) {
                    Log.e("AlarmForegroundService", "Error moving activity to front (attempt 1): ${e.message}", e)
                }
            }, 200)
            Log.d("AlarmForegroundService", "postDelayed() called - attempt 1")
            
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                try {
                    ActivityUtils.moveActivityToFront(this, delayMs = 0, logTag = "AlarmForegroundService")
                    Log.d("AlarmForegroundService", "ActivityUtils.moveActivityToFront() called - attempt 2")
                } catch (e: Exception) {
                    Log.e("AlarmForegroundService", "Error moving activity to front (attempt 2): ${e.message}", e)
                }
            }, 500)
            Log.d("AlarmForegroundService", "postDelayed() called - attempt 2")
        } catch (e: Exception) {
            Log.e("AlarmForegroundService", "Error in onStartCommand: ${e.message}", e)
        }
        
        return START_STICKY
    }
    
    override fun onDestroy() {
        super.onDestroy()
        Log.d("AlarmForegroundService", "onDestroy() called")
        releaseWakeLock()
        // Servis öldüğünde alarmı durdur (Eğer hala çalıyorsa)
        try {
            if (AlarmHelper.isAlarmPlaying()) {
                Log.d("AlarmForegroundService", "Alarm is still playing in onDestroy, stopping it")
                AlarmHelper.stopSystemAlarm()
            }
        } catch (e: Exception) {
            Log.e("AlarmForegroundService", "Error stopping alarm in onDestroy: ${e.message}")
        }
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        Log.d("AlarmForegroundService", "onTaskRemoved() called - App swiped away")
        // Uygulama son uygulamalardan kapatıldığında alarmı durdur
        try {
            AlarmHelper.stopSystemAlarm(this)
            Log.d("AlarmForegroundService", "stopSystemAlarm() called in onTaskRemoved")
        } catch (e: Exception) {
            Log.e("AlarmForegroundService", "Error stopping alarm in onTaskRemoved: ${e.message}")
        }
        stopSelf()
    }
    
    override fun onBind(intent: Intent?): IBinder? = null
    
    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            getString(R.string.channel_name_alarm_service),
            NotificationManager.IMPORTANCE_NONE
        ).apply {
            description = getString(R.string.channel_description_alarm_service)
            setShowBadge(false)
            enableLights(false)
            enableVibration(false)
            setSound(null, null)
        }
        Log.d("AlarmForegroundService", "NotificationChannel created")
        
        val notificationManager = getSystemService(NotificationManager::class.java)
        Log.d("AlarmForegroundService", "getSystemService(NotificationManager) called")
        notificationManager.createNotificationChannel(channel)
        Log.d("AlarmForegroundService", "createNotificationChannel() called")
    }
    
    private fun createNotification(): android.app.Notification {
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(getString(R.string.alarm_stop_title))
            .setContentText(getString(R.string.alarm_triggering))
            .setSmallIcon(R.drawable.ic_stat_r)
            // PRIORITY_MIN kullan: Kullanıcıya gösterilmemeli, sadece sistem için gerekli
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .setOngoing(false)
            .build()
        Log.d("AlarmForegroundService", "NotificationCompat.Builder().build() called")
        return notification
    }
    
    private fun acquireWakeLock() {
        try {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            Log.d("AlarmForegroundService", "getSystemService(POWER_SERVICE) called")
            wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "RaidAlarm::ForegroundServiceWakeLock"
            )
            Log.d("AlarmForegroundService", "newWakeLock() called")
            // WakeLock süresini optimize et: 10 dakika yerine 3 dakika yeterli
            // Alarm tetikleme işlemi genellikle 1-2 dakika içinde tamamlanır
            wakeLock?.acquire(3 * 60 * 1000L)
            Log.d("AlarmForegroundService", "wakeLock.acquire() called - 3 minutes timeout")
        } catch (e: Exception) {
            Log.e("AlarmForegroundService", "Error acquiring wake lock: ${e.message}", e)
        }
    }
    
    private fun releaseWakeLock() {
        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
                Log.d("AlarmForegroundService", "wakeLock.release() called")
                wakeLock = null
            }
        } catch (e: Exception) {
            Log.e("AlarmForegroundService", "Error releasing wake lock: ${e.message}", e)
            wakeLock = null
        }
    }
    
    fun stopService() {
        stopSelf()
        Log.d("AlarmForegroundService", "stopSelf() called")
    }
}
