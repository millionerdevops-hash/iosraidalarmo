
import React, { useState, useMemo } from 'react';
import { 
  ArrowLeft, 
  Search, 
  X, 
  ShoppingBag, 
  Hammer, 
  Shirt, 
  Heart, 
  Crosshair, 
  Zap, 
  Wrench, 
  Minus, 
  Plus, 
  Trash2, 
  Box,
  SearchX
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { CRAFTABLES, CraftCategory } from '../data/craftingData';

interface CraftingCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

const CATEGORIES: { id: CraftCategory | 'All'; label: string; icon: any }[] = [
    { id: 'All', label: 'All', icon: Box },
    { id: 'Weapon', label: 'Guns', icon: Crosshair },
    { id: 'Attire', label: 'Gear', icon: Shirt },
    { id: 'Meds', label: 'Meds', icon: Heart },
    { id: 'Ammo', label: 'Ammo', icon: Zap },
    { id: 'Build', label: 'Build', icon: Hammer },
    { id: 'Tool', label: 'Tools', icon: Wrench },
];

export const CraftingCalculatorScreen: React.FC<CraftingCalculatorScreenProps> = ({ onNavigate }) => {
  const [activeCategory, setActiveCategory] = useState<CraftCategory | 'All'>('All');
  const [search, setSearch] = useState('');
  const [cart, setCart] = useState<{ id: string; qty: number }[]>([]);

  // Filter Items
  const filteredItems = useMemo(() => {
      return CRAFTABLES.filter(item => {
          const matchesCat = activeCategory === 'All' || item.category === activeCategory;
          const matchesSearch = item.name.toLowerCase().includes(search.toLowerCase());
          return matchesCat && matchesSearch;
      });
  }, [activeCategory, search]);

  // Cart Management
  const addToCart = (id: string) => {
      setCart(prev => {
          const exists = prev.find(i => i.id === id);
          if (exists) return prev.map(i => i.id === id ? { ...i, qty: i.qty + 1 } : i);
          return [...prev, { id, qty: 1 }];
      });
  };

  const updateQty = (id: string, delta: number) => {
      setCart(prev => prev.map(i => {
          if (i.id === id) {
              const newQty = Math.max(0, i.qty + delta);
              return { ...i, qty: newQty };
          }
          return i;
      }).filter(i => i.qty > 0));
  };

  const clearCart = () => setCart([]);

  // Calculate Totals
  const totals = useMemo(() => {
      const result: Record<string, number> = {};
      cart.forEach(cartItem => {
          const itemDef = CRAFTABLES.find(c => c.id === cartItem.id);
          if (itemDef) {
              Object.entries(itemDef.recipe).forEach(([resource, amount]) => {
                  result[resource] = (result[resource] || 0) + (amount as number * cartItem.qty);
              });
          }
      });
      return result;
  }, [cart]);

  const hasTotals = Object.keys(totals).length > 0;

  // Helper to get formatted resource name
  const formatResource = (key: string) => {
      return key.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
  };

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
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Crafting Calc</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Item Resource Planner</p>
            </div>
        </div>
        <button 
            onClick={clearCart}
            disabled={cart.length === 0}
            className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-red-500 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
        >
            <Trash2 className="w-5 h-5" />
        </button>
      </div>

      {/* Controls */}
      <div className="bg-[#0c0c0e] border-b border-zinc-800/50 sticky top-0 z-20">
          {/* Search */}
          <div className="px-4 py-3">
             <div className="relative group">
                 <div className="absolute inset-y-0 left-3 flex items-center pointer-events-none">
                     <Search className="w-4 h-4 text-zinc-500" />
                 </div>
                 <input 
                    type="text" 
                    placeholder="Search items..." 
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl py-2.5 pl-10 pr-10 text-sm text-white focus:border-blue-500/50 focus:bg-zinc-900 focus:outline-none transition-all"
                 />
                 {search && (
                     <button onClick={() => setSearch('')} className="absolute inset-y-0 right-3 flex items-center text-zinc-500 hover:text-white">
                         <X className="w-4 h-4" />
                     </button>
                 )}
             </div>
          </div>

          {/* Categories */}
          <div className="flex gap-2 overflow-x-auto no-scrollbar px-4 pb-3">
              {CATEGORIES.map((cat) => (
                  <button
                      key={cat.id}
                      onClick={() => setActiveCategory(cat.id as any)}
                      className={`px-3 py-1.5 rounded-lg text-[10px] font-bold uppercase tracking-wide flex items-center gap-1.5 border transition-all whitespace-nowrap
                          ${activeCategory === cat.id 
                              ? 'bg-blue-600 text-white border-blue-500 shadow-lg shadow-blue-900/20' 
                              : 'bg-zinc-900 border-zinc-800 text-zinc-500 hover:bg-zinc-800 hover:text-zinc-300'}
                      `}
                  >
                      <cat.icon className="w-3 h-3" />
                      {cat.label}
                  </button>
              ))}
          </div>
      </div>

      {/* Content Grid */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-4 pb-48">
         {filteredItems.length === 0 ? (
             <div className="flex flex-col items-center justify-center pt-20 px-6 text-center animate-in fade-in zoom-in-95 duration-300">
                <div className="w-20 h-20 bg-zinc-900/50 rounded-full flex items-center justify-center mb-4 border border-zinc-800 shadow-[0_0_30px_rgba(0,0,0,0.2)]">
                    <SearchX className="w-10 h-10 text-zinc-600" />
                </div>
                <h3 className="text-white font-bold text-lg mb-2">No Blueprints Found</h3>
                <p className="text-zinc-500 text-xs max-w-[220px] leading-relaxed mb-6">
                    We couldn't find any items matching "{search}". Try checking your spelling or switching categories.
                </p>
                <button 
                    onClick={() => { setSearch(''); setActiveCategory('All'); }}
                    className="px-6 py-3 bg-zinc-900 border border-zinc-700 rounded-xl text-zinc-300 text-xs font-bold uppercase hover:bg-zinc-800 hover:text-white hover:border-zinc-500 transition-all active:scale-95"
                >
                    Clear Filters
                </button>
             </div>
         ) : (
             <div className="grid grid-cols-4 gap-2">
                 {filteredItems.map((item) => {
                     const inCart = cart.find(c => c.id === item.id);
                     return (
                         <button
                            key={item.id}
                            onClick={() => addToCart(item.id)}
                            className={`aspect-square rounded-xl relative overflow-hidden border transition-all active:scale-95 group flex flex-col items-center justify-center p-2
                                ${inCart ? 'bg-blue-900/20 border-blue-500/50' : 'bg-zinc-900/30 border-zinc-800 hover:bg-zinc-800'}
                            `}
                         >
                             <img src={item.image} alt={item.name} className="w-full h-full object-contain drop-shadow-lg" />
                             {inCart && (
                                 <div className="absolute top-1 right-1 bg-blue-600 text-white text-[9px] font-black w-5 h-5 flex items-center justify-center rounded-full shadow-lg">
                                     {inCart.qty}
                                 </div>
                             )}
                             <div className="absolute bottom-0 left-0 right-0 bg-black/60 backdrop-blur-[1px] py-1 px-1">
                                 <p className="text-[8px] text-zinc-300 text-center truncate leading-tight">{item.name}</p>
                             </div>
                         </button>
                     );
                 })}
             </div>
         )}
      </div>

      {/* Bottom Sheet: Shopping List */}
      {cart.length > 0 && (
          <div className="absolute bottom-0 left-0 right-0 bg-[#121214] border-t border-zinc-800 shadow-[0_-10px_40px_rgba(0,0,0,0.5)] z-30 animate-in slide-in-from-bottom duration-300 max-h-[50%] flex flex-col">
              
              {/* Handle */}
              <div className="w-full flex justify-center pt-3 pb-1 border-b border-zinc-800/50 cursor-pointer">
                  <div className="w-10 h-1 bg-zinc-800 rounded-full" />
              </div>

              <div className="flex-1 overflow-y-auto no-scrollbar p-4">
                  {/* Selected Items List */}
                  <div className="flex gap-2 overflow-x-auto no-scrollbar mb-4 pb-2 border-b border-zinc-800/50">
                      {cart.map((c) => {
                          const def = CRAFTABLES.find(i => i.id === c.id);
                          if (!def) return null;
                          return (
                              <div key={c.id} className="shrink-0 bg-zinc-900 rounded-lg p-2 flex items-center gap-2 border border-zinc-800">
                                  <img src={def.image} className="w-6 h-6 object-contain" alt="" />
                                  <div className="flex flex-col">
                                      <span className="text-[9px] text-zinc-400 leading-none truncate max-w-[60px]">{def.name}</span>
                                      <div className="flex items-center gap-2 mt-1">
                                          <button onClick={() => updateQty(c.id, -1)} className="hover:text-white text-zinc-500"><Minus className="w-3 h-3" /></button>
                                          <span className="text-xs font-bold text-white font-mono">{c.qty}</span>
                                          <button onClick={() => updateQty(c.id, 1)} className="hover:text-white text-zinc-500"><Plus className="w-3 h-3" /></button>
                                      </div>
                                  </div>
                              </div>
                          );
                      })}
                  </div>

                  {/* Totals Grid */}
                  <div className="space-y-3">
                      <div className="flex items-center gap-2">
                          <ShoppingBag className="w-4 h-4 text-blue-500" />
                          <span className="text-xs font-bold text-white uppercase tracking-wider">Required Resources</span>
                      </div>
                      
                      <div className="grid grid-cols-3 gap-2">
                          {Object.entries(totals).map(([key, val]) => (
                              <div key={key} className="bg-black/40 border border-zinc-800 rounded-lg p-2 flex flex-col items-center justify-center">
                                  <span className="text-white font-mono font-bold text-sm">{val.toLocaleString()}</span>
                                  <span className="text-[8px] text-zinc-500 uppercase font-bold text-center leading-none mt-0.5">{formatResource(key)}</span>
                              </div>
                          ))}
                      </div>
                  </div>
              </div>
          </div>
      )}

    </div>
  );
};
