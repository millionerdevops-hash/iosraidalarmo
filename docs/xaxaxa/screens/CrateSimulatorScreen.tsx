
import React, { useState, useEffect } from 'react';
import { 
  ArrowLeft, 
  RotateCcw, 
  PackageOpen, 
  Sparkles, 
  Coins,
  History,
  TrendingUp,
  TrendingDown,
  Box,
  Lock
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { CRATES, CrateType, LootItem } from '../data/lootData';

interface CrateSimulatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// Mock costs for the "Gamble" aspect
const CRATE_COSTS: Record<string, number> = {
    'elite': 500,
    'bradley': 800,
    'heli': 1000,
    'locked': 400
};

export const CrateSimulatorScreen: React.FC<CrateSimulatorScreenProps> = ({ onNavigate }) => {
  // Global Scrap State (simulated per session if not passed)
  const [scrapBalance, setScrapBalance] = useState(() => {
      return parseInt(localStorage.getItem('raid_alarm_scrap') || '1000');
  });

  const [selectedCrate, setSelectedCrate] = useState<CrateType>(CRATES[0]);
  const [opening, setOpening] = useState(false);
  const [loot, setLoot] = useState<{ item: LootItem, count: number }[]>([]);
  const [winnings, setWinnings] = useState(0);
  const [netProfit, setNetProfit] = useState(0);
  const [history, setHistory] = useState<{profit: number, timestamp: number}[]>([]);

  // Persist balance
  useEffect(() => {
      localStorage.setItem('raid_alarm_scrap', scrapBalance.toString());
  }, [scrapBalance]);

  const handleOpenCrate = () => {
      const cost = CRATE_COSTS[selectedCrate.id] || 0;
      
      if (scrapBalance < cost) {
          alert("Not enough scrap!");
          return;
      }

      setOpening(true);
      setLoot([]);
      setWinnings(0);
      setNetProfit(0);
      setScrapBalance(prev => prev - cost);

      // Simulation Delay & Logic
      setTimeout(() => {
          const newLoot: { item: LootItem, count: number }[] = [];
          let currentScrapValue = 0;

          // Logic: Try to fill slots based on chance
          for(let i=0; i < selectedCrate.maxSlots; i++) {
              // Roll for item
              const possibleItems = selectedCrate.lootTable.filter(i => Math.random() * 100 < i.chance);
              
              if (possibleItems.length > 0) {
                  // Pick weighted random (simplified here to random pick from candidates)
                  const picked = possibleItems[Math.floor(Math.random() * possibleItems.length)];
                  const count = Math.floor(Math.random() * (picked.max - picked.min + 1)) + picked.min;
                  
                  // Stack logic
                  const existing = newLoot.find(l => l.item.name === picked.name);
                  if (existing) {
                      existing.count += count;
                  } else {
                      newLoot.push({ item: picked, count });
                  }
                  currentScrapValue += picked.scrapValue * count;
              }
          }

          // Always give at least some scrap/junk if empty (Bad luck protection for visuals)
          if (newLoot.length === 0) {
              const scrapItem = selectedCrate.lootTable.find(i => i.name === 'Scrap') || { name: 'Scrap', image: '', scrapValue: 1 };
              newLoot.push({ item: scrapItem as LootItem, count: 5 });
              currentScrapValue += 5;
          }

          setLoot(newLoot);
          setWinnings(currentScrapValue);
          const profit = currentScrapValue - cost;
          setNetProfit(profit);
          setScrapBalance(prev => prev + currentScrapValue);
          
          setHistory(prev => [{ profit, timestamp: Date.now() }, ...prev].slice(0, 5));
          setOpening(false);
      }, 1500); // 1.5s animation
  };

  const cost = CRATE_COSTS[selectedCrate.id] || 0;

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative overflow-hidden">
      
      {/* Background Ambience */}
      <div className="absolute inset-0 pointer-events-none bg-[radial-gradient(circle_at_top,_#1f1f22_0%,_#0c0c0e_70%)]" />
      <div className="absolute top-0 inset-x-0 h-px bg-gradient-to-r from-transparent via-white/10 to-transparent" />

      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e]/80 backdrop-blur-md z-20 shrink-0 relative">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors active:scale-95"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Loot Room</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Crate Simulator</p>
            </div>
        </div>
        <div className="flex items-center gap-2 bg-zinc-900 px-3 py-1.5 rounded-full border border-zinc-800 shadow-inner">
            <span className="text-yellow-500 font-black font-mono text-sm">{scrapBalance}</span>
            <Coins className="w-4 h-4 text-yellow-600 fill-yellow-600" />
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 flex flex-col relative z-10">
         
         {/* CRATE SELECTOR - Horizontal Scroll */}
         <div className="flex gap-3 overflow-x-auto no-scrollbar mb-6 pb-2 shrink-0">
             {CRATES.map(crate => {
                 const isSelected = selectedCrate.id === crate.id;
                 const cCost = CRATE_COSTS[crate.id] || 0;
                 return (
                     <button
                        key={crate.id}
                        onClick={() => { 
                            if (!opening) {
                                setSelectedCrate(crate); 
                                setLoot([]); 
                                setWinnings(0);
                                setNetProfit(0);
                            }
                        }}
                        className={`flex flex-col items-center justify-between p-3 rounded-2xl border min-w-[110px] h-32 transition-all duration-300 relative overflow-hidden group
                            ${isSelected 
                                ? 'bg-zinc-800 border-yellow-500 shadow-[0_0_20px_rgba(234,179,8,0.2)] scale-105' 
                                : 'bg-[#18181b] border-zinc-800 opacity-60 hover:opacity-100 hover:border-zinc-600'}
                        `}
                     >
                         <div className="absolute inset-0 bg-gradient-to-b from-white/5 to-transparent pointer-events-none" />
                         
                         <span className={`text-[10px] font-black uppercase tracking-wider z-10 ${isSelected ? 'text-yellow-500' : 'text-zinc-500'}`}>
                             {crate.name.split(' ')[0]}
                         </span>
                         
                         <img 
                            src={crate.image} 
                            alt={crate.name} 
                            className={`w-14 h-14 object-contain drop-shadow-xl z-10 transition-transform duration-500 ${isSelected ? 'scale-110' : 'grayscale group-hover:grayscale-0'}`} 
                         />
                         
                         <div className="bg-black/40 px-2 py-1 rounded text-[10px] font-mono text-zinc-300 border border-white/5 z-10">
                             {cCost} <span className="text-yellow-600">©</span>
                         </div>
                     </button>
                 );
             })}
         </div>

         {/* MAIN STAGE */}
         <div className="flex-1 flex flex-col items-center relative min-h-[350px]">
             
             {/* Center Spotlight Effect */}
             <div className={`absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-yellow-500/10 rounded-full blur-[80px] transition-all duration-500 ${opening ? 'opacity-100 scale-150' : 'opacity-50 scale-100'}`} />

             {/* The Crate Visual */}
             <div className="relative z-20 mb-8 mt-4">
                 <div className={`relative transition-all duration-300 ${opening ? 'animate-[shake_0.5s_ease-in-out_infinite]' : ''}`}>
                     <img 
                        src={selectedCrate.image} 
                        alt={selectedCrate.name} 
                        className={`w-56 h-56 object-contain drop-shadow-[0_25px_50px_rgba(0,0,0,0.6)] relative z-10 transition-all duration-300 ${opening ? 'brightness-125' : ''}`} 
                     />
                     {/* Glow behind crate */}
                     <div className={`absolute inset-0 bg-yellow-500/20 blur-xl rounded-full -z-10 transition-opacity duration-300 ${opening ? 'opacity-100' : 'opacity-0'}`} />
                 </div>

                 {/* Floating Result Badge */}
                 {loot.length > 0 && !opening && (
                     <div className={`absolute -top-12 left-1/2 -translate-x-1/2 flex flex-col items-center animate-in slide-in-from-bottom-4 zoom-in duration-500 z-30`}>
                         <div className={`px-4 py-2 rounded-full border shadow-2xl backdrop-blur-md flex items-center gap-2 mb-2
                             ${netProfit >= 0 
                                 ? 'bg-green-500/20 border-green-500/50 text-green-400 shadow-green-500/20' 
                                 : 'bg-red-500/20 border-red-500/50 text-red-400 shadow-red-500/20'}
                         `}>
                             {netProfit >= 0 ? <TrendingUp className="w-4 h-4" /> : <TrendingDown className="w-4 h-4" />}
                             <span className="font-black text-lg">{netProfit >= 0 ? '+' : ''}{netProfit}</span>
                         </div>
                     </div>
                 )}
             </div>

             {/* OPEN BUTTON */}
             <button 
                onClick={handleOpenCrate}
                disabled={opening}
                className={`relative group px-10 py-5 rounded-2xl font-black text-lg uppercase tracking-widest shadow-2xl transition-all active:scale-[0.98] flex items-center gap-3 overflow-hidden
                    ${opening 
                        ? 'bg-zinc-800 text-zinc-500 cursor-not-allowed' 
                        : 'bg-white text-black hover:bg-zinc-200 shadow-white/10'}
                `}
             >
                 {/* Button Glint */}
                 {!opening && <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/40 to-transparent -translate-x-[150%] group-hover:animate-[shimmer_1.5s_infinite]" />}
                 
                 {opening ? (
                     <>OPENING...</>
                 ) : (
                     <>
                        <PackageOpen className="w-6 h-6 stroke-[2.5]" />
                        <span>OPEN <span className="text-xs ml-1 opacity-60 font-mono">(-{cost})</span></span>
                     </>
                 )}
             </button>

             {/* LOOT GRID */}
             {loot.length > 0 && !opening && (
                 <div className="w-full mt-10 animate-in slide-in-from-bottom duration-500 fade-in">
                     <div className="flex items-center justify-between mb-3 px-2">
                         <div className="flex items-center gap-2">
                             <Sparkles className="w-4 h-4 text-yellow-500" />
                             <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Rewards</span>
                         </div>
                         <span className="text-[10px] font-mono text-zinc-600">Total Value: {winnings}</span>
                     </div>
                     
                     <div className="grid grid-cols-4 gap-2">
                         {loot.map((drop, idx) => (
                             <div 
                                key={idx} 
                                className={`relative aspect-square bg-[#121214] rounded-xl border flex flex-col items-center justify-center p-2 group overflow-hidden
                                    ${drop.item.isRare 
                                        ? 'border-yellow-500/40 shadow-[inset_0_0_20px_rgba(234,179,8,0.1)]' 
                                        : 'border-zinc-800'}
                                `}
                                style={{ animationDelay: `${idx * 100}ms` }} // Staggered entrance
                             >
                                 <div className="absolute inset-0 bg-gradient-to-br from-white/5 to-transparent pointer-events-none" />
                                 
                                 <img 
                                    src={drop.item.image} 
                                    alt={drop.item.name} 
                                    className="w-full h-full object-contain drop-shadow-md group-hover:scale-110 transition-transform duration-300 relative z-10" 
                                 />
                                 
                                 <div className="absolute top-1 right-1 bg-black/80 backdrop-blur px-1.5 py-0.5 rounded text-[9px] font-bold text-white border border-white/10 z-20 shadow-lg">
                                     x{drop.count}
                                 </div>
                                 
                                 {drop.item.isRare && (
                                     <div className="absolute inset-0 bg-yellow-500/5 z-0 animate-pulse" />
                                 )}
                             </div>
                         ))}
                     </div>
                 </div>
             )}

         </div>

      </div>
      
      {/* CSS for Shake Animation */}
      <style>{`
        @keyframes shake {
          0% { transform: translate(1px, 1px) rotate(0deg); }
          10% { transform: translate(-1px, -2px) rotate(-1deg); }
          20% { transform: translate(-3px, 0px) rotate(1deg); }
          30% { transform: translate(3px, 2px) rotate(0deg); }
          40% { transform: translate(1px, -1px) rotate(1deg); }
          50% { transform: translate(-1px, 2px) rotate(-1deg); }
          60% { transform: translate(-3px, 1px) rotate(0deg); }
          70% { transform: translate(3px, 1px) rotate(-1deg); }
          80% { transform: translate(-1px, -1px) rotate(1deg); }
          90% { transform: translate(1px, 2px) rotate(0deg); }
          100% { transform: translate(1px, -2px) rotate(-1deg); }
        }
        @keyframes shimmer {
          100% { transform: translateX(150%); }
        }
      `}</style>
    </div>
  );
};
