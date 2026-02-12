
import React from 'react';
import { 
    RefreshCw, List, Loader2, Bell, BellOff, Lock,
    Copy, Globe
} from 'lucide-react';
import { ServerData } from '../../../types';
import { Button } from '../../Button';

interface ServerOverviewTabProps {
    server: ServerData;
    refreshing: boolean;
    onRefresh: () => void;
    onChangeServer: () => void;
    wipeAlertEnabled: boolean;
    onToggleWipeAlert: (enabled: boolean) => void;
    wipeAlertMinutes: number;
    onSetWipeAlertMinutes?: (minutes: number) => void;
    isFreeUser?: boolean;
    onPaywall?: () => void;
}

export const ServerOverviewTab: React.FC<ServerOverviewTabProps> = ({
    server,
    refreshing,
    onRefresh,
    onChangeServer,
    wipeAlertEnabled,
    onToggleWipeAlert,
    wipeAlertMinutes,
    onSetWipeAlertMinutes,
    isFreeUser = true,
    onPaywall
}) => {
    
    const formatCountdown = (isoDate?: string) => {
        if (!isoDate) return "Unknown";
        const diffMs = new Date(isoDate).getTime() - new Date().getTime();
        if (diffMs < 0) return "Overdue";
        const days = Math.floor(diffMs / (86400000));
        const hours = Math.floor((diffMs % 86400000) / 3600000);
        const mins = Math.floor((diffMs % 3600000) / 60000);
        if (days > 0) return `${days}d ${hours}h`;
        return `${hours}h ${mins}m`;
    };

    const formatTimeAgo = (isoDate?: string) => {
        if (!isoDate) return "Unknown";
        const wipe = new Date(isoDate);
        const now = new Date();
        const diffMs = now.getTime() - wipe.getTime();
        const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
        const diffDays = Math.floor(diffHours / 24);
        
        if (diffDays > 0) return `${diffDays}d ${diffHours % 24}h ago`;
        return `${diffHours}h ago`;
    };

    const formatEntities = (count?: number) => {
        if (!count) return 'N/A';
        return count > 1000 ? `${(count / 1000).toFixed(0)}k` : count;
    };

    const handleToggleClick = () => {
        if (!server.nextWipe) return;
        if (isFreeUser && onPaywall) {
            onPaywall();
        } else {
            onToggleWipeAlert(!wipeAlertEnabled);
        }
    };

    const isActive = wipeAlertEnabled && !!server.nextWipe;

    return (
        <>
            <div className="space-y-4 animate-in fade-in slide-in-from-bottom-2 duration-300 pb-32 p-4">
                
                {/* 1. SERVER STATS GRID (Text Only) */}
                <div className="grid grid-cols-4 gap-2">
                    {/* POPULATION */}
                    <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-2 flex flex-col items-center justify-center h-16">
                        <span className="text-[10px] text-zinc-500 font-black uppercase tracking-wider mb-0.5">
                            POP
                        </span>
                        <span className="font-mono font-bold text-sm text-white whitespace-nowrap">
                            {server.players}/{server.maxPlayers}
                        </span>
                    </div>

                    {/* FPS */}
                    <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-2 flex flex-col items-center justify-center h-16">
                        <span className="text-[10px] text-zinc-500 font-black uppercase tracking-wider mb-0.5">
                            FPS
                        </span>
                        <span className={`font-mono font-bold text-sm ${server.fps && server.fps > 30 ? 'text-white' : 'text-red-400'}`}>
                            {server.fps || 'N/A'}
                        </span>
                    </div>

                    {/* ENTITIES */}
                    <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-2 flex flex-col items-center justify-center h-16">
                        <span className="text-[10px] text-zinc-500 font-black uppercase tracking-wider mb-0.5">
                            ENTITIES
                        </span>
                        <span className="font-mono font-bold text-sm text-white">
                            {formatEntities(server.entities)}
                        </span>
                    </div>

                    {/* UPTIME */}
                    <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-2 flex flex-col items-center justify-center h-16">
                        <span className="text-[10px] text-zinc-500 font-black uppercase tracking-wider mb-0.5">
                            UPTIME
                        </span>
                        <span className="font-mono font-bold text-sm text-white">
                            {server.uptime ? `${Math.floor(server.uptime / 3600)}h` : 'N/A'}
                        </span>
                    </div>
                </div>

                {/* 2. MAP INTELLIGENCE CARD */}
                <div className="bg-[#18181b] border border-zinc-800 rounded-2xl overflow-hidden relative">
                    <div className="p-3 border-b border-zinc-800/50 flex items-center justify-between bg-black/20">
                        <div className="flex items-center gap-2">
                            <span className="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Map Info</span>
                        </div>
                        <span className="text-[10px] text-zinc-500 font-mono bg-zinc-900 px-2 py-0.5 rounded border border-zinc-800 truncate max-w-[150px]">
                            {server.map || 'Procedural Map'}
                        </span>
                    </div>

                    <div className="p-3 grid grid-cols-2 gap-3">
                        {/* Seed */}
                        <div className="bg-zinc-900/50 rounded-xl p-2.5 border border-zinc-800 flex flex-col">
                            <span className="text-[9px] text-zinc-500 font-bold uppercase mb-1">Seed</span>
                            <div className="flex items-center justify-between">
                                <span className="text-lg font-black text-white font-mono tracking-tight">{server.seed || '?'}</span>
                                <button 
                                    onClick={() => server.seed && navigator.clipboard.writeText(server.seed.toString())}
                                    className="p-1 bg-zinc-800 hover:bg-zinc-700 text-zinc-400 hover:text-white rounded-md transition-colors"
                                    title="Copy Seed"
                                >
                                    <Copy className="w-3 h-3" />
                                </button>
                            </div>
                        </div>

                        {/* Size */}
                        <div className="bg-zinc-900/50 rounded-xl p-2.5 border border-zinc-800 flex flex-col">
                            <span className="text-[9px] text-zinc-500 font-bold uppercase mb-1">Size</span>
                            <div className="flex items-center justify-between">
                                <span className="text-lg font-black text-white font-mono tracking-tight">{server.mapSize || '?'}</span>
                                <span className="text-[9px] text-zinc-600 font-mono self-end mb-1">m²</span>
                            </div>
                        </div>
                    </div>
                </div>

                {/* 3. WIPE SCHEDULE (Side-by-Side) */}
                <div className="grid grid-cols-2 gap-3">
                    {/* Next Wipe */}
                    <div className="bg-zinc-900 border border-zinc-800 rounded-xl p-4 flex flex-col justify-between h-24">
                        <span className="text-[10px] text-zinc-500 font-black uppercase tracking-widest">
                            NEXT WIPE
                        </span>
                        
                        {server.nextWipe ? (
                            <div>
                                <div className="text-xl font-black text-white font-mono tracking-tighter leading-none mb-1">
                                    {formatCountdown(server.nextWipe)}
                                </div>
                                <div className="text-zinc-500 text-[10px] font-medium truncate">
                                    {new Date(server.nextWipe).toLocaleDateString(undefined, {weekday:'short', month:'short', day:'numeric'})}
                                </div>
                            </div>
                        ) : (
                            <div className="text-sm font-bold text-zinc-600 uppercase">
                                Unknown
                            </div>
                        )}
                    </div>

                    {/* Last Wipe */}
                    <div className="bg-zinc-900 border border-zinc-800 rounded-xl p-4 flex flex-col justify-between h-24">
                        <span className="text-[10px] text-zinc-500 font-black uppercase tracking-widest">
                            LAST WIPE
                        </span>
                        <div>
                            <div className="text-xl font-bold text-zinc-300 tracking-tight leading-none mb-1">
                                {formatTimeAgo(server.lastWipe)}
                            </div>
                            <div className="text-zinc-500 text-[10px] font-medium truncate">
                                {server.lastWipe ? new Date(server.lastWipe).toLocaleDateString() : 'N/A'}
                            </div>
                        </div>
                    </div>
                </div>

                {/* 4. NOTIFICATION CARD (Always Visible) */}
                <div className={`bg-[#18181b] border transition-all duration-300 rounded-2xl overflow-hidden
                    ${isActive ? 'border-orange-500 shadow-[0_0_20px_rgba(249,115,22,0.1)]' : 'border-zinc-800'}
                `}>
                    {/* Toggle Header */}
                    <div className="p-4 flex items-center justify-between border-b border-zinc-800/50 bg-black/20">
                        <div className="flex items-center gap-3">
                            <div className={`w-10 h-10 rounded-full flex items-center justify-center transition-colors ${isActive ? 'bg-orange-500 text-black' : 'bg-zinc-800 text-zinc-500'}`}>
                                {isActive ? <Bell className="w-5 h-5" /> : <BellOff className="w-5 h-5" />}
                            </div>
                            <div>
                                <div className={`font-bold text-sm ${isActive ? 'text-white' : 'text-zinc-400'}`}>
                                    Wipe Notification
                                </div>
                                <div className="text-zinc-500 text-[10px] uppercase font-bold tracking-wide">
                                    {!server.nextWipe ? 'Schedule Unknown' : isActive ? 'Active' : isFreeUser ? 'Pro Feature' : 'Disabled'}
                                </div>
                            </div>
                        </div>
                        
                        <button 
                            onClick={handleToggleClick}
                            disabled={!server.nextWipe}
                            className={`w-12 h-7 rounded-full p-1 transition-colors duration-200 ease-in-out relative
                            ${isActive ? 'bg-orange-500' : 'bg-zinc-700'}
                            ${!server.nextWipe ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}
                            `}
                        >
                            <div className={`w-5 h-5 bg-white rounded-full shadow-md transition-transform duration-200 ease-in-out flex items-center justify-center 
                                ${isActive ? 'translate-x-5' : 'translate-x-0'}
                            `}>
                                {isFreeUser && !isActive && server.nextWipe && <Lock className="w-3 h-3 text-zinc-800" />}
                            </div>
                        </button>
                    </div>

                    {/* Duration Selector */}
                    {isActive && onSetWipeAlertMinutes && !isFreeUser && (
                        <div className="p-4 animate-in slide-in-from-top-2 duration-200">
                            <div className="flex items-center justify-between mb-3">
                                <span className="text-xs text-zinc-400 font-bold uppercase">Alert me before:</span>
                                <span className="text-xs text-orange-500 font-mono font-bold">{wipeAlertMinutes} min</span>
                            </div>
                            
                            <div className="grid grid-cols-4 gap-2">
                                {[10, 30, 60, 120].map((mins) => (
                                    <button
                                        key={mins}
                                        onClick={() => onSetWipeAlertMinutes(mins)}
                                        className={`py-2 rounded-lg text-xs font-bold border transition-all
                                            ${wipeAlertMinutes === mins 
                                                ? 'bg-orange-500 text-black border-orange-500' 
                                                : 'bg-zinc-900 text-zinc-500 border-zinc-700 hover:bg-zinc-800 hover:text-zinc-300'
                                            }
                                        `}
                                    >
                                        {mins >= 60 ? `${mins/60}h` : `${mins}m`}
                                    </button>
                                ))}
                            </div>
                        </div>
                    )}
                </div>
            </div>

            {/* FIXED FOOTER BUTTONS */}
            <div className="absolute bottom-0 left-0 right-0 p-4 bg-[#0c0c0e] border-t border-zinc-800 flex gap-3 z-20">
                <Button onClick={onRefresh} disabled={refreshing} className="flex-1 bg-red-600 hover:bg-red-700 border-red-500">
                    {refreshing ? <Loader2 className="w-4 h-4 animate-spin" /> : <RefreshCw className="w-4 h-4" />}
                    FORCE REFRESH
                </Button>
                <Button variant="secondary" onClick={onChangeServer} className="flex-1">
                    <List className="w-4 h-4" /> CHANGE SERVER
                </Button>
            </div>
        </>
    );
};
