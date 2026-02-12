
// Centralized API handling logic

// ... (Existing fetchBattleMetrics function remains here - DO NOT REMOVE) ...
export const fetchBattleMetrics = async (endpoint: string, queryParams: string = '') => {
  const ownApiUrl = `/api/battlemetrics?path=${encodeURIComponent(endpoint)}&params=${encodeURIComponent(queryParams)}`;
  try {
      const response = await fetch(ownApiUrl);
      if (!response.ok) throw new Error(`Server Error: ${response.status}`);
      const json = await response.json();
      if (json.errors) throw new Error(json.errors[0]?.detail || "External API Error");
      return json; 
  } catch (error: any) {
      console.warn(`[API] Internal proxy failed, switching to Simulation Mode:`, error.message);
      return getMockData(endpoint, queryParams);
  }
};

// NEW: Direct Steam Fetcher via our Proxy
export const fetchSteamProfile = async (steamId: string) => {
    try {
        const response = await fetch(`/api/steam?id=${steamId}`);
        const json = await response.json();
        
        if (!response.ok) {
            throw new Error(json.error || 'Steam API Error');
        }
        return json;
    } catch (error) {
        console.error("Steam Fetch Error:", error);
        throw error;
    }
};

// ... (Rest of the file: getMockData, etc.) ...
// --- SIMULATION DATA GENERATOR (Offline/Demo Mode) ---
const getMockData = (endpoint: string, params: string) => {
    // ... (Existing mock data logic) ...
    // Global Stats (Dashboard)
    if (endpoint === '/games/2') {
        return {
            data: {
                attributes: {
                    players: 84230 + Math.floor(Math.random() * 5000),
                    servers: 12405
                }
            }
        };
    }
    // ... (Keep the rest of the existing file exactly as is) ...
    if (endpoint.includes('/servers') && !endpoint.includes('/servers/')) {
        return {
            data: [
                mockServer("Rustoria.co - US Main", 680, 700, 1),
                mockServer("Rusty Moose | US Small", 342, 400, 2),
                mockServer("Rustafied.com - EU Odd", 410, 500, 3),
                mockServer("Reddit.com/r/PlayRust - Large", 215, 300, 4),
                mockServer("Stevious 2x Solo/Duo/Trio", 180, 250, 5),
            ]
        };
    }
    if (endpoint.match(/\/servers\/\d+/)) {
        return {
            data: mockServer("Simulated Server (Offline Mode)", 123, 200, 1, true),
            included: generateMockPlayers(10)
        };
    }
    if (endpoint.match(/\/players\/\d+/)) {
        const idMatch = endpoint.match(/\/players\/(\d+)/);
        const id = idMatch ? idMatch[1] : '0';
        return {
            data: mockPlayer(id, "Simulated Survivor", Math.random() > 0.5),
            included: [{ type: 'server', id: 's1', attributes: { name: 'Rustoria Main' } }]
        };
    }
    if (endpoint.includes('/players')) {
        const searchMatch = params.match(/search]=(\d+)/);
        if (searchMatch) {
            return {
                data: [mockPlayer(searchMatch[1], "Unknown Survivor", true)]
            };
        }
        return {
            data: [
                mockPlayer("123456", "Toxic_Gamer_99", true),
                mockPlayer("654321", "RoofCamper", false),
                mockPlayer("789012", "FriendlyNaked", true),
            ],
            included: [{ type: 'server', id: 's1', attributes: { name: 'Rustoria Main' } }]
        };
    }
    if (endpoint.includes('/bans')) { return { data: [], meta: { total: 0 } }; }
    if (endpoint.includes('/sessions')) {
        const now = Date.now();
        const hour = 3600000;
        return {
            data: [
                { type: "session", id: "sess1", attributes: { start: new Date(now - hour * 0.5).toISOString(), stop: null, firstTime: false }, relationships: { server: { data: { type: "server", id: "s1" } } } },
                { type: "session", id: "sess2", attributes: { start: new Date(now - hour * 25).toISOString(), stop: new Date(now - hour * 21).toISOString(), firstTime: false }, relationships: { server: { data: { type: "server", id: "s1" } } } },
                { type: "session", id: "sess3", attributes: { start: new Date(now - hour * 49).toISOString(), stop: new Date(now - hour * 46).toISOString(), firstTime: false }, relationships: { server: { data: { type: "server", id: "s1" } } } }
            ],
            included: [ { type: "server", id: "s1", attributes: { name: "Rustoria.co - US Main" } } ]
        };
    }
    throw new Error(`Connection Failed (No Mock Data Available for ${endpoint})`);
};

// Helpers for Mock Data
const mockServer = (name: string, players: number, max: number, rank: number, detailed = false) => ({
    id: Math.floor(Math.random() * 1000000).toString(),
    type: "server",
    attributes: { name, players, maxPlayers: max, rank, status: "online", ip: "127.0.0.1", port: 28015, country: "US", details: { map: "Procedural Map", rust_world_size: 4500, rust_last_wipe: new Date().toISOString(), rust_fps: 240, official: true } }
});
const mockPlayer = (id: string, name: string, isOnline: boolean) => ({
    id, type: "player", attributes: { name, private: false, createdAt: "2023-01-01T00:00:00Z" }, relationships: { servers: { data: isOnline ? [{ type: 'server', id: 's1' }] : [] } }
});
const generateMockPlayers = (count: number) => {
    return Array.from({ length: count }).map((_, i) => ({ type: 'player', id: `p${i}`, attributes: { name: `Survivor_${Math.floor(Math.random()*9999)}` }, meta: { time: Math.floor(Math.random() * 3600) } }));
};
