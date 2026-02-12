
import React, { useState, useEffect, useRef } from 'react';
import { ArrowLeft, Fish, Anchor, Coins } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface FishingScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

const FISH_TYPES = [
    { name: 'Trout', value: 10, difficulty: 1, image: 'https://rustlabs.com/img/items180/trout.raw.png' },
    { name: 'Salmon', value: 20, difficulty: 1.5, image: 'https://rustlabs.com/img/items180/salmon.raw.png' },
    { name: 'Small Shark', value: 50, difficulty: 2.5, image: 'https://rustlabs.com/img/items180/shark.raw.png' },
    { name: 'Yellow Perch', value: 15, difficulty: 1.2, image: 'https://rustlabs.com/img/items180/yellowperch.raw.png' },
    { name: 'Catfish', value: 25, difficulty: 1.8, image: 'https://rustlabs.com/img/items180/catfish.raw.png' },
];

export const FishingScreen: React.FC<FishingScreenProps> = ({ onNavigate }) => {
  const [scrapBalance, setScrapBalance] = useState(() => parseInt(localStorage.getItem('raid_alarm_scrap') || '1000'));
  
  const [gameState, setGameState] = useState<'IDLE' | 'CASTING' | 'REELING' | 'CAUGHT' | 'SNAPPED'>('IDLE');
  const [tension, setTension] = useState(0); // 0 to 100
  const [distance, setDistance] = useState(100); // 100m start
  const [caughtFish, setCaughtFish] = useState(FISH_TYPES[0]);
  
  // Refs for loop
  const isHoldingRef = useRef(false);
  const animationRef = useRef<number | null>(null);

  useEffect(() => {
      localStorage.setItem('raid_alarm_scrap', scrapBalance.toString());
  }, [scrapBalance]);

  const startFishing = () => {
      setGameState('CASTING');
      setTension(0);
      setDistance(100);
      
      // Select random fish
      const randomFish = FISH_TYPES[Math.floor(Math.random() * FISH_TYPES.length)];
      setCaughtFish(randomFish);

      setTimeout(() => {
          setGameState('REELING');
          gameLoop();
      }, 1500);
  };

  const gameLoop = () => {
      if (animationRef.current) cancelAnimationFrame(animationRef.current);

      const loop = () => {
          setGameState(current => {
              if (current !== 'REELING') return current;

              // Logic inside state setter to access fresh refs/state if needed
              // But here we rely on refs for input, state for logic
              return 'REELING'; 
          });

          // We need access to current tension/distance which is hard in RAF.
          // Let's use a functional update for state to drive the logic next frame
          setTension(prevTension => {
              let newTension = prevTension;
              
              if (isHoldingRef.current) {
                  // Reeling in: Increases tension, decreases distance
                  newTension += 1.5; 
                  setDistance(prevDist => Math.max(0, prevDist - 0.8));
              } else {
                  // Letting go: Decreases tension, distance slowly increases (fish swims away)
                  newTension -= 2.0;
                  setDistance(prevDist => Math.min(120, prevDist + 0.3));
              }
              
              // Fish fighting mechanic (random tension spikes)
              if (Math.random() < 0.05) newTension += 5;

              // Bounds
              newTension = Math.max(0, newTension);

              // Check Fail
              if (newTension >= 100) {
                  setGameState('SNAPPED');
                  return 100;
              }
              
              return newTension;
          });

          // Check Win (Distance check needs to be separate or synced)
          // We can check distance in a separate effect or here via ref? 
          // React state updates are batched. Let's use a ref for distance to check immediately.
          // Ideally, we'd rewrite to use Refs for all game logic variables, then sync to State for render.
          
          animationRef.current = requestAnimationFrame(loop);
      };
      
      animationRef.current = requestAnimationFrame(loop);
  };

  // Monitor Win Condition in Effect
  useEffect(() => {
      if (gameState === 'REELING') {
          if (distance <= 0) {
              setGameState('CAUGHT');
              setScrapBalance(prev => prev + caughtFish.value);
              if (animationRef.current) cancelAnimationFrame(animationRef.current);
          }
      }
  }, [distance, gameState]);

  // Clean up
  useEffect(() => {
      return () => {
          if (animationRef.current) cancelAnimationFrame(animationRef.current);
      };
  }, []);

  const handlePointerDown = () => {
      if (gameState === 'REELING') isHoldingRef.current = true;
  };

  const handlePointerUp = () => {
      if (gameState === 'REELING') isHoldingRef.current = false;
  };

  // Color for tension bar
  const getTensionColor = () => {
      if (tension < 50) return 'bg-green-500';
      if (tension < 80) return 'bg-yellow-500';
      return 'bg-red-500';
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative select-none">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Fishing Sim</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Catch & Sell</p>
            </div>
        </div>
        <div className="bg-zinc-900 px-3 py-1.5 rounded-full border border-zinc-800 flex items-center gap-2 shadow-inner">
            <span className="text-yellow-500 font-black font-mono text-sm">{scrapBalance}</span>
            <Coins className="w-3.5 h-3.5 text-yellow-600 fill-yellow-600" />
        </div>
      </div>

      <div className="flex-1 p-6 flex flex-col items-center justify-center relative overflow-hidden">
          
          {/* Water Background */}
          <div className="absolute inset-0 z-0 bg-gradient-to-b from-[#0f172a] to-[#082f49] opacity-50" />
          
          {gameState === 'IDLE' && (
              <div className="relative z-10 text-center animate-in zoom-in">
                  <div className="w-32 h-32 bg-blue-900/20 rounded-full flex items-center justify-center border-4 border-blue-500/30 mb-6 mx-auto shadow-[0_0_50px_rgba(59,130,246,0.3)]">
                      <Fish className="w-16 h-16 text-blue-400" />
                  </div>
                  <h3 className="text-2xl font-black text-white uppercase mb-2">Ready to Fish?</h3>
                  <p className="text-zinc-400 text-sm mb-8">Hold to reel in. Release to reduce tension.</p>
                  <button 
                    onClick={startFishing}
                    className="px-8 py-4 bg-blue-600 hover:bg-blue-500 text-white font-black uppercase rounded-2xl shadow-lg shadow-blue-900/40 active:scale-95 transition-all"
                  >
                      Cast Line
                  </button>
              </div>
          )}

          {gameState === 'CASTING' && (
              <div className="relative z-10 text-center animate-pulse">
                  <Anchor className="w-12 h-12 text-zinc-500 mx-auto mb-4" />
                  <span className="text-white font-bold uppercase tracking-widest">Casting...</span>
              </div>
          )}

          {gameState === 'REELING' && (
              <div className="relative z-10 w-full max-w-xs flex flex-col items-center gap-8">
                  {/* Distance Indicator */}
                  <div className="text-center">
                      <div className="text-4xl font-black text-white font-mono">{Math.round(distance)}m</div>
                      <span className="text-zinc-400 text-xs uppercase font-bold tracking-wider">Distance</span>
                  </div>

                  {/* Tension Bar */}
                  <div className="w-full">
                      <div className="flex justify-between items-end mb-2">
                          <span className="text-xs font-bold text-white uppercase">Line Tension</span>
                          <span className={`text-xs font-mono font-bold ${tension > 80 ? 'text-red-500' : 'text-zinc-400'}`}>
                              {Math.round(tension)}%
                          </span>
                      </div>
                      <div className="h-6 w-full bg-zinc-900 rounded-full border border-zinc-700 overflow-hidden relative">
                          <div 
                              className={`h-full transition-all duration-100 ease-linear ${getTensionColor()}`} 
                              style={{ width: `${tension}%` }}
                          />
                          {/* Danger Zone Marker */}
                          <div className="absolute top-0 bottom-0 right-[20%] w-0.5 bg-red-500/50 dashed" />
                      </div>
                      <p className="text-center text-[10px] text-zinc-500 mt-2 uppercase">Hold to Reel • Release to Relax</p>
                  </div>

                  {/* Visual Reel Button (Interaction Area) */}
                  <button
                      onMouseDown={handlePointerDown}
                      onMouseUp={handlePointerUp}
                      onMouseLeave={handlePointerUp}
                      onTouchStart={handlePointerDown}
                      onTouchEnd={handlePointerUp}
                      className="w-24 h-24 rounded-full bg-zinc-800 border-4 border-zinc-600 flex items-center justify-center shadow-2xl active:scale-95 transition-transform active:bg-zinc-700 touch-none"
                  >
                      <div className="w-3 h-3 bg-zinc-500 rounded-full" />
                  </button>
              </div>
          )}

          {gameState === 'CAUGHT' && (
              <div className="relative z-10 text-center animate-in zoom-in">
                  <div className="w-40 h-40 bg-green-900/20 rounded-full flex items-center justify-center border-4 border-green-500/30 mb-6 mx-auto shadow-[0_0_50px_rgba(34,197,94,0.3)] bg-black/40">
                      <img src={caughtFish.image} alt={caughtFish.name} className="w-24 h-24 object-contain drop-shadow-xl" />
                  </div>
                  <h3 className="text-3xl font-black text-white uppercase mb-1">Caught!</h3>
                  <p className="text-green-400 font-bold text-lg mb-8">
                      {caughtFish.name} <span className="text-white mx-2">•</span> +{caughtFish.value} Scrap
                  </p>
                  <button 
                    onClick={startFishing}
                    className="px-8 py-4 bg-white text-black font-black uppercase rounded-2xl shadow-lg active:scale-95 transition-all hover:bg-zinc-200"
                  >
                      Fish Again
                  </button>
              </div>
          )}

          {gameState === 'SNAPPED' && (
              <div className="relative z-10 text-center animate-in zoom-in">
                  <div className="w-32 h-32 bg-red-900/20 rounded-full flex items-center justify-center border-4 border-red-500/30 mb-6 mx-auto shadow-[0_0_50px_rgba(220,38,38,0.3)]">
                      <div className="relative">
                          <Anchor className="w-16 h-16 text-red-500 opacity-50" />
                          <div className="absolute top-1/2 left-0 right-0 h-1 bg-red-500 rotate-45" />
                      </div>
                  </div>
                  <h3 className="text-3xl font-black text-white uppercase mb-2">Line Snapped!</h3>
                  <p className="text-zinc-400 text-sm mb-8">Too much tension. The fish escaped.</p>
                  <button 
                    onClick={startFishing}
                    className="px-8 py-4 bg-zinc-800 text-white font-black uppercase rounded-2xl shadow-lg active:scale-95 transition-all hover:bg-zinc-700 border border-zinc-700"
                  >
                      Try Again
                  </button>
              </div>
          )}

      </div>
    </div>
  );
};
