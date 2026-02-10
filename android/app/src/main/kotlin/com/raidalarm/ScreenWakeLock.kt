package com.raidalarm

import android.content.Context
import android.os.PowerManager
import android.util.Log

object ScreenWakeLock {
    private var wakeLock: PowerManager.WakeLock? = null
    
    /**
     * Ekranı açmak için wake lock alır.
     * FLAG_KEEP_SCREEN_ON window flag'i ekranı açık tutar,
     * bu wake lock ise ekranı açmak için kullanılır.
     */
    fun acquire(context: Context) {
        try {
            if (wakeLock?.isHeld == true) {
                return
            }
            
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            // PARTIAL_WAKE_LOCK + ACQUIRE_CAUSES_WAKEUP: Ekranı açmak için
            // SCREEN_BRIGHT_WAKE_LOCK deprecated olduğu için PARTIAL_WAKE_LOCK kullanıyoruz
            // FLAG_KEEP_SCREEN_ON window flag'i ekranı açık tutar
            wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "RaidAlarm::ScreenWakeLock"
            )
            Log.d("ScreenWakeLock", "newWakeLock() called - PARTIAL_WAKE_LOCK + ACQUIRE_CAUSES_WAKEUP")
            
            // Ekstra güvenlik için 5 dakika timeout (activity kapanırsa release edilir)
            wakeLock?.acquire(5 * 60 * 1000L)
            Log.d("ScreenWakeLock", "wakeLock.acquire() called - 5 minutes timeout")
        } catch (e: Exception) {
            Log.e("ScreenWakeLock", "Error acquiring wake lock: ${e.message}", e)
        }
    }
    
    fun release() {
        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
                Log.d("ScreenWakeLock", "wakeLock.release() called")
                wakeLock = null
            }
        } catch (e: Exception) {
            Log.e("ScreenWakeLock", "Error releasing wake lock: ${e.message}", e)
            wakeLock = null
        }
    }
    
    fun isHeld(): Boolean {
        return wakeLock?.isHeld == true
    }
}
