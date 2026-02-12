import React, { useState, useEffect } from 'react';
import { Button } from '../components/Button';
import { ScreenName } from '../types';
import { TYPOGRAPHY } from '../theme';
import { 
  ArrowRight, 
  User, 
  Moon,
  Zap,
  Radio,
  MoreHorizontal
} from 'lucide-react';

interface AlarmPreviewScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const AlarmPreviewScreen: React.FC<AlarmPreviewScreenProps> = ({ onNavigate }) => {
  const [sequenceStep, setSequenceStep] = useState(0); 
  const [buttonVisible, setButtonVisible] = useState(false);

  // 0: Initial (Offline)
  // 1: Notification: ONLINE
  // 2: State Update: List shows Online
  // 3: Notification: OFFLINE
  // 4: State Update: List shows Offline

  // Button Visibility Logic (Run once)
  useEffect(() => {
    const timer = setTimeout(() => setButtonVisible(true), 1000);
    return () => clearTimeout(timer);
  }, []);

  // Animation Loop Logic
  useEffect(() => {
    let mounted = true;
    
    const loopSequence = async () => {
        if (!mounted) return;
        
        // 0. Start
        setSequenceStep(0);
        await new Promise(r => setTimeout(r, 1000));
        if (!mounted) return;

        // 1. Show Notification (Target Online)
        setSequenceStep(1);
        await new Promise(r => setTimeout(r, 4000)); // Show notification for 4s
        if (!mounted) return;

        // 2. Hide Notification, keep status Online
        setSequenceStep(2);
        await new Promise(r => setTimeout(r, 2500));
        if (!mounted) return;

        // 3. Show Notification (Target Offline)
        setSequenceStep(3);
        await new Promise(r => setTimeout(r, 4000));
        if (!mounted) return;

        // 4. Hide Notification, status Offline
        setSequenceStep(4);
        await new Promise(r => setTimeout(r, 1500));
        if (!mounted) return;

        // Loop
        loopSequence();
    };

    loopSequence();
    return () => { mounted = false; };
  }, []);

  // Derived States
  const isOnlineNotification = sequenceStep === 1;
  const isOfflineNotification = sequenceStep === 3;
  const showNotification = isOnlineNotification || isOfflineNotification;
  
  // The target is "Online" during step 1 (notification) and step 2 (rest)
  const isTargetOnline = sequenceStep === 1 || sequenceStep === 2;

  // --- SUB-COMPONENTS ---

  const TargetCard = ({ name, status, time, isOnline }: { name: string, status: string, time: string, isOnline: boolean }) => (
      <div className={`flex items-center justify-between p-3.5 rounded-2xl border transition-all duration-500 relative overflow-hidden group
          ${isOnline 
            ? 'bg-red-950/30 border-red-500/50 shadow-[0_0_30px_rgba(220,38,38,0.1)]' 
            : 'bg-[#18181b] border-zinc-800'
          }
      `}>
          <div className="flex items-center gap-3 z-10 flex-1 min-w-0">
              <div className="relative shrink-0">
                  <div className={`w-10 h-10 rounded-full flex items-center justify-center border transition-colors duration-500
                      ${isOnline ? 'bg-red-900/20 border-red-500 text-red-500' : 'bg-zinc-800 border-zinc-700 text-zinc-500'}
                  `}>
                      <User className="w-5 h-5" />
                  </div>
                  {/* Online Dot */}
                  <div className={`absolute -bottom-0.5 -right-0.5 w-3 h-3 rounded-full border-2 border-[#121214] transition-colors duration-500
                      ${isOnline ? 'bg-green-500 shadow-[0_0_8px_#22c55e]' : 'bg-zinc-600'}
                  `} />
              </div>
              <div className="min-w-0 flex-1">
                  <div className={`text-sm font-bold leading-none transition-colors duration-500 mb-1 truncate ${isOnline ? 'text-white' : 'text-zinc-400'}`}>{name}</div>
                  <div className="flex items-center gap-1.5">
                      <span className={`text-[9px] font-mono uppercase font-bold px-1.5 py-0.5 rounded transition-colors duration-500 shrink-0
                          ${isOnline ? 'bg-red-500 text-white' : 'bg-zinc-800 text-zinc-500'}`}>
                          {status}
                      </span>
                      <span className="text-[9px] text-zinc-600 font-mono truncate">{time}</span>
                  </div>
              </div>
          </div>
      </div>
  );

  return (
    <div className="flex flex-col h-full bg-zinc-950 p-6 relative overflow-hidden">
      
      {/* Page Header (App Outside Phone) */}
      <div className="text-center mb-8 relative z-10 animate-in fade-in slide-in-from-top-4 duration-700">
        <span className="text-xs font-mono text-zinc-500 border border-zinc-800 px-2 py-1 rounded uppercase tracking-wider">
          Step 3
        </span>
        <h2 className={`text-3xl text-white mt-4 ${TYPOGRAPHY.rustFont}`}>
          Live Tracking
        </h2>
        <p className="text-zinc-400 text-sm mt-2">
          Real-time status updates for your enemies.
        </p>
      </div>

      {/* Main Content: Phone Mockup */}
      <div className="flex-1 flex items-center justify-center relative z-10">
          <div className="relative w-72 h-[520px] bg-black rounded-[3rem] border-8 border-zinc-900 shadow-2xl overflow-hidden flex flex-col">
              
              {/* Dynamic Island Area */}
              <div className="absolute top-0 left-1/2 -translate-x-1/2 w-28 h-7 bg-black rounded-b-2xl z-[60]" />

              {/* --- NOTIFICATION TOAST --- */}
              {/* Positioned absolute, z-index high, slides in/out */}
              <div className={`absolute left-4 right-4 z-50 transition-all duration-500 cubic-bezier(0.34, 1.56, 0.64, 1)
                  ${showNotification ? 'top-10 opacity-100 scale-100' : 'top-4 opacity-0 scale-95 pointer-events-none'}
              `}>
                  <div className={`bg-[#1c1c1e] border border-white/10 p-3 rounded-2xl shadow-2xl flex items-center gap-3 backdrop-blur-xl relative overflow-hidden`}>
                      
                      <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 
                          ${isOnlineNotification ? 'bg-red-600/20 text-red-500' : 'bg-zinc-800 text-zinc-400'}
                      `}>
                          {isOnlineNotification ? (
                              <Zap className="w-5 h-5 fill-current animate-pulse" />
                          ) : (
                              <Moon className="w-5 h-5 fill-current" />
                          )}
                      </div>
                      <div className="flex-1 min-w-0">
                          <div className="flex justify-between items-center mb-0.5">
                              <h4 className={`font-bold text-xs uppercase tracking-wide ${isOnlineNotification ? 'text-white' : 'text-zinc-400'}`}>
                                  {isOnlineNotification ? 'TARGET ONLINE' : 'TARGET OFFLINE'}
                              </h4>
                              <span className="text-[9px] text-zinc-500 font-mono">now</span>
                          </div>
                          <p className="text-zinc-300 text-[11px] leading-tight truncate">
                              <span className="font-bold text-white">ToxicNeighbor</span> {isOnlineNotification ? 'just woke up.' : 'has disconnected.'}
                          </p>
                      </div>
                  </div>
              </div>

              {/* --- PHONE APP CONTENT --- */}
              <div className="flex-1 bg-[#09090b] flex flex-col relative z-0">
                  
                  {/* App Header */}
                  <div className="px-6 pt-12 pb-6 border-b border-zinc-900 bg-[#09090b]">
                      <div className="flex justify-between items-center">
                          <div>
                              <h3 className="text-white font-black text-xl tracking-tight">Target Monitor</h3>
                              <div className="flex items-center gap-1.5 mt-1">
                                  <div className="w-1.5 h-1.5 bg-green-500 rounded-full animate-pulse" />
                                  <span className="text-zinc-500 text-[10px] font-mono uppercase tracking-wide">System Active</span>
                              </div>
                          </div>
                          <div className="w-8 h-8 rounded-full bg-zinc-900 flex items-center justify-center border border-zinc-800">
                              <Radio className="w-4 h-4 text-zinc-500" />
                          </div>
                      </div>
                  </div>

                  {/* Scrollable Content */}
                  <div className="flex-1 p-4 space-y-3 overflow-hidden">
                      
                      {/* Active Target */}
                      <TargetCard 
                          name="ToxicNeighbor" 
                          status={isTargetOnline ? 'ONLINE' : 'OFFLINE'} 
                          time={isTargetOnline ? 'Active Now' : 'Seen 5m ago'}
                          isOnline={isTargetOnline} 
                      />
                      
                      {/* Other Targets */}
                      <TargetCard 
                          name="RoofCamper" 
                          status="OFFLINE" 
                          time="Seen 4h ago"
                          isOnline={false} 
                      />
                      
                      {/* Removed "Showing 2/5 Targets" text */}

                  </div>
              </div>

          </div>
      </div>

      {/* Footer Action - STABLE (No flickering) */}
      <div className={`mt-8 transition-all duration-700 transform ${buttonVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'}`}>
        <Button onClick={() => onNavigate('SETUP_READY')}>
           Continue to Setup <ArrowRight className="w-4 h-4" />
        </Button>
      </div>

      {/* Background Ambience */}
      <div className="absolute inset-0 pointer-events-none bg-[radial-gradient(circle_at_center,_#27272a_0%,_#09090b_100%)] -z-10" />
    </div>
  );
};