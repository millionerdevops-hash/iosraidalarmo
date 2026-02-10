package com.raidalarm

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import io.flutter.plugin.common.MethodChannel

object IntentHandler {
    private const val PREFS_NAME = "intent_handler_prefs"
    private const val KEY_LAST_ALARM_INTENT_TIME = "last_alarm_intent_time"
    private const val INTENT_VALIDITY_MS = 5000L
    
    private const val KEY_PENDING_ALARM_INTENT_ACTION = "pending_alarm_intent_action"
    private const val KEY_PENDING_ALARM_INTENT_TIMESTAMP = "pending_alarm_intent_timestamp"
    
    enum class LifecycleState {
        CREATE,
        NEW_INTENT,
        RESUME
    }
    
    fun handleIntent(
        activity: Activity,
        intent: Intent?,
        lifecycleState: LifecycleState,
        notificationMethodChannel: MethodChannel?
    ) {
        if (intent == null) {
            return
        }
        
        val action = intent.action ?: return
        
        when (action) {
            // "com.raidalarm.OPEN_NOTIFICATION_SETTINGS" -> {
            //     handleOpenNotificationSettings(activity, lifecycleState)
            // }
            "com.raidalarm.TRIGGER_ALARM" -> {
                handleTriggerAlarm(activity, intent, lifecycleState, notificationMethodChannel)
            }
            "com.raidalarm.DISMISS_ALARM" -> {
                handleDismissAlarm(activity, lifecycleState, notificationMethodChannel)
            }
        }
    }
    
    // private fun handleOpenNotificationSettings(activity: Activity, lifecycleState: LifecycleState) {
    //     try {
    //        val intent = Intent(android.provider.Settings.ACTION_SETTINGS)
    //        activity.startActivity(intent)
    //     } catch (e: Exception) {}
    // }
    
    private fun handleTriggerAlarm(
        activity: Activity,
        intent: Intent,
        lifecycleState: LifecycleState,
        notificationMethodChannel: MethodChannel?
    ) {
        val settings = AlarmSettingsHelper.loadSettings(activity, logTag = "IntentHandler")
        Log.d("IntentHandler", "AlarmSettingsHelper.loadSettings() called")
        if (!settings.alarmEnabled) {
            return
        }
        
        val isPendingIntent = intent.getBooleanExtra("is_pending_intent", false)
        if (!isPendingIntent && !AlarmHelper.isAlarmPlaying()) {
            Log.d("IntentHandler", "AlarmHelper.isAlarmPlaying() returned false")
            return
        }
        
        val intentTimestamp = intent.getLongExtra("intent_timestamp", 0L)
        val currentTime = System.currentTimeMillis()
        
        if (intentTimestamp > 0) {
            val prefs = activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val lastIntentTime = prefs.getLong(KEY_LAST_ALARM_INTENT_TIME, 0L)
            Log.d("IntentHandler", "SharedPreferences.getLong() called: $KEY_LAST_ALARM_INTENT_TIME = $lastIntentTime")
            
            if (intentTimestamp == lastIntentTime) {
                return
            }
            
            if (currentTime - intentTimestamp > INTENT_VALIDITY_MS) {
                return
            }
            
            prefs.edit().putLong(KEY_LAST_ALARM_INTENT_TIME, intentTimestamp).apply()
            Log.d("IntentHandler", "SharedPreferences.edit().putLong().apply() called: $KEY_LAST_ALARM_INTENT_TIME = $intentTimestamp")
        } else {
            intent.putExtra("intent_timestamp", currentTime)
            val prefs = activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit().putLong(KEY_LAST_ALARM_INTENT_TIME, currentTime).apply()
            Log.d("IntentHandler", "SharedPreferences.edit().putLong().apply() called: $KEY_LAST_ALARM_INTENT_TIME = $currentTime")
        }
        
        if (!PermissionHelper.canDrawOverlays(activity)) {
            val pendingTimestamp = intent.getLongExtra("intent_timestamp", 0L)
            val timestampToSave = if (pendingTimestamp > 0) pendingTimestamp else currentTime
            val prefs = activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit()
                .putString(KEY_PENDING_ALARM_INTENT_ACTION, intent.action)
                .putLong(KEY_PENDING_ALARM_INTENT_TIMESTAMP, timestampToSave)
                .apply()
            Log.d("IntentHandler", "SharedPreferences.edit().putString().putLong().apply() called: pending intent saved")
            
            PermissionHelper.requestDisplayOverOtherAppsPermission(activity)
            Log.d("IntentHandler", "PermissionHelper.requestDisplayOverOtherAppsPermission() called")
            return
        }
        
        val prefs = activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit()
            .remove(KEY_PENDING_ALARM_INTENT_ACTION)
            .remove(KEY_PENDING_ALARM_INTENT_TIMESTAMP)
            .apply()
        Log.d("IntentHandler", "SharedPreferences.edit().remove().remove().apply() called: pending intent cleared")
    }
    
    fun handleIntentOnResume(
        activity: Activity,
        intent: Intent?,
        notificationMethodChannel: MethodChannel?
    ) {
        if (intent == null || notificationMethodChannel == null) {
            return
        }
        
        val action = intent.action ?: return
        
        when (action) {
            "com.raidalarm.TRIGGER_ALARM" -> {
                val settings = AlarmSettingsHelper.loadSettings(activity, logTag = "IntentHandler")
                Log.d("IntentHandler", "AlarmSettingsHelper.loadSettings() called (onResume)")
                if (!settings.alarmEnabled) {
                    return
                }
                
                if (!AlarmHelper.isAlarmPlaying()) {
                    Log.d("IntentHandler", "AlarmHelper.isAlarmPlaying() returned false (onResume)")
                    return
                }
                
                val intentTimestamp = intent.getLongExtra("intent_timestamp", 0L)
                if (intentTimestamp > 0) {
                    val prefs = activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                    val lastIntentTime = prefs.getLong(KEY_LAST_ALARM_INTENT_TIME, 0L)
                    Log.d("IntentHandler", "SharedPreferences.getLong() called: $KEY_LAST_ALARM_INTENT_TIME = $lastIntentTime (onResume)")
                    
                    if (intentTimestamp == lastIntentTime) {
                        return
                    }
                }
            }
            "com.raidalarm.DISMISS_ALARM" -> {
                StreamEventSender.sendEventDirect(
                    methodChannel = notificationMethodChannel,
                    methodName = "goToHome",
                    arguments = null,
                    delayMs = 200L
                )
                Log.d("IntentHandler", "StreamEventSender.sendEventDirect() called: goToHome")
            }
        }
    }
    
    private fun handleDismissAlarm(
        activity: Activity,
        lifecycleState: LifecycleState,
        notificationMethodChannel: MethodChannel?
    ) {
        try {
            AlarmHelper.stopSystemAlarm(activity)
            Log.d("IntentHandler", "AlarmHelper.stopSystemAlarm() called")
            
            AlarmNotificationManager.dismissAlarmNotification(activity)
            Log.d("IntentHandler", "AlarmNotificationManager.dismissAlarmNotification() called")
            
            if (lifecycleState == LifecycleState.NEW_INTENT && notificationMethodChannel != null) {
                StreamEventSender.sendEventWithRetry(
                    methodChannel = notificationMethodChannel,
                    methodName = "goToHome",
                    arguments = null,
                    maxRetries = 5,
                    retryDelayMs = 300L
                )
                Log.d("IntentHandler", "StreamEventSender.sendEventWithRetry() called: goToHome")
            }
        } catch (e: Exception) {
            Log.e("IntentHandler", "Error handling dismiss alarm: ${e.message}", e)
        }
    }
    
    fun checkAndProcessPendingIntent(
        activity: Activity,
        notificationMethodChannel: MethodChannel?
    ) {
        try {
            if (!PermissionHelper.canDrawOverlays(activity)) {
                return
            }
            
            val prefs = activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val pendingAlarmAction = prefs.getString(KEY_PENDING_ALARM_INTENT_ACTION, null)
            val pendingAlarmTimestamp = prefs.getLong(KEY_PENDING_ALARM_INTENT_TIMESTAMP, 0L)
            Log.d("IntentHandler", "SharedPreferences.getString() called: $KEY_PENDING_ALARM_INTENT_ACTION = $pendingAlarmAction")
            Log.d("IntentHandler", "SharedPreferences.getLong() called: $KEY_PENDING_ALARM_INTENT_TIMESTAMP = $pendingAlarmTimestamp")
            
            if (pendingAlarmAction != null && pendingAlarmTimestamp > 0) {
                prefs.edit()
                    .remove(KEY_PENDING_ALARM_INTENT_ACTION)
                    .remove(KEY_PENDING_ALARM_INTENT_TIMESTAMP)
                    .apply()
                Log.d("IntentHandler", "SharedPreferences.edit().remove().remove().apply() called: pending intent cleared")
                
                val intent = Intent(activity, activity.javaClass).apply {
                    action = pendingAlarmAction
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP
                    putExtra("intent_timestamp", System.currentTimeMillis())
                    putExtra("is_pending_intent", true)
                }
                Log.d("IntentHandler", "Intent() created: $pendingAlarmAction")
                
                handleIntent(
                    activity = activity,
                    intent = intent,
                    lifecycleState = LifecycleState.NEW_INTENT,
                    notificationMethodChannel = notificationMethodChannel
                )
                
                activity.setIntent(intent)
                Log.d("IntentHandler", "activity.setIntent() called")
                return
            }
        } catch (e: Exception) {
            Log.e("IntentHandler", "Error checking and processing pending intent: ${e.message}", e)
        }
    }
}
