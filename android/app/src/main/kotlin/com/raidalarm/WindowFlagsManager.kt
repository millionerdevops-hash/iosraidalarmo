package com.raidalarm

import android.app.Activity
import android.util.Log
import android.view.WindowManager

object WindowFlagsManager {
    
    fun setWindowFlagsForLockedScreen(activity: Activity) {
        try {
            // Activity'yi kilit ekranının üstünde göster ve ekranı aç
            activity.setShowWhenLocked(true)
            activity.setTurnScreenOn(true)
            Log.d("WindowFlagsManager", "setShowWhenLocked(true) and setTurnScreenOn(true) called")
            
            // activity.window.addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
            // Log.d("WindowFlagsManager", "FLAG_DISMISS_KEYGUARD added")
            
            // Ekranı açık tut
            activity.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            Log.d("WindowFlagsManager", "FLAG_KEEP_SCREEN_ON added")
            
            // Activity'yi ön plana getir
            ActivityUtils.moveActivityToFront(activity, delayMs = 100, logTag = "WindowFlagsManager")
            Log.d("WindowFlagsManager", "ActivityUtils.moveActivityToFront() called")
            
            // Ekranı açmak için wake lock al
            ScreenWakeLock.acquire(activity)
            Log.d("WindowFlagsManager", "ScreenWakeLock.acquire() called")
        } catch (e: Exception) {
            Log.e("WindowFlagsManager", "Error setting window flags: ${e.message}", e)
        }
    }
}
