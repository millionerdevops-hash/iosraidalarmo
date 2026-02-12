
import React, { useState, useEffect } from 'react';
import { TrendingUp, Server, Users, Loader2, AlertTriangle } from 'lucide-react';
import { fetchBattleMetrics } from '../../utils/api';

export const GlobalStatusWidget: React.FC = () => {
  const [stats, setStats] = useState<{ players: number | null; servers: number | null }>({
      players: null,
      servers: null
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    let isMounted = true;

    const fetchGlobalStats = async () => {
      try {
        setError(false);
        // Fetch Rust Game Info (ID: 2)
        const data = await fetchBattleMetrics('/games/2');
        if (isMounted && data && data.data && data.data.attributes) {
            setStats({
                players: data.data.attributes.players,
                servers: data.data.attributes.servers
            });
        }
      } catch (error) {
        console.warn("Global Widget update failed", error);
        if (isMounted) setError(true);
      } finally {
        if (isMounted) setLoading(false);
      }
    };

    fetchGlobalStats();
    
    // Refresh every 60 seconds
    const interval = setInterval(fetchGlobalStats, 60000);
    return () => {
        isMounted = false;
        clearInterval(interval);
    };
  }, []);

  return (
    <div>
        <div className="flex items-center gap-2 mb-3 px-1">
            <TrendingUp className="w-4 h-4 text-orange-500" />
            <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Global Status</span>
        </div>
        <div className="grid grid-cols-2 gap-3">
            {/* Players Card */}
            <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 flex flex-col items-center justify-center gap-1.5 relative overflow-hidden group">
                <div className="absolute inset-0 bg-green-500/5 group-hover:bg-green-500/10 transition-colors" />
                <div className="flex items-center gap-2 text-[10px] text-zinc-500 uppercase font-bold z-10">
                    <Users className="w-3 h-3" /> Players
                </div>
                {loading ? (
                    <Loader2 className="w-5 h-5 text-zinc-600 animate-spin my-0.5" />
                ) : error ? (
                    <span className="text-red-500 font-mono font-bold text-sm z-10">Offline</span>
                ) : (
                    <span className="text-white font-mono font-black text-xl z-10 tracking-tight">
                        {stats.players ? stats.players.toLocaleString() : '---'}
                    </span>
                )}
                <div className="flex items-center gap-1.5 z-10">
                    <div className={`w-1.5 h-1.5 rounded-full ${error ? 'bg-red-500' : 'bg-green-500 animate-pulse shadow-[0_0_8px_#22c55e]'}`} />
                    <span className={`text-[9px] font-bold uppercase ${error ? 'text-red-500' : 'text-green-500'}`}>
                        {error ? 'API Error' : 'Online'}
                    </span>
                </div>
            </div>
            
            {/* Servers Card */}
            <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 flex flex-col items-center justify-center gap-1.5 relative overflow-hidden group">
                <div className="absolute inset-0 bg-blue-500/5 group-hover:bg-blue-500/10 transition-colors" />
                <div className="flex items-center gap-2 text-[10px] text-zinc-500 uppercase font-bold z-10">
                    <Server className="w-3 h-3" /> Servers
                </div>
                {loading ? (
                    <Loader2 className="w-5 h-5 text-zinc-600 animate-spin my-0.5" />
                ) : error ? (
                    <AlertTriangle className="w-5 h-5 text-zinc-700 z-10" />
                ) : (
                    <span className="text-white font-mono font-black text-xl z-10 tracking-tight">
                        {stats.servers ? stats.servers.toLocaleString() : '---'}
                    </span>
                )}
                <div className="flex items-center gap-1.5 z-10">
                    <div className={`w-1.5 h-1.5 rounded-full ${error ? 'bg-zinc-700' : 'bg-blue-500'}`} />
                    <span className={`text-[9px] font-bold uppercase ${error ? 'text-zinc-600' : 'text-blue-500'}`}>
                        Monitored
                    </span>
                </div>
            </div>
        </div>
    </div>
  );
};
