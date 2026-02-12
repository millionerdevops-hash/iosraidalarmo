
import React, { useState, useMemo } from 'react';
import { 
  ArrowLeft, 
  Search, 
  Clock, 
  Home, 
  Car, 
  Box, 
  Skull, 
  AlertTriangle,
  Info
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { DECAY_DATA, DecayCategory } from '../data/decayData';

interface DecayTimersScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

const CATEGORIES: { id: DecayCategory | 'ALL'; label: string; icon: any; color: string }[] = [
    { id: 'ALL', label: 'All', icon: List, color: 'text-white' },
    { id: 'Structure', label: 'Building', icon: Home, color: 'text-orange-500' },
    { id: 'Deployable', label: 'Items', icon: Box, color: 'text-blue-400' },
    { id: 'Vehicle', label: 'Vehicles', icon: Car, color: 'text-green-500' },
    { id: 'Despawn', label: 'Despawn', icon: Skull, color: 'text-red-500' },
    { id: 'Trap', label: 'Traps', icon: AlertTriangle, color: 'text-yellow-500' }
];

import { List } from 'lucide-react';

export const DecayTimersScreen: React.FC<DecayTimersScreenProps> = ({ onNavigate }) => {
  const [activeCategory, setActiveCategory] = useState<DecayCategory | 'ALL'>('ALL');
  const [search, setSearch] = useState('');

  const filteredData = useMemo(() => {
      return DECAY_DATA.filter(item => {
          const matchesCat = activeCategory === 'ALL' || item.category === activeCategory;
          const matchesSearch = item.name.toLowerCase().includes(search.toLowerCase());
          return matchesCat && matchesSearch;
      }).sort((a, b) => a.seconds - b.seconds);
  }, [activeCategory, search]);

  const getCategoryColor = (cat: DecayCategory) => {
      return CATEGORIES.find(c => c.id === cat)?.color || 'text-zinc-400';
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
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
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Decay Timers</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Life Cycle Database</p>
            </div>
        </div>
      </div>

      {/* Filter & Search */}
      <div className="bg-[#0c0c0e] sticky top-0 z-20 pb-2 border-b border-zinc-900">
          
          {/* Search */}
          <div className="px-4 py-3">
             <div className="relative group">
                 <div className="absolute inset-y-0 left-3 flex items-center pointer-events-none">
                     <Search className="w-4 h-4 text-zinc-500" />
                 </div>
                 <input 
                    type="text" 
                    placeholder="Search item or structure..." 
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    className="w-full bg-zinc-900 border border-zinc-800 rounded-xl py-3 pl-10 pr-4 text-sm text-white placeholder:text-zinc-600 focus:border-zinc-600 focus:outline-none transition-all font-mono"
                 />
             </div>
          </div>

          {/* Categories */}
          <div className="flex gap-2 overflow-x-auto no-scrollbar px-4 pb-2">
              {CATEGORIES.map((cat) => (
                  <button
                      key={cat.id}
                      onClick={() => setActiveCategory(cat.id as any)}
                      className={`px-3 py-2 rounded-lg text-[10px] font-bold uppercase transition-all whitespace-nowrap border flex items-center gap-2
                          ${activeCategory === cat.id 
                              ? 'bg-zinc-800 border-zinc-600 text-white shadow-lg' 
                              : 'bg-zinc-900 border-zinc-800 text-zinc-500 hover:text-zinc-300'}
                      `}
                  >
                      <cat.icon className={`w-3 h-3 ${activeCategory === cat.id ? cat.color : 'text-zinc-500'}`} />
                      {cat.label}
                  </button>
              ))}
          </div>
      </div>

      {/* Content List */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-4 pb-20 space-y-3">
         
         {/* Info Box for Despawn Context */}
         {activeCategory === 'Despawn' && (
             <div className="bg-red-900/10 border border-red-500/20 p-3 rounded-xl flex gap-3 mb-2">
                 <Info className="w-5 h-5 text-red-400 shrink-0 mt-0.5" />
                 <p className="text-[10px] text-red-200/80 leading-relaxed">
                     Despawn timers start when an item is dropped on the ground. Timers reset if the item is picked up or moved. Server lag can slightly extend these times.
                 </p>
             </div>
         )}

         {filteredData.length === 0 ? (
             <div className="flex flex-col items-center justify-center py-20 opacity-50">
                 <Clock className="w-12 h-12 text-zinc-700 mb-4" />
                 <span className="text-zinc-500 font-mono text-xs uppercase tracking-widest">No Data Found</span>
             </div>
         ) : (
             filteredData.map((item) => (
                 <div 
                    key={item.id}
                    className="bg-[#121214] border border-zinc-800 rounded-xl p-3 flex items-center gap-4 hover:border-zinc-700 transition-all group"
                 >
                     {/* Image */}
                     <div className="w-12 h-12 rounded-lg bg-black/40 flex items-center justify-center border border-zinc-800 relative shrink-0">
                         <img src={item.image} alt={item.name} className="w-10 h-10 object-contain drop-shadow-md group-hover:scale-110 transition-transform" />
                         {/* Category Icon Badge */}
                         <div className="absolute -top-1.5 -left-1.5 bg-zinc-900 border border-zinc-700 rounded-full p-0.5">
                             {CATEGORIES.find(c => c.id === item.category)?.icon && React.createElement(CATEGORIES.find(c => c.id === item.category)!.icon, { className: `w-3 h-3 ${getCategoryColor(item.category)}` })}
                         </div>
                     </div>

                     {/* Details */}
                     <div className="flex-1 min-w-0">
                         <div className="flex justify-between items-start">
                             <h3 className="text-sm font-bold text-white truncate pr-2">{item.name}</h3>
                             <span className={`text-xs font-black font-mono whitespace-nowrap ${
                                 item.category === 'Despawn' ? 'text-red-400' : 
                                 item.category === 'Structure' ? 'text-orange-400' : 'text-green-400'
                             }`}>
                                 {item.time}
                             </span>
                         </div>
                         
                         <div className="flex items-center justify-between mt-1">
                             <span className="text-[10px] text-zinc-500 uppercase font-bold tracking-wide">
                                 {item.category === 'Despawn' ? 'Disappears In' : 'Full Decay In'}
                             </span>
                             {item.notes && (
                                 <span className="text-[9px] text-zinc-600 italic truncate max-w-[150px]">
                                     {item.notes}
                                 </span>
                             )}
                         </div>
                     </div>
                 </div>
             ))
         )}

         {/* Footer Note */}
         <div className="text-center pt-6 pb-2">
             <p className="text-[9px] text-zinc-600">
                 * Timers assume standard vanilla server rates. Modded servers may vary.
             </p>
         </div>

      </div>
    </div>
  );
};
