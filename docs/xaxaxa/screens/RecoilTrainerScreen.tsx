
import React, { useState, useEffect, useRef, useMemo } from 'react';
import { 
  ArrowLeft, 
  Crosshair, 
  RotateCcw, 
  Target,
  Zap,
  Info,
  MoveDown,
  MoveLeft,
  MoveRight,
  MousePointer2,
  Cross
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { WEAPONS } from '../data/recoilData';

interface RecoilTrainerScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const RecoilTrainerScreen: React.FC<RecoilTrainerScreenProps> = ({ onNavigate }) => {
  const [selectedWeaponId, setSelectedWeaponId] = useState('ak47');
  const [isPlaying, setIsPlaying] = useState(false);
  const [shotIndex, setShotIndex] = useState(0);
  const [speedMultiplier, setSpeedMultiplier] = useState(1); // 1 = Normal
  const [showControl, setShowControl] = useState(true); // Default to Control Mode (Mouse) for learning
  
  const animationRef = useRef<number | null>(null);
  const canvasRef = useRef<HTMLDivElement>(null);

  const weapon = WEAPONS.find(w => w.id === selectedWeaponId) || WEAPONS[0];

  // Animation Loop
  useEffect(() => {
      if (isPlaying) {
          const msPerShot = (60000 / weapon.rpm) / speedMultiplier;
          
          animationRef.current = window.setInterval(() => {
              setShotIndex(prev => {
                  if (prev >= weapon.pattern.length - 1) {
                      setIsPlaying(false);
                      return prev;
                  }
                  return prev + 1;
              });
          }, msPerShot);
      } else {
          if (animationRef.current) clearInterval(animationRef.current);
      }

      return () => {
          if (animationRef.current) clearInterval(animationRef.current);
      };
  }, [isPlaying, weapon.rpm, speedMultiplier, weapon.pattern.length]);

  const reset = () => {
      setIsPlaying(false);
      setShotIndex(0);
  };

  const togglePlay = () => {
      if (shotIndex >= weapon.pattern.length - 1) {
          setShotIndex(0);
      }
      setIsPlaying(!isPlaying);
  };

  // --- VISUALIZATION HELPERS ---
  const CENTER = 150; // SVG Center (300x300 viewBox)

  // Dynamic Scale Calculation
  const dynamicScale = useMemo(() => {
      let maxDist = 0;
      weapon.pattern.forEach(p => {
          const dist = Math.max(Math.abs(p.x), Math.abs(p.y));
          if (dist > maxDist) maxDist = dist;
      });
      if (maxDist === 0) return 2.0; 
      
      const availableRadius = 120; // 150 center - 30 padding
      const calculatedScale = availableRadius / maxDist;
      
      return Math.min(2.5, Math.max(0.5, calculatedScale));
  }, [weapon]);

  const getCoordinates = (p: {x: number, y: number}) => {
      const impactX = CENTER + (p.x * dynamicScale);
      const impactY = CENTER - (p.y * dynamicScale); // Invert Y for screen coords
      
      const controlX = CENTER - (p.x * dynamicScale); // Reverse X to counter
      const controlY = CENTER + (p.y * dynamicScale); // Reverse Y to counter (Pull Down)
      
      return showControl ? { x: controlX, y: controlY } : { x: impactX, y: impactY };
  };

  // --- DYNAMIC HINTS LOGIC ---
  const getDynamicHint = () => {
      if (!isPlaying && shotIndex === 0) return { text: "Ready", icon: Crosshair, color: "text-zinc-500" };
      if (shotIndex >= weapon.pattern.length - 1) return { text: "Complete", icon: RotateCcw, color: "text-green-500" };

      const current = weapon.pattern[shotIndex];
      const next = weapon.pattern[Math.min(shotIndex + 3, weapon.pattern.length - 1)]; // Look ahead
      
      const dx = next.x - current.x;
      const dy = next.y - current.y;

      if (dy > 2) return { text: "PULL DOWN", icon: MoveDown, color: "text-red-500" };
      if (dx > 2) return { text: "PULL LEFT", icon: MoveLeft, color: "text-orange-500" };
      if (dx < -2) return { text: "PULL RIGHT", icon: MoveRight, color: "text-orange-500" };
      
      return { text: "STABILIZE", icon: Target, color: "text-blue-500" };
  };

  const hint = getDynamicHint();

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 active:bg-zinc-800 active:text-white transition-all"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Recoil Trainer</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Pattern Visualizer</p>
            </div>
        </div>
      </div>

      <div className="flex-1 flex flex-col p-4 overflow-hidden">
          
          {/* WEAPON SELECTOR (Horizontal Scroll with Images) */}
          <div className="flex gap-2 overflow-x-auto no-scrollbar mb-4 shrink-0 pb-2">
              {WEAPONS.map((w) => (
                  <button
                    key={w.id}
                    onClick={() => { setSelectedWeaponId(w.id); reset(); }}
                    className={`px-4 py-3 rounded-2xl text-xs font-black uppercase transition-all whitespace-nowrap border flex flex-col items-center gap-1.5 active:scale-95 min-w-[80px]
                        ${selectedWeaponId === w.id 
                            ? 'bg-zinc-800 border-orange-500 text-white shadow-lg shadow-orange-900/20' 
                            : 'bg-zinc-900 border-zinc-800 text-zinc-500'}
                    `}
                  >
                      <div className="h-12 w-full flex items-center justify-center mb-1">
                          <img 
                            src={w.imageUrl} 
                            alt={w.name} 
                            className={`max-h-full max-w-full object-contain drop-shadow-md ${selectedWeaponId === w.id ? 'brightness-110' : 'opacity-60 grayscale'}`} 
                          />
                      </div>
                      {w.name}
                  </button>
              ))}
          </div>

          {/* VISUALIZER CONTAINER (Monitor Style) */}
          <div className="flex-1 bg-black border-4 border-zinc-800 rounded-3xl relative flex items-center justify-center overflow-hidden mb-4 shadow-2xl" ref={canvasRef}>
              
              {/* CRT Scanline Effect */}
              <div className="absolute inset-0 z-20 pointer-events-none opacity-10 bg-[linear-gradient(rgba(18,16,16,0)_50%,rgba(0,0,0,0.25)_50%),linear-gradient(90deg,rgba(255,0,0,0.06),rgba(0,255,0,0.02),rgba(0,0,255,0.06))] bg-[length:100%_4px,6px_100%]" />
              <div className="absolute inset-0 z-0 bg-[radial-gradient(circle_at_center,_#1a1a1a_0%,_#000000_100%)]" />

              {/* Grid Background */}
              <div className="absolute inset-0 z-0 opacity-20 pointer-events-none" 
                   style={{ 
                       backgroundImage: 'linear-gradient(rgba(50, 205, 50, 0.3) 1px, transparent 1px), linear-gradient(90deg, rgba(50, 205, 50, 0.3) 1px, transparent 1px)', 
                       backgroundSize: '40px 40px' 
                   }} 
              />
              <div className="absolute inset-0 flex items-center justify-center z-0 opacity-30">
                  <div className="w-[1px] h-full bg-green-500/50" />
                  <div className="h-[1px] w-full bg-green-500/50 absolute" />
              </div>

              {/* Mode Toggle (On Screen) */}
              <button 
                onClick={() => setShowControl(!showControl)}
                className="absolute top-4 left-4 z-30 flex items-center gap-2 bg-black/60 backdrop-blur px-3 py-1.5 rounded-lg border border-white/10 active:scale-95 transition-transform"
              >
                  {showControl 
                    ? <MousePointer2 className="w-3 h-3 text-green-400" />
                    : <Crosshair className="w-3 h-3 text-red-400" />
                  }
                  <span className={`text-[9px] font-black uppercase ${showControl ? 'text-green-400' : 'text-red-400'}`}>
                      {showControl ? 'Mouse Move' : 'Impact Point'}
                  </span>
              </button>

              {/* Live Hint Overlay */}
              <div className="absolute top-4 right-4 z-30">
                  <div className={`flex items-center gap-2 bg-black/80 backdrop-blur border border-white/10 px-3 py-1.5 rounded-lg shadow-xl transition-all duration-200 ${isPlaying ? 'scale-110' : 'scale-100'}`}>
                      <hint.icon className={`w-4 h-4 ${hint.color}`} />
                      <span className={`text-xs font-black uppercase tracking-wider ${hint.color}`}>
                          {hint.text}
                      </span>
                  </div>
              </div>

              {/* SVG LAYER */}
              <svg viewBox="0 0 300 300" className="w-full h-full max-w-[320px] max-h-[320px] z-10 overflow-visible">
                  {/* Center Crosshair */}
                  <circle cx={CENTER} cy={CENTER} r="2" fill="#22c55e" className="opacity-80" />
                  <line x1={CENTER-10} y1={CENTER} x2={CENTER+10} y2={CENTER} stroke="#22c55e" strokeWidth="1" opacity="0.3" />
                  <line x1={CENTER} y1={CENTER-10} x2={CENTER} y2={CENTER+10} stroke="#22c55e" strokeWidth="1" opacity="0.3" />
                  
                  {/* The Path Line (Ghost) */}
                  <polyline 
                      points={weapon.pattern.map(p => {
                          const c = getCoordinates(p);
                          return `${c.x},${c.y}`;
                      }).join(' ')}
                      fill="none"
                      stroke={showControl ? "#22c55e" : "#ef4444"}
                      strokeWidth="2"
                      strokeOpacity="0.2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeDasharray="4 4"
                  />

                  {/* Active Dots */}
                  {weapon.pattern.map((p, i) => {
                      if (i > shotIndex) return null;
                      const c = getCoordinates(p);
                      const isCurrent = i === shotIndex;
                      const isRecent = i >= shotIndex - 5; // Trail effect
                      
                      // Only show trail
                      if (!isRecent && !isCurrent) return null; 

                      const opacity = isCurrent ? 1 : (1 - (shotIndex - i) * 0.2);

                      return (
                          <g key={i} opacity={opacity}>
                              {/* Connection Line */}
                              {i > 0 && (
                                  <line 
                                    x1={getCoordinates(weapon.pattern[i-1]).x} 
                                    y1={getCoordinates(weapon.pattern[i-1]).y}
                                    x2={c.x}
                                    y2={c.y}
                                    stroke={showControl ? "#4ade80" : "#f87171"}
                                    strokeWidth={isCurrent ? 3 : 2}
                                  />
                              )}
                              
                              {/* Dot */}
                              <circle 
                                cx={c.x} 
                                cy={c.y} 
                                r={isCurrent ? 5 : 3} 
                                fill={showControl ? "#4ade80" : "#f87171"} 
                                className={isCurrent ? "animate-pulse" : ""}
                                stroke="black"
                                strokeWidth="1"
                              />
                          </g>
                      );
                  })}
              </svg>

          </div>

          {/* CONTROLS */}
          <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-5 shrink-0 shadow-lg">
              
              <div className="flex items-center justify-between mb-5">
                  <div>
                      <h3 className="text-white font-black text-lg uppercase leading-none">{weapon.name}</h3>
                      <div className="flex items-center gap-3 mt-1.5">
                          <span className="text-zinc-500 text-[10px] font-bold bg-zinc-900 px-1.5 py-0.5 rounded">{weapon.rpm} RPM</span>
                          <span className="text-zinc-500 text-[10px] font-bold bg-zinc-900 px-1.5 py-0.5 rounded">{weapon.ammoCapacity} Rounds</span>
                          {/* Difficulty Badge moved here */}
                          <div className={`text-[10px] px-2 py-0.5 rounded bg-zinc-900 border border-zinc-800 font-bold uppercase tracking-wider
                              ${weapon.difficulty === 'Easy' ? 'text-green-500' : weapon.difficulty === 'Medium' ? 'text-yellow-500' : 'text-red-500'}
                          `}>
                              {weapon.difficulty}
                          </div>
                      </div>
                  </div>
                  <div className="text-right">
                      <div className="text-[10px] text-zinc-500 font-mono mb-1 font-bold">SHOT {shotIndex + 1}/{weapon.pattern.length}</div>
                      <div className="w-32 h-2 bg-zinc-800 rounded-full overflow-hidden">
                          <div className="h-full bg-orange-500 transition-all duration-100" style={{ width: `${(shotIndex / weapon.pattern.length) * 100}%` }} />
                      </div>
                  </div>
              </div>

              {/* Control Buttons */}
              <div className="flex gap-3">
                  <button 
                    onClick={() => setSpeedMultiplier(speedMultiplier === 1 ? 0.5 : speedMultiplier === 0.5 ? 0.25 : 1)}
                    className={`w-16 flex flex-col items-center justify-center rounded-xl border transition-all active:scale-95
                        ${speedMultiplier < 1 ? 'bg-blue-900/20 border-blue-500/50 text-blue-400' : 'bg-zinc-900 border-zinc-800 text-zinc-500'}
                    `}
                  >
                      <Zap className="w-4 h-4 mb-0.5" />
                      <span className="text-[10px] font-bold">{speedMultiplier}x</span>
                  </button>

                  <button 
                    onClick={togglePlay}
                    className={`flex-1 py-4 rounded-xl font-black uppercase text-sm flex items-center justify-center gap-2 shadow-lg transition-all active:scale-[0.98]
                        ${isPlaying 
                            ? 'bg-zinc-800 text-white border border-zinc-700' 
                            : 'bg-white text-black border border-white'}
                    `}
                  >
                      {isPlaying ? 'PAUSE' : 'FIRE'}
                  </button>
                  
                  <button 
                    onClick={reset}
                    className="w-16 bg-zinc-800 border border-zinc-700 text-zinc-400 rounded-xl flex items-center justify-center active:text-white active:bg-zinc-700 transition-colors"
                  >
                      <RotateCcw className="w-5 h-5" />
                  </button>
              </div>

          </div>

      </div>
    </div>
  );
};
