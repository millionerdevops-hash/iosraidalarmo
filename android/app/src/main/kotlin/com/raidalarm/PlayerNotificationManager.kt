package com.raidalarm

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat

object PlayerNotificationManager {
    private const val NOTIFICATION_ID_BASE = 2000

    fun showPlayerStatusNotification(context: Context, playerName: String, serverName: String, isOnline: Boolean) {
        try {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            
            // Ensure channel exists
            try {
                NotificationChannelHelper.createPlayerTrackingChannel(context)
            } catch (e: Exception) {
                // Log but continue, channel creation might fail on older Android versions or due to other issues
            }
            
            val statusEmoji = if (isOnline) "🔴" else "💤"
            val statusText = if (isOnline) context.getString(R.string.player_status_online) else context.getString(R.string.player_status_offline)
            val title = context.getString(R.string.player_status_title, statusEmoji, playerName, statusText)
            
            // Body text
            val body = if (isOnline) 
                context.getString(R.string.player_status_joined_body, playerName, serverName) 
            else 
                context.getString(R.string.player_status_left_body, playerName, serverName)
            
            // Intent to open app
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 
                0, 
                intent, 
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val builder = NotificationCompat.Builder(context, "raidalarm_player_tracking")
                .setSmallIcon(R.mipmap.ic_launcher) 
                .setContentTitle(title)
                .setContentText(body)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                
            val notification = builder.build()
                
            // Use timestamp for ID to ensure every event creates a new notification (stacking)
            // ensuring headers-up alerts appear every time.
            val notificationId = System.currentTimeMillis().toInt()
            notificationManager.notify(notificationId, notification)
        } catch (e: Exception) {
            // Permission might be denied or other system error
            // Safe to ignore to prevent app crash
        }
    }
}
