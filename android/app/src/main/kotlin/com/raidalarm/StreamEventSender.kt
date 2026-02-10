package com.raidalarm

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.MethodChannel

object StreamEventSender {
    
    /**
     * MethodChannel üzerinden event gönderir, başarısız olursa retry yapar.
     * 
     * @param methodChannel Flutter MethodChannel
     * @param methodName Gönderilecek method adı
     * @param arguments Method argümanları
     * @param maxRetries Maksimum retry sayısı
     * @param retryDelayMs Retry arasındaki delay (ms)
     * @param onSuccess Başarılı olduğunda çağrılacak callback
     * @param onError Hata olduğunda çağrılacak callback
     */
    fun sendEventWithRetry(
        methodChannel: MethodChannel?,
        methodName: String,
        arguments: Map<String, Any>? = null,
        maxRetries: Int = 5,
        retryDelayMs: Long = 300L,
        onSuccess: (() -> Unit)? = null,
        onError: ((String) -> Unit)? = null
    ) {
        var retryCount = 0
        
        fun sendStreamEvent() {
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    if (methodChannel != null) {
                        methodChannel.invokeMethod(methodName, arguments)
                        Log.d("StreamEventSender", "invokeMethod() called: $methodName")
                        onSuccess?.invoke()
                    } else {
                        // MethodChannel null ise retry yap
                        retryCount++
                        if (retryCount < maxRetries) {
                            Log.d("StreamEventSender", "Retry triggered (count: $retryCount/$maxRetries)")
                            sendStreamEvent()
                        } else {
                            val errorMsg = "MethodChannel not ready after $maxRetries retries"
                            Log.e("StreamEventSender", errorMsg)
                            onError?.invoke(errorMsg)
                        }
                    }
                } catch (e: Exception) {
                    val errorMsg = "Error sending Stream event ($methodName): ${e.message}"
                    Log.e("StreamEventSender", errorMsg, e)
                    onError?.invoke(errorMsg)
                }
            }, retryDelayMs)
        }
        
        sendStreamEvent()
        Log.d("StreamEventSender", "sendEventWithRetry() started: $methodName")
    }
    
    /**
     * MethodChannel üzerinden event gönderir (retry yok).
     * 
     * @param methodChannel Flutter MethodChannel
     * @param methodName Gönderilecek method adı
     * @param arguments Method argümanları
     * @param delayMs Göndermeden önce delay (ms)
     */
    fun sendEventDirect(
        methodChannel: MethodChannel?,
        methodName: String,
        arguments: Map<String, Any>? = null,
        delayMs: Long = 200L
    ) {
        Handler(Looper.getMainLooper()).postDelayed({
            try {
                if (methodChannel != null) {
                    methodChannel.invokeMethod(methodName, arguments)
                    Log.d("StreamEventSender", "invokeMethod() called: $methodName")
                } else {
                    Log.w("StreamEventSender", "MethodChannel is null, cannot send: $methodName")
                }
            } catch (e: Exception) {
                Log.e("StreamEventSender", "Error sending event ($methodName): ${e.message}", e)
            }
        }, delayMs)
        Log.d("StreamEventSender", "sendEventDirect() started: $methodName")
    }
}
