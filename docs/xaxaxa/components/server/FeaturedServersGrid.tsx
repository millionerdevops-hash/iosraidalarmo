
import React from 'react';
import { Globe, Flame } from 'lucide-react';

const FEATURED_GROUPS = [
    { name: "Rusty Moose", query: "Rusty Moose" },
    { name: "Rustoria", query: "Rustoria" },
    { name: "Rustafied", query: "Rustafied" },
    { name: "Reddit PlayRust", query: "Reddit.com/r/PlayRust" },
    { name: "Vital", query: "Vital" },
    { name: "Rusticated", query: "Rusticated" },
    { name: "Stevious", query: "Stevious" },
    { name: "Bloo Lagoon", query: "Bloo Lagoon" },
    { name: "Pickle", query: "Pickle" },
    { name: "Paranoid", query: "Paranoid" },
    { name: "Renegade", query: "Renegade" },
    { name: "Werwolf", query: "Werwolf" },
    { name: "Hollow", query: "Hollow" },
    { name: "Atlas", query: "Atlas" },
    { name: "Upsurge", query: "Upsurge" },
    { name: "Garnet", query: "Garnet" }
];

interface FeaturedServersGridProps {
    onGroupSelect: (query: string) => void;
}

export const FeaturedServersGrid: React.FC<FeaturedServersGridProps> = ({ onGroupSelect }) => {
    return (
        <div className="animate-in fade-in duration-500">
            <div className="flex items-center gap-2 mb-4 px-1">
                <Flame className="w-4 h-4 text-orange-500" />
                <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Popular Communities</span>
            </div>
            
            <div className="grid grid-cols-2 gap-3">
                {FEATURED_GROUPS.map((group) => (
                    <button
                        key={group.name}
                        onClick={() => onGroupSelect(group.query)}
                        className="bg-zinc-900 border border-zinc-800 hover:border-orange-500/50 hover:bg-zinc-800 p-4 rounded-xl flex items-center justify-center text-center transition-all group active:scale-[0.98] min-h-[84px] shadow-sm"
                    >
                        <span className="text-sm font-black text-zinc-300 uppercase tracking-wide group-hover:text-white transition-colors">
                            {group.name}
                        </span>
                    </button>
                ))}
            </div>

            <div className="mt-8 p-4 bg-zinc-900/30 rounded-xl border border-zinc-800/50">
                <div className="flex items-center gap-2 mb-2">
                    <Flame className="w-4 h-4 text-orange-500" />
                    <h4 className="text-xs font-bold text-white uppercase">Why Official?</h4>
                </div>
                <p className="text-[10px] text-zinc-500 leading-relaxed">
                    Official servers maintain consistent monthly wipe schedules and high population. Add these to your favorites for quick access to wipe countdowns.
                </p>
            </div>
        </div>
    );
};
