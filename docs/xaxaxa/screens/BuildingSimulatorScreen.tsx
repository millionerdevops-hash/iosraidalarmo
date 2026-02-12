import React, { useState, useMemo } from 'react';
import { 
  ArrowLeft, 
  RotateCcw, 
  Layers, 
  DoorOpen, 
  Box, 
  Hammer,
  Eraser,
  Triangle,
  Square,
  Clock
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface BuildingSimulatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// --- CONSTANTS ---
type Tier = 'twig' | 'wood' | 'stone' | 'metal' | 'hqm';

interface Cost {
    wood: number;
    stone: number;
    metal: number;
    hqm: number;
}

const TIER_COLORS: Record<Tier, string> = {
    twig: 'bg-[#5c4033] border-[#3e2b22]', // Brownish
    wood: 'bg-[#855e42] border-[#5c4033]', // Wood
    stone: 'bg-[#71717a] border-[#52525b]', // Zinc-500
    metal: 'bg-[#ef4444] border-[#b91c1c]', // Red tint for sheet metal
    hqm: 'bg-[#3f3f46] border-[#27272a] shadow-inner', // Dark
};

const TIER_NAMES: Record<Tier, string> = {
    twig: 'Twig',
    wood: 'Wood',
    stone: 'Stone',
    metal: 'Sheet Metal',
    hqm: 'Armored'
};

// Costs per block (Foundation/Wall roughly similar for calc simplification)
// Upkeep per day is roughly ~10-33% depending on bracket. We'll use flat average for simplicity.
const COSTS: Record<Tier, { build: Cost; upkeep: Cost }> = {
    twig: { build: { wood: 50, stone: 0, metal: 0, hqm: 0 }, upkeep: { wood: 0, stone: 0, metal: 0, hqm: 0 } }, // Twig decays fast, no upkeep really
    wood: { build: { wood: 200, stone: 0, metal: 0, hqm: 0 }, upkeep: { wood: 30, stone: 0, metal: 0, hqm: 0 } },
    stone: { build: { wood: 0, stone: 300, metal: 0, hqm: 0 }, upkeep: { wood: 0, stone: 45, metal: 0, hqm: 0 } },
    metal: { build: { wood: 0, stone: 0, metal: 200, hqm: 0 }, upkeep: { wood: 0, stone: 0, metal: 30, hqm: 0 } },
    hqm: { build: { wood: 0, stone: 0, metal: 0, hqm: 25 }, upkeep: { wood: 0, stone: 0, metal: 0, hqm: 4 } }
};

const GRID_SIZE = 7; // 7x7 Grid

export const BuildingSimulatorScreen: React.FC<BuildingSimulatorScreenProps> = ({ onNavigate }) => {
  // Grid state: Key "x,y" -> Tier | null
  const [grid, setGrid] = useState<Record<string, Tier>>({});
  
  // Controls
  const [activeTier, setActiveTier] = useState<Tier>('stone');
  const [activeTool, setActiveTool] = useState<'paint' | 'erase'>('paint');
  
  // Vertical Counters (Manual additions)
  const [floors, setFloors] = useState(1);
  const [extraWalls, setExtraWalls] = useState(0); // Walls per floor roughly
  const [doors, setDoors] = useState(0);
  const [doorTier, setDoorTier] = useState<'sheet' | 'garage' | 'armored'>('sheet');

  // --- ACTIONS ---
  const handleCellClick = (x: number, y: number) => {
      const key = `${x},${y}`;
      if (activeTool === 'erase') {
          const newGrid = { ...grid };
          delete newGrid[key];
          setGrid(newGrid);
      } else {
          setGrid(prev => ({ ...prev, [key]: activeTier }));
      }
  };

  const clearGrid = () => {
      if(confirm('Clear entire layout?')) setGrid({});
  };

  // --- CALCULATIONS ---
  const stats = useMemo(() => {
      let buildCost: Cost = { wood: 0, stone: 0, metal: 0, hqm: 0 };
      let upkeepCost: Cost = { wood: 0, stone: 0, metal: 0, hqm: 0 };
      
      const foundationCount = Object.keys(grid).length;
      
      // 1. Foundations Calculation
      Object.values(grid).forEach((t) => {
          const tier = t as Tier;
          const c = COSTS[tier];
          buildCost.wood += c.build.wood;
          buildCost.stone += c.build.stone;
          buildCost.metal += c.build.metal;
          buildCost.hqm += c.build.hqm;

          upkeepCost.wood += c.upkeep.wood;
          upkeepCost.stone += c.upkeep.stone;
          upkeepCost.metal += c.upkeep.metal;
          upkeepCost.hqm += c.upkeep.hqm;
      });

      // 2. Vertical Calculation (Walls/Floors)
      // Assuming walls match the selected "Active Tier" for simplicity, or we can use the average tier of foundations.
      // Let's use 'activeTier' for the added walls to let user simulate different wall materials.
      if (floors > 0 && foundationCount > 0) {
          const wallTierCost = COSTS[activeTier];
          
          // Estimate Ceiling cost (Same as foundation count per floor above 1)
          const ceilingCount = foundationCount * (floors - 1);
          
          // Add Ceilings
          buildCost.wood += ceilingCount * wallTierCost.build.wood;
          buildCost.stone += ceilingCount * wallTierCost.build.stone;
          buildCost.metal += ceilingCount * wallTierCost.build.metal;
          buildCost.hqm += ceilingCount * wallTierCost.build.hqm;
          
          upkeepCost.wood += ceilingCount * wallTierCost.upkeep.wood;
          upkeepCost.stone += ceilingCount * wallTierCost.upkeep.stone;
          upkeepCost.metal += ceilingCount * wallTierCost.upkeep.metal;
          upkeepCost.hqm += ceilingCount * wallTierCost.upkeep.hqm;

          // Add Extra Walls (Manual Input)
          buildCost.wood += extraWalls * wallTierCost.build.wood;
          buildCost.stone += extraWalls * wallTierCost.build.stone;
          buildCost.metal += extraWalls * wallTierCost.build.metal;
          buildCost.hqm += extraWalls * wallTierCost.build.hqm;

          upkeepCost.wood += extraWalls * wallTierCost.upkeep.wood;
          upkeepCost.stone += extraWalls * wallTierCost.upkeep.stone;
          upkeepCost.metal += extraWalls * wallTierCost.upkeep.metal;
          upkeepCost.hqm += extraWalls * wallTierCost.upkeep.hqm;
      }

      // 3. Doors
      // Sheet: 150 Metal
      // Garage: 300 Metal + 2 Gears
      // Armored: 20 HQM + 5 Gears
      if (doors > 0) {
          if (doorTier === 'sheet') {
              buildCost.metal += doors * 150;
              // Upkeep is negligible for doors usually or covered by frame, simplified here
          } else if (doorTier === 'garage') {
              buildCost.metal += doors * 300;
          } else if (doorTier === 'armored') {
              buildCost.hqm += doors * 20;
          }
      }

      // Apply Bracket Tax (Rough Estimate)
      // If block count > 15, tax increases. We already used flat average in COST constant for simplicity.
      // But for display, let's just stick to the sum.

      return { buildCost, upkeepCost, foundationCount };
  }, [grid, floors, extraWalls, doors, doorTier, activeTier]);

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
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Base Builder</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Design & Upkeep Sim</p>
            </div>
        </div>
        <button 
            onClick={clearGrid}
            className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-red-500 hover:bg-red-900/10 transition-all"
        >
            <RotateCcw className="w-5 h-5" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 pb-48">
         
         {/* 1. GRID CANVAS */}
         <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-4 mb-4 shadow-xl flex flex-col items-center">
             <div className="grid grid-cols-7 gap-1.5 p-2 bg-[#0c0c0e] rounded-xl border border-zinc-800 shadow-inner">
                 {Array.from({ length: GRID_SIZE * GRID_SIZE }).map((_, i) => {
                     const x = i % GRID_SIZE;
                     const y = Math.floor(i / GRID_SIZE);
                     const key = `${x},${y}`;
                     const tier = grid[key];
                     
                     return (
                         <button
                            key={i}
                            onClick={() => handleCellClick(x, y)}
                            className={`w-9 h-9 rounded-md transition-all duration-100 flex items-center justify-center border-2 
                                ${tier 
                                    ? `${TIER_COLORS[tier]} shadow-sm` 
                                    : 'bg-[#18181b] border-transparent hover:border-zinc-700'}
                            `}
                         >
                             {tier && <div className="w-1.5 h-1.5 bg-black/20 rounded-full" />}
                         </button>
                     );
                 })}
             </div>
             <div className="mt-3 flex items-center gap-2 text-[10px] text-zinc-500 font-mono">
                 <Square className="w-3 h-3" /> Tap grid to place foundation
             </div>
         </div>

         {/* 2. TOOLBAR */}
         <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-2 mb-4 flex gap-2 overflow-x-auto no-scrollbar">
             <button 
                onClick={() => setActiveTool('erase')}
                className={`flex flex-col items-center justify-center w-14 h-14 rounded-lg border transition-all shrink-0
                    ${activeTool === 'erase' ? 'bg-red-900/40 border-red-500 text-red-400' : 'bg-zinc-900 border-zinc-700 text-zinc-500'}
                `}
             >
                 <Eraser className="w-5 h-5 mb-1" />
                 <span className="text-[8px] font-bold uppercase">Erase</span>
             </button>
             
             {(['twig', 'wood', 'stone', 'metal', 'hqm'] as Tier[]).map(tier => (
                 <button 
                    key={tier}
                    onClick={() => { setActiveTier(tier); setActiveTool('paint'); }}
                    className={`flex flex-col items-center justify-center w-14 h-14 rounded-lg border transition-all shrink-0
                        ${activeTier === tier && activeTool === 'paint'
                            ? `bg-zinc-800 border-white text-white shadow-lg` 
                            : 'bg-zinc-900 border-zinc-700 text-zinc-500'}
                    `}
                 >
                     <div className={`w-3 h-3 rounded-full mb-1 ${TIER_COLORS[tier].split(' ')[0]}`} />
                     <span className="text-[8px] font-bold uppercase">{TIER_NAMES[tier].split(' ')[0]}</span>
                 </button>
             ))}
         </div>

         {/* 3. VERTICAL SLIDERS (Walls/Floors) */}
         <div className="space-y-3 bg-[#18181b] border border-zinc-800 rounded-xl p-4 mb-20">
             
             <div className="flex items-center justify-between">
                 <div className="flex items-center gap-2 text-zinc-400">
                     <Layers className="w-4 h-4" />
                     <span className="text-xs font-bold uppercase">Floors</span>
                 </div>
                 <div className="flex items-center gap-3">
                     <button onClick={() => setFloors(Math.max(1, floors-1))} className="w-8 h-8 bg-zinc-900 rounded flex items-center justify-center hover:bg-zinc-800">-</button>
                     <span className="text-white font-mono font-bold w-4 text-center">{floors}</span>
                     <button onClick={() => setFloors(floors+1)} className="w-8 h-8 bg-zinc-900 rounded flex items-center justify-center hover:bg-zinc-800">+</button>
                 </div>
             </div>

             <div className="flex items-center justify-between">
                 <div className="flex items-center gap-2 text-zinc-400">
                     <Box className="w-4 h-4" />
                     <span className="text-xs font-bold uppercase">Walls (Total)</span>
                 </div>
                 <div className="flex items-center gap-3">
                     <button onClick={() => setExtraWalls(Math.max(0, extraWalls-1))} className="w-8 h-8 bg-zinc-900 rounded flex items-center justify-center hover:bg-zinc-800">-</button>
                     <span className="text-white font-mono font-bold w-6 text-center">{extraWalls}</span>
                     <button onClick={() => setExtraWalls(extraWalls+1)} className="w-8 h-8 bg-zinc-900 rounded flex items-center justify-center hover:bg-zinc-800">+</button>
                 </div>
             </div>

             <div className="flex items-center justify-between">
                 <div className="flex items-center gap-2 text-zinc-400">
                     <DoorOpen className="w-4 h-4" />
                     <span className="text-xs font-bold uppercase">Doors</span>
                 </div>
                 <div className="flex items-center gap-2">
                     {/* Door Tier Toggle */}
                     <button 
                        onClick={() => setDoorTier(doorTier === 'sheet' ? 'garage' : doorTier === 'garage' ? 'armored' : 'sheet')}
                        className="px-2 py-1 bg-zinc-900 rounded text-[9px] font-bold uppercase border border-zinc-700 min-w-[50px]"
                     >
                         {doorTier}
                     </button>
                     <div className="flex items-center gap-3">
                        <button onClick={() => setDoors(Math.max(0, doors-1))} className="w-8 h-8 bg-zinc-900 rounded flex items-center justify-center hover:bg-zinc-800">-</button>
                        <span className="text-white font-mono font-bold w-4 text-center">{doors}</span>
                        <button onClick={() => setDoors(doors+1)} className="w-8 h-8 bg-zinc-900 rounded flex items-center justify-center hover:bg-zinc-800">+</button>
                     </div>
                 </div>
             </div>

         </div>

      </div>

      {/* FOOTER: COST SUMMARY */}
      <div className="absolute bottom-0 left-0 right-0 bg-[#121214] border-t border-zinc-800 p-4 pb-8 shadow-[0_-10px_40px_rgba(0,0,0,0.5)] z-20">
          <div className="grid grid-cols-2 gap-4">
              
              {/* Upkeep */}
              <div className="bg-black/40 rounded-xl p-3 border border-green-500/20">
                  <div className="flex items-center gap-2 mb-2 text-green-500">
                      <Clock className="w-3 h-3" />
                      <span className="text-[10px] font-bold uppercase tracking-wider">Daily Upkeep</span>
                  </div>
                  <div className="space-y-1">
                      {stats.upkeepCost.wood > 0 && <div className="flex justify-between text-xs text-amber-600 font-bold"><span>Wood</span><span>{stats.upkeepCost.wood}</span></div>}
                      {stats.upkeepCost.stone > 0 && <div className="flex justify-between text-xs text-zinc-400 font-bold"><span>Stone</span><span>{stats.upkeepCost.stone}</span></div>}
                      {stats.upkeepCost.metal > 0 && <div className="flex justify-between text-xs text-zinc-500 font-bold"><span>Metal</span><span>{stats.upkeepCost.metal}</span></div>}
                      {stats.upkeepCost.hqm > 0 && <div className="flex justify-between text-xs text-zinc-300 font-bold"><span>HQM</span><span>{stats.upkeepCost.hqm}</span></div>}
                      {stats.foundationCount === 0 && <div className="text-[10px] text-zinc-600 italic">Place foundations...</div>}
                  </div>
              </div>

              {/* Build Cost */}
              <div className="bg-black/40 rounded-xl p-3 border border-orange-500/20">
                  <div className="flex items-center gap-2 mb-2 text-orange-500">
                      <Hammer className="w-3 h-3" />
                      <span className="text-[10px] font-bold uppercase tracking-wider">Build Cost</span>
                  </div>
                  <div className="space-y-1">
                      {stats.buildCost.wood > 0 && <div className="flex justify-between text-xs text-amber-600 font-bold"><span>Wood</span><span>{stats.buildCost.wood}</span></div>}
                      {stats.buildCost.stone > 0 && <div className="flex justify-between text-xs text-zinc-400 font-bold"><span>Stone</span><span>{stats.buildCost.stone}</span></div>}
                      {stats.buildCost.metal > 0 && <div className="flex justify-between text-xs text-zinc-500 font-bold"><span>Metal</span><span>{stats.buildCost.metal}</span></div>}
                      {stats.buildCost.hqm > 0 && <div className="flex justify-between text-xs text-zinc-300 font-bold"><span>HQM</span><span>{stats.buildCost.hqm}</span></div>}
                      {stats.foundationCount === 0 && <div className="text-[10px] text-zinc-600 italic">Start building...</div>}
                  </div>
              </div>

          </div>
      </div>

    </div>
  );
};