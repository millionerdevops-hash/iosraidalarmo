package com.raidalarm

import android.app.Application
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MyApplication : Application() {
    
    companion object {
        private const val ENGINE_ID = "main_engine"
    }
    
    override fun onCreate() {
        super.onCreate()
        
        try {
            val flutterEngine = FlutterEngine(this)
            Log.d("MyApplication", "FlutterEngine created")
            
            // Engine'in geçerli olduğunu doğrula
            val dartExecutor = flutterEngine.dartExecutor
            if (dartExecutor == null) {
                Log.e("MyApplication", "FlutterEngine.dartExecutor is null, not caching engine")
                return
            }
            
            val binaryMessenger = dartExecutor.binaryMessenger
            if (binaryMessenger == null) {
                Log.e("MyApplication", "FlutterEngine.dartExecutor.binaryMessenger is null, not caching engine")
                return
            }
            
            // Engine geçerli, cache'e ekle
            FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
            Log.d("MyApplication", "FlutterEngine cached: $ENGINE_ID")
        } catch (e: Exception) {
            Log.e("MyApplication", "Error creating/caching FlutterEngine: ${e.message}", e)
        }
    }
}
