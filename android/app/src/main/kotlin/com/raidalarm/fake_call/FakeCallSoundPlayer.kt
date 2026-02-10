package com.raidalarm.fake_call

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.text.TextUtils
import android.util.Log

class FakeCallSoundPlayer(private val context: Context) {
    
    private var vibrator: Vibrator? = null
    private var audioManager: AudioManager? = null
    private var ringtone: Ringtone? = null
    private var isPlaying: Boolean = false
    private var isReceiverRegistered: Boolean = false // Receiver register durumunu takip et
    
    inner class ScreenOffFakeCallBroadcastReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (isPlaying) {
                stop()
                Log.d("FakeCallSoundPlayer", "Screen off - sound stopped")
            }
        }
    }
    
    private var screenOffReceiver = ScreenOffFakeCallBroadcastReceiver()
    
    fun play(data: Bundle) {
        isPlaying = true
        prepare()
        playSound(data)
        playVibrator()
        
        val filter = IntentFilter(Intent.ACTION_SCREEN_OFF)
        try {
            context.registerReceiver(screenOffReceiver, filter)
            isReceiverRegistered = true
            Log.d("FakeCallSoundPlayer", "Screen off receiver registered")
        } catch (e: Exception) {
            isReceiverRegistered = false
            Log.e("FakeCallSoundPlayer", "Failed to register screen off receiver: ${e.message}", e)
        }
    }
    
    fun stop() {
        isPlaying = false
        
        try {
            ringtone?.let {
                if (it.isPlaying) it.stop()
            }
        } catch (e: Exception) {
            Log.e("FakeCallSoundPlayer", "Error stopping ringtone: ${e.message}")
        }
        
        try {
            vibrator?.cancel()
        } catch (e: Exception) {
            Log.e("FakeCallSoundPlayer", "Error canceling vibrator: ${e.message}")
        }
        
        ringtone = null
        vibrator = null
        
        // Sadece register edilmişse unregister et
        if (isReceiverRegistered) {
            try {
                context.unregisterReceiver(screenOffReceiver)
                isReceiverRegistered = false
                Log.d("FakeCallSoundPlayer", "Screen off receiver unregistered")
            } catch (e: IllegalArgumentException) {
                // Receiver zaten unregister edilmiş - bu normal olabilir
                isReceiverRegistered = false
                Log.d("FakeCallSoundPlayer", "Screen off receiver already unregistered (this is OK)")
            } catch (e: Exception) {
                isReceiverRegistered = false
                Log.e("FakeCallSoundPlayer", "Failed to unregister screen off receiver: ${e.message}", e)
            }
        }
    }
    
    fun destroy() {
        stop()
    }
    
    private fun prepare() {
        ringtone?.stop()
        vibrator?.cancel()
    }
    
    private fun playVibrator() {
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            Log.d("FakeCallSoundPlayer", "VibratorManager obtained")
            vibratorManager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }
        
        audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        Log.d("FakeCallSoundPlayer", "AudioManager obtained")
        
        // ÖNEMLİ: Fake call için titreşim her zaman aktif olmalı (güvenlik için)
        // Kullanıcı telefonu sessiz modda bırakmış olsa bile titreşim çalışmalı
        when (audioManager?.ringerMode) {
            AudioManager.RINGER_MODE_SILENT -> {
                // Silent modda bile titreşim çalışmalı (güvenlik için)
                // Ses çalmayacak ama titreşim çalacak
                Log.d("FakeCallSoundPlayer", "Ringer mode is SILENT - vibration still enabled for security")
                vibrator?.vibrate(
                    VibrationEffect.createWaveform(
                        longArrayOf(0L, 1000L, 1000L),
                        0
                    )
                )
                Log.d("FakeCallSoundPlayer", "Vibration started (SILENT mode)")
            }
            else -> {
                // MinSdk 28 olduğu için VibrationEffect direkt kullanılabilir
                vibrator?.vibrate(
                    VibrationEffect.createWaveform(
                        longArrayOf(0L, 1000L, 1000L),
                        0
                    )
                )
                Log.d("FakeCallSoundPlayer", "Vibration started")
            }
        }
    }
    
    private fun playSound(data: Bundle?) {
        val sound = data?.getString(
            FakeCallConstants.EXTRA_FAKE_CALL_RINGTONE_PATH,
            ""
        )
        val uri = sound?.let { getRingtoneUri(it) }
        
        if (uri == null) {
            Log.d("FakeCallSoundPlayer", "Ringtone URI is null - cannot play sound")
            return
        }
        
        // Ensure audio manager is initialized
        if (audioManager == null) {
            audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        }
        
        // ÖNEMLİ: Fake call için ses ayarlarını optimize et
        // Telefon titreşimde/sessizde/kısık seste olsa bile ses %100 çalmalı
        // AudioSettingsManager.setupAlarmSettings() zaten FakeCallActivity'de çağrılıyor
        // Burada ekstra güvenlik için ringer mode'u kontrol ediyoruz
        val ringerMode = audioManager?.ringerMode
        if (ringerMode == AudioManager.RINGER_MODE_SILENT || ringerMode == AudioManager.RINGER_MODE_VIBRATE) {
            // Silent veya Vibrate modda - NORMAL moda geç (ses + titreşim)
            try {
                audioManager?.ringerMode = AudioManager.RINGER_MODE_NORMAL
                Log.d("FakeCallSoundPlayer", "Ringer mode changed to NORMAL (from $ringerMode) for fake call")
            } catch (e: Exception) {
                Log.e("FakeCallSoundPlayer", "Failed to set ringer mode to NORMAL: ${e.message}", e)
                // Ringer mode değiştirilemezse bile devam et - titreşim zaten çalışıyor
            }
        }
        
        // Ekstra güvenlik: Tüm stream'leri maksimum yap (AudioSettingsManager zaten yapıyor ama ekstra kontrol)
        try {
            val streamsToBoost = listOf(
                AudioManager.STREAM_RING,       // Zil sesi ve telefon araması için (en önemli)
                AudioManager.STREAM_ALARM,      // Alarm sesleri için
                AudioManager.STREAM_NOTIFICATION // Bildirim sesleri için
            )
            
            streamsToBoost.forEach { streamType ->
                try {
                    val maxVolume = audioManager?.getStreamMaxVolume(streamType) ?: return@forEach
                    val currentVolume = audioManager?.getStreamVolume(streamType) ?: return@forEach
                    
                    if (currentVolume < maxVolume) {
                        audioManager?.setStreamVolume(streamType, maxVolume, 0)
                        Log.d("FakeCallSoundPlayer", "setStreamVolume() called - streamType: $streamType, volume: $maxVolume (MAX)")
                    }
                } catch (e: Exception) {
                    Log.e("FakeCallSoundPlayer", "Failed to set volume for stream $streamType: ${e.message}", e)
                }
            }
        } catch (e: Exception) {
            Log.e("FakeCallSoundPlayer", "Error setting stream volumes: ${e.message}", e)
        }
        
        try {
            ringtone = RingtoneManager.getRingtone(context, uri)
            Log.d("FakeCallSoundPlayer", "Ringtone obtained from URI: $uri")
            
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE) // Telefon araması gibi davran
                .setLegacyStreamType(AudioManager.STREAM_RING) // Zil sesi kanalı (tüm cihazlarda çalışır)
                .setFlags(AudioAttributes.FLAG_AUDIBILITY_ENFORCED) // Zorunlu ses (sessiz modda bile)
                .build()
            Log.d("FakeCallSoundPlayer", "AudioAttributes created - STREAM_RING (works on all devices)")
            ringtone?.setAudioAttributes(audioAttributes)
            
            ringtone?.isLooping = true
            Log.d("FakeCallSoundPlayer", "Ringtone looping enabled")
            
            ringtone?.play()
            Log.d("FakeCallSoundPlayer", "Ringtone playback started")
        } catch (e: Exception) {
            Log.e("FakeCallSoundPlayer", "Error playing ringtone: ${e.message}", e)
        }
    }
    
    private fun getRingtoneUri(fileName: String): Uri? {
        if (TextUtils.isEmpty(fileName)) {
            return getDefaultRingtoneUri()
        }
        
        // Check if it is a file path first (custom sound)
        if (fileName.contains("/") || fileName.contains("\\")) {
             try {
                 val file = java.io.File(fileName)
                 if (file.exists()) {
                     val uri = Uri.fromFile(file)
                     Log.d("FakeCallSoundPlayer", "Ringtone URI from file: $uri")
                     return uri
                 }
             } catch (e: Exception) {
                 Log.e("FakeCallSoundPlayer", "Error creating URI from file: ${e.message}")
             }
        }
        
        if (fileName.equals("system_ringtone_default", ignoreCase = true)) {
            return getDefaultRingtoneUri(useSystemDefault = true)
        }
        
        try {
            val resId = context.resources.getIdentifier(fileName, "raw", context.packageName)
            if (resId != 0) {
                val uri = Uri.parse("android.resource://${context.packageName}/$resId")
                Log.d("FakeCallSoundPlayer", "Ringtone URI from resource: $uri")
                return uri
            }
            
            return getDefaultRingtoneUri()
        } catch (e: Exception) {
            Log.e("FakeCallSoundPlayer", "Error getting ringtone URI: ${e.message}", e)
            return getDefaultRingtoneUri()
        }
    }
    
    private fun getDefaultRingtoneUri(useSystemDefault: Boolean = false): Uri? {
        try {
            if (!useSystemDefault) {
                val resId = context.resources.getIdentifier("ringtone_default", "raw", context.packageName)
                if (resId != 0) {
                    val uri = Uri.parse("android.resource://${context.packageName}/$resId")
                    Log.d("FakeCallSoundPlayer", "Default ringtone URI from resource: $uri")
                    return uri
                }
            }
            
            val systemUri = RingtoneManager.getActualDefaultRingtoneUri(
                context,
                RingtoneManager.TYPE_RINGTONE
            )
            Log.d("FakeCallSoundPlayer", "System default ringtone URI: $systemUri")
            return systemUri
        } catch (e: Exception) {
            Log.e("FakeCallSoundPlayer", "Error getting default ringtone URI: ${e.message}", e)
            return null
        }
    }
}
