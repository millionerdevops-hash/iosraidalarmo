
import React, { useState, useEffect } from 'react';
import { 
  Search, 
  Loader2, 
  XCircle, 
  Star, 
  Globe2,
  Flame,
  Users,
  Map as MapIcon,
  Globe
} from 'lucide-react';
import { ServerData } from '../../../types';
import { fetchBattleMetrics } from '../../../utils/api';

interface ServerSearchManagerProps {
    onSelectServer: (server: ServerData) => void;
}

const FEATURED_GROUPS = [
    { name: "Rusty Moose", query: "Rusty Moose" },
    { name: "Rustoria", query: "Rustoria" },
    { name: "Rustafied", query: "Rustafied" },
    { name: "Reddit PlayRust", query: "Reddit.com/r/PlayRust" },
    { name: "Vital", query: "Vital" },
    { name: "Rusticated", query: "Rusticated" },
    { name: "Stevious", query: "Stevious" },
    { name: "Bloo Lagoon", query: "Bloo Lagoon" },
    { name: "Pickle", query: "Pickle" },
    { name: "Paranoid", query: "Paranoid" },
    { name: "Renegade", query: "Renegade" },
    { name: "Werwolf", query: "Werwolf" },
    { name: "Hollow", query: "Hollow" },
    { name: "Atlas", query: "Atlas" },
    { name: "Upsurge", query: "Upsurge" },
    { name: "Garnet", query: "Garnet" }
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

export const ServerSearchManager: React.FC<ServerSearchManagerProps> = ({ onSelectServer }) => {
    const [searchMode, setSearchMode] = useState<'SEARCH' | 'FAVORITES' | 'FEATURED'>('SEARCH');
    const [query, setQuery] = useState('');
    const [results, setResults] = useState<ServerData[]>([]);
    const [loading, setLoading] = useState(false);
    const [favorites, setFavorites] = useState<ServerData[]>(() => {
        try {
            const saved = localStorage.getItem('raid_alarm_favs');
            return saved ? JSON.parse(saved) : [];
        } catch { return []; }
    });

    useEffect(() => {
        localStorage.setItem('raid_alarm_favs', JSON.stringify(favorites));
    }, [favorites]);

    useEffect(() => {
        const delayDebounceFn = setTimeout(() => {
            if (query.length > 2 && searchMode === 'SEARCH') {
                searchServers(query);
            } else if (query.length <= 2 && searchMode === 'SEARCH') {
                setResults([]);
            }
        }, 800);
        return () => clearTimeout(delayDebounceFn);
    }, [query, searchMode]);

    const searchServers = async (searchQuery: string) => {
        setLoading(true);
        try {
            const response = await fetchBattleMetrics('/servers', `?filter[game]=rust&filter[search]=${encodeURIComponent(searchQuery)}&page[size]=10`);
            const mappedResults: ServerData[] = response.data.map((item: any) => mapApiResponse(item));
            setResults(mappedResults);
        } catch (err) {
            console.error(err);
        } finally {
            setLoading(false);
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

    const toggleFavorite = (e: React.MouseEvent, server: ServerData) => {
        e.stopPropagation();
        setFavorites(prev => {
            const exists = prev.some(f => f.id === server.id);
            if (exists) return prev.filter(f => f.id !== server.id);
            return [...prev, server];
        });
    };

    const isFavorite = (serverId: string) => favorites.some(f => f.id === serverId);

    const handleFeaturedClick = (groupQuery: string) => {
        setSearchMode('SEARCH');
        setQuery(groupQuery);
        searchServers(groupQuery);
    };

    const renderServerList = (list: ServerData[], emptyMsg: string) => {
        if (list.length === 0) return <div className="text-center py-10 text-zinc-500 text-xs">{emptyMsg}</div>;
        
        return list.map((server) => {
            const isFav = isFavorite(server.id);
            return (
                <button 
                    key={server.id}
                    onClick={() => onSelectServer(server)}
                    className="w-full bg-[#121214] hover:bg-[#1c1c1e] border border-zinc-800 p-4 rounded-xl text-left transition-all active:scale-[0.98] group relative mb-2"
                >
                    <div className="flex justify-between items-start mb-2 pr-8">
                            <h3 className="text-white font-bold text-sm line-clamp-1 group-hover:text-orange-500 transition-colors">
                                {server.name}
                            </h3>
                    </div>
                    <div className="flex items-center gap-4 text-xs text-zinc-500 font-mono">
                            <span className="flex items-center gap-1.5"><Users className="w-3 h-3" />{server.players}/{server.maxPlayers}</span>
                            <span className="flex items-center gap-1.5"><MapIcon className="w-3 h-3" />{server.map || 'Procedural'}</span>
                    </div>
                    <div 
                        onClick={(e) => toggleFavorite(e, server)}
                        className="absolute top-4 right-4 text-zinc-600 hover:text-yellow-500 z-10 p-1"
                    >
                        <Star className={`w-4 h-4 ${isFav ? 'fill-yellow-500 text-yellow-500' : ''}`} />
                    </div>
                </button>
            );
        });
    };

    return (
        <div className="flex flex-col h-full">
            <div className="flex gap-2 mb-6 overflow-x-auto no-scrollbar">
                <SearchTabButton label="Search" active={searchMode === 'SEARCH'} onClick={() => setSearchMode('SEARCH')} />
                <SearchTabButton label="Favorites" active={searchMode === 'FAVORITES'} onClick={() => setSearchMode('FAVORITES')} />
                <SearchTabButton label="Featured" active={searchMode === 'FEATURED'} onClick={() => setSearchMode('FEATURED')} />
            </div>

            {searchMode === 'SEARCH' && (
                <>
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
                            autoFocus
                        />
                        {query && (
                            <button onClick={() => { setQuery(''); setResults([]); }} className="absolute inset-y-0 right-3 flex items-center text-zinc-500 hover:text-white">
                                <XCircle className="w-5 h-5" />
                            </button>
                        )}
                    </div>
                    <div className="flex-1 overflow-y-auto no-scrollbar pb-8">
                        {loading && <div className="text-center py-8 text-zinc-500 flex justify-center gap-2"><Loader2 className="w-4 h-4 animate-spin"/> Searching...</div>}
                        {!loading && renderServerList(results, query.length > 2 ? "No servers found." : "")}
                    </div>
                </>
            )}

            {searchMode === 'FAVORITES' && (
                <div className="flex-1 overflow-y-auto no-scrollbar pb-8">
                    {renderServerList(favorites, "No favorites saved.")}
                </div>
            )}

            {searchMode === 'FEATURED' && (
                <div className="flex-1 overflow-y-auto no-scrollbar pb-8">
                    <div className="grid grid-cols-2 gap-3">
                        {FEATURED_GROUPS.map((group) => (
                            <button
                                key={group.name}
                                onClick={() => handleFeaturedClick(group.query)}
                                className="bg-zinc-900 border border-zinc-800 hover:border-orange-500/50 hover:bg-zinc-800 p-4 rounded-xl flex items-center justify-center text-center transition-all group active:scale-[0.98] min-h-[84px] shadow-sm"
                            >
                                <span className="text-sm font-black text-zinc-300 uppercase tracking-wide group-hover:text-white transition-colors">
                                    {group.name}
                                </span>
                            </button>
                        ))}
                    </div>
                    <div className="mt-8 p-4 bg-zinc-900/30 rounded-xl border border-zinc-800/50">
                        <div className="flex items-center gap-2 mb-2">
                            <Flame className="w-4 h-4 text-orange-500" />
                            <h4 className="text-xs font-bold text-white uppercase">Official Servers</h4>
                        </div>
                        <p className="text-[10px] text-zinc-500 leading-relaxed">
                            Official servers offer monthly wipes and high reliability.
                        </p>
                    </div>
                </div>
            )}
        </div>
    );
};
