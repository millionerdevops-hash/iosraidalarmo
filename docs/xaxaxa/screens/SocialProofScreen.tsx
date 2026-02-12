
import React from 'react';
import { 
  ArrowLeft, 
  Star, 
  ShieldCheck, 
  User, 
  Quote
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { Button } from '../components/Button';

interface SocialProofScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

const REVIEWS = [
    {
        id: 1,
        name: 'Toxic_Chad_99',
        role: '@clan_leader',
        text: "Honestly the only reason our main loot room survived last wipe. The fake call feature woke me up at 4 AM when they breached compound. Secured the defense.",
        avatarColor: 'bg-red-600'
    },
    {
        id: 2,
        name: 'SoloSurvivor',
        role: '@lone_wolf',
        text: "For a solo player, this is mandatory. I can finally sleep without anxiety. The MLRS calculator is also dead accurate. Worth every scrap.",
        avatarColor: 'bg-blue-600'
    },
    {
        id: 3,
        name: 'RustAcademy_Fan',
        role: '@builder_main',
        text: "I used to miss Rust+ notifications all the time because my phone was on silent. The alarm override actually works. 10/10 app.",
        avatarColor: 'bg-green-600'
    },
    {
        id: 4,
        name: 'Zerg_Hunter',
        role: '@pvp_god',
        text: "Good app. The recoil trainer helps for warmup. Worth the lifetime sub just for the peace of mind during off-hours.",
        avatarColor: 'bg-orange-600'
    }
];

export const SocialProofScreen: React.FC<SocialProofScreenProps> = ({ onNavigate }) => {
  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] relative overflow-hidden font-sans">
      
      {/* 1. Background Ambience */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full h-80 bg-red-900/20 blur-[100px] pointer-events-none rounded-full" />

      {/* 2. Floating Back Button (No Header) */}
      <div className="absolute top-6 left-4 z-30">
          <button 
              onClick={() => onNavigate('SETTINGS')}
              className="w-10 h-10 rounded-full bg-zinc-900/50 backdrop-blur-md border border-white/10 flex items-center justify-center text-zinc-400 hover:text-white transition-all active:scale-95"
          >
              <ArrowLeft className="w-5 h-5" />
          </button>
      </div>

      {/* 3. Main Scrollable Content */}
      <div className="flex-1 overflow-y-auto no-scrollbar pt-20 px-6 pb-32 relative z-10">
          
          {/* HERO SECTION */}
          <div className="flex flex-col items-center text-center mb-10">
              <h1 className={`text-3xl text-white mb-4 ${TYPOGRAPHY.rustFont} tracking-wide drop-shadow-lg`}>
                  Top Rated Defense
              </h1>
              
              {/* Stars */}
              <div className="flex gap-2 mb-6">
                  {[1, 2, 3, 4, 5].map((s) => (
                      <Star key={s} className="w-8 h-8 text-yellow-500 fill-yellow-500 drop-shadow-md" />
                  ))}
              </div>

              <p className="text-zinc-400 text-sm font-medium max-w-[280px] leading-relaxed">
                  This tool was designed for survivors like you who value their sleep and their loot.
              </p>

              {/* Avatar Stack + Count */}
              <div className="flex items-center justify-center mt-6">
                  <div className="flex -space-x-3">
                      <div className="w-10 h-10 rounded-full border-2 border-[#0c0c0e] bg-zinc-800 flex items-center justify-center"><User className="w-5 h-5 text-zinc-500" /></div>
                      <div className="w-10 h-10 rounded-full border-2 border-[#0c0c0e] bg-zinc-700 flex items-center justify-center"><User className="w-5 h-5 text-zinc-400" /></div>
                      <div className="w-10 h-10 rounded-full border-2 border-[#0c0c0e] bg-zinc-600 flex items-center justify-center"><User className="w-5 h-5 text-zinc-300" /></div>
                  </div>
                  <div className="ml-4 text-left">
                      <span className="block text-white font-black text-sm">45,000+</span>
                      <span className="block text-zinc-500 text-[10px] font-bold uppercase tracking-wider">Active Raiders</span>
                  </div>
              </div>
          </div>

          {/* REVIEWS LIST */}
          <div className="space-y-4">
              {REVIEWS.map((review) => (
                  <div 
                    key={review.id}
                    className="bg-[#18181b] border border-zinc-800 p-5 rounded-3xl relative shadow-lg"
                  >
                      <div className="flex justify-between items-start mb-3">
                          <div className="flex items-center gap-3">
                              {/* Avatar */}
                              <div className={`w-10 h-10 rounded-full flex items-center justify-center text-white font-bold text-sm ${review.avatarColor} shadow-inner border border-white/10`}>
                                  {review.name.charAt(0)}
                              </div>
                              <div className="text-left">
                                  <div className="text-white font-bold text-sm">{review.name}</div>
                                  <div className="text-zinc-500 text-[10px] font-mono">{review.role}</div>
                              </div>
                          </div>
                          {/* 5 Stars Small */}
                          <div className="flex gap-0.5">
                              {[1, 2, 3, 4, 5].map((s) => (
                                  <Star key={s} className="w-3 h-3 text-yellow-500 fill-yellow-500" />
                              ))}
                          </div>
                      </div>
                      
                      <p className="text-zinc-300 text-xs leading-relaxed font-medium">
                          "{review.text}"
                      </p>
                  </div>
              ))}
          </div>

          {/* Trust Badge at bottom of scroll */}
          <div className="mt-8 flex flex-col items-center justify-center gap-2 opacity-50">
              <ShieldCheck className="w-8 h-8 text-zinc-600" />
              <span className="text-[10px] text-zinc-600 uppercase font-bold tracking-widest">Official Rust+ Compatible</span>
          </div>

      </div>

      {/* 4. Sticky Footer Button */}
      <div className="absolute bottom-0 left-0 right-0 p-6 bg-gradient-to-t from-[#0c0c0e] via-[#0c0c0e] to-transparent z-20 pt-12">
          <Button 
            onClick={() => onNavigate('PAYWALL')} 
            className="w-full py-4 bg-white text-black font-black uppercase rounded-full shadow-[0_0_30px_rgba(255,255,255,0.2)] hover:bg-zinc-200 active:scale-95 transition-all text-sm tracking-widest border-none"
          >
              Join the Squad
          </Button>
      </div>

    </div>
  );
};
