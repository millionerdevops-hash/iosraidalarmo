import React from 'react';
import { ArrowLeft, Star, Globe } from 'lucide-react';
import { ServerData, ScreenName } from '../../../types';

interface ServerHeaderProps {
    server: ServerData;
    isFavorite: boolean;
    onToggleFavorite: (e: React.MouseEvent) => void;
    onNavigate: (screen: ScreenName) => void;
}

export const ServerHeader: React.FC<ServerHeaderProps> = ({ 
    server, 
    isFavorite, 
    onToggleFavorite, 
    onNavigate 
}) => {
    const isOnline = server.status === 'online';

    return (
        <div className="relative border-b border-zinc-800 bg-[#121214] min-h-[160px] flex flex-col justify-end">
            {/* Background */}
            {server.headerImage ? (
                <>
                    <div className="absolute inset-0 bg-cover bg-center opacity-40 blur-[2px]" style={{ backgroundImage: `url(${server.headerImage})` }} />
                    <div className="absolute inset-0 bg-gradient-to-t from-[#121214] via-[#121214]/80 to-black/60" />
                </>
            ) : (
                <div className="absolute inset-0 bg-gradient-to-b from-black/50 to-[#121214]" />
            )}

            {/* Nav & Favorite */}
            <div className="absolute top-4 left-4 right-4 z-50 flex justify-between">
                <button 
                    onClick={() => onNavigate('SERVER_SEARCH')}
                    className="w-10 h-10 rounded-full bg-black/40 backdrop-blur border border-white/10 flex items-center justify-center text-white hover:bg-black/60 transition-colors"
                >
                    <ArrowLeft className="w-5 h-5" />
                </button>
                <button 
                    onClick={onToggleFavorite}
                    className={`w-10 h-10 rounded-full backdrop-blur border flex items-center justify-center transition-colors
                        ${isFavorite ? 'bg-yellow-500/20 border-yellow-500 text-yellow-500' : 'bg-black/40 border-white/10 text-zinc-400 hover:text-white'}
                    `}
                >
                    <Star className={`w-5 h-5 ${isFavorite ? 'fill-yellow-500' : ''}`} />
                </button>
            </div>

            {/* Info */}
            <div className="relative z-10 px-6 pb-6 pt-16">
                <div className="flex flex-wrap items-center gap-2 mb-3">
                    <div className="flex items-center gap-1.5 bg-black/60 backdrop-blur px-2.5 py-1 rounded border border-white/10">
                        <div className={`w-2 h-2 rounded-full ${isOnline ? 'bg-green-500 shadow-[0_0_8px_#22c55e]' : 'bg-red-500'}`} />
                        <span className={`text-[10px] font-black uppercase tracking-wider ${isOnline ? 'text-green-500' : 'text-red-500'}`}>
                            {isOnline ? 'ONLINE' : 'OFFLINE'}
                        </span>
                    </div>
                    {server.official && (
                        <div className="bg-blue-900/60 backdrop-blur px-2 py-1 rounded border border-blue-500/30 text-blue-400 text-[10px] font-bold uppercase">Official</div>
                    )}
                </div>

                <h1 className="text-xl md:text-2xl font-black text-white leading-tight mb-3 line-clamp-2 drop-shadow-xl shadow-black">
                    {server.name}
                </h1>
                
                <div className="flex items-center flex-wrap gap-2 text-[11px] font-mono text-zinc-300">
                    <div className="bg-zinc-900/80 border border-zinc-700 px-2 py-1 rounded flex items-center gap-1.5 backdrop-blur-sm cursor-pointer active:scale-95 transition-transform" onClick={() => navigator.clipboard.writeText(`${server.ip}:${server.port}`)}>
                        <Globe className="w-3 h-3 text-zinc-500" />
                        <span>{server.ip}:{server.port}</span>
                    </div>
                </div>
            </div>
        </div>
    );
};