
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Clock, 
  TrendingUp,
  CheckCircle2,
  Info,
  Droplet,
  Fuel
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface DieselCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

type FuelType = 'Diesel' | 'LowGrade';
type MachineType = 'excavator' | 'hqm_quarry' | 'sulfur_quarry' | 'stone_quarry' | 'static_pump_jack' | 'deploy_pump_jack' | 'deploy_quarry';

// Resource Icons (Output)
const RESOURCE_IMAGES: Record<string, string> = {
    'Diesel Fuel': 'https://rustlabs.com/img/items180/diesel_barrel.png',
    'Low Grade Fuel': 'https://rustlabs.com/img/items180/lowgradefuel.png',
    'Sulfur Ore': 'https://rustlabs.com/img/items180/sulfur.ore.png',
    'HQM Ore': 'https://rustlabs.com/img/items180/hq.metal.ore.png',
    'Metal Frags': 'https://rustlabs.com/img/items180/metal.fragments.png',
    'Stones': 'https://rustlabs.com/img/items180/stones.png',
    'Metal Ore': 'https://rustlabs.com/img/items180/metal.ore.png',
    'Crude Oil': 'https://rustlabs.com/img/items180/crude.oil.png'
};

const MACHINES: { 
    id: MachineType; 
    label: string; 
    fuelType: FuelType;
    type: 'Monument' | 'Static Site' | 'Deployable';
    image: string;
    ratePerFuel: Record<string, number>; // Output per 1 unit of fuel
    burnRateMins: number; // How many minutes 1 unit of fuel lasts
    description: string;
}[] = [
    // --- DIESEL MACHINES ---
    { 
        id: 'excavator', 
        label: 'Giant Excavator', 
        fuelType: 'Diesel',
        type: 'Monument',
        image: 'https://wiki.rustclash.com/img/screenshots/excavator.png',
        burnRateMins: 2, // 1 Diesel = 2 mins
        ratePerFuel: { 
            'Sulfur Ore': 2000, 
            'HQM Ore': 100, 
            'Metal Frags': 5000, 
            'Stones': 10000 
        },
        description: 'Highest yield. High risk PVP area.'
    },
    { 
        id: 'hqm_quarry', 
        label: 'HQM Quarry', 
        fuelType: 'Diesel',
        type: 'Static Site',
        image: 'https://wiki.rustclash.com/img/items180/mining.quarry.png',
        burnRateMins: 2,
        ratePerFuel: { 'HQM Ore': 50, 'Stones': 1000, 'Sulfur Ore': 0 },
        description: 'Found at HQM Monument.'
    },
    { 
        id: 'sulfur_quarry', 
        label: 'Sulfur Quarry', 
        fuelType: 'Diesel',
        type: 'Static Site',
        image: 'https://wiki.rustclash.com/img/items180/mining.quarry.png',
        burnRateMins: 2,
        ratePerFuel: { 'Sulfur Ore': 1000, 'Stones': 1000 },
        description: 'Found at Sulfur Monument.'
    },
    { 
        id: 'stone_quarry', 
        label: 'Stone Quarry', 
        fuelType: 'Diesel',
        type: 'Static Site',
        image: 'https://wiki.rustclash.com/img/items180/mining.quarry.png',
        burnRateMins: 2,
        ratePerFuel: { 'Stones': 5000, 'Metal Ore': 1000 },
        description: 'Found at Stone Monument.'
    },
    { 
        id: 'static_pump_jack', 
        label: 'Static Pump Jack', 
        fuelType: 'Diesel',
        type: 'Static Site',
        image: 'https://wiki.rustclash.com/img/items180/mining.pumpjack.png',
        burnRateMins: 2,
        ratePerFuel: { 'Crude Oil': 28 }, 
        description: 'Power Plant / Water Treatment.'
    },

    // --- LOW GRADE MACHINES ---
    {
        id: 'deploy_pump_jack',
        label: 'Deployable Pump',
        fuelType: 'LowGrade',
        type: 'Deployable',
        image: 'https://wiki.rustclash.com/img/items180/mining.pumpjack.png',
        burnRateMins: 0.1666, // 1 LGF = 10 seconds = ~0.166 mins (360 LGF/hr)
        ratePerFuel: { 'Crude Oil': 1 }, // ~1:1 Ratio usually
        description: 'Player placed. Needs survey.'
    },
    {
        id: 'deploy_quarry',
        label: 'Mining Quarry',
        fuelType: 'LowGrade',
        type: 'Deployable',
        image: 'https://wiki.rustclash.com/img/items180/mining.quarry.png',
        burnRateMins: 0.1666, // 1 LGF = 10 seconds
        ratePerFuel: { 'Stones': 5, 'Metal Ore': 1, 'Sulfur Ore': 0.5, 'HQM Ore': 0.1 }, // AVERAGE Yield placeholder
        description: 'Yield depends on Survey Crater quality.'
    }
];

export const DieselCalculatorScreen: React.FC<DieselCalculatorScreenProps> = ({ onNavigate }) => {
  const [fuelAmount, setFuelAmount] = useState<string>('1');
  const [fuelType, setFuelType] = useState<FuelType>('Diesel');
  const [selectedMachine, setSelectedMachine] = useState<MachineType>('excavator');

  // Filter machines based on active fuel type
  const activeMachines = MACHINES.filter(m => m.fuelType === fuelType);
  
  // Ensure selected machine matches current fuel type
  const currentMachine = activeMachines.find(m => m.id === selectedMachine) || activeMachines[0];
  
  const count = parseInt(fuelAmount) || 0;
  const timeMinutes = count * currentMachine.burnRateMins;
  
  const fuelName = fuelType === 'Diesel' ? 'Diesel Fuel' : 'Low Grade Fuel';
  const fuelIconColor = fuelType === 'Diesel' ? 'text-yellow-500' : 'text-red-500';
  const fuelBorderColor = fuelType === 'Diesel' ? 'border-yellow-500' : 'border-red-500';

  // Format helpers
  const formatTime = (mins: number) => {
      if (mins < 1) return `${Math.round(mins * 60)} sec`;
      if (mins >= 60) {
          const h = Math.floor(mins / 60);
          const m = Math.round(mins % 60);
          return `${h}h ${m > 0 ? m + 'm' : ''}`;
      }
      return `${Math.round(mins)} min`;
  };

  const formatNumber = (num: number) => {
      if (num > 10000) return `${(num/1000).toFixed(1)}k`;
      return Math.floor(num).toLocaleString();
  };

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
        <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Fuel Calc</h2>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6">
          
          {/* FUEL TYPE TOGGLE */}
          <div className="flex bg-zinc-900 p-1 rounded-xl border border-zinc-800 mb-6">
              <button 
                  onClick={() => { setFuelType('Diesel'); setSelectedMachine('excavator'); setFuelAmount('1'); }}
                  className={`flex-1 py-3 rounded-lg text-xs font-bold uppercase transition-all flex items-center justify-center gap-2
                      ${fuelType === 'Diesel' ? 'bg-[#18181b] text-yellow-500 shadow-md border border-yellow-500/30' : 'text-zinc-500 hover:text-zinc-300'}
                  `}
              >
                  <Fuel className="w-4 h-4" /> Diesel
              </button>
              <button 
                  onClick={() => { setFuelType('LowGrade'); setSelectedMachine('deploy_pump_jack'); setFuelAmount('100'); }}
                  className={`flex-1 py-3 rounded-lg text-xs font-bold uppercase transition-all flex items-center justify-center gap-2
                      ${fuelType === 'LowGrade' ? 'bg-[#18181b] text-red-500 shadow-md border border-red-500/30' : 'text-zinc-500 hover:text-zinc-300'}
                  `}
              >
                  <Droplet className="w-4 h-4" /> Low Grade
              </button>
          </div>

          {/* INPUT CARD */}
          <div className={`bg-[#121214] border rounded-2xl p-5 mb-6 shadow-xl relative overflow-hidden transition-colors duration-300 ${fuelType === 'Diesel' ? 'border-yellow-900/30' : 'border-red-900/30'}`}>
              <div className="flex justify-between items-center mb-4 relative z-10">
                  <span className="text-xs font-bold text-zinc-500 uppercase tracking-widest">Input Amount</span>
                  <div className={`flex items-center gap-1.5 px-2 py-1 rounded border ${fuelType === 'Diesel' ? 'bg-yellow-900/20 border-yellow-700/30' : 'bg-red-900/20 border-red-700/30'}`}>
                      <Clock className={`w-3 h-3 ${fuelIconColor}`} />
                      <span className={`text-[10px] font-mono font-bold ${fuelIconColor}`}>{formatTime(timeMinutes)} Runtime</span>
                  </div>
              </div>
              
              <div className="flex items-center gap-4 relative z-10">
                  <div className="w-20 h-20 bg-zinc-900 rounded-2xl border border-zinc-700 flex items-center justify-center shrink-0 p-2 shadow-inner">
                      <img src={RESOURCE_IMAGES[fuelName]} alt={fuelName} className="w-full h-full object-contain" />
                  </div>
                  <div className="flex-1">
                      <input 
                        type="number" 
                        value={fuelAmount}
                        onChange={(e) => setFuelAmount(e.target.value)}
                        className={`w-full bg-zinc-900 border border-zinc-700 rounded-xl py-4 px-4 text-3xl font-black text-white outline-none focus:${fuelBorderColor} transition-colors font-mono`}
                        placeholder="0"
                      />
                  </div>
              </div>
              
              <div className="grid grid-cols-4 gap-2 mt-4 relative z-10">
                  {[1, 10, 50, 100].map(amt => (
                      <button 
                        key={amt}
                        onClick={() => setFuelAmount((parseInt(fuelAmount || '0') + amt).toString())}
                        className="py-2 bg-zinc-800 hover:bg-zinc-700 border border-zinc-700 hover:border-zinc-500 rounded-lg text-xs font-bold text-zinc-300 transition-all active:scale-95"
                      >
                          +{amt}
                      </button>
                  ))}
              </div>
          </div>

          {/* MACHINE SELECTOR */}
          <div className="mb-8">
              <div className="flex items-center justify-between mb-3 px-1">
                  <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest">Select Machine</h3>
                  {fuelType === 'Diesel' && (
                      <div className="flex items-center gap-1 bg-zinc-900 px-2 py-0.5 rounded border border-zinc-800">
                          <Info className="w-3 h-3 text-zinc-500" />
                          <span className="text-[9px] text-zinc-500">Static Sites</span>
                      </div>
                  )}
              </div>
              
              <div className="grid grid-cols-2 gap-3">
                  {activeMachines.map((m) => {
                      const isSelected = currentMachine.id === m.id;
                      return (
                          <button
                            key={m.id}
                            onClick={() => setSelectedMachine(m.id)}
                            className={`relative w-full p-0 rounded-xl border flex flex-col items-center overflow-hidden transition-all active:scale-[0.98] group
                                ${isSelected 
                                    ? `bg-[#18181b] ${fuelType === 'Diesel' ? 'border-yellow-500' : 'border-red-500'} shadow-lg` 
                                    : 'bg-zinc-900/40 border-zinc-800 hover:bg-zinc-900 hover:border-zinc-700'
                                }
                            `}
                          >
                              {/* Machine Image */}
                              <div className="w-full h-24 bg-zinc-950 relative flex items-center justify-center p-2">
                                  <div className={`absolute inset-0 opacity-20 ${isSelected ? (fuelType === 'Diesel' ? 'bg-yellow-500/20' : 'bg-red-500/20') : ''}`} />
                                  <img 
                                    src={m.image} 
                                    alt={m.label} 
                                    className={`h-full w-auto object-contain transition-all duration-300 drop-shadow-xl ${isSelected ? 'scale-110' : 'opacity-70 grayscale'}`} 
                                  />
                                  <div className={`absolute top-2 left-2 text-[8px] font-black uppercase px-1.5 py-0.5 rounded bg-black/60 backdrop-blur border border-white/10 ${isSelected ? 'text-white' : 'text-zinc-500'}`}>
                                      {m.type}
                                  </div>
                              </div>

                              <div className="p-3 w-full text-left relative z-10 border-t border-white/5 bg-[#121214]">
                                  <span className={`text-xs font-black uppercase tracking-wide leading-tight block mb-1 ${isSelected ? 'text-white' : 'text-zinc-400'}`}>
                                      {m.label}
                                  </span>
                                  <p className="text-[9px] text-zinc-500 line-clamp-1">{m.description}</p>
                              </div>
                              
                              {isSelected && (
                                  <div className={`absolute top-2 right-2 p-1 rounded-full animate-in zoom-in duration-200 z-20 ${fuelType === 'Diesel' ? 'bg-yellow-500' : 'bg-red-500'}`}>
                                      <CheckCircle2 className="w-3 h-3 text-black" />
                                  </div>
                              )}
                          </button>
                      );
                  })}
              </div>
          </div>

          {/* OUTPUT CARD */}
          <div className="space-y-3 pb-8">
              <div className="flex items-center gap-2 mb-2 px-1">
                  <TrendingUp className={`w-4 h-4 ${fuelType === 'Diesel' ? 'text-green-500' : 'text-orange-500'}`} />
                  <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">
                      {fuelType === 'Diesel' ? 'Total Output' : 'Estimated Yield'}
                  </span>
              </div>

              {Object.entries(currentMachine.ratePerFuel).map(([resource, rate]) => {
                  if (rate === 0) return null;
                  const total = rate * count;
                  
                  let colorClass = 'text-white';
                  let borderColor = 'border-zinc-800';

                  if (resource.includes('Sulfur')) {
                      colorClass = 'text-yellow-400';
                      borderColor = 'border-yellow-500/30';
                  }
                  if (resource.includes('HQM')) {
                      colorClass = 'text-zinc-300';
                      borderColor = 'border-zinc-600';
                  }
                  if (resource.includes('Metal')) {
                      colorClass = 'text-blue-300';
                      borderColor = 'border-blue-500/30';
                  }
                  if (resource.includes('Crude')) {
                      colorClass = 'text-black bg-red-500 px-1 rounded'; // Highlight oil
                      borderColor = 'border-red-500/30';
                  }

                  return (
                      <div key={resource} className={`flex items-center justify-between bg-[#121214] p-3 rounded-2xl border ${borderColor} relative overflow-hidden group`}>
                          <div className="flex items-center gap-4 z-10">
                              <div className="w-12 h-12 bg-black/40 rounded-xl border border-white/5 flex items-center justify-center p-1">
                                  <img src={RESOURCE_IMAGES[resource]} alt={resource} className="w-full h-full object-contain drop-shadow-md" />
                              </div>
                              <div>
                                  <div className="text-[10px] font-bold text-zinc-500 uppercase tracking-wider">{resource}</div>
                                  <div className={`text-2xl font-black font-mono tracking-tight ${resource.includes('Crude') ? 'text-red-500' : colorClass}`}>
                                      {formatNumber(total)}
                                  </div>
                              </div>
                          </div>
                          
                          <div className="text-right z-10">
                              <span className="text-[9px] text-zinc-600 bg-black/40 px-1.5 py-0.5 rounded border border-zinc-800">
                                  {rate}/{fuelType === 'Diesel' ? 'diesel' : 'lgf'}
                              </span>
                          </div>
                      </div>
                  );
              })}
              
              {currentMachine.type === 'Deployable' && currentMachine.id.includes('quarry') && (
                  <div className="text-center p-3 bg-zinc-900/50 rounded-xl border border-zinc-800 border-dashed">
                      <p className="text-[10px] text-zinc-500 italic">
                          * Deployable Quarry yield varies greatly based on Survey Charge results. Values shown are averages.
                      </p>
                  </div>
              )}
          </div>

      </div>
    </div>
  );
};
