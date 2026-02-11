const OneSignal = require('onesignal-node');
require('dotenv').config();

const client = new OneSignal.Client(
    process.env.ONESIGNAL_APP_ID,
    process.env.ONESIGNAL_API_KEY
);

async function sendPushNotification(onesignalId, message) {
    if (!onesignalId) return;

    const notification = {
        contents: {
            'en': message.body || 'New Raid Alarm notification',
        },
        headings: {
            'en': message.title || 'Raid Alarm',
        },
        include_subscription_ids: [onesignalId],
        data: message.data || {},
        android_group: 'rust_alarm_group',
        ios_badgeType: 'Increase',
        ios_badgeCount: 1,
    };

    try {
        const response = await client.createNotification(notification);
        console.log('[Notification] ✅ Sent successfully:', response.body.id);
    } catch (e) {
        console.error('[Notification] ❌ Error sending:', e);
    }
}

module.exports = { sendPushNotification };
