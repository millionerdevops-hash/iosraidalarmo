
import React, { useState, useEffect, useMemo } from 'react';
import { 
  ArrowLeft, 
  Check, 
  Trash2, 
  Search,
  Filter,
  Users,
  Hammer,
  Info
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { BLUEPRINTS, BPTier } from '../data/blueprintData';

interface BlueprintTrackerScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const BlueprintTrackerScreen: React.FC<BlueprintTrackerScreenProps> = ({ onNavigate }) => {
  const [learnedIds, setLearnedIds] = useState<string[]>(() => {
      try {
          const saved = localStorage.getItem('raid_alarm_bps');
          return saved ? JSON.parse(saved) : [];
      } catch { return []; }
  });
  
  const [activeTier, setActiveTier] = useState<BPTier>('Tier 2');
  const [search, setSearch] = useState('');
  const [filterMode, setFilterMode] = useState<'ALL' | 'NEEDED'>('ALL'); // Show All vs Show Needed Only
  
  // Persist Data
  useEffect(() => {
      localStorage.setItem('raid_alarm_bps', JSON.stringify(learnedIds));
  }, [learnedIds]);

  const toggleLearn = (id: string) => {
      setLearnedIds(prev => {
          if (prev.includes(id)) return prev.filter(i => i !== id);
          return [...prev, id];
      });
  };

  const clearAll = () => {
      if(confirm("Are you sure you want to reset all learned blueprints?")) {
          setLearnedIds([]);
      }
  };

  // --- FILTER & CALCULATIONS ---
  const tierBPs = useMemo(() => BLUEPRINTS.filter(bp => bp.tier === activeTier), [activeTier]);
  
  const displayBPs = useMemo(() => {
      return tierBPs.filter(bp => {
          const matchesSearch = bp.name.toLowerCase().includes(search.toLowerCase());
          const isLearned = learnedIds.includes(bp.id);
          const matchesMode = filterMode === 'ALL' || (filterMode === 'NEEDED' && !isLearned);
          return matchesSearch && matchesMode;
      }).sort((a, b) => {
          // Sort Needed to top, Learned to bottom
          const aLearned = learnedIds.includes(a.id);
          const bLearned = learnedIds.includes(b.id);
          if (aLearned === bLearned) return 0;
          return aLearned ? 1 : -1;
      });
  }, [tierBPs, search, learnedIds, filterMode]);

  const stats = useMemo(() => {
      const totalCost = tierBPs.reduce((sum, bp) => sum + bp.cost, 0);
      const learnedCost = tierBPs
          .filter(bp => learnedIds.includes(bp.id))
          .reduce((sum, bp) => sum + bp.cost, 0);
      const remainingCost = totalCost - learnedCost;
      const progress = (learnedCost / totalCost) * 100;
      
      return { totalCost, learnedCost, remainingCost, progress };
  }, [tierBPs, learnedIds]);

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>BP Tracker</h2>
                <div className="flex items-center gap-1 text-zinc-500 text-xs font-mono uppercase tracking-wider">
                    <Users className="w-3 h-3" /> Clan Sync Active
                </div>
            </div>
        </div>
        <button 
            onClick={clearAll}
            className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-red-500 hover:bg-red-900/10 transition-all"
        >
            <Trash2 className="w-5 h-5" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 pb-24">
         
         {/* INFO BOX */}
         <div className="bg-blue-900/10 border border-blue-500/20 p-3 rounded-xl mb-4 flex items-start gap-3">
             <Info className="w-5 h-5 text-blue-400 shrink-0 mt-0.5" />
             <p className="text-blue-200/70 text-[10px] leading-relaxed">
                 <strong className="text-blue-200">Note:</strong> Costs shown are for the <strong>Research Table</strong> (Direct Learn). If using the Tech Tree, total costs will be higher due to unlocking prerequisites. Use "Tech Tree" calc for path costs.
             </p>
         </div>

         {/* TIER TABS */}
         <div className="flex bg-zinc-900 p-1 rounded-xl border border-zinc-800 mb-4">
             {(['Tier 1', 'Tier 2', 'Tier 3'] as BPTier[]).map((tier) => (
                 <button
                    key={tier}
                    onClick={() => { setActiveTier(tier); setSearch(''); }}
                    className={`flex-1 py-2.5 rounded-lg text-xs font-bold uppercase transition-all
                        ${activeTier === tier 
                            ? tier === 'Tier 3' ? 'bg-[#0c0c0e] text-red-500 border border-red-900 shadow-lg' :
                              tier === 'Tier 2' ? 'bg-[#0c0c0e] text-blue-400 border border-blue-900 shadow-lg' :
                              'bg-[#0c0c0e] text-green-400 border border-green-900 shadow-lg'
                            : 'text-zinc-500 hover:text-zinc-300'}
                    `}
                 >
                     {tier}
                 </button>
             ))}
         </div>

         {/* SCRAP CALCULATOR CARD */}
         <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 mb-4 shadow-lg">
             <div className="flex justify-between items-center mb-2">
                 <div className="flex items-center gap-2">
                     <Hammer className="w-4 h-4 text-zinc-500" />
                     <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Scrap Required</span>
                 </div>
                 <span className="text-[10px] text-zinc-600 font-mono">
                     {Math.round(stats.progress)}% Complete
                 </span>
             </div>
             
             <div className="flex items-end gap-2">
                 <span className="text-3xl font-black text-white font-mono tracking-tighter">
                     {stats.remainingCost.toLocaleString()}
                 </span>
                 <span className="text-xs font-bold text-zinc-500 mb-1.5 uppercase">Scrap Left</span>
             </div>

             {/* Progress Bar */}
             <div className="h-1.5 w-full bg-zinc-800 rounded-full overflow-hidden mt-3">
                 <div 
                    className={`h-full transition-all duration-500 ${activeTier === 'Tier 3' ? 'bg-red-600' : activeTier === 'Tier 2' ? 'bg-blue-500' : 'bg-green-500'}`} 
                    style={{ width: `${stats.progress}%` }} 
                 />
             </div>
         </div>

         {/* FILTERS */}
         <div className="flex gap-2 mb-4">
             <div className="relative flex-1">
                 <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
                 <input 
                    type="text" 
                    placeholder="Search blueprints..."
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    className="w-full bg-zinc-900 border border-zinc-800 rounded-lg py-2.5 pl-9 pr-4 text-xs text-white focus:border-zinc-600 outline-none"
                 />
             </div>
             <button 
                onClick={() => setFilterMode(filterMode === 'ALL' ? 'NEEDED' : 'ALL')}
                className={`px-3 rounded-lg border flex items-center justify-center gap-2 transition-all
                    ${filterMode === 'NEEDED' ? 'bg-zinc-800 border-zinc-600 text-white' : 'bg-zinc-900 border-zinc-800 text-zinc-500'}
                `}
             >
                 <Filter className="w-4 h-4" />
                 <span className="text-[10px] font-bold uppercase hidden sm:inline">Needed</span>
             </button>
         </div>

         {/* BLUEPRINT LIST */}
         <div className="space-y-2">
             {displayBPs.map((bp) => {
                 const isLearned = learnedIds.includes(bp.id);
                 return (
                     <button
                        key={bp.id}
                        onClick={() => toggleLearn(bp.id)}
                        className={`w-full flex items-center justify-between p-3 rounded-xl border transition-all active:scale-[0.98] group
                            ${isLearned 
                                ? 'bg-zinc-900/30 border-zinc-800 opacity-60' 
                                : 'bg-[#18181b] border-zinc-700 hover:border-zinc-500 shadow-md'}
                        `}
                     >
                         <div className="flex items-center gap-4">
                             {/* Item Image */}
                             <div className={`w-12 h-12 rounded-lg flex items-center justify-center bg-black/40 border p-1
                                 ${isLearned ? 'border-zinc-800 grayscale' : 'border-zinc-700'}
                             `}>
                                 <img src={bp.image} alt={bp.name} className="w-full h-full object-contain" loading="lazy" />
                             </div>
                             
                             <div className="text-left">
                                 <div className={`text-sm font-bold leading-tight mb-1 ${isLearned ? 'text-zinc-500 line-through' : 'text-white'}`}>
                                     {bp.name}
                                 </div>
                                 <div className="flex items-center gap-2">
                                     <span className="text-[10px] font-mono font-bold text-zinc-400 bg-zinc-900/50 px-1.5 py-0.5 rounded border border-zinc-800">
                                         {bp.cost} Scrap
                                     </span>
                                     <span className="text-[9px] text-zinc-600 uppercase font-bold tracking-wide">
                                         {bp.category}
                                     </span>
                                 </div>
                             </div>
                         </div>
                         
                         {/* Checkbox Status */}
                         <div className={`w-6 h-6 rounded-full flex items-center justify-center border-2 transition-all
                             ${isLearned 
                                 ? 'bg-green-500 border-green-500 text-black' 
                                 : 'border-zinc-700 text-transparent group-hover:border-zinc-500'}
                         `}>
                             <Check className="w-4 h-4 stroke-[3]" />
                         </div>
                     </button>
                 );
             })}
             
             {displayBPs.length === 0 && (
                 <div className="text-center py-10 text-zinc-500 text-xs italic">
                     No blueprints found matching your filter.
                 </div>
             )}
         </div>

      </div>
    </div>
  );
};
