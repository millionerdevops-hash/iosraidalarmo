
import React, { useState, useEffect } from 'react';
import { 
  ArrowLeft, 
  Search, 
  Loader2, 
  XCircle, 
  Ghost,
  AlertTriangle,
  Users,
  Hash,
  ShieldAlert
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { fetchBattleMetrics } from '../utils/api'; 
import { PlayerListItem, PlayerSearchResultItem } from '../components/player/PlayerListItem';
import { PlayerDetailSheet } from '../components/player/PlayerDetailSheet';

interface PlayerSearchScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// Temporary: Extending interface to hack in the missing prop without breaking existing usages in App.tsx
interface ExtendedProps extends PlayerSearchScreenProps {
    isFree?: boolean;
    onViewStats?: (id: string, name: string) => void;
}

// Extended interface for full details
interface PlayerFullDetails extends PlayerSearchResultItem {
  private: boolean;
  firstSeen: string;
  country?: string;
}

export const PlayerSearchScreen: React.FC<ExtendedProps> = ({ onNavigate, isFree = true, onViewStats }) => {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<PlayerFullDetails[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  
  // Sheet State
  const [selectedPlayer, setSelectedPlayer] = useState<PlayerFullDetails | null>(null);
  const [loadingSheet, setLoadingSheet] = useState(false);

  // Debounce search
  useEffect(() => {
    const delayDebounceFn = setTimeout(() => {
      if (query.trim().length > 2) {
        searchPlayers(query.trim());
      } else {
        setResults([]);
        setError(null);
      }
    }, 800);

    return () => clearTimeout(delayDebounceFn);
  }, [query]);

  const searchPlayers = async (rawQuery: string) => {
    setLoading(true);
    setError(null);
    const searchQuery = rawQuery.trim(); // Ensure no leading/trailing spaces

    try {
      // 1. Detect Steam ID (17 digits)
      const isSteamId = /^\d{17}$/.test(searchQuery);
      
      let params = '';
      if (isSteamId) {
          // If Steam ID, we use the search filter which supports steam IDs (e.g. filter[search]=76561198...)
          // BattleMetrics recommends using filter[search] for general queries including IDs
          params = `?filter[search]=${searchQuery}&include=server`; 
      } else {
          // Text Search: Get more results to find exact matches buried deep
          params = `?filter[search]=${encodeURIComponent(searchQuery)}&include=server&page[size]=100`;
      }

      const json = await fetchBattleMetrics('/players', params);
      const servers = json.included || [];

      if (!json.data || !Array.isArray(json.data)) {
          setResults([]);
          return;
      }

      // 2. Map Data
      let mappedResults: PlayerFullDetails[] = json.data.map((item: any) => {
         let currentServerName = undefined;
         let isOnline = false;

         const serverRelation = item.relationships?.servers?.data?.[0];
         
         if (serverRelation) {
             const serverObj = servers.find((s: any) => s.id === serverRelation.id);
             if (serverObj) {
                 currentServerName = serverObj.attributes.name;
                 isOnline = true;
             }
         }

         return {
            id: item.id,
            name: item.attributes?.name || "Unknown Player",
            private: item.attributes?.private || false, // Capture privacy status
            firstSeen: item.attributes?.createdAt || new Date().toISOString(),
            currentServer: currentServerName,
            status: isOnline ? 'online' : 'offline',
            country: 'Global'
         };
      });

      // 3. Filter Garbage AND Private Profiles
      mappedResults = mappedResults.filter(p => {
          const hasName = p.name && p.name.trim().length > 0 && p.name !== "Unknown Player";
          const isPublic = !p.private; // Filter out private profiles
          return hasName && isPublic;
      });

      // 4. Client-Side Smart Sorting (Crucial Step)
      if (!isSteamId) {
          const lowerQuery = searchQuery.toLowerCase();
          
          mappedResults.sort((a, b) => {
              const nameA = a.name.toLowerCase();
              const nameB = b.name.toLowerCase();

              // Priority 1: Exact Match (Absolute priority)
              const aExact = nameA === lowerQuery;
              const bExact = nameB === lowerQuery;
              if (aExact && !bExact) return -1;
              if (bExact && !aExact) return 1;

              // Priority 2: Starts With
              const aStarts = nameA.startsWith(lowerQuery);
              const bStarts = nameB.startsWith(lowerQuery);
              if (aStarts && !bStarts) return -1;
              if (bStarts && !aStarts) return 1;

              // Priority 3: Word Boundary Match (e.g. "Real Kurt" matches "Kurt")
              const aWord = nameA.split(' ').includes(lowerQuery);
              const bWord = nameB.split(' ').includes(lowerQuery);
              if (aWord && !bWord) return -1;
              if (bWord && !aWord) return 1;

              // Priority 4: Length (Shorter names usually mean closer match to query)
              return nameA.length - nameB.length;
          });
      }

      setResults(mappedResults);
    } catch (err: any) {
      console.error(err);
      // Display specific error if possible
      setError("Failed to fetch data. Ensure BattleMetrics API is reachable.");
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  const handleSelectPlayer = async (basicPlayer: PlayerFullDetails) => {
      setSelectedPlayer(basicPlayer);
      setLoadingSheet(true);

      try {
          const json = await fetchBattleMetrics(`/players/${basicPlayer.id}`, '?include=server');
          // Safe navigation: ensure data and attributes exist
          const attr = json.data?.attributes;
          
          let currentServerName = undefined;
          let isOnline = false;

          if (json.included && json.included.length > 0) {
              const activeServer = json.included.find((inc: any) => inc.type === 'server');
              if (activeServer) {
                  currentServerName = activeServer.attributes.name;
                  isOnline = true;
              }
          }

          setSelectedPlayer(prev => prev ? ({
              ...prev,
              firstSeen: attr?.createdAt || prev.firstSeen,
              private: attr?.private ?? prev.private,
              currentServer: currentServerName,
              status: isOnline ? 'online' : 'offline'
          }) : null);

      } catch (err) {
          console.error("Failed to fetch player details", err);
      } finally {
          setLoadingSheet(false);
      }
  };

  const handleTrackPlayer = (name: string, id: string) => {
      console.log(`Tracking ${name} (${id})`);
      setSelectedPlayer(null);
      onNavigate('DASHBOARD');
  };

  // Check query trimming for display logic
  const isSteamIdQuery = /^\d{17}$/.test(query.trim());

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center gap-4 bg-[#0c0c0e] z-10">
        <button 
          onClick={() => onNavigate('DASHBOARD')}
          className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
           <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Player Finder</h2>
           <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Global Database Search</p>
        </div>
      </div>

      <div className="flex-1 overflow-hidden flex flex-col p-6">
        
        {/* Search Input */}
        <div className="relative mb-4">
            <div className="absolute inset-y-0 left-3 flex items-center pointer-events-none">
                {isSteamIdQuery ? <Hash className="w-4 h-4 text-orange-500" /> : <Search className="w-5 h-5 text-zinc-500" />}
            </div>
            <input 
                type="text"
                className={`w-full bg-[#1c1c1e] border text-white text-sm rounded-xl py-4 pl-10 pr-4 outline-none transition-colors font-mono
                    ${isSteamIdQuery ? 'border-orange-500/50 focus:border-orange-500' : 'border-zinc-800 focus:border-purple-500'}
                `}
                placeholder="Search name or Steam ID (64)..."
                value={query}
                onChange={(e) => { setQuery(e.target.value); }}
                autoFocus
            />
            {query && (
                <button 
                    onClick={() => { setQuery(''); setResults([]); setError(null); }}
                    className="absolute inset-y-0 right-3 flex items-center text-zinc-500 hover:text-white"
                >
                    <XCircle className="w-5 h-5" />
                </button>
            )}
        </div>

        {/* Info Banner for SteamID */}
        {isSteamIdQuery && (
            <div className="flex items-center gap-2 mb-4 px-1">
                <ShieldAlert className="w-3 h-3 text-orange-500" />
                <span className="text-[10px] text-zinc-500">Searching specifically for Steam ID...</span>
            </div>
        )}

        {/* Content Area */}
        <div className="flex-1 overflow-y-auto no-scrollbar pb-8">
            
            {loading && (
                <div className="flex flex-col items-center justify-center py-10 gap-4 text-zinc-500">
                    <Loader2 className="w-8 h-8 animate-spin text-purple-500" />
                    <span className="text-xs uppercase tracking-widest">Searching Database...</span>
                </div>
            )}

            {error && (
                <div className="bg-red-950/20 border border-red-900/30 rounded-xl p-4 text-center">
                    <div className="w-10 h-10 bg-red-900/20 rounded-full flex items-center justify-center mx-auto mb-2">
                        <AlertTriangle className="w-5 h-5 text-red-500" />
                    </div>
                    <p className="text-red-400 text-sm font-bold">Connection Failed</p>
                    <p className="text-red-300/60 text-xs mt-1 mb-3">{error}</p>
                    <button 
                        onClick={() => searchPlayers(query)}
                        className="text-[10px] font-bold text-white bg-red-900/40 px-3 py-1.5 rounded-lg hover:bg-red-800/50"
                    >
                        Retry
                    </button>
                </div>
            )}

            {!loading && !error && results.length === 0 && query.length > 2 && (
                 <div className="text-center py-10 text-zinc-500">
                     <Ghost className="w-12 h-12 mx-auto mb-4 opacity-20" />
                     <p>No players found.</p>
                     <p className="text-[10px] mt-2 text-zinc-600 max-w-[200px] mx-auto">
                         Private profiles are automatically hidden. Double check the ID or name.
                     </p>
                 </div>
            )}

            {/* Results Count Header */}
            {!loading && results.length > 0 && (
                <div className="flex items-center justify-between gap-2 mb-3 px-1">
                    <div className="flex items-center gap-2">
                        <Users className="w-3 h-3 text-zinc-500" />
                        <span className="text-xs text-zinc-500 font-bold uppercase">{results.length} Public Profiles</span>
                    </div>
                    {isSteamIdQuery && (
                        <span className="text-[10px] text-orange-500 bg-orange-900/10 px-2 py-0.5 rounded border border-orange-500/20 uppercase font-bold">
                            Exact ID
                        </span>
                    )}
                </div>
            )}

            {/* List Results */}
            <div className="space-y-3">
                {results.map((player) => (
                    <PlayerListItem 
                        key={player.id} 
                        player={player} 
                        onClick={() => handleSelectPlayer(player)} 
                    />
                ))}
            </div>
        </div>
      </div>

      {/* --- BOTTOM SHEET MODAL --- */}
      {selectedPlayer && (
          <PlayerDetailSheet 
            player={selectedPlayer}
            loading={loadingSheet}
            onClose={() => setSelectedPlayer(null)}
            onTrack={handleTrackPlayer}
            isFreeUser={isFree}
            onPaywall={() => onNavigate('PAYWALL')}
            onViewStats={onViewStats} // Passed here!
          />
      )}

    </div>
  );
};
