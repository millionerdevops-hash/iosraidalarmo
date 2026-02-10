package com.raidalarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.PowerManager
import android.util.Log
import org.json.JSONArray
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class PlayerTrackingReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "RaidAlarm:PlayerCheck")
        
        try {
            wakeLock.acquire(60 * 1000L) // 1 minute max timeout
            Log.d("PlayerTrackingReceiver", "Alarm received, starting check...")

            Thread {
                try {
                    checkPlayers(context)
                } catch (e: Exception) {
                    Log.e("PlayerTrackingReceiver", "Error in checkPlayers: ${e.message}", e)
                } finally {
                    try {
                        // Schedule next run regardless of success/failure
                        PlayerTrackingScheduler.scheduleNextAlarm(context)
                    } catch (e: Exception) {
                         Log.e("PlayerTrackingReceiver", "Error rescheduling: ${e.message}", e)
                    }
                    
                    if (wakeLock.isHeld) {
                        wakeLock.release()
                    }
                }
            }.start()
        } catch (e: Exception) {
             Log.e("PlayerTrackingReceiver", "WakeLock error: ${e.message}", e)
        }
    }

    private fun checkPlayers(context: Context) {
        // 1. Read directly from SQLite Database using PlayerTrackerDatabaseHelper
        val dbHelper = PlayerTrackerDatabaseHelper(context)
        val players = dbHelper.getTrackedPlayers() // Returns List<JSONObject>

        if (players.isEmpty()) {
            Log.d("PlayerTrackingReceiver", "No tracking list found in Database")
            return
        }

        // 2. Iterate and Check Each Player Individually
        Log.d("PlayerTrackingReceiver", "Checking ${players.size} players sequentially from DB...")
        
        var stateChanged = false

        for (trackedPlayer in players) {
            val tId = trackedPlayer.getString("id")
            val tName = trackedPlayer.getString("name")
            val notificationSent = trackedPlayer.optBoolean("notificationSent", false)
            
            // OPTIMIZATION: Skip API check if notification already sent
            // Mantık: Bildirim gönderildiyse (1), kullanıcı güncelleme yapana kadar (0 olana kadar) tekrar kontrol etme
            if (notificationSent) {
               Log.d("PlayerTrackingReceiver", "[$tName] Skipping check - notification already sent (waiting for user update)")
               continue
            }
            
            try {
                val urlStr = "https://api.battlemetrics.com/players/$tId?include=server"
                Log.d("PlayerTrackingReceiver", "[$tName] Requesting API: $urlStr")
                
                val url = URL(urlStr)
                val conn = url.openConnection() as HttpURLConnection
                conn.requestMethod = "GET"
                conn.connectTimeout = 20000
                conn.readTimeout = 20000
                conn.setRequestProperty("User-Agent", "RaidAlarm/1.0 (Android Native)")
                conn.setRequestProperty("Accept", "application/json")

                val responseCode = conn.responseCode
                if (responseCode == 200) {
                    val reader = BufferedReader(InputStreamReader(conn.inputStream))
                    val response = StringBuilder()
                    var line: String?
                    while (reader.readLine().also { line = it } != null) {
                        response.append(line)
                    }
                    reader.close()

                    // Parse
                    val jsonResponse = JSONObject(response.toString())
                    val data = jsonResponse.optJSONObject("data")
                    
                    if (data != null) {
                        // Check 'included' array for servers
                        val included = jsonResponse.optJSONArray("included")
                        
                        val targetServerId = trackedPlayer.getString("serverId")
                        val serverName = trackedPlayer.optString("serverName", context.getString(R.string.unknown_server))

                        var isOnlineNow = false
                        val serverIdsFound = StringBuilder()

                        if (included != null) {
                            for (k in 0 until included.length()) {
                                val s = included.getJSONObject(k)
                                if (s.optString("type") != "server") continue
                                
                                val sId = s.optString("id")
                                
                                // Check metadata for actual online status
                                val meta = s.optJSONObject("meta")
                                val isActuallyOnline = meta?.optBoolean("online", false) ?: false
                                
                                if (serverIdsFound.isNotEmpty()) serverIdsFound.append(",")
                                serverIdsFound.append("$sId(Online:$isActuallyOnline)")
                                
                                if (sId == targetServerId && isActuallyOnline) {
                                    isOnlineNow = true;
                                    break // Found them online on target server, no need to check others
                                }
                            }
                        }
                        
                        Log.d("PlayerTrackingReceiver", "[$tName] Servers: [$serverIdsFound] | Target: $targetServerId | Online: $isOnlineNow")

                        val wasOnline = trackedPlayer.optBoolean("isOnline", false)

                        if (isOnlineNow != wasOnline) {
                            Log.i("PlayerTrackingReceiver", "Status change for $tName: $wasOnline -> $isOnlineNow")
                            
                            val notifyOnOnline = trackedPlayer.optBoolean("notifyOnOnline", true)
                            val notifyOnOffline = trackedPlayer.optBoolean("notifyOnOffline", false)
                            
                            var shouldNotify = false
                            if (isOnlineNow && notifyOnOnline) {
                                shouldNotify = true
                            } else if (!isOnlineNow && notifyOnOffline) {
                                shouldNotify = true
                            }
                            
                            if (shouldNotify) {
                                try {
                                    PlayerNotificationManager.showPlayerStatusNotification(
                                        context,
                                        tName,
                                        serverName,
                                        isOnlineNow
                                    )
                                } catch (e: Exception) {
                                    Log.e("PlayerTrackingReceiver", "Notification Error: ${e.message}")
                                }
                            } else {
                                Log.d("PlayerTrackingReceiver", "Notification skipped (Online:$notifyOnOnline, Offline:$notifyOnOffline)")
                            }
                            
                            // Update Status in DB with notification_sent flag
                            val currentTime = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US).format(Date())
                            dbHelper.updatePlayerStatus(
                                serverId = trackedPlayer.getString("serverId"),
                                playerId = tId,
                                isOnline = isOnlineNow,
                                lastSeen = currentTime,
                                notificationSent = shouldNotify // Mark as sent if notification was sent
                            )
                            stateChanged = true
                        }
                    } else {
                         Log.w("PlayerTrackingReceiver", "[$tName] No 'data' in response")
                    }
                } else {
                     Log.e("PlayerTrackingReceiver", "[$tName] API Request failed: $responseCode")
                }
                
                conn.disconnect()
                
            } catch (e: Exception) {
                Log.e("PlayerTrackingReceiver", "[$tName] Error processing player: ${e.message}", e)
            }
        }

            // 4. Save New State (if changed)
            if (stateChanged) {
             Log.d("PlayerTrackingReceiver", "State changes detected and updated in DB.")
        }
    }
}
