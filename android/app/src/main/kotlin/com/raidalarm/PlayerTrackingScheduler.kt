package com.raidalarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

object PlayerTrackingScheduler {
    private const val REQUEST_CODE = 777
    private const val INTERVAL_MS = 45 * 1000L // 45 seconds

    fun startTracking(context: Context) {
        Log.d("PlayerTrackingScheduler", "startTracking() called")
        scheduleNextAlarm(context)
    }

    fun scheduleNextAlarm(context: Context) {
        try {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
            if (alarmManager == null) {
                Log.e("PlayerTrackingScheduler", "AlarmManager is null")
                return
            }

            val intent = Intent(context, PlayerTrackingReceiver::class.java)
            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
            
            val pendingIntent = PendingIntent.getBroadcast(context, REQUEST_CODE, intent, flags)
            
            // Trigger time: Now + Interval
            val triggerTime = System.currentTimeMillis() + INTERVAL_MS

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                // Doze modunda bile çalışması için
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerTime, pendingIntent)
            } else {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, triggerTime, pendingIntent)
            }
            
            Log.d("PlayerTrackingScheduler", "Next check scheduled in ${INTERVAL_MS/1000} seconds")
        } catch (e: Exception) {
            Log.e("PlayerTrackingScheduler", "Error scheduling alarm: ${e.message}", e)
        }
    }

    fun stopTracking(context: Context) {
        try {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
            val intent = Intent(context, PlayerTrackingReceiver::class.java)
            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
            
            val pendingIntent = PendingIntent.getBroadcast(context, REQUEST_CODE, intent, flags)
            
            alarmManager?.cancel(pendingIntent)
            Log.d("PlayerTrackingScheduler", "Tracking stopped/cancelled")
        } catch (e: Exception) {
            Log.e("PlayerTrackingScheduler", "Error stopping tracking: ${e.message}", e)
        }
    }
}
