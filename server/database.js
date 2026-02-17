const Database = require('better-sqlite3');
const path = require('path');

async function setupDb() {
    const dbPath = process.env.DB_PATH || path.join(__dirname, 'database.sqlite');
    console.log(`[Database] 📂 Using database at: ${dbPath}`);

    const db = new Database(dbPath);

    // Create tables
    db.exec(`
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            steam_id TEXT UNIQUE,
            steam_token TEXT,
            android_id TEXT,
            security_token TEXT,
            fcm_token TEXT,
            onesignal_id TEXT,
            ios_voip_token TEXT,
            platform TEXT,
            last_login DATETIME DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE IF NOT EXISTS servers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            ip TEXT,
            port TEXT,
            player_id TEXT,
            player_token TEXT,
            name TEXT,
            FOREIGN KEY(user_id) REFERENCES users(id),
            UNIQUE(user_id, ip, port)
        );

        CREATE TABLE IF NOT EXISTS devices (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            server_ip TEXT NOT NULL,
            server_port INTEGER NOT NULL,
            entity_id INTEGER NOT NULL,
            entity_type INTEGER NOT NULL,
            name TEXT NOT NULL,
            is_active INTEGER DEFAULT 0,
            created_at INTEGER DEFAULT (strftime('%s', 'now')),
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            UNIQUE(user_id, server_ip, server_port, entity_id)
        );
    `);

    // Wrap db to match previous API usage (async wrapper not needed for better-sqlite3 but keeps compatibility)
    return {
        run: async (sql, params = []) => db.prepare(sql).run(...params),
        get: async (sql, params = []) => db.prepare(sql).get(...params),
        all: async (sql, params = []) => db.prepare(sql).all(...params),
        exec: async (sql) => db.exec(sql)
    };
}

module.exports = { setupDb };
