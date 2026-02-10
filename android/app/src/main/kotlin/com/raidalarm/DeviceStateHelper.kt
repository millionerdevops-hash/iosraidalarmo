package com.raidalarm

import android.app.KeyguardManager
import android.content.Context
import android.os.PowerManager
import android.util.Log

object DeviceStateHelper {
    
    /**
     * Telefonun kilitli olup olmadığını kontrol eder.
     * 
     * @param context Context
     * @param logTag Log tag (varsayılan: "DeviceStateHelper")
     * @return true: Telefon kilitli veya ekran kapalı, false: Telefon açık ve ekran açık
     */
    fun isPhoneLocked(context: Context, logTag: String = "DeviceStateHelper"): Boolean {
        return try {
            val keyguardManager = context.getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            val isLocked = keyguardManager.isDeviceLocked
            Log.d(logTag, "isDeviceLocked: $isLocked")
            
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            val isScreenOn = powerManager.isInteractive
            Log.d(logTag, "isInteractive: $isScreenOn")
            
            val result = isLocked || !isScreenOn
            Log.d(logTag, "isPhoneLocked: $result")
            result
        } catch (e: Exception) {
            Log.e(logTag, "Error checking phone lock state: ${e.message}", e)
            // Hata durumunda güvenli tarafta kal: telefon kilitli kabul et
            true
        }
    }
}
