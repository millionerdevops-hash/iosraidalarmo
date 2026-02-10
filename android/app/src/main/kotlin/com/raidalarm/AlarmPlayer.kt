package com.raidalarm

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.util.Log
import kotlinx.coroutines.*

object AlarmPlayer {
    private var currentMediaPlayer: MediaPlayer? = null
    private var currentVibrator: Vibrator? = null
    private var isPlaying = false
    private var durationJob: Job? = null
    private var vibrationDurationJob: Job? = null
    
    fun isPlaying(): Boolean = isPlaying
    
    /**
     * Reset the alarm duration timer without restarting the sound.
     * This is called when a new notification arrives while alarm is already playing.
     */
    fun resetDuration(durationSeconds: Int, onStopped: () -> Unit) {
        try {
            // Cancel existing duration job
            durationJob?.cancel()
            Log.d("AlarmPlayer", "Existing duration job cancelled")
            
            // Start new duration job
            if (durationSeconds > 0) {
                durationJob = CoroutineScope(Dispatchers.Main).launch {
                    delay((durationSeconds * 1000).toLong())
                    Log.d("AlarmPlayer", "Duration reset completed - $durationSeconds seconds")
                    try {
                        if (isPlaying) {
                            stopAlarmSound()
                            onStopped()
                            Log.d("AlarmPlayer", "onStopped() callback invoked after duration reset")
                        }
                    } catch (e: Exception) {
                        Log.e("AlarmPlayer", "Error in reset duration timer: ${e.message}", e)
                        isPlaying = false
                    }
                }
                Log.d("AlarmPlayer", "Duration timer reset to $durationSeconds seconds")
            }
        } catch (e: Exception) {
            Log.e("AlarmPlayer", "Error resetting duration: ${e.message}", e)
        }
    }
    
    /**
     * Reset the vibration duration timer without restarting vibration.
     */
    fun resetVibrationDuration(durationSeconds: Int) {
        try {
            // Cancel existing vibration duration job
            vibrationDurationJob?.cancel()
            Log.d("AlarmPlayer", "Existing vibration duration job cancelled")
            
            // Start new vibration duration job
            if (durationSeconds > 0) {
                vibrationDurationJob = CoroutineScope(Dispatchers.Main).launch {
                    delay((durationSeconds * 1000).toLong())
                    Log.d("AlarmPlayer", "Vibration duration reset completed - $durationSeconds seconds")
                    stopVibration()
                }
                Log.d("AlarmPlayer", "Vibration duration timer reset to $durationSeconds seconds")
            }
        } catch (e: Exception) {
            Log.e("AlarmPlayer", "Error resetting vibration duration: ${e.message}", e)
        }
    }
    
    suspend fun playAlarmSound(
        context: Context,
        vibrationEnabled: Boolean,
        durationSeconds: Int,
        soundFileName: String? = null, // Ses dosyası adı (null = sistem varsayılanı)
        onStopped: () -> Unit
    ) {
        try {
            val alarmUri: Uri = if (soundFileName != null && soundFileName.isNotEmpty()) {
                // Özel ses seçilmişse raw resource'dan çek
                getAlarmSoundUri(context, soundFileName) 
                    ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            } else {
                // Sistem varsayılanı
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            }
            Log.d("AlarmPlayer", "Alarm URI: $alarmUri (soundFileName: $soundFileName)")
            
            if (alarmUri == null) {
                Log.w("AlarmPlayer", "Alarm URI is null - cannot play sound")
                return
            }
            
            // PRE-EMPTIVE CLEANUP: Release any existing player before starting a new one
            // This prevents overlapping sounds and resource leaks if multiple alarms trigger fast
            stopAlarmSound()
            Log.d("AlarmPlayer", "Pre-emptive stopAlarmSound() called before new playback")
            
            withContext(Dispatchers.Main) {
                Log.d("AlarmPlayer", "withContext(Dispatchers.Main) called")
                currentMediaPlayer = MediaPlayer().apply {
                    Log.d("AlarmPlayer", "MediaPlayer() created")
                    setDataSource(context, alarmUri)
                    Log.d("AlarmPlayer", "setDataSource() called")
                    
                    val audioAttributes = AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setFlags(AudioAttributes.FLAG_AUDIBILITY_ENFORCED)
                        .build()
                    Log.d("AlarmPlayer", "AudioAttributes.Builder().build() called")
                    setAudioAttributes(audioAttributes)
                    Log.d("AlarmPlayer", "setAudioAttributes() called")
                    
                    // ÖNEMLİ: Alarm %100 en yüksek seste çalmalı
                    // Kullanıcı telefonu kısık seste bırakmış olsa bile
                    val mediaPlayerVolume = 1.0f // Maksimum ses seviyesi
                    setVolume(mediaPlayerVolume, mediaPlayerVolume)
                    Log.d("AlarmPlayer", "setVolume() called: $mediaPlayerVolume (MAX)")
                    
                    prepare()
                    Log.d("AlarmPlayer", "prepare() called")
                    isLooping = true
                    Log.d("AlarmPlayer", "isLooping set to true")
                    start()
                    Log.d("AlarmPlayer", "start() called")
                    
                    this@AlarmPlayer.isPlaying = true
                    Log.d("AlarmPlayer", "isPlaying set to true")
                    
                    if (vibrationEnabled) {
                        CoroutineScope(Dispatchers.Main).launch {
                            Log.d("AlarmPlayer", "CoroutineScope.launch() called - startVibration")
                            startVibration(context, durationSeconds)
                        }
                    }
                    
                    if (durationSeconds > 0) {
                        durationJob = CoroutineScope(Dispatchers.Main).launch {
                            delay((durationSeconds * 1000).toLong())
                            Log.d("AlarmPlayer", "delay() completed - $durationSeconds seconds")
                            try {
                                if (this@AlarmPlayer.isPlaying) {
                                    stopAlarmSound()
                                    onStopped()
                                    Log.d("AlarmPlayer", "onStopped() callback invoked")
                                }
                            } catch (e: Exception) {
                                Log.e("AlarmPlayer", "Error in duration timer: ${e.message}", e)
                                this@AlarmPlayer.isPlaying = false
                            }
                        }
                        Log.d("AlarmPlayer", "CoroutineScope.launch() called - duration timer")
                    }
                }
            }
        } catch (e: Exception) {
            isPlaying = false
            throw e
        }
    }
    
    fun stopAlarmSound() {
        try {
            // Cancel duration job
            durationJob?.cancel()
            durationJob = null
            
            currentMediaPlayer?.let { player ->
                try {
                    if (player.isPlaying) {
                        player.stop()
                        Log.d("AlarmPlayer", "player.stop() called")
                    }
                } catch (e: Exception) {
                    Log.e("AlarmPlayer", "Error stopping player (might be already stopped): ${e.message}")
                } finally {
                    try {
                        player.release()
                        Log.d("AlarmPlayer", "player.release() called")
                    } catch (e: Exception) {
                        Log.e("AlarmPlayer", "Error releasing player: ${e.message}")
                    }
                    currentMediaPlayer = null
                }
            }
            isPlaying = false
            Log.d("AlarmPlayer", "isPlaying set to false")
        } catch (e: Exception) {
            Log.e("AlarmPlayer", "Error stopping alarm sound: ${e.message}", e)
            isPlaying = false
        }
    }
    
    fun startVibration(context: Context, durationSeconds: Int) {
        try {
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                Log.d("AlarmPlayer", "getSystemService(VIBRATOR_MANAGER_SERVICE) called")
                vibratorManager.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            }
            Log.d("AlarmPlayer", "Vibrator obtained")
            
            currentVibrator = vibrator
            
            val pattern = longArrayOf(0, 500, 200, 500, 200, 1000)
            val amplitudes = intArrayOf(0, 255, 0, 255, 0, 255)
            
            val vibrationEffect = if (durationSeconds > 0) {
                VibrationEffect.createWaveform(pattern, amplitudes, 0)
            } else {
                VibrationEffect.createWaveform(pattern, amplitudes, 0)
            }
            Log.d("AlarmPlayer", "VibrationEffect.createWaveform() called")
            
            vibrator.vibrate(vibrationEffect)
            Log.d("AlarmPlayer", "vibrator.vibrate() called")
            
            if (durationSeconds > 0) {
                vibrationDurationJob = CoroutineScope(Dispatchers.Main).launch {
                    delay((durationSeconds * 1000).toLong())
                    Log.d("AlarmPlayer", "delay() completed - vibration duration")
                    stopVibration()
                }
                Log.d("AlarmPlayer", "CoroutineScope.launch() called - vibration duration timer")
            }
        } catch (e: Exception) {
            Log.e("AlarmPlayer", "Error starting vibration: ${e.message}", e)
        }
    }
    
    fun stopVibration() {
        try {
            // Cancel vibration duration job
            vibrationDurationJob?.cancel()
            vibrationDurationJob = null
            
            currentVibrator?.cancel()
            Log.d("AlarmPlayer", "vibrator.cancel() called")
            currentVibrator = null
        } catch (e: Exception) {
            Log.e("AlarmPlayer", "Error stopping vibration: ${e.message}", e)
        }
    }
    
    fun stopAll() {
        stopAlarmSound()
        stopVibration()
    }
    
    /**
     * Raw resource'dan alarm sesi URI'si al
     * @param context Context
     * @param fileName Ses dosyası adı (örn: "alarm_sound_1")
     * @return Uri veya null (dosya bulunamazsa)
     */
    private fun getAlarmSoundUri(context: Context, fileName: String): Uri? {
        return try {
            // Check if it is a file path first (custom sound)
            if (fileName.contains("/") || fileName.contains("\\")) {
                val file = java.io.File(fileName)
                if (file.exists()) {
                    val uri = Uri.fromFile(file)
                    Log.d("AlarmPlayer", "Alarm sound URI from file: $uri (fileName: $fileName)")
                    return uri
                }
            }

            val resId = context.resources.getIdentifier(fileName, "raw", context.packageName)
            if (resId != 0) {
                val uri = Uri.parse("android.resource://${context.packageName}/$resId")
                Log.d("AlarmPlayer", "Alarm sound URI from resource: $uri (fileName: $fileName)")
                uri
            } else {
                Log.w("AlarmPlayer", "Alarm sound resource not found: $fileName")
                null
            }
        } catch (e: Exception) {
            Log.e("AlarmPlayer", "Error getting alarm sound URI: ${e.message}", e)
            null
        }
    }
}
