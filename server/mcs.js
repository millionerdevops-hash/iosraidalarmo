const PushReceiverClient = require('@liamcottle/push-receiver/src/client');
const AndroidFCM = require('@liamcottle/push-receiver/src/android/fcm');
const { sendPushNotification } = require('./notifications');
const axios = require('axios');
const { v4: uuidv4 } = require('uuid');

const activeClients = new Map();

// Facepunch / Expo Constants - THESE ARE THE STATIC VALUES FROM RUST+ APP
const RUST_APP_ID = 'com.facepunch.rust.companion';
const EXPO_PROJECT_ID = '49451aca-a822-41e6-ad59-955718d0ff9c';

// Official Rust+ Static FCM Config (From rustplus.js source)
const RUSTPLUS_CONFIG = {
    apiKey: "AIzaSyB5y2y-Tzqb4-I4Qnlsh_9naYv_TD8pCvY",
    projectId: "rust-companion-app",
    gcmSenderId: "976529667804",
    gmsAppId: "1:976529667804:android:d6f1ddeb4403b338fea619",
    androidPackageName: "com.facepunch.rust.companion",
    androidPackageCert: "E28D05345FB78A7A1A63D70F4A302DBF426CA5AD"
};

async function performFullRegistration(steamToken) {
    try {
        console.log('[Register] 📦 Starting official app emulated registration...');

        // 1. GCM/FCM Register using @liamcottle/push-receiver (Handles checkin internally)
        const fcmCredentials = await AndroidFCM.register(
            RUSTPLUS_CONFIG.apiKey,
            RUSTPLUS_CONFIG.projectId,
            RUSTPLUS_CONFIG.gcmSenderId,
            RUSTPLUS_CONFIG.gmsAppId,
            RUSTPLUS_CONFIG.androidPackageName,
            RUSTPLUS_CONFIG.androidPackageCert
        );

        const fcmToken = fcmCredentials.fcm.token;
        const androidId = fcmCredentials.gcm.androidId;
        const securityToken = fcmCredentials.gcm.securityToken;

        console.log(`[Register] ✅ GCM Registration complete (Android ID: ${androidId})`);
        console.log('[Register] ✅ Emulated FCM Token acquired');

        // 2. Get Expo Push Token (Facepunch uses Expo for push delivery)
        const expoResponse = await axios.post('https://exp.host/--/api/v2/push/getExpoPushToken', {
            type: 'fcm',
            deviceId: uuidv4(), // Unique virtual device ID for Expo
            development: false,
            appId: RUST_APP_ID, // com.facepunch.rust.companion
            deviceToken: fcmToken,
            projectId: EXPO_PROJECT_ID,
        });

        if (!expoResponse.data || !expoResponse.data.data) {
            throw new Error('Failed to get Expo Push Token');
        }

        const expoToken = expoResponse.data.data.expoPushToken;
        console.log('[Register] ✅ Expo Token acquired');

        // 3. Register with Facepunch (The "Pairing" Link)
        // We identify as 'rustplus.js' as per documentation examples
        const fpResponse = await axios.post('https://companion-rust.facepunch.com:443/api/push/register', {
            AuthToken: steamToken,
            DeviceId: 'rustplus.js',
            PushKind: 3, // FCM Push Kind
            PushToken: expoToken,
        });

        if (fpResponse.status !== 200) {
            throw new Error(`Facepunch registration failed with status: ${fpResponse.status}`);
        }
        console.log('[Register] ✅ Facepunch Cloud Registration complete');

        return {
            android_id: androidId,
            security_token: securityToken,
            fcm_token: fcmToken,
            expo_token: expoToken
        };
    } catch (e) {
        console.error('[Register] ❌ Registration failed:', e.message);
        throw e;
    }
}

async function startMcsForUser(user, db) {
    if (activeClients.has(user.id)) {
        console.log(`[MCS] ℹ️ User ${user.id} already has an active client.`);
        return;
    }

    console.log(`[MCS] 🔌 Connecting for user: ${user.steam_id}`);

    try {
        const client = new PushReceiverClient(
            user.android_id,
            user.security_token,
            [] // persistentIds
        );

        client.on('ON_NOTIFICATION_RECEIVED', (notification) => {
            const data = notification.data || {};
            // Convert data to our format if needed
            handleNotification(user, { appData: Object.entries(data).map(([key, value]) => ({ key, value })) }, db);
        });

        // Listen for data messages (Rust+ typically sends data messages)
        client.on('ON_DATA_RECEIVED', (data) => {
            // rustplus.js CLI structure: data is the message object
            const appData = Object.keys(data).map(key => ({ key, value: data[key] }));
            handleNotification(user, { appData }, db);
        });

        client.on('error', (err) => {
            console.error(`[MCS] ❌ Error for user ${user.id}:`, err);
            activeClients.delete(user.id);
            setTimeout(() => startMcsForUser(user, db), 5000);
        });

        client.on('close', () => {
            console.log(`[MCS] ⚠️ Connection closed for user ${user.id}`);
            activeClients.delete(user.id);
            setTimeout(() => startMcsForUser(user, db), 5000);
        });

        await client.connect();
        activeClients.set(user.id, client);

    } catch (e) {
        console.error(`[MCS] ❌ Connection failed for user ${user.id}:`, e);
    }
}

async function handleNotification(user, data, db) {
    const payload = {};
    if (data.appData) {
        data.appData.forEach(entry => {
            payload[entry.key] = entry.value;
        });
    }

    if (payload.body) {
        try {
            const bodyJson = JSON.parse(payload.body);
            Object.assign(payload, bodyJson);
        } catch (e) { }
    }

    let title = "Rust+ Notification";
    let body = "New event detected";

    if (payload.ip && payload.playerToken) {
        title = "Server Pairing";
        body = `A new server (${payload.name || payload.ip}) is ready to pair.`;

        // AUTOMATICALLY SAVE SERVER TO DATABASE
        if (db) {
            try {
                // Ensure port is an integer
                const port = parseInt(payload.port || '28015');
                const ip = payload.ip;
                const playerId = payload.playerId || user.steam_id;
                const playerToken = payload.playerToken;
                const name = payload.name || `${ip}:${port}`;

                // Check if already exists to avoid duplicates
                const existing = await db.get(
                    'SELECT id FROM servers WHERE user_id = ? AND ip = ? AND port = ?',
                    [user.id, ip, port]
                );

                if (!existing) {
                    await db.run(`
                        INSERT INTO servers (user_id, ip, port, player_id, player_token, name)
                        VALUES (?, ?, ?, ?, ?, ?)
                    `, [user.id, ip, port, playerId, playerToken, name]);
                    console.log(`[MCS] ✅ Auto-paired new server: ${name} for user ${user.steam_id}`);
                } else {
                    // Update token if changed
                    await db.run(`
                        UPDATE servers SET player_token = ?, name = ? WHERE id = ?
                    `, [playerToken, name, existing.id]);
                    console.log(`[MCS] 🔄 Updated server credentials: ${name}`);
                }
            } catch (err) {
                console.error('[MCS] ❌ Failed to save auto-paired server:', err);
            }
        }

    } else if (payload.entityId) {
        if (payload.entityType == "1") {
            title = "Smart Switch";
            body = `Switch "${payload.name || 'Device'}" state changed.`;
        } else {
            title = "Smart Alarm!";
            body = `Alarm "${payload.name || 'Device'}" triggered!`;
        }
    }

    sendPushNotification(user.onesignal_id, {
        title,
        body,
        data: payload
    });
}

module.exports = { startMcsForUser, performFullRegistration };
