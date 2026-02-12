
import React, { useState, useEffect, useRef } from 'react';
import { 
  AlertTriangle, 
  RefreshCw, 
  Activity, 
  Map as MapIcon, 
  Terminal, 
  Crosshair, 
  BellRing, 
  Wifi, 
  WifiOff, 
  Trash2, 
  CheckCircle2
} from 'lucide-react';
import { ScreenName, ServerData, TargetPlayer, AlertConfig } from '../types';
import { fetchBattleMetrics } from '../utils/api';
import { Button } from '../components/Button';

// Imported Widgets
import { ServerHeader } from '../components/server/detail/ServerHeader';
import { ServerOverviewTab } from '../components/server/detail/ServerOverviewTab';
import { ServerMapTab } from '../components/server/detail/ServerMapTab';
import { ServerLiveTab } from '../components/server/detail/ServerLiveTab';
import { ServerTargetsTab } from '../components/server/detail/ServerTargetsTab';

interface ServerDetailScreenProps {
  onNavigate: (screen: ScreenName) => void;
  savedServer: ServerData; // Must exist
  onSaveServer: (server: ServerData | null) => void;
  wipeAlertEnabled: boolean;
  onToggleWipeAlert: (enabled: boolean) => void;
  wipeAlertMinutes?: number;
  onSetWipeAlertMinutes?: (minutes: number) => void;
  trackedTargets: TargetPlayer[];
  onUpdateTargets: (targets: TargetPlayer[]) => void;
}

// Types for internal logic
interface BMPlayer {
    id: string;
    attributes: { name: string; };
    meta?: { time?: number; }
}

interface LogEntry {
    id: number;
    text: string;
    playerName: string;
    playerId: string;
    type: 'join' | 'leave' | 'error';
    time: string;
}

interface PlayerDetail {
    id: string;
    name: string;
    firstSeen?: string;
    isPrivate?: boolean;
    sessionEvents?: number;
    isOnlineRealtime: boolean;
}

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
        {/* Only show icon if provided, but design usually favors text or icon+text */}
        {label}
    </button>
);

export const ServerDetailScreen: React.FC<ServerDetailScreenProps> = ({ 
  onNavigate, 
  savedServer, 
  onSaveServer,
  wipeAlertEnabled,
  onToggleWipeAlert,
  wipeAlertMinutes = 30,
  onSetWipeAlertMinutes,
  trackedTargets,
  onUpdateTargets
}) => {
  const [activeTab, setActiveTab] = useState<'OVERVIEW' | 'MAP' | 'LIVE' | 'TARGETS'>('OVERVIEW');
  const [refreshing, setRefreshing] = useState(false);
  const [serverError, setServerError] = useState<string | null>(null);
  
  // Real Logs State
  const [logs, setLogs] = useState<LogEntry[]>([]);
  const [feedError, setFeedError] = useState<string | null>(null);
  
  // Modals State
  const [inspectingPlayer, setInspectingPlayer] = useState<PlayerDetail | null>(null);
  const [editingTarget, setEditingTarget] = useState<TargetPlayer | null>(null);
  
  const [loadingPlayerDetails, setLoadingPlayerDetails] = useState(false);
  const [tempAlertConfig, setTempAlertConfig] = useState<AlertConfig>({ onOnline: true, onOffline: false });

  // Manual Target Entry State
  const [targetInput, setTargetInput] = useState('');
  const [verifyingTarget, setVerifyingTarget] = useState(false);
  const [targetError, setTargetError] = useState<string | null>(null);

  // Refs
  const playerCacheRef = useRef<Map<string, string>>(new Map());
  const isFirstLoadRef = useRef(true);
  const pollIntervalRef = useRef<number | null>(null);
  
  // Favorites Logic
  const [favorites, setFavorites] = useState<ServerData[]>(() => {
      try {
          const saved = localStorage.getItem('raid_alarm_favs');
          return saved ? JSON.parse(saved) : [];
      } catch { return []; }
  });

  const toggleFavorite = (e: React.MouseEvent) => {
      e.stopPropagation();
      setFavorites(prev => {
          const exists = prev.some(f => f.id === savedServer.id);
          const newFavs = exists 
            ? prev.filter(f => f.id !== savedServer.id)
            : [...prev, savedServer];
          
          localStorage.setItem('raid_alarm_favs', JSON.stringify(newFavs));
          return newFavs;
      });
  };

  const isFav = favorites.some(f => f.id === savedServer.id);

  // Initial refresh & Polling Logic
  useEffect(() => {
    refreshServerData(savedServer.id);
    startPolling(savedServer.id);
    return () => stopPolling();
  }, [savedServer.id]);

  // Reset temp config when opening inspection modal
  useEffect(() => {
      if (inspectingPlayer) {
          const existing = trackedTargets.find(t => t.name.toLowerCase() === inspectingPlayer.name.toLowerCase());
          setTempAlertConfig(existing?.alertConfig || { onOnline: true, onOffline: false });
      }
  }, [inspectingPlayer]);

  const startPolling = (serverId: string) => {
      stopPolling();
      fetchLiveFeed(serverId);
      // OPTIMIZATION: 30 seconds poll interval to match Vercel cache and prevent rate limiting
      pollIntervalRef.current = window.setInterval(() => fetchLiveFeed(serverId), 30000);
  };

  const stopPolling = () => {
      if (pollIntervalRef.current) {
          clearInterval(pollIntervalRef.current);
          pollIntervalRef.current = null;
      }
  };

  const refreshServerData = async (serverId: string) => {
    setRefreshing(true);
    setServerError(null);
    try {
        const json = await fetchBattleMetrics(`/servers/${serverId}`);
        if(json.data) {
            onSaveServer(mapApiResponse(json.data));
        }
    } catch (err: any) {
        console.error("Failed to refresh", err);
        setServerError("Connection unstable. Data may be stale.");
    } finally {
        setRefreshing(false);
    }
  };

  const fetchLiveFeed = async (serverId: string) => {
      try {
          const json = await fetchBattleMetrics(`/servers/${serverId}`, '?include=player');
          setFeedError(null);
          if (json.included) processPlayerDiff(json.included);
      } catch (err) {
          console.error("Live feed error", err);
          setFeedError("Signal Lost. Retrying...");
      }
  };

  const processPlayerDiff = (includedData: any[]) => {
      const currentPlayers: BMPlayer[] = includedData.filter((item: any) => item.type === 'player');
      const currentMap = new Map<string, string>();
      const newLogs: typeof logs = [];
      const now = new Date();
      const timeString = now.toLocaleTimeString([], { hour12: false });

      currentPlayers.forEach(p => currentMap.set(p.id, p.attributes.name));

      // Calculate updates for GLOBAL tracked targets
      const updatedTargets = trackedTargets.map(target => {
          const isOnline = Array.from(currentMap.values()).some((name: string) => 
              name.toLowerCase() === target.name.toLowerCase()
          );
          const config = target.alertConfig || { onOnline: true, onOffline: false };
          let lastSeen = target.lastSeen;
          
          if (target.isOnline !== isOnline) {
             if (isOnline) {
                 lastSeen = 'Online now';
             } else {
                 lastSeen = `Left at ${timeString}`;
             }
          }
          return { ...target, isOnline, lastSeen, alertConfig: config };
      });

      if (JSON.stringify(updatedTargets) !== JSON.stringify(trackedTargets)) {
          onUpdateTargets(updatedTargets);
      }

      if (isFirstLoadRef.current) {
          playerCacheRef.current = currentMap;
          isFirstLoadRef.current = false;
          
          const recentJoins = currentPlayers
            .filter(p => p.meta && p.meta.time && p.meta.time < 600)
            .sort((a, b) => (a.meta?.time || 0) - (b.meta?.time || 0))
            .slice(0, 4);

          const initialLogs: LogEntry[] = recentJoins.map(p => ({
              id: Date.now() + Math.random(),
              text: `Connected`,
              playerName: p.attributes.name,
              playerId: p.id,
              type: 'join',
              time: 'Recently'
          }));
          setLogs(initialLogs);
          return;
      }

      const previousMap = playerCacheRef.current;

      currentMap.forEach((name, id) => {
          if (!previousMap.has(id)) {
              newLogs.push({
                  id: Date.now() + Math.random(),
                  text: `Connected`,
                  playerName: name,
                  playerId: id,
                  type: 'join',
                  time: timeString
              });
          }
      });

      previousMap.forEach((name, id) => {
          if (!currentMap.has(id)) {
              newLogs.push({
                  id: Date.now() + Math.random(),
                  text: `Disconnected`,
                  playerName: name,
                  playerId: id,
                  type: 'leave',
                  time: timeString
              });
          }
      });

      playerCacheRef.current = currentMap;
      if (newLogs.length > 0) setLogs(prev => [...newLogs, ...prev].slice(0, 50));
  };

  const handleInspectPlayer = async (playerId: string, playerName: string) => {
     const isOnlineRealtime = playerCacheRef.current.has(playerId);
     setInspectingPlayer({ id: playerId, name: playerName, isOnlineRealtime }); 
     setLoadingPlayerDetails(true);

     try {
         const json = await fetchBattleMetrics(`/players/${playerId}`);
         const attrs = json.data?.attributes;
         if (attrs) {
             setInspectingPlayer(prev => prev ? ({
                 ...prev,
                 firstSeen: attrs.createdAt,
                 isPrivate: attrs.private,
                 sessionEvents: logs.filter(l => l.playerId === playerId).length,
             }) : null);
         }
     } catch (err) {
         console.error(err);
     } finally {
         setLoadingPlayerDetails(false);
     }
  };

  const addOrUpdateTarget = (name: string, id?: string) => {
      const existingIdx = trackedTargets.findIndex(t => t.name.toLowerCase() === name.toLowerCase());
      const safeConfig = tempAlertConfig || { onOnline: true, onOffline: false };
      const isOnline = Array.from(playerCacheRef.current.values()).some((n: string) => n.toLowerCase() === name.toLowerCase());

      if (existingIdx >= 0) {
          const updated = [...trackedTargets];
          updated[existingIdx] = { ...updated[existingIdx], alertConfig: safeConfig };
          onUpdateTargets(updated);
      } else {
          const newTarget: TargetPlayer = {
              name: name,
              id: id,
              isOnline: isOnline, 
              lastSeen: isOnline ? 'Online now' : 'Offline',
              alertConfig: safeConfig
          };
          onUpdateTargets([...trackedTargets, newTarget]);
      }
      setInspectingPlayer(null);
      setActiveTab('TARGETS');
  };

  const verifyAndAddTarget = async () => {
    if(!targetInput || targetInput.length < 2) return;
    
    setVerifyingTarget(true);
    setTargetError(null);
    
    try {
        const params = `?filter[search]=${encodeURIComponent(targetInput)}&filter[servers]=${savedServer.id}&page[size]=1`;
        const json = await fetchBattleMetrics('/players', params);
        
        if (json.data && json.data.length > 0) {
            const player = json.data[0];
            addOrUpdateTarget(player.attributes.name, player.id);
            setTargetInput('');
        } else {
            setTargetError('Player not found on this server.');
        }
    } catch (err) {
        setTargetError('Connection error. Try again.');
    } finally {
        setVerifyingTarget(false);
    }
  };

  const handleUpdateTargetConfig = (type: 'onOnline' | 'onOffline') => {
    if (!editingTarget) return;
    const newConfig = { onOnline: type === 'onOnline', onOffline: type === 'onOffline' };
    setEditingTarget(prev => prev ? ({ ...prev, alertConfig: newConfig }) : null);
    const updatedList = trackedTargets.map(t => t.name === editingTarget.name ? { ...t, alertConfig: newConfig } : t);
    onUpdateTargets(updatedList);
  };

  const removeTarget = () => {
      if (!editingTarget) return;
      onUpdateTargets(trackedTargets.filter(t => t.name !== editingTarget.name));
      setEditingTarget(null);
  };

  const updateTempConfig = (type: 'onOnline' | 'onOffline') => {
      setTempAlertConfig(prev => {
          const newState = { ...prev };
          if (type === 'onOnline') {
              newState.onOnline = !prev.onOnline;
              if (newState.onOnline) newState.onOffline = false;
          } else {
              newState.onOffline = !prev.onOffline;
              if (newState.onOffline) newState.onOnline = false;
          }
          return newState;
      });
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

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] relative">
        
        {/* HEADER WIDGET */}
        <ServerHeader 
            server={savedServer}
            isFavorite={isFav}
            onToggleFavorite={toggleFavorite}
            onNavigate={onNavigate}
        />

        {/* TABS NAVIGATION */}
        <div className="flex border-b border-zinc-800 bg-[#0c0c0e] overflow-x-auto no-scrollbar">
            <div className="flex w-full min-w-max">
                <TabButton label="OVERVIEW" active={activeTab === 'OVERVIEW'} onClick={() => setActiveTab('OVERVIEW')} />
                <TabButton label="MAP" active={activeTab === 'MAP'} onClick={() => setActiveTab('MAP')} />
                <TabButton label="LIVE" active={activeTab === 'LIVE'} onClick={() => setActiveTab('LIVE')} />
                <TabButton label="TARGETS" active={activeTab === 'TARGETS'} onClick={() => setActiveTab('TARGETS')} />
            </div>
        </div>

        {/* MAIN CONTENT AREA */}
        <div className={`flex-1 overflow-y-auto relative z-0 ${activeTab === 'MAP' ? 'p-0' : 'p-0'}`}>
            
            {/* Connection Error Banner */}
            {serverError && (
                <div className="m-4 bg-red-950/20 border border-red-900/30 rounded-xl p-3 flex items-center gap-3">
                    <AlertTriangle className="w-5 h-5 text-red-500 shrink-0" />
                    <div className="flex-1">
                        <span className="text-xs font-bold text-red-400 block">Connection Issue</span>
                        <span className="text-[10px] text-zinc-400">{serverError}</span>
                    </div>
                    <button onClick={() => refreshServerData(savedServer.id)} className="bg-red-900/40 p-2 rounded-lg hover:bg-red-900/60 transition-colors">
                        <RefreshCw className="w-4 h-4 text-red-200" />
                    </button>
                </div>
            )}

            {activeTab === 'OVERVIEW' && (
                <ServerOverviewTab 
                    server={savedServer}
                    refreshing={refreshing}
                    onRefresh={() => refreshServerData(savedServer.id)}
                    onChangeServer={() => { onSaveServer(null); onNavigate('SERVER_SEARCH'); }}
                    wipeAlertEnabled={wipeAlertEnabled}
                    onToggleWipeAlert={onToggleWipeAlert}
                    wipeAlertMinutes={wipeAlertMinutes}
                    onSetWipeAlertMinutes={onSetWipeAlertMinutes}
                />
            )}

            {activeTab === 'MAP' && (
                <ServerMapTab server={savedServer} />
            )}

            {activeTab === 'LIVE' && (
                <ServerLiveTab 
                    logs={logs}
                    feedError={feedError}
                    onInspectPlayer={handleInspectPlayer}
                />
            )}

            {activeTab === 'TARGETS' && (
                <ServerTargetsTab 
                    trackedTargets={trackedTargets}
                    targetInput={targetInput}
                    onTargetInputChange={setTargetInput}
                    verifyingTarget={verifyingTarget}
                    onVerifyAndAdd={verifyAndAddTarget}
                    targetError={targetError}
                    onEditTarget={setEditingTarget}
                    onGoToLive={() => setActiveTab('LIVE')}
                />
            )}
        </div>

        {/* --- MODALS --- */}

        {/* 1. INSPECTION SHEET */}
        {inspectingPlayer && (
            <div className="absolute inset-0 z-50 flex items-end justify-center bg-black/80 backdrop-blur-[2px]">
                <div className="absolute inset-0" onClick={() => setInspectingPlayer(null)} />
                <div className="w-full bg-[#18181b] border-t border-zinc-800 rounded-t-3xl p-6 shadow-2xl relative z-10 animate-in slide-in-from-bottom-full duration-300">
                    <div className="w-12 h-1 bg-zinc-700 rounded-full mx-auto mb-6" />
                    <h2 className="text-2xl font-black text-white leading-tight mb-4">{inspectingPlayer.name}</h2>
                    
                    <div className="bg-zinc-900/50 p-3 rounded-xl border border-zinc-800 mb-4">
                        {inspectingPlayer.isOnlineRealtime ? (
                            <span className="text-green-500 font-mono text-sm font-bold flex items-center gap-2"><div className="w-2.5 h-2.5 bg-green-500 rounded-full" />Online</span>
                        ) : (
                            <span className="text-red-500 font-mono text-sm font-bold flex items-center gap-2"><div className="w-2.5 h-2.5 bg-red-500 rounded-full" />Offline</span>
                        )}
                    </div>
                    
                    <div className="bg-zinc-900/30 border border-zinc-800 p-4 rounded-xl">
                        <div className="flex items-center gap-2 mb-3">
                            <BellRing className="w-4 h-4 text-orange-500" />
                            <span className="text-xs font-bold uppercase text-zinc-400">Alert Triggers:</span>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                            <button onClick={() => updateTempConfig('onOnline')} className={`p-3 rounded-lg border-2 transition-all flex flex-col items-center gap-2 ${tempAlertConfig.onOnline ? 'bg-green-500/10 border-green-500 text-green-500' : 'bg-zinc-900 border-zinc-800 text-zinc-500'}`}>
                                <Wifi className="w-5 h-5" /><span className="text-[10px] font-bold uppercase">Online</span>
                            </button>
                            <button onClick={() => updateTempConfig('onOffline')} className={`p-3 rounded-lg border-2 transition-all flex flex-col items-center gap-2 ${tempAlertConfig.onOffline ? 'bg-red-500/10 border-red-500 text-red-500' : 'bg-zinc-900 border-zinc-800 text-zinc-500'}`}>
                                <WifiOff className="w-5 h-5" /><span className="text-[10px] font-bold uppercase">Offline</span>
                            </button>
                        </div>
                    </div>
                    <Button onClick={() => addOrUpdateTarget(inspectingPlayer.name, inspectingPlayer.id)} className="mt-4">
                        Update Tracking
                    </Button>
                </div>
            </div>
        )}

        {/* 2. EDITING TARGET SHEET */}
        {editingTarget && (
            <div className="absolute inset-0 z-50 flex items-end justify-center bg-black/80 backdrop-blur-[2px]">
                <div className="absolute inset-0" onClick={() => setEditingTarget(null)} />
                <div className="w-full bg-[#18181b] border-t border-zinc-800 rounded-t-3xl p-6 shadow-2xl relative z-10 animate-in slide-in-from-bottom-full duration-300">
                    <div className="w-12 h-1 bg-zinc-700 rounded-full mx-auto mb-6" />
                    
                    <div className="flex justify-between items-center mb-4">
                        <h2 className="text-2xl font-black text-white leading-tight">{editingTarget.name}</h2>
                        <button 
                            onClick={removeTarget}
                            className="p-2 bg-red-950/20 text-red-500 rounded-lg hover:bg-red-950/40 transition-colors"
                        >
                            <Trash2 className="w-5 h-5" />
                        </button>
                    </div>
                    
                    <div className="bg-zinc-900/50 p-3 rounded-xl border border-zinc-800 mb-4">
                        {editingTarget.isOnline ? (
                            <span className="text-green-500 font-mono text-sm font-bold flex items-center gap-2"><div className="w-2.5 h-2.5 bg-green-500 rounded-full" />Online</span>
                        ) : (
                            <span className="text-red-500 font-mono text-sm font-bold flex items-center gap-2"><div className="w-2.5 h-2.5 bg-red-500 rounded-full" />Offline</span>
                        )}
                    </div>
                    
                    <div className="bg-zinc-900/30 border border-zinc-800 p-4 rounded-xl">
                        <div className="flex items-center gap-2 mb-3">
                            <BellRing className="w-4 h-4 text-orange-500" />
                            <span className="text-xs font-bold uppercase text-zinc-400">Notification Triggers:</span>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                            <button 
                                onClick={() => handleUpdateTargetConfig('onOnline')} 
                                className={`p-3 rounded-lg border-2 transition-all flex flex-col items-center gap-2 
                                    ${editingTarget.alertConfig?.onOnline ? 'bg-green-500/10 border-green-500 text-green-500' : 'bg-zinc-900 border-zinc-800 text-zinc-500'}
                                `}
                            >
                                <Wifi className="w-5 h-5" /><span className="text-[10px] font-bold uppercase">Notify Online</span>
                            </button>
                            <button 
                                onClick={() => handleUpdateTargetConfig('onOffline')} 
                                className={`p-3 rounded-lg border-2 transition-all flex flex-col items-center gap-2 
                                    ${editingTarget.alertConfig?.onOffline ? 'bg-red-500/10 border-red-500 text-red-500' : 'bg-zinc-900 border-zinc-800 text-zinc-500'}
                                `}
                            >
                                <WifiOff className="w-5 h-5" /><span className="text-[10px] font-bold uppercase">Notify Offline</span>
                            </button>
                        </div>
                    </div>

                    <div className="mt-4 pt-4 border-t border-zinc-800">
                            <button 
                            onClick={() => setEditingTarget(null)}
                            className="w-full py-4 bg-orange-600 text-white font-bold uppercase rounded-xl hover:bg-orange-500 transition-colors flex items-center justify-center gap-2 shadow-lg shadow-orange-900/40 active:scale-[0.98]"
                            >
                            <CheckCircle2 className="w-5 h-5" /> Confirm Tracking
                            </button>
                    </div>
                </div>
            </div>
        )}

    </div>
  );
};
