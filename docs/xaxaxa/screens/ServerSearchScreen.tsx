import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Search, 
  Loader2, 
  XCircle, 
  Star, 
  ListFilter,
  Check,
  WifiOff
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName, ServerData } from '../types';
import { fetchBattleMetrics } from '../utils/api';
import { ServerListItem } from '../components/server/ServerListItem';
import { FeaturedServersGrid } from '../components/server/FeaturedServersGrid';

interface ServerSearchScreenProps {
  onNavigate: (screen: ScreenName) => void;
  onSaveServer: (server: ServerData | null) => void;
}

const SORT_OPTIONS = [
    { id: 'rank', label: 'Relevance (Default)' },
    { id: '-players', label: 'High Pop (Most Players)' },
    { id: 'players', label: 'Low Pop (Least Players)' },
    { id: '-details.rust_last_wipe', label: 'Just Wiped (Newest)' },
    { id: 'details.rust_last_wipe', label: 'Oldest Map (Stale)' },
];

const SearchTabButton = ({ active, onClick, label }: any) => (
    <button 
        onClick={onClick}
        className={`px-4 py-2 rounded-full text-[10px] font-bold uppercase tracking-wider transition-all border
            ${active 
                ? 'bg-zinc-100 text-black border-white' 
                : 'bg-zinc-900 text-zinc-500 border-zinc-800 hover:border-zinc-600'
            }
        `}
    >
        {label}
    </button>
);

export const ServerSearchScreen: React.FC<ServerSearchScreenProps> = ({ 
  onNavigate, 
  onSaveServer
}) => {
  const [searchMode, setSearchMode] = useState<'SEARCH' | 'FAVORITES' | 'FEATURED'>('SEARCH');
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<ServerData[]>([]);
  const [favorites, setFavorites] = useState<ServerData[]>(() => {
      try {
          const saved = localStorage.getItem('raid_alarm_favs');
          return saved ? JSON.parse(saved) : [];
      } catch { return []; }
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [sortBy, setSortBy] = useState('rank');
  const [isSortMenuOpen, setIsSortMenuOpen] = useState(false);
  
  const sortMenuRef = useRef<HTMLDivElement>(null);

  // Close sort menu on click outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
        if (sortMenuRef.current && !sortMenuRef.current.contains(event.target as Node)) {
            setIsSortMenuOpen(false);
        }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Persist Favorites
  useEffect(() => {
      localStorage.setItem('raid_alarm_favs', JSON.stringify(favorites));
  }, [favorites]);

  // Debounce Search
  useEffect(() => {
    const delayDebounceFn = setTimeout(() => {
      if (query.length > 2 && searchMode === 'SEARCH') {
        searchServers(query, sortBy);
      } else if (query.length <= 2 && searchMode === 'SEARCH') {
        setResults([]);
        setError(null);
      }
    }, 800);
    return () => clearTimeout(delayDebounceFn);
  }, [query, searchMode]);

  const toggleFavorite = (e: React.MouseEvent, server: ServerData) => {
      e.stopPropagation();
      setFavorites(prev => {
          const exists = prev.some(f => f.id === server.id);
          if (exists) return prev.filter(f => f.id !== server.id);
          return [...prev, server];
      });
  };

  const isFavorite = (serverId: string) => favorites.some(f => f.id === serverId);

  const handleSelectServer = (server: ServerData) => {
      onSaveServer(server);
      onNavigate('SERVER_DETAIL');
  };

  const searchServers = async (searchQuery: string, sortOption: string) => {
    setLoading(true);
    setError(null);
    try {
      // USING CENTRALIZED API
      const params = `?filter[game]=rust&filter[search]=${encodeURIComponent(searchQuery)}&sort=${sortOption}&page[size]=20`;
      const json = await fetchBattleMetrics('/servers', params);

      const mappedResults: ServerData[] = json.data.map((item: any) => mapApiResponse(item));
      setResults(mappedResults);
    } catch (err: any) {
      console.error(err);
      setError(err.message || "Connection failed.");
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  const handleFeaturedClick = (groupQuery: string) => {
      setSearchMode('SEARCH');
      setQuery(groupQuery);
      setSortBy('rank');
      searchServers(groupQuery, 'rank');
  };

  const handleSortChange = (newSort: string) => {
      setSortBy(newSort);
      setIsSortMenuOpen(false);
      if (query.length > 2) {
          searchServers(query, newSort);
      }
  };

  const mapApiResponse = (item: any): ServerData => {
      const attr = item.attributes || {};
      const details = attr.details || {};
      return {
        id: item.id,
        name: attr.name || 'Unknown Server',
        ip: attr.ip || '0.0.0.0',
        port: attr.port || 0,
        players: attr.players || 0,
        maxPlayers: attr.maxPlayers || 0,
        status: attr.status || 'offline',
        rank: attr.rank,
        country: attr.country,
        map: details.map,
        mapSize: details.rust_world_size,
        seed: details.rust_world_seed,
        lastWipe: details.rust_last_wipe,
        nextWipe: details.rust_next_wipe,
        description: details.rust_description,
        url: details.rust_url,
        official: details.official || false,
        modded: !details.official,
        pve: details.pve || false,
        fps: details.rust_fps,
        uptime: details.rust_uptime,
        headerImage: details.rust_headerimage
      };
  };

  const activeSortLabel = SORT_OPTIONS.find(s => s.id === sortBy)?.label || 'Relevance';

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e]">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 relative">
        <div className="flex items-center gap-3">
            <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
              <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
               <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Server Search</h2>
               <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">
                   Find & Track
               </p>
            </div>
        </div>

        <div className="flex items-center gap-2">
            {/* Sort Dropdown Trigger (Only visible in search mode) */}
            {searchMode === 'SEARCH' && (
                <div className="relative" ref={sortMenuRef}>
                    <button 
                        onClick={() => setIsSortMenuOpen(!isSortMenuOpen)}
                        className={`w-10 h-10 rounded-full border flex items-center justify-center transition-all
                            ${isSortMenuOpen 
                                ? 'bg-zinc-800 border-zinc-600 text-white' 
                                : 'bg-zinc-900 border-zinc-800 text-zinc-500 hover:text-white'}
                        `}
                    >
                        <ListFilter className="w-5 h-5" />
                    </button>

                    {/* Dropdown Menu */}
                    {isSortMenuOpen && (
                        <div className="absolute right-0 top-full mt-2 w-56 bg-[#18181b] border border-zinc-800 rounded-xl shadow-2xl overflow-hidden z-50 animate-in fade-in zoom-in-95 duration-200">
                            <div className="p-2 border-b border-zinc-800/50 bg-black/20">
                                <span className="text-[10px] font-bold text-zinc-500 uppercase px-2">Sort Results By</span>
                            </div>
                            <div className="p-1">
                                {SORT_OPTIONS.map((option) => (
                                    <button
                                        key={option.id}
                                        onClick={() => handleSortChange(option.id)}
                                        className={`w-full text-left px-3 py-2.5 rounded-lg text-xs font-medium flex items-center justify-between transition-colors
                                            ${sortBy === option.id 
                                                ? 'bg-zinc-800 text-white' 
                                                : 'text-zinc-400 hover:bg-zinc-800/50 hover:text-zinc-300'}
                                        `}
                                    >
                                        {option.label}
                                        {sortBy === option.id && <Check className="w-3 h-3 text-orange-500" />}
                                    </button>
                                ))}
                            </div>
                        </div>
                    )}
                </div>
            )}
            
            {/* Quick Favorites Toggle */}
            <button 
                onClick={() => setSearchMode(searchMode === 'FAVORITES' ? 'SEARCH' : 'FAVORITES')}
                className={`w-10 h-10 rounded-full border flex items-center justify-center transition-all
                    ${searchMode === 'FAVORITES'
                        ? 'bg-yellow-500/10 border-yellow-500 text-yellow-500 shadow-[0_0_15px_rgba(234,179,8,0.3)]' 
                        : 'bg-zinc-900 border-zinc-800 text-zinc-500 hover:text-white'}
                `}
            >
                <Star className={`w-5 h-5 ${searchMode === 'FAVORITES' ? 'fill-yellow-500' : ''}`} />
            </button>
        </div>
      </div>

      <div className="flex-1 overflow-hidden flex flex-col p-6">
        
        {/* VIEW TABS */}
        <div className="flex gap-2 mb-6 overflow-x-auto no-scrollbar">
            <SearchTabButton label="Search" active={searchMode === 'SEARCH'} onClick={() => setSearchMode('SEARCH')} />
            <SearchTabButton label="Favorites" active={searchMode === 'FAVORITES'} onClick={() => setSearchMode('FAVORITES')} />
            <SearchTabButton label="Featured" active={searchMode === 'FEATURED'} onClick={() => setSearchMode('FEATURED')} />
        </div>

        {/* --- VIEW: SEARCH MODE --- */}
        {searchMode === 'SEARCH' && (
            <>
                {/* Search Input */}
                <div className="relative mb-6">
                    <div className="absolute inset-y-0 left-3 flex items-center pointer-events-none">
                        <Search className="w-5 h-5 text-zinc-500" />
                    </div>
                    <input 
                        type="text"
                        className="w-full bg-[#1c1c1e] border border-zinc-800 text-white text-sm rounded-xl py-4 pl-10 pr-4 focus:border-orange-500 focus:outline-none transition-colors font-mono"
                        placeholder="Search server name..."
                        value={query}
                        onChange={(e) => setQuery(e.target.value)}
                        autoFocus={!query}
                    />
                    {query && (
                        <button onClick={() => { setQuery(''); setResults([]); setError(null); }} className="absolute inset-y-0 right-3 flex items-center text-zinc-500 hover:text-white">
                            <XCircle className="w-5 h-5" />
                        </button>
                    )}
                </div>

                {/* Content: Loading / Results / Error / Featured Fallback */}
                <div className="flex-1 overflow-y-auto no-scrollbar pb-8 space-y-3">
                    
                    {/* Error State */}
                    {error && (
                        <div className="bg-red-950/20 border border-red-900/30 rounded-xl p-4 flex flex-col items-center justify-center text-center gap-2">
                            <div className="w-10 h-10 rounded-full bg-red-900/20 flex items-center justify-center">
                                <WifiOff className="w-5 h-5 text-red-500" />
                            </div>
                            <span className="text-sm font-bold text-red-400">Search Failed</span>
                            <span className="text-xs text-red-300/60 max-w-[200px]">{error}</span>
                            <button 
                                onClick={() => searchServers(query, sortBy)}
                                className="mt-2 px-4 py-2 bg-red-900/40 hover:bg-red-900/60 rounded-lg text-xs font-bold text-red-200 transition-colors"
                            >
                                Retry Search
                            </button>
                        </div>
                    )}

                    {/* Active Sort Indicator (Only if query exists & no error) */}
                    {query.length > 2 && !loading && !error && results.length > 0 && (
                        <div className="flex justify-between items-center px-1 mb-2">
                             <span className="text-[10px] text-zinc-500 uppercase font-bold tracking-wider">Results</span>
                             <div className="flex items-center gap-1.5 text-[10px] text-zinc-400">
                                 <ListFilter className="w-3 h-3" />
                                 <span>{activeSortLabel}</span>
                             </div>
                        </div>
                    )}

                    {loading && (
                        <div className="text-center py-12 text-zinc-500 flex flex-col items-center">
                            <Loader2 className="w-8 h-8 animate-spin mb-3 text-orange-500"/>
                            <span className="text-xs font-mono uppercase tracking-widest">Searching...</span>
                        </div>
                    )}
                    
                    {!loading && !error && results.length === 0 && query.length > 2 && (
                         <div className="text-center py-12 text-zinc-500 border border-dashed border-zinc-800 rounded-xl">
                             No servers found matching "{query}"
                         </div>
                    )}

                    {/* Server List */}
                    {query.length > 2 ? (
                        results.map((server) => (
                            <ServerListItem 
                                key={server.id}
                                server={server}
                                isFavorite={isFavorite(server.id)}
                                onSelect={handleSelectServer}
                                onToggleFavorite={toggleFavorite}
                            />
                        ))
                    ) : (
                        /* Featured Grid displayed when search is empty in Search Mode */
                        !loading && !error && (
                            <FeaturedServersGrid onGroupSelect={handleFeaturedClick} />
                        )
                    )}
                </div>
            </>
        )}

        {/* --- VIEW: FAVORITES MODE --- */}
        {searchMode === 'FAVORITES' && (
            <div className="flex-1 overflow-y-auto no-scrollbar pb-8 space-y-3 animate-in fade-in slide-in-from-right-4 duration-300">
                {favorites.length === 0 ? (
                    <div className="text-center py-20 text-zinc-600 border border-dashed border-zinc-800 rounded-xl flex flex-col items-center">
                        <Star className="w-12 h-12 mb-4 opacity-20" />
                        <p className="text-sm font-bold text-zinc-400">No favorites saved.</p>
                        <p className="text-xs mt-2 text-zinc-600 max-w-[200px]">
                            Search for servers and tap the star icon to track them here.
                        </p>
                        <button 
                            onClick={() => setSearchMode('SEARCH')}
                            className="mt-6 text-xs text-orange-500 font-bold uppercase hover:text-orange-400"
                        >
                            Return to Search
                        </button>
                    </div>
                ) : (
                    favorites.map((server) => (
                        <ServerListItem 
                            key={server.id}
                            server={server}
                            isFavorite={true}
                            onSelect={handleSelectServer}
                            onToggleFavorite={toggleFavorite}
                        />
                    ))
                )}
            </div>
        )}

        {/* --- VIEW: FEATURED MODE (Distinct Tab) --- */}
        {searchMode === 'FEATURED' && (
            <div className="flex-1 overflow-y-auto no-scrollbar pb-8">
                <FeaturedServersGrid onGroupSelect={handleFeaturedClick} />
            </div>
        )}

      </div>
    </div>
  );
};