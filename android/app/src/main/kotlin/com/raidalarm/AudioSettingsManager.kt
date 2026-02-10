package com.raidalarm

import android.media.AudioManager
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

object AudioSettingsManager {
    
    suspend fun setupAlarmSettings(audioManager: AudioManager) = withContext(Dispatchers.IO) {
        Log.d("AudioSettingsManager", "withContext(Dispatchers.IO) called")
        // ÖNEMLİ: Alarm tetiklendiğinde ses ve titreşimi %100 aç
        // Kullanıcı telefonu kısık seste/titreşimde bırakmış olsa bile
        // alarm %100 en yüksek seste çalmalı
        forceNormalRingerMode(audioManager)
        setAllStreamsToMax(audioManager)
        ensureVibrationEnabled(audioManager)
    }
    
    private fun forceNormalRingerMode(audioManager: AudioManager) {
        val currentRingerMode = audioManager.ringerMode
        Log.d("AudioSettingsManager", "audioManager.ringerMode read: $currentRingerMode")
        val currentRingerModeName = when(currentRingerMode) {
            AudioManager.RINGER_MODE_NORMAL -> "NORMAL"
            AudioManager.RINGER_MODE_VIBRATE -> "VIBRATE"
            AudioManager.RINGER_MODE_SILENT -> "SILENT"
            else -> "UNKNOWN($currentRingerMode)"
        }
        
        if (currentRingerMode != AudioManager.RINGER_MODE_NORMAL) {
            try {
                audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
                Log.d("AudioSettingsManager", "audioManager.ringerMode set to RINGER_MODE_NORMAL")
                val newRingerMode = audioManager.ringerMode
                Log.d("AudioSettingsManager", "audioManager.ringerMode read after set: $newRingerMode")
            } catch (e: Exception) {
                Log.e("AudioSettingsManager", "Error setting ringer mode to NORMAL: ${e.message}", e)
            }
        }
    }
    
    private fun setAllStreamsToMax(audioManager: AudioManager) {
        // ÖNEMLİ: Android'de zil sesi (STREAM_RING) ve telefon arama sesi genellikle aynı kanalı kullanır
        // Ancak bazı OEM cihazlarda (Samsung, Xiaomi, Huawei) farklılıklar olabilir
        // Bu yüzden tüm önemli stream'leri maksimum yapıyoruz
        val streamsToBoost = listOf(
            AudioManager.STREAM_ALARM,      // Alarm sesleri için (en önemli)
            AudioManager.STREAM_RING,       // Zil sesi ve telefon araması için (en önemli)
            AudioManager.STREAM_NOTIFICATION, // Bildirim sesleri için
            AudioManager.STREAM_MUSIC,      // Müzik için (bazı cihazlarda alarm sesi buraya düşebilir)
            AudioManager.STREAM_SYSTEM      // Sistem sesleri için
        )
        
        streamsToBoost.forEach { streamType ->
            try {
                val maxVolume = audioManager.getStreamMaxVolume(streamType)
                Log.d("AudioSettingsManager", "getStreamMaxVolume() called - streamType: ${getStreamName(streamType)}, maxVolume: $maxVolume")
                
                val currentVolume = audioManager.getStreamVolume(streamType)
                Log.d("AudioSettingsManager", "getStreamVolume() called - streamType: ${getStreamName(streamType)}, currentVolume: $currentVolume")
                
                // Sadece maksimum değilse ayarla (gereksiz işlem yapmamak için)
                if (currentVolume < maxVolume) {
                    audioManager.setStreamVolume(
                        streamType,
                        maxVolume,
                        0 // FLAG_SHOW_UI = 0 (ses UI'sını gösterme)
                    )
                    Log.d("AudioSettingsManager", "setStreamVolume() called - streamType: ${getStreamName(streamType)}, volume: $maxVolume (MAX)")
                } else {
                    Log.d("AudioSettingsManager", "setStreamVolume() skipped - streamType: ${getStreamName(streamType)} already at max: $currentVolume")
                }
            } catch (e: Exception) {
                // Bazı cihazlarda bazı stream'ler ayarlanamayabilir (izin eksikliği, OEM kısıtlamaları)
                // Bu durumda diğer stream'lerle devam et
                Log.e("AudioSettingsManager", "Failed to set volume for ${getStreamName(streamType)}: ${e.message}", e)
            }
        }
    }
    
    private fun ensureVibrationEnabled(audioManager: AudioManager) {
        // Titreşimi aç: RINGER_MODE_VIBRATE veya RINGER_MODE_NORMAL olmalı
        // RINGER_MODE_SILENT ise RINGER_MODE_NORMAL'a geç (ses + titreşim)
        val currentRingerMode = audioManager.ringerMode
        Log.d("AudioSettingsManager", "ensureVibrationEnabled() called - currentRingerMode: $currentRingerMode")
        
        if (currentRingerMode == AudioManager.RINGER_MODE_SILENT) {
            try {
                // Silent moddan çık - NORMAL moda geç (ses + titreşim)
                audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
                Log.d("AudioSettingsManager", "audioManager.ringerMode set to RINGER_MODE_NORMAL (from SILENT)")
            } catch (e: Exception) {
                Log.e("AudioSettingsManager", "Failed to set ringer mode to NORMAL: ${e.message}", e)
            }
        } else if (currentRingerMode == AudioManager.RINGER_MODE_VIBRATE) {
            // Vibrate modda - ses açık değil ama titreşim var, bu yeterli
            // Ancak ses de açmak için NORMAL moda geç
            try {
                audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
                Log.d("AudioSettingsManager", "audioManager.ringerMode set to RINGER_MODE_NORMAL (from VIBRATE)")
            } catch (e: Exception) {
                Log.e("AudioSettingsManager", "Failed to set ringer mode to NORMAL: ${e.message}", e)
            }
        }
        // RINGER_MODE_NORMAL zaten açık - ses ve titreşim aktif
    }
    
    private fun getStreamName(streamType: Int): String {
        return when (streamType) {
            AudioManager.STREAM_ALARM -> "STREAM_ALARM"
            AudioManager.STREAM_MUSIC -> "STREAM_MUSIC"
            AudioManager.STREAM_RING -> "STREAM_RING"
            AudioManager.STREAM_NOTIFICATION -> "STREAM_NOTIFICATION"
            AudioManager.STREAM_SYSTEM -> "STREAM_SYSTEM"
            else -> "UNKNOWN($streamType)"
        }
    }
}
