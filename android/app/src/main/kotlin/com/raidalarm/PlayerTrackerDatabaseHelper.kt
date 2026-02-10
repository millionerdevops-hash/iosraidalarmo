package com.raidalarm

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log
import org.json.JSONObject

class PlayerTrackerDatabaseHelper(private val context: Context) : SQLiteOpenHelper(context, "raidalarm.db", null, 10) {

    companion object {
        const val TABLE_TRACKED_PLAYERS = "tracked_players"
        const val COLUMN_SERVER_ID = "server_id"
        const val COLUMN_NAME = "name"
        const val COLUMN_PLAYER_ID = "player_id"
        const val COLUMN_IS_ONLINE = "is_online"
        const val COLUMN_LAST_SEEN = "last_seen"
        const val COLUMN_NOTIFY_ON_ONLINE = "notify_on_online"
        const val COLUMN_NOTIFY_ON_OFFLINE = "notify_on_offline"
        const val COLUMN_NOTIFICATION_SENT = "notification_sent"
    }

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("""
            CREATE TABLE IF NOT EXISTS notifications (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp INTEGER NOT NULL,
                package_name TEXT NOT NULL,
                channel_id TEXT,
                title TEXT,
                body TEXT,
                subtitle TEXT,
                created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
                UNIQUE(timestamp, package_name, channel_id)
            )
        """)
        
        db.execSQL("CREATE INDEX IF NOT EXISTS idx_notifications_timestamp ON notifications(timestamp DESC)")
        db.execSQL("CREATE INDEX IF NOT EXISTS idx_notifications_package_channel ON notifications(package_name, channel_id)")
        db.execSQL("CREATE INDEX IF NOT EXISTS idx_notifications_package_channel_timestamp ON notifications(package_name, channel_id, timestamp DESC)")

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS attack_statistics (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL UNIQUE,
                daily_count INTEGER DEFAULT 0,
                hourly_data TEXT,
                weekly_count INTEGER DEFAULT 0,
                monthly_count INTEGER DEFAULT 0,
                created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
                updated_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
            )
        """)

        db.execSQL("CREATE INDEX IF NOT EXISTS idx_attack_statistics_date ON attack_statistics(date DESC)")

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS app_settings (
                key TEXT PRIMARY KEY,
                value TEXT NOT NULL,
                updated_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
            )
        """)

        db.insert("app_settings", null, ContentValues().apply {
            put("key", "totalAttackCount")
            put("value", "0")
        })

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS permission_cache (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                permission_type TEXT UNIQUE NOT NULL,
                is_granted INTEGER NOT NULL,
                last_checked INTEGER NOT NULL
            )
        """)
        
        db.execSQL("CREATE INDEX IF NOT EXISTS idx_permission_cache_type ON permission_cache(permission_type)")

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS favorites (
                id TEXT PRIMARY KEY,
                data TEXT NOT NULL
            )
        """)

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS tracked_players (
                server_id TEXT NOT NULL,
                name TEXT NOT NULL,
                player_id TEXT,
                is_online INTEGER NOT NULL DEFAULT 0,
                last_seen TEXT NOT NULL,
                notify_on_online INTEGER NOT NULL DEFAULT 1,
                notify_on_offline INTEGER NOT NULL DEFAULT 0,
                notification_sent INTEGER NOT NULL DEFAULT 0,
                PRIMARY KEY (server_id, name)
            )
        """)

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS wipe_alerts (
                server_id TEXT PRIMARY KEY,
                server_name TEXT,
                wipe_time TEXT NOT NULL,
                alert_minutes INTEGER NOT NULL DEFAULT 30,
                is_enabled INTEGER NOT NULL DEFAULT 0,
                notification_id INTEGER NOT NULL
            )
        """)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("CREATE INDEX IF NOT EXISTS idx_notifications_package_channel_timestamp ON notifications(package_name, channel_id, timestamp DESC)")
        if (oldVersion < 2) {
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS permission_cache (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    permission_type TEXT UNIQUE NOT NULL,
                    is_granted INTEGER NOT NULL,
                    last_checked INTEGER NOT NULL
                )
            """)
            db.execSQL("CREATE INDEX IF NOT EXISTS idx_permission_cache_type ON permission_cache(permission_type)")
        }

        if (oldVersion < 4) {
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS favorites (
                    id TEXT PRIMARY KEY,
                    data TEXT NOT NULL
                )
            """)
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS tracked_players (
                    server_id TEXT NOT NULL,
                    name TEXT NOT NULL,
                    player_id TEXT,
                    is_online INTEGER NOT NULL DEFAULT 0,
                    last_seen TEXT NOT NULL,
                    notify_on_online INTEGER NOT NULL DEFAULT 1,
                    notify_on_offline INTEGER NOT NULL DEFAULT 0,
                    PRIMARY KEY (server_id, name)
                )
            """)
        }

        if (oldVersion < 6) {
            if (!columnExists(db, "tracked_players", "notify_on_online")) {
                db.execSQL("ALTER TABLE tracked_players ADD COLUMN notify_on_online INTEGER NOT NULL DEFAULT 1")
            }
            if (!columnExists(db, "tracked_players", "notify_on_offline")) {
                db.execSQL("ALTER TABLE tracked_players ADD COLUMN notify_on_offline INTEGER NOT NULL DEFAULT 0")
            }
        }

        if (oldVersion < 7) {
            if (!columnExists(db, "tracked_players", "player_id")) {
                db.execSQL("ALTER TABLE tracked_players ADD COLUMN player_id TEXT")
            }
        }

        if (oldVersion < 8) {
             if (!columnExists(db, "tracked_players", "player_id")) {
                db.execSQL("ALTER TABLE tracked_players ADD COLUMN player_id TEXT")
            }
        }

        if (oldVersion < 9) {
            if (!columnExists(db, "tracked_players", "notification_sent")) {
                db.execSQL("ALTER TABLE tracked_players ADD COLUMN notification_sent INTEGER NOT NULL DEFAULT 0")
            }
        }

        if (oldVersion < 10) {
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS wipe_alerts (
                    server_id TEXT PRIMARY KEY,
                    server_name TEXT,
                    wipe_time TEXT NOT NULL,
                    alert_minutes INTEGER NOT NULL DEFAULT 30,
                    is_enabled INTEGER NOT NULL DEFAULT 0,
                    notification_id INTEGER NOT NULL
                )
            """)
        }
    }

    private fun columnExists(db: SQLiteDatabase, table: String, column: String): Boolean {
        var cursor: Cursor? = null
        try {
            cursor = db.rawQuery("PRAGMA table_info($table)", null)
            if (cursor != null) {
                val nameIndex = cursor.getColumnIndex("name")
                if (nameIndex != -1) {
                    while (cursor.moveToNext()) {
                        val name = cursor.getString(nameIndex)
                        if (name == column) return true
                    }
                }
            }
            return false
        } catch (e: Exception) {
            Log.e("PlayerTrackerDB", "Error checking column existence: ${e.message}")
            return false
        } finally {
            cursor?.close()
        }
    }

    fun getTrackedPlayers(): List<JSONObject> {
        val players = mutableListOf<JSONObject>()
        
        // Use readableDatabase to avoid locking issues if possible
        var db: SQLiteDatabase? = null
        var cursor: Cursor? = null
        
        try {
            db = readableDatabase
            cursor = db.query(
                TABLE_TRACKED_PLAYERS,
                null, 
                null, 
                null, 
                null, 
                null, 
                null
            )

            if (cursor != null && cursor.moveToFirst()) {
                do {
                    val player = JSONObject()
                    try {
                        player.put("serverId", cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_SERVER_ID)))
                        player.put("name", cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_NAME)))
                        
                        // ID might be nullable in DB schema, but we need it.
                        // If null, we skip or use empty string (shouldn't happen for valid tracked players)
                        val pId = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_PLAYER_ID))
                        player.put("id", pId ?: "") 
                        
                        val isOnline = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_IS_ONLINE)) == 1
                        player.put("isOnline", isOnline)
                        
                        val notifyOnOnline = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_NOTIFY_ON_ONLINE)) == 1
                        player.put("notifyOnOnline", notifyOnOnline)
                        
                        val notifyOnOffline = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_NOTIFY_ON_OFFLINE)) == 1
                        player.put("notifyOnOffline", notifyOnOffline)
                        
                        val notificationSent = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_NOTIFICATION_SENT)) == 1
                        player.put("notificationSent", notificationSent)

                        // Fallback for server name
                        player.put("serverName", context.getString(R.string.default_server_name)) 
                        
                        players.add(player)
                    } catch (e: Exception) {
                        Log.e("PlayerTrackerDB", "Error parsing player row", e)
                    }
                } while (cursor.moveToNext())
            }
        } catch (e: Exception) {
            Log.e("PlayerTrackerDB", "Error getting tracked players", e)
        } finally {
            cursor?.close()
            db?.close()
        }
        return players
    }

    fun updatePlayerStatus(serverId: String, playerId: String, isOnline: Boolean, lastSeen: String, notificationSent: Boolean = false) {
        var db: SQLiteDatabase? = null
        try {
            db = writableDatabase
            val values = ContentValues().apply {
                put(COLUMN_IS_ONLINE, if (isOnline) 1 else 0)
                put(COLUMN_LAST_SEEN, lastSeen)
                put(COLUMN_NOTIFICATION_SENT, if (notificationSent) 1 else 0)
            }
            
            db.update(
                TABLE_TRACKED_PLAYERS,
                values,
                "$COLUMN_SERVER_ID = ? AND $COLUMN_PLAYER_ID = ?",
                arrayOf(serverId, playerId)
            )
        } catch (e: Exception) {
             Log.e("PlayerTrackerDB", "Error updating player status", e)
        } finally {
            db?.close()
        }
    }
}
