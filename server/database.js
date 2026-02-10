const sqlite3 = require('sqlite3');
const { open } = require('sqlite');
const path = require('path');

async function setupDb() {
    const db = await open({
        filename: path.join(__dirname, 'database.sqlite'),
        driver: sqlite3.Database
    });

    await db.exec(`
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            steam_id TEXT UNIQUE,
            steam_token TEXT,
            android_id TEXT,
            security_token TEXT,
            fcm_token TEXT,
            onesignal_id TEXT,
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
            FOREIGN KEY(user_id) REFERENCES users(id)
        );
    `);

    return db;
}

module.exports = { setupDb };
