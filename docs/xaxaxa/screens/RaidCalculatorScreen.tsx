
import React, { useState, useMemo, useEffect } from 'react';
import { 
  ArrowLeft, 
  Minus, 
  Plus, 
  Droplet, 
  Filter,
  ShoppingCart,
  Trash2,
  Hammer,
  Flame
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { 
    TARGETS, 
    RAID_METHODS,
    getAmmo,
    RaidTarget,
    RaidMethod
} from '../data/raidData';
import { ExplosiveCard } from '../components/raid/ExplosiveCard';
import { RaidCategoryTabs } from '../components/raid/RaidCategoryTabs';
import { RaidTargetGrid } from '../components/raid/RaidTargetGrid';

interface RaidCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

interface CartItem {
    id: string; // unique instance id
    target: RaidTarget;
    method: RaidMethod;
    count: number;
    sulfurCost: number;
}

export const RaidCalculatorScreen: React.FC<RaidCalculatorScreenProps> = ({ onNavigate }) => {
  const [selectedTargetId, setSelectedTargetId] = useState('sheet_door');
  const [count, setCount] = useState(1);
  const [activeCategory, setActiveCategory] = useState<'construction' | 'door' | 'item' | 'placeable'>('door');
  const [sortMethod, setSortMethod] = useState<'sulfur' | 'qty'>('sulfur');
  
  // --- RAID CART STATE ---
  const [raidCart, setRaidCart] = useState<CartItem[]>([]);
  const [showCart, setShowCart] = useState(false);

  // Derived
  const target = TARGETS.find(t => t.id === selectedTargetId) || TARGETS[0];
  const filteredTargets = TARGETS.filter(t => t.category === activeCategory);

  const increment = () => setCount(prev => Math.min(prev + 1, 100));
  const decrement = () => setCount(prev => Math.max(prev - 1, 1));

  // --- CALCULATION LOGIC ---
  const calculateMethods = () => {
      const validMethods = RAID_METHODS.filter(m => {
          let damage = m.damage;
          if (m.damageOverride && m.damageOverride[target.id]) {
              damage = m.damageOverride[target.id];
          }
          if (damage <= 0) return false;
          if (m.isEco && (target.tier === 'hqm' || target.tier === 'metal')) {
              if (target.category === 'construction' || target.category === 'door') return false; 
          }
          return true;
      });

      return validMethods.sort((a, b) => {
          const ammoA = getAmmo(a.ammoId);
          const ammoB = getAmmo(b.ammoId);
          if (!ammoA || !ammoB) return 0;

          const damageA = (a.damageOverride && a.damageOverride[target.id]) || a.damage;
          const damageB = (b.damageOverride && b.damageOverride[target.id]) || b.damage;

          const shotsA = Math.ceil(target.hp / damageA) * count;
          const sulfurA = shotsA * ammoA.sulfurCost;
          
          const shotsB = Math.ceil(target.hp / damageB) * count;
          const sulfurB = shotsB * ammoB.sulfurCost;

          if (sortMethod === 'sulfur') {
              if (sulfurA === 0 && sulfurB > 0) return -1;
              if (sulfurB === 0 && sulfurA > 0) return 1;
              return sulfurA - sulfurB;
          } else {
              return shotsA - shotsB;
          }
      });
  };

  const methods = calculateMethods();

  // --- CART ACTIONS ---
  const addToCart = (method: RaidMethod) => {
      const ammo = getAmmo(method.ammoId);
      if (!ammo) return;

      const damage = (method.damageOverride && method.damageOverride[target.id]) || method.damage;
      const shots = Math.ceil(target.hp / damage) * count;
      const sulfurTotal = shots * ammo.sulfurCost;

      const newItem: CartItem = {
          id: Date.now().toString() + Math.random(),
          target: target,
          method: method,
          count: count,
          sulfurCost: sulfurTotal
      };

      setRaidCart(prev => [...prev, newItem]);
      
      // Feedback
      // (Optional: Toast logic could go here)
  };

  const removeFromCart = (id: string) => {
      setRaidCart(prev => prev.filter(i => i.id !== id));
  };

  const clearCart = () => {
      if (confirm("Clear your raid plan?")) setRaidCart([]);
  };

  // --- TOTALS AGGREGATION ---
  const totals = useMemo(() => {
      const result = {
          sulfur: 0,
          gunpowder: 0,
          fuel: 0,
          metal: 0,
          charcoal: 0
      };

      raidCart.forEach(item => {
          const ammo = getAmmo(item.method.ammoId);
          if (!ammo) return;

          const damage = (item.method.damageOverride && item.method.damageOverride[item.target.id]) || item.method.damage;
          const shotsPerTarget = Math.ceil(item.target.hp / damage);
          const totalShots = shotsPerTarget * item.count;

          result.sulfur += (ammo.recipe.sulfur || 0) * totalShots;
          result.gunpowder += (ammo.recipe.gunpowder || 0) * totalShots;
          result.fuel += (ammo.recipe.fuel || 0) * totalShots;
          result.metal += (ammo.recipe.metal || 0) * totalShots;
          result.charcoal += (ammo.recipe.charcoal || 0) * totalShots;
      });

      return result;
  }, [raidCart]);

  const hasItems = raidCart.length > 0;

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between relative bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Raid Calculator</h2>
                <div className="flex items-center gap-2">
                    <span className="text-zinc-500 text-xs font-mono uppercase tracking-wider">
                        {showCart ? 'Raid Planner' : 'Select Method'}
                    </span>
                    {hasItems && !showCart && (
                        <span className="bg-orange-600 text-white text-[9px] font-bold px-1.5 py-0.5 rounded-full animate-pulse">
                            {raidCart.length} Items
                        </span>
                    )}
                </div>
            </div>
        </div>
        
        <button 
            onClick={() => setShowCart(!showCart)}
            className={`w-12 h-12 rounded-xl flex items-center justify-center transition-all relative
                ${showCart ? 'bg-orange-600 text-white shadow-lg shadow-orange-900/40' : 'bg-zinc-900 border border-zinc-800 text-zinc-400'}
            `}
        >
            <ShoppingCart className="w-5 h-5" />
            {hasItems && !showCart && (
                <div className="absolute -top-1 -right-1 w-4 h-4 bg-red-500 rounded-full border-2 border-[#0c0c0e]" />
            )}
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar pb-40">
         
         {showCart ? (
             // --- VIEW: SHOPPING CART ---
             <div className="p-4 space-y-4 animate-in slide-in-from-right duration-300">
                 {raidCart.length === 0 ? (
                     <div className="text-center py-20 opacity-50">
                         <ShoppingCart className="w-12 h-12 mx-auto mb-3 text-zinc-600" />
                         <p className="text-zinc-500 font-mono text-sm">Your raid plan is empty.</p>
                         <button onClick={() => setShowCart(false)} className="mt-4 text-orange-500 text-xs font-bold uppercase hover:underline">
                             Add Targets
                         </button>
                     </div>
                 ) : (
                     <>
                        <div className="flex justify-between items-center px-1">
                            <span className="text-xs font-bold text-zinc-500 uppercase tracking-widest">Raid Plan</span>
                            <button onClick={clearCart} className="text-[10px] text-red-500 flex items-center gap-1 hover:underline">
                                <Trash2 className="w-3 h-3" /> Clear All
                            </button>
                        </div>

                        <div className="space-y-2">
                            {raidCart.map((item) => {
                                const ammo = getAmmo(item.method.ammoId);
                                return (
                                    <div key={item.id} className="bg-[#121214] border border-zinc-800 rounded-xl p-3 flex items-center justify-between group">
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 rounded-lg bg-black/40 border border-zinc-700 flex items-center justify-center p-1 relative">
                                                <img src={item.target.img} className="w-full h-full object-contain" alt="" />
                                                <div className="absolute -top-1.5 -left-1.5 bg-zinc-800 text-white text-[9px] font-black w-4 h-4 flex items-center justify-center rounded-full border border-zinc-600">
                                                    {item.count}
                                                </div>
                                            </div>
                                            <div>
                                                <div className="text-xs font-bold text-white">{item.target.label}</div>
                                                <div className="flex items-center gap-1 text-[10px] text-zinc-500">
                                                    <img src={ammo.img} className="w-3 h-3 object-contain" alt="" />
                                                    via {ammo.name.replace('Rocket', '').trim()}
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div className="flex items-center gap-3">
                                            <div className="text-right">
                                                <div className="text-yellow-500 font-mono font-bold text-sm">
                                                    {item.sulfurCost.toLocaleString()}
                                                </div>
                                                <div className="text-[8px] text-zinc-600 uppercase font-bold">Sulfur</div>
                                            </div>
                                            <button 
                                                onClick={() => removeFromCart(item.id)}
                                                className="w-8 h-8 flex items-center justify-center rounded-lg bg-zinc-900 text-zinc-600 hover:text-red-500 hover:bg-red-900/10 transition-colors"
                                            >
                                                <Trash2 className="w-4 h-4" />
                                            </button>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                        
                        <div className="p-4 bg-blue-900/10 border border-blue-500/20 rounded-xl text-center mt-6">
                            <p className="text-blue-200/70 text-[10px] italic">
                                "Tip: Group raid cost includes crafting of explosives, ammo, and required fuel."
                            </p>
                        </div>
                     </>
                 )}
             </div>
         ) : (
             // --- VIEW: CALCULATOR ---
             <>
                {/* 1. Category Tabs */}
                <RaidCategoryTabs 
                    activeCategory={activeCategory} 
                    onSelect={(cat) => { setActiveCategory(cat); setSelectedTargetId(TARGETS.find(t=>t.category === cat)?.id || ''); }} 
                />

                {/* 2. Sticky Action Bar */}
                <div className="sticky top-0 z-20 bg-[#0c0c0e]/95 backdrop-blur-md border-y border-zinc-800 px-4 py-4 shadow-2xl mb-4">
                    <div className="flex items-center justify-between gap-4">
                        <div className="flex-1">
                            <span className="text-[10px] font-black text-zinc-500 uppercase tracking-widest block mb-1">Targeting</span>
                            <span className="text-white font-black uppercase text-xl leading-none block mb-1 truncate">{target.label}</span>
                            <span className="text-[10px] text-zinc-400 font-mono bg-zinc-900 px-1.5 py-0.5 rounded border border-zinc-800">{target.hp} HP</span>
                        </div>
                        
                        <div className="flex items-center gap-3 bg-black rounded-lg p-1 border border-zinc-800">
                            <button onClick={decrement} className="w-10 h-10 rounded bg-zinc-900 text-zinc-400 hover:text-white flex items-center justify-center transition-colors active:scale-95">
                                <Minus className="w-5 h-5" />
                            </button>
                            <span className="w-8 text-center font-mono text-xl font-bold text-white tabular-nums">{count}</span>
                            <button onClick={increment} className="w-10 h-10 rounded bg-orange-600 text-white flex items-center justify-center shadow-lg shadow-orange-900/20 transition-colors active:scale-95">
                                <Plus className="w-5 h-5" />
                            </button>
                        </div>
                    </div>
                </div>

                {/* 3. Target Grid */}
                <RaidTargetGrid 
                    targets={filteredTargets} 
                    selectedId={selectedTargetId} 
                    onSelect={setSelectedTargetId} 
                />

                {/* 4. Results List */}
                <div className="px-4 space-y-2">
                    <div className="flex items-center justify-between mb-3 px-1">
                        <div className="flex items-center gap-2">
                            <Filter className="w-3 h-3 text-orange-500" />
                            <span className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest">
                                Tap to Add
                            </span>
                        </div>
                        <div className="flex bg-zinc-900 rounded p-0.5 border border-zinc-800">
                            <button onClick={() => setSortMethod('sulfur')} className={`px-2 py-0.5 text-[9px] font-bold uppercase rounded ${sortMethod === 'sulfur' ? 'bg-zinc-700 text-white' : 'text-zinc-500'}`}>Sulfur</button>
                            <button onClick={() => setSortMethod('qty')} className={`px-2 py-0.5 text-[9px] font-bold uppercase rounded ${sortMethod === 'qty' ? 'bg-zinc-700 text-white' : 'text-zinc-500'}`}>Count</button>
                        </div>
                    </div>

                    {methods.map((method) => (
                        <button 
                            key={method.id}
                            onClick={() => addToCart(method)}
                            className="w-full text-left active:scale-[0.98] transition-transform"
                        >
                            <ExplosiveCard 
                                method={method}
                                targetQty={count}
                                targetHp={target.hp}
                                targetId={target.id}
                            />
                        </button>
                    ))}
                </div>
             </>
         )}

      </div>

      {/* FOOTER: TOTAL COST SUMMARY (Only if cart has items) */}
      {hasItems && (
          <div className="absolute bottom-0 left-0 right-0 bg-[#121214] border-t border-zinc-800 p-4 pb-8 z-30 shadow-[0_-10px_30px_rgba(0,0,0,0.5)] animate-in slide-in-from-bottom duration-300">
              <div className="flex justify-between items-center mb-3">
                  <span className="text-[10px] font-black text-zinc-500 uppercase tracking-widest">
                      Total Materials Required
                  </span>
                  {!showCart && (
                      <button onClick={() => setShowCart(true)} className="text-[10px] font-bold text-orange-500 uppercase hover:text-white">
                          View List
                      </button>
                  )}
              </div>
              
              <div className="grid grid-cols-4 gap-2">
                  <div className="bg-black/40 border border-yellow-500/20 rounded-lg p-2 flex flex-col items-center">
                      <div className="text-[9px] text-yellow-600 font-bold uppercase mb-0.5">Sulfur</div>
                      <div className="text-white font-mono font-black text-sm">{totals.sulfur.toLocaleString()}</div>
                  </div>
                  <div className="bg-black/40 border border-zinc-800 rounded-lg p-2 flex flex-col items-center">
                      <div className="text-[9px] text-zinc-500 font-bold uppercase mb-0.5">GP</div>
                      <div className="text-zinc-300 font-mono font-bold text-sm">{totals.gunpowder.toLocaleString()}</div>
                  </div>
                  <div className="bg-black/40 border border-zinc-800 rounded-lg p-2 flex flex-col items-center">
                      <div className="text-[9px] text-zinc-500 font-bold uppercase mb-0.5">Charcoal</div>
                      <div className="text-zinc-300 font-mono font-bold text-sm">{totals.charcoal.toLocaleString()}</div>
                  </div>
                  <div className="bg-black/40 border border-zinc-800 rounded-lg p-2 flex flex-col items-center">
                      <div className="text-[9px] text-zinc-500 font-bold uppercase mb-0.5">Frags</div>
                      <div className="text-zinc-300 font-mono font-bold text-sm">{totals.metal.toLocaleString()}</div>
                  </div>
              </div>
          </div>
      )}

    </div>
  );
};
