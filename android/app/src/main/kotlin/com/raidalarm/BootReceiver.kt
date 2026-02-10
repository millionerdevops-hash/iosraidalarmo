package com.raidalarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class BootReceiver : BroadcastReceiver() {
    
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d("BootReceiver", "onReceive() called - action: $action")
        
        if (action == Intent.ACTION_BOOT_COMPLETED || 
            action == "android.intent.action.QUICKBOOT_POWERON" ||
            action == "com.htc.intent.action.QUICKBOOT_POWERON") {
            
            CoroutineScope(Dispatchers.Default + SupervisorJob()).launch {
                Log.d("BootReceiver", "CoroutineScope.launch() called")
                delay(5000)
                Log.d("BootReceiver", "delay(5000) completed")
                
                // NotificationListener check removed
                // val isEnabled = NotificationListenerHelper.isNotificationServiceEnabled(context)
                // Log.d("BootReceiver", "isNotificationServiceEnabled() called: $isEnabled")
                
                // if (isEnabled) {
                //     NotificationHelper.cancelServiceDisabledNotification(context)
                //     Log.d("BootReceiver", "cancelServiceDisabledNotification() called")
                // } else {
                //     NotificationHelper.showServiceDisabledNotification(context)
                //     Log.d("BootReceiver", "showServiceDisabledNotification() called")
                // }
                
                try {
                    val dbHelper = DatabaseHelper.getInstance(context)
                    Log.d("BootReceiver", "DatabaseHelper.getInstance() called")
                    val db = dbHelper.readableDatabase
                    Log.d("BootReceiver", "readableDatabase accessed")
                    
                    // Memory leak önleme: cursor'ı try-finally ile kapat
                    val cursor = db.rawQuery("SELECT COUNT(*) FROM notifications", null)
                    Log.d("BootReceiver", "db.rawQuery() called - notification count")
                    val notificationCount = try {
                        if (cursor.moveToFirst()) {
                            val count = cursor.getInt(0)
                            Log.d("BootReceiver", "cursor.getInt() called - notificationCount: $count")
                            count
                        } else {
                            0
                        }
                    } finally {
                        cursor.close()
                        Log.d("BootReceiver", "cursor.close() called")
                    }
                    
                    // Memory leak önleme: cursor'ı try-finally ile kapat
                    val settingsCursor = db.query(
                        "app_settings",
                        arrayOf("value"),
                        "key = ?",
                        arrayOf("totalAttackCount"),
                        null,
                        null,
                        null,
                        "1"
                    )
                    Log.d("BootReceiver", "db.query() called - totalAttackCount")
                    val totalAttackCount = try {
                        if (settingsCursor.moveToFirst()) {
                            val countStr = settingsCursor.getString(0)
                            Log.d("BootReceiver", "settingsCursor.getString() called - value: $countStr")
                            countStr.toIntOrNull() ?: 0
                        } else {
                            0
                        }
                    } finally {
                        settingsCursor.close()
                        Log.d("BootReceiver", "settingsCursor.close() called")
                    }
                } catch (e: Exception) {
                    Log.e("BootReceiver", "Error checking database on boot: ${e.message}", e)
                }
            }
        }
    }
}
