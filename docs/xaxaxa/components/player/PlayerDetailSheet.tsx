
import React, { useState, useEffect } from 'react';
import { 
  User, 
  Loader2, 
  Map as MapIcon, 
  Clock, 
  ShieldAlert,
  Fingerprint,
  Copy,
  Lock,
  Activity,
  BarChart3,
  Moon,
  Sun,
  AlertOctagon,
  CheckCircle2,
  Globe,
  History,
  Server,
  Crosshair
} from 'lucide-react';
import { Button } from '../Button';
import { fetchBattleMetrics } from '../../utils/api';

interface PlayerDetailData {
  id: string;
  name: string;
  private: boolean;
  firstSeen: string;
  currentServer?: string;
  status: 'online' | 'offline';
  country?: string;
}

interface PlayerDetailSheetProps {
  player: PlayerDetailData;
  loading: boolean;
  onClose: () => void;
  onTrack: (name: string, id: string) => void;
  isFreeUser: boolean; 
  onPaywall: () => void;
  onViewStats?: (id: string, name: string) => void; // New optional prop
}

// Format for session log item
interface SessionLogItem {
    id: string;
    serverName: string;
    action: 'Playing' | 'Left' | 'Joined';
    timeStr: string;
    duration?: string;
    timestamp: number;
}

interface RealIntelData {
    activityData: number[];
    peakHour: number;
    banCount: number;
    trustScore: number;
    sleepStart: number;
    sleepEnd: number;
    sessionLogs: SessionLogItem[];
    loaded: boolean;
    error?: string;
}

export const PlayerDetailSheet: React.FC<PlayerDetailSheetProps> = ({ 
  player, 
  loading, 
  onClose,
  onTrack,
  isFreeUser,
  onPaywall,
  onViewStats
}) => {
  const [activeTab, setActiveTab] = useState<'STATUS' | 'INTEL'>('STATUS');
  
  const [intel, setIntel] = useState<RealIntelData>({
      activityData: Array(24).fill(0),
      peakHour: 0,
      banCount: 0,
      trustScore: 100,
      sleepStart: 0,
      sleepEnd: 0,
      sessionLogs: [],
      loaded: false
  });

  useEffect(() => {
      if (activeTab === 'INTEL' && !intel.loaded && !isFreeUser) {
          fetchRealData();
      }
  }, [activeTab, isFreeUser]);

  const fetchRealData = async () => {
      try {
          const bansReq = fetchBattleMetrics('/bans', `?filter[player]=${player.id}&page[size]=10`);
          const sessionsReq = fetchBattleMetrics('/sessions', `?filter[player]=${player.id}&include=server&page[size]=15&sort=-start`);

          const [bansRes, sessionsRes] = await Promise.all([bansReq, sessionsReq]);

          const banCount = bansRes.meta?.total || bansRes.data?.length || 0;
          
          // --- PROCESS SESSIONS & ACTIVITY ---
          const activityBuckets = Array(24).fill(0);
          const sessions = sessionsRes.data || [];
          const servers = sessionsRes.included || [];
          
          const logs: SessionLogItem[] = [];

          if (sessions.length > 0) {
              sessions.forEach((session: any) => {
                  const start = new Date(session.attributes.start);
                  const stop = session.attributes.stop ? new Date(session.attributes.stop) : null;
                  
                  // Heatmap Logic
                  let currentHour = start.getHours();
                  let durationMs = (stop ? stop.getTime() : new Date().getTime()) - start.getTime();
                  let durationHours = durationMs / (1000 * 60 * 60);
                  
                  const loopLimit = Math.min(Math.ceil(durationHours), 12);
                  for(let i=0; i < loopLimit; i++) {
                      const hourIndex = (currentHour + i) % 24;
                      activityBuckets[hourIndex] += 1;
                  }

                  // Log List Logic
                  const serverObj = servers.find((s: any) => s.id === session.relationships.server.data.id);
                  const serverName = serverObj ? serverObj.attributes.name : 'Unknown Server';
                  
                  // Formatter for duration
                  const h = Math.floor(durationMs / 3600000);
                  const m = Math.floor((durationMs % 3600000) / 60000);
                  const durStr = h > 0 ? `${h}h ${m}m` : `${m}m`;

                  if (!stop) {
                      logs.push({
                          id: session.id,
                          serverName,
                          action: 'Playing',
                          timeStr: 'Currently Online',
                          duration: durStr,
                          timestamp: start.getTime()
                      });
                  } else {
                      logs.push({
                          id: session.id,
                          serverName,
                          action: 'Left',
                          timeStr: stop.toLocaleDateString(undefined, {month:'short', day:'numeric', hour:'2-digit', minute:'2-digit'}),
                          duration: durStr,
                          timestamp: stop.getTime()
                      });
                  }
              });
          }

          // Sort logs newest first
          logs.sort((a, b) => b.timestamp - a.timestamp);

          const maxVal = Math.max(...activityBuckets, 1);
          const normalizedActivity = activityBuckets.map(v => Math.round((v / maxVal) * 100));
          const peakHour = normalizedActivity.indexOf(Math.max(...normalizedActivity));

          let minSum = Infinity;
          let sleepStart = 0;
          for(let i=0; i<24; i++) {
              let sum = 0;
              for(let j=0; j<8; j++) sum += normalizedActivity[(i+j)%24];
              if(sum < minSum) {
                  minSum = sum;
                  sleepStart = i;
              }
          }
          const sleepEnd = (sleepStart + 8) % 24;

          let score = 100 - (banCount * 25);
          if (player.private) score -= 10;
          score = Math.max(0, score);

          setIntel({
              activityData: normalizedActivity,
              peakHour,
              banCount,
              trustScore: score,
              sleepStart,
              sleepEnd,
              sessionLogs: logs,
              loaded: true
          });

      } catch (err) {
          console.error("Intel fetch error", err);
          setIntel(prev => ({ ...prev, error: "Could not fetch detailed intel." }));
      }
  };

  const formatDate = (dateString: string) => {
     try {
         return new Date(dateString).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
     } catch { return 'Unknown'; }
  };

  const handleTabChange = (tab: 'STATUS' | 'INTEL') => {
      setActiveTab(tab);
  };

  return (
      <div className="absolute inset-0 z-50 flex items-end justify-center">
          <div 
            className="absolute inset-0 bg-black/80 backdrop-blur-[2px] animate-in fade-in duration-300"
            onClick={onClose}
          />
          
          <div className="w-full bg-[#0c0c0e] border-t border-zinc-800 rounded-t-[32px] shadow-2xl relative z-10 animate-in slide-in-from-bottom duration-300 max-h-[90vh] flex flex-col">
              <div className="pt-4 pb-2 flex justify-center shrink-0" onClick={onClose}>
                  <div className="w-12 h-1.5 bg-zinc-800 rounded-full" />
              </div>

              <div className="overflow-y-auto no-scrollbar p-6 pt-2">
                  <div className="flex justify-between items-start mb-6">
                      <div>
                          <h2 className="text-3xl text-white font-black uppercase tracking-tight leading-none mb-2 line-clamp-1 break-all">
                              {player.name}
                          </h2>
                          <div className="flex items-center gap-3">
                              <div className="flex items-center gap-1.5 bg-zinc-900 border border-zinc-800 px-2 py-1 rounded text-zinc-500 cursor-pointer active:text-white transition-colors" onClick={() => navigator.clipboard.writeText(player.id)}>
                                  <Fingerprint className="w-3 h-3" />
                                  <span className="text-[10px] font-mono">{player.id}</span>
                                  <Copy className="w-2.5 h-2.5 ml-1 opacity-50" />
                              </div>
                              {player.private && (
                                  <span className="text-[9px] bg-red-950/30 text-red-500 border border-red-900/50 px-2 py-1 rounded uppercase font-bold">Private Profile</span>
                              )}
                          </div>
                      </div>

                      <div className={`w-14 h-14 rounded-2xl flex items-center justify-center border-2 shadow-[0_0_30px_rgba(0,0,0,0.5)]
                          ${player.status === 'online' ? 'border-green-500 bg-green-500/10 text-green-500' : 'border-zinc-800 bg-zinc-900 text-zinc-600'}
                      `}>
                          <User className="w-7 h-7" />
                      </div>
                  </div>

                  <div className="flex bg-zinc-900 p-1 rounded-xl mb-6 border border-zinc-800">
                      <button 
                        onClick={() => handleTabChange('STATUS')}
                        className={`flex-1 py-2.5 rounded-lg text-xs font-bold uppercase transition-all flex items-center justify-center gap-2
                            ${activeTab === 'STATUS' ? 'bg-[#0c0c0e] text-white shadow-lg border border-zinc-700' : 'text-zinc-500 hover:text-zinc-300'}
                        `}
                      >
                          <Activity className="w-4 h-4" /> Status
                      </button>
                      <button 
                        onClick={() => handleTabChange('INTEL')}
                        className={`flex-1 py-2.5 rounded-lg text-xs font-bold uppercase transition-all flex items-center justify-center gap-2 relative
                            ${activeTab === 'INTEL' ? 'bg-red-900/20 text-red-200 shadow-lg border border-red-900/50' : 'text-zinc-500 hover:text-zinc-300'}
                        `}
                      >
                          {isFreeUser && <Lock className="w-3 h-3 absolute left-3 text-red-500" />}
                          Intelligence
                      </button>
                  </div>

                  {activeTab === 'STATUS' && (
                      <div className="animate-in fade-in slide-in-from-right-4 duration-300 space-y-3">
                            <div className={`rounded-2xl p-5 border flex items-center justify-between
                                ${player.status === 'online' 
                                    ? 'bg-green-950/10 border-green-500/30' 
                                    : 'bg-zinc-900/30 border-zinc-800'}
                            `}>
                                <div>
                                    <span className="text-[10px] font-bold uppercase text-zinc-500 tracking-wider mb-1 block">Current State</span>
                                    <div className={`text-2xl font-black tracking-tight ${player.status === 'online' ? 'text-green-500' : 'text-zinc-400'}`}>
                                        {player.status === 'online' ? 'ONLINE' : 'OFFLINE'}
                                    </div>
                                </div>
                                {player.status === 'online' && (
                                    <div className="relative">
                                        <div className="w-4 h-4 bg-green-500 rounded-full animate-ping absolute inset-0 opacity-75" />
                                        <div className="w-4 h-4 bg-green-500 rounded-full shadow-[0_0_15px_#22c55e]" />
                                    </div>
                                )}
                            </div>
                            
                            <div className="bg-[#121214] rounded-2xl p-4 border border-zinc-800">
                                <div className="flex items-center gap-2 mb-3 text-zinc-500">
                                    <Globe className="w-4 h-4" />
                                    <span className="text-xs font-bold uppercase">Active Server</span>
                                </div>
                                {loading ? (
                                    <div className="flex items-center gap-2 text-zinc-500 text-sm">
                                        <Loader2 className="w-4 h-4 animate-spin" /> Fetching server info...
                                    </div>
                                ) : (
                                    <div className="text-white font-medium text-sm leading-relaxed">
                                        {player.currentServer || "Not currently in a monitored server."}
                                    </div>
                                )}
                            </div>

                            <div className="grid grid-cols-2 gap-3">
                                <div className="bg-[#121214] rounded-2xl p-4 border border-zinc-800">
                                    <span className="text-[10px] font-bold uppercase text-zinc-500 block mb-1">First Seen</span>
                                    <span className="text-white font-mono text-sm">{formatDate(player.firstSeen)}</span>
                                </div>
                                <div className="bg-[#121214] rounded-2xl p-4 border border-zinc-800">
                                    <span className="text-[10px] font-bold uppercase text-zinc-500 block mb-1">Region</span>
                                    <span className="text-white font-mono text-sm">{player.country || "Global"}</span>
                                </div>
                            </div>

                            {/* Combat Record Link */}
                            {onViewStats && (
                                <button 
                                    onClick={() => onViewStats(player.id, player.name)}
                                    className="w-full bg-zinc-900 border border-zinc-800 hover:border-orange-500/50 p-4 rounded-2xl flex items-center justify-between group transition-all"
                                >
                                    <div className="flex items-center gap-3">
                                        <div className="w-10 h-10 rounded-lg bg-black flex items-center justify-center border border-zinc-800 text-orange-500">
                                            <Crosshair className="w-5 h-5" />
                                        </div>
                                        <div className="text-left">
                                            <div className="text-white font-bold text-sm">Combat Record</div>
                                            <div className="text-zinc-500 text-[10px]">K/D, Weapon Stats, Hit Zones</div>
                                        </div>
                                    </div>
                                    <div className="bg-zinc-800 text-zinc-400 px-2 py-1 rounded text-[9px] font-bold uppercase group-hover:bg-orange-500 group-hover:text-black transition-colors">
                                        View
                                    </div>
                                </button>
                            )}
                      </div>
                  )}

                  {activeTab === 'INTEL' && (
                      <div className="animate-in fade-in slide-in-from-right-4 duration-300 relative">
                            {isFreeUser && (
                                <div className="absolute inset-0 z-20 backdrop-blur-sm bg-black/60 flex flex-col items-center justify-center rounded-2xl border border-white/5 text-center p-6 animate-in fade-in duration-500">
                                    <div className="w-16 h-16 bg-red-900/20 rounded-full flex items-center justify-center border border-red-500/30 mb-4 shadow-[0_0_30px_rgba(220,38,38,0.2)]">
                                        <Lock className="w-8 h-8 text-red-500" />
                                    </div>
                                    <h3 className="text-white font-black text-xl uppercase mb-2">Classified Intel</h3>
                                    <p className="text-zinc-400 text-xs mb-6 max-w-[200px] leading-relaxed">
                                        Upgrade to view sleep patterns, ban history, and risk analysis.
                                    </p>
                                    <button onClick={onPaywall} className="w-full py-3 bg-red-600 text-white font-bold uppercase text-xs rounded-xl hover:bg-red-500 shadow-lg shadow-red-900/40 active:scale-95 transition-all">
                                        Unlock Full Dossier
                                    </button>
                                </div>
                            )}

                            <div className={`${isFreeUser ? 'opacity-20 pointer-events-none grayscale blur-sm' : ''} space-y-4`}>
                                {!intel.loaded && !isFreeUser && (
                                    <div className="py-12 flex flex-col items-center justify-center text-zinc-500">
                                        <Loader2 className="w-8 h-8 animate-spin mb-2 text-orange-500" />
                                        <span className="text-xs uppercase tracking-widest font-mono">Analyzing BattleMetrics Data...</span>
                                    </div>
                                )}

                                {intel.error && (
                                    <div className="bg-red-950/20 border border-red-900/30 rounded-xl p-4 text-center text-red-400 text-xs">{intel.error}</div>
                                )}

                                {intel.loaded && (
                                    <>
                                        <div className={`rounded-2xl p-4 border flex items-center justify-between relative overflow-hidden ${intel.banCount > 0 ? 'bg-red-950/20 border-red-500/30' : 'bg-green-950/20 border-green-500/30'}`}>
                                            <div className="relative z-10">
                                                <div className="flex items-center gap-2 mb-1">
                                                    {intel.banCount > 0 ? <AlertOctagon className="w-4 h-4 text-red-500" /> : <CheckCircle2 className="w-4 h-4 text-green-500" />}
                                                    <span className={`text-xs font-bold uppercase ${intel.banCount > 0 ? 'text-red-400' : 'text-green-400'}`}>
                                                        {intel.banCount > 0 ? 'High Risk Target' : 'Clean Record'}
                                                    </span>
                                                </div>
                                                <div className="text-[10px] text-zinc-400 font-mono">
                                                    {intel.banCount > 0 ? `${intel.banCount} previous game bans found.` : 'No active BattleMetrics bans.'}
                                                </div>
                                            </div>
                                            <div className="text-right relative z-10">
                                                <span className={`text-3xl font-black ${intel.trustScore < 50 ? 'text-red-500' : 'text-white'}`}>{intel.trustScore}</span>
                                                <div className="text-[9px] text-zinc-500 uppercase font-bold">Trust Score</div>
                                            </div>
                                        </div>

                                        <div className="bg-[#121214] rounded-2xl p-5 border border-zinc-800">
                                            <div className="flex items-center justify-between mb-4">
                                                <div className="flex items-center gap-2 text-zinc-300">
                                                    <BarChart3 className="w-4 h-4 text-orange-500" />
                                                    <span className="text-xs font-bold uppercase">24h Activity</span>
                                                </div>
                                            </div>
                                            <div className="flex items-end h-16 gap-1 mb-2">
                                                {intel.activityData.map((val, idx) => (
                                                    <div key={idx} className="flex-1 flex flex-col justify-end h-full">
                                                        <div className={`w-full rounded-t-sm min-h-[2px] ${val > 60 ? 'bg-red-600' : val > 30 ? 'bg-orange-600/60' : 'bg-zinc-800'}`} style={{ height: `${val}%` }} />
                                                    </div>
                                                ))}
                                            </div>
                                            <div className="flex justify-between text-[9px] text-zinc-600 font-mono border-t border-zinc-800 pt-2">
                                                <span>00:00</span><span>12:00</span><span>23:00</span>
                                            </div>
                                        </div>

                                        {/* SESSION HISTORY LIST */}
                                        <div className="bg-[#121214] rounded-2xl border border-zinc-800 overflow-hidden">
                                            <div className="p-4 border-b border-zinc-800 bg-black/20 flex items-center gap-2">
                                                <History className="w-4 h-4 text-blue-500" />
                                                <span className="text-xs font-bold text-white uppercase">Session Log</span>
                                            </div>
                                            <div className="divide-y divide-zinc-800/50">
                                                {intel.sessionLogs.length === 0 ? (
                                                    <div className="p-4 text-center text-[10px] text-zinc-500">No recent history found.</div>
                                                ) : (
                                                    intel.sessionLogs.map((log) => (
                                                        <div key={log.id} className="p-3 flex items-center justify-between hover:bg-zinc-900/30 transition-colors">
                                                            <div className="flex flex-col gap-1 min-w-0 flex-1 pr-4">
                                                                <div className="flex items-center gap-2">
                                                                    <div className={`w-1.5 h-1.5 rounded-full ${log.action === 'Playing' ? 'bg-green-500 animate-pulse' : 'bg-zinc-600'}`} />
                                                                    <span className={`text-[10px] font-bold uppercase ${log.action === 'Playing' ? 'text-green-500' : 'text-zinc-400'}`}>
                                                                        {log.action}
                                                                    </span>
                                                                    <span className="text-[10px] text-zinc-500 font-mono truncate">{log.timeStr}</span>
                                                                </div>
                                                                <div className="text-xs text-white font-medium truncate flex items-center gap-1.5">
                                                                    <Server className="w-3 h-3 text-zinc-600" />
                                                                    {log.serverName}
                                                                </div>
                                                            </div>
                                                            <div className="text-right shrink-0">
                                                                <span className="text-[10px] font-mono font-bold text-zinc-300 bg-zinc-800 px-1.5 py-0.5 rounded border border-zinc-700">
                                                                    {log.duration}
                                                                </span>
                                                            </div>
                                                        </div>
                                                    ))
                                                )}
                                            </div>
                                        </div>
                                    </>
                                )}
                            </div>
                      </div>
                  )}
                  
                  {activeTab === 'STATUS' && (
                    <div className="mt-6 pt-4 border-t border-zinc-800">
                        <Button onClick={() => onTrack(player.name, player.id)} className="w-full shadow-lg">
                            TRACK THIS TARGET
                        </Button>
                        <p className="text-center text-[10px] text-zinc-500 mt-3">
                            You will receive notifications when status changes.
                        </p>
                    </div>
                  )}
              </div>
          </div>
      </div>
  );
};
