
export const config = {
  runtime: 'edge',
};

export default async function handler(request: Request) {
  const { searchParams } = new URL(request.url);
  const path = searchParams.get('path');
  const params = searchParams.get('params') || '';

  if (!path) {
    return new Response(JSON.stringify({ error: 'Path required' }), {
      status: 400,
      headers: { 'content-type': 'application/json' },
    });
  }

  // Determine cache duration based on endpoint type
  let cacheSeconds = 60; // Default 1 minute
  
  if (path.includes('/players')) {
    cacheSeconds = 30; // Players move fast, 30s cache
  } else if (path.includes('servers') && params.includes('search')) {
    cacheSeconds = 120; // Search results can stay longer (2 mins) to save quota
  } else if (path.includes('servers')) {
    cacheSeconds = 60; // Server details (pop count) 1 min is standard
  }

  try {
    // Construct the real BattleMetrics URL
    // Decode params to ensure special chars like brackets [] work correctly
    const targetUrl = `https://api.battlemetrics.com${path}${decodeURIComponent(params)}`;
    
    console.log(`[Proxy] Fetching: ${targetUrl}`);

    const bmResponse = await fetch(targetUrl, {
      headers: {
        'Authorization': process.env.BATTLEMETRICS_TOKEN ? `Bearer ${process.env.BATTLEMETRICS_TOKEN}` : '',
        'Accept': 'application/json'
      }
    });

    const data = await bmResponse.json();

    return new Response(JSON.stringify(data), {
      status: bmResponse.status,
      headers: {
        'content-type': 'application/json',
        // CRITICAL: This tells Vercel Edge Network to cache this response
        // s-maxage=60: Cache on Vercel CDN for 60 seconds (Shared among all users)
        // stale-while-revalidate=30: Serve old data for 30s more while fetching new data in background
        'Cache-Control': `public, s-maxage=${cacheSeconds}, stale-while-revalidate=${Math.floor(cacheSeconds / 2)}`,
        'Access-Control-Allow-Origin': '*'
      },
    });

  } catch (error: any) {
    return new Response(JSON.stringify({ error: 'Failed to fetch data', details: error.message }), {
      status: 500,
      headers: { 'content-type': 'application/json' },
    });
  }
}