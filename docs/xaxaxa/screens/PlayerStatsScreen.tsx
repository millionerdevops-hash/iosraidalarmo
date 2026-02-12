
import React, { useState, useEffect } from 'react';
import { 
  ArrowLeft, 
  Share2,
  Loader2,
  Shield,
  Clock,
  Globe,
  AlertTriangle,
  CheckCircle2,
  Copy,
  ExternalLink,
  Ban,
  Activity,
  Calendar,
  Flame
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { fetchSteamProfile, fetchBattleMetrics } from '../utils/api';

interface PlayerStatsScreenProps {
  onNavigate: (screen: ScreenName) => void;
  playerId: string;
  playerName: string;
}

interface FullSteamData {
    profile: {
        steamid: string;
        personaname: string;
        avatarfull: string;
        communityvisibilitystate: number; // 1=Private, 3=Public
        gameextrainfo?: string;
        timecreated?: number;
        loccountrycode?: string;
        profileurl: string;
        lastlogoff?: number;
    };
    bans: {
        VACBanned: boolean;
        NumberOfVACBans: number;
        DaysSinceLastBan: number;
        CommunityBanned: boolean;
        EconomyBan: string;
    };
    hours_played: number;
    recent_hours: number;
    ids: {
        steamId64: string;
        steamId32: string;
        steamId3: string;
        steamId2: string;
    };
}

export const PlayerStatsScreen: React.FC<PlayerStatsScreenProps> = ({ onNavigate, playerId, playerName }) => {
  const [data, setData] = useState<FullSteamData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  
  // Weekly Chart Data
  const [chartData, setChartData] = useState<{day: string, hours: number}[]>([]);
  const [chartLoading, setChartLoading] = useState(false);

  useEffect(() => {
      const loadData = async () => {
          setLoading(true);
          try {
              // 1. Fetch Steam Profile
              const steamRes = await fetchSteamProfile(playerId);
              setData(steamRes);

              // 2. Fetch Session History for Chart (BattleMetrics)
              // Only fetch if we have a valid steam ID and they aren't private/banned (optional logic, but doing it always here)
              fetchWeeklyChart(playerId);

          } catch (err: any) {
              setError(err.message || "Failed to load Steam profile.");
          } finally {
              setLoading(false);
          }
      };
      loadData();
  }, [playerId]);

  const fetchWeeklyChart = async (steamId: string) => {
      setChartLoading(true);
      try {
          // A. Resolve BattleMetrics Player ID from Steam ID
          const searchRes = await fetchBattleMetrics('/players', `?filter[search]=${steamId}`);
          
          if (searchRes.data && searchRes.data.length > 0) {
              const bmId = searchRes.data[0].id;
              
              // B. Fetch Sessions
              // Get last 50 sessions to cover a week potentially
              const sessionsRes = await fetchBattleMetrics('/sessions', `?filter[player]=${bmId}&page[size]=50&sort=-start`);
              
              if (sessionsRes.data) {
                  processSessionsIntoChart(sessionsRes.data);
              }
          }
      } catch (e) {
          console.warn("Could not fetch session chart", e);
      } finally {
          setChartLoading(false);
      }
  };

  const processSessionsIntoChart = (sessions: any[]) => {
      const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      const now = new Date();
      // Initialize last 7 days buckets
      const buckets: Record<string, number> = {};
      
      // Setup last 7 days keys
      for (let i = 6; i >= 0; i--) {
          const d = new Date();
          d.setDate(now.getDate() - i);
          const key = days[d.getDay()];
          buckets[key] = 0; // Init 0
      }

      sessions.forEach((session: any) => {
          const start = new Date(session.attributes.start);
          const stop = session.attributes.stop ? new Date(session.attributes.stop) : new Date();
          
          // Check if session is within last 7 days
          const diffDays = (now.getTime() - start.getTime()) / (1000 * 3600 * 24);
          
          if (diffDays <= 7) {
              const dayName = days[start.getDay()];
              
              // Duration in hours
              let durationHours = (stop.getTime() - start.getTime()) / (1000 * 3600);
              // Cap weird long sessions (e.g. AFK 24h+) to 24 for visual sanity
              durationHours = Math.min(durationHours, 24);
              
              if (buckets[dayName] !== undefined) {
                  buckets[dayName] += durationHours;
              }
          }
      });

      // Convert to array
      const result = Object.entries(buckets).map(([day, hours]) => ({
          day, 
          hours: Math.round(hours * 10) / 10
      }));
      
      // Reorder to match current day at end? 
      // The Object.entries might not preserve order. Let's strictly order by last 7 days index.
      const orderedResult = [];
      for (let i = 6; i >= 0; i--) {
          const d = new Date();
          d.setDate(now.getDate() - i);
          const dayName = days[d.getDay()];
          const val = buckets[dayName] || 0;
          orderedResult.push({ day: dayName, hours: Math.round(val * 10) / 10 });
      }

      setChartData(orderedResult);
  };

  const copyToClipboard = (text: string) => {
      navigator.clipboard.writeText(text);
  };

  const StatusRow = ({ label, value, isLink = false, copy = false }: any) => (
      <div className="flex items-center justify-between py-2.5 border-b border-zinc-800 last:border-0">
          <span className="text-zinc-500 text-xs font-bold uppercase tracking-wider">{label}</span>
          <div className="flex items-center gap-2 max-w-[60%]">
              {isLink ? (
                  <a href={value} target="_blank" rel="noopener noreferrer" className="text-blue-400 text-xs truncate hover:underline flex items-center gap-1">
                      Link <ExternalLink className="w-3 h-3" />
                  </a>
              ) : (
                  <span className="text-zinc-300 text-xs font-mono truncate select-all">{value}</span>
              )}
              {copy && (
                  <button onClick={() => copyToClipboard(value)} className="text-zinc-600 hover:text-white transition-colors">
                      <Copy className="w-3 h-3" />
                  </button>
              )}
          </div>
      </div>
  );

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative font-sans">
      
      {/* Header */}
      <div className="p-4 pt-6 flex items-center justify-between z-10 shrink-0 bg-[#0c0c0e] border-b border-zinc-800">
        <button 
            onClick={() => onNavigate('COMBAT_SEARCH')}
            className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
        >
            <ArrowLeft className="w-5 h-5" />
        </button>
        <div className="text-center">
            <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont} tracking-tight`}>Steam Dossier</h2>
            <p className="text-zinc-600 text-[10px] font-black uppercase tracking-widest">ID: {playerId}</p>
        </div>
        <button className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
            <Share2 className="w-4 h-4" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 space-y-4">
          
          {loading ? (
              <div className="flex flex-col items-center justify-center py-20 opacity-50">
                  <Loader2 className="w-8 h-8 text-[#66c0f4] animate-spin mb-4" />
                  <span className="text-xs font-mono text-zinc-500 uppercase tracking-widest">Decyphering Steam Data...</span>
              </div>
          ) : error ? (
              <div className="p-4 bg-red-900/20 border border-red-900 rounded-xl text-center">
                  <AlertTriangle className="w-8 h-8 text-red-500 mx-auto mb-2" />
                  <p className="text-red-400 text-sm">{error}</p>
              </div>
          ) : data ? (
              <>
                {/* 1. Main Profile Card */}
                <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 relative overflow-hidden">
                    <div className="flex gap-4">
                        {/* Avatar */}
                        <div className="w-20 h-20 bg-zinc-900 rounded-lg shrink-0 overflow-hidden border border-zinc-700 shadow-xl relative">
                            <img src={data.profile.avatarfull} alt="Avatar" className="w-full h-full object-cover" />
                            {data.bans.VACBanned && (
                                <div className="absolute inset-0 bg-red-900/50 flex items-center justify-center backdrop-blur-[1px]">
                                    <Ban className="w-8 h-8 text-red-500 rotate-12" />
                                </div>
                            )}
                        </div>
                        
                        {/* Info */}
                        <div className="flex-1 min-w-0">
                            <h2 className="text-xl font-bold text-white truncate mb-1">{data.profile.personaname}</h2>
                            
                            <div className="space-y-1">
                                <div className="flex items-center gap-2 text-xs text-zinc-400">
                                    <Globe className="w-3 h-3" />
                                    <span>{data.profile.loccountrycode || 'Unknown Region'}</span>
                                </div>
                                <div className="flex items-center gap-2 text-xs text-zinc-400">
                                    <Clock className="w-3 h-3" />
                                    <span>Created: {data.profile.timecreated ? new Date(data.profile.timecreated * 1000).toLocaleDateString() : 'Hidden'}</span>
                                </div>
                                <div className={`inline-flex items-center gap-1.5 px-2 py-0.5 rounded text-[10px] font-bold uppercase mt-1
                                    ${data.profile.gameextrainfo ? 'bg-green-900/30 text-green-400 border border-green-500/30' : 
                                      data.profile.communityvisibilitystate !== 3 ? 'bg-red-900/30 text-red-400 border border-red-500/30' :
                                      'bg-zinc-800 text-zinc-400'}
                                `}>
                                    {data.profile.gameextrainfo 
                                        ? `Playing ${data.profile.gameextrainfo}`
                                        : (data.profile.communityvisibilitystate !== 3 ? 'Private Profile' : 'Online / Idle')}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* 2. PLAYTIME STATS (Steam) */}
                <div className="grid grid-cols-2 gap-3">
                    <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 flex flex-col justify-center">
                        <span className="text-[10px] font-bold text-zinc-500 uppercase flex items-center gap-1 mb-1">
                            <Clock className="w-3 h-3" /> Total Hours
                        </span>
                        <span className="text-2xl font-black text-white font-mono tracking-tight">
                            {data.hours_played > 0 ? data.hours_played.toLocaleString() : '---'}
                        </span>
                    </div>
                    <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 flex flex-col justify-center relative overflow-hidden">
                        {data.recent_hours > 40 && (
                            <div className="absolute top-0 right-0 p-2 opacity-20">
                                <Flame className="w-8 h-8 text-orange-500" />
                            </div>
                        )}
                        <span className="text-[10px] font-bold text-orange-500 uppercase flex items-center gap-1 mb-1">
                            <Activity className="w-3 h-3" /> Last 2 Weeks
                        </span>
                        <span className="text-2xl font-black text-orange-400 font-mono tracking-tight">
                            {data.recent_hours > 0 ? `${data.recent_hours}h` : '0h'}
                        </span>
                    </div>
                </div>

                {/* 3. WEEKLY ACTIVITY CHART (BattleMetrics) */}
                {data.profile.communityvisibilitystate === 3 && (
                    <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4">
                        <div className="flex items-center justify-between mb-4">
                            <div className="flex items-center gap-2">
                                <Calendar className="w-4 h-4 text-zinc-400" />
                                <span className="text-xs font-bold text-zinc-300 uppercase">Daily Activity (7 Days)</span>
                            </div>
                            {chartLoading && <Loader2 className="w-3 h-3 animate-spin text-zinc-600" />}
                        </div>

                        {chartData.length > 0 ? (
                            <div className="flex items-end justify-between h-24 gap-2">
                                {chartData.map((d, i) => {
                                    const maxH = Math.max(...chartData.map(c => c.hours), 1);
                                    const hPercent = (d.hours / maxH) * 100;
                                    const intensityColor = d.hours > 8 ? 'bg-red-500' : d.hours > 4 ? 'bg-orange-500' : 'bg-zinc-700';
                                    
                                    return (
                                        <div key={i} className="flex-1 flex flex-col items-center justify-end h-full gap-2 group">
                                            <div className="w-full bg-zinc-900 rounded-t-sm relative flex items-end h-full">
                                                <div 
                                                    className={`w-full rounded-t-sm transition-all duration-500 ${intensityColor}`} 
                                                    style={{ height: `${Math.max(5, hPercent)}%` }}
                                                />
                                                {/* Tooltip */}
                                                <div className="absolute -top-8 left-1/2 -translate-x-1/2 bg-zinc-800 text-white text-[10px] font-bold px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-10 border border-zinc-700">
                                                    {d.hours}h
                                                </div>
                                            </div>
                                            <span className="text-[9px] font-bold text-zinc-500 uppercase">{d.day}</span>
                                        </div>
                                    );
                                })}
                            </div>
                        ) : (
                            <div className="h-20 flex items-center justify-center text-[10px] text-zinc-600 italic border border-dashed border-zinc-800 rounded-lg">
                                {chartLoading ? 'Analyzing session data...' : 'No public session data available.'}
                            </div>
                        )}
                    </div>
                )}

                {/* 4. Ban Status Panel */}
                <div className="bg-[#121214] border border-zinc-800 rounded-xl overflow-hidden">
                    <div className="px-4 py-2 bg-zinc-900 border-b border-zinc-800 flex items-center justify-between">
                        <span className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest">Trust Status</span>
                        <Shield className="w-3 h-3 text-zinc-600" />
                    </div>
                    <div className="p-4 grid grid-cols-3 gap-2 text-center">
                        <div className={`p-2 rounded-lg border flex flex-col items-center justify-center gap-1
                            ${data.bans.VACBanned ? 'bg-red-900/20 border-red-500/50 text-red-500' : 'bg-green-900/10 border-green-900/30 text-green-500'}
                        `}>
                            {data.bans.VACBanned ? <Ban className="w-4 h-4" /> : <CheckCircle2 className="w-4 h-4" />}
                            <span className="text-[9px] font-bold uppercase">VAC</span>
                        </div>
                        <div className={`p-2 rounded-lg border flex flex-col items-center justify-center gap-1
                            ${data.bans.CommunityBanned ? 'bg-red-900/20 border-red-500/50 text-red-500' : 'bg-green-900/10 border-green-900/30 text-green-500'}
                        `}>
                            {data.bans.CommunityBanned ? <Ban className="w-4 h-4" /> : <CheckCircle2 className="w-4 h-4" />}
                            <span className="text-[9px] font-bold uppercase">Community</span>
                        </div>
                        <div className={`p-2 rounded-lg border flex flex-col items-center justify-center gap-1
                            ${data.bans.EconomyBan !== 'none' ? 'bg-red-900/20 border-red-500/50 text-red-500' : 'bg-green-900/10 border-green-900/30 text-green-500'}
                        `}>
                            {data.bans.EconomyBan !== 'none' ? <Ban className="w-4 h-4" /> : <CheckCircle2 className="w-4 h-4" />}
                            <span className="text-[9px] font-bold uppercase">Trade</span>
                        </div>
                    </div>
                    {data.bans.NumberOfVACBans > 0 && (
                        <div className="px-4 pb-3 text-center">
                            <p className="text-[10px] text-red-400 font-mono bg-red-950/20 py-1 rounded">
                                {data.bans.NumberOfVACBans} VAC Bans. Last ban: {data.bans.DaysSinceLastBan} days ago.
                            </p>
                        </div>
                    )}
                </div>

                {/* 5. ID Table */}
                <div className="bg-[#121214] border border-zinc-800 rounded-xl overflow-hidden mb-8">
                    <div className="px-4 py-2 bg-zinc-900 border-b border-zinc-800">
                        <span className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest">ID Configuration</span>
                    </div>
                    <div className="p-4 space-y-1">
                        <StatusRow label="Steam ID" value={data.ids.steamId2} copy />
                        <StatusRow label="Steam 64" value={data.ids.steamId64} copy />
                        <StatusRow label="Profile URL" value={data.profile.profileurl} isLink />
                    </div>
                </div>

              </>
          ) : null}

      </div>
    </div>
  );
};
