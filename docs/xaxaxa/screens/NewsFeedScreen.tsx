
import React, { useState, useEffect } from 'react';
import { ArrowLeft, Loader2, ExternalLink, CalendarDays, RefreshCw, AlertTriangle, X, Globe } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface NewsFeedScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

interface NewsItem {
  title: string;
  link: string;
  description: string;
  pubDate: string;
  category: string;
  image: string | null;
}

export const NewsFeedScreen: React.FC<NewsFeedScreenProps> = ({ onNavigate }) => {
  const [news, setNews] = useState<NewsItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  
  // State for the in-app browser
  const [activeArticle, setActiveArticle] = useState<string | null>(null);

  useEffect(() => {
    fetchNews();
  }, []);

  const cleanDescription = (html: string) => {
      // Remove HTML tags and truncate
      const tmp = document.createElement("DIV");
      tmp.innerHTML = html;
      const text = tmp.textContent || tmp.innerText || "";
      return text.substring(0, 150) + (text.length > 150 ? '...' : '');
  };

  const extractImage = (html: string): string | null => {
      const match = html.match(/<img[^>]+src="([^">]+)"/);
      return match ? match[1] : null;
  };

  // Helper to map RSS categories to Rust Website Badges
  const normalizeCategory = (rawCat: string, title: string): string => {
      const lowerCat = (rawCat || "").toLowerCase().trim();
      const lowerTitle = (title || "").toLowerCase().trim();

      // 1. Force Community if title says so (Overrules generic tags)
      if (lowerTitle.includes('community update')) return 'Community';

      // 2. Map generic "News" to "Devblog" (Rust site usually treats Main News as Devblog/Red)
      if (lowerCat === 'news') return 'Devblog';
      if (lowerCat === 'devblog') return 'Devblog';
      
      // 3. Changelogs
      if (lowerCat === 'changelog') return 'Update';
      if (lowerCat === 'update') return 'Update';

      // 4. Default: Return original capitalized or 'General'
      if (!rawCat) return 'General';
      return rawCat.charAt(0).toUpperCase() + rawCat.slice(1);
  };

  const parseXML = (xmlText: string): NewsItem[] => {
      const parser = new DOMParser();
      const xml = parser.parseFromString(xmlText, "text/xml");
      const items = Array.from(xml.querySelectorAll("item"));
      
      if (items.length === 0) throw new Error("Invalid XML format");

      return items.map(item => {
        const title = item.querySelector("title")?.textContent || "No Title";
        const link = item.querySelector("link")?.textContent || "#";
        const descriptionRaw = item.querySelector("description")?.textContent || "";
        const pubDate = item.querySelector("pubDate")?.textContent || "";
        
        // Extract Category node
        const categoryNode = item.querySelector("category");
        const rawCategory = categoryNode?.textContent || "";
        
        // Normalize
        const category = normalizeCategory(rawCategory, title);
        
        return {
          title,
          link,
          description: cleanDescription(descriptionRaw),
          pubDate,
          category,
          image: extractImage(descriptionRaw)
        };
      });
  };

  const fetchNews = async () => {
    setLoading(true);
    setError(null);
    
    try {
        // STRATEGY 1: Local API (Preferred for Prod/Vercel)
        try {
            const res = await fetch('/api/rss');
            if (res.ok) {
                const text = await res.text();
                if (text.trim().startsWith('<')) {
                    const items = parseXML(text);
                    setNews(items);
                    setLoading(false);
                    return; 
                }
            }
        } catch (e) { /* Ignore local fail */ }

        // STRATEGY 2: RSS2JSON (Reliable Public API, returns JSON)
        try {
            const res = await fetch('https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Frust.facepunch.com%2Frss%2Fblog');
            if (res.ok) {
                const data = await res.json();
                if (data.status === 'ok') {
                    const items = data.items.map((item: any) => {
                        // RSS2JSON puts categories in an array
                        let rawCat = "";
                        if (item.categories && item.categories.length > 0) {
                            rawCat = item.categories[0]; 
                        }
                        
                        const normalizedCat = normalizeCategory(rawCat, item.title);

                        return {
                            title: item.title,
                            link: item.link,
                            description: cleanDescription(item.description),
                            pubDate: item.pubDate,
                            category: normalizedCat, 
                            image: item.thumbnail || extractImage(item.description)
                        };
                    });
                    setNews(items);
                    setLoading(false);
                    return;
                }
            }
        } catch (e) { /* Ignore RSS2JSON fail */ }

        // STRATEGY 3: AllOrigins (Raw Proxy)
        try {
            const res = await fetch(`https://api.allorigins.win/raw?url=${encodeURIComponent('https://rust.facepunch.com/rss/blog')}`);
            if (res.ok) {
                const text = await res.text();
                const items = parseXML(text);
                setNews(items);
                setLoading(false);
                return;
            }
        } catch (e) { /* Ignore AllOrigins fail */ }

        throw new Error("Could not connect to Rust News Network.");

    } catch (err: any) {
        console.error("News fetch failed:", err);
        setError("Unable to fetch live news.");
    } finally {
        setLoading(false);
    }
  };

  const formatDate = (dateString: string) => {
    try {
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
    } catch {
        return dateString;
    }
  };

  // --- RENDER WEB VIEW (If an article is selected) ---
  if (activeArticle) {
      return (
        <div className="flex flex-col h-full bg-[#1b2838] relative animate-in slide-in-from-bottom duration-300 z-50">
          {/* Web View Header */}
          <div className="flex items-center justify-between p-4 bg-[#171a21] border-b border-[#2a475e] shadow-md z-10 shrink-0">
            <div className="flex items-center gap-2 overflow-hidden">
                <Globe className="w-4 h-4 text-[#66c0f4] shrink-0" />
                <span className="text-xs font-bold text-[#c7d5e0] truncate">facepunch.com</span>
            </div>
            <button 
                onClick={() => setActiveArticle(null)}
                className="p-2 bg-[#2a475e] rounded hover:bg-[#66c0f4] hover:text-[#171a21] text-[#c7d5e0] transition-colors"
            >
                <X className="w-5 h-5" />
            </button>
          </div>

          {/* Iframe Container */}
          <div className="flex-1 relative bg-white">
             <iframe 
                src={activeArticle} 
                className="w-full h-full border-0"
                title="News Article"
                sandbox="allow-scripts allow-same-origin allow-forms allow-popups"
             />
          </div>
        </div>
      );
  }

  // --- RENDER LIST VIEW ---
  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>News Feed</h2>
                <div className="flex items-center gap-2">
                    <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Official Updates</p>
                </div>
            </div>
        </div>
        <button 
            onClick={fetchNews}
            disabled={loading}
            className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors disabled:opacity-50"
        >
            <RefreshCw className={`w-5 h-5 ${loading ? 'animate-spin' : ''}`} />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 space-y-4 pb-12">
          
          {loading && (
              <div className="flex flex-col items-center justify-center py-20 text-zinc-500 gap-3">
                  <Loader2 className="w-8 h-8 animate-spin text-orange-500" />
                  <span className="text-xs uppercase font-bold tracking-widest">Fetching from Facepunch...</span>
              </div>
          )}

          {error && !loading && (
              <div className="flex flex-col items-center justify-center py-10 gap-4">
                  <div className="w-16 h-16 bg-red-900/10 rounded-full flex items-center justify-center border border-red-500/20">
                      <AlertTriangle className="w-8 h-8 text-red-500" />
                  </div>
                  <div className="text-center">
                      <h3 className="text-white font-bold text-lg mb-1">Connection Failed</h3>
                      <p className="text-zinc-500 text-xs max-w-[250px] mx-auto leading-relaxed">
                          Could not retrieve live news feed from Rust servers.
                      </p>
                  </div>
                  <div className="flex flex-col gap-2 w-full max-w-[200px]">
                      <button 
                        onClick={fetchNews}
                        className="py-3 bg-red-600 hover:bg-red-500 text-white font-bold uppercase text-xs rounded-xl transition-colors shadow-lg shadow-red-900/20"
                      >
                          Try Again
                      </button>
                  </div>
              </div>
          )}

          {!loading && !error && news.map((item, idx) => (
              <div 
                key={idx}
                onClick={() => setActiveArticle(item.link)}
                className="block bg-[#121214] border border-zinc-800 rounded-2xl overflow-hidden hover:border-zinc-600 transition-all active:scale-[0.99] group shadow-lg cursor-pointer"
              >
                  {/* Image Area */}
                  <div className="w-full h-40 relative bg-zinc-900">
                      {item.image ? (
                          <img 
                            src={item.image} 
                            alt={item.title} 
                            className="w-full h-full object-cover opacity-80 group-hover:opacity-100 transition-opacity" 
                          />
                      ) : (
                          <div className="w-full h-full flex items-center justify-center bg-zinc-900">
                              <span className="text-zinc-700 font-black text-4xl select-none">RUST</span>
                          </div>
                      )}
                      
                      <div className="absolute inset-0 bg-gradient-to-t from-[#121214] to-transparent opacity-90" />
                  </div>

                  {/* Content */}
                  <div className="p-4 pt-2 relative z-10 -mt-6">
                      <div className="flex items-center gap-2 mb-2 text-[10px] text-zinc-400 font-mono">
                          <CalendarDays className="w-3 h-3" />
                          <span>{formatDate(item.pubDate)}</span>
                      </div>
                      
                      <h3 className="text-lg font-bold text-white leading-tight mb-2 group-hover:text-orange-500 transition-colors">
                          {item.title}
                      </h3>
                      
                      <p className="text-xs text-zinc-400 leading-relaxed line-clamp-2 mb-3">
                          {item.description}
                      </p>

                      <div className="flex items-center gap-1 text-[10px] font-bold text-zinc-500 uppercase tracking-wider group-hover:text-white transition-colors">
                          Read Full Article <ExternalLink className="w-3 h-3" />
                      </div>
                  </div>
              </div>
          ))}

          {!loading && !error && news.length > 0 && (
              <div className="text-center py-6 text-zinc-600 text-[10px] uppercase font-bold tracking-widest">
                  End of Feed
              </div>
          )}

      </div>
    </div>
  );
};
