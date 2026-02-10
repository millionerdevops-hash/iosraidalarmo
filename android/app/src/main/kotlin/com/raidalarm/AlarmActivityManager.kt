package com.raidalarm

import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

object AlarmActivityManager {
    private var foregroundCheckJob: Job? = null
    private var currentContext: Context? = null
    
    private var notificationMethodChannel: MethodChannel? = null
    
    fun setNotificationMethodChannel(channel: MethodChannel?) {
        notificationMethodChannel = channel
        Log.d("AlarmActivityManager", "setNotificationMethodChannel() called - channel: ${if (channel != null) "set" else "null"}")
    }
    
    fun openAlarmStopScreen(context: Context) {
        try {
            val isReallyForeground = ActivityUtils.isAppReallyInForeground(context)
            Log.d("AlarmActivityManager", "isAppReallyInForeground() called: $isReallyForeground")
            
            val isLocked = isPhoneLocked(context)
            Log.d("AlarmActivityManager", "isPhoneLocked() called: $isLocked")
            
            if (!PermissionHelper.canDrawOverlays(context)) {
                Log.d("AlarmActivityManager", "canDrawOverlays() returned false")
                return
            }
            
            if (isReallyForeground) {
                openNativeAlarmStopActivity(context)
                Log.d("AlarmActivityManager", "openNativeAlarmStopActivity() called (directly from foreground)")
            } else {
                Log.d("AlarmActivityManager", "App is in background - full screen intent from notification will handle activity start")
            }
        } catch (e: Exception) {
            Log.e("AlarmActivityManager", "Error opening alarm stop screen: ${e.message}", e)
        }
    }
    
    private fun openNativeAlarmStopActivity(context: Context) {
        try {
            val intent = Intent(context, AlarmStopActivity::class.java).apply {
                action = "com.raidalarm.OPEN_ALARM_STOP"
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS
            }
            Log.d("AlarmActivityManager", "Intent created - OPEN_ALARM_STOP")
            
            val isReallyForeground = ActivityUtils.isAppReallyInForeground(context)
            Log.d("AlarmActivityManager", "isAppReallyInForeground() called: $isReallyForeground")
            val isLocked = isPhoneLocked(context)
            Log.d("AlarmActivityManager", "isPhoneLocked() called: $isLocked")
            
            if (isReallyForeground) {
                context.startActivity(intent)
                Log.d("AlarmActivityManager", "startActivity() called")
                ActivityUtils.moveActivityToFront(context, delayMs = 200, logTag = "AlarmActivityManager")
                Log.d("AlarmActivityManager", "ActivityUtils.moveActivityToFront() called")
            } else {
                context.startActivity(intent)
                Log.d("AlarmActivityManager", "startActivity() called")
            }
        } catch (e: Exception) {
            Log.e("AlarmActivityManager", "Error opening native alarm stop activity: ${e.message}", e)
        }
    }
    
    
    fun startForegroundCheck(context: Context, isPlayingCallback: () -> Boolean) {
        foregroundCheckJob?.cancel()
        Log.d("AlarmActivityManager", "foregroundCheckJob.cancel() called")
        
        currentContext = context
        
        foregroundCheckJob = CoroutineScope(Dispatchers.Default).launch {
            Log.d("AlarmActivityManager", "CoroutineScope.launch() called - foreground check started")
            while (isPlayingCallback() && isActive) {
                try {
                    delay(2000)
                    Log.d("AlarmActivityManager", "delay(2000) completed")
                    
                    if (!isPlayingCallback()) {
                        Log.d("AlarmActivityManager", "isPlayingCallback() returned false - breaking")
                        break
                    }
                    
                    val isReallyForeground = ActivityUtils.isAppReallyInForeground(context)
                    Log.d("AlarmActivityManager", "isAppReallyInForeground() called: $isReallyForeground")
                    if (!isReallyForeground) {
                        continue
                    }
                    
                    ActivityUtils.moveActivityToFront(context, delayMs = 100, logTag = "AlarmActivityManager")
                    Log.d("AlarmActivityManager", "ActivityUtils.moveActivityToFront() called")
                } catch (e: Exception) {
                    if (e is CancellationException) {
                        throw e
                    }
                    Log.e("AlarmActivityManager", "Error in foreground check: ${e.message}", e)
                }
            }
        }
    }
    
    fun stopForegroundCheck() {
        foregroundCheckJob?.cancel()
        Log.d("AlarmActivityManager", "foregroundCheckJob.cancel() called")
        foregroundCheckJob = null
        currentContext = null
    }
    
    fun sendAlarmStoppedEvent() {
        try {
            if (notificationMethodChannel != null) {
                notificationMethodChannel?.invokeMethod("alarmStopped", null)
                Log.d("AlarmActivityManager", "invokeMethod(alarmStopped) called")
            }
        } catch (e: Exception) {
            Log.e("AlarmActivityManager", "Error sending alarm stopped event: ${e.message}", e)
        }
    }
    
    private fun isPhoneLocked(context: Context): Boolean {
        val result = DeviceStateHelper.isPhoneLocked(context, "AlarmActivityManager")
        Log.d("AlarmActivityManager", "DeviceStateHelper.isPhoneLocked() called: $result")
        return result
    }
}
