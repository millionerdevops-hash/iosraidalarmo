const { listen, register, checkin } = require('push-receiver');
const { sendPushNotification } = require('./notifications');
const axios = require('axios');
const { v4: uuidv4 } = require('uuid');

const activeClients = new Map();

// Facepunch / Expo Constants
const RUST_APP_ID = 'com.facepunch.rust.companion';
const EXPO_PROJECT_ID = '49451aca-a822-41e6-ad59-955718d0ff9c';

// Official Rust+ FCM Config
const FCM_CONFIG = {
    apiKey: "AIzaSyB5y2y-Tzqb4-I4Qnlsh_9naYv_TD8pCvY",
    projectId: "rust-companion-app",
    gcmSenderId: "976529667804",
};

async function performFullRegistration(steamToken) {
    try {
        console.log('[Register] 📦 Starting full registration on server...');

        // 1. Check-in (Android ID / Security Token)
        const checkinResponse = await checkin();
        const androidId = checkinResponse.androidId;
        const securityToken = checkinResponse.securityToken;
        console.log('[Register] ✅ Check-in complete');

        // 2. GCM Register (FCM Token) - Using Official Parameters
        const fcmResponse = await register({
            androidId,
            securityToken,
            appId: FCM_CONFIG.gcmSenderId, // Facepunch Sender ID
            apiKey: FCM_CONFIG.apiKey
        });
        const fcmToken = fcmResponse.token;
        console.log('[Register] ✅ GCM Register complete');

        // 3. Get Expo Push Token
        const expoResponse = await axios.post('https://exp.host/--/api/v2/push/getExpoPushToken', {
            type: 'fcm',
            deviceId: uuidv4(),
            development: false,
            appId: RUST_APP_ID,
            deviceToken: fcmToken,
            projectId: EXPO_PROJECT_ID,
        });

        const expoToken = expoResponse.data.data.expoPushToken;
        console.log('[Register] ✅ Expo Token acquired');

        // 4. Register with Facepunch
        const fpResponse = await axios.post('https://companion-rust.facepunch.com:443/api/push/register', {
            AuthToken: steamToken,
            DeviceId: 'rustplus.js',
            PushKind: 3,
            PushToken: expoToken,
        });

        if (fpResponse.status !== 200) {
            throw new Error(`Facepunch registration failed: ${fpResponse.status}`);
        }
        console.log('[Register] ✅ Facepunch Registration complete');

        return {
            android_id: androidId,
            security_token: securityToken,
            fcm_token: fcmToken,
            expo_token: expoToken
        };
    } catch (e) {
        console.error('[Register] ❌ Full registration failed:', e.message);
        throw e;
    }
}

async function startMcsForUser(user) {
    if (activeClients.has(user.id)) {
        console.log(`[MCS] ℹ️ User ${user.id} already has an active client.`);
        return;
    }

    const credentials = {
        fcm: {
            token: user.fcm_token,
        },
        gcm: {
            androidId: user.android_id,
            securityToken: user.security_token,
        }
    };

    console.log(`[MCS] 🔌 Connecting for user: ${user.steam_id}`);

    try {
        const listener = await listen(credentials, ({ tag, data }) => {
            if (tag === 8) { // DataMessageStanza
                handleNotification(user, data);
            }
        });

        activeClients.set(user.id, listener);

        listener.on('error', (err) => {
            console.error(`[MCS] ❌ Error for user ${user.id}:`, err);
            activeClients.delete(user.id);
            setTimeout(() => startMcsForUser(user), 5000);
        });

        listener.on('close', () => {
            console.log(`[MCS] ⚠️ Connection closed for user ${user.id}`);
            activeClients.delete(user.id);
            setTimeout(() => startMcsForUser(user), 5000);
        });

    } catch (e) {
        console.error(`[MCS] ❌ Connection failed for user ${user.id}:`, e);
    }
}

function handleNotification(user, data) {
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
