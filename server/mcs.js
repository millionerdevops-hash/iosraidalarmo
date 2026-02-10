const { listen, register, checkin } = require('push-receiver');
const { sendPushNotification } = require('./notifications');

const activeClients = new Map();

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
            // Reconnect after delay
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
    console.log(`[MCS] 🔔 New notification for user ${user.id}`);

    // Convert data to a more usable format
    const payload = {};
    if (data.appData) {
        data.appData.forEach(entry => {
            payload[entry.key] = entry.value;
        });
    }

    // Handle body JSON if present (Rust+ standard)
    if (payload.body) {
        try {
            const bodyJson = JSON.parse(payload.body);
            Object.assign(payload, bodyJson);
        } catch (e) { }
    }

    // Determine notification title/body based on Rust+ content
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

module.exports = { startMcsForUser };
