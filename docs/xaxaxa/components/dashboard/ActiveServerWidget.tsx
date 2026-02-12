import React, { useState, useEffect } from 'react';
import { Timer, Users, Map as MapIcon, Cpu, Wifi } from 'lucide-react';
import { ServerData, ScreenName } from '../../types';

interface ActiveServerWidgetProps {
  server: ServerData | null;
  onNavigate: (screen: ScreenName) => void;
}

export const ActiveServerWidget: React.FC<ActiveServerWidgetProps> = ({ server, onNavigate }) => {
  // We need a local state to trigger re-renders for the countdown timer
  const [, setNow] = useState(Date.now());

  useEffect(() => {
    // Update every minute to keep the wipe countdown fresh
    const interval = setInterval(() => setNow(Date.now()), 60000);
    return () => clearInterval(interval);
  }, []);

  const formatWipeCountdown = (isoDate?: string) => {
    if (!isoDate) return "Unknown";
    const diffMs = new Date(isoDate).getTime() - new Date().getTime();
    if (diffMs < 0) return "Wiped";
    const days = Math.floor(diffMs / (86400000));
    const hours = Math.floor((diffMs % 86400000) / 3600000);
    const mins = Math.floor((diffMs % 3600000) / 60000);
    if (days > 0) return `${days}d ${hours}h`;
    return `${hours}h ${mins}m`;
  };

  if (!server) {
    return (
        <button 
            onClick={() => onNavigate('SERVER_SEARCH')}
            className="w-full bg-zinc-900/30 border border-dashed border-zinc-800 rounded-2xl p-8 flex flex-col items-center justify-center gap-3 text-zinc-500 hover:text-zinc-300 hover:border-zinc-700 transition-all group"
        >
            <Wifi className="w-8 h-8 group-hover:text-green-500 transition-colors" />
            <span className="text-xs font-bold uppercase tracking-wide">Select Active Server</span>
        </button>
    );
  }

  return (
    <button 
      onClick={() => onNavigate('SERVER_DETAIL')}
      className="w-full relative overflow-hidden bg-[#121214] border border-zinc-800 rounded-2xl p-4 flex flex-col justify-between h-40 group active:scale-[0.99] transition-all"
    >
      {server.headerImage && (
          <div className="absolute inset-0 bg-cover bg-center opacity-30 pointer-events-none transition-opacity group-hover:opacity-40" style={{ backgroundImage: `url(${server.headerImage})` }} />
      )}
      <div className="absolute inset-0 bg-gradient-to-t from-zinc-950 via-zinc-950/50 to-transparent pointer-events-none" />

      <div className="relative z-10 flex justify-between items-start">
          <div className="bg-black/60 backdrop-blur px-2 py-1 rounded border border-white/10 flex items-center gap-1.5">
             <div className={`w-2 h-2 rounded-full ${server.status === 'online' ? 'bg-green-500 shadow-[0_0_8px_#22c55e]' : 'bg-red-500'}`} />
             <span className="text-[10px] font-bold text-white uppercase">{server.status}</span>
          </div>
          {server.nextWipe && (
              <div className="bg-orange-900/80 backdrop-blur px-2 py-1 rounded border border-orange-500/30 text-orange-400 text-[10px] font-bold uppercase flex items-center gap-1">
                  <Timer className="w-3 h-3" /> {formatWipeCountdown(server.nextWipe)}
              </div>
          )}
      </div>

      <div className="relative z-10 text-left">
          <h3 className="text-lg font-black text-white uppercase tracking-wide leading-tight drop-shadow-md line-clamp-1">
              {server.name}
          </h3>
          <div className="flex items-center gap-4 mt-2 text-zinc-300 text-xs font-mono">
              <span className="flex items-center gap-1.5"><Users className="w-3 h-3" /> {server.players}/{server.maxPlayers}</span>
              <span className="flex items-center gap-1.5"><MapIcon className="w-3 h-3" /> {server.map}</span>
              <span className="flex items-center gap-1.5"><Cpu className="w-3 h-3" /> {server.fps} FPS</span>
          </div>
      </div>
    </button>
  );
};