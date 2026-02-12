
import React, { useState, useEffect, useRef } from 'react';
import { ArrowLeft, RotateCcw, Grab, Hand } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface LootSimulatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

interface LootItem {
    id: string; // Unique ID per instance
    defId: string; // Definition ID (e.g. 'ak')
    name: string;
    image: string;
    value: number; // Score
    type: 'HIGH' | 'MID' | 'TRASH';
}

const ITEM_DEFS = [
    // HIGH TIER
    { id: 'ak', name: 'Assault Rifle', value: 500, type: 'HIGH', image: 'https://rustlabs.com/img/items180/rifle.ak.png' },
    { id: 'c4', name: 'C4', value: 500, type: 'HIGH', image: 'https://rustlabs.com/img/items180/explosive.timed.png' },
    { id: 'rocket', name: 'Rocket', value: 300, type: 'HIGH', image: 'https://rustlabs.com/img/items180/ammo.rocket.basic.png' },
    { id: 'hqm', name: 'HQM', value: 200, type: 'HIGH', image: 'https://rustlabs.com/img/items180/metal.refined.png' },
    { id: 'l96', name: 'L96', value: 400, type: 'HIGH', image: 'https://rustlabs.com/img/items180/rifle.l96.png' },
    
    // MID TIER
    { id: 'sar', name: 'SAR', value: 150, type: 'MID', image: 'https://rustlabs.com/img/items180/rifle.semiauto.png' },
    { id: 'meds', name: 'Meds', value: 100, type: 'MID', image: 'https://rustlabs.com/img/items180/syringe.medical.png' },
    { id: 'scrap', name: 'Scrap', value: 100, type: 'MID', image: 'https://rustlabs.com/img/items180/scrap.png' },
    { id: 'roadsign', name: 'Armor', value: 120, type: 'MID', image: 'https://rustlabs.com/img/items180/roadsign.kilt.png' },

    // TRASH (Negative or 0 value)
    { id: 'rock', name: 'Rock', value: -50, type: 'TRASH', image: 'https://rustlabs.com/img/items180/rock.png' },
    { id: 'torch', name: 'Torch', value: -50, type: 'TRASH', image: 'https://rustlabs.com/img/items180/torch.png' },
    { id: 'seed', name: 'Seed', value: -20, type: 'TRASH', image: 'https://rustlabs.com/img/items180/seed.hemp.png' },
    { id: 'bone', name: 'Bone', value: -20, type: 'TRASH', image: 'https://rustlabs.com/img/items180/bone.fragments.png' },
    { id: 'note', name: 'Note', value: -10, type: 'TRASH', image: 'https://rustlabs.com/img/items180/note.png' },
];

interface DragState {
    isDragging: boolean;
    itemIndex: number; // Index in the containerItems array
    startX: number;
    startY: number;
    currentX: number;
    currentY: number;
}

export const LootSimulatorScreen: React.FC<LootSimulatorScreenProps> = ({ onNavigate }) => {
  const [gameState, setGameState] = useState<'MENU' | 'PLAYING' | 'FINISHED'>('MENU');
  
  // Game Data
  const [containerItems, setContainerItems] = useState<LootItem[]>([]);
  const [inventoryItems, setInventoryItems] = useState<LootItem[]>([]); // Items successfully looted
  
  const [score, setScore] = useState(0);
  const [timeLeft, setTimeLeft] = useState(0);
  const [bestScore, setBestScore] = useState(0);
  const [penaltyFlash, setPenaltyFlash] = useState(false);

  // Drag State
  const [drag, setDrag] = useState<DragState | null>(null);
  
  const timerRef = useRef<number | null>(null);
  const inventoryRef = useRef<HTMLDivElement>(null); // To detect drop zone

  // Cleanup timer
  useEffect(() => {
      return () => {
          if (timerRef.current) clearInterval(timerRef.current);
      };
  }, []);

  // Global Pointer Events for Dragging
  useEffect(() => {
      const handleMove = (e: PointerEvent) => {
          if (drag && drag.isDragging) {
              setDrag(prev => prev ? { ...prev, currentX: e.clientX, currentY: e.clientY } : null);
          }
      };

      const handleUp = (e: PointerEvent) => {
          if (drag && drag.isDragging) {
              handleDrop(e.clientX, e.clientY);
          }
      };

      if (drag) {
          window.addEventListener('pointermove', handleMove);
          window.addEventListener('pointerup', handleUp);
          window.addEventListener('pointercancel', handleUp);
      }

      return () => {
          window.removeEventListener('pointermove', handleMove);
          window.removeEventListener('pointerup', handleUp);
          window.removeEventListener('pointercancel', handleUp);
      };
  }, [drag]);

  const startGame = () => {
      setScore(0);
      setInventoryItems([]);
      setTimeLeft(8.00); // 8 seconds to loot
      generateLoot();
      setGameState('PLAYING');
      
      timerRef.current = window.setInterval(() => {
          setTimeLeft(prev => {
              if (prev <= 0.01) {
                  finishGame();
                  return 0;
              }
              return prev - 0.01;
          });
      }, 10);
  };

  const generateLoot = () => {
      // 12 slots (3x4) or 15 (3x5)
      const newItems: LootItem[] = [];
      for (let i = 0; i < 15; i++) {
          const randomDef = ITEM_DEFS[Math.floor(Math.random() * ITEM_DEFS.length)];
          newItems.push({ 
              ...randomDef, 
              id: `${randomDef.id}-${Math.random()}`,
              defId: randomDef.id,
              // Override type string for TS if needed, logic is same
              type: randomDef.type as 'HIGH'|'MID'|'TRASH'
          });
      }
      setContainerItems(newItems);
  };

  // --- DRAG HANDLERS ---

  const startDrag = (index: number, e: React.PointerEvent) => {
      if (gameState !== 'PLAYING') return;
      e.preventDefault(); // Prevent scroll
      
      // Check if slot is empty (null logic handled by rendering, but array is dense here)
      // Actually we remove items from array to simulate empty slots or just mark them?
      // Better to keep array fixed size and use nulls, but simpler to splice for now.
      // Let's use dense array and just remove item when dragged successfully.
      
      setDrag({
          isDragging: true,
          itemIndex: index,
          startX: e.clientX,
          startY: e.clientY,
          currentX: e.clientX,
          currentY: e.clientY
      });
  };

  const handleDrop = (x: number, y: number) => {
      if (!drag || !inventoryRef.current) {
          setDrag(null);
          return;
      }

      // Check if dropped inside inventory bounds
      const invRect = inventoryRef.current.getBoundingClientRect();
      const isOverInventory = 
          x >= invRect.left && 
          x <= invRect.right && 
          y >= invRect.top && 
          y <= invRect.bottom;

      if (isOverInventory) {
          const item = containerItems[drag.itemIndex];
          
          if (item.type === 'TRASH') {
              // PENALTY
              triggerPenalty();
          } else {
              // SUCCESS
              setInventoryItems(prev => [...prev, item]); // Add to bag
              setScore(prev => prev + item.value);
          }

          // Remove from Container regardless (it was moved or destroyed)
          const newContainer = [...containerItems];
          newContainer.splice(drag.itemIndex, 1);
          setContainerItems(newContainer);
      } 
      
      // If not over inventory, it snaps back (do nothing, just clear drag)
      setDrag(null);
  };

  const triggerPenalty = () => {
      setTimeLeft(prev => Math.max(0, prev - 2.0)); // Lose 2 seconds
      setPenaltyFlash(true);
      setTimeout(() => setPenaltyFlash(false), 300);
  };

  const finishGame = () => {
      if (timerRef.current) clearInterval(timerRef.current);
      setGameState('FINISHED');
      if (score > bestScore) setBestScore(score);
      setDrag(null);
  };

  return (
    <div className={`flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative select-none touch-none overflow-hidden ${penaltyFlash ? 'bg-red-900/20' : ''}`}>
      
      {/* DRAG GHOST LAYER (Fixed on top) */}
      {drag && drag.isDragging && (
          <div 
            className="fixed pointer-events-none z-50 w-20 h-20 flex items-center justify-center"
            style={{ 
                left: drag.currentX, 
                top: drag.currentY,
                transform: 'translate(-50%, -50%)' // Center on finger
            }}
          >
              <img 
                src={containerItems[drag.itemIndex].image} 
                className="w-16 h-16 object-contain drop-shadow-2xl scale-110" 
                alt=""
              />
          </div>
      )}

      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Loot Panic</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Drag & Drop Sim</p>
            </div>
        </div>
        <div className="bg-zinc-900 px-3 py-1.5 rounded-full border border-zinc-800 text-yellow-500 font-bold font-mono text-sm">
            High: {bestScore}
        </div>
      </div>

      <div className="flex-1 flex flex-col p-4 overflow-hidden relative">
          
          {gameState === 'MENU' && (
              <div className="absolute inset-0 z-20 bg-black/80 backdrop-blur-sm flex flex-col items-center justify-center p-6 text-center animate-in zoom-in">
                  <div className="w-24 h-24 bg-red-600 rounded-full flex items-center justify-center mb-6 shadow-[0_0_40px_rgba(220,38,38,0.4)] animate-bounce">
                      <Grab className="w-12 h-12 text-white" />
                  </div>
                  <h3 className="text-3xl font-black text-white uppercase mb-2">Drag To Loot!</h3>
                  <p className="text-zinc-400 text-sm mb-8 max-w-[240px]">
                      Drag valuable items from the top crate to your inventory below. Avoid the trash! You have 8 seconds.
                  </p>
                  <button 
                    onClick={startGame}
                    className="w-full py-4 bg-white text-black font-black uppercase rounded-2xl shadow-lg active:scale-95 transition-all text-sm tracking-widest"
                  >
                      Start Looting
                  </button>
              </div>
          )}

          {gameState === 'FINISHED' && (
              <div className="absolute inset-0 z-20 bg-black/90 backdrop-blur-md flex flex-col items-center justify-center p-6 text-center animate-in zoom-in">
                  <div className="text-6xl font-black text-white mb-2 text-shadow-glow">{score}</div>
                  <span className="text-zinc-500 font-bold uppercase tracking-widest text-sm mb-8">Loot Value Secured</span>

                  <div className="grid grid-cols-2 gap-4 w-full">
                      <div className="bg-zinc-900 border border-zinc-800 p-4 rounded-2xl flex flex-col items-center">
                          <span className="text-[10px] text-zinc-500 uppercase font-bold">Items Looted</span>
                          <span className="text-xl font-bold text-white">{inventoryItems.length}</span>
                      </div>
                      <div className="bg-zinc-900 border border-zinc-800 p-4 rounded-2xl flex flex-col items-center">
                          <span className="text-[10px] text-zinc-500 uppercase font-bold">Rating</span>
                          <span className={`text-xl font-black uppercase ${score > 1500 ? 'text-yellow-500' : 'text-zinc-400'}`}>
                              {score > 1500 ? 'CHAD' : 'GRUB'}
                          </span>
                      </div>
                  </div>

                  <div className="flex gap-4 w-full mt-8">
                      <button 
                        onClick={() => setGameState('MENU')}
                        className="flex-1 py-4 bg-zinc-900 border border-zinc-800 rounded-xl text-zinc-400 font-bold uppercase hover:text-white"
                      >
                          Menu
                      </button>
                      <button 
                        onClick={startGame}
                        className="flex-1 py-4 bg-white text-black font-black uppercase rounded-xl flex items-center justify-center gap-2 hover:bg-zinc-200"
                      >
                          <RotateCcw className="w-4 h-4" /> Re-Loot
                      </button>
                  </div>
              </div>
          )}

          {/* --- GAME INTERFACE --- */}

          {/* 1. LOOT CONTAINER (SOURCE) */}
          <div className="flex-1 flex flex-col min-h-0">
              <div className="flex justify-between items-end mb-2 px-1">
                  <div className="bg-zinc-800 text-[10px] text-zinc-400 px-2 py-1 rounded font-bold uppercase tracking-wider">
                      Loot Container
                  </div>
                  {/* Timer */}
                  <div className={`font-mono font-black text-2xl ${timeLeft < 3 ? 'text-red-500 animate-pulse' : 'text-white'}`}>
                      {timeLeft.toFixed(2)}s
                  </div>
              </div>
              
              <div className="bg-[#18181b] border-2 border-zinc-800 rounded-xl p-2 flex-1 overflow-hidden">
                  <div className="grid grid-cols-5 gap-1 h-full content-start">
                      {containerItems.map((item, idx) => (
                          <div 
                            key={item.id}
                            onPointerDown={(e) => startDrag(idx, e)}
                            className={`aspect-square bg-[#27272a] rounded border border-zinc-700/50 flex items-center justify-center relative touch-none
                                ${drag?.itemIndex === idx ? 'opacity-20' : 'opacity-100'}
                            `}
                          >
                              <img src={item.image} alt={item.name} className="w-10 h-10 object-contain pointer-events-none" />
                              {item.type === 'TRASH' && gameState === 'PLAYING' && (
                                  // Optional Hint: Debug mode only? No, keep it hidden for difficulty
                                  null
                              )}
                          </div>
                      ))}
                      {/* Fill empty slots visually if needed, though grid handles it */}
                  </div>
              </div>
          </div>

          {/* MIDDLE SPACER / ARROW */}
          <div className="h-12 flex items-center justify-center shrink-0">
              <div className="animate-bounce mt-2 opacity-50">
                  <Hand className="w-6 h-6 text-zinc-600 rotate-180" />
              </div>
          </div>

          {/* 2. PLAYER INVENTORY (DESTINATION) */}
          <div className="flex-1 flex flex-col min-h-0">
              <div className="flex justify-between items-end mb-2 px-1">
                  <div className="bg-zinc-800 text-[10px] text-zinc-400 px-2 py-1 rounded font-bold uppercase tracking-wider">
                      Inventory
                  </div>
                  <div className="text-green-500 font-black text-lg">
                      {score} <span className="text-xs text-zinc-500">Value</span>
                  </div>
              </div>

              <div 
                ref={inventoryRef}
                className={`bg-[#18181b] border-2 rounded-xl p-2 flex-1 overflow-hidden transition-colors ${drag ? 'border-orange-500/50 bg-orange-900/10' : 'border-zinc-800'}`}
              >
                  <div className="grid grid-cols-5 gap-1 h-full content-start">
                      {/* Render Collected Items */}
                      {inventoryItems.map((item, idx) => (
                          <div key={`${item.id}-inv`} className="aspect-square bg-[#27272a] rounded border border-zinc-700/50 flex items-center justify-center animate-in zoom-in duration-200">
                              <img src={item.image} alt={item.name} className="w-10 h-10 object-contain" />
                          </div>
                      ))}
                      
                      {/* Empty Slots Filler */}
                      {Array.from({ length: Math.max(0, 15 - inventoryItems.length) }).map((_, i) => (
                          <div key={`empty-${i}`} className="aspect-square bg-[#121214] rounded border border-zinc-800/30" />
                      ))}
                  </div>
              </div>
          </div>

      </div>
    </div>
  );
};
