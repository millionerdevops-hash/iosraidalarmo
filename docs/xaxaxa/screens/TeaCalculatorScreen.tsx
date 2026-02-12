
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  ArrowRight,
  Coffee, 
  Leaf, 
  Pickaxe, 
  TreePine, 
  Heart, 
  Recycle, 
  Radiation,
  Beaker,
  Timer,
  Wheat,
  Snowflake,
  Flame,
  Hammer,
  Activity,
  Droplet
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { TEA_DATABASE, TeaType, TeaDef } from '../data/teaData';

interface TeaCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

const CATEGORIES: { id: TeaType; label: string; icon: any; color: string }[] = [
    { id: 'Ore', label: 'Ore', icon: Pickaxe, color: 'text-yellow-500' },
    { id: 'Wood', label: 'Wood', icon: TreePine, color: 'text-amber-600' },
    { id: 'Scrap', label: 'Scrap', icon: Recycle, color: 'text-zinc-300' },
    { id: 'Harvesting', label: 'Harvest', icon: Wheat, color: 'text-lime-400' },
    { id: 'MaxHealth', label: 'Max HP', icon: Heart, color: 'text-emerald-500' },
    { id: 'Healing', label: 'Heal', icon: Activity, color: 'text-red-500' },
    { id: 'Rad', label: 'Anti-Rad', icon: Radiation, color: 'text-orange-500' },
    { id: 'Cooling', label: 'Cooling', icon: Snowflake, color: 'text-cyan-400' },
    { id: 'Warming', label: 'Warming', icon: Flame, color: 'text-orange-300' },
    { id: 'Crafting', label: 'Crafting', icon: Hammer, color: 'text-purple-400' },
];

export const TeaCalculatorScreen: React.FC<TeaCalculatorScreenProps> = ({ onNavigate }) => {
  const [activeCategory, setActiveCategory] = useState<TeaType>('Ore');
  const [selectedTea, setSelectedTea] = useState<TeaDef | null>(null);

  // Default to the Basic tea of the category
  React.useEffect(() => {
      const firstTea = TEA_DATABASE.find(t => t.type === activeCategory && t.tier === 'Basic');
      setSelectedTea(firstTea || null);
  }, [activeCategory]);

  const filteredTeas = TEA_DATABASE.filter(t => t.type === activeCategory);

  // Sorting: Basic -> Advanced -> Pure
  const sortedTeas = filteredTeas.sort((a, b) => {
      const order = { 'Basic': 0, 'Advanced': 1, 'Pure': 2 };
      return order[a.tier] - order[b.tier];
  });

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-center relative bg-[#0c0c0e] z-10 shrink-0">
        <button 
          onClick={() => onNavigate('DASHBOARD')}
          className="absolute left-4 p-2 text-zinc-400 hover:text-white transition-colors"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Tea Recipes</h2>
      </div>

      {/* Category Tabs */}
      <div className="flex bg-[#0c0c0e] p-4 gap-2 overflow-x-auto no-scrollbar shrink-0 border-b border-zinc-900">
          {CATEGORIES.map(cat => (
              <button
                  key={cat.id}
                  onClick={() => setActiveCategory(cat.id)}
                  className={`flex items-center gap-2 px-4 py-2 rounded-xl text-[10px] font-bold uppercase transition-all whitespace-nowrap border active:scale-95
                      ${activeCategory === cat.id 
                          ? `bg-zinc-800 border-zinc-600 text-white shadow-[0_0_15px_rgba(255,255,255,0.05)]` 
                          : 'bg-zinc-900 border-transparent text-zinc-500'}
                  `}
              >
                  <cat.icon className={`w-3 h-3 ${activeCategory === cat.id ? cat.color : 'text-zinc-600'}`} />
                  {cat.label}
              </button>
          ))}
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4">
         
         {/* Main Tea Display (Detail View) */}
         {selectedTea && (
             <div className="mb-6 animate-in fade-in duration-300">
                 
                 {/* Card Header & Visual */}
                 <div className={`rounded-2xl border p-6 text-center relative overflow-hidden mb-4 ${selectedTea.color}`}>
                     
                     {/* Absolute Duration Badge (Top Right) */}
                     <div className="absolute top-4 right-4 flex items-center gap-1.5 text-[10px] font-mono font-bold uppercase bg-black/40 px-2.5 py-1.5 rounded-lg border border-white/10 text-zinc-200 shadow-sm backdrop-blur-md z-20">
                         <Timer className="w-3 h-3 text-white/70" /> 
                         <span>{selectedTea.duration}</span>
                     </div>

                     <div className="relative z-10 flex flex-col items-center">
                         {/* Dynamic Image */}
                         <div className="w-32 h-32 mb-2 filter drop-shadow-2xl">
                             <img src={selectedTea.image} alt={selectedTea.name} className="w-full h-full object-contain" />
                         </div>
                         
                         <h3 className="text-2xl font-black uppercase leading-none mb-3 shadow-black drop-shadow-md text-white">{selectedTea.name}</h3>
                         
                         {/* Unified Stats Area (Excluding Duration) */}
                         <div className="flex flex-wrap justify-center gap-1.5 max-w-xs">
                             {/* Dynamic Stats Pills */}
                             {selectedTea.stats.map((stat, idx) => (
                                 <div key={idx} className="flex items-center gap-1.5 text-[10px] font-mono font-bold uppercase bg-black/60 px-2 py-1.5 rounded-lg border border-white/10 text-white shadow-sm backdrop-blur-sm">
                                     {stat.label === 'Hydration' && <Droplet className="w-3 h-3 text-cyan-400" />}
                                     <span className="text-zinc-400">{stat.label}</span>
                                     <span className={stat.isPositive ? 'text-green-400' : 'text-red-400'}>{stat.value}</span>
                                 </div>
                             ))}
                         </div>
                     </div>
                 </div>

                 {/* Recipe Section (Mixing Table Style) */}
                 <div className="bg-[#18181b] border border-zinc-800 rounded-2xl p-4">
                     <div className="flex items-center gap-2 mb-4">
                         <Beaker className="w-4 h-4 text-purple-500" />
                         <span className="text-xs font-bold text-white uppercase tracking-wider">Mixing Table Recipe</span>
                     </div>

                     <div className="flex justify-center gap-3">
                         {selectedTea.recipe.inputs.map((input, idx) => (
                             <React.Fragment key={idx}>
                                 {/* Plus Sign - Vertically aligned with image box */}
                                 {idx > 0 && (
                                     <div className="flex flex-col items-center">
                                         <div className="h-14 flex items-center justify-center text-zinc-600 font-black text-lg">
                                             +
                                         </div>
                                     </div>
                                 )}
                                 
                                 {/* Input Item */}
                                 <div className="flex flex-col items-center gap-2">
                                     <div className="w-14 h-14 rounded-xl bg-black/40 border border-zinc-700 flex items-center justify-center relative shrink-0">
                                         <img src={input.img} alt={input.name} className="w-10 h-10 object-contain" />
                                         <div className="absolute -top-2 -right-2 bg-zinc-800 text-white text-[10px] font-black w-5 h-5 rounded-full flex items-center justify-center border border-zinc-600 shadow-lg z-10">
                                             x{input.count}
                                         </div>
                                     </div>
                                     <span className="text-[9px] text-zinc-500 font-bold uppercase text-center whitespace-nowrap max-w-[60px] truncate">
                                         {input.name}
                                     </span>
                                 </div>
                             </React.Fragment>
                         ))}

                         {/* Arrow - Vertically aligned with image box */}
                         <div className="flex flex-col items-center px-1">
                             <div className="h-14 flex items-center justify-center text-zinc-500">
                                 <ArrowRight className="w-4 h-4" />
                             </div>
                         </div>

                         {/* Output Item */}
                         <div className="flex flex-col items-center gap-2">
                             <div className="w-14 h-14 rounded-xl bg-zinc-800 border border-zinc-600 flex items-center justify-center relative shadow-lg shadow-black/50 shrink-0">
                                 <img src={selectedTea.image} alt={selectedTea.name} className="w-10 h-10 object-contain" />
                                 <div className="absolute -top-2 -right-2 bg-green-500 text-black text-[10px] font-black w-5 h-5 rounded-full flex items-center justify-center border border-green-400 shadow-lg z-10">
                                     1
                                 </div>
                             </div>
                             <span className="text-[9px] text-white font-bold uppercase text-center leading-tight">
                                 {selectedTea.tier}
                             </span>
                         </div>
                     </div>
                 </div>

             </div>
         )}

         {/* Tea List Selection */}
         <div className="space-y-2">
             <div className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-2 px-1">Select Tier</div>
             {sortedTeas.map((tea) => (
                 <button
                     key={tea.id}
                     onClick={() => setSelectedTea(tea)}
                     className={`w-full flex items-center justify-between p-3 rounded-xl border transition-all active:scale-[0.98]
                         ${selectedTea?.id === tea.id 
                             ? 'bg-zinc-800 border-zinc-600' 
                             : 'bg-zinc-900/40 border-zinc-800'}
                     `}
                 >
                     <div className="flex items-center gap-3">
                         <div className={`w-10 h-10 rounded-lg flex items-center justify-center bg-black/40 border border-zinc-700/50 p-1`}>
                             <img src={tea.image} alt={tea.name} className="w-full h-full object-contain" />
                         </div>
                         <div className="text-left">
                             <div className={`text-xs font-bold ${selectedTea?.id === tea.id ? 'text-white' : 'text-zinc-400'}`}>
                                 {tea.name}
                             </div>
                         </div>
                     </div>
                     <div className={`text-[9px] font-bold uppercase px-2 py-1 rounded border ${tea.color.replace('text-', 'text-opacity-80 text-').split(' ')[0]} bg-black/20 border-white/5`}>
                         {tea.tier}
                     </div>
                 </button>
             ))}
         </div>

      </div>
    </div>
  );
};
