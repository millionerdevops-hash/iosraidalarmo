package com.raidalarm.fake_call

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import com.raidalarm.MainActivity
import com.raidalarm.ActivityUtils
import com.raidalarm.PermissionHelper

class FakeCallBroadcastReceiver : BroadcastReceiver() {
    
    companion object {
        private var notificationMethodChannel: MethodChannel? = null
        
        fun setNotificationMethodChannel(channel: MethodChannel?) {
            notificationMethodChannel = channel
            Log.d("FakeCallBroadcastReceiver", "setNotificationMethodChannel() called")
        }
        
        fun getIntentIncoming(context: Context, data: Bundle): Intent {
            return Intent(context, FakeCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${FakeCallConstants.ACTION_FAKE_CALL_INCOMING}"
                putExtra(FakeCallConstants.EXTRA_FAKE_CALL_DATA, data)
            }
        }
        
        fun getIntentAccept(context: Context, data: Bundle): Intent {
            return Intent(context, FakeCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${FakeCallConstants.ACTION_FAKE_CALL_ACCEPT}"
                putExtra(FakeCallConstants.EXTRA_FAKE_CALL_DATA, data)
            }
        }
        
        fun getIntentDecline(context: Context, data: Bundle): Intent {
            return Intent(context, FakeCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${FakeCallConstants.ACTION_FAKE_CALL_DECLINE}"
                putExtra(FakeCallConstants.EXTRA_FAKE_CALL_DATA, data)
            }
        }
        
        fun getIntentTimeout(context: Context, data: Bundle): Intent {
            return Intent(context, FakeCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${FakeCallConstants.ACTION_FAKE_CALL_TIMEOUT}"
                putExtra(FakeCallConstants.EXTRA_FAKE_CALL_DATA, data)
            }
        }
    }
    
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val data = intent.extras?.getBundle(FakeCallConstants.EXTRA_FAKE_CALL_DATA) ?: return
        
        Log.d("FakeCallBroadcastReceiver", "onReceive() called - action: $action")
        
        when (action) {
            "${context.packageName}.${FakeCallConstants.ACTION_FAKE_CALL_INCOMING}" -> {
                try {
                    if (FakeCallNotificationManager.isFakeCallActive()) {
                        // Fake call is already active - reset duration instead of opening new screen
                        val duration = data.getLong(FakeCallConstants.EXTRA_FAKE_CALL_DURATION, 0L)
                        FakeCallNotificationManager.resetFakeCallDuration(context, duration)
                        Log.d("FakeCallBroadcastReceiver", "Fake call already active - duration reset to $duration ms")
                        return
                    }
                    
                    // Not active - start new fake call
                    openFakeCallActivity(context, data)
                    Log.d("FakeCallBroadcastReceiver", "openFakeCallActivity() called")
                    
                    // Mark fake call as active with duration
                    val duration = data.getLong(FakeCallConstants.EXTRA_FAKE_CALL_DURATION, 0L)
                    FakeCallNotificationManager.startFakeCall(context, duration)
                    Log.d("FakeCallBroadcastReceiver", "Fake call started with duration: $duration ms")
                    
                    sendEventToFlutter(FakeCallConstants.ACTION_FAKE_CALL_INCOMING, data)
                } catch (e: Exception) {
                    Log.e("FakeCallBroadcastReceiver", "Error handling incoming call: ${e.message}", e)
                }
            }
            
            "${context.packageName}.${FakeCallConstants.ACTION_FAKE_CALL_ACCEPT}" -> {
                try {
                    FakeCallNotificationManager.endFakeCall(context)
                    Log.d("FakeCallBroadcastReceiver", "Fake call ended - accepted")
                    navigateToHome(context)
                    sendEventToFlutter(FakeCallConstants.ACTION_FAKE_CALL_ACCEPT, data)
                } catch (e: Exception) {
                    Log.e("FakeCallBroadcastReceiver", "Error handling accept: ${e.message}", e)
                }
            }
            
            "${context.packageName}.${FakeCallConstants.ACTION_FAKE_CALL_DECLINE}" -> {
                try {
                    FakeCallNotificationManager.endFakeCall(context)
                    Log.d("FakeCallBroadcastReceiver", "Fake call ended - declined")
                    navigateToHome(context)
                    sendEventToFlutter(FakeCallConstants.ACTION_FAKE_CALL_DECLINE, data)
                } catch (e: Exception) {
                    Log.e("FakeCallBroadcastReceiver", "Error handling decline: ${e.message}", e)
                }
            }
            
            "${context.packageName}.${FakeCallConstants.ACTION_FAKE_CALL_TIMEOUT}" -> {
                try {
                    FakeCallNotificationManager.endFakeCall(context)
                    Log.d("FakeCallBroadcastReceiver", "Fake call ended - timeout")
                    sendEventToFlutter(FakeCallConstants.ACTION_FAKE_CALL_TIMEOUT, data)
                } catch (e: Exception) {
                    Log.e("FakeCallBroadcastReceiver", "Error handling timeout: ${e.message}", e)
                }
            }
        }
    }
    
    private fun openFakeCallActivity(context: Context, data: Bundle) {
        try {
            // KRİTİK: Display Over Other Apps izni kontrolü - Alarm Stop ile aynı mantık
            // İzin yoksa activity açılmamalı (API 23+ için gerekli)
            if (!PermissionHelper.canDrawOverlays(context)) {
                Log.d("FakeCallBroadcastReceiver", "canDrawOverlays() returned false - cannot open FakeCallActivity")
                return
            }
            
            data.putLong("EXTRA_TIME_START_CALL", System.currentTimeMillis())
            
            val activityIntent = FakeCallActivity.getIntent(context, data)
            
            Log.d("FakeCallBroadcastReceiver", "Intent created - opening FakeCallActivity")
            context.startActivity(activityIntent)
            Log.d("FakeCallBroadcastReceiver", "startActivity() called - FakeCallActivity opened")
            
            // Start sound player
            val soundPlayer = FakeCallSoundPlayer(context)
            soundPlayer.play(data)
            FakeCallNotificationManager.setSoundPlayer(soundPlayer)
            
            // Move activity to front (works even when app is closed, like AlarmStopActivity)
            ActivityUtils.moveActivityToFront(context, delayMs = 200, logTag = "FakeCallBroadcastReceiver")
            Log.d("FakeCallBroadcastReceiver", "ActivityUtils.moveActivityToFront() called")
        } catch (e: Exception) {
            Log.e("FakeCallBroadcastReceiver", "Failed to open FakeCallActivity: ${e.message}", e)
        }
    }
    
    private fun navigateToHome(context: Context) {
        try {
            val mainIntent = Intent(context, com.raidalarm.MainActivity::class.java).apply {
                action = "com.raidalarm.GO_TO_HOME"
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
            }
            Log.d("FakeCallBroadcastReceiver", "Intent created - GO_TO_HOME")
            context.startActivity(mainIntent)
            Log.d("FakeCallBroadcastReceiver", "startActivity() called - navigating to home")
        } catch (e: Exception) {
            Log.e("FakeCallBroadcastReceiver", "Failed to navigate to home: ${e.message}", e)
        }
    }
    
    private fun sendEventToFlutter(event: String, data: Bundle) {
        try {
            val eventData = mapOf(
                "event" to event,
                "body" to mapOf(
                    "id" to data.getString(FakeCallConstants.EXTRA_FAKE_CALL_ID, ""),
                    "nameCaller" to data.getString(FakeCallConstants.EXTRA_FAKE_CALL_NAME_CALLER, ""),
                    "avatar" to data.getString(FakeCallConstants.EXTRA_FAKE_CALL_AVATAR, ""),
                    "duration" to data.getLong(FakeCallConstants.EXTRA_FAKE_CALL_DURATION, 0L),
                )
            )
            
            notificationMethodChannel?.invokeMethod("onFakeCallEvent", eventData)
            Log.d("FakeCallBroadcastReceiver", "invokeMethod(onFakeCallEvent) called - event: $event")
        } catch (e: Exception) {
            Log.e("FakeCallBroadcastReceiver", "Error sending event to Flutter: ${e.message}", e)
        }
    }
}
