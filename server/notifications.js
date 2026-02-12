const apn = require('apn');
const OneSignal = require('onesignal-node');
require('dotenv').config();

// OneSignal Client
const client = new OneSignal.Client(
    process.env.ONESIGNAL_APP_ID,
    process.env.ONESIGNAL_API_KEY
);

// APNs Provider for VoIP (Requires .p8 key)
let apnProvider;
try {
    if (process.env.APN_KEY_ID && process.env.APN_TEAM_ID && process.env.APN_P8_CONTENT) {
        apnProvider = new apn.Provider({
            token: {
                key: process.env.APN_P8_CONTENT.replace(/\\n/g, '\n'), // Handle env var newlines
                keyId: process.env.APN_KEY_ID,
                teamId: process.env.APN_TEAM_ID,
            },
            production: process.env.NODE_ENV === 'production',
        });
        console.log('[APN] ✅ VoIP Provider configured');
    }
} catch (e) {
    console.warn('[APN] ⚠️ Failed to configure APN Provider:', e.message);
}

async function sendPushNotification(onesignalId, message) {
    if (!onesignalId) return;

    const isSilent = message.silent;

    const notification = {
        include_subscription_ids: [onesignalId],
        data: message.data || {},
        android_group: 'rust_alarm_group',
    };

    if (!isSilent) {
        notification.contents = { 'en': message.body || 'New Raid Alarm notification' };
        notification.headings = { 'en': message.title || 'Raid Alarm' };
        notification.ios_badgeType = 'Increase';
        notification.ios_badgeCount = 1;
    } else {
        notification.content_available = true; // For iOS background update
        // No contents, no headings = Silent
    }

    try {
        const response = await client.createNotification(notification);
        console.log('[Notification] ✅ Sent successfully:', response.body.id);
    } catch (e) {
        if (e.statusCode === 403) {
            console.error('[Notification] ⛔ Access Denied (403). CHECK YOUR ONESIGNAL_API_KEY in Render dashboard!');
        } else {
            console.error('[Notification] ❌ Error sending:', e.message);
        }
    }
}

async function sendVoipNotification(voipToken, payload) {
    if (!apnProvider || !voipToken) {
        // Only warn if we actually have a token but no provider, or vice versa
        if (voipToken && !apnProvider) console.warn('[APN] ⚠️ Provider not ready (Missing Env Vars?)');
        return;
    }

    const note = new apn.Notification();
    note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
    note.priority = 10; // High priority (Critical for VoIP)
    note.pushType = "voip"; // Matches .voip certificate
    note.topic = process.env.BUNDLE_ID + ".voip"; // e.g. com.facepunch.rust.companion.voip
    note.payload = payload;

    try {
        const result = await apnProvider.send(note, voipToken);
        if (result.failed.length > 0) {
            console.error('[APN] ❌ VoIP Send Failed:', result.failed);
        } else {
            console.log('[APN] 🚀 VoIP Sent Successfully');
        }
    } catch (e) {
        console.error('[APN] ❌ Error Sending VoIP:', e.message);
    }
}

module.exports = { sendPushNotification, sendVoipNotification };
