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

async function performFullRegistration(steamToken, deviceId = 'rustplus.js') {
    try {
        console.log(`[Register] 📦 Starting official app emulated registration for device: ${deviceId}...`);

        // 1. GCM/FCM Register using @liamcottle/push-receiver (Handles checkin internally)
        let fcmCredentials;
        let retries = 3;
        while (retries > 0) {
            try {
                fcmCredentials = await AndroidFCM.register(
                    RUSTPLUS_CONFIG.apiKey,
                    RUSTPLUS_CONFIG.projectId,
                    RUSTPLUS_CONFIG.gcmSenderId,
                    RUSTPLUS_CONFIG.gmsAppId,
                    RUSTPLUS_CONFIG.androidPackageName,
                    RUSTPLUS_CONFIG.androidPackageCert
                );
                break;
            } catch (err) {
                retries--;
                if (err.message.includes('PHONE_REGISTRATION_ERROR') && retries > 0) {
                    console.log(`[Register] ⚠️ GCM Registration temporary error, retrying... (${retries} attempts left)`);
                    await new Promise(r => setTimeout(r, 2000));
                } else {
                    throw err;
                }
            }
        }

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
            DeviceId: deviceId,
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

        await client.connect();
        activeClients.set(user.id, client);

        // Helper to extract appData
        const extractAppData = (data) => {
            if (data.appData && Array.isArray(data.appData)) {
                return data.appData;
            }
            return Object.entries(data).map(([key, value]) => ({ key, value }));
        };

        client.on('ON_NOTIFICATION_RECEIVED', (notification) => {
            const data = notification.data || {};
            handleNotification(user, { appData: extractAppData(data) }, db);
        });

        client.on('ON_DATA_RECEIVED', (data) => {
            handleNotification(user, { appData: extractAppData(data) }, db);
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
            console.log('[MCS] 🔍 Parsing Body:', payload.body);
            const bodyJson = JSON.parse(payload.body);
            Object.assign(payload, bodyJson);
            console.log('[MCS] ✅ Body Parsed Successfully. IPs:', payload.ip);
        } catch (e) {
            console.error('[MCS] ❌ JSON Parse Error:', e.message);
        }
    } else {
        console.warn('[MCS] ⚠️ Payload has no body field:', Object.keys(payload));
    }

    // DEBUG: Log the full payload to see what we are receiving
    // DEBUG: Log the full payload to see what we are receiving
    console.log('[MCS] 📩 Received Payload:', JSON.stringify(payload, null, 2));

    let title = "Raid Alarm";
    let body = "New Notification";

    // --------------------------------------------------
    // 1. DETECT RAID ALARM (Independent of Pairing Info)
    // --------------------------------------------------
    // channelId: "alarm" is the reliable indicator from Rust+ servers
    if (payload.channelId === "alarm" || payload.type === "alarm" || (payload.title && payload.title.toLowerCase().includes('raid'))) {
        console.log('[MCS] 🚨 RAID ALARM DETECTED!');
        console.log('[MCS] 📝 Title:', payload.title || 'Alarm');
        console.log('[MCS] 📝 Message:', payload.message || 'Your base is under attack!');

        const alarmTitle = payload.title || "Raid Alarm";
        const alarmMessage = payload.message || payload.body || "Your base is under attack!";

        // 1. Send OneSignal Push (Android)
        if (user.onesignal_id) {
            console.log('[MCS] 📤 Sending OneSignal notification...');
            sendPushNotification(user.onesignal_id, {
                title: alarmTitle,
                body: alarmMessage,
                data: { ...payload, type: 'raid', channelId: 'alarm' }
            });
        }

        // 2. Send VoIP Push (iOS - Immediate Wake-up + Fake Call)
        if (user.ios_voip_token) {
            console.log('[MCS] 📤 Sending VoIP notification to iOS...');
            const { sendVoipNotification } = require('./notifications');
            await sendVoipNotification(user.ios_voip_token, {
                title: alarmTitle,
                body: alarmMessage,
                type: 'raid',
                channelId: 'alarm',
                serverId: payload.id || 'unknown',
                serverName: payload.name || 'Unknown Server',
                timestamp: Date.now()
            });
            console.log('[MCS] ✅ VoIP notification sent successfully');
        }

        // If it was just an alarm without pairing data, we are done.
        if (!payload.ip || !payload.playerToken) return;
    }

    // --------------------------------------------------
    // 2. DETECT SERVER PAIRING (IP & Token Required)
    // --------------------------------------------------
    if (payload.ip && payload.playerToken) {
        console.log('[MCS] 🔗 Server Pairing Data detected');

        // AUTOMATICALLY SAVE SERVER TO DATABASE
        if (db) {
            try {
                const port = parseInt(payload.port || '28015');
                const ip = payload.ip;
                const playerId = payload.playerId || user.steam_id;
                const playerToken = payload.playerToken;
                const name = payload.name || `${ip}:${port}`;

                const existing = await db.get(
                    'SELECT id FROM servers WHERE user_id = ? AND ip = ? AND port = ?',
                    [user.id, ip, port]
                );

                if (!existing) {
                    await db.run(`
                        INSERT INTO servers (user_id, ip, port, player_id, player_token, name)
                        VALUES (?, ?, ?, ?, ?, ?)
                    `, [user.id, ip, port, playerId, playerToken, name]);
                    console.log(`[MCS] ✅ Auto-paired new server: ${name}`);
                } else {
                    await db.run(`
                        UPDATE servers SET player_token = ?, name = ? WHERE id = ?
                    `, [playerToken, name, existing.id]);
                    console.log(`[MCS] 🔄 Updated server credentials: ${name}`);
                }

                // Notify client about new pairing
                sendPushNotification(user.onesignal_id, {
                    title: "Raid Alarm",
                    body: "Server Connection Established",
                    data: {
                        type: 'server_pairing',
                        ip: ip,
                        port: port.toString(),
                        playerId: playerId,
                        playerToken: playerToken,
                        name: name
                    }
                });

                if (user.ios_voip_token) {
                    const { sendVoipNotification } = require('./notifications');
                    await sendVoipNotification(user.ios_voip_token, {
                        type: 'server_pairing',
                        ip: ip,
                        port: port.toString(),
                        playerId: playerId,
                        playerToken: playerToken,
                        name: name
                    });
                }
            } catch (err) {
                console.error('[MCS] ❌ Auto-pair failed:', err);
            }
        }
    }
} // End handleNotification

module.exports = { startMcsForUser, performFullRegistration };
