require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { setupDb } = require('./database');
const { startMcsForUser, performFullRegistration } = require('./mcs');

// DEBUG: Check for API Keys
console.log('[System] 🔑 OneSignal Key Status:', process.env.ONESIGNAL_API_KEY ? 'Present' : 'MISSING ❌');
console.log('[System] 🔑 OneSignal App ID Status:', process.env.ONESIGNAL_APP_ID ? 'Present' : 'MISSING ❌');

console.log('[System] 🔑 OneSignal Key Status:', process.env.ONESIGNAL_API_KEY ? 'Present (' + process.env.ONESIGNAL_API_KEY.substring(0, 4) + '...)' : 'MISSING ❌');
console.log('[System] 🔑 OneSignal App ID Status:', process.env.ONESIGNAL_APP_ID ? 'Present' : 'MISSING ❌');

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
    const { steam_id, steam_token, onesignal_id, ios_voip_token, platform } = req.body;

    // Check minimum requirements
    if (!steam_id || !steam_token) {
        return res.status(400).json({ error: 'Missing steam_id or steam_token' });
    }

    try {
        console.log(`[API] 👤 Registering user: ${steam_id} (${platform || 'unknown'})`);

        if (!onesignal_id && !ios_voip_token) {
            console.warn(`[API] ⚠️ No push token provided for ${steam_id}. User won't receive notifications until synced.`);
        }

        // Perform the heavy lifting on the server
        const mcsCredentials = await performFullRegistration(steam_token);

        await db.run(`
            INSERT INTO users (steam_id, steam_token, android_id, security_token, fcm_token, onesignal_id, ios_voip_token, platform)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(steam_id) DO UPDATE SET
                steam_token = excluded.steam_token,
                android_id = excluded.android_id,
                security_token = excluded.security_token,
                fcm_token = excluded.fcm_token,
                onesignal_id = COALESCE(excluded.onesignal_id, users.onesignal_id),
                ios_voip_token = COALESCE(excluded.ios_voip_token, users.ios_voip_token),
                platform = excluded.platform,
                last_login = CURRENT_TIMESTAMP
        `, [
            steam_id,
            steam_token,
            mcsCredentials.android_id.toString(),
            mcsCredentials.security_token.toString(),
            mcsCredentials.fcm_token,
            onesignal_id || null,
            ios_voip_token || null,
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

// 4. Sync Devices
app.post('/api/sync-devices', async (req, res) => {
    const { steam_id, devices } = req.body;

    try {
        const user = await db.get('SELECT id FROM users WHERE steam_id = ?', [steam_id]);
        if (!user) return res.status(404).json({ error: 'User not found' });

        // Delete existing devices for this user
        await db.run('DELETE FROM devices WHERE user_id = ?', [user.id]);

        // Insert new devices
        for (const device of devices) {
            if (!device.server_ip || !device.server_port) continue; // Skip invalid entries

            await db.run(`
                INSERT INTO devices (user_id, server_ip, server_port, entity_id, entity_type, name, is_active)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            `, [user.id, device.server_ip, device.server_port, device.entity_id, device.entity_type, device.name, device.is_active ? 1 : 0]);
        }

        console.log(`[API] ✅ Synced ${devices.length} devices for user ${steam_id}`);
        res.json({ success: true });
    } catch (e) {
        console.error('[API] ❌ Device sync error:', e);
        res.status(500).json({ error: 'Database error' });
    }
});

// 5. Get Devices (For App Sync)
app.get('/api/devices', async (req, res) => {
    const { steam_id } = req.query;

    if (!steam_id) {
        return res.status(400).json({ error: 'Missing steam_id' });
    }

    try {
        const user = await db.get('SELECT id FROM users WHERE steam_id = ?', [steam_id]);
        if (!user) return res.status(404).json({ error: 'User not found' });

        const devices = await db.all('SELECT * FROM devices WHERE user_id = ?', [user.id]);

        res.json({
            devices: devices.map(d => ({
                server_ip: d.server_ip,
                server_port: d.server_port,
                entity_id: d.entity_id,
                entity_type: d.entity_type,
                name: d.name,
                is_active: d.is_active === 1
            }))
        });
    } catch (e) {
        console.error('[API] ❌ Get devices error:', e);
        res.status(500).json({ error: 'Database error' });
    }
});

// 6. Get Servers (For App Sync)
app.get('/api/servers', async (req, res) => {
    const { steam_id } = req.query;

    if (!steam_id) {
        return res.status(400).json({ error: 'Missing steam_id' });
    }

    try {
        const user = await db.get('SELECT id FROM users WHERE steam_id = ?', [steam_id]);
        if (!user) return res.status(404).json({ error: 'User not found' });

        const servers = await db.all('SELECT * FROM servers WHERE user_id = ?', [user.id]);
        res.json({ servers });
    } catch (e) {
        console.error('[API] ❌ Fetch error:', e);
        res.status(500).json({ error: 'Database error' });
    }
});

// 7. Test VoIP/OneSignal Push Notification
app.post('/api/test-voip', async (req, res) => {
    const { steam_id } = req.body;

    if (!steam_id) {
        return res.status(400).json({ error: 'steam_id required' });
    }

    try {
        const user = await db.get('SELECT * FROM users WHERE steam_id = ?', [steam_id]);
        if (!user) {
            return res.status(404).json({ error: 'User not found. Please login first.' });
        }

        console.log(`[Test] 🧪 Sending test notification to user: ${steam_id}`);
        console.log(`[Test] 📱 iOS VoIP Token: ${user.ios_voip_token ? 'Present' : 'Missing'}`);
        console.log(`[Test] 📱 OneSignal ID: ${user.onesignal_id ? 'Present' : 'Missing'}`);

        const { sendVoipNotification } = require('./notifications');
        const { sendPushNotification } = require('./notifications');

        // Try iOS VoIP first
        if (user.ios_voip_token) {
            try {
                await sendVoipNotification(user.ios_voip_token, {
                    title: 'TEST RAID ALERT',
                    body: 'Your base is under attack! (Test)',
                    type: 'raid',
                    channelId: 'alarm',
                    serverId: 'test-server-123',
                    serverName: 'Test Server',
                    timestamp: Date.now()
                });
                console.log(`[Test] ✅ VoIP notification sent successfully`);
                return res.json({
                    success: true,
                    message: 'Test VoIP notification sent to iOS',
                    platform: 'ios',
                    token_type: 'voip'
                });
            } catch (error) {
                console.error(`[Test] ❌ VoIP send error:`, error);
                return res.status(500).json({
                    error: 'Failed to send VoIP notification',
                    details: error.message
                });
            }
        }

        // Fallback to OneSignal
        if (user.onesignal_id) {
            try {
                await sendPushNotification(user.onesignal_id, {
                    title: 'TEST RAID ALERT',
                    body: 'Your base is under attack! (Test)',
                    type: 'raid',
                    serverId: 'test-server-123',
                    serverName: 'Test Server'
                });
                console.log(`[Test] ✅ OneSignal notification sent successfully`);
                return res.json({
                    success: true,
                    message: 'Test OneSignal notification sent',
                    platform: 'android',
                    token_type: 'onesignal'
                });
            } catch (error) {
                console.error(`[Test] ❌ OneSignal send error:`, error);
                return res.status(500).json({
                    error: 'Failed to send OneSignal notification',
                    details: error.message
                });
            }
        }

        return res.status(400).json({
            error: 'No push token found for user',
            details: 'User must login on iOS (for VoIP) or Android (for OneSignal) first'
        });

    } catch (error) {
        console.error(`[Test] ❌ Database error:`, error);
        return res.status(500).json({
            error: 'Database error',
            details: error.message
        });
    }
});

// Initialize and Start
const startServer = async () => {
    try {
        console.log('[System] 🔄 Starting server initialization...');

        db = await setupDb();
        console.log('[System] ✅ Database initialized');

        // Worker removed - MCS handles all notifications
        // const { startWorker } = require('./worker');
        // startWorker(db);

        app.listen(port, '0.0.0.0', async () => {
            console.log(`[Server] 🚀 Running on port ${port}`);

            // Restart MCS for all users on startup
            try {
                const users = await db.all('SELECT * FROM users');
                console.log(`[System] 🔄 Restarting MCS for ${users.length} users...`);
                users.forEach(user => startMcsForUser(user, db));
            } catch (mcsError) {
                console.error('[System] ⚠️ MCS restart error (non-fatal):', mcsError);
            }
        });
    } catch (error) {
        console.error('[System] ❌ Server Logic Failed to Start:', error);
        process.exit(1); // Exit process to signal container failure
    }
};

startServer();
