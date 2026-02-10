package com.raidalarm

import android.content.Context
import android.util.Log

object AlarmSettingsHelper {
    
    data class AlarmSettings(
        val alarmEnabled: Boolean = true,
        val alarmMode: String = "sound",
        val alarmLoop: Boolean = false,
        val durationSeconds: Int = 30,
        val vibrationEnabled: Boolean = true,
        val fakeCallEnabled: Boolean = false,
        val fakeCallDuration: Int = 30,
        val fakeCallLoop: Boolean = false,
        val alarmSound: String? = null, // Ses dosyası adı (null = sistem varsayılanı)
        val fakeCallSound: String? = null, // Ses dosyası adı (null = sistem varsayılanı)
        val fakeCallerName: String = "Raid Alarm",
        val fakeCallShowNumber: Boolean = false,
        val fakeCallBackground: String = "Default Dark"
    ) {
        fun getEffectiveDuration(): Int {
            val result = if (alarmLoop) 0 else durationSeconds
            Log.d("AlarmSettingsHelper", "getEffectiveDuration() called: $result")
            return result
        }
        
        fun getEffectiveFakeCallDuration(): Long {
            val effectiveFakeCallDuration = if (fakeCallDuration > 0) {
                fakeCallDuration
            } else {
                durationSeconds
            }
            // Fake call süresi: 30sn, 1dk, 3dk, 5dk (30-300 saniye arası)
            val clampedDuration = effectiveFakeCallDuration.coerceIn(30, 300)
            val result = if (fakeCallLoop) 0L else (clampedDuration * 1000L)
            Log.d("AlarmSettingsHelper", "getEffectiveFakeCallDuration() called: $result ms (fakeCallDuration: $fakeCallDuration, durationSeconds: $durationSeconds, fakeCallLoop: $fakeCallLoop)")
            return result
        }
    }
    
    fun loadSettings(
        context: Context,
        logTag: String = "AlarmSettingsHelper"
    ): AlarmSettings {
        try {
            val dbHelper = DatabaseHelper.getInstance(context)
            Log.d("AlarmSettingsHelper", "DatabaseHelper.getInstance() called")
            val alarmSettingsJson = dbHelper.loadAlarmSettings()
            Log.d("AlarmSettingsHelper", "loadAlarmSettings() called")
            
            var alarmEnabled = true
            var alarmMode = "sound"
            var alarmLoop = false
            var durationSeconds = 30
            var vibrationEnabled = true
            var fakeCallEnabled = false
            var fakeCallDuration = 30
            var fakeCallLoop = false
            var alarmSound: String? = null
            var fakeCallSound: String? = null
            var fakeCallerName = "Raid Alarm"
            var fakeCallShowNumber = false
            var fakeCallBackground = "Default Dark"
            
            if (alarmSettingsJson != null) {
                try {
                    alarmEnabled = alarmSettingsJson.optBoolean("alarmEnabled", true)
                    Log.d("AlarmSettingsHelper", "optBoolean(alarmEnabled) called: $alarmEnabled")
                    val modeFromJson = alarmSettingsJson.optString("mode", "sound")
                    Log.d("AlarmSettingsHelper", "optString(mode) called: $modeFromJson")
                    alarmMode = if (modeFromJson == "vibration") "sound" else modeFromJson
                    alarmLoop = alarmSettingsJson.optBoolean("loop", false)
                    Log.d("AlarmSettingsHelper", "optBoolean(loop) called: $alarmLoop")
                    durationSeconds = alarmSettingsJson.optInt("durationSeconds", 30)
                    Log.d("AlarmSettingsHelper", "optInt(durationSeconds) called: $durationSeconds")
                    vibrationEnabled = alarmSettingsJson.optBoolean("vibrationEnabled", true)
                    Log.d("AlarmSettingsHelper", "optBoolean(vibrationEnabled) called: $vibrationEnabled")
                    fakeCallEnabled = alarmSettingsJson.optBoolean("fakeCallEnabled", false)
                    Log.d("AlarmSettingsHelper", "optBoolean(fakeCallEnabled) called: $fakeCallEnabled")
                    fakeCallDuration = alarmSettingsJson.optInt("fakeCallDuration", 30)
                    Log.d("AlarmSettingsHelper", "optInt(fakeCallDuration) called: $fakeCallDuration")
                    fakeCallLoop = alarmSettingsJson.optBoolean("fakeCallLoop", false)
                    Log.d("AlarmSettingsHelper", "optBoolean(fakeCallLoop) called: $fakeCallLoop")
                    // Ses seçimleri (null olabilir)
                    val alarmSoundStr = alarmSettingsJson.optString("alarmSound", null)
                    alarmSound = if (alarmSoundStr != null && alarmSoundStr.isNotEmpty() && alarmSoundStr != "null") {
                        alarmSoundStr
                    } else {
                        null
                    }
                    Log.d("AlarmSettingsHelper", "optString(alarmSound) called: $alarmSound")
                    val fakeCallSoundStr = alarmSettingsJson.optString("fakeCallSound", null)
                    fakeCallSound = if (fakeCallSoundStr != null && fakeCallSoundStr.isNotEmpty() && fakeCallSoundStr != "null") {
                        fakeCallSoundStr
                    } else {
                        null
                    }
                    Log.d("AlarmSettingsHelper", "optString(fakeCallSound) called: $fakeCallSound")
                    
                    fakeCallerName = alarmSettingsJson.optString("fakeCallerName", "Raid Alarm")
                    Log.d("AlarmSettingsHelper", "optString(fakeCallerName) called: $fakeCallerName")
                    fakeCallShowNumber = alarmSettingsJson.optBoolean("fakeCallShowNumber", false)
                    Log.d("AlarmSettingsHelper", "optBoolean(fakeCallShowNumber) called: $fakeCallShowNumber")
                    fakeCallBackground = alarmSettingsJson.optString("fakeCallBackground", "Default Dark")
                    Log.d("AlarmSettingsHelper", "optString(fakeCallBackground) called: $fakeCallBackground")
                } catch (e: Exception) {
                    Log.e(logTag, "Error parsing alarm settings JSON: ${e.message}", e)
                }
            }
            
            val settings = AlarmSettings(
                alarmEnabled = alarmEnabled,
                alarmMode = alarmMode,
                alarmLoop = alarmLoop,
                durationSeconds = durationSeconds,
                vibrationEnabled = vibrationEnabled,
                fakeCallEnabled = fakeCallEnabled,
                fakeCallDuration = fakeCallDuration,
                fakeCallLoop = fakeCallLoop,
                alarmSound = alarmSound,
                fakeCallSound = fakeCallSound,
                fakeCallerName = fakeCallerName,
                fakeCallShowNumber = fakeCallShowNumber,
                fakeCallBackground = fakeCallBackground
            )
            Log.d("AlarmSettingsHelper", "AlarmSettings() created")
            
            return settings
        } catch (e: Exception) {
            Log.e(logTag, "Error loading alarm settings: ${e.message}", e)
            return AlarmSettings()
        }
    }
}
