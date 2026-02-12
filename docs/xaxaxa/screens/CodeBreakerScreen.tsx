
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  RefreshCw, 
  Zap, 
  Lock, 
  Unlock, 
  Terminal, 
  List, 
  ShieldAlert,
  Coins,
  Cpu,
  Wifi
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface CodeBreakerScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

const MAX_ATTEMPTS = 8;
const BASE_REWARD = 500; // Increased Scrap Reward significantly

// Top common Rust codes (The "Meta")
const COMMON_CODES = [
    '1234', '1111', '0000', '1998', '1999', '2000', '2001', '2002', 
    '2003', '2004', '2005', '2006', '2023', '2024', '2025', '6969', 
    '8008', '1337', '2580', '0852', '5555', '9999', '1212', '1010'
];

export const CodeBreakerScreen: React.FC<CodeBreakerScreenProps> = ({ onNavigate }) => {
  // Global Scrap State
  const [scrapBalance, setScrapBalance] = useState(() => {
      return parseInt(localStorage.getItem('raid_alarm_scrap') || '1000');
  });

  const [targetCode, setTargetCode] = useState('');
  const [currentGuess, setCurrentGuess] = useState('');
  const [attempts, setAttempts] = useState(0);
  const [gameState, setGameState] = useState<'PLAYING' | 'WON' | 'LOST'>('PLAYING');
  const [history, setHistory] = useState<{ guess: string; result: string[] }[]>([]);
  const [shocked, setShocked] = useState(false); // Visual effect for wrong guess
  const [wonAmount, setWonAmount] = useState(0);

  useEffect(() => {
    startNewGame();
  }, []);

  // Update Scrap Storage
  useEffect(() => {
      localStorage.setItem('raid_alarm_scrap', scrapBalance.toString());
  }, [scrapBalance]);

  const generateCode = () => {
      // 30% Chance to be a "Common Code" to make it realistic/guessable via Meta
      if (Math.random() < 0.3) {
          return COMMON_CODES[Math.floor(Math.random() * COMMON_CODES.length)];
      }
      // Otherwise random
      return Math.floor(1000 + Math.random() * 9000).toString();
  };

  const startNewGame = () => {
    setTargetCode(generateCode());
    setCurrentGuess('');
    setAttempts(0);
    setGameState('PLAYING');
    setHistory([]);
    setShocked(false);
    setWonAmount(0);
  };

  const handleInput = (num: string) => {
    if (gameState !== 'PLAYING') return;
    if (currentGuess.length < 4) {
      setCurrentGuess(prev => prev + num);
    }
  };

  const handleClear = () => {
    if (gameState !== 'PLAYING') return;
    setCurrentGuess('');
  };

  const handleQuickCode = (code: string) => {
      if (gameState !== 'PLAYING') return;
      setCurrentGuess(code);
      setTimeout(() => executeSubmit(code), 250);
  };

  const executeSubmit = (guess: string) => {
    if (guess.length !== 4) return;

    const newAttempts = attempts + 1;
    setAttempts(newAttempts);

    // Mastermind Logic
    const result = new Array(4).fill('R'); // Default Red
    const targetArr = targetCode.split('');
    const guessArr = guess.split('');
    
    // Track usage to handle duplicates correctly (Mastermind rules)
    const targetUsed = new Array(4).fill(false);
    const guessUsed = new Array(4).fill(false);

    // 1. Exact Matches (Green)
    for (let i = 0; i < 4; i++) {
        if (guessArr[i] === targetArr[i]) {
            result[i] = 'G';
            targetUsed[i] = true;
            guessUsed[i] = true;
        }
    }

    // 2. Wrong Position (Yellow)
    for (let i = 0; i < 4; i++) {
        if (!guessUsed[i]) {
            for (let j = 0; j < 4; j++) {
                if (!targetUsed[j] && guessArr[i] === targetArr[j]) {
                    result[i] = 'Y';
                    targetUsed[j] = true;
                    break;
                }
            }
        }
    }

    // Add to history (Newest first)
    setHistory(prev => [{ guess, result }, ...prev]);

    if (guess === targetCode) {
        setGameState('WON');
        // Higher reward formula: Base 500 - (50 per attempt)
        const winAmount = Math.max(50, BASE_REWARD - (attempts * 50)); 
        setWonAmount(winAmount);
        setScrapBalance(prev => prev + winAmount);
    } else {
        setCurrentGuess('');
        // Shock Effect
        setShocked(true);
        setTimeout(() => setShocked(false), 300);

        if (newAttempts >= MAX_ATTEMPTS) {
            setGameState('LOST');
        }
    }
  };

  const renderKeypad = () => {
      return (
          <div className="bg-[#2a2a2a] p-1.5 rounded-b-3xl border-x-8 border-b-8 border-[#1a1a1a] shadow-2xl relative z-10">
              <div className="grid grid-cols-3 gap-2 p-3 bg-[#18181b] rounded-2xl border border-zinc-800">
                  {[1, 2, 3, 4, 5, 6, 7, 8, 9].map(num => (
                      <button
                        key={num}
                        onClick={() => handleInput(num.toString())}
                        className="aspect-square bg-zinc-800 hover:bg-zinc-700 text-zinc-200 font-black text-2xl rounded-lg shadow-[0_4px_0_#27272a] active:translate-y-[4px] active:shadow-none transition-all flex items-center justify-center font-mono border-t border-white/10"
                      >
                          {num}
                      </button>
                  ))}
                  
                  {/* Bottom Row */}
                  <button 
                    onClick={handleClear}
                    className="aspect-square bg-red-900/80 hover:bg-red-900 text-white font-bold text-[10px] uppercase rounded-lg shadow-[0_4px_0_#450a0a] active:translate-y-[4px] active:shadow-none transition-all flex items-center justify-center tracking-wider border-t border-white/10"
                  >
                      CLEAR
                  </button>
                  
                  <button
                    onClick={() => handleInput('0')}
                    className="aspect-square bg-zinc-800 hover:bg-zinc-700 text-zinc-200 font-black text-2xl rounded-lg shadow-[0_4px_0_#27272a] active:translate-y-[4px] active:shadow-none transition-all flex items-center justify-center font-mono border-t border-white/10"
                  >
                      0
                  </button>
                  
                  <button 
                    onClick={() => executeSubmit(currentGuess)}
                    disabled={currentGuess.length !== 4}
                    className="aspect-square bg-green-700 hover:bg-green-600 text-white font-bold text-[10px] uppercase rounded-lg shadow-[0_4px_0_#14532d] active:translate-y-[4px] active:shadow-none transition-all flex items-center justify-center tracking-wider disabled:opacity-50 disabled:cursor-not-allowed border-t border-white/10"
                  >
                      ENTER
                  </button>
              </div>
          </div>
      );
  };

  return (
    <div className={`flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative overflow-hidden ${shocked ? 'animate-shake' : ''}`}>
      
      {/* SHOCK OVERLAY (Red Flash) */}
      <div 
        className={`absolute inset-0 z-50 bg-red-600/40 pointer-events-none transition-opacity duration-150 mix-blend-overlay ${shocked ? 'opacity-100' : 'opacity-0'}`} 
      />

      <style>{`
        @keyframes shake {
          0%, 100% { transform: translateX(0); }
          25% { transform: translateX(-6px); }
          75% { transform: translateX(6px); }
        }
        .animate-shake { animation: shake 0.2s ease-in-out; }
        .led-glow { text-shadow: 0 0 10px rgba(220, 38, 38, 0.8), 0 0 20px rgba(220, 38, 38, 0.4); }
        .led-glow-green { text-shadow: 0 0 10px rgba(34, 197, 94, 0.8), 0 0 20px rgba(34, 197, 94, 0.4); }
      `}</style>

      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Code Raider</h2>
                <div className="flex items-center gap-1.5 text-zinc-500 text-xs font-mono uppercase tracking-wider">
                    <Wifi className="w-3 h-3" /> Soft-Side Sim
                </div>
            </div>
        </div>
        <div className="bg-zinc-900 px-3 py-1.5 rounded-full border border-zinc-800 flex items-center gap-2 shadow-inner">
            <span className="text-yellow-500 font-black font-mono text-sm">{scrapBalance}</span>
            <Coins className="w-3.5 h-3.5 text-yellow-600 fill-yellow-600" />
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6 pb-24 flex flex-col items-center gap-8">
          
          {/* --- THE LOCK UNIT --- */}
          <div className="w-full max-w-[320px] relative z-20 mx-auto">
              
              {/* Top Housing (Screen) */}
              <div className="bg-[#2a2a2a] rounded-t-3xl p-6 pb-4 border-x-8 border-t-8 border-[#1a1a1a] shadow-2xl relative">
                  
                  {/* Status Light */}
                  <div className="flex justify-center mb-5">
                      <div className={`w-4 h-4 rounded-full shadow-[0_0_15px_currentColor] transition-colors duration-200 border-2 border-black/50
                          ${gameState === 'WON' ? 'bg-green-500 text-green-500' : gameState === 'LOST' ? 'bg-red-600 text-red-600' : 'bg-red-900/50 text-red-900'}
                      `} />
                  </div>

                  {/* LED Screen */}
                  <div className="bg-black border-4 border-[#151515] rounded-xl h-20 flex items-center justify-center relative overflow-hidden shadow-[inset_0_0_30px_rgba(0,0,0,1)] ring-1 ring-white/5">
                      {/* Glass Glare */}
                      <div className="absolute top-0 left-0 right-0 h-1/2 bg-gradient-to-b from-white/10 to-transparent pointer-events-none" />
                      
                      <div className="flex gap-3 relative z-10">
                          {gameState === 'PLAYING' ? (
                              [0,1,2,3].map(i => (
                                  <span key={i} className="font-mono text-4xl font-black text-red-600 w-8 text-center led-glow">
                                      {currentGuess[i] || '*'}
                                  </span>
                              ))
                          ) : (
                              <span className={`font-mono text-4xl font-black tracking-widest ${gameState === 'WON' ? 'text-green-500 led-glow-green' : 'text-red-600 led-glow'}`}>
                                  {gameState === 'WON' ? 'OPEN' : targetCode}
                              </span>
                          )}
                      </div>
                  </div>

                  {/* Health/Attempts Bar */}
                  <div className="flex justify-between items-center mt-4 px-1">
                      <span className="text-[9px] font-bold text-[#666] uppercase tracking-widest">Battery Level</span>
                      <div className="flex gap-1">
                          {Array.from({ length: MAX_ATTEMPTS }).map((_, i) => (
                              <div key={i} className={`w-4 h-1.5 rounded-full transition-colors ${i < (MAX_ATTEMPTS - attempts) ? 'bg-green-600' : 'bg-[#333]'}`} />
                          ))}
                      </div>
                  </div>
              </div>

              {/* Bottom Housing (Keypad or Result) */}
              {gameState === 'PLAYING' ? (
                  renderKeypad()
              ) : (
                  <div className="bg-[#252525] p-8 rounded-b-3xl border-x-8 border-b-8 border-[#1a1a1a] shadow-2xl text-center space-y-6">
                      {gameState === 'WON' ? (
                          <div className="flex flex-col items-center gap-3 animate-in zoom-in duration-300">
                              <div className="w-16 h-16 bg-green-500/10 rounded-full flex items-center justify-center border-2 border-green-500/50 shadow-[0_0_30px_rgba(34,197,94,0.2)]">
                                <Unlock className="w-8 h-8 text-green-500" />
                              </div>
                              <div>
                                <h3 className="text-2xl font-black uppercase text-white tracking-wide">Access Granted</h3>
                                <p className="text-green-400 font-mono text-sm mt-1">Reward: +{wonAmount} Scrap</p>
                              </div>
                          </div>
                      ) : (
                          <div className="flex flex-col items-center gap-3 animate-in zoom-in duration-300">
                              <div className="w-16 h-16 bg-red-900/20 rounded-full flex items-center justify-center border-2 border-red-500/50 shadow-[0_0_30px_rgba(220,38,38,0.2)]">
                                <ShieldAlert className="w-8 h-8 text-red-500" />
                              </div>
                              <div>
                                <h3 className="text-2xl font-black uppercase text-red-500 tracking-wide">System Lockout</h3>
                                <p className="text-zinc-500 text-sm mt-1">Code changed by owner.</p>
                              </div>
                          </div>
                      )}
                      
                      <button 
                        onClick={startNewGame}
                        className="w-full py-4 bg-[#eab308] hover:bg-[#ca8a04] text-black font-black uppercase rounded-xl shadow-lg flex items-center justify-center gap-2 transition-transform active:scale-95 text-sm tracking-wide"
                      >
                          <RefreshCw className="w-5 h-5" /> {gameState === 'WON' ? 'Hack Another' : 'Retry Hack'}
                      </button>
                  </div>
              )}
          </div>

          {/* --- HACKING DEVICE (HISTORY) --- */}
          {/* Only show if playing or if there is history */}
          {(gameState === 'PLAYING' || history.length > 0) && (
              <div className="w-full max-w-[320px] bg-black border border-zinc-800 rounded-2xl p-5 relative shadow-2xl mx-auto flex flex-col">
                  {/* CRT Overlay */}
                  <div className="absolute inset-0 bg-[linear-gradient(rgba(18,16,16,0)_50%,rgba(0,0,0,0.1)_50%),linear-gradient(90deg,rgba(255,0,0,0.06),rgba(0,255,0,0.02),rgba(0,0,255,0.06))] pointer-events-none z-10 bg-[length:100%_4px,6px_100%]" />
                  <div className="absolute top-0 left-0 right-0 h-8 bg-gradient-to-b from-green-500/10 to-transparent pointer-events-none" />
                  
                  <div className="flex items-center justify-between mb-4 border-b border-zinc-800 pb-2">
                      <div className="flex items-center gap-2">
                          <Terminal className="w-4 h-4 text-green-500" />
                          <span className="text-[10px] font-bold text-green-500 uppercase tracking-widest font-mono">CODE_BREAKER_V2</span>
                      </div>
                      <span className="text-[9px] text-zinc-600 font-mono">LOG</span>
                  </div>

                  {/* SCROLLABLE LIST - Fixed height and scroll */}
                  <div className="relative z-0 min-h-[120px] max-h-[240px] overflow-y-auto pr-2 space-y-1.5 scrollbar-thin scrollbar-thumb-zinc-800 scrollbar-track-transparent">
                      {history.length === 0 ? (
                          <div className="text-zinc-700 font-mono text-xs italic text-center pt-8">
                              Waiting for input...
                          </div>
                      ) : (
                          history.map((entry, i) => (
                              <div key={i} className="flex items-center justify-between font-mono text-xs border-b border-zinc-900/50 pb-1">
                                  <span className="text-zinc-300 tracking-[0.2em] font-bold">{entry.guess}</span>
                                  <div className="flex gap-1.5">
                                      {entry.result.map((res, rIdx) => (
                                          <div key={rIdx} className={`w-2.5 h-2.5 rounded-full shadow-[0_0_5px_currentColor] border border-black/50 ${
                                              res === 'G' ? 'bg-green-500 text-green-500' : res === 'Y' ? 'bg-yellow-500 text-yellow-500' : 'bg-zinc-800 text-transparent border-zinc-700 shadow-none'
                                          }`} />
                                      ))}
                                  </div>
                              </div>
                          ))
                      )}
                  </div>
                  
                  {/* Legend */}
                  {history.length > 0 && (
                      <div className="mt-4 flex justify-between text-[9px] text-zinc-500 font-mono border-t border-zinc-900 pt-2">
                          <div className="flex items-center gap-1"><div className="w-2 h-2 rounded-full bg-green-500" /> Correct</div>
                          <div className="flex items-center gap-1"><div className="w-2 h-2 rounded-full bg-yellow-500" /> Wrong Spot</div>
                          <div className="flex items-center gap-1"><div className="w-2 h-2 rounded-full bg-zinc-800" /> Invalid</div>
                      </div>
                  )}
              </div>
          )}

          {/* --- QUICK CODES (META) --- */}
          {gameState === 'PLAYING' && (
              <div className="w-full max-w-[320px] mx-auto">
                  <div className="flex items-center gap-2 mb-3 px-1">
                      <Cpu className="w-3 h-3 text-orange-500" />
                      <span className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest">Common Factory Codes</span>
                  </div>
                  <div className="grid grid-cols-4 gap-2">
                      {COMMON_CODES.slice(0, 12).map(code => (
                          <button
                            key={code}
                            onClick={() => handleQuickCode(code)}
                            className="bg-[#18181b] border border-zinc-800 hover:border-orange-500/50 hover:text-orange-500 text-zinc-400 text-xs font-mono font-bold py-2.5 rounded-lg transition-all active:scale-95 shadow-sm"
                          >
                              {code}
                          </button>
                      ))}
                  </div>
              </div>
          )}

      </div>
    </div>
  );
};
