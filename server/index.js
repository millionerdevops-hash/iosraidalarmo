const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { setupDb } = require('./database');
const { startMcsForUser, performFullRegistration } = require('./mcs');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

let db;

// 1. Health Check
app.get('/api/status', (req, res) => {
    res.json({ status: 'online', clients: 'active' });
});

// 2. Register User (Steam Login -> Full Server-Side Rust+ Setup)
app.post('/api/register', async (req, res) => {
    const { steam_id, steam_token, onesignal_id, platform } = req.body;

    // Check minimum requirements
    if (!steam_id || !steam_token) {
        return res.status(400).json({ error: 'Missing steam_id or steam_token' });
    }

    try {
        console.log(`[API] 👤 Registering user: ${steam_id} (${platform || 'unknown'})`);

        if (!onesignal_id) {
            console.warn(`[API] ⚠️ No onesignal_id provided for ${steam_id}. User won't receive notifications until synced.`);
        }

        // Perform the heavy lifting on the server
        const mcsCredentials = await performFullRegistration(steam_token);

        await db.run(`
            INSERT INTO users (steam_id, steam_token, android_id, security_token, fcm_token, onesignal_id, platform)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(steam_id) DO UPDATE SET
                steam_token = excluded.steam_token,
                android_id = excluded.android_id,
                security_token = excluded.security_token,
                fcm_token = excluded.fcm_token,
                onesignal_id = COALESCE(excluded.onesignal_id, users.onesignal_id),
                platform = excluded.platform,
                last_login = CURRENT_TIMESTAMP
        `, [
            steam_id,
            steam_token,
            mcsCredentials.android_id.toString(),
            mcsCredentials.security_token.toString(),
            mcsCredentials.fcm_token,
            onesignal_id || null,
            platform
        ]);

        const user = await db.get('SELECT * FROM users WHERE steam_id = ?', [steam_id]);

        // Start MCS listener for this user
        startMcsForUser(user, db);

        res.json({
            success: true,
            user_id: user.id,
            message: 'Registration completed successfully'
        });
    } catch (e) {
        console.error(`[API] ❌ Registration failed for ${steam_id}:`, e.message);
        res.status(500).json({
            error: e.message || 'Registration failed',
            details: 'Check server logs for MCS/FCM/Expo registration details'
        });
    }
});

// 3. Sync Servers
app.post('/api/sync-servers', async (req, res) => {
    const { steam_id, servers } = req.body;

    try {
        const user = await db.get('SELECT id FROM users WHERE steam_id = ?', [steam_id]);
        if (!user) return res.status(404).json({ error: 'User not found' });

        await db.run('DELETE FROM servers WHERE user_id = ?', [user.id]);

        for (const server of servers) {
            await db.run(`
                INSERT INTO servers (user_id, ip, port, player_id, player_token, name)
                VALUES (?, ?, ?, ?, ?, ?)
            `, [user.id, server.ip, server.port, server.player_id, server.player_token, server.name]);
        }

        res.json({ success: true });
    } catch (e) {
        console.error('[API] ❌ Sync error:', e);
        res.status(500).json({ error: 'Database error' });
    }
});

// Initialize and Start
setupDb().then(database => {
    db = database;
    app.listen(port, async () => {
        console.log(`[Server] 🚀 Running on port ${port}`);

        // Restart MCS for all users on startup
        const users = await db.all('SELECT * FROM users');
        users.forEach(user => startMcsForUser(user, db));
    });
