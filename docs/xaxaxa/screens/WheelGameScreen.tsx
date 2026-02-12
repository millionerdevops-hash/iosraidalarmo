
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  RotateCcw, 
  Play, 
  XCircle, 
  Triangle,
  History,
  Info,
  Trophy,
  Skull
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface WheelGameScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// HQM Image for currency
const HQM_IMAGE_URL = "https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fmetal-refined.webp&w=414&q=90";

// --- WHEEL CONFIG ---
// Actual Bandit Camp Wheel Layout (Clockwise)
// 20 Segments. 18 degrees each.
// 1, 3, 1, 5, 1, 3, 1, 10, 1, 3, 1, 5, 1, 20, 1, 3, 1, 5, 1, 10
const SEGMENTS = [1, 3, 1, 5, 1, 3, 1, 10, 1, 3, 1, 5, 1, 20, 1, 3, 1, 5, 1, 10];
const SEGMENT_ANGLE = 360 / SEGMENTS.length; // 18 degrees

const COLORS: Record<number, string> = {
    1: '#a1a1aa', // Zinc (Gray)
    3: '#86efac', // Green
    5: '#60a5fa', // Blue
    10: '#c084fc', // Purple
    20: '#f87171' // Red
};

const TEXT_COLORS: Record<number, string> = {
    1: '#71717a', 
    3: '#14532d', 
    5: '#1e3a8a', 
    10: '#581c87', 
    20: '#7f1d1d' 
};

export const WheelGameScreen: React.FC<WheelGameScreenProps> = ({ onNavigate }) => {
  // State
  const [scrap, setScrap] = useState(() => parseInt(localStorage.getItem('raid_alarm_scrap') || '1000'));
  const [bet, setBet] = useState(0);
  const [selectedNumber, setSelectedNumber] = useState<number | null>(null);
  
  // Rotation State
  const [rotation, setRotation] = useState(0);
  const [isSpinning, setIsSpinning] = useState(false);
  
  // Result States
  const [lastWinAmount, setLastWinAmount] = useState<number | null>(null);
  const [showResultOverlay, setShowResultOverlay] = useState<'WIN' | 'LOSS' | null>(null);
  const [history, setHistory] = useState<number[]>([]);

  // Sync Scrap
  useEffect(() => {
      localStorage.setItem('raid_alarm_scrap', scrap.toString());
  }, [scrap]);

  const placeBetAmount = (amount: number) => {
      if (bet + amount <= scrap) {
          setBet(prev => prev + amount);
          // Hide result if they start betting again
          if (!isSpinning) setShowResultOverlay(null);
      }
  };

  const clearBet = () => setBet(0);

  const spinWheel = () => {
      if (bet <= 0 || !selectedNumber) return;
      if (bet > scrap) return;

      // 1. Deduct Bet & Reset UI
      setScrap(prev => prev - bet);
      setIsSpinning(true);
      setShowResultOverlay(null);
      setLastWinAmount(null);

      // 2. Determine Outcome
      const winningIndex = Math.floor(Math.random() * SEGMENTS.length);
      const winningNumber = SEGMENTS[winningIndex];

      // 3. Calculate Rotation (Visuals)
      // To land on 'winningIndex' at TOP (0deg marker):
      // The segment at index `i` is located at `i * 18deg` relative to start.
      // To bring it to 0, we must rotate the wheel `- (i * 18deg)`.
      // We also add full spins (360 * 5) for effect.
      // We SUBTRACT from current rotation to ensure it always spins one direction (Clockwise visual = Negative CSS deg? No wait)
      // CSS Rotate(positive) = Clockwise.
      // If we want the wheel to spin Clockwise, we ADD degrees.
      // If wheel rotates +X degrees, the item at Top (0) moves Right. The item at Left (-X) moves to Top.
      // So to bring Index `i` to Top, we need `360 - (i * 18)`.
      
      const segmentTargetAngle = 360 - (winningIndex * SEGMENT_ANGLE);
      const spins = 360 * 5; // 5 Full spins
      const fuzz = (Math.random() * 10) - 5; // Randomness inside the slice
      
      // Calculate delta needed from current position
      // Current logical rotation = rotation % 360.
      // We want `rotation % 360` to end up at `segmentTargetAngle`.
      const currentMod = rotation % 360;
      const dist = (segmentTargetAngle - currentMod + 360) % 360; // Distance to target moving forward
      const newRotation = rotation + spins + dist + fuzz;

      setRotation(newRotation);

      // 4. End Game Logic (After 4s animation)
      setTimeout(() => {
          setIsSpinning(false);
          setHistory(prev => [winningNumber, ...prev].slice(0, 5));

          if (winningNumber === selectedNumber) {
              // WINNER
              // Formula: Original Bet + (Bet * Multiplier)
              const winVal = bet + (bet * winningNumber);
              setScrap(prev => prev + winVal);
              setLastWinAmount(winVal);
              setShowResultOverlay('WIN');
          } else {
              // LOSER
              setLastWinAmount(0);
              setShowResultOverlay('LOSS');
          }
          
          setBet(0);
          setSelectedNumber(null);
      }, 4000);
  };

  return (
    <div className="flex flex-col h-full bg-[#1c1917] animate-in slide-in-from-right duration-300 relative select-none overflow-hidden font-sans">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#1f1d18] z-20 shrink-0 shadow-lg relative">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-black/20 border border-white/10 flex items-center justify-center text-white/70 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Bandit Wheel</h2>
                <div className="flex items-center gap-1">
                    <span className="text-[9px] text-zinc-500 font-bold uppercase mr-1">History:</span>
                    {history.length > 0 ? (
                        history.map((h, i) => (
                            <span key={i} className={`text-[10px] font-black ${COLORS[h].split(' ')[0]} opacity-${100 - (i*20)}`}>
                                {h}
                            </span>
                        ))
                    ) : <span className="text-[9px] text-zinc-600">-</span>}
                </div>
            </div>
        </div>

        <div className="bg-black/40 px-3 py-1.5 rounded-full border border-white/10 flex items-center gap-2 shadow-inner">
            <span className="text-zinc-300 font-black font-mono text-sm">{scrap}</span>
            <img src={HQM_IMAGE_URL} className="w-4 h-4 object-contain" alt="HQM" />
        </div>
      </div>

      {/* GAME AREA */}
      <div className="flex-1 relative flex flex-col items-center justify-center bg-[#1c1917] overflow-hidden">
          
          {/* Decorative Background */}
          <div className="absolute inset-0 opacity-5 pointer-events-none bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')]" />
          
          {/* POINTER (Fixed at Top Center) */}
          <div className="absolute top-[8%] z-30 drop-shadow-xl filter">
              {/* The triangular pointer */}
              <div className="w-0 h-0 border-l-[12px] border-l-transparent border-r-[12px] border-r-transparent border-t-[24px] border-t-yellow-500 translate-y-1" />
          </div>

          {/* THE WHEEL CONTAINER */}
          <div className="relative w-[320px] h-[320px] md:w-[380px] md:h-[380px] rounded-full shadow-[0_0_50px_rgba(0,0,0,0.8)] border-8 border-[#292524] bg-[#292524]">
              
              {/* ROTATING PART */}
              <div 
                className="w-full h-full rounded-full overflow-hidden relative transition-transform cubic-bezier(0.15, 0.80, 0.30, 1.00)" // Ease-out effect
                style={{ 
                    transform: `rotate(${rotation}deg)`,
                    transitionDuration: isSpinning ? '4000ms' : '0ms'
                }}
              >
                  {SEGMENTS.map((num, i) => {
                      const rotate = i * SEGMENT_ANGLE;
                      
                      return (
                          <div 
                            key={i}
                            className="absolute top-0 left-0 w-full h-full pointer-events-none"
                            style={{ transform: `rotate(${rotate}deg)` }}
                          >
                              {/* The Segment Line */}
                              <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[1px] h-[50%] bg-[#44403c] origin-bottom z-10" />

                              {/* The Number Content - Positioned at top center of the slice */}
                              <div 
                                className="absolute top-0 left-1/2 -translate-x-1/2 w-[40px] h-[50%] origin-bottom pt-3 flex justify-center z-20"
                              >
                                  <div className="flex flex-col items-center">
                                      <span 
                                        className="font-black text-xl drop-shadow-md"
                                        style={{ 
                                            color: COLORS[num],
                                            textShadow: `0 2px 0 ${TEXT_COLORS[num]}`
                                        }}
                                      >
                                          {num}
                                      </span>
                                      {/* Dots/Pegs */}
                                      <div className={`w-1.5 h-1.5 rounded-full mt-1 ${num === 20 ? 'bg-red-500' : 'bg-[#57534e]'}`} />
                                  </div>
                              </div>
                          </div>
                      );
                  })}
                  
                  {/* Inner Ring for structure */}
                  <div className="absolute inset-[25%] rounded-full border-2 border-[#44403c] opacity-30 pointer-events-none" />
              </div>

              {/* CENTER CAP (Static) */}
              <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-24 h-24 bg-[#1c1917] rounded-full border-[6px] border-[#292524] flex items-center justify-center shadow-[inset_0_0_20px_rgba(0,0,0,0.8)] z-30">
                  <div className="text-[#57534e] font-black text-[10px] uppercase text-center leading-tight">
                      Bandit<br/>Camp
                  </div>
              </div>
              
              {/* Outer Rim Shine */}
              <div className="absolute inset-0 rounded-full border-[2px] border-[#44403c] pointer-events-none z-40" />
          </div>

          {/* RESULT OVERLAY (Popup) */}
          {showResultOverlay && (
              <div className="absolute inset-0 z-50 flex flex-col items-center justify-center bg-black/80 backdrop-blur-sm animate-in fade-in zoom-in duration-300">
                  
                  {showResultOverlay === 'WIN' ? (
                      <div className="flex flex-col items-center gap-4">
                          <div className="w-24 h-24 rounded-full bg-green-500/20 border-4 border-green-500 flex items-center justify-center shadow-[0_0_50px_rgba(34,197,94,0.5)] animate-bounce">
                              <Trophy className="w-12 h-12 text-green-500 fill-current" />
                          </div>
                          <div className="text-center">
                              <h3 className="text-4xl font-black text-white uppercase italic tracking-tighter drop-shadow-xl">WINNER!</h3>
                              <div className="flex items-center justify-center gap-2 mt-2 bg-zinc-900/80 px-4 py-2 rounded-xl border border-zinc-700">
                                  <span className="text-green-400 font-mono text-3xl font-black">+{lastWinAmount}</span>
                                  <img src={HQM_IMAGE_URL} className="w-8 h-8 object-contain" alt="HQM" />
                              </div>
                          </div>
                      </div>
                  ) : (
                      <div className="flex flex-col items-center gap-4">
                          <div className="w-20 h-20 rounded-full bg-red-900/20 border-4 border-red-500/50 flex items-center justify-center shadow-[0_0_30px_rgba(220,38,38,0.3)]">
                              <Skull className="w-10 h-10 text-red-500 fill-current" />
                          </div>
                          <div className="text-center">
                              <h3 className="text-3xl font-black text-red-500 uppercase italic tracking-tighter">SCRAP LOST</h3>
                              <p className="text-zinc-500 text-sm font-bold uppercase mt-1">Better luck next spin</p>
                          </div>
                      </div>
                  )}

                  <button 
                    onClick={() => setShowResultOverlay(null)}
                    className="mt-12 px-8 py-3 bg-white text-black font-black uppercase rounded-xl hover:bg-zinc-200 active:scale-95 transition-all shadow-xl"
                  >
                      Continue
                  </button>
              </div>
          )}

      </div>

      {/* CONTROLS */}
      <div className="bg-[#1c1917] border-t border-zinc-800 p-4 pb-8 z-30 relative shadow-2xl">
          
          {/* Number Selector */}
          <div className="flex justify-between gap-2 mb-6">
              {[1, 3, 5, 10, 20].map(num => (
                  <button
                    key={num}
                    onClick={() => !isSpinning && setSelectedNumber(num)}
                    disabled={isSpinning}
                    className={`flex-1 h-16 rounded-xl flex flex-col items-center justify-center border-b-4 transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed relative overflow-hidden
                        ${selectedNumber === num 
                            ? 'bg-zinc-700 border-white text-white -translate-y-1 shadow-lg' 
                            : 'bg-[#292524] border-[#44403c] text-zinc-500 hover:bg-zinc-800'}
                    `}
                    style={{ borderColor: selectedNumber === num ? COLORS[num] : undefined }}
                  >
                      {/* Color Strip */}
                      <div className="absolute top-0 left-0 right-0 h-1" style={{ backgroundColor: COLORS[num] }} />
                      
                      <span className="text-2xl font-black mt-1" style={{ color: selectedNumber === num ? COLORS[num] : undefined }}>{num}</span>
                      <span className="text-[9px] font-bold uppercase opacity-60">x{num}</span>
                  </button>
              ))}
          </div>

          {/* Betting Controls */}
          <div className="flex flex-col gap-3">
              <div className="flex justify-between items-center px-1">
                  <span className="text-zinc-500 text-xs font-bold uppercase tracking-wider">Bet Amount</span>
                  <div className="flex items-center gap-2 text-white font-mono font-bold text-lg">
                      {bet} <img src={HQM_IMAGE_URL} className="w-4 h-4 object-contain" alt="HQM" />
                  </div>
              </div>
              
              <div className="flex gap-2">
                  {[10, 50, 100, 500].map(amt => (
                      <button
                        key={amt}
                        onClick={() => !isSpinning && placeBetAmount(amt)}
                        disabled={isSpinning || scrap < amt}
                        className="flex-1 py-3 bg-zinc-800 rounded-lg text-xs font-bold text-zinc-300 hover:bg-zinc-700 border border-zinc-700 disabled:opacity-50 active:scale-95 transition-transform"
                      >
                          +{amt}
                      </button>
                  ))}
                  <button 
                    onClick={clearBet}
                    disabled={isSpinning}
                    className="w-14 flex items-center justify-center bg-red-900/20 border border-red-900/50 rounded-lg text-red-500 hover:text-red-400 disabled:opacity-50 active:scale-95 transition-transform"
                  >
                      <XCircle className="w-5 h-5" />
                  </button>
              </div>

              <button 
                onClick={spinWheel}
                disabled={isSpinning || bet <= 0 || !selectedNumber}
                className="w-full py-4 mt-2 bg-green-600 hover:bg-green-500 text-white font-black uppercase text-lg rounded-xl shadow-lg border-b-4 border-green-800 active:border-b-0 active:translate-y-1 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
              >
                  {isSpinning ? 'SPINNING...' : <><Play className="w-6 h-6 fill-current" /> SPIN</>}
              </button>
          </div>

      </div>
    </div>
  );
};
