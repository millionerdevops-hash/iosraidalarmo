package com.raidalarm

import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

object AlarmHelper {
    private var isPlaying = false
    private var currentDurationSeconds: Int = 0
    private var currentVibrationEnabled: Boolean = false
    private var currentSoundFileName: String? = null
    private var currentOnStopped: (() -> Unit)? = null
    
    fun setNotificationMethodChannel(channel: MethodChannel?) {
        AlarmActivityManager.setNotificationMethodChannel(channel)
        Log.d("AlarmHelper", "AlarmActivityManager.setNotificationMethodChannel() called")
    }
    
    fun playSystemAlarm(context: Context, durationSeconds: Int, vibrationEnabled: Boolean = false, soundFileName: String? = null) {
        try {
            if (isPlaying) {
                // Alarm is already playing - reset duration instead of blocking
                Log.d("AlarmHelper", "Alarm is already playing - resetting duration to $durationSeconds seconds")
                resetAlarmDuration(durationSeconds, vibrationEnabled)
                return
            }
            
            // Store current settings for potential duration reset
            currentDurationSeconds = durationSeconds
            currentVibrationEnabled = vibrationEnabled
            currentSoundFileName = soundFileName
            
            playSystemAlarmInternal(context, durationSeconds, vibrationEnabled, soundFileName)
            Log.d("AlarmHelper", "playSystemAlarmInternal() called")
        } catch (e: Exception) {
            isPlaying = false
            throw e
        }
    }
    
    /**
     * Reset the alarm duration timer without restarting the sound.
     * This is called when a new notification arrives while alarm is already playing.
     */
    private fun resetAlarmDuration(durationSeconds: Int, vibrationEnabled: Boolean) {
        try {
            // Update current duration
            currentDurationSeconds = durationSeconds
            currentVibrationEnabled = vibrationEnabled
            
            // Reset the duration timer in AlarmPlayer
            currentOnStopped?.let { onStoppedCallback ->
                AlarmPlayer.resetDuration(durationSeconds, onStoppedCallback)
                Log.d("AlarmHelper", "AlarmPlayer.resetDuration() called - duration reset to $durationSeconds seconds")
            }
            
            // Reset vibration duration if enabled
            if (vibrationEnabled) {
                AlarmPlayer.resetVibrationDuration(durationSeconds)
                Log.d("AlarmHelper", "AlarmPlayer.resetVibrationDuration() called - vibration duration reset to $durationSeconds seconds")
            }
        } catch (e: Exception) {
            Log.e("AlarmHelper", "Error resetting alarm duration: ${e.message}", e)
        }
    }
    
    private fun playSystemAlarmInternal(context: Context, durationSeconds: Int, vibrationEnabled: Boolean = false, soundFileName: String? = null) {
        try {
            isPlaying = true
            Log.d("AlarmHelper", "isPlaying set to true")
            
            val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            Log.d("AlarmHelper", "getSystemService(AUDIO_SERVICE) called")
            
            CoroutineScope(Dispatchers.Main + SupervisorJob()).launch {
                Log.d("AlarmHelper", "CoroutineScope.launch() called - alarm operations")
                
                // ÖNEMLİ: Ses ayarlarını ÖNCE yap, sonra alarm çal
                // Bu sayede telefon titreşimde/sessizde/kısık seste olsa bile
                // ses %100 seviyesine çıkar ve alarm çalmaya başlar
                // await kullanarak ses ayarlarının tamamlanmasını bekliyoruz
                AudioSettingsManager.setupAlarmSettings(audioManager)
                Log.d("AlarmHelper", "AudioSettingsManager.setupAlarmSettings() completed - audio settings configured")
                
                // Ses ayarları tamamlandıktan sonra diğer işlemleri başlat
                launch {
                    AlarmActivityManager.openAlarmStopScreen(context)
                    Log.d("AlarmHelper", "AlarmActivityManager.openAlarmStopScreen() called")
                }
                
                launch {
                    AlarmActivityManager.startForegroundCheck(context) {
                        isPlaying
                    }
                    Log.d("AlarmHelper", "AlarmActivityManager.startForegroundCheck() called")
                }
                
                // Ses ayarları tamamlandıktan sonra alarm çal
                launch {
                    // Store onStopped callback for potential duration reset
                    val onStoppedCallback: () -> Unit = {
                        try {
                            isPlaying = false
                            Log.d("AlarmHelper", "isPlaying set to false - onStopped")
                            
                            AlarmPlayer.stopVibration()
                            Log.d("AlarmHelper", "AlarmPlayer.stopVibration() called")
                            
                            AlarmNotificationManager.dismissAlarmNotification(context)
                            Log.d("AlarmHelper", "AlarmNotificationManager.dismissAlarmNotification() called")
                            
                            AlarmActivityManager.sendAlarmStoppedEvent()
                            Log.d("AlarmHelper", "AlarmActivityManager.sendAlarmStoppedEvent() called")
                            
                            AlarmActivityManager.stopForegroundCheck()
                            Log.d("AlarmHelper", "AlarmActivityManager.stopForegroundCheck() called")
                            
                            val closeIntent = Intent("com.raidalarm.ALARM_DURATION_FINISHED")
                            Log.d("AlarmHelper", "Intent created - ALARM_DURATION_FINISHED")
                            context.sendBroadcast(closeIntent)
                            Log.d("AlarmHelper", "sendBroadcast() called - ALARM_DURATION_FINISHED")
                        } catch (e: Exception) {
                            Log.e("AlarmHelper", "Error in onStopped callback: ${e.message}", e)
                            isPlaying = false
                            AlarmActivityManager.stopForegroundCheck()
                        }
                    }
                    
                    currentOnStopped = onStoppedCallback
                    
                    AlarmPlayer.playAlarmSound(
                        context = context,
                        vibrationEnabled = vibrationEnabled,
                        durationSeconds = durationSeconds,
                        soundFileName = soundFileName,
                        onStopped = onStoppedCallback
                    )
                    Log.d("AlarmHelper", "AlarmPlayer.playAlarmSound() called")
                }
            }
        } catch (e: Exception) {
            isPlaying = false
            throw e
        }
    }
    
    fun stopSystemAlarm() {
        try {
            AlarmPlayer.stopVibration()
            Log.d("AlarmHelper", "AlarmPlayer.stopVibration() called")
            
            AlarmPlayer.stopAlarmSound()
            Log.d("AlarmHelper", "AlarmPlayer.stopAlarmSound() called")
            
            isPlaying = false
            Log.d("AlarmHelper", "isPlaying set to false")
            
            AlarmActivityManager.stopForegroundCheck()
            Log.d("AlarmHelper", "AlarmActivityManager.stopForegroundCheck() called")
            
            ScreenWakeLock.release()
            Log.d("AlarmHelper", "ScreenWakeLock.release() called")
            
            AlarmActivityManager.sendAlarmStoppedEvent()
            Log.d("AlarmHelper", "AlarmActivityManager.sendAlarmStoppedEvent() called")
        } catch (e: Exception) {
            isPlaying = false
            AlarmActivityManager.stopForegroundCheck()
            ScreenWakeLock.release()
            AlarmActivityManager.sendAlarmStoppedEvent()
        }
    }
    
    fun stopSystemAlarm(context: Context) {
        AlarmActivityManager.sendAlarmStoppedEvent()
        Log.d("AlarmHelper", "AlarmActivityManager.sendAlarmStoppedEvent() called")
        stopSystemAlarm()
        AlarmNotificationManager.dismissAlarmNotification(context)
        Log.d("AlarmHelper", "AlarmNotificationManager.dismissAlarmNotification() called")
        
        try {
            val serviceIntent = Intent(context, AlarmForegroundService::class.java)
            Log.d("AlarmHelper", "Intent created - AlarmForegroundService")
            context.stopService(serviceIntent)
            Log.d("AlarmHelper", "stopService() called")
        } catch (e: Exception) {
            Log.e("AlarmHelper", "Error stopping foreground service: ${e.message}", e)
        }
    }
    
    fun isAlarmPlaying(): Boolean {
        val result = isPlaying || AlarmPlayer.isPlaying()
        Log.d("AlarmHelper", "isAlarmPlaying() called: $result")
        return result
    }
    
    fun playVibrationOnly(context: Context, durationSeconds: Int) {
        try {
            isPlaying = true
            Log.d("AlarmHelper", "isPlaying set to true")
            
            CoroutineScope(Dispatchers.Main + SupervisorJob()).launch {
                Log.d("AlarmHelper", "CoroutineScope.launch() called - vibration operations")
                launch {
                    AlarmActivityManager.openAlarmStopScreen(context)
                    Log.d("AlarmHelper", "AlarmActivityManager.openAlarmStopScreen() called")
                }
                
                launch {
                    AlarmActivityManager.startForegroundCheck(context) {
                        isPlaying
                    }
                    Log.d("AlarmHelper", "AlarmActivityManager.startForegroundCheck() called")
                }
                
                launch {
                    AlarmPlayer.startVibration(context, durationSeconds)
                    Log.d("AlarmHelper", "AlarmPlayer.startVibration() called")
                }
            }
            
            if (durationSeconds > 0) {
                CoroutineScope(Dispatchers.Main).launch {
                    delay((durationSeconds * 1000).toLong())
                    Log.d("AlarmHelper", "delay() completed - $durationSeconds seconds")
                    try {
                        if (isPlaying) {
                            AlarmPlayer.stopVibration()
                            Log.d("AlarmHelper", "AlarmPlayer.stopVibration() called")
                            isPlaying = false
                            Log.d("AlarmHelper", "isPlaying set to false")
                            
                            AlarmNotificationManager.dismissAlarmNotification(context)
                            Log.d("AlarmHelper", "AlarmNotificationManager.dismissAlarmNotification() called")
                            
                            AlarmActivityManager.sendAlarmStoppedEvent()
                            Log.d("AlarmHelper", "AlarmActivityManager.sendAlarmStoppedEvent() called")
                            
                            AlarmActivityManager.stopForegroundCheck()
                            Log.d("AlarmHelper", "AlarmActivityManager.stopForegroundCheck() called")
                        }
                    } catch (e: Exception) {
                        Log.e("AlarmHelper", "Error in vibration duration timer: ${e.message}", e)
                        isPlaying = false
                        AlarmActivityManager.stopForegroundCheck()
                    }
                }
                Log.d("AlarmHelper", "CoroutineScope.launch() called - vibration duration timer")
            }
        } catch (e: Exception) {
            isPlaying = false
            AlarmActivityManager.stopForegroundCheck()
            throw e
        }
    }
    
    fun dismissAlarmNotification(context: Context) {
        AlarmNotificationManager.dismissAlarmNotification(context)
        Log.d("AlarmHelper", "AlarmNotificationManager.dismissAlarmNotification() called")
    }
}
