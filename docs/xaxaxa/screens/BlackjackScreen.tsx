
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Spade, 
  Club, 
  Heart, 
  Diamond, 
  Shield,
  Play,
  Plus,
  Hand,
  XCircle
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface BlackjackScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// --- CONSTANTS ---
const HQM_IMAGE_URL = "https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fmetal-refined.webp&w=414&q=90";

// --- TYPES ---
type Suit = 'H' | 'D' | 'C' | 'S';
type Rank = '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' | '10' | 'J' | 'Q' | 'K' | 'A';

interface CardData {
    suit: Suit;
    rank: Rank;
    value: number;
    id: string;
    isHidden?: boolean;
}

type GamePhase = 'BETTING' | 'DEALING' | 'PLAYER_TURN' | 'DEALER_TURN' | 'RESOLVING' | 'GAME_OVER';

// --- LOGIC HELPERS ---
const VALUES: Record<Rank, number> = {
    '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9, '10': 10,
    'J': 10, 'Q': 10, 'K': 10, 'A': 11
};

const createDeck = (): CardData[] => {
    const suits: Suit[] = ['H', 'D', 'C', 'S'];
    const ranks: Rank[] = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];
    let deck: CardData[] = [];
    
    // Create multiple decks (4 decks is standard casino)
    for (let i = 0; i < 4; i++) { 
        suits.forEach(suit => {
            ranks.forEach(rank => {
                deck.push({
                    suit,
                    rank,
                    value: VALUES[rank],
                    id: `${rank}${suit}-${i}-${Math.random()}`,
                    isHidden: false
                });
            });
        });
    }
    return deck.sort(() => Math.random() - 0.5); // Shuffle
};

const calculateHand = (hand: CardData[]) => {
    let score = 0;
    let aces = 0;

    hand.forEach(card => {
        if (card.isHidden) return;
        score += card.value;
        if (card.rank === 'A') aces += 1;
    });

    while (score > 21 && aces > 0) {
        score -= 10;
        aces -= 1;
    }
    return score;
};

// --- VISUAL COMPONENT: CARD ---
interface PlayingCardProps {
    card: CardData;
    index: number;
    style?: React.CSSProperties;
    totalCards: number;
}

// This is drawn purely with code, no images needed.
const PlayingCard: React.FC<PlayingCardProps> = ({ card, index, style, totalCards }) => {
    
    // --- DYNAMIC OVERLAP LOGIC ---
    // Calculates how much negative margin to apply based on total cards to fit screen.
    // Screen width assumption ~360px safe area.
    // Card width 96px (w-24).
    // Formula ensures cards squeeze if count > 4.
    const calculateMargin = () => {
        if (index === 0) return 0;
        const baseMargin = -15; // Standard overlap
        if (totalCards <= 4) return baseMargin;
        
        // Squeeze logic: (AvailableWidth / (N-1)) - CardWidth
        // Available ~260px for overlaps
        const squeeze = (260 / (totalCards - 1)) - 96;
        return Math.min(baseMargin, squeeze);
    };

    const overlapStyle = {
        marginLeft: `${calculateMargin()}px`,
        zIndex: index, // Higher index on top
        transform: `rotate(${(index - (totalCards - 1) / 2) * 2}deg) translateY(${Math.abs(index - (totalCards - 1) / 2) * 2}px)`, 
        ...style
    };

    if (card.isHidden) {
        return (
            <div 
                className="w-24 h-36 rounded-xl border-2 border-[#3f1a1a] shadow-2xl relative overflow-hidden bg-[#592323] transition-all duration-500 shrink-0"
                style={{ 
                    ...overlapStyle,
                    backgroundImage: 'repeating-linear-gradient(45deg, #4a1c1c 0, #4a1c1c 10px, #3b1616 10px, #3b1616 20px)'
                }}
            >
                <div className="absolute inset-0 flex items-center justify-center">
                    <div className="w-12 h-16 border-2 border-[#7a3030] rounded-lg flex items-center justify-center bg-[#4a1c1c]/50">
                        {/* Removed Text, simple shape */}
                        <div className="w-6 h-8 bg-[#3f1a1a] rounded-sm opacity-50" />
                    </div>
                </div>
            </div>
        );
    }

    const isRed = card.suit === 'H' || card.suit === 'D';
    const Icon = card.suit === 'H' ? Heart : card.suit === 'D' ? Diamond : card.suit === 'C' ? Club : Spade;

    return (
        <div 
            className="w-24 h-36 bg-white rounded-xl shadow-2xl border border-zinc-200 relative select-none flex flex-col justify-between p-2 animate-in slide-in-from-right-10 fade-in duration-500 shrink-0"
            style={overlapStyle}
        >
            {/* Top Left */}
            <div className="flex flex-col items-center leading-none">
                <span className={`text-xl font-black ${isRed ? 'text-red-600' : 'text-black'}`}>{card.rank}</span>
                <Icon className={`w-4 h-4 ${isRed ? 'text-red-600 fill-current' : 'text-black fill-current'}`} />
            </div>

            {/* Center Big Icon */}
            <div className="absolute inset-0 flex items-center justify-center">
                <Icon className={`w-12 h-12 opacity-20 ${isRed ? 'text-red-600 fill-current' : 'text-black fill-current'}`} />
            </div>

            {/* Bottom Right (Rotated) */}
            <div className="flex flex-col items-center leading-none rotate-180">
                <span className={`text-xl font-black ${isRed ? 'text-red-600' : 'text-black'}`}>{card.rank}</span>
                <Icon className={`w-4 h-4 ${isRed ? 'text-red-600 fill-current' : 'text-black fill-current'}`} />
            </div>
        </div>
    );
};

export const BlackjackScreen: React.FC<BlackjackScreenProps> = ({ onNavigate }) => {
  // State
  const [scrap, setScrap] = useState(() => parseInt(localStorage.getItem('raid_alarm_scrap') || '1000'));
  const [bet, setBet] = useState(10);
  const [deck, setDeck] = useState<CardData[]>([]);
  const [playerHand, setPlayerHand] = useState<CardData[]>([]);
  const [dealerHand, setDealerHand] = useState<CardData[]>([]);
  const [phase, setPhase] = useState<GamePhase>('BETTING');
  const [resultMsg, setResultMsg] = useState<{ text: string; subtext?: string; color: string; amount?: number } | null>(null);

  // Sync Scrap
  useEffect(() => {
      localStorage.setItem('raid_alarm_scrap', scrap.toString());
  }, [scrap]);

  // Init Deck
  useEffect(() => {
      setDeck(createDeck());
  }, []);

  // --- ACTIONS ---

  const placeBet = (amount: number) => {
      // Logic for adding to bet
      if (bet + amount <= scrap) setBet(prev => prev + amount);
  };

  const clearBet = () => setBet(10); // Reset to min

  const dealGame = async () => {
      if (bet > scrap || bet <= 0) return;
      
      // Reshuffle deck if running low
      if (deck.length < 15) setDeck(createDeck());

      setScrap(prev => prev - bet);
      setPlayerHand([]);
      setDealerHand([]);
      setPhase('DEALING');
      setResultMsg(null);

      const newDeck = [...deck];
      const pHand: CardData[] = [];
      const dHand: CardData[] = [];

      // --- DEALING ANIMATION SEQUENCE ---
      // We simulate the delay of cards being thrown onto the table
      
      // 1. Player Card 1
      await wait(300);
      const c1 = newDeck.pop()!;
      pHand.push(c1);
      setPlayerHand([...pHand]);
      
      // 2. Dealer Card 1 (Face Up)
      await wait(300);
      const c2 = newDeck.pop()!;
      dHand.push(c2);
      setDealerHand([...dHand]);

      // 3. Player Card 2
      await wait(300);
      const c3 = newDeck.pop()!;
      pHand.push(c3);
      setPlayerHand([...pHand]);

      // 4. Dealer Card 2 (Face Down / Hidden)
      await wait(300);
      const c4 = newDeck.pop()!;
      c4.isHidden = true;
      dHand.push(c4);
      setDealerHand([...dHand]);

      setDeck(newDeck);

      // Check Natural Blackjack
      const pScore = calculateHand(pHand);
      if (pScore === 21) {
          // Instant win if player has BJ (Simplified, usually dealer checks peek)
          // We will resolve immediately
          resolveGame(pHand, dHand, 'PLAYER_TURN'); 
      } else {
          setPhase('PLAYER_TURN');
      }
  };

  const hit = async () => {
      if (phase !== 'PLAYER_TURN') return;
      
      const newDeck = [...deck];
      const card = newDeck.pop()!;
      const newHand = [...playerHand, card];
      
      setPlayerHand(newHand);
      setDeck(newDeck);

      const score = calculateHand(newHand);
      if (score > 21) {
          // BUST
          await wait(500); // Small pause to realize mistake
          resolveGame(newHand, dealerHand, 'PLAYER_TURN');
      }
  };

  const stand = () => {
      setPhase('DEALER_TURN');
  };

  const doubleDown = async () => {
      if (scrap < bet) return; // Can't afford
      setScrap(prev => prev - bet);
      setBet(prev => prev * 2);
      
      // Hit once
      const newDeck = [...deck];
      const card = newDeck.pop()!;
      const newHand = [...playerHand, card];
      setPlayerHand(newHand);
      setDeck(newDeck);

      // Force stand or bust
      const score = calculateHand(newHand);
      if (score > 21) {
          await wait(500);
          resolveGame(newHand, dealerHand, 'PLAYER_TURN');
      } else {
          setPhase('DEALER_TURN');
      }
  };

  // --- DEALER AI ---
  useEffect(() => {
      if (phase === 'DEALER_TURN') {
          const runDealer = async () => {
              let currentDHand = [...dealerHand];
              let currentDeck = [...deck];

              // 1. Reveal Hole Card
              await wait(600);
              currentDHand[1].isHidden = false;
              setDealerHand([...currentDHand]);
              
              // 2. Hit until 17
              let dScore = calculateHand(currentDHand);
              while (dScore < 17) {
                  await wait(1000); // Thinking time
                  const card = currentDeck.pop()!;
                  currentDHand.push(card);
                  setDealerHand([...currentDHand]); 
                  setDeck([...currentDeck]);
                  dScore = calculateHand(currentDHand);
              }

              await wait(500);
              resolveGame(playerHand, currentDHand, 'DEALER_TURN');
          };
          runDealer();
      }
  }, [phase]);

  const resolveGame = (pHand: CardData[], dHand: CardData[], finalPhase: GamePhase) => {
      setPhase('RESOLVING');
      
      const pScore = calculateHand(pHand);
      // Ensure dealer hidden card is counted if not revealed (e.g. player bust)
      const visibleDHand = dHand.map(c => ({...c, isHidden: false}));
      const dScore = calculateHand(visibleDHand);
      
      // Update UI to show dealer cards if player busted
      setDealerHand(visibleDHand);

      let win = 0;
      let msg = '';
      let sub = '';
      let color = 'text-white';

      if (pScore > 21) {
          msg = 'BUSTED';
          sub = 'You went over 21';
          color = 'text-red-500';
          win = 0;
      } else {
          const isPlayerBJ = pScore === 21 && pHand.length === 2;
          const isDealerBJ = dScore === 21 && dHand.length === 2;

          if (isPlayerBJ && !isDealerBJ) {
              msg = 'BLACKJACK!';
              sub = 'Payout 3:2';
              color = 'text-yellow-400';
              win = bet + (bet * 1.5);
          } else if (dScore > 21) {
              msg = 'YOU WIN';
              sub = 'Dealer Busted';
              color = 'text-green-500';
              win = bet * 2;
          } else if (pScore > dScore) {
              msg = 'YOU WIN';
              sub = `${pScore} vs ${dScore}`;
              color = 'text-green-500';
              win = bet * 2;
          } else if (dScore > pScore) {
              msg = 'DEALER WINS';
              sub = `${dScore} vs ${pScore}`;
              color = 'text-red-500';
              win = 0;
          } else {
              msg = 'PUSH';
              sub = 'Scrap Returned';
              color = 'text-blue-400';
              win = bet; // Return bet
          }
      }

      setResultMsg({ text: msg, subtext: sub, color, amount: win > bet ? win - bet : 0 });
      if (win > 0) setScrap(prev => prev + win);
      setPhase('GAME_OVER');

      // AUTO RESET AFTER DELAY
      setTimeout(() => {
          setResultMsg(null);
          setPhase('BETTING');
      }, 2500);
  };

  const wait = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

  // --- RENDER ---
  const playerScore = calculateHand(playerHand);
  const dealerScore = calculateHand(dealerHand); // Uses isHidden property to hide value

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative select-none overflow-hidden">
      
      {/* Header - Centered Layout */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#152e22] z-20 shrink-0 shadow-lg relative">
        <button 
            onClick={() => onNavigate('DASHBOARD')}
            className="w-10 h-10 rounded-full bg-black/20 border border-white/10 flex items-center justify-center text-white/70 hover:text-white transition-colors absolute left-4"
        >
            <ArrowLeft className="w-5 h-5" />
        </button>
        
        {/* Centered Title */}
        <div className="w-full text-center">
            <h2 className={`text-2xl text-white ${TYPOGRAPHY.rustFont}`}>BLACKJACK</h2>
        </div>

        <div className="bg-black/40 px-3 py-1.5 rounded-full border border-white/10 flex items-center gap-2 shadow-inner absolute right-4">
            <span className="text-zinc-300 font-black font-mono text-sm">{scrap}</span>
            <img src={HQM_IMAGE_URL} className="w-4 h-4 object-contain" alt="HQM" />
        </div>
      </div>

      {/* GAME TABLE AREA */}
      <div className="flex-1 relative flex flex-col overflow-hidden bg-[#1e4635]">
          {/* Table Texture */}
          <div className="absolute inset-0 pointer-events-none opacity-40 bg-[url('https://www.transparenttextures.com/patterns/felt.png')] z-0" />
          
          {/* Vignette */}
          <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,transparent_0%,rgba(0,0,0,0.6)_100%)] z-0 pointer-events-none" />

          {/* Logo on Felt */}
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 opacity-10 pointer-events-none z-0">
              <Spade className="w-64 h-64 text-black fill-black" />
          </div>

          {/* --- DEALER AREA (Top) --- */}
          <div className="flex-1 flex flex-col items-center pt-8 relative z-10">
              <div className="flex justify-center items-center h-40 w-full pl-[7px]"> 
                 {/* Slight offset to center hand visually due to stacking logic */}
                  {dealerHand.map((card, i) => (
                      <PlayingCard 
                        key={card.id} 
                        card={card} 
                        index={i} 
                        totalCards={dealerHand.length}
                      />
                  ))}
                  {dealerHand.length === 0 && phase === 'BETTING' && (
                      <div className="w-24 h-36 rounded-xl border-2 border-white/10 flex items-center justify-center opacity-20">
                          <span className="text-white font-bold text-xs uppercase tracking-widest">Dealer</span>
                      </div>
                  )}
              </div>
              
              {/* Dealer Score Badge */}
              {(dealerHand.length > 0) && (
                  <div className="mt-2 bg-black/60 backdrop-blur px-3 py-1 rounded-full border border-white/10 shadow-lg animate-in fade-in zoom-in">
                      <span className="text-xs font-bold text-zinc-300 uppercase tracking-widest">
                         {phase === 'PLAYER_TURN' ? 'Dealer' : `Dealer: ${dealerScore}`}
                      </span>
                  </div>
              )}
          </div>

          {/* --- RESULT OVERLAY (Center) --- */}
          {resultMsg && (
              <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-50 flex flex-col items-center animate-in zoom-in duration-300 w-full pointer-events-none">
                  <div className="bg-black/90 backdrop-blur-md px-6 py-4 rounded-2xl border border-white/10 shadow-2xl text-center w-60 relative overflow-hidden">
                      {/* Glow Background */}
                      <div className={`absolute inset-0 opacity-20 ${resultMsg.amount && resultMsg.amount > 0 ? 'bg-green-500' : 'bg-red-500'}`} />
                      
                      <h3 className={`text-3xl font-black italic uppercase tracking-tighter mb-1 ${resultMsg.color} drop-shadow-md`}>
                          {resultMsg.text}
                      </h3>
                      <p className="text-zinc-300 font-bold uppercase text-[10px] tracking-widest mb-2">
                          {resultMsg.subtext}
                      </p>
                      
                      {resultMsg.amount !== undefined && resultMsg.amount > 0 && (
                          <div className="inline-flex items-center gap-1.5 bg-green-900/40 px-3 py-1.5 rounded-lg border border-green-500/30">
                              <span className="text-green-400 font-mono font-black text-lg">+{resultMsg.amount}</span>
                              <img src={HQM_IMAGE_URL} className="w-4 h-4 object-contain" alt="HQM" />
                          </div>
                      )}
                  </div>
              </div>
          )}

          {/* --- PLAYER AREA (Bottom) --- */}
          <div className="flex-1 flex flex-col items-center justify-end pb-8 relative z-10">
              
              {/* Player Score Badge */}
              {(playerHand.length > 0) && (
                  <div className="mb-4 bg-black/60 backdrop-blur px-3 py-1 rounded-full border border-white/10 shadow-lg animate-in fade-in zoom-in">
                      <span className="text-xs font-bold text-zinc-300 uppercase tracking-widest">
                          You: {playerScore}
                      </span>
                  </div>
              )}

              <div className="flex justify-center items-center h-40 w-full pl-[7px]">
                  {playerHand.map((card, i) => (
                      <PlayingCard 
                        key={card.id} 
                        card={card} 
                        index={i} 
                        totalCards={playerHand.length}
                      />
                  ))}
                  {playerHand.length === 0 && phase === 'BETTING' && (
                      <div className="w-24 h-36 rounded-xl border-2 border-white/10 flex items-center justify-center opacity-20">
                          <span className="text-white font-bold text-xs uppercase tracking-widest">Player</span>
                      </div>
                  )}
              </div>
          </div>

      </div>

      {/* CONTROLS PANEL */}
      <div className="bg-[#151516] border-t border-zinc-800 p-4 pb-8 z-30 shadow-2xl relative">
          
          {phase === 'BETTING' && (
              <div className="flex flex-col gap-4 animate-in slide-in-from-bottom duration-300">
                  <div className="flex justify-between items-center px-1">
                      <span className="text-zinc-500 text-xs font-bold uppercase tracking-wider">Place Your Bet</span>
                      <div className="flex items-center gap-2">
                         <span className="text-white font-mono font-bold text-2xl">{bet}</span>
                         <img src={HQM_IMAGE_URL} className="w-5 h-5 object-contain" alt="HQM" />
                      </div>
                  </div>
                  
                  {/* Chips */}
                  <div className="grid grid-cols-4 gap-2">
                      {[10, 50, 100, 500].map((amt) => (
                          <button
                            key={amt}
                            onClick={() => placeBet(amt)}
                            disabled={scrap < amt}
                            className={`h-12 rounded-xl font-bold text-xs border-b-4 transition-all active:scale-95 flex flex-col items-center justify-center
                                bg-zinc-800 border-zinc-950 text-zinc-300 hover:bg-zinc-700
                                disabled:opacity-50 disabled:cursor-not-allowed
                            `}
                          >
                              +{amt}
                          </button>
                      ))}
                  </div>

                  <div className="flex gap-2">
                      <button 
                        onClick={clearBet}
                        className="w-16 h-12 rounded-xl bg-zinc-800 text-zinc-400 font-bold border-b-4 border-zinc-950 hover:text-white active:scale-95 transition-all flex items-center justify-center"
                      >
                          <XCircle className="w-5 h-5" />
                      </button>
                      <button 
                        onClick={dealGame}
                        disabled={scrap < bet || bet <= 0}
                        className="flex-1 h-12 bg-green-600 hover:bg-green-500 text-white font-black uppercase tracking-widest rounded-xl shadow-lg border-b-4 border-green-800 active:scale-[0.98] active:border-b-0 active:translate-y-1 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
                      >
                          <Play className="w-5 h-5 fill-current" /> DEAL CARDS
                      </button>
                  </div>
              </div>
          )}

          {phase === 'PLAYER_TURN' && (
              <div className="flex gap-3 animate-in slide-in-from-bottom duration-300">
                  <button 
                    onClick={hit}
                    className="flex-1 py-3 bg-green-600 hover:bg-green-500 text-white font-black uppercase rounded-xl shadow-lg border-b-4 border-green-800 active:border-b-0 active:translate-y-1 transition-all flex flex-row items-center justify-center gap-2"
                  >
                      <Plus className="w-5 h-5" />
                      <span className="text-sm tracking-wider">HIT</span>
                  </button>
                  <button 
                    onClick={stand}
                    className="flex-1 py-3 bg-red-600 hover:bg-red-500 text-white font-black uppercase rounded-xl shadow-lg border-b-4 border-red-800 active:border-b-0 active:translate-y-1 transition-all flex flex-row items-center justify-center gap-2"
                  >
                      <Hand className="w-5 h-5" />
                      <span className="text-sm tracking-wider">STAND</span>
                  </button>
                  <button 
                    onClick={doubleDown}
                    disabled={scrap < bet || playerHand.length > 2} 
                    className="flex-1 py-3 bg-blue-600 hover:bg-blue-500 text-white font-black uppercase rounded-xl shadow-lg border-b-4 border-blue-800 active:border-b-0 active:translate-y-1 transition-all flex flex-row items-center justify-center gap-2 disabled:opacity-50 disabled:grayscale"
                  >
                      <img src={HQM_IMAGE_URL} className="w-5 h-5 object-contain" alt="HQM" />
                      <span className="text-sm tracking-wider">DOUBLE</span>
                  </button>
              </div>
          )}

          {(phase === 'DEALER_TURN' || phase === 'DEALING' || phase === 'RESOLVING') && (
              <div className="w-full py-3 bg-zinc-900 border border-zinc-800 text-zinc-500 font-bold uppercase rounded-xl flex items-center justify-center gap-2 animate-pulse">
                  <Shield className="w-5 h-5" /> 
                  {phase === 'DEALING' ? 'Dealing...' : 'Dealer Turn...'}
              </div>
          )}

      </div>
    </div>
  );
};
