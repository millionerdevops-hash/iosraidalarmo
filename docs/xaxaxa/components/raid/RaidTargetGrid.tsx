import React from 'react';
import { RaidTarget } from '../../data/raidData';

interface RaidTargetGridProps {
    targets: RaidTarget[];
    selectedId: string;
    onSelect: (id: string) => void;
}

export const RaidTargetGrid: React.FC<RaidTargetGridProps> = ({ targets, selectedId, onSelect }) => {
    return (
        <div className="px-4 pb-6">
            <div className="grid grid-cols-4 gap-2">
               {targets.map((t) => (
                  <button
                    key={t.id}
                    onClick={() => onSelect(t.id)}
                    className={`aspect-square rounded-xl relative overflow-hidden transition-all duration-200 border-2 group
                       ${selectedId === t.id 
                         ? `bg-[#27272a] border-orange-500` 
                         : `bg-[#18181b] border-zinc-800/60 hover:border-zinc-600`
                       }
                    `}
                  >
                     <div className="absolute inset-0 flex items-center justify-center p-4">
                        <img 
                            src={t.img} 
                            alt={t.label} 
                            className={`w-full h-full object-contain drop-shadow-xl transition-transform duration-300 ${selectedId === t.id ? 'scale-110' : 'group-hover:scale-105'}`} 
                        />
                     </div>
                  </button>
               ))}
            </div>
         </div>
    );
};