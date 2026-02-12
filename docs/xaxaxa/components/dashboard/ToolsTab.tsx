
import React, { useState, useEffect } from 'react';
import { 
  Calculator, 
  Video,
  Coffee,
  ArrowRightLeft,
  Lightbulb,
  Coins,
  Hammer,
  Dna,
  Fuel,
  Map as MapIcon,
  BookOpen,
  Wifi,
  Target,
  ShoppingCart,
  Recycle,
  PackageOpen,
  Gamepad2,
  Volume2,
  Flame,
  Lock,
  UserPlus,
  Grab,
  Crosshair,
  Shield, 
  Workflow,
  Spade,
  Disc,
  Clock
} from 'lucide-react';
import { ScreenName } from '../../types';
import { ToolsMenuCard } from './ToolsMenuCard';

interface ToolsTabProps {
  onNavigate: (screen: ScreenName) => void;
}

// Outpost Exchange Rates Data
const EXCHANGE_RATES = [
    { from: 'Wood', to: 'Stone', ratio: '1 : 3' },
    { from: 'Scrap', to: 'LGF', ratio: '1 : 4' },
    { from: 'Scrap', to: 'Metal', ratio: '1 : 25' },
    { from: 'Scrap', to: 'Smoke', ratio: '5 : 1' },
    { from: 'Comp', to: 'Scrap', ratio: 'Recycler' },
];

// Random Rust Tips
const TACTICAL_TIPS = [
    "Stone walls have a soft side. 7 Spears can break one silently.",
    "Garage doors take 9 Satchels or 3 Rockets to destroy.",
    "Always airlock your base with a triangle foundation.",
    "Place sleeping bags near monuments for quick scrap runs.",
    "Recycling components at Outpost is 20% less efficient than monuments.",
    "Sam Sites require 500 scrap to purchase at Outpost.",
    "Minicopters decay in 8 hours if not housed under a roof."
];

export const ToolsTab: React.FC<ToolsTabProps> = ({ onNavigate }) => {
  const [tipIndex, setTipIndex] = useState(0);

  // Rotate tips occasionally
  useEffect(() => {
      setTipIndex(Math.floor(Math.random() * TACTICAL_TIPS.length));
  }, []);

  return (
      <div className="space-y-6 animate-in fade-in slide-in-from-bottom-2 duration-300 pb-32">
          
          {/* SECTION HEADER */}
          <div className="px-1 flex items-center justify-between pt-4">
              <span className="text-xs font-bold text-zinc-500 uppercase tracking-widest">Essential Utilities</span>
          </div>

          {/* TOOL CARDS STACK */}
          <div className="space-y-3">
              
              {/* DEVICE PAIRING */}
              <ToolsMenuCard
                title="DEVICE CONTROL"
                subtitle="Switches, Alarms & Turrets"
                icon={Wifi}
                image="https://files.facepunch.com/paddy/20200528/header.jpg"
                onClick={() => onNavigate('DEVICE_PAIRING')}
                color="text-green-500"
              />

              {/* WHEEL OF FORTUNE */}
              <ToolsMenuCard
                title="SPIN WHEEL"
                subtitle="Bandit Camp Gambling"
                icon={Disc}
                image="https://rustlabs.com/img/items180/spinning.wheel.png"
                onClick={() => onNavigate('WHEEL_GAME')}
                color="text-yellow-500"
              />

              {/* BLACKJACK */}
              <ToolsMenuCard
                title="BANDIT BLACKJACK"
                subtitle="Scrap Gambling Sim"
                icon={Spade}
                image="https://files.facepunch.com/paddy/20180802/bandit_town_header.jpg"
                onClick={() => onNavigate('BLACKJACK')}
                color="text-purple-500"
              />

              {/* AUTOMATION */}
              <ToolsMenuCard
                title="SMART LOGIC"
                subtitle="Triggers & Automations"
                icon={Workflow}
                image="https://rustlabs.com/img/items180/wiretool.png"
                onClick={() => onNavigate('AUTOMATION_LIST')}
                color="text-red-500"
              />

              {/* DECAY TIMERS - NEW */}
              <ToolsMenuCard
                title="DECAY TIMERS"
                subtitle="Despawn & Upkeep Info"
                icon={Clock}
                image="https://files.facepunch.com/paddy/20180504/DecayUpdate_Header.jpg"
                onClick={() => onNavigate('DECAY_TIMERS')}
                color="text-amber-500"
              />

              {/* ARMOR CALCULATOR */}
              <ToolsMenuCard
                title="ARMOR LAB"
                subtitle="Environment & PvP Sets"
                icon={Shield}
                image="https://rustlabs.com/img/items180/metal.facemask.png"
                onClick={() => onNavigate('ARMOR_CALCULATOR')}
                color="text-cyan-500"
              />

              {/* CODE BREAKER */}
              <ToolsMenuCard
                title="CODE RAIDER"
                subtitle="Lock Picking Sim"
                icon={Lock}
                image="https://rustlabs.com/img/items180/lock.code.png"
                onClick={() => onNavigate('CODE_BREAKER')}
                color="text-red-500"
              />

              {/* LOOT PANIC */}
              <ToolsMenuCard
                title="LOOT PANIC"
                subtitle="Fast Looting Trainer"
                icon={Grab}
                image="https://rustlabs.com/img/items180/supply.signal.png"
                onClick={() => onNavigate('LOOT_SIMULATOR')}
                color="text-cyan-400"
              />

              {/* AIM TRAINER */}
              <ToolsMenuCard
                title="REFLEX TRAINER"
                subtitle="Reaction Time Test"
                icon={Crosshair}
                image="https://rustlabs.com/img/items180/weapon.mod.holosight.png"
                onClick={() => onNavigate('AIM_TRAINER')}
                color="text-green-500"
              />

              {/* LFG CARD CREATOR */}
              <ToolsMenuCard
                title="TEAM BUILDER"
                subtitle="Create LFG Card"
                icon={UserPlus}
                image="https://files.facepunch.com/paddy/20201006/hardcore_header.jpg"
                onClick={() => onNavigate('TEAM_BUILDER')}
                color="text-blue-500"
              />

              {/* ROAST MY BASE */}
              <ToolsMenuCard
                title="ROAST MY BASE"
                subtitle="AI Rates Your Build"
                icon={Flame}
                image="https://files.facepunch.com/paddy/20200806/header.jpg"
                onClick={() => onNavigate('BASE_ROAST')}
                color="text-orange-500"
              />

              {/* SOUNDBOARD */}
              <ToolsMenuCard
                title="SOUNDBOARD"
                subtitle="Troll & Prank Sounds"
                icon={Volume2}
                image="https://files.facepunch.com/paddy/20210701/voice_props_header.jpg"
                onClick={() => onNavigate('SOUNDBOARD')}
                color="text-pink-500"
              />

              {/* SCRAP MATCH */}
              <ToolsMenuCard
                title="SCRAP MATCH"
                subtitle="Win Scrap & Test Memory"
                icon={Gamepad2}
                image="https://rustlabs.com/img/monuments/bandit-camp.png"
                onClick={() => onNavigate('MINI_GAME')}
                color="text-purple-500"
              />

              {/* CRATE SIMULATOR */}
              <ToolsMenuCard
                title="LOOT SIMULATOR"
                subtitle="Elite, Heli & Bradley Crates"
                icon={PackageOpen}
                image="https://rustlabs.com/img/items180/crate_elite.png"
                onClick={() => onNavigate('CRATE_SIMULATOR')}
                color="text-yellow-500"
              />

              {/* RAID CALCULATOR - CORE */}
              <ToolsMenuCard
                title="RAID COST"
                subtitle="Explosives & Sulfur"
                icon={Calculator}
                image="https://images.unsplash.com/photo-1629804568600-47b669b922a0?q=80&w=2670&auto=format&fit=crop"
                onClick={() => onNavigate('RAID_CALCULATOR')}
                color="text-orange-500"
              />

              {/* RECOIL TRAINER */}
              <ToolsMenuCard
                title="RECOIL TRAINER"
                subtitle="Spray Patterns (AK, MP5)"
                icon={Target}
                image="https://images.unsplash.com/photo-1595590424283-b8f17842773f?q=80&w=2670&auto=format&fit=crop"
                onClick={() => onNavigate('RECOIL_TRAINER')}
                color="text-red-500"
              />

              {/* MARKET MONITOR */}
              <ToolsMenuCard
                title="MARKET MONITOR"
                subtitle="Vendor Prices & Exchange"
                icon={ShoppingCart}
                image="https://rustlabs.com/img/items180/vending.machine.png"
                onClick={() => onNavigate('MARKET_MONITOR')}
                color="text-yellow-500"
              />

              {/* RECYCLER LOCATIONS */}
              <ToolsMenuCard
                title="RECYCLER SPOTS"
                subtitle="Safe & Monument Locations"
                icon={Recycle}
                image="https://rustlabs.com/img/items180/recycler_static.png"
                onClick={() => onNavigate('RECYCLER_GUIDE')}
                color="text-zinc-300"
              />

              {/* BLUEPRINT TRACKER */}
              <ToolsMenuCard
                title="BP TRACKER"
                subtitle="Clan Sync & Progress"
                icon={BookOpen}
                image="https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?q=80&w=2670&auto=format&fit=crop"
                onClick={() => onNavigate('BLUEPRINT_TRACKER')}
                color="text-blue-600"
              />

              {/* TECH TREE */}
              <ToolsMenuCard
                title="TECH TREE"
                subtitle="Path Cost & Unlocks"
                icon={Hammer}
                image="https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=2670&auto=format&fit=crop"
                onClick={() => onNavigate('TECH_TREE')}
                color="text-indigo-500"
              />

              {/* PUZZLE GUIDE */}
              <ToolsMenuCard
                title="PUZZLE GUIDE"
                subtitle="Keycards & Fuses"
                icon={MapIcon}
                image="https://images.unsplash.com/photo-1518331647614-7a1f04cd34cf?q=80&w=2669&auto=format&fit=crop"
                onClick={() => onNavigate('MONUMENT_PUZZLES')}
                color="text-blue-400"
              />

              {/* GENETICS LAB */}
              <ToolsMenuCard
                title="GENETICS LAB"
                subtitle="AI Crossbreeding Calc"
                icon={Dna}
                image="https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?q=80&w=2670&auto=format&fit=crop"
                onClick={() => onNavigate('GENE_CALCULATOR')}
                color="text-green-500"
              />

              {/* DIESEL CALCULATOR */}
              <ToolsMenuCard
                title="DIESEL CALC"
                subtitle="Excavator & Quarry Output"
                icon={Fuel}
                image="https://images.unsplash.com/photo-1599939571322-792a32690c60?q=80&w=2575&auto=format&fit=crop"
                onClick={() => onNavigate('DIESEL_CALCULATOR')}
                color="text-yellow-500"
              />

              {/* CCTV CODES */}
              <ToolsMenuCard
                title="CCTV CODES"
                subtitle="Monument Cams"
                icon={Video}
                image="https://images.unsplash.com/photo-1550751827-4bd374c3f58b?q=80&w=2670&auto=format&fit=crop"
                onClick={() => onNavigate('CCTV_CODES')}
                color="text-blue-500"
              />

              {/* TEA CALCULATOR */}
              <ToolsMenuCard
                title="TEA GUIDE"
                subtitle="Buffs & Recipes"
                icon={Coffee}
                image="https://images.unsplash.com/photo-1595981267035-7b04ca84a82d?q=80&w=2670&auto=format&fit=crop"
                onClick={() => onNavigate('TEA_CALCULATOR')}
                color="text-emerald-500"
              />
          </div>

          {/* --- NEW SECTION: MARKET WATCH (Outpost Rates) --- */}
          <div className="pt-2">
              <div className="px-1 flex items-center gap-2 mb-3">
                  <Coins className="w-4 h-4 text-yellow-500" />
                  <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Outpost Exchange</span>
              </div>
              
              <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-4 overflow-hidden">
                  <div className="flex gap-4 overflow-x-auto no-scrollbar pb-1">
                      {EXCHANGE_RATES.map((rate, i) => (
                          <div key={i} className="flex flex-col items-center min-w-[80px] border-r border-zinc-800/50 last:border-0 pr-4 last:pr-0">
                              <div className="text-[10px] text-zinc-500 uppercase font-bold mb-1 flex items-center gap-1">
                                  {rate.from} <ArrowRightLeft className="w-3 h-3" /> {rate.to}
                              </div>
                              <div className="text-white font-mono font-bold text-sm">
                                  {rate.ratio}
                              </div>
                          </div>
                      ))}
                  </div>
              </div>
          </div>

          {/* --- NEW SECTION: TACTICAL INTEL (Random Tip) --- */}
          <div className="bg-gradient-to-br from-blue-900/10 to-zinc-900 border border-blue-500/20 rounded-2xl p-5 relative overflow-hidden">
              <div className="absolute top-0 right-0 p-4 opacity-10">
                  <Lightbulb className="w-12 h-12 text-blue-500" />
              </div>
              
              <div className="flex items-start gap-3 relative z-10">
                  <div className="bg-blue-500/20 p-2 rounded-lg">
                      <Lightbulb className="w-5 h-5 text-blue-400" />
                  </div>
                  <div>
                      <h4 className="text-blue-400 font-bold text-xs uppercase mb-1">Tactical Intel</h4>
                      <p className="text-zinc-300 text-xs leading-relaxed font-medium">
                          "{TACTICAL_TIPS[tipIndex]}"
                      </p>
                  </div>
              </div>
          </div>

      </div>
  );
};
