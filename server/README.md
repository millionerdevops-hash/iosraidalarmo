# Raidalarm Server (Rust+ Migration)

This server handles 24/7 background notifications for the Raidalarm Flutter app. It connects to Google's MCS (Push Receiver) using the user's Steam credentials and routes notifications to mobile devices via OneSignal.

## Features
- **Background MCS Listener:** Keeps a persistent connection to Google for raid alarms.
- **OneSignal Integration:** Forwards Rust+ events to both Android and iOS devices.
- **SQLite Database:** Stores user tokens and paired servers.
- **Centralized Synchronization:** Receives updates from the Flutter app.

## Setup & Deployment (Render.com)
1. **New Web Service:** Connect your repository and select the `server/` directory.
2. **Runtime:** Node.js
3. **Build Command:** `npm install`
4. **Start Command:** `node index.js`
5. **Environment Variables:**
   - `ONESIGNAL_APP_ID`: Your OneSignal App ID.
   - `ONESIGNAL_API_KEY`: Your OneSignal REST API Key.
   - `PORT`: 3000 (Default)

## API Endpoints
- `POST /api/register`: Handles full Rust+ registration (GCM check-in, Expo token, Facepunch registration).
  - Body: `{ steam_id, steam_token, onesignal_id }`
- `POST /api/sync-servers`: Sync paired servers from the app.
  - Body: `{ steam_id, servers: [...] }`
- `GET /api/status`: Health check.
