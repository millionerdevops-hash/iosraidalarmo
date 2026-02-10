package com.raidalarm

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log

object ActivityUtils {
    
    fun moveActivityToFront(
        context: Context,
        delayMs: Long = 0,
        logTag: String = "ActivityUtils"
    ) {
        val runnable = Runnable {
            try {
                val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                Log.d("ActivityUtils", "getSystemService(ACTIVITY_SERVICE) called")
                var success = false
                
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    val tasks = activityManager.appTasks
                    Log.d("ActivityUtils", "activityManager.appTasks accessed - count: ${tasks.size}")
                    if (tasks.isNotEmpty()) {
                        tasks[0].moveToFront()
                        Log.d("ActivityUtils", "tasks[0].moveToFront() called")
                        success = true
                    }
                }
                
                if (!success) {
                    try {
                        @Suppress("DEPRECATION")
                        val tasks = activityManager.getRunningTasks(1)
                        Log.d("ActivityUtils", "getRunningTasks() called - count: ${tasks.size}")
                        if (tasks.isNotEmpty()) {
                            val topActivity = tasks[0].topActivity
                            Log.d("ActivityUtils", "topActivity accessed: ${topActivity?.packageName}")
                            if (topActivity?.packageName == context.packageName) {
                                activityManager.moveTaskToFront(
                                    tasks[0].id,
                                    ActivityManager.MOVE_TASK_WITH_HOME
                                )
                                Log.d("ActivityUtils", "moveTaskToFront() called - taskId: ${tasks[0].id}")
                            }
                        }
                    } catch (e: Exception) {
                        Log.e(logTag, "Error using deprecated getRunningTasks: ${e.message}", e)
                    }
                }
            } catch (e: Exception) {
                Log.e(logTag, "Error moving activity to front: ${e.message}", e)
            }
        }
        
        if (delayMs > 0) {
            Handler(Looper.getMainLooper()).postDelayed(runnable, delayMs)
            Log.d("ActivityUtils", "postDelayed() called - delayMs: $delayMs")
        } else {
            runnable.run()
            Log.d("ActivityUtils", "runnable.run() called immediately")
        }
    }
    
    fun isAppInForeground(context: Context): Boolean {
        try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            Log.d("ActivityUtils", "getSystemService(ACTIVITY_SERVICE) called")
            val runningProcesses = activityManager.runningAppProcesses
            Log.d("ActivityUtils", "runningAppProcesses accessed - count: ${runningProcesses?.size ?: 0}")
            
            if (runningProcesses != null) {
                val packageName = context.packageName
                for (processInfo in runningProcesses) {
                    if (processInfo.processName == packageName) {
                        Log.d("ActivityUtils", "processInfo.processName matched: $packageName")
                        val isForeground = processInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND ||
                                          processInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_VISIBLE ||
                                          processInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND_SERVICE
                        Log.d("ActivityUtils", "isAppInForeground() returned: $isForeground (importance: ${processInfo.importance})")
                        return isForeground
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("ActivityUtils", "Error checking if app is in foreground: ${e.message}", e)
        }
        return false
    }
    
    fun isAppReallyInForeground(context: Context): Boolean {
        try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            Log.d("ActivityUtils", "getSystemService(ACTIVITY_SERVICE) called")
            val runningProcesses = activityManager.runningAppProcesses
            Log.d("ActivityUtils", "runningAppProcesses accessed - count: ${runningProcesses?.size ?: 0}")
            
            if (runningProcesses != null) {
                val packageName = context.packageName
                for (processInfo in runningProcesses) {
                    if (processInfo.processName == packageName) {
                        Log.d("ActivityUtils", "processInfo.processName matched: $packageName")
                        val isReallyForeground = processInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
                        Log.d("ActivityUtils", "isAppReallyInForeground() returned: $isReallyForeground (importance: ${processInfo.importance})")
                        return isReallyForeground
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("ActivityUtils", "Error checking if app is really in foreground: ${e.message}", e)
        }
        return false
    }
}
