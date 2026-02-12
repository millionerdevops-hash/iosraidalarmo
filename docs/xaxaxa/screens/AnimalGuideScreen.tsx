
import React, { useState, useMemo } from 'react';
import { 
  ArrowLeft, 
  Crosshair,
  Heart,
  Trophy,
  Hammer
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { ANIMALS, Animal, HarvestTool, ResourceDrop } from '../data/animalData';

interface AnimalGuideScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

interface HarvestGroup {
    id: string;
    tools: HarvestTool[];
    drops: ResourceDrop[];
    totalValue: number; // For sorting
}

export const AnimalGuideScreen: React.FC<AnimalGuideScreenProps> = ({ onNavigate }) => {
  const [selectedAnimal, setSelectedAnimal] = useState<Animal | null>(null);

  // Grouping Logic
  const harvestGroups = useMemo(() => {
      if (!selectedAnimal) return [];

      const groups: Record<string, HarvestGroup> = {};

      selectedAnimal.harvest.forEach(tool => {
          // Create a unique signature for the drops (e.g. "Leather-100|Raw Meat-19")
          // Sort drops by name to ensure consistent signature order
          const signature = tool.drops
              .sort((a, b) => a.name.localeCompare(b.name))
              .map(d => `${d.name}-${d.amount}`)
              .join('|');

          // Calculate a rough "total value" for sorting (e.g. sum of amounts)
          const totalVal = tool.drops.reduce((sum, d) => sum + d.amount, 0);

          if (!groups[signature]) {
              groups[signature] = {
                  id: signature,
                  tools: [],
                  drops: tool.drops,
                  totalValue: totalVal
              };
          }
          groups[signature].tools.push(tool);
      });

      // Convert to array and sort by total value (descending)
      return Object.values(groups).sort((a, b) => b.totalValue - a.totalValue);
  }, [selectedAnimal]);

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => {
                    if (selectedAnimal) setSelectedAnimal(null);
                    else onNavigate('DASHBOARD');
                }}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                {/* Dynamic Title based on selection */}
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont} ${selectedAnimal ? 'italic tracking-tighter' : ''}`}>
                    {selectedAnimal ? selectedAnimal.name.toUpperCase() : 'Fauna Guide'}
                </h2>
                {!selectedAnimal && (
                    <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">
                        Select Species
                    </p>
                )}
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4">
         
         {!selectedAnimal ? (
             <div className="grid grid-cols-2 gap-3 pb-8">
                 {ANIMALS.map((animal) => (
                     <button
                        key={animal.id}
                        onClick={() => setSelectedAnimal(animal)}
                        className="bg-[#121214] border border-zinc-800 hover:border-zinc-600 rounded-2xl p-4 flex flex-col items-center gap-3 transition-all active:scale-[0.98] group relative overflow-hidden"
                     >
                         <div className="w-20 h-20 relative z-10">
                             <img src={animal.image} alt={animal.name} className="w-full h-full object-contain drop-shadow-xl" />
                         </div>
                         <div className="text-center relative z-10">
                             <h3 className="text-white font-black uppercase text-lg leading-none">{animal.name}</h3>
                             <p className="text-zinc-500 text-xs font-mono mt-1">{animal.hp} HP</p>
                         </div>
                         
                         {/* Background Gradient */}
                         <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent z-0" />
                     </button>
                 ))}
             </div>
         ) : (
             <div className="flex flex-col gap-6 pb-12">
                 
                 {/* Hero Section */}
                 <div className="relative rounded-3xl bg-[#18181b] border border-zinc-800 overflow-hidden p-6 flex flex-col items-center shadow-2xl">
                     
                     <div className="relative w-full flex justify-center mb-6">
                         <img 
                            src={selectedAnimal.image} 
                            alt={selectedAnimal.name} 
                            className="w-56 h-56 object-contain drop-shadow-[0_15px_30px_rgba(0,0,0,0.6)] z-10" 
                         />
                         
                         {/* HP Badge - On Image */}
                         <div className="absolute bottom-0 right-4 bg-green-600/90 text-white font-black text-sm px-3 py-1.5 rounded-lg border border-green-400/50 shadow-lg backdrop-blur-md flex items-center gap-1.5 z-20">
                             <Heart className="w-3.5 h-3.5 fill-current" />
                             {selectedAnimal.hp} HP
                         </div>
                     </div>

                     <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_#27272a_0%,_#18181b_70%)] z-0" />
                     
                     <div className="w-full relative z-10">
                         <div className="bg-zinc-900/50 p-4 rounded-xl border border-zinc-800 text-sm text-zinc-300 leading-relaxed font-medium">
                             {selectedAnimal.description}
                         </div>
                     </div>
                 </div>

                 {/* Grouped Harvesting Table */}
                 <div>
                     <div className="flex items-center gap-2 mb-4 px-1">
                         <Crosshair className="w-4 h-4 text-orange-500" />
                         <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Harvest Yields</span>
                     </div>

                     <div className="space-y-4">
                         {harvestGroups.map((group, idx) => (
                             <div 
                                key={idx} 
                                className={`bg-[#121214] border rounded-2xl p-4 relative overflow-hidden transition-all
                                    ${idx === 0 ? 'border-orange-500/30 shadow-[0_0_20px_rgba(249,115,22,0.05)]' : 'border-zinc-800'}
                                `}
                             >
                                 {/* Best Yield Badge */}
                                 {idx === 0 && (
                                     <div className="absolute top-0 right-0 bg-orange-600/90 text-white text-[9px] font-black px-2 py-1 rounded-bl-xl shadow-lg flex items-center gap-1 z-20">
                                         <Trophy className="w-3 h-3 fill-current" /> BEST YIELD
                                     </div>
                                 )}

                                 {/* Tools Row */}
                                 <div className="mb-4">
                                     <span className="text-[9px] text-zinc-500 font-bold uppercase tracking-widest block mb-2">
                                         Tools ({group.tools.length})
                                     </span>
                                     <div className="flex flex-wrap gap-2">
                                         {group.tools.map((tool, tIdx) => (
                                             <div key={tIdx} className="relative group/tooltip">
                                                 <div className={`w-10 h-10 rounded-lg flex items-center justify-center border transition-colors bg-zinc-900
                                                     ${idx === 0 ? 'border-orange-500/30 text-orange-200' : 'border-zinc-700 text-zinc-400'}
                                                 `}>
                                                     <img src={tool.icon} alt={tool.name} className="w-6 h-6 object-contain drop-shadow-md" />
                                                 </div>
                                                 {/* Tooltip Name */}
                                                 <div className="absolute -bottom-6 left-1/2 -translate-x-1/2 bg-black text-white text-[9px] px-2 py-1 rounded whitespace-nowrap opacity-0 group-hover/tooltip:opacity-100 transition-opacity pointer-events-none z-30 font-bold uppercase tracking-wider border border-zinc-800">
                                                     {tool.name}
                                                 </div>
                                             </div>
                                         ))}
                                     </div>
                                 </div>

                                 {/* Divider */}
                                 <div className="h-px bg-zinc-800/80 w-full mb-3" />

                                 {/* Resources Row */}
                                 <div>
                                     <div className="grid grid-cols-3 gap-2">
                                         {group.drops.map((drop, rIdx) => (
                                             <div 
                                                key={rIdx} 
                                                className={`flex items-center gap-2 p-2 rounded-lg border bg-zinc-900/50
                                                    ${idx === 0 ? 'border-zinc-700' : 'border-zinc-800/50'}
                                                `}
                                             >
                                                 <img src={drop.icon} alt={drop.name} className="w-6 h-6 object-contain" />
                                                 <div className="flex flex-col leading-none">
                                                     <span className={`text-sm font-black font-mono ${idx === 0 ? 'text-white' : 'text-zinc-400'}`}>
                                                         {drop.amount}
                                                     </span>
                                                     <span className="text-[8px] text-zinc-500 font-bold uppercase tracking-tight mt-0.5 truncate max-w-[60px]">
                                                         {drop.name}
                                                     </span>
                                                 </div>
                                             </div>
                                         ))}
                                     </div>
                                 </div>

                             </div>
                         ))}
                     </div>
                 </div>

             </div>
         )}

      </div>
    </div>
  );
};
