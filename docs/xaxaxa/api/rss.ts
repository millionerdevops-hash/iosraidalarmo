
export const config = {
  runtime: 'edge',
};

export default async function handler(request: Request) {
  try {
    // Official Rust Blog RSS Feed
    const RSS_URL = 'https://rust.facepunch.com/rss/blog';
    
    // Mimic a real browser User-Agent to prevent 403 Forbidden
    const response = await fetch(RSS_URL, {
        headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'application/rss+xml, application/xml, text/xml, */*',
        }
    });
    
    if (!response.ok) {
        throw new Error(`Upstream error: ${response.status} ${response.statusText}`);
    }

    const text = await response.text();

    return new Response(text, {
      status: 200,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'Cache-Control': 'public, s-maxage=3600, stale-while-revalidate=1800',
        'Access-Control-Allow-Origin': '*'
      },
    });
  } catch (error: any) {
    return new Response(JSON.stringify({ error: 'Failed to fetch RSS', details: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
}
