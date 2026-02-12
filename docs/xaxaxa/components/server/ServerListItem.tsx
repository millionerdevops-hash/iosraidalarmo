import React from 'react';
import { Users, Map as MapIcon, Star } from 'lucide-react';
import { ServerData } from '../../types';

interface ServerListItemProps {
    server: ServerData;
    isFavorite: boolean;
    onSelect: (server: ServerData) => void;
    onToggleFavorite: (e: React.MouseEvent, server: ServerData) => void;
}

export const ServerListItem: React.FC<ServerListItemProps> = ({ 
    server, 
    isFavorite, 
    onSelect, 
    onToggleFavorite 
}) => {
    return (
        <button 
            onClick={() => onSelect(server)}
            className="w-full bg-[#121214] hover:bg-[#1c1c1e] border border-zinc-800 p-4 rounded-xl text-left transition-all active:scale-[0.98] group relative"
        >
            <div className="flex justify-between items-start mb-2 pr-8">
                 <h3 className="text-white font-bold text-sm line-clamp-1 group-hover:text-orange-500 transition-colors">
                     {server.name}
                 </h3>
            </div>
            <div className="flex items-center gap-4 text-xs text-zinc-500 font-mono">
                 <span className="flex items-center gap-1.5"><Users className="w-3 h-3" />{server.players}/{server.maxPlayers}</span>
                 {server.map ? (
                    <span className="flex items-center gap-1.5"><MapIcon className="w-3 h-3" />{server.map}</span>
                 ) : (
                    <span className="text-zinc-600">{server.ip}:{server.port}</span>
                 )}
            </div>
            <div 
                onClick={(e) => onToggleFavorite(e, server)}
                className="absolute top-4 right-4 text-zinc-600 hover:text-yellow-500 z-10 p-1"
            >
                <Star className={`w-4 h-4 ${isFavorite ? 'fill-yellow-500 text-yellow-500' : ''}`} />
            </div>
        </button>
    );
};