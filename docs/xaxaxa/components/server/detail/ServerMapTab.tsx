import React from 'react';
import { ExternalLink, Map as MapIcon } from 'lucide-react';
import { ServerData } from '../../../types';

interface ServerMapTabProps {
    server: ServerData;
}

export const ServerMapTab: React.FC<ServerMapTabProps> = ({ server }) => {
    const openRustMaps = () => {
        if (server.mapSize && server.seed) {
            window.open(`https://rustmaps.com/map/${server.mapSize}_${server.seed}`, '_blank');
        }
    };

    return (
        <div className="flex-1 h-full bg-[#121214] relative animate-in fade-in duration-300">
            {server.mapSize && server.seed ? (
                <>
                    <iframe 
                        src={`https://rustmaps.com/map/${server.mapSize}_${server.seed}`}
                        className="w-full h-full border-0"
                        title="Rust Map View"
                        sandbox="allow-scripts allow-same-origin allow-forms"
                    />
                    {/* Overlay to allow opening elsewhere if iframe is cramped */}
                    <div className="absolute bottom-6 right-6 flex gap-2">
                        <button 
                            onClick={openRustMaps}
                            className="bg-black/80 backdrop-blur-md text-white px-4 py-2.5 rounded-full text-xs font-bold border border-white/20 flex items-center gap-2 hover:bg-black hover:border-white/40 transition-all shadow-2xl"
                        >
                            <ExternalLink className="w-3 h-3" /> Open in Browser
                        </button>
                    </div>
                </>
            ) : (
                <div className="flex flex-col items-center justify-center h-full text-zinc-500 gap-2">
                    <MapIcon className="w-12 h-12 opacity-20" />
                    <span className="text-xs">Map info unavailable for this server</span>
                </div>
            )}
        </div>
    );
};