
import React, { useState } from 'react';
import { 
  BellRing, 
  Moon, 
  VolumeX, 
  AlertTriangle, 
  Smartphone,
  CheckCircle2,
  X,
  Bell
} from 'lucide-react';
import { TYPOGRAPHY, EFFECTS } from '../theme';
import { ScreenName } from '../types';
import { Button } from '../components/Button';

interface CriticalAlertPermissionScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const CriticalAlertPermissionScreen: React.FC<CriticalAlertPermissionScreenProps> = ({ onNavigate }) => {
  const [showSystemDialog, setShowSystemDialog] = useState(false);

  const handleRequest = () => {
      // Show the mock system dialog first
      setShowSystemDialog(true);
  };

  const handleSystemAllow = () => {
      setShowSystemDialog(false);
      onNavigate('SETUP_READY');
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] relative overflow-hidden font-sans">
      
      {/* 1. VISUAL AREA */}
      <div className="flex-1 flex flex-col items-center justify-center p-6 relative">
          
          {/* Central Graphic - BIGGER MOCKUP */}
          <div className="relative z-10 mb-10 mt-4">
              
              {/* Phone Frame */}
              <div className="w-52 h-[26rem] border-8 border-zinc-800 rounded-[3rem] bg-[#000000] relative flex flex-col items-center justify-center shadow-2xl overflow-hidden">
                  
                  {/* Screen Glow */}
                  <div className="absolute inset-0 bg-gradient-to-b from-red-900/20 to-transparent pointer-events-none" />

                  {/* Dynamic Island */}
                  <div className="absolute top-3 w-20 h-6 bg-black rounded-full z-20 border border-zinc-900/50" />
                  
                  {/* Silent Mode Indicator */}
                  <div className="absolute top-12 flex items-center justify-center gap-2 bg-zinc-800/80 backdrop-blur-md px-3 py-1.5 rounded-full border border-zinc-700/50">
                      <Moon className="w-3 h-3 text-red-400 fill-current" />
                      <span className="text-[10px] font-medium text-white">Do Not Disturb</span>
                  </div>

                  {/* Alarm Content - Slowed Down Bounce */}
                  <div className="flex flex-col items-center animate-[bounce_2s_infinite]">
                      <div className="w-20 h-20 bg-red-600 rounded-full flex items-center justify-center shadow-[0_0_30px_rgba(220,38,38,0.5)] mb-4">
                          <BellRing className="w-10 h-10 text-white fill-white" />
                      </div>
                      <span className="text-sm font-black text-white uppercase tracking-widest mb-1">RAID ALARM</span>
                      <span className="text-[10px] text-red-500 font-bold bg-red-950/50 px-2 py-0.5 rounded border border-red-900/50">CRITICAL ALERT</span>
                  </div>

                  {/* Volume Bar (Muted but breaking through) */}
                  <div className="absolute bottom-8 w-full px-6">
                      <div className="flex items-center gap-3 bg-zinc-900/90 backdrop-blur-md p-3 rounded-2xl border border-zinc-800 shadow-lg">
                          <VolumeX className="w-5 h-5 text-zinc-400" />
                          <div className="flex-1 h-1.5 bg-zinc-800 rounded-full overflow-hidden flex">
                              {/* The volume is technically '0' (gray) but Raid Alarm forces sound (Red bar indicating override) */}
                              <div className="w-full h-full bg-red-600 animate-pulse" />
                          </div>
                      </div>
                  </div>
              </div>

              {/* Bypass Badge - Scaled and Positioned */}
              <div className="absolute -bottom-5 -right-6 bg-white text-black px-4 py-2.5 rounded-xl border-4 border-[#0c0c0e] shadow-[0_10px_30px_rgba(0,0,0,0.5)] flex items-center gap-2 rotate-[-5deg] z-30">
                  <div className="bg-red-600 rounded-full p-1">
                      <AlertTriangle className="w-4 h-4 text-white fill-current" />
                  </div>
                  <div className="flex flex-col leading-none">
                      <span className="text-[10px] font-bold text-zinc-500 uppercase">System</span>
                      <span className="text-sm font-black uppercase">BYPASS</span>
                  </div>
              </div>
          </div>

          <h2 className={`text-3xl text-white text-center mb-4 ${TYPOGRAPHY.rustFont}`}>
              Override Silent Mode
          </h2>
          
          <p className="text-zinc-400 text-sm text-center leading-relaxed max-w-xs mb-8">
              Raid Alarm uses <strong className="text-white">Critical Alerts</strong> to play loud sounds even if your iPhone is muted or Do Not Disturb is on.
          </p>

          <div className="w-full max-w-xs bg-zinc-900/50 border border-zinc-800 rounded-2xl p-4 space-y-3">
              <div className="flex items-start gap-3">
                  <div className="p-1.5 bg-zinc-800 rounded-lg shrink-0">
                      <Moon className="w-4 h-4 text-zinc-400 fill-zinc-400" />
                  </div>
                  <div>
                      <h4 className="text-white text-xs font-bold">Focus Mode Bypass</h4>
                      <p className="text-[10px] text-zinc-500 leading-tight">Breaks through Sleep/DND filters.</p>
                  </div>
              </div>
              <div className="h-px bg-zinc-800/50 w-full" />
              <div className="flex items-start gap-3">
                  <div className="p-1.5 bg-zinc-800 rounded-lg shrink-0">
                      <VolumeX className="w-4 h-4 text-zinc-400" />
                  </div>
                  <div>
                      <h4 className="text-white text-xs font-bold">Mute Switch Bypass</h4>
                      <p className="text-[10px] text-zinc-500 leading-tight">Plays audio at 100% volume.</p>
                  </div>
              </div>
          </div>
      </div>

      {/* 2. ACTION AREA */}
      <div className="p-6 pb-10 bg-[#0c0c0e] border-t border-zinc-900 z-20">
          <Button 
            onClick={handleRequest}
            className={`w-full ${EFFECTS.glowRed}`}
          >
              Enable Critical Alerts
          </Button>
      </div>

      {/* --- MOCK IOS SYSTEM DIALOG --- */}
      {showSystemDialog && (
          <div className="absolute inset-0 z-50 bg-black/60 backdrop-blur-[2px] flex items-center justify-center p-8 animate-in fade-in duration-200">
              <div className="bg-[#252525]/95 backdrop-blur-xl w-full max-w-[270px] rounded-[14px] text-center overflow-hidden shadow-2xl animate-in zoom-in-95 duration-200 ring-1 ring-white/10">
                  <div className="p-5 pb-4">
                      <div className="flex justify-center mb-4">
                          <div className="w-12 h-12 bg-[#3a3a3c] rounded-[10px] flex items-center justify-center shadow-lg border border-white/5 relative overflow-hidden">
                              <div className="absolute inset-0 bg-gradient-to-br from-white/10 to-transparent" />
                              <BellRing className="w-7 h-7 text-red-500 fill-red-500" />
                          </div>
                      </div>
                      <h3 className="text-white font-bold text-[17px] leading-tight mb-2">
                          "Raid Alarm" Would Like to Send You Critical Alerts
                      </h3>
                      <p className="text-[13px] text-white leading-[1.3]">
                          Critical Alerts play a sound and appear on the Lock Screen even if your iPhone is muted or Do Not Disturb is on.
                      </p>
                  </div>
                  <div className="grid grid-cols-2 border-t border-white/15 divide-x divide-white/15">
                      <button 
                          onClick={() => setShowSystemDialog(false)}
                          className="py-3 text-[17px] text-[#0a84ff] active:bg-white/10 transition-colors"
                      >
                          Don't Allow
                      </button>
                      <button 
                          onClick={handleSystemAllow}
                          className="py-3 text-[17px] font-semibold text-[#0a84ff] active:bg-white/10 transition-colors"
                      >
                          Allow
                      </button>
                  </div>
              </div>
          </div>
      )}

    </div>
  );
};
