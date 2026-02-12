
import React, { useState } from 'react';
import { TYPOGRAPHY } from '../theme';
import { PlanType } from '../types';
import { X, Check, Minus, Zap, Star, ShieldCheck } from 'lucide-react';

interface PaywallScreenProps {
  onPurchase: (planId: PlanType) => void;
  onSkip: () => void;
  onRestore: () => void;
  onPrivacyPolicy: () => void;
  onTerms: () => void;
}

export const PaywallScreen: React.FC<PaywallScreenProps> = ({ 
  onPurchase, 
  onSkip, 
  onRestore, 
  onPrivacyPolicy, 
  onTerms 
}) => {
  
  // Default to MONTHLY as requested
  const [selectedPlan, setSelectedPlan] = useState<'LIFETIME' | 'MONTHLY'>('MONTHLY');

  const FEATURES = [
      { name: "Alarm Mode", free: false, premium: true },
      { name: "Fake Call Mode", free: false, premium: true },
      { name: "Online/Offline Tracker", free: false, premium: true },
      { name: "No Ads", free: false, premium: true },
      { name: "Wipe Notification", free: true, premium: true },
      { name: "Tools", free: true, premium: true },
  ];

  return (
    <div className="relative flex flex-col h-full bg-[#0c0c0e] overflow-hidden font-sans">
      
      {/* Background Ambience */}
      <div className="absolute top-0 right-0 w-64 h-64 bg-red-600/10 blur-[100px] pointer-events-none rounded-full" />
      <div className="absolute bottom-0 left-0 w-64 h-64 bg-orange-600/5 blur-[80px] pointer-events-none rounded-full" />
      
      {/* Header (Close Only) */}
      <div className="p-6 pt-8 flex justify-between items-start shrink-0 z-20">
        <div className="pr-8">
            <h2 className={`text-2xl text-white leading-tight mb-2 ${TYPOGRAPHY.rustFont}`}>
              Choose your plan for <br/><span className="text-red-600">Total Domination</span>
            </h2>
        </div>
        <button 
          onClick={onSkip}
          className="w-8 h-8 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-500 hover:text-white transition-colors"
        >
          <X className="w-5 h-5" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar px-6 pb-6 z-10 flex flex-col">
        
        {/* --- COMPARISON TABLE --- */}
        <div className="mb-8">
            {/* Table Header */}
            <div className="grid grid-cols-[1fr_4rem_4rem] gap-2 mb-3 px-2 border-b border-zinc-800 pb-2">
                <div className="text-[10px] font-bold text-zinc-600 uppercase tracking-widest self-end">Features</div>
                <div className="text-xs font-black text-zinc-500 uppercase tracking-wider text-center">Free</div>
                <div className="text-xs font-black text-white uppercase tracking-wider text-center">Pro</div>
            </div>

            {/* Table Rows */}
            <div className="space-y-1 relative">
                {/* Premium Column Highlight Background */}
                <div className="absolute top-0 bottom-0 right-0 w-[4.5rem] bg-gradient-to-b from-red-900/10 to-red-900/5 rounded-xl border border-red-900/20 -z-10 translate-x-1" />

                {FEATURES.map((feat, idx) => (
                    <div key={idx} className="grid grid-cols-[1fr_4rem_4rem] gap-2 items-center py-3 border-b border-zinc-900/50 last:border-0">
                        <div className="text-sm font-medium text-zinc-300 pl-1">{feat.name}</div>
                        
                        <div className="flex justify-center">
                            {feat.free ? (
                                <Check className="w-4 h-4 text-zinc-500" />
                            ) : (
                                <Minus className="w-3 h-3 text-zinc-800" />
                            )}
                        </div>

                        <div className="flex justify-center">
                            {feat.premium && (
                                <div className="bg-red-600 rounded-full p-0.5 shadow-lg shadow-red-900/50">
                                    <Check className="w-3 h-3 text-white stroke-[3]" />
                                </div>
                            )}
                        </div>
                    </div>
                ))}
            </div>
        </div>

        {/* --- PLAN SELECTION --- */}
        <div className="space-y-4 mb-4">
            
            {/* LIFETIME PLAN */}
            <button
                onClick={() => setSelectedPlan('LIFETIME')}
                className={`w-full relative p-4 rounded-2xl border-2 text-left transition-all active:scale-[0.98] group flex items-center
                    ${selectedPlan === 'LIFETIME' 
                        ? 'bg-red-900/10 border-red-600 shadow-[0_0_30px_rgba(220,38,38,0.15)]' 
                        : 'bg-zinc-900/50 border-zinc-800 opacity-80'}
                `}
            >
                {/* Checkbox */}
                <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center shrink-0 mr-4 transition-colors
                    ${selectedPlan === 'LIFETIME' ? 'border-red-600 bg-red-600' : 'border-zinc-600'}
                `}>
                    {selectedPlan === 'LIFETIME' && <Check className="w-3 h-3 text-white" />}
                </div>

                {/* Content */}
                <div className="flex-1">
                    <div className="flex items-center justify-between mb-0.5">
                        <span className="block text-base font-black text-white uppercase tracking-wide">Lifetime Access</span>
                        <span className="block text-xl font-black text-white">$49.99</span>
                    </div>
                    <span className="block text-xs text-zinc-400 font-medium">One-time payment. Own it forever.</span>
                </div>

                {/* Badge */}
                <div className="absolute -top-3 right-4 bg-gradient-to-r from-zinc-700 to-zinc-600 text-white text-[10px] font-black uppercase px-3 py-1 rounded-full shadow-lg border border-zinc-500">
                    One-Time
                </div>
            </button>

            {/* MONTHLY PLAN */}
            <button
                onClick={() => setSelectedPlan('MONTHLY')}
                className={`w-full relative p-4 rounded-2xl border-2 text-left transition-all active:scale-[0.98] group flex items-center
                    ${selectedPlan === 'MONTHLY' 
                        ? 'bg-red-900/10 border-red-600 shadow-[0_0_30px_rgba(220,38,38,0.15)]' 
                        : 'bg-zinc-900/50 border-zinc-800 opacity-80'}
                `}
            >
                {/* Checkbox */}
                <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center shrink-0 mr-4 transition-colors
                    ${selectedPlan === 'MONTHLY' ? 'border-red-600 bg-red-600' : 'border-zinc-600'}
                `}>
                    {selectedPlan === 'MONTHLY' && <Check className="w-3 h-3 text-white" />}
                </div>

                {/* Content */}
                <div className="flex-1">
                    <div className="flex items-center justify-between mb-0.5">
                        <span className="block text-base font-bold text-white uppercase tracking-wide">Monthly Plan</span>
                        <span className="block text-lg font-bold text-white">$9.99<span className="text-xs text-zinc-500 font-medium ml-1">/mo</span></span>
                    </div>
                    <span className="block text-xs text-orange-400 font-bold uppercase tracking-wider">
                        Includes 5-Day Free Trial
                    </span>
                </div>

                {/* Badge */}
                <div className="absolute -top-3 right-4 bg-gradient-to-r from-red-600 to-orange-600 text-white text-[10px] font-black uppercase px-3 py-1 rounded-full shadow-lg border border-red-400">
                    Best Value
                </div>
            </button>

        </div>

      </div>

      {/* --- FOOTER ACTION --- */}
      <div className="p-6 pt-4 bg-gradient-to-t from-[#0c0c0e] via-[#0c0c0e] to-transparent z-20">
          
          <button 
            onClick={() => onPurchase(selectedPlan === 'LIFETIME' ? 'CLAN' : 'SOLO')} // Mapping for logic
            className="w-full py-4 bg-red-600 hover:bg-red-500 text-white font-black uppercase text-base rounded-2xl shadow-lg shadow-red-900/40 transition-all active:scale-[0.98] mb-4 flex items-center justify-center gap-2"
          >
              {selectedPlan === 'MONTHLY' ? (
                  <>
                    <Zap className="w-5 h-5 fill-white" /> Start 5-Day Free Trial
                  </>
              ) : (
                  <>
                    <Star className="w-5 h-5 fill-white" /> Unlock Forever
                  </>
              )}
          </button>
          
          <p className="text-center text-[10px] text-zinc-600 font-medium mb-4">
              {selectedPlan === 'MONTHLY' 
                ? "You won't be charged until the trial ends. Cancel anytime." 
                : "One-time purchase. Includes all future updates."}
          </p>

          <div className="flex justify-center items-center gap-6 border-t border-zinc-900 pt-4">
            <button onClick={onPrivacyPolicy} className="text-[10px] text-zinc-500 uppercase font-bold hover:text-zinc-300">Privacy</button>
            <button onClick={onRestore} className="text-[10px] text-zinc-500 uppercase font-bold hover:text-zinc-300">Restore</button>
            <button onClick={onTerms} className="text-[10px] text-zinc-500 uppercase font-bold hover:text-zinc-300">Terms</button>
          </div>
      </div>

    </div>
  );
};
