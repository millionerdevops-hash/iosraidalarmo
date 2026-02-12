import React from 'react';
import { User } from 'lucide-react';

export interface PlayerSearchResultItem {
  id: string;
  name: string;
  status: 'online' | 'offline';
  currentServer?: string;
}

interface PlayerListItemProps {
  player: PlayerSearchResultItem;
  onClick: (player: PlayerSearchResultItem) => void;
}

export const PlayerListItem: React.FC<PlayerListItemProps> = ({ player, onClick }) => {
  return (
    <button 
        onClick={() => onClick(player)}
        className="w-full bg-[#121214] hover:bg-[#1c1c1e] border border-zinc-800 p-4 rounded-xl text-left transition-all active:scale-[0.98] group flex items-center gap-4"
    >
        {/* Avatar / Icon */}
        <div className={`w-10 h-10 rounded-full flex items-center justify-center border text-zinc-400 group-hover:text-white relative shrink-0
             ${player.status === 'online' ? 'bg-green-900/10 border-green-500/30' : 'bg-zinc-800 border-zinc-700'}
        `}>
            <User className="w-5 h-5" />
            {/* Status Dot in List */}
            <div className={`absolute bottom-0 right-0 w-3 h-3 rounded-full border-2 border-[#121214] 
                ${player.status === 'online' ? 'bg-green-500' : 'bg-zinc-600'}
            `} />
        </div>
        
        <div className="flex-1 min-w-0">
            <h3 className="text-white font-bold text-sm group-hover:text-purple-400 transition-colors truncate mb-1">
                {player.name}
            </h3>
            <div>
                <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Playing on:</span>
                <span className={`text-xs font-mono block truncate ${player.currentServer ? 'text-zinc-200' : 'text-zinc-600 italic'}`}>
                    {player.currentServer || "Not in a server"}
                </span>
            </div>
        </div>
    </button>
  );
};