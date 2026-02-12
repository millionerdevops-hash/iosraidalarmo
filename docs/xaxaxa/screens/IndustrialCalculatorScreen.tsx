
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Minus, 
  Plus, 
  Zap,
  Flame,
  Box,
  Factory,
  ArrowRight,
  Split,
  Settings
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { INDUSTRIAL_MACHINES, MachineId } from '../data/industrialData';

interface IndustrialCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const IndustrialCalculatorScreen: React.FC<IndustrialCalculatorScreenProps> = ({ onNavigate }) => {
  const [selectedMachine, setSelectedMachine] = useState<MachineId>('electric_furnace');
  const [count, setCount] = useState(1);

  const machine = INDUSTRIAL_MACHINES.find(m => m.id === selectedMachine)!;

  const increment = () => setCount(Math.min(count + 1, 50));
  const decrement = () => setCount(Math.max(count - 1, 1));

  // --- CALCULATIONS ---
  const totalPower = machine.powerPerUnit > 0 ? machine.powerPerUnit * count + 2 : 2; // +2 for conveyors (min 1 in 1 out)
  const totalWood = machine.woodPerHr * count;
  const totalCharcoal = machine.charcoalPerHr * count;
  const totalOutput = machine.outputPerHr * count; // Metal/Sulfur
  
  // Infrastructure requirements (Rule of thumb: 1 input adapter + 1 output adapter per machine + 2 main conveyors)
  // Or daisy chain? Assuming standard parallel setup for max efficiency.
  const adaptersNeeded = count * 2; 
  const conveyorsNeeded = 2; // Main trunk lines usually. Or 1 per machine if not daisy chained? Let's say "System Conveyors".
  const splittersNeeded = Math.ceil(count / 3); // 1 splitter per 3 machines if parallel

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
        <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Industrial</h2>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6">
          
          {/* MACHINE SELECTOR */}
          <div className="grid grid-cols-4 gap-2 mb-6">
              {INDUSTRIAL_MACHINES.map((m) => (
                  <button
                    key={m.id}
                    onClick={() => setSelectedMachine(m.id)}
                    className={`flex flex-col items-center justify-center p-3 rounded-xl border transition-all active:scale-95
                        ${selectedMachine === m.id 
                            ? 'bg-zinc-800 border-zinc-500 text-white' 
                            : 'bg-zinc-900 border-zinc-800 text-zinc-500 hover:bg-zinc-800'}
                    `}
                  >
                      <m.icon className={`w-6 h-6 mb-2 ${selectedMachine === m.id ? 'text-orange-500' : ''}`} />
                      <span className="text-[9px] font-bold uppercase text-center leading-tight">{m.name.split(' ')[0]}</span>
                  </button>
              ))}
          </div>

          {/* QUANTITY CONTROL */}
          <div className="flex items-center justify-between bg-[#121214] border border-zinc-800 rounded-2xl p-4 mb-6 shadow-lg">
              <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-black/40 rounded-xl flex items-center justify-center border border-zinc-700">
                      <machine.icon className="w-6 h-6 text-zinc-300" />
                  </div>
                  <div>
                      <h3 className="text-white font-bold text-sm uppercase">{machine.name}</h3>
                      <p className="text-zinc-500 text-xs">x{count} Active Units</p>
                  </div>
              </div>
              <div className="flex items-center gap-3 bg-zinc-900 rounded-lg p-1 border border-zinc-800">
                  <button onClick={decrement} className="w-8 h-8 flex items-center justify-center text-zinc-400 hover:text-white"><Minus className="w-4 h-4" /></button>
                  <span className="w-6 text-center font-mono font-bold text-white">{count}</span>
                  <button onClick={increment} className="w-8 h-8 flex items-center justify-center text-zinc-400 hover:text-white"><Plus className="w-4 h-4" /></button>
              </div>
          </div>

          {/* VISUAL FLOW */}
          <div className="mb-6 relative h-24 bg-zinc-900/30 rounded-2xl border border-zinc-800/50 flex items-center justify-between px-6 overflow-hidden">
              {/* Animated Dashed Line */}
              <div className="absolute top-1/2 left-0 right-0 h-0.5 bg-gradient-to-r from-transparent via-zinc-600 to-transparent opacity-30" />
              <div className="absolute top-1/2 left-0 right-0 h-0.5 border-t border-dashed border-orange-500/50 animate-[dash_20s_linear_infinite]" />

              <div className="relative z-10 flex flex-col items-center gap-1">
                  <Box className="w-6 h-6 text-zinc-500" />
                  <span className="text-[9px] font-bold text-zinc-600 uppercase">Input</span>
              </div>
              
              <div className="relative z-10 flex flex-col items-center gap-1">
                  <Settings className="w-8 h-8 text-orange-500 animate-spin-slow" />
                  <span className="text-[9px] font-bold text-orange-500 uppercase">Processing</span>
              </div>

              <div className="relative z-10 flex flex-col items-center gap-1">
                  <Box className="w-6 h-6 text-zinc-300" />
                  <span className="text-[9px] font-bold text-zinc-400 uppercase">Output</span>
              </div>
          </div>

          {/* STATS GRID */}
          <div className="grid grid-cols-2 gap-3 mb-6">
              
              {/* Output */}
              <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 flex flex-col justify-center relative overflow-hidden group">
                  <div className="absolute inset-0 bg-yellow-500/5 group-hover:bg-yellow-500/10 transition-colors" />
                  <div className="relative z-10">
                      <div className="flex items-center gap-2 mb-1">
                          <ArrowRight className="w-4 h-4 text-yellow-500" />
                          <span className="text-[10px] font-bold text-zinc-500 uppercase">Production</span>
                      </div>
                      <div className="text-2xl font-black text-white font-mono tracking-tight">
                          {totalOutput.toLocaleString()}
                      </div>
                      <div className="text-[10px] text-zinc-500 font-mono mt-0.5">Ore per Hour</div>
                  </div>
              </div>

              {/* Power */}
              <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 flex flex-col justify-center relative overflow-hidden group">
                  <div className="absolute inset-0 bg-cyan-500/5 group-hover:bg-cyan-500/10 transition-colors" />
                  <div className="relative z-10">
                      <div className="flex items-center gap-2 mb-1">
                          <Zap className="w-4 h-4 text-cyan-500" />
                          <span className="text-[10px] font-bold text-zinc-500 uppercase">Total Power</span>
                      </div>
                      <div className="text-2xl font-black text-white font-mono tracking-tight">
                          {totalPower}
                      </div>
                      <div className="text-[10px] text-zinc-500 font-mono mt-0.5">rWm Needed</div>
                  </div>
              </div>

              {/* Fuel (If Needed) */}
              {totalWood > 0 && (
                  <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 flex flex-col justify-center">
                      <div className="flex items-center gap-2 mb-1">
                          <Flame className="w-4 h-4 text-orange-500" />
                          <span className="text-[10px] font-bold text-zinc-500 uppercase">Fuel Burn</span>
                      </div>
                      <div className="text-xl font-black text-white font-mono tracking-tight">
                          {totalWood.toLocaleString()}
                      </div>
                      <div className="text-[10px] text-zinc-500 font-mono mt-0.5">Wood / Hr</div>
                  </div>
              )}

              {/* Charcoal (If Produced) */}
              {totalCharcoal > 0 && (
                  <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 flex flex-col justify-center">
                      <div className="flex items-center gap-2 mb-1">
                          <Box className="w-4 h-4 text-zinc-400" />
                          <span className="text-[10px] font-bold text-zinc-500 uppercase">Byproduct</span>
                      </div>
                      <div className="text-xl font-black text-white font-mono tracking-tight">
                          {totalCharcoal.toLocaleString()}
                      </div>
                      <div className="text-[10px] text-zinc-500 font-mono mt-0.5">Charcoal / Hr</div>
                  </div>
              )}
          </div>

          {/* COMPONENT CHECKLIST */}
          <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-4">
              <div className="flex items-center gap-2 mb-3">
                  <Factory className="w-4 h-4 text-blue-400" />
                  <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Required Components</span>
              </div>
              <div className="space-y-2">
                  <div className="flex justify-between items-center text-xs border-b border-zinc-800/50 pb-2">
                      <span className="text-zinc-300">Storage Adapters</span>
                      <span className="font-mono font-bold text-white">x{adaptersNeeded}</span>
                  </div>
                  <div className="flex justify-between items-center text-xs border-b border-zinc-800/50 pb-2">
                      <span className="text-zinc-300">Industrial Conveyors</span>
                      <span className="font-mono font-bold text-white">x{conveyorsNeeded}+</span>
                  </div>
                  {splittersNeeded > 0 && (
                      <div className="flex justify-between items-center text-xs pb-1">
                          <span className="text-zinc-300">Industrial Splitters</span>
                          <span className="font-mono font-bold text-white">x{splittersNeeded}</span>
                      </div>
                  )}
              </div>
          </div>

      </div>
    </div>
  );
};
