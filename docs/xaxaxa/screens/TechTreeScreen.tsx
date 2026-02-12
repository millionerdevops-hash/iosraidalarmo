import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Search, 
  GitBranch,
  Hammer,
  Zap,
  Shield,
  Box,
  ChevronRight,
  Calculator
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface TechTreeScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// Simplified data structure for demo purposes
// In a full app, this would be a complete graph of ~200 items.
interface TechNode {
    id: string;
    name: string;
    unlockCost: number;
    tier: 1 | 2 | 3;
    parentId?: string; // Points to previous item in tree
}

// Sample Data representing "Meta" paths
const TECH_TREE_DATA: TechNode[] = [
    // --- TIER 1 ---
    { id: 't1_root', name: 'WB Level 1', unlockCost: 0, tier: 1 },
    { id: 'revolver', name: 'Revolver', unlockCost: 75, tier: 1, parentId: 't1_root' },
    { id: 'pistol_ammo', name: 'Pistol Ammo', unlockCost: 75, tier: 1, parentId: 'revolver' },
    { id: 'db_shotgun', name: 'Double Barrel', unlockCost: 75, tier: 1, parentId: 'pistol_ammo' },
    { id: 'satchel', name: 'Satchel Charge', unlockCost: 125, tier: 1, parentId: 'db_shotgun' },
    { id: 'beancan', name: 'Beancan Grenade', unlockCost: 75, tier: 1, parentId: 'satchel' },
    
    { id: 'ladder_hatch', name: 'Ladder Hatch', unlockCost: 125, tier: 1, parentId: 't1_root' }, // Simplified path for demo

    // --- TIER 2 (The most critical one) ---
    { id: 't2_root', name: 'WB Level 2', unlockCost: 0, tier: 2 },
    // Path A: Guns
    { id: 'med_syringe', name: 'Medical Syringe', unlockCost: 75, tier: 2, parentId: 't2_root' },
    { id: 'semi_rifle', name: 'Semi Auto Rifle', unlockCost: 125, tier: 2, parentId: 'med_syringe' },
    { id: 'semi_pistol', name: 'Semi Auto Pistol', unlockCost: 75, tier: 2, parentId: 'semi_rifle' },
    { id: 'thompson', name: 'Thompson', unlockCost: 125, tier: 2, parentId: 'semi_pistol' },
    { id: 'ammo_556', name: '5.56 Ammo', unlockCost: 125, tier: 2, parentId: 'thompson' },
    
    // Path B: Construction / Garage Door (Approximated path logic)
    { id: 'stone_gate', name: 'High Ext. Stone Gate', unlockCost: 75, tier: 2, parentId: 't2_root' },
    { id: 'stone_wall', name: 'High Ext. Stone Wall', unlockCost: 75, tier: 2, parentId: 'stone_gate' },
    { id: 'large_box', name: 'Large Wood Box', unlockCost: 75, tier: 2, parentId: 'stone_wall' },
    { id: 'garage_door', name: 'Garage Door', unlockCost: 75, tier: 2, parentId: 'large_box' },
    
    // Path C: Electrical
    { id: 'solar', name: 'Large Solar Panel', unlockCost: 75, tier: 2, parentId: 't2_root' },
    { id: 'battery_med', name: 'Medium Battery', unlockCost: 75, tier: 2, parentId: 'solar' },
    { id: 'wind_turbine', name: 'Wind Turbine', unlockCost: 125, tier: 2, parentId: 'battery_med' },

    // --- TIER 3 ---
    { id: 't3_root', name: 'WB Level 3', unlockCost: 0, tier: 3 },
    { id: 'mp5', name: 'MP5A4', unlockCost: 125, tier: 3, parentId: 't3_root' },
    { id: 'c4', name: 'Timed Explosive', unlockCost: 500, tier: 3, parentId: 'mp5' },
    { id: 'rocket', name: 'Rocket', unlockCost: 500, tier: 3, parentId: 'c4' },
    { id: 'launcher', name: 'Rocket Launcher', unlockCost: 500, tier: 3, parentId: 'rocket' },
    { id: 'ak47', name: 'Assault Rifle', unlockCost: 500, tier: 3, parentId: 'launcher' },
    { id: 'metal_facemask', name: 'Metal Facemask', unlockCost: 125, tier: 3, parentId: 'ak47' },
    { id: 'metal_chest', name: 'Metal Chestplate', unlockCost: 125, tier: 3, parentId: 'metal_facemask' },
];

export const TechTreeScreen: React.FC<TechTreeScreenProps> = ({ onNavigate }) => {
  const [activeTier, setActiveTier] = useState<1 | 2 | 3>(2);
  const [search, setSearch] = useState('');
  const [selectedNodeId, setSelectedNodeId] = useState<string | null>(null);

  // --- LOGIC ---
  
  const getPath = (targetId: string): TechNode[] => {
      const path: TechNode[] = [];
      let currentId: string | undefined = targetId;
      
      while (currentId) {
          const node = TECH_TREE_DATA.find(n => n.id === currentId);
          if (node) {
              path.unshift(node); // Add to front
              currentId = node.parentId;
          } else {
              currentId = undefined;
          }
      }
      return path;
  };

  const calculateTotalCost = (path: TechNode[]) => {
      return path.reduce((sum, node) => sum + node.unlockCost, 0);
  };

  const selectedNode = selectedNodeId ? TECH_TREE_DATA.find(n => n.id === selectedNodeId) : null;
  const path = selectedNode ? getPath(selectedNode.id) : [];
  const totalCost = calculateTotalCost(path);

  const filteredItems = TECH_TREE_DATA.filter(n => 
      n.tier === activeTier && 
      n.name.toLowerCase().includes(search.toLowerCase()) && 
      n.unlockCost > 0 // Hide Root nodes from search
  );

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center gap-4 bg-[#0c0c0e] z-10">
        <button 
          onClick={() => onNavigate('DASHBOARD')}
          className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-all"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
           <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Tech Tree</h2>
           <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Path Cost Calculator</p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar pb-10 p-4">
         
         {/* TIER TABS */}
         <div className="flex bg-zinc-900 p-1 rounded-xl border border-zinc-800 mb-4">
             {[1, 2, 3].map((tier) => (
                 <button
                    key={tier}
                    onClick={() => { setActiveTier(tier as any); setSelectedNodeId(null); }}
                    className={`flex-1 py-3 rounded-lg text-xs font-bold uppercase transition-all flex flex-col items-center gap-1
                        ${activeTier === tier 
                            ? tier === 1 ? 'bg-zinc-800 text-white border border-zinc-600 shadow-lg'
                            : tier === 2 ? 'bg-[#1e293b] text-blue-400 border border-blue-900 shadow-lg'
                            : 'bg-[#271a1a] text-red-500 border border-red-900 shadow-lg'
                            : 'text-zinc-500 hover:text-zinc-300'}
                    `}
                 >
                     <span className="opacity-50">Tier {tier}</span>
                     {tier === 1 && <Hammer className="w-4 h-4" />}
                     {tier === 2 && <Zap className="w-4 h-4" />}
                     {tier === 3 && <Shield className="w-4 h-4" />}
                 </button>
             ))}
         </div>

         {/* RESULT CARD */}
         {selectedNode ? (
             <div className="bg-[#18181b] border border-cyan-500/30 rounded-2xl p-5 mb-6 shadow-[0_0_30px_rgba(6,182,212,0.1)] relative overflow-hidden animate-in fade-in slide-in-from-top-4">
                 <div className="absolute top-0 left-0 w-1 h-full bg-cyan-500" />
                 
                 <div className="flex justify-between items-start mb-4">
                     <div>
                         <div className="text-[10px] text-cyan-500 font-bold uppercase tracking-widest mb-1">Target Acquired</div>
                         <h3 className="text-2xl text-white font-black uppercase leading-none">{selectedNode.name}</h3>
                     </div>
                     <div className="text-right">
                         <div className="text-3xl text-white font-mono font-black tracking-tighter">{totalCost}</div>
                         <div className="text-[10px] text-zinc-500 font-bold uppercase">Total Scrap</div>
                     </div>
                 </div>

                 {/* Path Visualization */}
                 <div className="bg-black/40 rounded-xl p-3 border border-zinc-800/50 max-h-48 overflow-y-auto no-scrollbar">
                     <div className="space-y-3 relative">
                         {/* Vertical Line */}
                         <div className="absolute left-[9px] top-2 bottom-2 w-0.5 bg-zinc-800 z-0" />
                         
                         {path.map((node, index) => {
                             const isTarget = node.id === selectedNode.id;
                             const isRoot = index === 0;
                             
                             return (
                                <div key={node.id} className="flex items-center gap-3 relative z-10">
                                    <div className={`w-5 h-5 rounded-full flex items-center justify-center border-2 
                                        ${isTarget ? 'bg-cyan-500 border-cyan-500' : isRoot ? 'bg-zinc-800 border-zinc-700' : 'bg-[#0c0c0e] border-zinc-700'}
                                    `}>
                                        {isTarget && <div className="w-2 h-2 bg-white rounded-full animate-pulse" />}
                                    </div>
                                    <div className="flex-1 flex justify-between items-center p-2 rounded bg-zinc-900/50 border border-zinc-800/50">
                                        <span className={`text-xs font-bold ${isTarget ? 'text-white' : 'text-zinc-400'}`}>
                                            {node.name}
                                        </span>
                                        {node.unlockCost > 0 && (
                                            <span className="text-[10px] font-mono text-zinc-500">
                                                -{node.unlockCost}
                                            </span>
                                        )}
                                    </div>
                                </div>
                             );
                         })}
                     </div>
                 </div>
                 
                 <button 
                    onClick={() => setSelectedNodeId(null)}
                    className="w-full mt-4 py-2 text-xs font-bold text-cyan-500 uppercase hover:text-cyan-400"
                 >
                     Select Different Target
                 </button>
             </div>
         ) : (
             <div className="bg-zinc-900/30 border border-zinc-800 p-6 rounded-2xl text-center mb-6">
                 <GitBranch className="w-10 h-10 text-zinc-600 mx-auto mb-3" />
                 <p className="text-zinc-400 text-sm">Select an item below to calculate the total path cost from the start of the tree.</p>
             </div>
         )}

         {/* SEARCH */}
         <div className="relative mb-4">
             <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
             <input 
                type="text" 
                placeholder="Search tech tree..." 
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="w-full bg-zinc-900 border border-zinc-800 rounded-xl py-3 pl-10 pr-4 text-sm text-white placeholder:text-zinc-600 focus:border-cyan-500 outline-none transition-colors"
             />
         </div>

         {/* ITEM LIST */}
         <div className="space-y-2">
             {filteredItems.map((node) => (
                 <button 
                    key={node.id}
                    onClick={() => setSelectedNodeId(node.id)}
                    className={`w-full flex items-center justify-between p-4 rounded-xl border text-left transition-all active:scale-[0.98]
                        ${selectedNodeId === node.id 
                            ? 'bg-cyan-900/20 border-cyan-500/50' 
                            : 'bg-zinc-900 border-zinc-800 hover:bg-zinc-800'}
                    `}
                 >
                     <div className="flex items-center gap-3">
                         <div className="w-8 h-8 bg-black/40 rounded flex items-center justify-center border border-zinc-700">
                             <Box className="w-4 h-4 text-zinc-500" />
                         </div>
                         <span className="font-bold text-sm text-white">{node.name}</span>
                     </div>
                     <div className="flex items-center gap-2">
                         <span className="text-xs font-mono text-zinc-400">{node.unlockCost} Scrap</span>
                         <ChevronRight className="w-4 h-4 text-zinc-600" />
                     </div>
                 </button>
             ))}
             {filteredItems.length === 0 && (
                 <div className="text-center py-8 text-zinc-600 text-xs italic">
                     No items found. Try a broader search or switch Tiers.
                 </div>
             )}
         </div>

      </div>
    </div>
  );
};