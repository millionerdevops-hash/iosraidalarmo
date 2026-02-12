import React, { useState, useEffect } from 'react';
import { Button } from '../components/Button';
import { ScreenName } from '../types';
import { TYPOGRAPHY } from '../theme';
import { ArrowRight, Smartphone, Phone, Siren, Wifi, Box } from 'lucide-react';

interface HowItWorksScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// --- INTERNAL COMPONENTS ---

// The Phone Shell (Shared Style with Step 3)
const PhoneShell = ({ children, borderColor = 'border-zinc-900' }: { children?: React.ReactNode, borderColor?: string }) => (
  <div className={`relative w-72 h-[460px] bg-black rounded-[3rem] border-8 ${borderColor} shadow-2xl overflow-hidden flex flex-col relative transition-colors duration-300`}>
      {/* Dynamic Island / Notch */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-7 bg-black rounded-b-2xl z-50" />
      {children}
  </div>
);

// The Internal Notification - Positioned below the clock for Lock Screen visibility
const InternalNotification = ({ visible, title, message, time = 'now' }: { visible: boolean, title: string, message: string, time?: string }) => (
  <div className={`absolute left-3 right-3 z-40 transition-all duration-500 ease-out
      ${visible ? 'top-[180px] opacity-100 scale-100' : 'top-[160px] opacity-0 scale-95'}
  `}>
      <div className="backdrop-blur-xl bg-zinc-800/90 border border-zinc-600/50 shadow-lg p-4 rounded-2xl flex flex-col gap-2">
          {/* Header */}
          <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                  <div className="bg-[#ce422b] rounded-md p-1 shadow-sm">
                      <Box className="text-white stroke-[2.5] w-3 h-3" />
                  </div>
                  <span className="font-semibold text-white/90 text-[10px] uppercase tracking-tight">RUST+</span>
              </div>
              <span className="text-white/50 font-medium text-[10px]">{time}</span>
          </div>
          {/* Body */}
          <div>
              <h4 className="font-bold text-white text-sm leading-tight mb-0.5">{title}</h4>
              <p className="text-zinc-200 text-xs leading-tight">{message}</p>
          </div>
      </div>
  </div>
);

// Wallpaper & Clock (Shared background)
const LockScreenContent = () => (
    <div className="absolute inset-0 bg-black">
      <div className="absolute inset-0 z-0 bg-black">
          <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_right,_#27272a_0%,_#000000_70%)] opacity-80" />
      </div>
      {/* Lock Screen Time */}
      <div className="relative z-10 flex flex-col items-center pt-16 text-white/90">
          <div className="text-7xl font-thin tracking-tighter leading-none text-zinc-100">03:42</div>
          <div className="text-lg font-medium mt-2 text-zinc-400">Tuesday, Oct 24</div>
      </div>
    </div>
);

export const HowItWorksScreen: React.FC<HowItWorksScreenProps> = ({ onNavigate }) => {
  // Demo Mode State: Toggle between ALARM and CALL
  const [demoMode, setDemoMode] = useState<'ALARM' | 'CALL'>('ALARM');
  
  // Animation State Loop
  // IDLE: Phone clean
  // NOTIFIED: Notification appears
  // ACTIVE: Alarm/Call screen takes over
  const [animState, setAnimState] = useState<'IDLE' | 'NOTIFIED' | 'ACTIVE'>('IDLE');

  // Animation Loop Logic
  useEffect(() => {
      let isMounted = true;
      
      const sequence = async () => {
        if (!isMounted) return;

        // 0. Start Hidden (IDLE) - Allows animation to reset
        setAnimState('IDLE');
        await new Promise(r => setTimeout(r, 800)); // Pause before start
        if (!isMounted) return;
        
        // 1. Show Notification (Slide Down)
        setAnimState('NOTIFIED');
        await new Promise(r => setTimeout(r, 2000)); // Wait while reading notification
        if (!isMounted) return;
        
        // 2. Trigger Alarm/Call (ACTIVE) -> Notification Hides
        setAnimState('ACTIVE');
        await new Promise(r => setTimeout(r, 3000)); // Wait while alarm rings
        if (!isMounted) return;
        
        // Loop
        sequence(); 
      };

      sequence();
      
      return () => { isMounted = false; };
  }, [demoMode]);

  return (
    <div className="flex flex-col h-full bg-zinc-950 relative overflow-hidden p-6">
       {/* Background noise texture */}
       <div className="absolute inset-0 opacity-20 pointer-events-none bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')]" />
       
       <div className="text-center mb-6 pt-4 relative z-10">
        {/* Main Title - Updated Order */}
        <h2 className={`text-3xl text-white ${TYPOGRAPHY.rustFont}`}>
          Rust+ Detects
        </h2>
        
        {/* Description */}
        <p className="text-zinc-400 text-sm mt-2">
          Rust+ detects the raid and sends the alert.
        </p>

        {/* Secondary Punchline */}
        <h3 className={`text-xl text-white mt-4 ${TYPOGRAPHY.rustFont}`}>
          We Take Control
        </h3>
      </div>

      {/* Toggle */}
      <div className="flex bg-zinc-900 p-1 rounded-lg border border-zinc-800 mb-6 relative z-10">
        <div 
           className={`absolute top-1 bottom-1 w-[calc(50%-4px)] bg-zinc-700 rounded transition-all duration-300 ${demoMode === 'ALARM' ? 'left-1' : 'left-[calc(50%+2px)]'}`} 
        />
        <button 
          onClick={() => setDemoMode('ALARM')}
          className={`flex-1 py-2 text-xs font-bold uppercase relative z-10 flex items-center justify-center gap-2 ${demoMode === 'ALARM' ? 'text-white' : 'text-zinc-500'}`}
        >
          <Siren className="w-4 h-4" /> Alarm Mode
        </button>
        <button 
          onClick={() => setDemoMode('CALL')}
          className={`flex-1 py-2 text-xs font-bold uppercase relative z-10 flex items-center justify-center gap-2 ${demoMode === 'CALL' ? 'text-white' : 'text-zinc-500'}`}
        >
          <Smartphone className="w-4 h-4" /> Fake Call
        </button>
      </div>

      {/* Dynamic Preview Container */}
      <div className="flex-1 flex items-center justify-center relative z-10">
        <PhoneShell borderColor={(animState === 'ACTIVE' && demoMode === 'ALARM') ? 'border-red-900' : 'border-zinc-900'}>
           
           {/* Layer 1: Base State (Wallpaper + Notification) */}
           <div className="absolute inset-0">
                <LockScreenContent />
                {/* Notification hides when Alarm/Call becomes ACTIVE */}
                <InternalNotification 
                    visible={animState === 'NOTIFIED'} 
                    title="Alarm"
                    message="Your base is under attack!"
                />
           </div>

           {/* Layer 2: ACTIVE STATE - ALARM OVERLAY */}
           <div className={`absolute inset-0 bg-[#450a0a] z-30 flex flex-col items-center justify-center gap-4 transition-all duration-300 ${demoMode === 'ALARM' && animState === 'ACTIVE' ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-full'}`}>
               <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_#dc2626_0%,_transparent_70%)] opacity-50 animate-pulse" />
               <Siren className="w-20 h-20 text-white animate-bounce relative z-10" />
               <div className="text-center relative z-10">
                   <h3 className={`text-4xl text-white ${TYPOGRAPHY.rustFont}`}>RAID<br/>ALARM</h3>
                   <div className="bg-red-600 text-white text-[10px] font-bold px-3 py-1 rounded-full mt-4 inline-block shadow-lg animate-pulse uppercase tracking-widest">
                      Activated
                   </div>
               </div>
           </div>

           {/* Layer 3: ACTIVE STATE - CALL OVERLAY */}
           <div className={`absolute inset-0 bg-black z-30 flex flex-col items-center justify-around py-12 transition-all duration-300 ${demoMode === 'CALL' && animState === 'ACTIVE' ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-full'}`}>
              <div className="flex flex-col items-center gap-2 pt-10">
                 <div className="w-20 h-20 rounded-full bg-zinc-800 flex items-center justify-center mb-2">
                    <Wifi className="w-10 h-10 text-zinc-500" />
                 </div>
                 <h3 className="text-3xl text-white font-normal">Rust Alert</h3>
                 <p className="text-zinc-500 text-sm">Mobile...</p>
              </div>
              
              <div className="flex w-full justify-around px-8 pb-8">
                 <div className="w-16 h-16 bg-red-600 rounded-full flex items-center justify-center">
                    <Phone className="w-8 h-8 text-white rotate-[135deg]" />
                 </div>
                 <div className="w-16 h-16 bg-green-500 rounded-full flex items-center justify-center animate-pulse shadow-[0_0_15px_rgba(34,197,94,0.5)]">
                    <Phone className="w-8 h-8 text-white" />
                 </div>
              </div>
           </div>

        </PhoneShell>
      </div>

      {/* Button */}
      <div className="mt-8 relative z-10">
        <Button onClick={() => onNavigate('ALARM_PREVIEW')}>
           Target Alerts <ArrowRight className="w-4 h-4" />
        </Button>
      </div>
    </div>
  );
};