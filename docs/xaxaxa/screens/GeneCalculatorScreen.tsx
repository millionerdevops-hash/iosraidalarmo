
import React, { useState, useEffect } from 'react';
import { 
  ArrowLeft, 
  Sprout, 
  Plus, 
  Trash2, 
  RefreshCw, 
  CheckCircle2,
  AlertTriangle,
  Info,
  GitMerge,
  Grid3x3,
  Eraser,
  Dna,
  BookOpen,
  Star,
  Compass,
  X,
  Copy
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { Button } from '../components/Button';

interface GeneCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

type GeneType = 'G' | 'Y' | 'H' | 'W' | 'X';

// --- RUST GENETICS CONSTANTS ---
// Red genes (W, X) have higher weight (1.0) than Green genes (0.6)
const WEIGHTS: Record<GeneType, number> = {
    G: 0.6, 
    Y: 0.6, 
    H: 0.6, 
    W: 1.0, 
    X: 1.0  
};

const GENE_COLORS: Record<GeneType, string> = {
    G: 'text-green-500 bg-green-950/40 border-green-500/50',
    Y: 'text-yellow-400 bg-yellow-950/40 border-yellow-500/50',
    H: 'text-blue-400 bg-blue-950/40 border-blue-500/50',
    W: 'text-red-500 bg-red-950/40 border-red-500/50',
    X: 'text-red-500 bg-red-950/40 border-red-500/50'
};

const MAX_INVENTORY = 8;

const PRESETS: { label: string; sub: string; genes: GeneType[] }[] = [
    { label: 'Max Yield', sub: '4Y 2G', genes: ['G','G','Y','Y','Y','Y'] },
    { label: 'Balanced', sub: '3Y 3G', genes: ['G','G','G','Y','Y','Y'] },
    { label: 'Speed', sub: '4G 2Y', genes: ['G','G','G','G','Y','Y'] },
    { label: 'Hemp God', sub: '3Y 3G', genes: ['Y','Y','Y','G','G','G'] },
];

interface Clone {
    id: number;
    genes: GeneType[];
}

interface Solution {
    target: GeneType[];
    neighbors: { slot: string, cloneId: number, genes: GeneType[] }[]; // N, S, E, W
    score: number; // For sorting best solutions (fewer clones = better)
    chance: number; // 100% or 50%
}

// --- COMPONENTS ---

const GeneDisplay = ({ genes, size = 'md' }: { genes: GeneType[], size?: 'sm'|'md'|'lg' }) => {
    const boxSize = size === 'sm' ? 'w-4 h-4 text-[8px]' : size === 'md' ? 'w-6 h-6 text-[10px]' : 'w-8 h-8 text-xs';
    return (
        <div className="flex gap-0.5 justify-center">
            {genes.map((g, i) => (
                <div key={i} className={`${boxSize} flex items-center justify-center font-black border rounded-[3px] ${GENE_COLORS[g]}`}>
                    {g}
                </div>
            ))}
        </div>
    );
};

const GeneInputRow = ({ genes, onChange, label }: { genes: GeneType[], onChange: (newGenes: GeneType[]) => void, label?: string }) => {
    const cycleGene = (index: number) => {
        const types: GeneType[] = ['G', 'Y', 'H', 'W', 'X'];
        const current = genes[index];
        const nextIndex = (types.indexOf(current) + 1) % types.length;
        const newGenes = [...genes];
        newGenes[index] = types[nextIndex];
        onChange(newGenes);
    };

    return (
        <div className="flex items-center gap-2">
            {label && <span className="text-[10px] font-bold w-4 text-zinc-500">{label}</span>}
            <div className="flex gap-1">
                {genes.map((gene, idx) => (
                    <button
                        key={idx}
                        onClick={() => cycleGene(idx)}
                        className={`w-9 h-9 border-2 flex items-center justify-center font-black text-sm transition-all active:scale-95 rounded ${GENE_COLORS[gene]}`}
                    >
                        {gene}
                    </button>
                ))}
            </div>
        </div>
    );
};

export const GeneCalculatorScreen: React.FC<GeneCalculatorScreenProps> = ({ onNavigate }) => {
  // State
  const [targetGenes, setTargetGenes] = useState<GeneType[]>(['G', 'G', 'Y', 'Y', 'Y', 'Y']);
  const [inventory, setInventory] = useState<Clone[]>([
      { id: 1, genes: ['G', 'G', 'Y', 'H', 'X', 'Y'] },
      { id: 2, genes: ['Y', 'G', 'G', 'W', 'Y', 'Y'] },
      { id: 3, genes: ['G', 'X', 'Y', 'Y', 'G', 'H'] }
  ]);
  
  // Planter Visualization State (Index 0-8)
  // 0 1 2
  // 3 4 5
  // 6 7 8
  // Center is 4. Neighbors are 1(N), 3(W), 5(E), 7(S)
  const [planterState, setPlanterState] = useState<(Clone | null)[]>(Array(9).fill(null));
  const [selectedPlanterSlot, setSelectedPlanterSlot] = useState<number | null>(null);

  const [calculating, setCalculating] = useState(false);
  const [solutions, setSolutions] = useState<Solution[]>([]);
  const [noSolution, setNoSolution] = useState(false);
  const [showInfo, setShowInfo] = useState(false);

  // --- ACTIONS ---
  const addClone = () => {
      if (inventory.length >= MAX_INVENTORY) return;
      const newId = Math.max(0, ...inventory.map(i => i.id), 0) + 1;
      setInventory([...inventory, { id: newId, genes: ['G', 'Y', 'H', 'W', 'X', 'G'] }]);
  };

  const updateClone = (id: number, newGenes: GeneType[]) => {
      setInventory(inventory.map(c => c.id === id ? { ...c, genes: newGenes } : c));
  };

  const removeClone = (id: number) => {
      setInventory(inventory.filter(c => c.id !== id));
  };

  // --- SOLVER ENGINE ---
  const calculateCrossbreed = (parents: GeneType[][]): { result: GeneType[], chance: number } | null => {
      const resultGenes: GeneType[] = [];
      let minChance = 100;

      for (let i = 0; i < 6; i++) {
          const weights: Record<string, number> = { G: 0, Y: 0, H: 0, W: 0, X: 0 };
          
          // Sum weights for this slot across all parents
          parents.forEach(p => {
              const gene = p[i];
              weights[gene] += WEIGHTS[gene];
          });

          // Find winner
          let maxWeight = -1;
          let winners: string[] = [];

          for (const [gene, weight] of Object.entries(weights)) {
              if (weight > maxWeight) {
                  maxWeight = weight;
                  winners = [gene];
              } else if (weight === maxWeight) {
                  winners.push(gene);
              }
          }

          // If simple majority (or weighted majority)
          if (winners.length === 1) {
              resultGenes.push(winners[0] as GeneType);
          } else {
              // Tie (50/50). 
              // We pick the first one for the "Result" but mark chance as 50%
              resultGenes.push(winners[0] as GeneType);
              minChance = 50;
          }
      }
      return { result: resultGenes, chance: minChance };
  };

  const findRecipes = async () => {
      setCalculating(true);
      setSolutions([]);
      setNoSolution(false);

      // Yield to UI to show loading state
      await new Promise(r => setTimeout(r, 100));

      const targetStr = targetGenes.join('');
      const foundSolutions: Solution[] = [];

      // Helper to generate combinations with repetition
      // We need to check 2, 3, and 4 neighbors configuration
      // We can use the same clone multiple times!
      
      const inventoryIndices = inventory.map((_, i) => i);
      
      // We will try up to 4 neighbors. 
      // Optimization: We don't need to permute slots (N,S,E,W) for the *calculation*, 
      // just the *set* of parents matters for the weight sum.
      // However, for the UI, we assign them to slots.
      
      const tryCombinations = (k: number) => {
          const combinations: number[][] = [];
          
          // Generate combinations with repetition (n^k)
          // Since inventory is small (max 8), 8^4 = 4096 checks. Fast enough.
          const indices = Array(k).fill(0);
          
          while (true) {
              combinations.push([...indices]);
              let i = k - 1;
              while (i >= 0 && indices[i] === inventory.length - 1) {
                  indices[i] = 0;
                  i--;
              }
              if (i < 0) break;
              indices[i]++;
          }

          for (const comboIndices of combinations) {
              const parents = comboIndices.map(idx => inventory[idx]);
              const outcome = calculateCrossbreed(parents.map(p => p.genes));

              if (outcome && outcome.result.join('') === targetStr) {
                  // Valid Solution Found
                  const slots = ['N', 'S', 'E', 'W'].slice(0, k);
                  foundSolutions.push({
                      target: outcome.result,
                      neighbors: parents.map((p, i) => ({
                          slot: slots[i],
                          cloneId: p.id,
                          genes: p.genes
                      })),
                      score: k, // Prefer fewer clones (lower k)
                      chance: outcome.chance
                  });
              }
          }
      };

      // Try 2, 3, then 4 neighbors
      // We want to find "Best" options first (fewer clones required)
      tryCombinations(2);
      tryCombinations(3);
      tryCombinations(4);

      // Sort: 100% chance first, then fewer neighbors
      foundSolutions.sort((a, b) => {
          if (a.chance !== b.chance) return b.chance - a.chance;
          return a.score - b.score;
      });

      // Deduplicate (simple JSON stringify check for unique neighbor sets)
      const uniqueSolutions: Solution[] = [];
      const seen = new Set();
      
      for (const sol of foundSolutions) {
          // Sort neighbors by ID to check set uniqueness regardless of order
          const signature = sol.neighbors.map(n => n.cloneId).sort().join(',');
          if (!seen.has(signature)) {
              seen.add(signature);
              uniqueSolutions.push(sol);
          }
          if (uniqueSolutions.length >= 5) break; // Limit to top 5
      }

      setSolutions(uniqueSolutions);
      if (uniqueSolutions.length === 0) setNoSolution(true);
      setCalculating(false);
  };

  // --- MANUAL PLANTER INTERACTION ---
  const handleSlotClick = (idx: number) => {
      // Only allow neighbor slots (1,3,5,7)
      if ([1,3,5,7].includes(idx)) {
          setSelectedPlanterSlot(selectedPlanterSlot === idx ? null : idx);
      }
  };

  const placeCloneInSlot = (clone: Clone) => {
      if (selectedPlanterSlot !== null) {
          const next = [...planterState];
          next[selectedPlanterSlot] = clone;
          setPlanterState(next);
          setSelectedPlanterSlot(null);
          
          // Auto-calculate center if enough neighbors
          const neighbors = [1,3,5,7].map(i => next[i]).filter(c => c !== null) as Clone[];
          if (neighbors.length >= 2) {
              const outcome = calculateCrossbreed(neighbors.map(n => n.genes));
              if (outcome) {
                  // Update Center (Index 4)
                  next[4] = { id: 999, genes: outcome.result };
                  setPlanterState(next);
              }
          } else {
              // Clear center if not enough
              next[4] = null;
              setPlanterState(next);
          }
      }
  };

  const applySolutionToPlanter = (sol: Solution) => {
      const next = Array(9).fill(null);
      // Map solution slots to grid indices
      const slotMap: Record<string, number> = { 'N': 1, 'S': 7, 'W': 3, 'E': 5 };
      
      sol.neighbors.forEach(n => {
          const idx = slotMap[n.slot];
          if (idx) next[idx] = { id: n.cloneId, genes: n.genes };
      });
      
      // Set Center Result
      next[4] = { id: 999, genes: sol.target };
      setPlanterState(next);
      
      // Scroll to planter
      document.getElementById('planter-section')?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Gene Calculator</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Crossbreeding Solver</p>
            </div>
        </div>
        <button 
            onClick={() => setShowInfo(true)}
            className="text-zinc-500 hover:text-white"
        >
            <Info className="w-6 h-6" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 pb-24 space-y-6">
         
         {/* 1. TARGET */}
         <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-4 shadow-lg">
             <div className="flex justify-between items-center mb-4">
                 <div className="flex items-center gap-2">
                     <Star className="w-4 h-4 text-yellow-500" />
                     <h3 className="text-sm font-bold text-white uppercase">Goal</h3>
                 </div>
                 {/* Presets */}
                 <div className="flex gap-2">
                     {PRESETS.slice(0,3).map((p, i) => (
                         <button key={i} onClick={() => setTargetGenes([...p.genes])} className="text-[10px] bg-zinc-900 border border-zinc-800 px-2 py-1 rounded text-zinc-400 hover:text-white transition-colors">
                             {p.label}
                         </button>
                     ))}
                 </div>
             </div>
             
             <div className="flex justify-center">
                 <GeneInputRow genes={targetGenes} onChange={setTargetGenes} />
             </div>
         </div>

         {/* 2. INVENTORY */}
         <div>
             <div className="flex justify-between items-center mb-3 px-1">
                 <h3 className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Available Clones</h3>
                 <span className="text-[10px] font-mono text-zinc-600">{inventory.length}/{MAX_INVENTORY}</span>
             </div>

             <div className="space-y-3">
                 {inventory.map((clone, idx) => (
                     <div key={clone.id} className="flex items-center gap-3 bg-zinc-900/40 p-2 rounded-xl border border-zinc-800/50">
                         <div className="w-6 flex justify-center font-mono text-xs text-zinc-600 font-bold">#{idx+1}</div>
                         <div className="flex-1">
                             <GeneInputRow genes={clone.genes} onChange={(g) => updateClone(clone.id, g)} />
                         </div>
                         <div className="flex flex-col gap-1">
                             {selectedPlanterSlot !== null ? (
                                 <button 
                                    onClick={() => placeCloneInSlot(clone)}
                                    className="p-2 bg-orange-600 hover:bg-orange-500 text-white rounded-lg shadow-lg animate-pulse"
                                 >
                                     <ArrowLeft className="w-4 h-4" />
                                 </button>
                             ) : (
                                 <button onClick={() => removeClone(clone.id)} className="p-2 text-zinc-600 hover:text-red-500 transition-colors">
                                     <Trash2 className="w-4 h-4" />
                                 </button>
                             )}
                         </div>
                     </div>
                 ))}
                 
                 {inventory.length < MAX_INVENTORY && (
                     <button 
                        onClick={addClone}
                        className="w-full py-3 border border-dashed border-zinc-700 rounded-xl text-zinc-500 text-xs font-bold uppercase hover:text-white hover:bg-zinc-900 transition-all flex items-center justify-center gap-2"
                     >
                         <Plus className="w-4 h-4" /> Add Clone
                     </button>
                 )}
             </div>
         </div>

         {/* 3. CALCULATE BUTTON */}
         <Button onClick={findRecipes} disabled={calculating} className="shadow-lg shadow-green-900/20">
             {calculating ? <RefreshCw className="w-4 h-4 animate-spin" /> : <GitMerge className="w-4 h-4" />}
             {calculating ? 'Calculating...' : 'Find Breeding Recipe'}
         </Button>

         {/* 4. RESULTS SECTION */}
         {noSolution && (
             <div className="bg-red-950/20 border border-red-900/50 p-4 rounded-xl flex items-center gap-3 animate-in fade-in">
                 <AlertTriangle className="w-5 h-5 text-red-500" />
                 <div>
                     <p className="text-red-200 text-xs font-bold">No 100% solution found.</p>
                     <p className="text-red-400/60 text-[10px]">Try getting more 'G' or 'Y' clones to overpower the red genes.</p>
                 </div>
             </div>
         )}

         {solutions.length > 0 && (
             <div className="space-y-4 animate-in slide-in-from-bottom-4 duration-500">
                 <h3 className="text-xs font-bold text-green-500 uppercase tracking-widest px-1">Best Recipes Found</h3>
                 
                 {solutions.map((sol, idx) => (
                     <div key={idx} className="bg-[#18181b] border border-green-500/30 rounded-2xl p-4 shadow-xl relative overflow-hidden">
                         {idx === 0 && <div className="absolute top-0 right-0 bg-green-600 text-white text-[9px] font-black px-2 py-1 rounded-bl-lg">BEST OPTION</div>}
                         
                         <div className="flex items-center justify-between mb-4">
                             <div className="flex flex-col">
                                 <span className="text-[10px] text-zinc-500 uppercase font-bold">Result</span>
                                 <GeneDisplay genes={sol.target} size="md" />
                             </div>
                             <div className="text-right mr-8">
                                 <span className="text-[10px] text-zinc-500 uppercase font-bold">Chance</span>
                                 <div className={`text-lg font-black ${sol.chance === 100 ? 'text-green-500' : 'text-yellow-500'}`}>{sol.chance}%</div>
                             </div>
                         </div>

                         {/* Mini Grid Visualization */}
                         <div className="bg-black/40 rounded-xl p-3 border border-zinc-800/50">
                             <div className="text-[10px] text-zinc-500 font-mono mb-2 flex items-center gap-2">
                                 <Compass className="w-3 h-3" /> Placement Map
                             </div>
                             {sol.neighbors.map((n, i) => (
                                 <div key={i} className="flex justify-between items-center mb-1 text-xs">
                                     <span className="font-bold text-white w-4">{n.slot}:</span>
                                     <GeneDisplay genes={n.genes} size="sm" />
                                     <span className="text-[10px] text-zinc-500 font-mono">Clone #{inventory.findIndex(c => c.id === n.cloneId) + 1}</span>
                                 </div>
                             ))}
                         </div>

                         <button 
                            onClick={() => applySolutionToPlanter(sol)}
                            className="w-full mt-3 py-2 bg-zinc-800 hover:bg-zinc-700 rounded-lg text-[10px] font-bold uppercase text-zinc-300 transition-colors"
                         >
                             Visualize in Planter
                         </button>
                     </div>
                 ))}
             </div>
         )}

         {/* 5. PLANTER SIMULATOR (Bottom) */}
         <div id="planter-section" className="pt-8 border-t border-zinc-800">
             <div className="flex items-center justify-between mb-3 px-1">
                 <div className="flex items-center gap-2">
                     <Grid3x3 className="w-4 h-4 text-orange-500" />
                     <h3 className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Planter Simulator</h3>
                 </div>
                 <button onClick={() => setPlanterState(Array(9).fill(null))} className="text-[10px] text-red-400 flex items-center gap-1 hover:underline">
                     <Eraser className="w-3 h-3" /> Clear
                 </button>
             </div>

             <div className="bg-[#121214] p-4 rounded-2xl border-4 border-[#3a2e26] shadow-2xl">
                 <div className="grid grid-cols-3 gap-2">
                     {planterState.map((cell, i) => {
                         // Only corners (neighbors) and center are relevant usually
                         // 0 1 2
                         // 3 4 5
                         // 6 7 8
                         const isNeighbor = [1,3,5,7].includes(i);
                         const isCenter = i === 4;
                         const isValid = isNeighbor || isCenter;
                         const isSelected = selectedPlanterSlot === i;

                         return (
                             <button
                                key={i}
                                disabled={!isValid}
                                onClick={() => handleSlotClick(i)}
                                className={`aspect-square rounded-lg border-2 flex flex-col items-center justify-center relative transition-all
                                    ${!isValid ? 'bg-[#1c1917] border-transparent opacity-50' : 
                                      isSelected ? 'bg-zinc-800 border-orange-500 z-10' :
                                      'bg-[#292524] border-[#44403c] hover:border-zinc-500'}
                                `}
                             >
                                 {isValid && (
                                     <span className="absolute top-1 left-1 text-[8px] font-bold text-[#78716c]">
                                         {i === 1 ? 'N' : i === 7 ? 'S' : i === 3 ? 'W' : i === 5 ? 'E' : 'CTR'}
                                     </span>
                                 )}
                                 
                                 {cell ? (
                                     <div className="scale-75">
                                         <GeneDisplay genes={cell.genes} size="sm" />
                                     </div>
                                 ) : isValid && (
                                     <div className="w-2 h-2 rounded-full bg-[#44403c]" />
                                 )}
                             </button>
                         );
                     })}
                 </div>
                 <div className="text-center mt-3 text-[10px] text-zinc-500">
                     Tap N/S/E/W to place clones manually. Center auto-calculates.
                 </div>
             </div>
         </div>

      </div>

      {/* Info Modal */}
      {showInfo && (
          <div className="absolute inset-0 z-50 bg-black/90 backdrop-blur-sm flex items-center justify-center p-6 animate-in fade-in">
              <div className="bg-[#18181b] border border-zinc-700 rounded-2xl p-6 w-full max-w-xs relative">
                  <button onClick={() => setShowInfo(false)} className="absolute top-4 right-4 text-zinc-500 hover:text-white"><X className="w-5 h-5"/></button>
                  <h3 className="text-lg font-black text-white uppercase mb-4 flex items-center gap-2">
                      <BookOpen className="w-5 h-5 text-orange-500" /> Guide
                  </h3>
                  
                  <div className="space-y-4 text-xs text-zinc-300">
                      <div>
                          <strong className="text-white block mb-1">Gene Weights</strong>
                          <div className="flex justify-between bg-zinc-900 p-2 rounded">
                              <span>Green (G,Y,H)</span>
                              <span className="font-mono text-green-500">0.60</span>
                          </div>
                          <div className="flex justify-between bg-zinc-900 p-2 rounded mt-1">
                              <span>Red (W,X)</span>
                              <span className="font-mono text-red-500">1.00</span>
                          </div>
                      </div>
                      
                      <p>
                          To overwrite a Red gene in the center, you need at least <strong className="text-white">two Green genes</strong> in the same slot from neighbors (0.6 + 0.6 = 1.2 > 1.0).
                      </p>
                      
                      <p>
                          This calculator assumes you can <strong className="text-white">clone</strong> your inventory items. If you have 1 good clone, the solver will try using it in multiple slots.
                      </p>
                  </div>
              </div>
          </div>
      )}

    </div>
  );
};
