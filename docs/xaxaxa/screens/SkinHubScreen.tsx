
import React, { useState, useEffect } from 'react';
import { ArrowLeft, Gift, Coins, Copy, Star, ExternalLink, Ticket, ShieldCheck, DollarSign, CheckCircle2 } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface SkinHubScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// --- AFFILIATE DATA (REAL WORLD EXAMPLES) ---
const PARTNER_OFFERS = [
    { 
        id: 'rustclash',
        name: 'RustClash', 
        offer: 'Free Case', 
        code: 'RAIDALARM', 
        color: 'text-orange-500', 
        bgColor: 'bg-orange-500/10 border-orange-500/30',
        url: 'https://rustclash.com' 
    },
    { 
        id: 'skinport',
        name: 'SkinPort', 
        offer: 'Low Fee Market', 
        code: 'RAID', 
        color: 'text-blue-400', 
        bgColor: 'bg-blue-500/10 border-blue-500/30',
        url: 'https://skinport.com' 
    },
    { 
        id: 'banditcamp',
        name: 'Bandit.Camp', 
        offer: '$0.50 Free', 
        code: 'ALARM', 
        color: 'text-green-500', 
        bgColor: 'bg-green-500/10 border-green-500/30',
        url: 'https://bandit.camp' 
    },
    { 
        id: 'rustchance',
        name: 'RustChance', 
        offer: 'Welcome Bonus', 
        code: 'RAIDALARM', 
        color: 'text-red-500', 
        bgColor: 'bg-red-500/10 border-red-500/30',
        url: 'https://rustchance.com' 
    }
];

const FEATURED_SKINS = [
    { name: 'Alien Red', item: 'AK-47', price: '$120.00', img: 'https://community.cloudflare.steamstatic.com/economy/image/6TMcQ7eX6E0EZl2byXi7vaVKyDk_zQLX05x6eLCFM9ne_cn43Vm5eVjso7hNph14zVSMqqc_qg-tE8x0KOT70s22yO08rNM5r7Y1RvC8' },
    { name: 'Glory', item: 'AK-47', price: '$400.00', img: 'https://community.cloudflare.steamstatic.com/economy/image/6TMcQ7eX6E0EZl2byXi7vaVKyDk_zQLX05x6eLCFM9ne_cn43Vm5eVjso7hNph14zVSMqqc_qg-tE8x0KOT70s22yO08rNM5r7Y1P_i7' },
    { name: 'Big Grin', item: 'Metal Facemask', price: '$600.00', img: 'https://community.cloudflare.steamstatic.com/economy/image/6TMcQ7eX6E0EZl2byXi7vaVKyDk_zQLX05x6eLCFM9ne_cn43Vm5eVjso7hNph14zVSMqqc_qg-tE8x0KOT70s22yO08rNM5r7Y1Mv2w' },
    { name: 'Punishment', item: 'Metal Mask', price: '$250.00', img: 'https://community.cloudflare.steamstatic.com/economy/image/6TMcQ7eX6E0EZl2byXi7vaVKyDk_zQLX05x6eLCFM9ne_cn43Vm5eVjso7hNph14zVSMqqc_qg-tE8x0KOT70s22yO08rNM5r7Y1N_mz' },
];

// Helper to check if today is a new day
const isNewDay = (lastDate: string | null) => {
    if (!lastDate) return true;
    const today = new Date().toDateString();
    return today !== lastDate;
};

export const SkinHubScreen: React.FC<SkinHubScreenProps> = ({ onNavigate }) => {
  // App-Internal Currency (Scrap)
  const [scrapBalance, setScrapBalance] = useState(() => parseInt(localStorage.getItem('raid_alarm_scrap') || '1000'));
  
  // Daily Crate State
  const [lastClaimDate, setLastClaimDate] = useState(() => localStorage.getItem('skin_hub_daily') || '');
  const [canClaim, setCanClaim] = useState(isNewDay(localStorage.getItem('skin_hub_daily')));
  const [opening, setOpening] = useState(false);
  const [reward, setReward] = useState<number | null>(null);
  
  // UX State
  const [copiedId, setCopiedId] = useState<string | null>(null);

  // Sync Scrap
  useEffect(() => {
      localStorage.setItem('raid_alarm_scrap', scrapBalance.toString());
  }, [scrapBalance]);

  const handleClaimDaily = () => {
      if (!canClaim) return;
      setOpening(true);
      
      // Simulate Opening
      setTimeout(() => {
          const amount = Math.floor(Math.random() * 200) + 50; // Random 50-250 scrap
          setReward(amount);
          setScrapBalance(prev => prev + amount);
          
          const today = new Date().toDateString();
          localStorage.setItem('skin_hub_daily', today);
          setLastClaimDate(today);
          setCanClaim(false);
          setOpening(false);
      }, 2000);
  };

  const handlePartnerClick = (partner: typeof PARTNER_OFFERS[0]) => {
      // 1. Copy Code
      navigator.clipboard.writeText(partner.code);
      setCopiedId(partner.id);
      
      // 2. Visual Feedback
      setTimeout(() => {
          setCopiedId(null);
          // 3. Open Link
          window.open(partner.url, '_blank');
      }, 1000);
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative overflow-hidden font-sans">
      
      {/* 1. Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Skin Hub</h2>
                <div className="flex items-center gap-1.5 text-pink-500 text-xs font-mono uppercase tracking-wider">
                    <Gift className="w-3 h-3" /> Rewards & Codes
                </div>
            </div>
        </div>
        <div className="bg-zinc-900 px-3 py-1.5 rounded-full border border-zinc-800 flex items-center gap-2 shadow-inner">
            <span className="text-yellow-500 font-black font-mono text-sm">{scrapBalance}</span>
            <Coins className="w-3.5 h-3.5 text-yellow-600 fill-yellow-600" />
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6 space-y-8">
          
          {/* 2. Daily Crate */}
          <div className="bg-gradient-to-br from-purple-900/20 to-zinc-900 border border-purple-500/20 rounded-3xl p-6 relative overflow-hidden shadow-2xl">
              <div className="absolute top-0 right-0 p-4 opacity-10">
                  <Gift className="w-24 h-24 text-purple-500" />
              </div>
              
              <div className="relative z-10 text-center">
                  <h3 className="text-2xl font-black text-white uppercase mb-2 drop-shadow-md">Daily Supply Drop</h3>
                  <p className="text-[10px] text-purple-300 uppercase tracking-widest mb-4">In-App Scrap Reward</p>
                  
                  <div className="my-6 relative h-28 flex items-center justify-center">
                      {reward ? (
                          <div className="animate-in zoom-in duration-500 flex flex-col items-center">
                              <span className="text-4xl font-black text-yellow-400 drop-shadow-glow">+{reward}</span>
                              <span className="text-xs font-bold text-zinc-400 uppercase mt-2">Scrap Added</span>
                          </div>
                      ) : (
                          <div 
                            onClick={handleClaimDaily}
                            className={`cursor-pointer transition-all duration-300 ${canClaim ? 'hover:scale-105 active:scale-95' : 'opacity-50 grayscale cursor-not-allowed'}`}
                          >
                              <img 
                                src="https://rustlabs.com/img/items180/crate_elite.png" 
                                alt="Crate" 
                                className={`w-32 h-32 object-contain drop-shadow-2xl ${opening ? 'animate-bounce' : ''}`} 
                              />
                              {canClaim && (
                                  <div className="absolute inset-0 bg-purple-500/20 blur-xl rounded-full -z-10 animate-pulse" />
                              )}
                          </div>
                      )}
                  </div>

                  <button 
                    onClick={handleClaimDaily}
                    disabled={!canClaim || opening || reward !== null}
                    className={`w-full py-4 rounded-xl font-black uppercase text-sm shadow-lg transition-all
                        ${canClaim && !reward 
                            ? 'bg-purple-600 hover:bg-purple-500 text-white shadow-purple-900/40' 
                            : 'bg-zinc-800 text-zinc-500 border border-zinc-700'}
                    `}
                  >
                      {reward ? 'Claimed' : opening ? 'Opening...' : canClaim ? 'Open Free Crate' : 'Come Back Tomorrow'}
                  </button>
              </div>
          </div>

          {/* 3. PARTNER CODES (MONETIZATION) */}
          <div>
              <div className="flex items-center justify-between mb-3 px-1">
                  <div className="flex items-center gap-2">
                      <Ticket className="w-4 h-4 text-green-500" />
                      <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Free Promo Codes</span>
                  </div>
                  <span className="text-[9px] text-zinc-600 bg-zinc-900 px-2 py-0.5 rounded border border-zinc-800">
                      Sponsored
                  </span>
              </div>
              
              <div className="space-y-3">
                  {PARTNER_OFFERS.map((partner) => (
                      <button
                        key={partner.id}
                        onClick={() => handlePartnerClick(partner)}
                        className={`w-full flex items-center justify-between p-3 rounded-xl border transition-all active:scale-[0.98] group relative overflow-hidden ${partner.bgColor}`}
                      >
                          <div className="flex items-center gap-4 z-10">
                              <div className={`w-12 h-12 rounded-lg bg-black/40 flex items-center justify-center border border-white/10 shadow-lg ${partner.color}`}>
                                  {partner.id === 'skinport' ? <ShieldCheck className="w-6 h-6" /> : <DollarSign className="w-6 h-6" />}
                              </div>
                              <div className="text-left">
                                  <h4 className="text-white font-bold text-sm">{partner.name}</h4>
                                  <p className={`text-[10px] font-bold uppercase tracking-wide ${partner.color}`}>
                                      {partner.offer}
                                  </p>
                              </div>
                          </div>

                          <div className="flex flex-col items-end gap-1 z-10">
                              <div className="flex items-center gap-1.5 bg-black/40 px-2 py-1 rounded border border-white/5">
                                  <span className="text-xs font-mono font-bold text-white tracking-widest">{partner.code}</span>
                                  {copiedId === partner.id ? <CheckCircle2 className="w-3 h-3 text-green-500" /> : <Copy className="w-3 h-3 text-zinc-500" />}
                              </div>
                              <span className="text-[8px] text-zinc-500 font-mono">Tap to Copy</span>
                          </div>

                          {/* Hover Highlight */}
                          <div className="absolute inset-0 bg-white/5 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none" />
                      </button>
                  ))}
              </div>
          </div>

          {/* 4. Skin Showcase */}
          <div>
              <div className="flex items-center justify-between mb-3 px-1">
                  <div className="flex items-center gap-2">
                      <Star className="w-4 h-4 text-yellow-500" />
                      <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Trending Skins</span>
                  </div>
                  <span className="text-[10px] text-zinc-600">Market Price</span>
              </div>

              <div className="grid grid-cols-2 gap-3">
                  {FEATURED_SKINS.map((skin, i) => (
                      <div key={i} className="bg-[#121214] border border-zinc-800 rounded-xl overflow-hidden group">
                          <div className="aspect-square bg-[#1a1a1d] relative flex items-center justify-center p-4">
                              <div className="absolute inset-0 bg-gradient-to-tr from-white/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
                              <img src={skin.img} alt={skin.name} className="w-full h-full object-contain drop-shadow-xl group-hover:scale-110 transition-transform duration-500" />
                          </div>
                          <div className="p-3 bg-[#121214] border-t border-zinc-800 relative z-10">
                              <h4 className="text-sm font-bold text-white truncate">{skin.name}</h4>
                              <div className="flex justify-between items-center mt-1">
                                  <span className="text-[10px] text-zinc-500 uppercase">{skin.item}</span>
                                  <span className="text-xs font-mono font-black text-green-400">{skin.price}</span>
                              </div>
                          </div>
                      </div>
                  ))}
              </div>
          </div>

          {/* 5. Footer Disclaimer */}
          <div className="pt-4 border-t border-zinc-800/50 pb-8 text-center">
              <p className="text-[9px] text-zinc-600 leading-relaxed max-w-xs mx-auto">
                  Disclaimer: Promo codes and offers are provided by third-party partners. We are not responsible for transactions on external sites.
              </p>
          </div>

      </div>
    </div>
  );
};
