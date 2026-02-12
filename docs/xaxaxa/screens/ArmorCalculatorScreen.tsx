
import React, { useState, useMemo } from 'react';
import { 
  ArrowLeft, 
  Shield, 
  Snowflake, 
  Radiation, 
  Skull, 
  Shirt, 
  Trash2,
  Info,
  Check,
  MapPin,
  CreditCard,
  Zap,
  Target
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { ARMOR_ITEMS, ArmorItem, ArmorSlot, HAZMAT_ITEM, PRESETS, ZONE_DATA, ZoneRequirement } from '../data/armorData';

interface ArmorCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

type LoadoutSlot = 'Head' | 'Chest_Outer' | 'Chest_Inner' | 'Legs_Outer' | 'Legs_Inner' | 'Feet' | 'Hands';

const SLOTS_CONFIG: { id: LoadoutSlot; label: string; icon: any }[] = [
    { id: 'Head', label: 'Head', icon: Skull },
    { id: 'Chest_Outer', label: 'Armor', icon: Shield },
    { id: 'Chest_Inner', label: 'Shirt', icon: Shirt },
    { id: 'Legs_Outer', label: 'Kilt', icon: Shield },
    { id: 'Legs_Inner', label: 'Pants', icon: Shirt },
    { id: 'Feet', label: 'Boots', icon: Shield },
    { id: 'Hands', label: 'Hands', icon: Shield },
];

export const ArmorCalculatorScreen: React.FC<ArmorCalculatorScreenProps> = ({ onNavigate }) => {
  const [loadout, setLoadout] = useState<Record<LoadoutSlot, ArmorItem | null>>({
      Head: null,
      Chest_Outer: null,
      Chest_Inner: null,
      Legs_Outer: null,
      Legs_Inner: null,
      Feet: null,
      Hands: null
  });

  const [isHazmat, setIsHazmat] = useState(false);
  const [activeSlot, setActiveSlot] = useState<LoadoutSlot | null>(null);
  
  // NEW: Selected Zone for Comparison
  const [selectedZoneId, setSelectedZoneId] = useState<string | null>(null);
  const [showZoneModal, setShowZoneModal] = useState(false);

  const activeZone = useMemo(() => ZONE_DATA.find(z => z.id === selectedZoneId), [selectedZoneId]);

  // --- ACTIONS ---
  const equipItem = (item: ArmorItem, slot: LoadoutSlot) => {
      if (item.id === 'hazmat') {
          setIsHazmat(true);
          setLoadout({
            Head: null, Chest_Outer: null, Chest_Inner: null, Legs_Outer: null, Legs_Inner: null, Feet: null, Hands: null
          });
      } else {
          setIsHazmat(false);
          setLoadout(prev => ({ ...prev, [slot]: item }));
      }
      setActiveSlot(null);
  };

  const applyPreset = (presetId: string) => {
      if (presetId === 'rad_run') { // Legacy check
          setIsHazmat(true);
          return;
      }
      
      // Auto-configure for zone if needed
      // Logic for standard presets
      setIsHazmat(false);
      const newLoadout = { ...loadout };
      (Object.keys(newLoadout) as LoadoutSlot[]).forEach(k => newLoadout[k] = null);

      const itemsToEquip = PRESETS.find(p => p.id === presetId)?.items || [];
      
      // Basic Mapper from Item ID to Slot
      itemsToEquip.forEach(itemId => {
          const item = ARMOR_ITEMS.find(i => i.id === itemId);
          if (item) {
              if (item.id === 'hazmat') { setIsHazmat(true); return; }
              // Auto-slot logic (Simplified)
              if (item.slot === 'Head') newLoadout.Head = item;
              else if (item.slot === 'Boots') newLoadout.Feet = item;
              else if (item.slot === 'Hands') newLoadout.Hands = item;
              else if (item.slot === 'Chest') {
                  // If it's hoodie/wetsuit/tanktop put in inner
                  if (['hoodie', 'wetsuit', 'tank_top'].includes(item.id)) newLoadout.Chest_Inner = item;
                  else newLoadout.Chest_Outer = item;
              }
              else if (item.slot === 'Legs') {
                  if (['pants'].includes(item.id)) newLoadout.Legs_Inner = item;
                  else newLoadout.Legs_Outer = item;
              }
          }
      });

      if (!isHazmat) setLoadout(newLoadout);
  };

  const clearAll = () => {
      setIsHazmat(false);
      setLoadout({
        Head: null, Chest_Outer: null, Chest_Inner: null, Legs_Outer: null, Legs_Inner: null, Feet: null, Hands: null
      });
      setSelectedZoneId(null);
  };

  // --- STATS CALC ---
  const stats = useMemo(() => {
      if (isHazmat) return HAZMAT_ITEM.stats;

      const total = { projectile: 0, cold: 0, radiation: 0, explosion: 0 };
      (Object.values(loadout) as (ArmorItem | null)[]).forEach(item => {
          if (item) {
              total.projectile += item.stats.projectile;
              total.cold += item.stats.cold;
              total.radiation += item.stats.radiation;
              total.explosion += item.stats.explosion;
          }
      });
      return total;
  }, [loadout, isHazmat]);

  const suit = useMemo(() => {
      if (stats.cold >= 40) return { label: 'ARCTIC SAFE', color: 'text-cyan-400' };
      if (stats.cold >= 20) return { label: 'DAYTIME SNOW', color: 'text-blue-300' };
      if (stats.radiation >= 25) return { label: 'RAD TOWN READY', color: 'text-green-400' };
      if (stats.radiation >= 10) return { label: 'LOW RADS', color: 'text-green-600' };
      if (stats.projectile >= 45) return { label: 'PVP TANK', color: 'text-red-500' };
      return { label: 'CASUAL ROAM', color: 'text-zinc-400' };
  }, [stats]);

  // Requirement Check Logic
  const zoneCheck = useMemo(() => {
      if (!activeZone) return null;
      const radSafe = stats.radiation >= activeZone.rads;
      const coldSafe = stats.cold >= activeZone.cold;
      const isHazmatRequired = activeZone.rads >= 50;
      const hazmatCheck = isHazmatRequired ? isHazmat : true;

      return {
          radSafe,
          coldSafe,
          hazmatCheck,
          allSafe: radSafe && coldSafe && hazmatCheck
      };
  }, [activeZone, stats, isHazmat]);

  // Filter items for modal
  const getItemsForSlot = (slot: LoadoutSlot) => {
      return ARMOR_ITEMS.filter(item => {
          if (slot === 'Head') return item.slot === 'Head';
          if (slot === 'Feet') return item.slot === 'Boots';
          if (slot === 'Hands') return item.slot === 'Hands';
          if (slot === 'Chest_Outer') return ['Metal Chest Plate', 'Road Sign Jacket', 'Jacket', 'Snow Jacket', 'Heavy Plate Jacket'].includes(item.name);
          if (slot === 'Chest_Inner') return ['Hoodie', 'Wetsuit', 'Diving Tank'].includes(item.name);
          if (slot === 'Legs_Outer') return ['Road Sign Kilt', 'Wood Armor Pants', 'Heavy Plate Pants'].includes(item.name);
          if (slot === 'Legs_Inner') return ['Pants'].includes(item.name);
          return false;
      });
  };

  const getCardColor = (c: string) => c === 'Green' ? 'bg-green-500' : c === 'Blue' ? 'bg-blue-500' : 'bg-red-600';

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Armor Calc</h2>
                <div className="flex items-center gap-1.5 text-zinc-500 text-xs font-mono uppercase tracking-wider">
                    <Shield className="w-3 h-3" /> Protection Stats
                </div>
            </div>
        </div>
        <button onClick={clearAll} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-red-500 transition-colors">
            <Trash2 className="w-5 h-5" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 flex flex-col pb-20">
          
          {/* ZONE SELECTION BAR */}
          <button 
            onClick={() => setShowZoneModal(true)}
            className="w-full bg-zinc-900 border border-zinc-800 p-3 rounded-xl mb-4 flex items-center justify-between group hover:border-zinc-700 transition-all"
          >
              <div className="flex items-center gap-3">
                  <div className={`w-10 h-10 rounded-lg flex items-center justify-center border ${activeZone ? 'bg-blue-900/20 border-blue-500/50 text-blue-400' : 'bg-black/40 border-zinc-800 text-zinc-600'}`}>
                      <MapPin className="w-5 h-5" />
                  </div>
                  <div className="text-left">
                      <span className="text-[10px] font-bold text-zinc-500 uppercase tracking-wider block">Target Zone</span>
                      <span className={`font-bold text-sm ${activeZone ? 'text-white' : 'text-zinc-600'}`}>
                          {activeZone ? activeZone.name : 'Tap to Select...'}
                      </span>
                  </div>
              </div>
              <div className="text-xs text-zinc-500 group-hover:text-white transition-colors">Change</div>
          </button>

          {/* 1. STATS DISPLAY */}
          <div className={`border rounded-2xl p-5 mb-6 shadow-xl relative overflow-hidden transition-colors duration-300
              ${zoneCheck ? (zoneCheck.allSafe ? 'bg-green-950/10 border-green-500/30' : 'bg-red-950/10 border-red-500/30') : 'bg-[#18181b] border-zinc-800'}
          `}>
              {/* Status Header */}
              <div className="flex justify-between items-start mb-4 relative z-10">
                  <div>
                      <div className="text-[10px] text-zinc-500 font-bold uppercase tracking-widest mb-1">Status</div>
                      <div className={`text-xl font-black ${suit.color} uppercase tracking-tight`}>
                          {zoneCheck ? (zoneCheck.allSafe ? 'ZONE SAFE' : 'UNSAFE') : suit.label}
                      </div>
                  </div>
                  {isHazmat && (
                      <div className="px-2 py-1 bg-yellow-500/20 text-yellow-500 text-[9px] font-black uppercase rounded border border-yellow-500/50">
                          Hazmat Suit
                      </div>
                  )}
              </div>

              {/* Requirement Feedback (If Zone Active) */}
              {activeZone && zoneCheck && !zoneCheck.allSafe && (
                  <div className="mb-4 bg-black/40 p-2 rounded-lg border border-red-500/20">
                      {!zoneCheck.radSafe && <div className="text-[10px] text-red-400 font-bold flex items-center gap-1"><Radiation className="w-3 h-3"/> Need {activeZone.rads}% Rad Prot (Have {stats.radiation}%)</div>}
                      {!zoneCheck.coldSafe && <div className="text-[10px] text-cyan-400 font-bold flex items-center gap-1"><Snowflake className="w-3 h-3"/> Need {activeZone.cold}% Cold Prot (Have {stats.cold}%)</div>}
                      {!zoneCheck.hazmatCheck && <div className="text-[10px] text-yellow-500 font-bold flex items-center gap-1"><Shield className="w-3 h-3"/> Hazmat Required</div>}
                  </div>
              )}

              {/* Stats Grid */}
              <div className="grid grid-cols-3 gap-3 relative z-10">
                  {/* COLD */}
                  <div className={`rounded-xl p-3 flex flex-col items-center border ${activeZone && !zoneCheck?.coldSafe ? 'bg-red-500/10 border-red-500 text-red-500' : 'bg-cyan-900/20 border-cyan-500/30 text-white'}`}>
                      <Snowflake className="w-5 h-5 text-cyan-400 mb-1" />
                      <span className="text-xl font-black">{stats.cold}%</span>
                      <span className="text-[9px] text-cyan-500 font-bold uppercase">Cold</span>
                  </div>
                  {/* RAD */}
                  <div className={`rounded-xl p-3 flex flex-col items-center border ${activeZone && !zoneCheck?.radSafe ? 'bg-red-500/10 border-red-500 text-red-500' : 'bg-green-900/20 border-green-500/30 text-white'}`}>
                      <Radiation className="w-5 h-5 text-green-400 mb-1" />
                      <span className="text-xl font-black">{stats.radiation}%</span>
                      <span className="text-[9px] text-green-500 font-bold uppercase">Rad</span>
                  </div>
                  {/* PROJ */}
                  <div className="bg-red-900/20 border border-red-500/30 rounded-xl p-3 flex flex-col items-center">
                      <Skull className="w-5 h-5 text-red-400 mb-1" />
                      <span className="text-xl font-black text-white">{stats.projectile}%</span>
                      <span className="text-[9px] text-red-500 font-bold uppercase">Proj</span>
                  </div>
              </div>
          </div>

          {/* 2. ZONE DETAILS (If Active) */}
          {activeZone && (
              <div className="mb-6 animate-in slide-in-from-top-2">
                  <div className="flex items-center gap-2 mb-2 px-1">
                      <Info className="w-3 h-3 text-zinc-500" />
                      <span className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest">Entry Requirements</span>
                  </div>
                  <div className="bg-[#18181b] border border-zinc-800 rounded-xl p-3 flex justify-between items-center">
                      <div className="flex gap-2">
                          {activeZone.cards.length > 0 ? activeZone.cards.map(c => (
                              <div key={c} className={`px-2 py-1 rounded text-[10px] font-bold uppercase text-black ${getCardColor(c)} flex items-center gap-1 shadow-sm`}>
                                  <CreditCard className="w-3 h-3" /> {c}
                              </div>
                          )) : <span className="text-zinc-600 text-xs">No Cards</span>}
                      </div>
                      
                      {activeZone.fuse > 0 && (
                          <div className="flex items-center gap-1 bg-yellow-500/10 px-2 py-1 rounded border border-yellow-500/30 text-yellow-500 text-[10px] font-bold uppercase">
                              <Zap className="w-3 h-3" /> {activeZone.fuse} Fuse
                          </div>
                      )}
                  </div>
                  <p className="text-[10px] text-zinc-500 mt-2 px-1 italic">"{activeZone.notes}"</p>
              </div>
          )}

          {/* 3. PAPER DOLL (Slots) */}
          <div className="flex-1">
              {isHazmat ? (
                  <button 
                    onClick={() => setIsHazmat(false)}
                    className="w-full h-64 bg-zinc-900/30 border-2 border-dashed border-zinc-700 rounded-2xl flex flex-col items-center justify-center gap-4 group hover:border-yellow-500 hover:bg-yellow-500/10 transition-all"
                  >
                      <img src={HAZMAT_ITEM.image} alt="Hazmat" className="w-32 h-32 object-contain drop-shadow-xl" />
                      <div className="text-center">
                          <span className="text-white font-bold block">Hazmat Suit Equipped</span>
                          <span className="text-xs text-zinc-500">Tap to remove</span>
                      </div>
                  </button>
              ) : (
                  <div className="grid grid-cols-2 gap-x-4 gap-y-3">
                      {SLOTS_CONFIG.map((slot, i) => {
                          const equipped = loadout[slot.id];
                          const isHead = slot.id === 'Head';
                          
                          return (
                              <button
                                key={slot.id}
                                onClick={() => setActiveSlot(slot.id)}
                                className={`relative bg-zinc-900 border border-zinc-800 rounded-xl p-2 flex items-center gap-3 transition-all active:scale-95 hover:border-zinc-600
                                    ${isHead ? 'col-span-2 justify-center py-4 bg-zinc-900/80' : ''}
                                    ${equipped ? 'border-zinc-600' : ''}
                                `}
                              >
                                  <div className={`rounded-lg flex items-center justify-center bg-black/40 ${isHead ? 'w-16 h-16' : 'w-12 h-12'}`}>
                                      {equipped ? (
                                          <img src={equipped.image} className="w-full h-full object-contain" alt="" />
                                      ) : (
                                          <slot.icon className={`text-zinc-700 ${isHead ? 'w-8 h-8' : 'w-5 h-5'}`} />
                                      )}
                                  </div>
                                  <div className={`text-left ${isHead ? 'absolute left-4 bottom-4' : ''}`}>
                                      <span className="text-[9px] text-zinc-500 font-bold uppercase block">{slot.label}</span>
                                      <span className={`text-xs font-bold leading-tight ${equipped ? 'text-white' : 'text-zinc-600'}`}>
                                          {equipped ? equipped.name : 'Empty'}
                                      </span>
                                  </div>
                              </button>
                          );
                      })}
                  </div>
              )}
          </div>

          {/* 4. PRESETS */}
          <div className="mt-6">
              <div className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest mb-3 flex items-center gap-2">
                  <Target className="w-3 h-3" /> Quick Loadouts
              </div>
              <div className="grid grid-cols-2 gap-3">
                  {PRESETS.map(preset => (
                      <button
                        key={preset.id}
                        onClick={() => applyPreset(preset.id)}
                        className={`p-3 rounded-xl bg-gradient-to-br ${preset.bg} to-zinc-900 border border-white/5 text-left relative overflow-hidden group active:scale-[0.98] transition-all`}
                      >
                          <div className="absolute inset-0 bg-black/20 group-hover:bg-transparent transition-colors" />
                          <div className="relative z-10">
                              <h4 className="text-white font-bold text-sm uppercase">{preset.name}</h4>
                              <p className="text-[10px] text-white/60 leading-tight mt-1">{preset.description}</p>
                          </div>
                      </button>
                  ))}
              </div>
          </div>

      </div>

      {/* ZONE SELECTION MODAL */}
      {showZoneModal && (
          <div className="absolute inset-0 z-50 bg-[#0c0c0e]/95 backdrop-blur-md flex flex-col animate-in slide-in-from-bottom duration-300">
              <div className="p-4 border-b border-zinc-800 flex justify-between items-center bg-[#0c0c0e]">
                  <h3 className="text-white font-bold text-lg uppercase flex items-center gap-2">
                      <MapPin className="w-5 h-5 text-orange-500" /> Select Destination
                  </h3>
                  <button onClick={() => setShowZoneModal(false)} className="p-2 text-zinc-500 hover:text-white">
                      Close
                  </button>
              </div>
              <div className="flex-1 overflow-y-auto p-4 space-y-2">
                  <button 
                    onClick={() => { setSelectedZoneId(null); setShowZoneModal(false); }}
                    className="w-full p-4 rounded-xl border border-dashed border-zinc-700 text-zinc-500 font-bold uppercase text-xs hover:text-white hover:border-white/20 mb-2"
                  >
                      Clear Zone
                  </button>

                  {ZONE_DATA.map(zone => (
                      <button
                        key={zone.id}
                        onClick={() => { setSelectedZoneId(zone.id); setShowZoneModal(false); }}
                        className={`w-full text-left p-4 rounded-xl border transition-all active:scale-[0.98]
                            ${selectedZoneId === zone.id ? 'bg-zinc-800 border-orange-500' : 'bg-zinc-900 border-zinc-800 hover:border-zinc-600'}
                        `}
                      >
                          <div className="flex justify-between items-center mb-1">
                              <h4 className="text-white font-bold text-sm uppercase">{zone.name}</h4>
                              <div className="flex gap-1">
                                  {zone.rads > 25 && <Radiation className="w-4 h-4 text-green-500" />}
                                  {zone.cold > 20 && <Snowflake className="w-4 h-4 text-cyan-500" />}
                              </div>
                          </div>
                          <div className="flex gap-3 text-[10px] text-zinc-400 font-mono">
                              <span>Rad: {zone.rads > 0 ? `${zone.rads}%` : 'Safe'}</span>
                              <span>Cold: {zone.cold > 0 ? `${zone.cold}%` : 'None'}</span>
                          </div>
                      </button>
                  ))}
              </div>
          </div>
      )}

      {/* ITEM SELECTION MODAL */}
      {activeSlot && (
          <div className="absolute inset-0 z-50 bg-[#0c0c0e]/95 backdrop-blur-md flex flex-col animate-in slide-in-from-bottom duration-300">
              <div className="p-4 border-b border-zinc-800 flex justify-between items-center bg-[#0c0c0e]">
                  <h3 className="text-white font-bold text-lg uppercase flex items-center gap-2">
                      Select {SLOTS_CONFIG.find(s => s.id === activeSlot)?.label}
                  </h3>
                  <button onClick={() => setActiveSlot(null)} className="p-2 text-zinc-500 hover:text-white">
                      Close
                  </button>
              </div>
              <div className="flex-1 overflow-y-auto p-4 space-y-2">
                  <button 
                    onClick={() => { setLoadout(prev => ({ ...prev, [activeSlot]: null })); setActiveSlot(null); }}
                    className="w-full p-3 rounded-xl bg-red-900/20 border border-red-500/30 text-red-400 font-bold uppercase text-xs flex items-center justify-center gap-2 mb-4"
                  >
                      <Trash2 className="w-4 h-4" /> Unequip
                  </button>

                  {getItemsForSlot(activeSlot).map(item => (
                      <button
                        key={item.id}
                        onClick={() => equipItem(item, activeSlot)}
                        className="w-full flex items-center gap-4 p-3 rounded-xl bg-zinc-900 border border-zinc-800 hover:border-zinc-600 transition-all text-left"
                      >
                          <div className="w-12 h-12 bg-black/40 rounded-lg flex items-center justify-center border border-zinc-700">
                              <img src={item.image} className="w-10 h-10 object-contain" alt="" />
                          </div>
                          <div className="flex-1">
                              <div className="text-sm font-bold text-white mb-1">{item.name}</div>
                              <div className="flex gap-3">
                                  {item.stats.cold !== 0 && (
                                      <span className={`text-[10px] font-mono ${item.stats.cold > 0 ? 'text-cyan-400' : 'text-red-400'}`}>
                                          {item.stats.cold > 0 ? '+' : ''}{item.stats.cold}% Cold
                                      </span>
                                  )}
                                  {item.stats.projectile > 0 && <span className="text-[10px] text-red-400 font-mono">+{item.stats.projectile}% Proj</span>}
                                  {item.stats.radiation > 0 && <span className="text-[10px] text-green-400 font-mono">+{item.stats.radiation}% Rad</span>}
                              </div>
                          </div>
                          {loadout[activeSlot]?.id === item.id && <Check className="w-5 h-5 text-green-500" />}
                      </button>
                  ))}
              </div>
          </div>
      )}

    </div>
  );
};
