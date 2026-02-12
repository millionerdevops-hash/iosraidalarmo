
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, Star, Activity, Terminal, Crosshair, CalendarDays, 
  Map as MapIcon, Users, Cpu, Clock, Timer, AlertTriangle, 
  History, RefreshCw, List, Loader2, Globe, Bell, BellOff,
  Wifi, WifiOff
} from 'lucide-react';
import { ServerData, TargetPlayer, AlertConfig } from '../../../types';
import { fetchBattleMetrics } from '../../../utils/api';
import { Button } from '../../Button';
import { ServerHeader } from '../detail/ServerHeader';
import { ServerOverviewTab } from '../detail/ServerOverviewTab';
import { ServerMapTab } from '../detail/ServerMapTab';
import { ServerLiveTab } from '../detail/ServerLiveTab';
import { ServerTargetsTab } from '../detail/ServerTargetsTab';

interface ServerDetailManagerProps {
    server: ServerData;
    onBack: () => void;
    onSaveServer: (server: ServerData | null) => void;
    wipeAlertEnabled: boolean;
    onToggleWipeAlert: (enabled: boolean) => void;
    wipeAlertMinutes: number;
    onSetWipeAlertMinutes?: (minutes: number) => void;
}

// --- TYPES ---
interface LogEntry {
    id: number;
    text: string;
    playerName: string;
    playerId: string;
    type: 'join' | 'leave' | 'error';
    time: string;
}

// --- SUB-COMPONENTS (Simplified for the split) ---
const TabButton = ({ active, onClick, label, icon: Icon }: any) => (
    <button 
        onClick={onClick}
        className={`flex-1 py-3 flex items-center justify-center gap-2 border-b-2 transition-all text-xs uppercase font-bold tracking-wider
            ${active 
                ? 'border-orange-500 text-white bg-zinc-900/50' 
                : 'border-transparent text-zinc-600 hover:text-zinc-400'
            }
        `}
    >
        <Icon className="w-4 h-4" />
        {label}
    </button>
);

export const ServerDetailManager: React.FC<ServerDetailManagerProps> = ({
    server,
    onBack,
    onSaveServer,
    wipeAlertEnabled,
    onToggleWipeAlert,
    wipeAlertMinutes,
    onSetWipeAlertMinutes
}) => {
    const [activeTab, setActiveTab] = useState<'OVERVIEW' | 'LIVE' | 'TARGETS' | 'WIPE'>('OVERVIEW');
    const [logs, setLogs] = useState<LogEntry[]>([]);
    const [trackedTargets, setTrackedTargets] = useState<TargetPlayer[]>([]);
    const [refreshing, setRefreshing] = useState(false);
    
    // Favorites
    const [favorites, setFavorites] = useState<ServerData[]>(() => {
        try { return JSON.parse(localStorage.getItem('raid_alarm_favs') || '[]'); } catch { return []; }
    });

    const isFav = favorites.some(f => f.id === server.id);
    const pollIntervalRef = useRef<number | null>(null);
    const playerCacheRef = useRef<Map<string, string>>(new Map());
    const isFirstLoadRef = useRef(true);

    // Persist Favs
    useEffect(() => {
        localStorage.setItem('raid_alarm_favs', JSON.stringify(favorites));
    }, [favorites]);

    // Initial load & Polling
    useEffect(() => {
        refreshServerData();
        if (activeTab === 'LIVE' || activeTab === 'TARGETS') {
            startPolling();
        } else {
            stopPolling();
        }
        return () => stopPolling();
    }, [server.id, activeTab]);

    const toggleFavorite = () => {
        setFavorites(prev => {
            const exists = prev.some(f => f.id === server.id);
            if (exists) return prev.filter(f => f.id !== server.id);
            return [...prev, server];
        });
    };

    const startPolling = () => {
        stopPolling();
        fetchLiveFeed();
        pollIntervalRef.current = window.setInterval(fetchLiveFeed, 10000);
    };
  
    const stopPolling = () => {
        if (pollIntervalRef.current) {
            clearInterval(pollIntervalRef.current);
            pollIntervalRef.current = null;
        }
    };

    const refreshServerData = async () => {
        setRefreshing(true);
        try {
            const json = await fetchBattleMetrics(`/servers/${server.id}`);
            if(json.data) onSaveServer(mapApiResponse(json.data));
        } catch (err) { console.error(err); } 
        finally { setRefreshing(false); }
    };

    const fetchLiveFeed = async () => {
        try {
            const json = await fetchBattleMetrics(`/servers/${server.id}`, '?include=player');
            if (json.included) processPlayerDiff(json.included);
        } catch (err) { console.error("Polling error", err); }
    };

    const processPlayerDiff = (includedData: any[]) => {
        const currentPlayers = includedData.filter((item: any) => item.type === 'player');
        const currentMap = new Map<string, string>();
        const newLogs: LogEntry[] = [];
        const now = new Date();
        const timeString = now.toLocaleTimeString([], { hour12: false });
  
        currentPlayers.forEach((p: any) => currentMap.set(p.id, p.attributes.name));
  
        setTrackedTargets(prev => prev.map(target => {
            const isOnline = Array.from(currentMap.values()).some(n => n.toLowerCase() === target.name.toLowerCase());
            return { ...target, isOnline, lastSeen: isOnline ? 'Online now' : `Left at ${timeString}` };
        }));
  
        if (isFirstLoadRef.current) {
            playerCacheRef.current = currentMap;
            isFirstLoadRef.current = false;
            // Fake initial logs
            setLogs(currentPlayers.slice(0,4).map((p:any) => ({
                id: Math.random(), text: `Connected`, playerName: p.attributes.name, playerId: p.id, type: 'join', time: 'Recently'
            })));
            return;
        }
  
        const previousMap = playerCacheRef.current;
        currentMap.forEach((name, id) => {
            if (!previousMap.has(id)) newLogs.push({ id: Math.random(), text: `Connected`, playerName: name, playerId: id, type: 'join', time: timeString });
        });
        previousMap.forEach((name, id) => {
            if (!currentMap.has(id)) newLogs.push({ id: Math.random(), text: `Disconnected`, playerName: name, playerId: id, type: 'leave', time: timeString });
        });
  
        playerCacheRef.current = currentMap;
        if (newLogs.length > 0) setLogs(prev => [...newLogs, ...prev].slice(0, 50));
    };

    const mapApiResponse = (item: any): ServerData => {
        const attr = item.attributes || {};
        const details = attr.details || {};
        return {
          id: item.id,
          name: attr.name || 'Unknown', ip: attr.ip || '0.0.0.0', port: attr.port || 0,
          players: attr.players || 0, maxPlayers: attr.maxPlayers || 0, status: attr.status || 'offline',
          rank: attr.rank, map: details.map, mapSize: details.rust_world_size, seed: details.rust_world_seed,
          lastWipe: details.rust_last_wipe, nextWipe: details.rust_next_wipe, official: details.official || false,
          fps: details.rust_fps, uptime: details.rust_uptime, headerImage: details.rust_headerimage,
          entities: details.rust_ent_cnt_i
        };
    };

    // --- RENDER ---
    return (
        <div className="flex flex-col h-full bg-[#0c0c0e] relative">
            {/* Header */}
            <ServerHeader 
                server={server}
                isFavorite={isFav}
                onToggleFavorite={toggleFavorite}
                onNavigate={onBack} 
            />

            {/* Tabs */}
            <div className="flex border-b border-zinc-800 bg-[#0c0c0e]">
                <TabButton label="Overview" icon={Activity} active={activeTab === 'OVERVIEW'} onClick={() => setActiveTab('OVERVIEW')} />
                <TabButton label="Live" icon={Terminal} active={activeTab === 'LIVE'} onClick={() => setActiveTab('LIVE')} />
                <TabButton label="Targets" icon={Crosshair} active={activeTab === 'TARGETS'} onClick={() => setActiveTab('TARGETS')} />
                <TabButton label="Wipe" icon={CalendarDays} active={activeTab === 'WIPE'} onClick={() => setActiveTab('WIPE')} />
            </div>

            {/* Content Body */}
            <div className="flex-1 overflow-y-auto p-4">
                {activeTab === 'OVERVIEW' && (
                    <ServerOverviewTab 
                        server={server}
                        refreshing={refreshing}
                        onRefresh={refreshServerData}
                        onChangeServer={onBack}
                        wipeAlertEnabled={wipeAlertEnabled}
                        onToggleWipeAlert={onToggleWipeAlert}
                        wipeAlertMinutes={wipeAlertMinutes}
                        onSetWipeAlertMinutes={onSetWipeAlertMinutes}
                    />
                )}

                {activeTab === 'LIVE' && (
                    <ServerLiveTab 
                        logs={logs}
                        feedError={null}
                        onInspectPlayer={() => {}} // Placeholder
                    />
                )}

                {activeTab === 'TARGETS' && (
                    <ServerTargetsTab 
                        trackedTargets={trackedTargets}
                        targetInput={""}
                        onTargetInputChange={() => {}}
                        verifyingTarget={false}
                        onVerifyAndAdd={() => {}}
                        targetError={null}
                        onEditTarget={() => {}}
                        onGoToLive={() => setActiveTab('LIVE')}
                    />
                )}

                {activeTab === 'WIPE' && (
                    <div className="space-y-6 animate-in fade-in slide-in-from-right-2 duration-300">
                        <div className="bg-zinc-900 border border-zinc-800 rounded-2xl p-6 text-center">
                            <h3 className="text-zinc-500 text-xs font-bold uppercase tracking-widest mb-2 flex items-center justify-center gap-2">
                                <Timer className="w-3 h-3" /> Next Wipe In
                            </h3>
                            <div className="text-3xl font-black text-white font-mono tracking-tighter">
                                --
                            </div>
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
};
