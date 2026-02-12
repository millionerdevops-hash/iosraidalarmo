
import React, { useState, useEffect, useRef } from 'react';
import { ArrowLeft, Crosshair, Target, RotateCcw, MousePointer2, AlertCircle } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface AimTrainerScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

interface TargetEntity {
    id: number;
    x: number; // percentage
    y: number; // percentage
    createdAt: number;
}

const GAME_DURATION = 30; // Seconds

export const AimTrainerScreen: React.FC<AimTrainerScreenProps> = ({ onNavigate }) => {
  const [gameState, setGameState] = useState<'IDLE' | 'PLAYING' | 'FINISHED'>('IDLE');
  const [score, setScore] = useState(0);
  const [misses, setMisses] = useState(0);
  const [timeLeft, setTimeLeft] = useState(GAME_DURATION);
  const [targets, setTargets] = useState<TargetEntity[]>([]);
  const [avgReaction, setAvgReaction] = useState(0);
  
  const reactionTimesRef = useRef<number[]>([]);
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
      let timer: number;
      if (gameState === 'PLAYING') {
          timer = window.setInterval(() => {
              setTimeLeft(prev => {
                  if (prev <= 1) {
                      finishGame();
                      return 0;
                  }
                  return prev - 1;
              });
          }, 1000);
      }
      return () => clearInterval(timer);
  }, [gameState]);

  const startGame = () => {
      setScore(0);
      setMisses(0);
      setTimeLeft(GAME_DURATION);
      reactionTimesRef.current = [];
      setAvgReaction(0);
      setGameState('PLAYING');
      spawnTarget();
  };

  const spawnTarget = () => {
      // Keep only 1 target at a time for "Reflex" mode
      const newTarget: TargetEntity = {
          id: Date.now(),
          x: 10 + Math.random() * 80, // 10% to 90% padding
          y: 10 + Math.random() * 80,
          createdAt: Date.now()
      };
      setTargets([newTarget]);
  };

  const hitTarget = (e: React.MouseEvent | React.TouchEvent, id: number, createdAt: number) => {
      e.stopPropagation();
      e.preventDefault(); // Prevent touch ghost clicks
      
      const reaction = Date.now() - createdAt;
      reactionTimesRef.current.push(reaction);
      
      setScore(prev => prev + 1);
      spawnTarget();
  };

  const handleMiss = (e: React.MouseEvent | React.TouchEvent) => {
      // If clicking background while playing, count as miss
      if (gameState === 'PLAYING') {
          setMisses(prev => prev + 1);
      }
  };

  const finishGame = () => {
      setGameState('FINISHED');
      setTargets([]);
      const total = reactionTimesRef.current.reduce((a, b) => a + b, 0);
      setAvgReaction(total > 0 ? Math.round(total / reactionTimesRef.current.length) : 0);
  };

  // Calculate Accuracy
  const totalClicks = score + misses;
  const accuracy = totalClicks > 0 ? Math.round((score / totalClicks) * 100) : 0;

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative select-none">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Reflex Trainer</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Reaction Test</p>
            </div>
        </div>
      </div>

      <div className="flex-1 flex flex-col p-4">
          
          {/* Game Area */}
          <div 
            ref={containerRef}
            onMouseDown={handleMiss}
            className="flex-1 bg-black border-4 border-zinc-800 rounded-3xl relative overflow-hidden shadow-2xl mb-4 cursor-crosshair active:border-zinc-700 transition-colors"
          >
              {/* Grid Background */}
              <div className="absolute inset-0 opacity-20 pointer-events-none" 
                   style={{ backgroundImage: 'linear-gradient(#333 1px, transparent 1px), linear-gradient(90deg, #333 1px, transparent 1px)', backgroundSize: '40px 40px' }} 
              />

              {gameState === 'IDLE' && (
                  <div className="absolute inset-0 flex flex-col items-center justify-center bg-black/60 backdrop-blur-sm z-20">
                      <Target className="w-16 h-16 text-green-500 mb-4" />
                      <h3 className="text-2xl font-black text-white uppercase mb-2">Warmup</h3>
                      <p className="text-zinc-400 text-sm mb-6 max-w-[200px] text-center">
                          Tap targets as fast as possible. 
                      </p>
                      <button 
                        onClick={(e) => { e.stopPropagation(); startGame(); }}
                        className="px-8 py-4 bg-green-600 hover:bg-green-500 text-white font-black uppercase rounded-xl shadow-lg active:scale-95 transition-all"
                      >
                          Start Test
                      </button>
                  </div>
              )}

              {gameState === 'FINISHED' && (
                  <div className="absolute inset-0 flex flex-col items-center justify-center bg-black/80 backdrop-blur-sm z-20 animate-in zoom-in">
                      <div className="text-center mb-6">
                          <span className="text-zinc-500 text-xs font-bold uppercase tracking-widest">Average Reaction</span>
                          <div className="text-6xl font-black text-white font-mono tracking-tight text-shadow-glow">
                              {avgReaction}<span className="text-2xl text-zinc-500 ml-1">ms</span>
                          </div>
                      </div>
                      
                      <div className="grid grid-cols-2 gap-3 w-full max-w-[260px] mb-8">
                          <div className="bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-center">
                              <div className="text-[9px] text-zinc-500 uppercase font-bold">Accuracy</div>
                              <div className={`text-xl font-bold ${accuracy >= 90 ? 'text-green-500' : 'text-yellow-500'}`}>{accuracy}%</div>
                          </div>
                          <div className="bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-center">
                              <div className="text-[9px] text-zinc-500 uppercase font-bold">Misses</div>
                              <div className="text-xl font-bold text-red-500">{misses}</div>
                          </div>
                          <div className="bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-center col-span-2">
                              <div className="text-[9px] text-zinc-500 uppercase font-bold">Rating</div>
                              <div className={`text-xl font-black ${avgReaction < 200 ? 'text-green-500' : avgReaction < 300 ? 'text-yellow-500' : 'text-red-500'}`}>
                                  {avgReaction < 200 ? 'CHAD' : avgReaction < 300 ? 'DECENT' : 'NOOB'}
                              </div>
                          </div>
                      </div>

                      <button 
                        onClick={(e) => { e.stopPropagation(); startGame(); }}
                        className="flex items-center gap-2 px-6 py-3 bg-white text-black font-black uppercase rounded-xl shadow-lg active:scale-95 transition-all hover:bg-zinc-200"
                      >
                          <RotateCcw className="w-4 h-4" /> Retry
                      </button>
                  </div>
              )}

              {/* Targets */}
              {targets.map(t => (
                  <button
                    key={t.id}
                    onMouseDown={(e) => hitTarget(e, t.id, t.createdAt)}
                    onTouchStart={(e) => hitTarget(e, t.id, t.createdAt)}
                    className="absolute w-12 h-12 -ml-6 -mt-6 rounded-full bg-red-500 border-4 border-white shadow-[0_0_20px_rgba(239,68,68,0.6)] active:scale-90 transition-transform z-10 flex items-center justify-center group"
                    style={{ left: `${t.x}%`, top: `${t.y}%` }}
                  >
                      <div className="w-2 h-2 bg-white rounded-full group-hover:bg-zinc-200" />
                  </button>
              ))}

          </div>

          {/* Stats Bar */}
          <div className="flex items-center justify-between bg-[#121214] border border-zinc-800 rounded-2xl p-4">
              <div className="flex flex-col">
                  <span className="text-[9px] font-bold text-zinc-500 uppercase tracking-widest">Time Left</span>
                  <span className={`text-2xl font-mono font-black ${timeLeft < 5 ? 'text-red-500 animate-pulse' : 'text-white'}`}>
                      {timeLeft}s
                  </span>
              </div>
              
              <div className="h-8 w-px bg-zinc-800" />

              <div className="flex flex-col items-center">
                  <span className="text-[9px] font-bold text-zinc-500 uppercase tracking-widest">Misses</span>
                  <span className={`text-2xl font-mono font-black ${misses > 0 ? 'text-red-500' : 'text-zinc-600'}`}>
                      {misses}
                  </span>
              </div>

              <div className="h-8 w-px bg-zinc-800" />

              <div className="flex flex-col items-end">
                  <span className="text-[9px] font-bold text-zinc-500 uppercase tracking-widest">Hits</span>
                  <span className="text-2xl font-mono font-black text-green-400">
                      {score}
                  </span>
              </div>
          </div>

      </div>
    </div>
  );
};
