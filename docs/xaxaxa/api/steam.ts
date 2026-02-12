
export const config = {
  runtime: 'edge',
};

// SteamID Conversion Constants
const STEAM_OFFSET = BigInt('76561197960265728');

function getSteamIds(steamId64: string) {
  try {
    const bigId = BigInt(steamId64);
    const accountId = bigId - STEAM_OFFSET; // SteamID3 (AccountID)
    
    // SteamID2 Calculation (STEAM_X:Y:Z)
    // Z = AccountID / 2
    // Y = AccountID % 2
    const y = accountId % 2n;
    const z = (accountId - y) / 2n;
    const steamId2 = `STEAM_0:${y}:${z}`;
    
    // SteamID3 Format [U:1:AccountID]
    const steamId3 = `[U:1:${accountId}]`;

    return {
      steamId64,
      steamId32: accountId.toString(),
      steamId3,
      steamId2
    };
  } catch (e) {
    return { steamId64, steamId32: '?', steamId3: '?', steamId2: '?' };
  }
}

export default async function handler(request: Request) {
  const { searchParams } = new URL(request.url);
  const steamId = searchParams.get('id');
  const apiKey = process.env.STEAM_API_KEY; 

  if (!steamId) {
    return new Response(JSON.stringify({ error: 'Steam ID required' }), { status: 400 });
  }

  // --- FALLBACK FOR DEMO (If no API Key) ---
  if (!apiKey && steamId === '76561199346057194') {
      return new Response(JSON.stringify({
          profile: {
            steamid: '76561199346057194',
            personaname: 'RUST_KING',
            avatarfull: 'https://avatars.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg',
            communityvisibilitystate: 1, // Private
            gameextrainfo: 'Rust',
            timecreated: 1655635200, // Jun 19 2022 approx
            loccountrycode: 'JP',
            profileurl: 'https://steamcommunity.com/profiles/76561199346057194/'
          },
          bans: {
            VACBanned: false,
            NumberOfVACBans: 0,
            DaysSinceLastBan: 0,
            CommunityBanned: false,
            EconomyBan: 'none'
          },
          hours_played: 2450,
          recent_hours: 86.5, // Mock recent hours
          ids: getSteamIds('76561199346057194')
      }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  }

  if (!apiKey) {
      return new Response(JSON.stringify({ error: 'Server Config Error: Missing STEAM_API_KEY' }), { status: 500 });
  }

  try {
    // 1. Fetch Summary
    const summaryUrl = `http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=${apiKey}&steamids=${steamId}`;
    
    // 2. Fetch Bans
    const bansUrl = `http://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=${apiKey}&steamids=${steamId}`;

    // Parallel Fetch
    const [summaryRes, bansRes] = await Promise.all([
        fetch(summaryUrl),
        fetch(bansUrl)
    ]);

    const summaryJson = await summaryRes.json();
    const bansJson = await bansRes.json();
    
    const player = summaryJson.response?.players?.[0];
    const banData = bansJson.players?.[0];

    if (!player) {
        return new Response(JSON.stringify({ error: 'Player not found' }), { status: 404 });
    }

    let hoursPlayed = 0;
    let recentHours = 0;

    // 3. If Public, Fetch Owned Games for Rust Hours
    if (player.communityvisibilitystate === 3) {
        try {
            const gamesUrl = `http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=${apiKey}&steamid=${steamId}&format=json&include_appinfo=1&appids_filter[0]=252490`;
            const gamesRes = await fetch(gamesUrl);
            const gamesJson = await gamesRes.json();
            
            // Rust App ID is 252490
            const rustGame = gamesJson.response?.games?.find((g: any) => g.appid === 252490);
            
            if (rustGame) {
                hoursPlayed = Math.round(rustGame.playtime_forever / 60);
                // playtime_2weeks is in minutes, convert to hours (1 decimal)
                if (rustGame.playtime_2weeks) {
                    recentHours = Math.round((rustGame.playtime_2weeks / 60) * 10) / 10;
                }
            }
        } catch (e) { /* Ignore */ }
    }

    // Combine Data
    const result = {
        profile: player,
        bans: banData || {},
        hours_played: hoursPlayed,
        recent_hours: recentHours,
        ids: getSteamIds(player.steamid)
    };

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'public, s-maxage=60'
      },
    });

  } catch (error: any) {
    return new Response(JSON.stringify({ error: 'Steam API Connection Failed', details: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
}
