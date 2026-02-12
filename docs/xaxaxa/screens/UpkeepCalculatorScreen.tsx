import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Minus, 
  Plus, 
  Trash2,
  Home,
  Box,
  DoorOpen,
  Triangle,
  Square,
  ArrowUp,
  Clock
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface UpkeepCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// Tier types
type BuildingTier = 'wood' | 'stone' | 'metal' | 'hqm';

interface BuildingBlock {
    id: string;
    name: string;
    icon: any;
    baseCost: number; // Cost in the selected tier material
}

const BLOCKS: BuildingBlock[] = [
    { id: 'foundation', name: 'Square Found.', icon: Square, baseCost: 50 },
    { id: 'triangle_foundation', name: 'Tri. Found.', icon: Triangle, baseCost: 25 },
    { id: 'wall', name: 'Wall', icon: Box, baseCost: 50 },
    { id: 'doorway', name: 'Doorway', icon: DoorOpen, baseCost: 35 }, // Actually 50 usually but wall frames are tricky, stick to standard wall cost for simplicity or split? Standard wall is 50.
    { id: 'floor', name: 'Floor / Roof', icon: ArrowUp, baseCost: 25 },
];

const TIER_CONFIG: Record<BuildingTier, { label: string, color: string, materialName: string }> = {
    wood: { label: 'Wood', color: 'text-amber-600', materialName: 'Wood' },
    stone: { label: 'Stone', color: 'text-zinc-400', materialName: 'Stone' },
    metal: { label: 'Sheet Metal', color: 'text-orange-600', materialName: 'Metal Frags' },
    hqm: { label: 'Armored', color: 'text-zinc-300', materialName: 'HQM' }
};

export const UpkeepCalculatorScreen: React.FC<UpkeepCalculatorScreenProps> = ({ onNavigate }) => {
  // State: quantities for each block in each tier
  // e.g. { 'wood': { 'foundation': 5 }, 'stone': { 'wall': 10 } }
  const [quantities, setQuantities] = useState<Record<BuildingTier, Record<string, number>>>({
      wood: {},
      stone: {},
      metal: {},
      hqm: {}
  });

  const [activeTier, setActiveTier] = useState<BuildingTier>('stone');

  const updateQuantity = (blockId: string, delta: number) => {
      setQuantities(prev => {
          const tierData = prev[activeTier];
          const current = tierData[blockId] || 0;
          const next = Math.max(0, current + delta);
          
          return {
              ...prev,
              [activeTier]: {
                  ...tierData,
                  [blockId]: next
              }
          };
      });
  };

  const clearAll = () => setQuantities({ wood: {}, stone: {}, metal: {}, hqm: {} });

  // --- CALCULATION LOGIC ---
  // Upkeep is calculated based on total blocks of a material.
  // Brackets: 
  // 1-15 blocks: 10%
  // 16-50 blocks: 15%
  // 51-125 blocks: 20%
  // 126+ blocks: 33%
  
  const calculateTierStats = (tier: BuildingTier) => {
      const tierData = quantities[tier];
      let totalBlocks = 0;
      let totalBuildCost = 0;

      Object.entries(tierData).forEach(([blockId, val]) => {
          const count = val as number;
          if (count > 0) {
              const block = BLOCKS.find(b => b.id === blockId);
              if (block) {
                  totalBlocks += count;
                  totalBuildCost += count * block.baseCost;
              }
          }
      });

      // Upkeep Calculation
      let upkeepCost = 0;
      
      if (totalBlocks > 0) {
         // This is a simplified per-block iterative approach or bracket approach
         // Rust calculates upkeep by summing the cost * bracket_tax for the whole base.
         // Actually, the bracket applies to the *number of blocks*.
         // It's cumulative.
         
         // 10% for first 15 blocks
         const b1 = Math.min(totalBlocks, 15);
         // 15% for next 35 (15 to 50)
         const b2 = Math.min(Math.max(0, totalBlocks - 15), 35);
         // 20% for next 75 (50 to 125)
         const b3 = Math.min(Math.max(0, totalBlocks - 50), 75);
         // 33.3% for remaining
         const b4 = Math.max(0, totalBlocks - 125);

         // We need average cost per block to apply tax accurately, but blocks have different costs.
         // Rust applies the tax to the TOTAL COST of the materials, but the tax RATE is determined by the number of ID's.
         // So: Upkeep = TotalCost * EffectiveTaxRate.
         
         let taxNumerator = (b1 * 0.10) + (b2 * 0.15) + (b3 * 0.20) + (b4 * 0.333);
         let effectiveTaxRate = taxNumerator / totalBlocks;
         
         upkeepCost = totalBuildCost * effectiveTaxRate;
      }

      return { totalBuildCost, upkeepCost: Math.ceil(upkeepCost), totalBlocks };
  };

  const totals = {
      wood: calculateTierStats('wood'),
      stone: calculateTierStats('stone'),
      metal: calculateTierStats('metal'),
      hqm: calculateTierStats('hqm')
  };

  const hasItems = Object.values(totals).some(t => t.totalBlocks > 0);

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Base Calc</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Build Cost & Upkeep</p>
            </div>
        </div>
        <button 
           onClick={clearAll}
           disabled={!hasItems}
           className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-red-500 hover:bg-red-900/10 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
        >
           <Trash2 className="w-5 h-5" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar pb-40">
         
         {/* Tier Selector */}
         <div className="p-4 pb-2">
            <div className="flex bg-zinc-900 p-1 rounded-xl border border-zinc-800">
                {(Object.keys(TIER_CONFIG) as BuildingTier[]).map((tier) => (
                    <button
                        key={tier}
                        onClick={() => setActiveTier(tier)}
                        className={`flex-1 py-2.5 rounded-lg text-xs font-bold uppercase transition-all
                            ${activeTier === tier 
                                ? 'bg-[#0c0c0e] text-white shadow-lg border border-zinc-700' 
                                : 'text-zinc-500 hover:text-zinc-300'}
                        `}
                    >
                        {TIER_CONFIG[tier].label}
                    </button>
                ))}
            </div>
         </div>

         {/* Building Blocks */}
         <div className="p-4 space-y-3">
             {BLOCKS.map((block) => {
                 const qty = quantities[activeTier][block.id] || 0;
                 return (
                     <div key={block.id} className={`flex items-center justify-between p-3 rounded-xl border transition-all ${qty > 0 ? 'bg-zinc-900 border-zinc-600' : 'bg-zinc-900/30 border-zinc-800'}`}>
                         <div className="flex items-center gap-3">
                             <div className={`w-12 h-12 rounded-lg flex items-center justify-center border transition-colors
                                ${qty > 0 ? 'bg-zinc-800 border-zinc-600' : 'bg-zinc-900 border-zinc-800'}
                             `}>
                                 <block.icon className={`w-6 h-6 ${qty > 0 ? TIER_CONFIG[activeTier].color : 'text-zinc-600'}`} />
                             </div>
                             <div>
                                 <div className={`font-bold text-sm ${qty > 0 ? 'text-white' : 'text-zinc-400'}`}>{block.name}</div>
                                 <div className="text-[10px] text-zinc-600 font-mono">
                                     Cost: {block.baseCost} {TIER_CONFIG[activeTier].materialName}
                                 </div>
                             </div>
                         </div>
                         
                         <div className="flex items-center gap-2">
                             {qty > 0 && (
                                 <span className="font-mono text-lg font-bold text-white mr-2 w-6 text-center">{qty}</span>
                             )}
                             <button 
                                onClick={() => updateQuantity(block.id, -1)}
                                className="w-10 h-10 rounded-lg bg-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white active:scale-90 transition-all border border-zinc-700"
                             >
                                 <Minus className="w-5 h-5" />
                             </button>
                             <button 
                                onClick={() => updateQuantity(block.id, 1)}
                                className="w-10 h-10 rounded-lg bg-zinc-800 flex items-center justify-center text-white active:scale-90 transition-all border border-zinc-600 hover:bg-zinc-700"
                             >
                                 <Plus className="w-5 h-5" />
                             </button>
                         </div>
                     </div>
                 );
             })}
         </div>

      </div>

      {/* FIXED BOTTOM RESULT BAR */}
      <div className="absolute bottom-0 left-0 right-0 bg-[#121214] border-t border-zinc-800 p-4 pb-8 shadow-[0_-10px_40px_rgba(0,0,0,0.5)] z-20">
          <div className="flex justify-between items-center mb-3">
              <span className="text-zinc-500 text-xs font-bold uppercase tracking-widest">Required Resources</span>
              <Clock className="w-4 h-4 text-zinc-600" />
          </div>
          
          <div className="space-y-2">
              {/* Only show tiers that have costs */}
              {Object.entries(totals).map(([tierKey, stats]) => {
                  if (stats.totalBlocks === 0) return null;
                  const tier = tierKey as BuildingTier;
                  
                  return (
                    <div key={tier} className="bg-black/40 rounded-xl p-3 border border-zinc-800 flex justify-between items-center">
                        <div className="flex items-center gap-2">
                            <div className={`w-2 h-2 rounded-full ${tier === 'wood' ? 'bg-amber-600' : tier === 'metal' ? 'bg-orange-600' : tier === 'hqm' ? 'bg-zinc-300' : 'bg-zinc-500'}`} />
                            <span className="text-xs font-bold uppercase text-zinc-400">{TIER_CONFIG[tier].label}</span>
                        </div>
                        <div className="text-right">
                             <div className="flex gap-4 text-sm font-mono font-bold">
                                 <span className="text-zinc-500 flex flex-col items-end leading-none">
                                     <span className="text-[10px] uppercase font-bold mb-0.5">Build</span>
                                     {stats.totalBuildCost.toLocaleString()}
                                 </span>
                                 <span className="text-white flex flex-col items-end leading-none">
                                     <span className="text-[10px] uppercase font-bold text-green-500 mb-0.5">24h Upkeep</span>
                                     {stats.upkeepCost.toLocaleString()}
                                 </span>
                             </div>
                        </div>
                    </div>
                  );
              })}
              
              {!hasItems && (
                  <div className="text-center py-4 text-zinc-600 text-xs italic">
                      Add blocks to see cost breakdown
                  </div>
              )}
          </div>
      </div>
    </div>
  );
};