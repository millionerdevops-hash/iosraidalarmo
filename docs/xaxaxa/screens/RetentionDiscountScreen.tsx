
import React, { useState, useEffect } from 'react';
import { Timer, Check, Shield, Zap, Crown, X } from 'lucide-react';
import { TYPOGRAPHY, EFFECTS } from '../theme';
import { ScreenName, PlanType } from '../types';

interface RetentionDiscountScreenProps {
  onNavigate: (screen: ScreenName) => void;
  onPurchase: (planId: PlanType) => void;
}

export const RetentionDiscountScreen: React.FC<RetentionDiscountScreenProps> = ({ onNavigate, onPurchase }) => {
  const [timeLeft, setTimeLeft] = useState(900); // 15 Minutes
  
  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft(prev => Math.max(0, prev - 1));
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const formatTime = (seconds: number) => {
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    return `${m < 10 ? '0' : ''}${m} : ${s < 10 ? '0' : ''}${s}`;
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] relative overflow-hidden font-sans">
      
      {/* Background Glows */}
      <div className="absolute top-[-20%] left-[-20%] w-[140%] h-[60%] bg-red-900/20 blur-[100px] pointer-events-none rounded-full" />
      <div className="absolute bottom-[-10%] right-[-10%] w-[100%] h-[40%] bg-orange-900/10 blur-[80px] pointer-events-none rounded-full" />

      {/* Header / Close */}
      <div className="relative z-20 px-6 pt-12 flex justify-between items-start">
          <button 
            onClick={() => onNavigate('DASHBOARD')}
            className="w-8 h-8 rounded-full bg-zinc-900/50 flex items-center justify-center text-zinc-500 hover:text-white transition-colors"
          >
              <X className="w-5 h-5" />
          </button>
      </div>

      <div className="flex-1 flex flex-col items-center px-6 relative z-10 -mt-4">
          
          {/* 1. TIMER & HEADER */}
          <div className="text-center mb-8">
              <h2 className="text-zinc-400 font-bold text-sm uppercase tracking-widest mb-2">One Time Offer</h2>
              <div className="flex items-center justify-center gap-3">
                  {/* Timer Boxes */}
                  <div className="bg-lime-400 text-black font-mono font-black text-xl px-3 py-2 rounded-lg shadow-[0_0_15px_rgba(163,230,53,0.4)]">
                      {formatTime(timeLeft).split(' : ')[0]}
                  </div>
                  <span className="text-zinc-600 font-black">:</span>
                  <div className="bg-lime-400 text-black font-mono font-black text-xl px-3 py-2 rounded-lg shadow-[0_0_15px_rgba(163,230,53,0.4)]">
                      {formatTime(timeLeft).split(' : ')[1]}
                  </div>
              </div>
              <p className="text-zinc-500 text-xs mt-3 font-medium">You will never see this again</p>
          </div>

          {/* 2. MAIN CARD */}
          <div className="w-full bg-[#18181b] border border-zinc-800 rounded-[32px] p-1 shadow-2xl relative overflow-visible">
               
               {/* Floating Discount Badge */}
               <div className="absolute -top-6 left-1/2 -translate-x-1/2 bg-gradient-to-r from-purple-600 to-indigo-600 text-white font-black text-lg px-6 py-2 rounded-full shadow-lg border-2 border-[#0c0c0e] z-20 whitespace-nowrap">
                   60% OFF
               </div>

               <div className="bg-[#121214] rounded-[28px] p-6 pb-8 overflow-hidden relative">
                   
                   {/* Background Glow inside card */}
                   <div className="absolute top-0 left-0 right-0 h-40 bg-gradient-to-b from-purple-900/20 to-transparent pointer-events-none" />

                   {/* VISUALS: 3 Feature Cards */}
                   <div className="flex justify-center items-end gap-3 mb-8 mt-4">
                       {/* Left Card */}
                       <div className="w-20 h-24 bg-zinc-800 rounded-xl border border-zinc-700 transform -rotate-6 translate-y-2 shadow-lg flex flex-col items-center justify-center opacity-80">
                           <Shield className="w-8 h-8 text-red-500 mb-2" />
                           <div className="h-1.5 w-12 bg-zinc-700 rounded-full" />
                           <div className="h-1.5 w-8 bg-zinc-700 rounded-full mt-1" />
                       </div>
                       
                       {/* Center Card (Main) */}
                       <div className="w-24 h-32 bg-zinc-800 rounded-xl border-2 border-purple-500 shadow-[0_0_30px_rgba(168,85,247,0.2)] flex flex-col items-center justify-center relative z-10">
                           <Crown className="w-10 h-10 text-yellow-400 mb-3 drop-shadow-md" />
                           <span className="text-[10px] font-black text-white uppercase tracking-wider">PREMIUM</span>
                           <div className="h-1 w-12 bg-zinc-700 rounded-full mt-2" />
                       </div>

                       {/* Right Card */}
                       <div className="w-20 h-24 bg-zinc-800 rounded-xl border border-zinc-700 transform rotate-6 translate-y-2 shadow-lg flex flex-col items-center justify-center opacity-80">
                           <Zap className="w-8 h-8 text-blue-400 mb-2" />
                           <div className="h-1.5 w-12 bg-zinc-700 rounded-full" />
                           <div className="h-1.5 w-8 bg-zinc-700 rounded-full mt-1" />
                       </div>
                   </div>

                   {/* TEXT CONTENT */}
                   <div className="text-center mb-6">
                       <h3 className="text-2xl font-bold text-white mb-1">Lifetime Access</h3>
                       <p className="text-zinc-500 text-xs px-4">
                           Unlock unlimited raid alerts, smart device control, and AI analysis forever.
                       </p>
                   </div>

                   {/* PRICING PILL */}
                   <div className="bg-black/40 rounded-xl p-3 border border-zinc-800 flex items-center justify-between mb-6">
                       <div className="flex flex-col items-start">
                           <span className="text-[10px] text-zinc-500 uppercase font-bold decoration-red-500 line-through">
                               $49.99
                           </span>
                           <span className="text-xs text-purple-400 font-bold">One-time payment</span>
                       </div>
                       <div className="text-right">
                           <span className="text-2xl font-black text-white font-mono tracking-tighter">$19.99</span>
                       </div>
                   </div>

                   {/* CTA BUTTON */}
                   <button 
                       onClick={() => onPurchase('CLAN')}
                       className="w-full py-4 bg-[#581c87] hover:bg-[#6b21a8] text-white font-black uppercase text-base rounded-xl shadow-[0_0_25px_rgba(147,51,234,0.4)] active:scale-[0.98] transition-all relative overflow-hidden group"
                   >
                       <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent translate-x-[-100%] group-hover:animate-[shimmer_1.5s_infinite]" />
                       Claim Offer Now
                   </button>
                   
                   <div className="text-center mt-3">
                        <span className="text-[10px] text-zinc-600 font-medium">No commitment - Secure Purchase</span>
                   </div>

               </div>
          </div>

          {/* 3. FOOTER LINK */}
          <div className="mt-auto pb-8">
              <button 
                  onClick={() => onNavigate('DASHBOARD')}
                  className="text-zinc-500 text-xs font-bold hover:text-white transition-colors border-b border-transparent hover:border-zinc-500 pb-0.5"
              >
                  No thanks, I'll pay full price
              </button>
          </div>

      </div>

    </div>
  );
};
