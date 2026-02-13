import Foundation
import SQLite3

class SettingsManager {
    static let shared = SettingsManager()
    
    private init() {}
    
    // MARK: - Stats & Database Updates
    
    func recordAttack() {
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        guard let db = openDatabase() else { return }
        defer { sqlite3_close(db) }
        
        // 1. Update Total Attack Count
        incrementTotalAttackCount(db)
        
        // 2. Update Last Attack Time
        setLastAttackTime(db, timestamp: timestamp)
        
        // 3. Update Statistics table (Daily, Weekly, Monthly)
        updateStatistics(db, timestamp: timestamp)
    }
    
    private func openDatabase() -> OpaquePointer? {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let dbPath = documentsPath.appendingPathComponent("raidalarm.db").path
        var db: OpaquePointer?
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            return db
        }
        return nil
    }

    private func incrementTotalAttackCount(_ db: OpaquePointer?) {
        // Get current
        var currentCount = 0
        let queryFn = "SELECT value FROM app_settings WHERE key = 'totalAttackCount'"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, queryFn, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                if let cString = sqlite3_column_text(stmt, 0) {
                    currentCount = Int(String(cString: cString)) ?? 0
                }
            }
        }
        sqlite3_finalize(stmt)
        
        // Update
        let newCount = currentCount + 1
        let updateQuery = "INSERT OR REPLACE INTO app_settings (key, value, updated_at) VALUES ('totalAttackCount', '\(newCount)', \(Int64(Date().timeIntervalSince1970)))"
        execute(db, sql: updateQuery)
        print("📈 Total Attack Count Updated: \(newCount)")
    }
    
    private func setLastAttackTime(_ db: OpaquePointer?, timestamp: Int64) {
        let query = "INSERT OR REPLACE INTO app_settings (key, value, updated_at) VALUES ('lastAttackTime', '\(timestamp)', \(Int64(Date().timeIntervalSince1970)))"
        execute(db, sql: query)
    }
    
    private func updateStatistics(_ db: OpaquePointer?, timestamp: Int64) {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        
        let dateKey = String(format: "%04d-%02d-%02d", year, month, day)
        let monthKey = String(format: "%04d-%02d", year, month)
        // Week calculation can be tricky to match Android exactly, but ISO week is standard
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let weekKey = String(format: "%04d-W%d", year, weekOfYear)

        // 3.1 Daily Count & Hourly Data
        updateDailyAndHourly(db, dateKey: dateKey, hour: hour)
        
        // 3.2 Weekly Count
        let updateWeekly = "UPDATE attack_statistics SET weekly_count = weekly_count + 1 WHERE date LIKE '\(weekKey)%'"
        execute(db, sql: updateWeekly)
        
        // 3.3 Monthly Count
        let updateMonthly = "UPDATE attack_statistics SET monthly_count = monthly_count + 1 WHERE date LIKE '\(monthKey)%'"
        execute(db, sql: updateMonthly)
    }
    
    private func updateDailyAndHourly(_ db: OpaquePointer?, dateKey: String, hour: Int) {
        // Check if row exists
        var exists = false
        var currentHourlyJson = "{}"
        var currentDaily = 0
        
        let query = "SELECT hourly_data, daily_count FROM attack_statistics WHERE date = '\(dateKey)'"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                exists = true
                if let cString = sqlite3_column_text(stmt, 0) {
                    currentHourlyJson = String(cString: cString)
                }
                currentDaily = Int(sqlite3_column_int(stmt, 1))
            }
        }
        sqlite3_finalize(stmt)
        
        // Parse JSON, increment hour, serialize back
        // Quick JSON manipulation
        var hourlyData: [String: Int] = [:]
        if let data = currentHourlyJson.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Int] {
            hourlyData = json
        }
        
        let hourStr = String(hour)
        hourlyData[hourStr] = (hourlyData[hourStr] ?? 0) + 1
        
        let newDaily = currentDaily + 1
        
        var newJsonString = "{}"
        if let jsonData = try? JSONSerialization.data(withJSONObject: hourlyData, options: []),
           let jsonStr = String(data: jsonData, encoding: .utf8) {
            newJsonString = jsonStr
        }
        
        if exists {
            let update = "UPDATE attack_statistics SET daily_count = \(newDaily), hourly_data = '\(newJsonString)', updated_at = \(Int64(Date().timeIntervalSince1970)) WHERE date = '\(dateKey)'"
            execute(db, sql: update)
        } else {
            let insert = "INSERT INTO attack_statistics (date, daily_count, hourly_data, created_at, updated_at) VALUES ('\(dateKey)', 1, '\(newJsonString)', \(Int64(Date().timeIntervalSince1970)), \(Int64(Date().timeIntervalSince1970)))"
            execute(db, sql: insert)
        }
    }
    
    // MARK: - Notification History
    
    func saveNotification(title: String, body: String, channelId: String?) {
        guard let db = openDatabase() else { return }
        defer { sqlite3_close(db) }
        
        // Match Android/Flutter schema
        // timestamp (INTEGER), package_name (TEXT), channel_id (TEXT), title (TEXT), body (TEXT), subtitle (TEXT)
        
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        let packageName = Bundle.main.bundleIdentifier ?? "com.raidalarm"
        let subtitle = ""
        let safeChannelId = channelId ?? ""
        
        let query = "INSERT INTO notifications (timestamp, package_name, channel_id, title, body, subtitle) VALUES (?, ?, ?, ?, ?, ?)"
        
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int64(stmt, 1, timestamp)
            
            let packageNameNS = packageName as NSString
            sqlite3_bind_text(stmt, 2, packageNameNS.utf8String, -1, nil)
            
            let channelIdNS = safeChannelId as NSString
            sqlite3_bind_text(stmt, 3, channelIdNS.utf8String, -1, nil)
            
            let titleNS = title as NSString
            sqlite3_bind_text(stmt, 4, titleNS.utf8String, -1, nil)
            
            let bodyNS = body as NSString
            sqlite3_bind_text(stmt, 5, bodyNS.utf8String, -1, nil)
            
            let subtitleNS = subtitle as NSString
            sqlite3_bind_text(stmt, 6, subtitleNS.utf8String, -1, nil)
            
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("✅ Notification saved to SQLite: \(title)")
            } else {
                print("❌ Failed to insert notification")
            }
        } else {
            let error = String(cString: sqlite3_errmsg(db))
            print("❌ SQLite Prepare Error (saveNotification): \(error)")
        }
        sqlite3_finalize(stmt)
    }

    private func execute(_ db: OpaquePointer?, sql: String) {
        var error: UnsafeMutablePointer<CChar>?
        if sqlite3_exec(db, sql, nil, nil, &error) != SQLITE_OK {
            let msg = String(cString: error!)
            print("❌ SQLite Error: \(msg) | SQL: \(sql)")
        }
    }

    // Standard getter used by AppDelegate
    func getSQLiteAlarmSettings() -> [String: Any] {
        var settings: [String: Any] = [:]
        
        guard let db = openDatabase() else { return [:] }
        defer { sqlite3_close(db) }
        
        let query = "SELECT value FROM app_settings WHERE key = 'alarmSettings'"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                if let cString = sqlite3_column_text(statement, 0) {
                    let jsonString = String(cString: cString)
                    if let data = jsonString.data(using: .utf8) {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                settings = json
                            }
                        } catch {
                            print("Error parsing SQLite JSON: \(error)")
                        }
                    }
                }
            }
        }
        sqlite3_finalize(statement)
        
        // Ensure default values if keys are missing
        if settings["vibration"] == nil { settings["vibration"] = true }
        if settings["duration"] == nil { settings["duration"] = 30 } // Default 30s
        if settings["infiniteLoop"] == nil { settings["infiniteLoop"] = true } // Default loop
        
        if settings.isEmpty {
             print("⚠️ No settings found in SQLite, using defaults.")
        } else {
             print("✅ Loaded Settings from SQLite: \(settings)")
        }
        
        return settings
    }
}
