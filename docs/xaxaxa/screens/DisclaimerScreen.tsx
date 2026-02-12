
import React, { useState } from 'react';
import { ShieldAlert, AlertTriangle, CheckCircle2, XCircle, CheckSquare, Square } from 'lucide-react';
import { TYPOGRAPHY, EFFECTS } from '../theme';
import { ScreenName } from '../types';
import { Button } from '../components/Button';

interface DisclaimerScreenProps {
  onAccept: () => void;
}

export const DisclaimerScreen: React.FC<DisclaimerScreenProps> = ({ onAccept }) => {
  const [declined, setDeclined] = useState(false);
  const [isChecked, setIsChecked] = useState(false);

  // --- VIEW: DECLINED STATE ---
  if (declined) {
    return (
      <div className="flex flex-col h-full bg-[#0c0c0e] items-center justify-center p-8 text-center animate-in fade-in duration-300">
        <div className="w-24 h-24 bg-red-900/20 rounded-full flex items-center justify-center border-2 border-red-500/50 mb-6 shadow-[0_0_30px_rgba(220,38,38,0.2)]">
           <XCircle className="w-12 h-12 text-red-500" />
        </div>
        <h2 className={`text-3xl text-white mb-4 ${TYPOGRAPHY.rustFont}`}>Access Denied</h2>
        <p className="text-zinc-300 text-base leading-relaxed mb-8 max-w-xs mx-auto">
          To ensure transparency and compliance with Facepunch Studios' guidelines, you must accept the disclaimer to use this application.
        </p>
        <div className="w-full max-w-xs space-y-3">
            <Button onClick={() => setDeclined(false)} variant="primary">
              Read Again
            </Button>
        </div>
      </div>
    );
  }

  // --- VIEW: DISCLAIMER CONTENT ---
  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] relative font-sans">
      
      {/* Header (Fixed) */}
      <div className="p-6 pt-10 pb-4 bg-[#0c0c0e] border-b border-zinc-900 shadow-xl z-20 flex flex-col items-center shrink-0">
          <div className="w-12 h-12 bg-red-600 rounded-xl flex items-center justify-center shadow-lg shadow-red-900/40 mb-3">
              <ShieldAlert className="w-6 h-6 text-white" />
          </div>
          <h1 className={`text-xl text-center text-white ${TYPOGRAPHY.rustFont} tracking-wide`}>
             IMPORTANT DISCLAIMER
          </h1>
      </div>

      {/* Scrollable Content Area */}
      <div className="flex-1 overflow-y-auto p-6 space-y-8 pb-8">
          
          {/* Main Warning Box */}
          <div className="bg-[#18181b] border-2 border-red-500/40 rounded-2xl p-5 text-center shadow-lg relative overflow-hidden">
              <div className="absolute top-0 left-0 w-full h-1 bg-red-600" />
              <p className="text-white text-base font-medium leading-relaxed">
                  This application is <span className="text-red-500 font-black">UNOFFICIAL</span> and <span className="text-red-500 font-black">NOT AFFILIATED</span> with Facepunch Studios or Rust.
              </p>
          </div>

          {/* Key Information */}
          <section>
              <h3 className="text-zinc-500 text-xs font-bold uppercase tracking-widest mb-4 pl-1 border-l-2 border-zinc-700">Key Information</h3>
              <ul className="space-y-4 text-sm text-zinc-300">
                  <li className="flex gap-3">
                      <div className="w-1.5 h-1.5 rounded-full bg-zinc-500 mt-2 shrink-0" />
                      <span>This is a third-party application developed independently.</span>
                  </li>
                  <li className="flex gap-3">
                      <div className="w-1.5 h-1.5 rounded-full bg-zinc-500 mt-2 shrink-0" />
                      <span><strong>NOT</strong> created, endorsed, or supported by Facepunch Studios Ltd.</span>
                  </li>
                  <li className="flex gap-3">
                      <div className="w-1.5 h-1.5 rounded-full bg-zinc-500 mt-2 shrink-0" />
                      <span>Uses the publicly available Rust+ Companion API within permitted guidelines.</span>
                  </li>
                  <li className="flex gap-3">
                      <div className="w-1.5 h-1.5 rounded-full bg-zinc-500 mt-2 shrink-0" />
                      <span>"Rust" and "Rust+" are registered trademarks of Facepunch Studios Ltd.</span>
                  </li>
              </ul>
          </section>

          {/* Risks & Responsibilities */}
          <section>
              <h3 className="text-zinc-500 text-xs font-bold uppercase tracking-widest mb-4 pl-1 border-l-2 border-orange-700">Risks & Responsibilities</h3>
              <div className="bg-zinc-900/50 rounded-2xl p-5 border border-zinc-800 space-y-4">
                  <div className="flex gap-3 text-sm text-zinc-300">
                      <AlertTriangle className="w-5 h-5 text-orange-500 shrink-0 mt-0.5" />
                      <span>You use this app entirely at your own risk.</span>
                  </div>
                  <div className="flex gap-3 text-sm text-zinc-300">
                      <AlertTriangle className="w-5 h-5 text-orange-500 shrink-0 mt-0.5" />
                      <span>Facepunch Studios Ltd. has <strong>NO LIABILITY</strong> for this application or its usage.</span>
                  </div>
                  <div className="flex gap-3 text-sm text-zinc-300">
                      <AlertTriangle className="w-5 h-5 text-orange-500 shrink-0 mt-0.5" />
                      <span>The developer is <strong>NOT</strong> responsible for account actions, bans, or in-game consequences.</span>
                  </div>
              </div>
          </section>

          {/* Discontinuation Risk */}
          <div className="bg-red-950/20 border border-red-500/30 rounded-2xl p-5">
              <div className="flex items-center gap-2 mb-3">
                  <ShieldAlert className="w-5 h-5 text-red-500" />
                  <h3 className="text-red-500 font-bold text-sm uppercase">Service Availability</h3>
              </div>
              <p className="text-red-200/80 text-sm leading-relaxed mb-3">
                  This app may be discontinued at any time if:
              </p>
              <ul className="space-y-2 text-xs text-red-100/70 list-disc pl-5 leading-relaxed">
                  <li>Facepunch Studios requests feature removal or app takedown.</li>
                  <li>The Rust+ API is modified, restricted, or shut down.</li>
                  <li>Legal or technical circumstances change.</li>
              </ul>
              <p className="mt-3 text-xs font-bold text-red-200">
                  No refunds are guaranteed if the app is discontinued due to external factors.
              </p>
          </div>

          <div className="h-4" />
      </div>

      {/* Footer Actions (Fixed) */}
      <div className="p-6 bg-[#121214] border-t border-zinc-800 z-30 shadow-[0_-5px_20px_rgba(0,0,0,0.5)]">
          
          {/* Checkbox */}
          <button 
            onClick={() => setIsChecked(!isChecked)}
            className="flex items-start gap-4 mb-6 w-full text-left group"
          >
              <div className={`mt-0.5 transition-colors ${isChecked ? 'text-green-500' : 'text-zinc-600 group-hover:text-zinc-400'}`}>
                  {isChecked ? <CheckSquare className="w-6 h-6 fill-current bg-black" /> : <Square className="w-6 h-6" />}
              </div>
              <p className={`text-sm leading-tight transition-colors ${isChecked ? 'text-white' : 'text-zinc-400'}`}>
                  I have read, understood, and accept the disclaimer above and agree to the Terms of Service.
              </p>
          </button>

          {/* Buttons */}
          <div className="flex flex-col gap-3">
              <Button 
                onClick={onAccept}
                disabled={!isChecked}
                className={`w-full py-4 shadow-lg transition-all
                    ${isChecked 
                        ? 'bg-red-600 hover:bg-red-500 text-white shadow-red-900/40 opacity-100 transform scale-100' 
                        : 'bg-zinc-800 border-zinc-700 text-zinc-500 opacity-50 cursor-not-allowed'}
                `}
              >
                  I Accept & Continue
              </Button>
              
              <button 
                onClick={() => setDeclined(true)}
                className="w-full py-3 text-zinc-500 text-xs font-bold uppercase tracking-wider hover:text-white transition-colors"
              >
                  Decline
              </button>
          </div>
      </div>

    </div>
  );
};
