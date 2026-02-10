package com.raidalarm

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log
import org.json.JSONArray
import org.json.JSONObject

class DatabaseHelper private constructor(context: Context) : SQLiteOpenHelper(
    context,
    DATABASE_NAME,
    null,
    DATABASE_VERSION
) {
    companion object {
        private const val TAG = "DatabaseHelper"
        private const val DATABASE_NAME = "raidalarm.db"
        private const val DATABASE_VERSION = 10

        @Volatile
        private var INSTANCE: DatabaseHelper? = null

        fun getInstance(context: Context): DatabaseHelper {
            return INSTANCE ?: synchronized(this) {
                val instance = DatabaseHelper(context.applicationContext)
                INSTANCE = instance
                Log.d("DatabaseHelper", "getInstance() called - new instance created")
                instance
            }
        }
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
        """.trimIndent())
        
        db.execSQL("""
            CREATE INDEX IF NOT EXISTS idx_notifications_timestamp 
            ON notifications(timestamp DESC)
        """.trimIndent())

        db.execSQL("""
            CREATE INDEX IF NOT EXISTS idx_notifications_package_channel 
            ON notifications(package_name, channel_id)
        """.trimIndent())

        db.execSQL("""
            CREATE INDEX IF NOT EXISTS idx_notifications_package_channel_timestamp 
            ON notifications(package_name, channel_id, timestamp DESC)
        """.trimIndent())

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
        """.trimIndent())

        db.execSQL("""
            CREATE INDEX IF NOT EXISTS idx_attack_statistics_date 
            ON attack_statistics(date DESC)
        """.trimIndent())

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS app_settings (
                key TEXT PRIMARY KEY,
                value TEXT NOT NULL,
                updated_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
            )
        """.trimIndent())

        db.insert("app_settings", null, android.content.ContentValues().apply {
            put("key", "totalAttackCount")
            put("value", "0")
        })

        // -- New Tables added to match app_database.dart (Flutter) --

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS permission_cache (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                permission_type TEXT UNIQUE NOT NULL,
                is_granted INTEGER NOT NULL,
                last_checked INTEGER NOT NULL
            )
        """.trimIndent())
        
        db.execSQL("""
            CREATE INDEX IF NOT EXISTS idx_permission_cache_type ON permission_cache(permission_type)
        """.trimIndent())

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS favorites (
                id TEXT PRIMARY KEY,
                data TEXT NOT NULL
            )
        """.trimIndent())

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
        """.trimIndent())

        db.execSQL("""
            CREATE TABLE IF NOT EXISTS wipe_alerts (
                server_id TEXT PRIMARY KEY,
                server_name TEXT,
                wipe_time TEXT NOT NULL,
                alert_minutes INTEGER NOT NULL DEFAULT 30,
                is_enabled INTEGER NOT NULL DEFAULT 0,
                notification_id INTEGER NOT NULL
            )
        """.trimIndent())
        
        Log.d("DatabaseHelper", "onCreate() completed with FULL schema")
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        Log.d("DatabaseHelper", "onUpgrade() called: $oldVersion -> $newVersion")

        // Ensure the optimized composite index exists for all users
        db.execSQL("""
            CREATE INDEX IF NOT EXISTS idx_notifications_package_channel_timestamp 
            ON notifications(package_name, channel_id, timestamp DESC)
        """.trimIndent())

        if (oldVersion < 2) {
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS permission_cache (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    permission_type TEXT UNIQUE NOT NULL,
                    is_granted INTEGER NOT NULL,
                    last_checked INTEGER NOT NULL
                )
            """.trimIndent())
            db.execSQL("CREATE INDEX IF NOT EXISTS idx_permission_cache_type ON permission_cache(permission_type)")
        }

        if (oldVersion < 4) {
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS favorites (
                    id TEXT PRIMARY KEY,
                    data TEXT NOT NULL
                )
            """.trimIndent())
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
            """.trimIndent())
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
             // v8 was also adding player_id, redundant check handled by columnExists
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
            """.trimIndent())
        }
    }

    private fun columnExists(db: SQLiteDatabase, table: String, column: String): Boolean {
        var cursor: android.database.Cursor? = null
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
            Log.e(TAG, "Error checking column existence: ${e.message}")
            return false
        } finally {
            cursor?.close()
        }
    }

    fun saveNotification(
        title: String?,
        body: String?,
        subtitle: String?,
        packageName: String,
        timestamp: Long,
        channelId: String?
    ): Boolean {
        return try {
            val db = writableDatabase
            Log.d("DatabaseHelper", "writableDatabase accessed")

            db.beginTransaction()
            Log.d("DatabaseHelper", "beginTransaction() called")
            try {
                // Deduplication: 3 saniye içinde aynı kanaldan/paketten gelen bildirimleri kontrol et
                // Rust+ (veya sistem) bazen aynı bildirimi güncelleyerek (timestamp değişse bile) tekrar gönderebiliyor
                // Bu durumda alarmın tekrar tetiklenmemesi için "yeni" bildirimi kaydetmiyoruz (false dönüyoruz)
                val checkTime = timestamp - 3000 // 3 saniye öncesine kadar bak
                val cursor = db.query(
                    "notifications",
                    arrayOf("id"),
                    "timestamp > ? AND package_name = ? AND channel_id = ?",
                    arrayOf(checkTime.toString(), packageName, channelId ?: ""),
                    null,
                    null,
                    null,
                    "1"
                )
                Log.d("DatabaseHelper", "db.query() called - duplicate check")

                // Memory leak önleme: cursor'ı try-finally ile kapat
                try {
                    if (cursor.moveToFirst()) {
                        Log.d("DatabaseHelper", "cursor.moveToFirst() returned true - duplicate found")
                        return false
                    }
                } finally {
                    cursor.close()
                    Log.d("DatabaseHelper", "cursor.close() called")
                }

                val values = android.content.ContentValues().apply {
                    put("timestamp", timestamp)
                    put("package_name", packageName)
                    put("channel_id", channelId)
                    put("title", title)
                    put("body", body)
                    put("subtitle", subtitle)
                }
                Log.d("DatabaseHelper", "ContentValues created")

                val result = db.insertWithOnConflict(
                    "notifications",
                    null,
                    values,
                    SQLiteDatabase.CONFLICT_IGNORE
                )
                Log.d("DatabaseHelper", "db.insertWithOnConflict() called - result: $result")

                if (result != -1L) {
                    db.setTransactionSuccessful()
                    Log.d("DatabaseHelper", "setTransactionSuccessful() called")
                    return true
                } else {
                    return false
                }
            } finally {
                db.endTransaction()
                Log.d("DatabaseHelper", "endTransaction() called")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error saving notification: ${e.message}", e)
            false
        }
    }

    fun recordAttack(timestamp: Long) {
        try {
            val db = writableDatabase
            Log.d("DatabaseHelper", "writableDatabase accessed")

            db.beginTransaction()
            Log.d("DatabaseHelper", "beginTransaction() called")
            try {
                val currentCount = getTotalAttackCount(db)
                Log.d("DatabaseHelper", "getTotalAttackCount() returned: $currentCount")
                setTotalAttackCount(db, currentCount + 1)
                Log.d("DatabaseHelper", "setTotalAttackCount() called")

                setLastAttackTime(db, timestamp)
                Log.d("DatabaseHelper", "setLastAttackTime() called")

                val calendar = java.util.Calendar.getInstance().apply {
                    timeInMillis = timestamp
                }
                Log.d("DatabaseHelper", "Calendar.getInstance() called")
                val year = calendar.get(java.util.Calendar.YEAR)
                val month = calendar.get(java.util.Calendar.MONTH) + 1
                val day = calendar.get(java.util.Calendar.DAY_OF_MONTH)
                val hour = calendar.get(java.util.Calendar.HOUR_OF_DAY)
                Log.d("DatabaseHelper", "calendar.get() called - year: $year, month: $month, day: $day, hour: $hour")
                val dateKey = String.format("%04d-%02d-%02d", year, month, day)
                val weekNumber = getWeekNumber(calendar)
                val weekKey = "$year-W$weekNumber"
                val monthKey = String.format("%04d-%02d", year, month)
                Log.d("DatabaseHelper", "dateKey: $dateKey, weekKey: $weekKey, monthKey: $monthKey")

                updateDailyCount(db, dateKey)
                Log.d("DatabaseHelper", "updateDailyCount() called")

                updateHourlyCount(db, dateKey, hour)
                Log.d("DatabaseHelper", "updateHourlyCount() called")

                updateWeeklyCount(db, weekKey)
                Log.d("DatabaseHelper", "updateWeeklyCount() called")

                updateMonthlyCount(db, monthKey)
                Log.d("DatabaseHelper", "updateMonthlyCount() called")
                
                db.setTransactionSuccessful()
                Log.d("DatabaseHelper", "setTransactionSuccessful() called")
            } finally {
                db.endTransaction()
                Log.d("DatabaseHelper", "endTransaction() called")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error recording attack: ${e.message}", e)
        }
    }

    fun loadAlarmSettings(): JSONObject? {
        val db = readableDatabase
        Log.d("DatabaseHelper", "readableDatabase accessed")
        val cursor = db.query(
            "app_settings",
            arrayOf("value"),
            "key = ?",
            arrayOf("alarmSettings"),
            null,
            null,
            null,
            "1"
        )
        Log.d("DatabaseHelper", "db.query() called - loadAlarmSettings")
        
        return try {
            if (cursor.moveToFirst()) {
                Log.d("DatabaseHelper", "cursor.moveToFirst() returned true")
                val jsonString = cursor.getString(0)
                Log.d("DatabaseHelper", "cursor.getString() called - value length: ${jsonString.length}")
                JSONObject(jsonString)
            } else {
                null
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error loading alarm settings: ${e.message}", e)
            null
        } finally {
            // Memory leak önleme: cursor'ı mutlaka kapat
            cursor.close()
            Log.d("DatabaseHelper", "cursor.close() called")
        }
    }

    private fun getTotalAttackCount(db: SQLiteDatabase): Int {
        val cursor = db.query(
            "app_settings",
            arrayOf("value"),
            "key = ?",
            arrayOf("totalAttackCount"),
            null,
            null,
            null,
            "1"
        )
        Log.d("DatabaseHelper", "db.query() called - getTotalAttackCount")
        return try {
            if (cursor.moveToFirst()) {
                val count = cursor.getInt(0)
                Log.d("DatabaseHelper", "cursor.getInt() called - count: $count")
                count
            } else {
                0
            }
        } finally {
            // Memory leak önleme: cursor'ı mutlaka kapat
            cursor.close()
            Log.d("DatabaseHelper", "cursor.close() called")
        }
    }

    private fun setTotalAttackCount(db: SQLiteDatabase, count: Int) {
        val values = android.content.ContentValues().apply {
            put("key", "totalAttackCount")
            put("value", count.toString())
            put("updated_at", System.currentTimeMillis() / 1000)
        }
        Log.d("DatabaseHelper", "ContentValues created - setTotalAttackCount: $count")
        db.insertWithOnConflict(
            "app_settings",
            null,
            values,
            SQLiteDatabase.CONFLICT_REPLACE
        )
        Log.d("DatabaseHelper", "db.insertWithOnConflict() called - setTotalAttackCount")
    }

    private fun setLastAttackTime(db: SQLiteDatabase, timestamp: Long) {
        val values = android.content.ContentValues().apply {
            put("key", "lastAttackTime")
            put("value", timestamp.toString())
            put("updated_at", System.currentTimeMillis() / 1000)
        }
        Log.d("DatabaseHelper", "ContentValues created - setLastAttackTime: $timestamp")
        db.insertWithOnConflict(
            "app_settings",
            null,
            values,
            SQLiteDatabase.CONFLICT_REPLACE
        )
        Log.d("DatabaseHelper", "db.insertWithOnConflict() called - setLastAttackTime")
    }

    private fun updateDailyCount(db: SQLiteDatabase, dateKey: String) {
        val cursor = db.query(
            "attack_statistics",
            arrayOf("daily_count"),
            "date = ?",
            arrayOf(dateKey),
            null,
            null,
            null,
            "1"
        )
        Log.d("DatabaseHelper", "db.query() called - updateDailyCount: $dateKey")

        try {
            if (cursor.moveToFirst()) {
                val currentCount = cursor.getInt(0)
                Log.d("DatabaseHelper", "cursor.getInt() called - currentCount: $currentCount")
                val newCount = currentCount + 1
                val values = android.content.ContentValues().apply {
                    put("daily_count", newCount)
                    put("updated_at", System.currentTimeMillis() / 1000)
                }
                Log.d("DatabaseHelper", "ContentValues created - updateDailyCount: $newCount")
                val rowsUpdated = db.update("attack_statistics", values, "date = ?", arrayOf(dateKey))
                Log.d("DatabaseHelper", "db.update() called - rowsUpdated: $rowsUpdated")
            } else {
                val values = android.content.ContentValues().apply {
                    put("date", dateKey)
                    put("daily_count", 1)
                    put("updated_at", System.currentTimeMillis() / 1000)
                }
                Log.d("DatabaseHelper", "ContentValues created - new daily_count record")
                val rowId = db.insert("attack_statistics", null, values)
                Log.d("DatabaseHelper", "db.insert() called - rowId: $rowId")
            }
        } finally {
            // Memory leak önleme: cursor'ı mutlaka kapat
            cursor.close()
            Log.d("DatabaseHelper", "cursor.close() called")
        }
    }

    private fun updateHourlyCount(db: SQLiteDatabase, dateKey: String, hour: Int) {
        val cursor = db.query(
            "attack_statistics",
            arrayOf("hourly_data", "daily_count"),
            "date = ?",
            arrayOf(dateKey),
            null,
            null,
            null,
            "1"
        )
        Log.d("DatabaseHelper", "db.query() called - updateHourlyCount: $dateKey, hour: $hour")

        var hourlyMap = JSONObject()
        var existingDailyCount = 0
        
        try {
            if (cursor.moveToFirst()) {
                val hourlyData = cursor.getString(0)
                Log.d("DatabaseHelper", "cursor.getString() called - hourlyData length: ${hourlyData?.length ?: 0}")
                if (hourlyData != null && hourlyData.isNotEmpty()) {
                    hourlyMap = JSONObject(hourlyData)
                    Log.d("DatabaseHelper", "JSONObject created from hourlyData")
                }
                existingDailyCount = cursor.getInt(1)
                Log.d("DatabaseHelper", "cursor.getInt() called - existingDailyCount: $existingDailyCount")
            }
        } finally {
            // Memory leak önleme: cursor'ı mutlaka kapat
            cursor.close()
            Log.d("DatabaseHelper", "cursor.close() called")
        }

        hourlyMap.put(hour.toString(), hourlyMap.optInt(hour.toString(), 0) + 1)
        Log.d("DatabaseHelper", "hourlyMap.put() called - hour: $hour")

        val values = android.content.ContentValues().apply {
            put("hourly_data", hourlyMap.toString())
            put("updated_at", System.currentTimeMillis() / 1000)
            put("daily_count", existingDailyCount)
        }
        Log.d("DatabaseHelper", "ContentValues created - updateHourlyCount")
        
        val rowsUpdated = db.update(
            "attack_statistics",
            values,
            "date = ?",
            arrayOf(dateKey)
        )
        Log.d("DatabaseHelper", "db.update() called - rowsUpdated: $rowsUpdated")
        
        if (rowsUpdated == 0) {
            values.put("date", dateKey)
            db.insert("attack_statistics", null, values)
            Log.d("DatabaseHelper", "db.insert() called - new hourly record")
        }
    }

    private fun updateWeeklyCount(db: SQLiteDatabase, weekKey: String) {
        db.execSQL(
            "UPDATE attack_statistics SET weekly_count = weekly_count + 1, updated_at = ? WHERE date LIKE ?",
            arrayOf(System.currentTimeMillis() / 1000, "$weekKey%")
        )
        Log.d("DatabaseHelper", "db.execSQL() called - updateWeeklyCount: $weekKey")
    }

    private fun updateMonthlyCount(db: SQLiteDatabase, monthKey: String) {
        db.execSQL(
            "UPDATE attack_statistics SET monthly_count = monthly_count + 1, updated_at = ? WHERE date LIKE ?",
            arrayOf(System.currentTimeMillis() / 1000, "$monthKey%")
        )
        Log.d("DatabaseHelper", "db.execSQL() called - updateMonthlyCount: $monthKey")
    }

    private fun getWeekNumber(calendar: java.util.Calendar): Int {
        val dayOfYear = calendar.get(java.util.Calendar.DAY_OF_YEAR)
        val dayOfWeek = calendar.get(java.util.Calendar.DAY_OF_WEEK)
        Log.d("DatabaseHelper", "calendar.get() called - dayOfYear: $dayOfYear, dayOfWeek: $dayOfWeek")
        return ((dayOfYear - dayOfWeek + 10) / 7).toInt()
    }
}
