
import React, { useState, useEffect } from 'react';
import { ArrowLeft, Trophy, Coins, Play, Eye, Sparkles, RefreshCw, Skull, Box, Lock } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface MiniGameScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// --- SCRAP MATCH CONFIG ---
type Difficulty = 'GRUB' | 'CHAD' | 'ZERG';

const DIFFICULTIES: Record<Difficulty, { pairs: number; grid: string; bet: number; win: number; time: number; color: string }> = {
    GRUB: { pairs: 6, grid: 'grid-cols-3', bet: 25, win: 50, time: 45, color: 'text-zinc-400' },
    CHAD: { pairs: 8, grid: 'grid-cols-4', bet: 100, win: 250, time: 60, color: 'text-orange-500' },
    ZERG: { pairs: 10, grid: 'grid-cols-4', bet: 250, win: 750, time: 80, color: 'text-red-500' }
};

const ITEMS = [
    { id: 'ak', img: 'https://rustlabs.com/img/items180/rifle.ak.png', rarity: 'yellow' },
    { id: 'm249', img: 'https://rustlabs.com/img/items180/lmg.m249.png', rarity: 'yellow' },
    { id: 'bolty', img: 'https://rustlabs.com/img/items180/rifle.bolt.png', rarity: 'yellow' },
    { id: 'lr300', img: 'https://rustlabs.com/img/items180/rifle.lr300.png', rarity: 'yellow' },
    { id: 'mp5', img: 'https://rustlabs.com/img/items180/smg.mp5.png', rarity: 'blue' },
    { id: 'tommy', img: 'https://rustlabs.com/img/items180/smg.thompson.png', rarity: 'blue' },
    { id: 'c4', img: 'https://rustlabs.com/img/items180/explosive.timed.png', rarity: 'yellow' },
    { id: 'rocket', img: 'https://rustlabs.com/img/items180/ammo.rocket.basic.png', rarity: 'red' },
    { id: 'launcher', img: 'https://rustlabs.com/img/items180/rocket.launcher.png', rarity: 'red' },
    { id: 'mask', img: 'https://rustlabs.com/img/items180/metal.facemask.png', rarity: 'blue' },
    { id: 'chest', img: 'https://rustlabs.com/img/items180/metal.plate.torso.png', rarity: 'blue' },
    { id: 'scrap', img: 'https://rustlabs.com/img/items180/scrap.png', rarity: 'gray' },
    { id: 'cctv', img: 'https://rustlabs.com/img/items180/cctv.camera.png', rarity: 'gray' },
    { id: 'laptop', img: 'https://rustlabs.com/img/items180/targeting.computer.png', rarity: 'gray' },
    { id: 'hazmat', img: 'https://rustlabs.com/img/items180/hazmatsuit.png', rarity: 'blue' }
];

interface Card {
    id: number;
    itemId: string;
    image: string;
    rarity: string;
    isFlipped: boolean;
    isMatched: boolean;
}

export const MiniGameScreen: React.FC<MiniGameScreenProps> = ({ onNavigate }) => {
  // Global State
  const [scrapBalance, setScrapBalance] = useState(() => {
      return parseInt(localStorage.getItem('raid_alarm_scrap') || '1000');
  });
  
  // --- MATCH GAME STATE ---
  const [matchState, setMatchState] = useState<'MENU' | 'PREVIEW' | 'PLAYING' | 'WON' | 'LOST'>('MENU');
  const [difficulty, setDifficulty] = useState<Difficulty>('GRUB');
  const [cards, setCards] = useState<Card[]>([]);
  const [flippedCards, setFlippedCards] = useState<number[]>([]); 
  const [timeLeft, setTimeLeft] = useState(0); 

  // Persist Data
  useEffect(() => {
      localStorage.setItem('raid_alarm_scrap', scrapBalance.toString());
  }, [scrapBalance]);

  // Preload Images
  useEffect(() => {
      ITEMS.forEach((item) => {
          const img = new Image();
          img.src = item.img;
      });
  }, []);

  // --- MATCH GAME LOGIC ---
  useEffect(() => {
      let timer: number;
      if (matchState === 'PLAYING' && timeLeft > 0) {
          timer = window.setInterval(() => {
              setTimeLeft(prev => {
                  if (prev <= 1) {
                      setMatchState('LOST');
                      return 0;
                  }
                  return prev - 1;
              });
          }, 1000);
      }
      return () => clearInterval(timer);
  }, [matchState, timeLeft]);

  const startMatchGame = () => {
      const cost = DIFFICULTIES[difficulty].bet;
      if (scrapBalance < cost) {
          alert("Not enough scrap!");
          return;
      }
      setScrapBalance(prev => prev - cost);
      
      const config = DIFFICULTIES[difficulty];
      const shuffledItems = [...ITEMS].sort(() => Math.random() - 0.5);
      const selectedItems = shuffledItems.slice(0, config.pairs);
      
      const deck = [...selectedItems, ...selectedItems]
          .sort(() => Math.random() - 0.5)
          .map((item, idx) => ({
              id: idx,
              itemId: item.id,
              image: item.img,
              rarity: item.rarity,
              isFlipped: true,
              isMatched: false
          }));

      setCards(deck);
      setFlippedCards([]);
      setTimeLeft(config.time);
      setMatchState('PREVIEW');
      setTimeout(() => {
          setCards(prev => prev.map(c => ({ ...c, isFlipped: false })));
          setMatchState('PLAYING');
      }, 2000);
  };

  const handleCardClick = (index: number) => {
      if (matchState !== 'PLAYING') return;
      if (flippedCards.length >= 2) return; 
      if (cards[index].isFlipped || cards[index].isMatched) return;

      setCards(prev => prev.map((c, i) => i === index ? { ...c, isFlipped: true } : c));
      const newFlipped = [...flippedCards, index];
      setFlippedCards(newFlipped);

      if (newFlipped.length === 2) {
          const [firstIndex, secondIndex] = newFlipped;
          const firstCard = cards[firstIndex];
          const secondCard = cards[index];

          if (firstCard.itemId === secondCard.itemId) {
              setTimeout(() => {
                  setCards(prev => prev.map((c, i) => 
                      (i === firstIndex || i === secondIndex) ? { ...c, isMatched: true } : c
                  ));
                  setFlippedCards([]);
                  setCards(currentCards => {
                      const allMatched = currentCards.every(c => c.isMatched || c.id === firstIndex || c.id === secondIndex);
                      if (allMatched) {
                          const reward = DIFFICULTIES[difficulty].win;
                          setScrapBalance(prev => prev + reward);
                          setMatchState('WON');
                      }
                      return currentCards;
                  });
              }, 300);
          } else {
              setTimeout(() => {
                  setCards(prev => prev.map((c, i) => 
                      (i === firstIndex || i === secondIndex) ? { ...c, isFlipped: false } : c
                  ));
                  setFlippedCards([]);
              }, 1000);
          }
      }
  };

  const getRarityBackground = (rarity: string) => {
      switch(rarity) {
          case 'yellow': return 'bg-gradient-to-br from-yellow-900/40 to-black border-yellow-500/50 shadow-[inset_0_0_20px_rgba(234,179,8,0.1)]';
          case 'blue': return 'bg-gradient-to-br from-blue-900/40 to-black border-blue-500/50 shadow-[inset_0_0_20px_rgba(59,130,246,0.1)]';
          case 'red': return 'bg-gradient-to-br from-red-900/40 to-black border-red-500/50 shadow-[inset_0_0_20px_rgba(239,68,68,0.1)]';
          default: return 'bg-gradient-to-br from-zinc-800 to-black border-zinc-700';
      }
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Background Ambience */}
      <div className="absolute inset-0 pointer-events-none opacity-20 bg-[radial-gradient(circle_at_top,_#2d2b1b_0%,_#0c0c0e_70%)]" />

      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e]/90 backdrop-blur-sm z-10 shrink-0 relative">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors active:scale-95"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Scrap Match</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Memory Game</p>
            </div>
        </div>
        <div className="flex items-center gap-2 bg-zinc-900 px-3 py-1.5 rounded-full border border-zinc-800 shadow-inner">
            <span className="text-yellow-500 font-black font-mono text-sm">{scrapBalance}</span>
            <Coins className="w-4 h-4 text-yellow-600 fill-yellow-600" />
        </div>
      </div>

      <div className="flex-1 overflow-hidden relative z-10">
          
          {/* MENU STATE */}
          {matchState === 'MENU' && (
            <div className="flex flex-col h-full p-6 animate-in zoom-in-95 overflow-y-auto no-scrollbar">
                <div className="flex-1 flex flex-col items-center justify-center">
                    <div className="w-32 h-32 bg-[#2d1b1b] rounded-full flex items-center justify-center border-4 border-[#4d2b2b] mb-8 shadow-[0_0_50px_rgba(220,38,38,0.15)] relative overflow-hidden group">
                        <div className="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')] opacity-20" />
                        <div className="absolute inset-0 bg-gradient-to-t from-red-900/50 to-transparent" />
                        <RefreshCw className="w-16 h-16 text-red-500 relative z-10 drop-shadow-xl" />
                    </div>
                    
                    <h2 className={`text-4xl text-white mb-2 text-center ${TYPOGRAPHY.rustFont} tracking-wider drop-shadow-lg`}>
                        SCRAP MATCH
                    </h2>
                    <p className="text-zinc-500 text-center mb-10 max-w-xs text-xs font-medium leading-relaxed">
                        Find pairs to multiply your scrap. High risk, high reward.
                    </p>

                    <div className="w-full space-y-4 mb-8">
                        {(Object.keys(DIFFICULTIES) as Difficulty[]).map(diff => {
                            const cfg = DIFFICULTIES[diff];
                            const isSelected = difficulty === diff;
                            return (
                                <button
                                    key={diff}
                                    onClick={() => setDifficulty(diff)}
                                    className={`w-full p-4 rounded-xl border-2 relative overflow-hidden transition-all active:scale-[0.98] group
                                        ${isSelected ? 'bg-zinc-800 border-white/20 shadow-xl' : 'bg-zinc-900/50 border-zinc-800 hover:bg-zinc-800'}
                                    `}
                                >
                                    {isSelected && <div className="absolute inset-0 bg-gradient-to-r from-white/5 to-transparent pointer-events-none" />}
                                    <div className="flex items-center justify-between relative z-10">
                                        <div className="flex flex-col items-start">
                                            <span className={`font-black text-sm uppercase tracking-widest ${cfg.color}`}>{diff}</span>
                                            <span className="text-[10px] text-zinc-500 font-mono mt-1">{cfg.pairs} Pairs • {cfg.time}s</span>
                                        </div>
                                        <div className="text-right">
                                            <div className="text-[9px] uppercase font-bold text-zinc-600 mb-0.5">Entry</div>
                                            <div className="font-mono font-bold text-white text-lg flex items-center gap-1">
                                                {cfg.bet} <Coins className="w-3.5 h-3.5 text-yellow-500" />
                                            </div>
                                        </div>
                                    </div>
                                </button>
                            );
                        })}
                    </div>
                </div>
                <button onClick={startMatchGame} className="w-full py-5 bg-white text-black font-black uppercase rounded-2xl flex items-center justify-center gap-3 shadow-[0_0_30px_rgba(255,255,255,0.2)] active:scale-[0.97] transition-all hover:bg-zinc-200 text-sm tracking-wide">
                    <Play className="w-5 h-5 fill-current" /> PLAY (-{DIFFICULTIES[difficulty].bet} SCRAP)
                </button>
            </div>
          )}

          {/* GAME OVER STATE */}
          {(matchState === 'WON' || matchState === 'LOST') && (
            <div className="flex flex-col items-center justify-center h-full p-6 text-center animate-in zoom-in overflow-y-auto no-scrollbar">
                <div className={`w-32 h-32 rounded-full flex items-center justify-center mb-8 border-4 shadow-2xl relative ${matchState === 'WON' ? 'bg-green-900/20 border-green-500 text-green-500 shadow-green-500/20' : 'bg-red-900/20 border-red-500 text-red-500 shadow-red-500/20'}`}>
                    <div className="absolute inset-0 rounded-full border border-white/10" />
                    {matchState === 'WON' ? <Trophy className="w-16 h-16 fill-current" /> : <Skull className="w-16 h-16 fill-current" />}
                </div>
                <h2 className={`text-5xl font-black italic uppercase mb-2 tracking-tighter drop-shadow-lg ${matchState === 'WON' ? 'text-white' : 'text-red-500'}`}>
                    {matchState === 'WON' ? 'JACKPOT' : 'WIPED'}
                </h2>
                <div className="bg-[#18181b] p-6 rounded-2xl border border-zinc-800 mb-10 w-full shadow-lg relative overflow-hidden">
                    {matchState === 'WON' && <div className="absolute inset-0 bg-green-500/5" />}
                    <p className="text-zinc-500 text-[10px] uppercase font-bold tracking-widest mb-2">Net Result</p>
                    {matchState === 'WON' ? (
                        <p className="text-3xl font-mono font-black text-green-400 flex items-center justify-center gap-2">
                            +{DIFFICULTIES[difficulty].win} <Coins className="w-6 h-6 text-yellow-500 fill-yellow-500" />
                        </p>
                    ) : (
                        <p className="text-3xl font-mono font-black text-red-500 flex items-center justify-center gap-2">
                            -{DIFFICULTIES[difficulty].bet} <Coins className="w-6 h-6 text-red-700" />
                        </p>
                    )}
                </div>
                <div className="w-full space-y-3">
                    <button onClick={startMatchGame} className="w-full py-4 bg-white text-black font-black uppercase rounded-xl hover:bg-zinc-200 transition-all active:scale-95 shadow-lg flex items-center justify-center gap-2">
                        <Play className="w-4 h-4 fill-current" /> Play Again
                    </button>
                    <button onClick={() => setMatchState('MENU')} className="w-full py-4 bg-zinc-900 text-zinc-400 font-bold uppercase rounded-xl border border-zinc-800 hover:text-white transition-all active:scale-95">
                        Return to Menu
                    </button>
                </div>
            </div>
          )}

          {/* PLAYING / PREVIEW STATE */}
          {(matchState === 'PLAYING' || matchState === 'PREVIEW') && (
              <div className="flex flex-col h-full p-4 overflow-hidden">
                  <div className="flex items-center justify-between mb-4 bg-zinc-900/90 p-4 rounded-2xl border border-zinc-800/80 backdrop-blur-md shadow-lg shrink-0">
                      <div className="flex flex-col">
                          <span className="text-[9px] text-zinc-500 font-black uppercase tracking-widest mb-0.5">Timer</span>
                          <span className={`text-2xl font-mono font-black ${timeLeft < 10 ? 'text-red-500 animate-pulse' : 'text-white'}`}>{timeLeft}s</span>
                      </div>
                      <div className="h-8 w-px bg-zinc-800" />
                      <div className="flex flex-col items-end">
                          <span className="text-[9px] text-zinc-500 font-black uppercase tracking-widest mb-0.5">Potential</span>
                          <span className="text-xl font-mono font-black text-green-400 flex items-center gap-1.5">+{DIFFICULTIES[difficulty].win} <Coins className="w-4 h-4 text-green-500" /></span>
                      </div>
                  </div>
                  
                  <div className={`grid ${DIFFICULTIES[difficulty].grid} gap-2 auto-rows-fr flex-1 pb-20 perspective-1000`}>
                      {cards.map((card, idx) => (
                          <button 
                            key={idx} 
                            onClick={() => handleCardClick(idx)} 
                            disabled={card.isMatched || card.isFlipped || matchState === 'PREVIEW'} 
                            className="relative w-full h-full min-h-[60px] group outline-none"
                          >
                              <div className={`w-full h-full transition-all duration-500 transform-style-3d ${card.isFlipped || card.isMatched ? 'rotate-y-180' : ''}`}>
                                  
                                  {/* CARD BACK (Hidden State) - Improved Visuals */}
                                  <div className={`absolute inset-0 w-full h-full backface-hidden rounded-xl flex items-center justify-center border-2 border-[#3f3f46] bg-[#27272a] shadow-lg overflow-hidden ${!card.isFlipped && !card.isMatched ? 'group-hover:border-zinc-500 group-active:scale-[0.98] transition-all' : ''}`}>
                                      {/* Crate Cross Texture */}
                                      <div className="absolute inset-0 opacity-10 bg-[repeating-linear-gradient(45deg,transparent,transparent_10px,#000_10px,#000_20px)]" />
                                      <div className="absolute inset-2 border border-zinc-700/50 rounded-lg" />
                                      
                                      {/* Center Icon */}
                                      <div className="relative z-10 text-zinc-600 opacity-50 bg-black/40 p-2 rounded-full border border-white/5">
                                          {difficulty === 'ZERG' ? <Lock className="w-6 h-6 stroke-[2]" /> : <Box className="w-6 h-6 stroke-[2]" />}
                                      </div>
                                      
                                      {/* Industrial Bolts */}
                                      <div className="absolute top-1.5 left-1.5 w-1.5 h-1.5 bg-[#18181b] rounded-full shadow-[inset_0_1px_2px_rgba(0,0,0,0.8)] border border-zinc-700" />
                                      <div className="absolute top-1.5 right-1.5 w-1.5 h-1.5 bg-[#18181b] rounded-full shadow-[inset_0_1px_2px_rgba(0,0,0,0.8)] border border-zinc-700" />
                                      <div className="absolute bottom-1.5 left-1.5 w-1.5 h-1.5 bg-[#18181b] rounded-full shadow-[inset_0_1px_2px_rgba(0,0,0,0.8)] border border-zinc-700" />
                                      <div className="absolute bottom-1.5 right-1.5 w-1.5 h-1.5 bg-[#18181b] rounded-full shadow-[inset_0_1px_2px_rgba(0,0,0,0.8)] border border-zinc-700" />
                                  </div>

                                  {/* CARD FRONT (Revealed State) */}
                                  <div className={`absolute inset-0 w-full h-full backface-hidden rounded-xl border-2 flex items-center justify-center p-2 rotate-y-180 shadow-2xl overflow-hidden
                                      ${card.isMatched 
                                          ? 'border-green-500 shadow-[0_0_20px_rgba(34,197,94,0.6)] bg-green-900/20' 
                                          : getRarityBackground(card.rarity)}
                                  `}>
                                      <div className={`absolute inset-0 opacity-40 bg-gradient-to-t from-black via-transparent to-transparent pointer-events-none`} />
                                      
                                      <img src={card.image} alt="item" className="w-full h-full object-contain drop-shadow-md relative z-10" />
                                      
                                      {/* Matched Sparkle */}
                                      {card.isMatched && (
                                          <div className="absolute top-1 right-1 bg-green-500 rounded-full w-4 h-4 flex items-center justify-center shadow-lg z-20 animate-in zoom-in duration-300">
                                              <Sparkles className="w-2.5 h-2.5 text-black fill-black" />
                                          </div>
                                      )}
                                  </div>
                              </div>
                          </button>
                      ))}
                  </div>
                  
                  {matchState === 'PREVIEW' && (
                      <div className="absolute inset-0 z-50 flex items-center justify-center pointer-events-none">
                          <div className="bg-black/90 backdrop-blur-md px-8 py-4 rounded-2xl border border-zinc-700 flex flex-col items-center gap-2 animate-in zoom-in fade-in duration-300 shadow-2xl">
                              <Eye className="w-8 h-8 text-white animate-pulse" />
                              <span className="text-white font-black uppercase tracking-widest text-lg">Memorize!</span>
                          </div>
                      </div>
                  )}
              </div>
          )}

      </div>
    </div>
  );
};
