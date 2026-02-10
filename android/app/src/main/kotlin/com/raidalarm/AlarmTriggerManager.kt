package com.raidalarm

import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import kotlinx.coroutines.*
import com.raidalarm.fake_call.FakeCallBroadcastReceiver
import com.raidalarm.fake_call.FakeCallConstants
import com.raidalarm.R

object AlarmTriggerManager {
    
    suspend fun triggerAlarm(context: Context) {
        try {
            // ÖNEMLİ: Bu fonksiyon uygulama kapalıyken bile çağrılabilir
            // NotificationListenerService her zaman çalışır
            // GuardMode check removed - Alarms should always trigger

            
            val settings = AlarmSettingsHelper.loadSettings(context, logTag = "AlarmTriggerManager")
            Log.d("AlarmTriggerManager", "loadSettings() called")
            
            if (!settings.alarmEnabled) {
                Log.d("AlarmTriggerManager", "alarmEnabled is false - skipping")
                return
            }
            
            // ÖNEMLİ: Alarm her zaman titreşimle çalışmalı (güvenlik için)
            // Kullanıcı titreşimi kapamış olsa bile alarm titreşimle çalışır
            AlarmHelper.playSystemAlarm(
                context,
                settings.getEffectiveDuration(),
                vibrationEnabled = true, // Her zaman titreşim aktif (güvenlik için)
                soundFileName = settings.alarmSound // Ses seçimi (null = sistem varsayılanı)
            )
            Log.d("AlarmTriggerManager", "playSystemAlarm() called - vibration always enabled for security, sound: ${settings.alarmSound}")
        } catch (e: Exception) {
            Log.e("AlarmTriggerManager", "Error triggering alarm: ${e.message}", e)
        }
    }
    
    suspend fun triggerFakeCall(context: Context) {
        try {
            // GuardMode check removed - Fake calls should always trigger if enabled

            
            val settings = AlarmSettingsHelper.loadSettings(context, logTag = "AlarmTriggerManager")
            Log.d("AlarmTriggerManager", "loadSettings() called for fake call")
            
            if (!settings.fakeCallEnabled) {
                Log.d("AlarmTriggerManager", "fakeCallEnabled is false - skipping fake call")
                return
            }
            
            val fakeCallDuration = if (settings.fakeCallDuration > 0) {
                settings.fakeCallDuration
            } else {
                settings.durationSeconds
            }
            val effectiveDuration = if (settings.fakeCallLoop) {
                0L
            } else {
                val clampedDuration = fakeCallDuration.coerceIn(30, 120)
                (clampedDuration * 1000L)
            }
            Log.d("AlarmTriggerManager", "getEffectiveFakeCallDuration() called: $effectiveDuration ms (fakeCallDuration: $fakeCallDuration, fakeCallLoop: ${settings.fakeCallLoop})")
            
            val data = Bundle().apply {
                putString(FakeCallConstants.EXTRA_FAKE_CALL_ID, "rust_attack_${System.currentTimeMillis()}")
                putString(FakeCallConstants.EXTRA_FAKE_CALL_NAME_CALLER, settings.fakeCallerName)
                // Generate random number if show number is enabled
                if (settings.fakeCallShowNumber) {
                    val prefix = "+1"
                    val areaCode = (100..999).random()
                    val firstPart = (100..999).random()
                    val secondPart = (1000..9999).random()
                    val phoneNumber = "$prefix $areaCode $firstPart $secondPart"
                    putString(FakeCallConstants.EXTRA_FAKE_CALL_NUMBER, phoneNumber)
                }
                
                putString(FakeCallConstants.EXTRA_FAKE_CALL_AVATAR, "")
                putLong(FakeCallConstants.EXTRA_FAKE_CALL_DURATION, effectiveDuration)
                putString(FakeCallConstants.EXTRA_FAKE_CALL_TEXT_ACCEPT, context.getString(R.string.text_accept))
                putString(FakeCallConstants.EXTRA_FAKE_CALL_TEXT_DECLINE, context.getString(R.string.text_decline))
                putString(FakeCallConstants.EXTRA_FAKE_CALL_SUBTITLE, context.getString(R.string.attack_detected_message))
                // Ses seçimi (null veya boş ise "system_ringtone_default" kullanılır)
                putString(FakeCallConstants.EXTRA_FAKE_CALL_RINGTONE_PATH, settings.fakeCallSound ?: "system_ringtone_default")
                putString(FakeCallConstants.EXTRA_FAKE_CALL_BACKGROUND_COLOR, "#1E1E1E")
                putString(FakeCallConstants.EXTRA_FAKE_CALL_BACKGROUND_IMAGE, settings.fakeCallBackground)
                putString(FakeCallConstants.EXTRA_FAKE_CALL_ACTION_COLOR, "#4CAF50")
                putString(FakeCallConstants.EXTRA_FAKE_CALL_TEXT_COLOR, "#ffffff")
                putString(FakeCallConstants.EXTRA_FAKE_CALL_APP_NAME, "Raid Alarm")
            }
            
            context.sendBroadcast(
                FakeCallBroadcastReceiver.getIntentIncoming(context, data)
            )
            Log.d("AlarmTriggerManager", "Fake call incoming broadcast sent - duration: $effectiveDuration ms")
        } catch (e: Exception) {
            Log.e("AlarmTriggerManager", "Error triggering fake call: ${e.message}", e)
        }
    }
}
