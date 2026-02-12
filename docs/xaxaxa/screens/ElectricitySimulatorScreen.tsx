
import React, { useState, useMemo } from 'react';
import { 
  ArrowLeft, 
  Zap, 
  Battery, 
  Plus, 
  Trash2, 
  Moon, 
  Sun,
  Activity,
  Fan,
  RotateCcw,
  Check
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { ELEC_ITEMS, ElecItem, ElecCategory } from '../data/electricityData';

interface ElectricitySimulatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const ElectricitySimulatorScreen: React.FC<ElectricitySimulatorScreenProps> = ({ onNavigate }) => {
  const [circuit, setCircuit] = useState<{ id: string; item: ElecItem; count: number }[]>([]);
  const [isNight, setIsNight] = useState(false);
  const [showAddItem, setShowAddItem] = useState(false);
  const [activeCategory, setActiveCategory] = useState<ElecCategory>('Source');

  // --- LOGIC ---
  
  const addToCircuit = (item: ElecItem) => {
      setCircuit(prev => {
          const exists = prev.find(i => i.item.id === item.id);
          if (exists) {
              return prev.map(i => i.item.id === item.id ? { ...i, count: i.count + 1 } : i);
          }
          return [...prev, { id: Date.now().toString(), item, count: 1 }];
      });
      setShowAddItem(false);
  };

  const updateCount = (itemId: string, delta: number) => {
      setCircuit(prev => prev.map(i => {
          if (i.id === itemId) {
              const newCount = Math.max(0, i.count + delta);
              return { ...i, count: newCount };
          }
          return i;
      }).filter(i => i.count > 0));
  };

  const removeItem = (itemId: string) => {
      setCircuit(prev => prev.filter(i => i.id !== itemId));
  };

  const reset = () => setCircuit([]);

  // Calculations
  const stats = useMemo(() => {
      let generation = 0;
      let consumption = 0;
      let batteryCapacity = 0; // in rWm (Watt Minutes)
      let batteryMaxOutput = 0;

      circuit.forEach(({ item, count }) => {
          if (item.category === 'Source') {
              let power = item.power;
              if (item.id === 'solar' && isNight) power = 0;
              generation += power * count;
          } else if (item.category === 'Consumer' || item.category === 'Control') {
              consumption += item.power * count;
          } else if (item.category === 'Battery') {
              batteryCapacity += item.power * count;
              // Add simpler max output logic if needed, but for "Load" check we usually look at total potential
              // Small: 10, Med: 50, Large: 100
              const maxOut = item.id === 'small_bat' ? 10 : item.id === 'med_bat' ? 50 : 100;
              batteryMaxOutput += maxOut * count;
          }
      });

      const net = generation - consumption;
      // Battery Duration: If net is negative, how long does battery last?
      // Formula: Capacity / Deficit
      let duration = 0;
      if (net < 0 && batteryCapacity > 0) {
          duration = batteryCapacity / Math.abs(net); // in minutes
      }

      return { generation, consumption, net, batteryCapacity, batteryMaxOutput, duration };
  }, [circuit, isNight]);

  const getStatusColor = () => {
      if (stats.consumption === 0) return 'text-zinc-500';
      if (stats.net >= 0) return 'text-green-500'; // Sustainable
      if (stats.duration > 0) return 'text-yellow-500'; // Draining
      return 'text-red-500'; // Dead
  };

  const formatDuration = (mins: number) => {
      if (mins === 0) return '---';
      if (mins > 1440) return '> 24h'; // Cap visuals
      const h = Math.floor(mins / 60);
      const m = Math.floor(mins % 60);
      return `${h}h ${m}m`;
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
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Circuit Sim</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Power Grid Calculator</p>
            </div>
        </div>
        <button 
            onClick={reset}
            className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-red-500 hover:bg-red-900/10 transition-all"
        >
            <RotateCcw className="w-5 h-5" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 pb-32">
         
         {/* MONITOR DASHBOARD */}
         <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-5 mb-6 shadow-xl relative overflow-hidden">
             {/* Night Mode Toggle Overlay */}
             <button 
                onClick={() => setIsNight(!isNight)}
                className={`absolute top-4 right-4 flex items-center gap-2 px-3 py-1.5 rounded-full border transition-all z-20
                    ${isNight ? 'bg-blue-950/50 border-blue-500/50 text-blue-300' : 'bg-orange-500/10 border-orange-500/30 text-orange-400'}
                `}
             >
                 {isNight ? <Moon className="w-3 h-3 fill-current" /> : <Sun className="w-3 h-3 fill-current" />}
                 <span className="text-[10px] font-bold uppercase">{isNight ? 'Night' : 'Day'}</span>
             </button>

             <div className="grid grid-cols-3 gap-4 text-center relative z-10 mt-2">
                 {/* Generation */}
                 <div>
                     <span className="text-[10px] text-zinc-500 font-bold uppercase block mb-1">Input</span>
                     <div className="text-2xl font-black text-cyan-400 font-mono tracking-tight">{stats.generation}</div>
                     <span className="text-[9px] text-cyan-400/60 font-mono">rWm</span>
                 </div>
                 
                 {/* Status Icon */}
                 <div className="flex flex-col items-center justify-center">
                     <div className={`w-12 h-12 rounded-full flex items-center justify-center border-2 mb-1 shadow-lg transition-all duration-500
                         ${stats.net >= 0 
                             ? 'bg-green-500/10 border-green-500 text-green-500' 
                             : 'bg-red-500/10 border-red-500 text-red-500'}
                     `}>
                         <Activity className="w-6 h-6" />
                     </div>
                     <span className={`text-[10px] font-bold uppercase ${stats.net >= 0 ? 'text-green-500' : 'text-red-500'}`}>
                         {stats.net >= 0 ? 'Stable' : 'Draining'}
                     </span>
                 </div>

                 {/* Load */}
                 <div>
                     <span className="text-[10px] text-zinc-500 font-bold uppercase block mb-1">Load</span>
                     <div className="text-2xl font-black text-orange-500 font-mono tracking-tight">{stats.consumption}</div>
                     <span className="text-[9px] text-orange-500/60 font-mono">rWm</span>
                 </div>
             </div>

             {/* Battery Status Bar */}
             <div className="mt-6 bg-black/40 rounded-xl p-3 border border-zinc-800">
                 <div className="flex justify-between items-center mb-2">
                     <div className="flex items-center gap-2">
                         <Battery className={`w-4 h-4 ${stats.net < 0 ? 'text-yellow-500' : 'text-green-500'}`} />
                         <span className="text-xs text-zinc-300 font-bold uppercase">Battery Buffer</span>
                     </div>
                     <span className={`text-xs font-mono font-bold ${stats.net < 0 ? 'text-yellow-500' : 'text-zinc-500'}`}>
                         {stats.net < 0 ? formatDuration(stats.duration) : 'Charging'}
                     </span>
                 </div>
                 {/* Progress/Capacity Bar (Visual only for capacity relative to huge amount) */}
                 <div className="h-1.5 w-full bg-zinc-800 rounded-full overflow-hidden">
                     <div 
                        className={`h-full transition-all duration-500 ${stats.net < 0 ? 'bg-yellow-500' : 'bg-green-500'}`} 
                        style={{ width: '100%' }} // Always full to represent health, could be dynamic based on charge logic if we tracked time
                     />
                 </div>
                 {stats.batteryMaxOutput < stats.consumption && (
                     <div className="mt-2 flex items-center gap-2 text-[10px] text-red-400 font-bold bg-red-950/20 px-2 py-1 rounded border border-red-900/30">
                         <Activity className="w-3 h-3" /> Warning: Load exceeds battery output limit!
                     </div>
                 )}
             </div>
         </div>

         {/* CIRCUIT LIST */}
         <div className="space-y-3">
             {/* Header */}
             <div className="flex justify-between items-center px-1">
                 <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest">Active Components</h3>
                 <span className="text-[10px] text-zinc-600">{circuit.length} Units</span>
             </div>

             {circuit.length === 0 ? (
                 <div className="text-center py-10 border-2 border-dashed border-zinc-800 rounded-2xl bg-zinc-900/10">
                     <Zap className="w-10 h-10 text-zinc-700 mx-auto mb-3" />
                     <p className="text-zinc-500 text-xs">Circuit is empty.</p>
                     <p className="text-zinc-600 text-[10px] mt-1">Add power sources and consumers to calculate.</p>
                 </div>
             ) : (
                 circuit.map((entry) => (
                     <div key={entry.id} className="bg-zinc-900 border border-zinc-800 p-3 rounded-xl flex items-center justify-between group">
                         <div className="flex items-center gap-3">
                             <div className={`w-10 h-10 rounded-lg flex items-center justify-center border 
                                 ${entry.item.category === 'Source' ? 'bg-cyan-900/20 border-cyan-500/30 text-cyan-400' : 
                                   entry.item.category === 'Battery' ? 'bg-green-900/20 border-green-500/30 text-green-400' : 
                                   'bg-orange-900/20 border-orange-500/30 text-orange-400'}
                             `}>
                                 <entry.item.icon className="w-5 h-5" />
                             </div>
                             <div>
                                 <div className="text-sm font-bold text-white">{entry.item.name}</div>
                                 <div className="text-[10px] text-zinc-500 font-mono">
                                     {entry.item.category === 'Source' ? `+${entry.item.power} rWm` : `-${entry.item.power} rWm`}
                                 </div>
                             </div>
                         </div>
                         
                         <div className="flex items-center gap-3 bg-black/40 rounded-lg p-1 border border-zinc-800">
                             <button onClick={() => updateCount(entry.id, -1)} className="w-6 h-6 flex items-center justify-center text-zinc-500 hover:text-white">-</button>
                             <span className="text-xs font-mono font-bold text-white w-4 text-center">{entry.count}</span>
                             <button onClick={() => updateCount(entry.id, 1)} className="w-6 h-6 flex items-center justify-center text-zinc-500 hover:text-white">+</button>
                         </div>
                     </div>
                 ))
             )}
         </div>

      </div>

      {/* FAB: ADD ITEM */}
      <div className="absolute bottom-6 left-6 right-6 z-20">
          <button 
            onClick={() => setShowAddItem(true)}
            className="w-full py-4 bg-cyan-600 hover:bg-cyan-500 text-white font-bold uppercase rounded-xl shadow-lg shadow-cyan-900/40 flex items-center justify-center gap-2 active:scale-95 transition-all"
          >
              <Plus className="w-5 h-5" /> Add Component
          </button>
      </div>

      {/* ADD ITEM MODAL */}
      {showAddItem && (
          <div className="absolute inset-0 z-50 bg-[#0c0c0e]/95 backdrop-blur-sm flex flex-col animate-in slide-in-from-bottom duration-300">
              <div className="p-4 border-b border-zinc-800 flex justify-between items-center bg-[#0c0c0e]">
                  <h3 className="text-white font-bold text-lg uppercase flex items-center gap-2">
                      <Zap className="w-5 h-5 text-cyan-400" /> Select Item
                  </h3>
                  <button onClick={() => setShowAddItem(false)} className="p-2 bg-zinc-900 rounded-full text-zinc-400 hover:text-white">
                      <Trash2 className="w-5 h-5 rotate-45" /> {/* Use rotate to simulate close X */}
                  </button>
              </div>

              {/* Categories */}
              <div className="flex p-2 bg-zinc-900/50 gap-2 overflow-x-auto no-scrollbar">
                  {(['Source', 'Battery', 'Consumer', 'Control'] as ElecCategory[]).map(cat => (
                      <button
                        key={cat}
                        onClick={() => setActiveCategory(cat)}
                        className={`px-4 py-2 rounded-lg text-xs font-bold uppercase transition-all whitespace-nowrap border
                            ${activeCategory === cat 
                                ? 'bg-zinc-800 text-white border-zinc-600' 
                                : 'text-zinc-500 border-transparent hover:text-zinc-300'}
                        `}
                      >
                          {cat}
                      </button>
                  ))}
              </div>

              <div className="flex-1 overflow-y-auto p-4 space-y-2">
                  {ELEC_ITEMS.filter(i => i.category === activeCategory).map(item => (
                      <button
                        key={item.id}
                        onClick={() => addToCircuit(item)}
                        className="w-full flex items-center gap-4 p-3 rounded-xl bg-zinc-900 border border-zinc-800 hover:border-cyan-500/50 transition-all text-left group"
                      >
                          <div className="w-12 h-12 rounded-lg bg-black flex items-center justify-center text-zinc-500 group-hover:text-cyan-400 transition-colors">
                              <item.icon className="w-6 h-6" />
                          </div>
                          <div className="flex-1">
                              <div className="font-bold text-sm text-white">{item.name}</div>
                              <div className="text-[10px] text-zinc-500">{item.desc}</div>
                          </div>
                          <div className="text-xs font-mono font-bold text-zinc-400 bg-black/40 px-2 py-1 rounded">
                              {item.power} rWm
                          </div>
                      </button>
                  ))}
              </div>
          </div>
      )}

    </div>
  );
};
