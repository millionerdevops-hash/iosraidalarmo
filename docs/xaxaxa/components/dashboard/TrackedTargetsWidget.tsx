
import React from 'react';
import { Crosshair, User, Bell, Search, ChevronRight } from 'lucide-react';
import { TargetPlayer, ScreenName } from '../../types';

interface TrackedTargetsWidgetProps {
  targets: TargetPlayer[];
  onNavigate: (screen: ScreenName) => void;
  onSelectTarget: (target: TargetPlayer) => void;
}

export const TrackedTargetsWidget: React.FC<TrackedTargetsWidgetProps> = ({ targets, onNavigate, onSelectTarget }) => {
  return (
    <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-4">
        <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
                <Crosshair className="w-4 h-4 text-red-500" />
                <h3 className="font-bold text-white text-sm uppercase tracking-wider">Tracked Targets</h3>
            </div>
            <span className="text-[10px] bg-zinc-900 text-zinc-500 px-2 py-1 rounded border border-zinc-800 font-mono">
                {targets.length} Active
            </span>
        </div>

        {targets.length === 0 ? (
            <div className="text-center py-6 border border-dashed border-zinc-800 rounded-xl bg-zinc-900/20">
                <p className="text-zinc-500 text-xs mb-2">No players currently tracked.</p>
                <button 
                    onClick={() => onNavigate('PLAYER_SEARCH')}
                    className="text-[10px] text-orange-500 font-bold uppercase hover:text-orange-400"
                >
                    Search Players
                </button>
            </div>
        ) : (
            <div className="space-y-2">
                {targets.map((target, idx) => (
                    <button 
                        key={idx} 
                        onClick={() => onSelectTarget(target)}
                        className="w-full flex items-center justify-between bg-zinc-900/50 p-3 rounded-xl border border-zinc-800/50 hover:bg-zinc-800 hover:border-zinc-700 transition-all active:scale-[0.98] group"
                    >
                        <div className="flex items-center gap-3">
                            <div className="relative">
                                <div className={`w-8 h-8 rounded-full flex items-center justify-center border ${target.isOnline ? 'bg-green-900/20 border-green-500/30' : 'bg-zinc-800 border-zinc-700'}`}>
                                    <User className={`w-4 h-4 ${target.isOnline ? 'text-green-500' : 'text-zinc-500'}`} />
                                </div>
                                <div className={`absolute -bottom-0.5 -right-0.5 w-2.5 h-2.5 rounded-full border-2 border-[#121214] ${target.isOnline ? 'bg-green-500 animate-pulse' : 'bg-zinc-500'}`} />
                            </div>
                            <div className="text-left">
                                <div className="text-sm font-bold text-white leading-none group-hover:text-orange-500 transition-colors">{target.name}</div>
                                <div className="text-[10px] text-zinc-500 font-mono mt-1">{target.isOnline ? 'Online Now' : target.lastSeen}</div>
                            </div>
                        </div>
                        
                        <div className="flex items-center gap-3">
                            {target.alertConfig?.onOnline && (
                                <div className="bg-red-500/10 p-1.5 rounded-lg border border-red-500/20">
                                    <Bell className="w-3 h-3 text-red-500" />
                                </div>
                            )}
                            <ChevronRight className="w-4 h-4 text-zinc-600 group-hover:text-white" />
                        </div>
                    </button>
                ))}
            </div>
        )}
    </div>
  );
};
