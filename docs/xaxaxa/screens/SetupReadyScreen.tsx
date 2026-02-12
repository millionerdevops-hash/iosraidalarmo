import React, { useState } from 'react';
import { Button } from '../components/Button';
import { ScreenName } from '../types';
import { TYPOGRAPHY } from '../theme';
import { 
  Download, 
  Link as LinkIcon, 
  BellRing, 
  AlertTriangle, 
  ShieldAlert, 
  Settings, 
  CheckCircle2, 
  BatteryWarning, 
  Clock, 
  Smartphone,
  Siren,
  ChevronRight,
  ShieldCheck,
  Zap,
  ArrowLeft
} from 'lucide-react';

interface SetupReadyScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// --- Helper Components Moved Outside ---

const StepHeader = ({ icon: Icon, title, subtitle }: { icon: any, title: string, subtitle?: string }) => (
  <div className="flex flex-col items-center text-center space-y-4 mb-6">
    <div className="w-20 h-20 bg-zinc-900 rounded-3xl flex items-center justify-center shadow-[0_0_30px_rgba(0,0,0,0.5)] border border-zinc-800 relative group">
      <div className="absolute inset-0 bg-gradient-to-tr from-white/5 to-transparent rounded-3xl" />
      <Icon className="w-10 h-10 text-white drop-shadow-md" />
    </div>
    <div>
      <h2 className={`text-2xl md:text-3xl text-white leading-tight mb-2 ${TYPOGRAPHY.rustFont}`}>{title}</h2>
      {subtitle && <p className="text-zinc-500 text-sm font-medium">{subtitle}</p>}
    </div>
  </div>
);

// Made children optional to fix TS error, though practically it's always passed
const ContentCard = ({ children, className = "" }: { children?: React.ReactNode, className?: string }) => (
  <div className={`w-full bg-[#121214] border border-white/5 p-5 rounded-2xl shadow-xl backdrop-blur-sm ${className}`}>
    {children}
  </div>
);

const ListItem = ({ number, text }: { number?: string, text: React.ReactNode }) => (
  <div className="flex items-start gap-3 p-3 bg-zinc-900/50 rounded-xl border border-zinc-800/50">
    {number && (
      <span className="flex items-center justify-center w-6 h-6 rounded-full bg-zinc-800 text-[10px] font-bold text-white shrink-0 border border-zinc-700">
        {number}
      </span>
    )}
    <div className="text-sm text-zinc-300 leading-relaxed">{text}</div>
  </div>
);

const BackButton = ({ onClick }: { onClick: () => void }) => (
  <button 
    onClick={onClick} 
    className="w-[56px] h-[56px] flex items-center justify-center bg-zinc-900 border border-zinc-800 text-zinc-400 hover:text-white hover:bg-zinc-800 transition-all active:scale-95 rounded-sm shrink-0"
  >
    <ArrowLeft className="w-6 h-6" />
  </button>
);

export const SetupReadyScreen: React.FC<SetupReadyScreenProps> = ({ onNavigate }) => {
  const [step, setStep] = useState(1);
  const totalSteps = 8;

  const nextStep = () => {
    if (step < totalSteps) {
      setStep(step + 1);
    } else {
      onNavigate('PAYWALL');
    }
  };

  const prevStep = () => {
    if (step > 1) {
      setStep(step - 1);
    }
  };

  const openPlayStore = () => {
    console.log("Opening Play Store...");
  };

  const renderContent = () => {
    switch (step) {
      /* 🟦 SLIDE 1: INSTALL */
      case 1:
        return (
          <>
            <div className="flex-1 flex flex-col justify-center animate-in fade-in slide-in-from-right-8 duration-500">
              <StepHeader icon={Download} title="Install Rust+" />
              
              <ContentCard className="space-y-4">
                 <div className="flex items-center justify-between px-2 pb-2 border-b border-white/5">
                    <div className="text-xs text-zinc-500 font-bold uppercase tracking-wider">How it works</div>
                    <Zap className="w-4 h-4 text-orange-500" />
                 </div>
                 <p className="text-zinc-300 text-sm leading-relaxed">
                   Raid Alarm works together with Rust+.
                 </p>
                 <div className="flex items-center gap-3 bg-black/40 p-3 rounded-lg border border-zinc-800">
                    <div className="w-1 h-8 bg-orange-500 rounded-full" />
                    <div className="text-xs">
                       <span className="text-white block font-bold">Rust+ sends the raid signal.</span>
                       <span className="text-zinc-400 block">Raid Alarm makes sure you hear it.</span>
                    </div>
                 </div>
                 <p className="text-zinc-400 text-xs">
                   If Rust+ is already installed, you can continue.
                 </p>
              </ContentCard>
            </div>
            
            <div className="space-y-3 pt-6">
              <Button onClick={openPlayStore}>
                Open Play Store → Install Rust+
              </Button>
              <button onClick={nextStep} className="w-full py-3 text-xs text-zinc-500 font-mono uppercase tracking-wider hover:text-white transition-colors">
                Rust+ is already installed → Continue
              </button>
            </div>
          </>
        );

      /* 🟦 SLIDE 2: CONNECT */
      case 2:
        return (
          <>
            <div className="flex-1 flex flex-col justify-center animate-in fade-in slide-in-from-right-8 duration-500">
              <StepHeader icon={LinkIcon} title="Connect Rust+" subtitle="Link your server to receive events" />
              
              <ContentCard className="space-y-3">
                <ListItem number="1" text="Open Rust+" />
                <ListItem number="2" text="Scan the pairing QR code in-game" />
                <ListItem number="3" text="Make sure your server is connected" />
              </ContentCard>
            </div>
            <div className="pt-6 flex gap-3 items-stretch">
              <BackButton onClick={prevStep} />
              <div className="flex-1">
                <Button onClick={nextStep} className="h-[56px]">I’ve Connected My Server</Button>
              </div>
            </div>
          </>
        );

      /* 🟦 SLIDE 3: NOTIFICATIONS */
      case 3:
        return (
          <>
            <div className="flex-1 flex flex-col justify-center animate-in fade-in slide-in-from-right-8 duration-500">
              <StepHeader icon={BellRing} title="Enable Notifications" />
              
              <p className="text-zinc-400 text-sm text-center mb-6 px-4">
                Make sure raid alerts can actually reach your phone.
              </p>

              <ContentCard className="space-y-3">
                {[
                  "Rust+ in-app notifications enabled",
                  "System notifications allowed",
                  "Notification sound turned ON",
                  "Do Not Disturb disabled"
                ].map((item, i) => (
                  <div key={i} className="flex items-center gap-3 p-3 bg-zinc-900/30 rounded-lg border border-zinc-800/30">
                     <div className="w-5 h-5 rounded-full bg-green-500/20 flex items-center justify-center border border-green-500/50 shrink-0">
                        <CheckCircle2 className="w-3 h-3 text-green-500" />
                     </div>
                     <span className="text-sm text-zinc-200">{item}</span>
                  </div>
                ))}
              </ContentCard>
            </div>
            <div className="pt-6 flex gap-3 items-stretch">
              <BackButton onClick={prevStep} />
              <div className="flex-1">
                <Button onClick={nextStep} className="h-[56px]">Check Notification Settings</Button>
              </div>
            </div>
          </>
        );

      /* 🟦 SLIDE 4: WARNING */
      case 4:
        return (
          <>
            <div className="flex-1 flex flex-col justify-center animate-in fade-in slide-in-from-right-8 duration-500">
              <div className="flex flex-col items-center text-center space-y-4 mb-6">
                 <div className="w-20 h-20 bg-red-950/30 rounded-3xl flex items-center justify-center shadow-[0_0_30px_rgba(220,38,38,0.2)] border border-red-900/50">
                    <AlertTriangle className="w-10 h-10 text-red-500 animate-pulse" />
                 </div>
                 <h2 className={`text-2xl md:text-3xl text-white leading-tight ${TYPOGRAPHY.rustFont}`}>
                   Why Rust+ Alone<br/><span className="text-red-500">Is Not Enough</span>
                 </h2>
              </div>

              <ContentCard className="bg-red-950/10 border-red-900/30">
                 <p className="text-zinc-400 text-sm mb-4 text-center">Rust+ does send notifications — but when:</p>
                 
                 <div className="space-y-2 mb-6">
                    <div className="bg-black/40 p-3 rounded border border-red-900/20 text-center text-sm text-red-200 font-medium">Your phone is on silent</div>
                    <div className="bg-black/40 p-3 rounded border border-red-900/20 text-center text-sm text-red-200 font-medium">You’re sleeping</div>
                    <div className="bg-black/40 p-3 rounded border border-red-900/20 text-center text-sm text-red-200 font-medium">Battery saver is active</div>
                 </div>

                 <div className="text-center space-y-2">
                    <p className="font-bold text-white text-lg">You never hear the first boom.</p>
                    <p className="text-red-400 text-xs px-2">Most offline raids succeed because alerts go unnoticed.</p>
                 </div>
              </ContentCard>
            </div>
            <div className="pt-6 flex gap-3 items-stretch">
              <BackButton onClick={prevStep} />
              <div className="flex-1">
                 <Button onClick={nextStep} variant="danger" className="h-[56px]">I’ve Missed Alerts Before</Button>
              </div>
            </div>
          </>
        );

      /* 🟦 SLIDE 5: UPGRADE */
      case 5:
        return (
          <>
             <div className="flex-1 flex flex-col justify-center animate-in fade-in slide-in-from-right-8 duration-500">
              <StepHeader icon={ShieldAlert} title="Raid Alarm Upgrades" subtitle="We listen to Rust+ events and convert them" />

              <div className="grid grid-cols-1 gap-3 w-full">
                  <div className="bg-zinc-900 border border-zinc-800 p-4 rounded-2xl flex items-center gap-4">
                     <div className="w-10 h-10 bg-red-600 rounded-lg flex items-center justify-center shadow-lg shadow-red-900/20">
                        <BellRing className="w-5 h-5 text-white" />
                     </div>
                     <span className="text-white font-bold">Loud alarms</span>
                  </div>

                  <div className="bg-zinc-900 border border-zinc-800 p-4 rounded-2xl flex items-center gap-4">
                     <div className="w-10 h-10 bg-green-600 rounded-lg flex items-center justify-center shadow-lg shadow-green-900/20">
                        <Smartphone className="w-5 h-5 text-white" />
                     </div>
                     <span className="text-white font-bold">Fake incoming calls</span>
                  </div>

                  <div className="bg-zinc-900 border border-zinc-800 p-4 rounded-2xl flex items-center gap-4">
                     <div className="w-10 h-10 bg-orange-600 rounded-lg flex items-center justify-center shadow-lg shadow-orange-900/20">
                        <Clock className="w-5 h-5 text-white" />
                     </div>
                     <span className="text-white font-bold text-sm">Repeating alerts</span>
                  </div>
              </div>

              <p className="text-center text-zinc-400 text-sm mt-6 leading-relaxed">
                 So when Rust+ sends the signal —<br/> <span className="text-white font-bold">you actually notice it.</span>
              </p>
            </div>
            <div className="pt-6 flex gap-3 items-stretch">
              <BackButton onClick={prevStep} />
              <div className="flex-1">
                 <Button onClick={nextStep} className="h-[56px]">Continue to Protection Setup</Button>
              </div>
            </div>
          </>
        );

      /* 🟦 SLIDE 6: PREPARE PERMISSIONS */
      case 6:
        return (
           <>
            <div className="flex-1 flex flex-col justify-center animate-in fade-in slide-in-from-right-8 duration-500">
              <StepHeader icon={Settings} title="Prepare Raid Alarm" />
              
              <ContentCard className="space-y-4">
                 <p className="text-zinc-300 text-sm">
                   To make sure you never miss a raid, Raid Alarm needs a few permissions to work properly.
                 </p>
                 <p className="text-zinc-500 text-xs uppercase font-bold tracking-wider">These allow us to:</p>
                 
                 <div className="space-y-2">
                    {['Trigger loud alarms', 'Simulate incoming calls', 'Override silent & battery restrictions'].map((txt, i) => (
                       <div key={i} className="flex items-center gap-3">
                          <div className="w-1.5 h-1.5 bg-orange-500 rounded-full" />
                          <span className="text-zinc-200 text-sm">{txt}</span>
                       </div>
                    ))}
                 </div>
                 
                 <div className="bg-yellow-950/20 p-3 rounded-lg border border-yellow-900/30 flex gap-3 items-start">
                    <AlertTriangle className="w-5 h-5 text-yellow-500 shrink-0" />
                    <p className="text-yellow-200 text-xs leading-tight">Without these, alerts may still be missed.</p>
                 </div>
              </ContentCard>
            </div>
            <div className="pt-6 flex gap-3 items-stretch">
              <BackButton onClick={prevStep} />
              <div className="flex-1">
                <Button onClick={nextStep} className="h-[56px]">Continue Setup</Button>
              </div>
            </div>
          </>
        );

      /* 🟦 SLIDE 7: GRANT PERMISSIONS */
      case 7:
        return (
          <>
            <div className="flex-1 flex flex-col justify-center animate-in fade-in slide-in-from-right-8 duration-500">
              <StepHeader icon={ShieldAlert} title="Grant Permissions" />
              
              <p className="text-center text-zinc-400 text-sm mb-6">Please allow the following permissions:</p>

              <div className="space-y-3 w-full">
                {[
                  { icon: BellRing, title: "Notifications", desc: "To play loud raid alarms" },
                  { icon: Smartphone, title: "Phone / Call access", desc: "To trigger fake incoming calls" },
                  { icon: BatteryWarning, title: "Ignore battery optimizations", desc: "To prevent alerts from being killed" },
                  { icon: Clock, title: "Run in background", desc: "To monitor Rust+ events at all times" }
                ].map((perm, idx) => (
                  <div key={idx} className="bg-zinc-900 border border-zinc-800 p-3 rounded-xl flex items-center gap-4">
                     <div className="w-10 h-10 rounded-full bg-zinc-800 flex items-center justify-center shrink-0">
                        <perm.icon className="w-5 h-5 text-zinc-400" />
                     </div>
                     <div>
                        <h4 className="text-white font-bold text-sm">{perm.title}</h4>
                        <p className="text-zinc-500 text-xs">{perm.desc}</p>
                     </div>
                  </div>
                ))}
              </div>
            </div>
            <div className="pt-6 flex gap-3 items-stretch">
              <BackButton onClick={prevStep} />
              <div className="flex-1">
                 <Button onClick={nextStep} className="h-[56px]">Allow Permissions</Button>
              </div>
            </div>
          </>
        );

      /* 🟦 SLIDE 8: COMPLETE */
      case 8:
        return (
          <>
            <div className="flex-1 flex flex-col justify-center animate-in fade-in slide-in-from-right-8 duration-500">
              <div className="flex flex-col items-center text-center space-y-6 mb-8">
                 <div className="w-24 h-24 bg-green-500/10 rounded-full flex items-center justify-center shadow-[0_0_50px_rgba(34,197,94,0.3)] border border-green-500/50 animate-pulse">
                   <ShieldCheck className="w-12 h-12 text-green-500" />
                 </div>
                 <h2 className={`text-4xl text-white ${TYPOGRAPHY.rustFont}`}>Setup Complete</h2>
                 <p className="text-zinc-400">You’re now fully protected.</p>
              </div>

              <ContentCard className="bg-gradient-to-b from-zinc-900 to-black border-zinc-800">
                 <div className="flex items-start gap-3">
                    <div className="w-8 h-8 rounded-full bg-red-600/20 flex items-center justify-center shrink-0">
                       <Siren className="w-4 h-4 text-red-500" />
                    </div>
                    <div>
                       <p className="text-zinc-400 text-xs uppercase tracking-wider font-bold mb-1">Protection Status</p>
                       <p className="text-white font-bold text-lg leading-tight">Raid Alarm will make sure you hear it.</p>
                       <p className="text-zinc-500 text-sm mt-1">Even if you’re sleeping or your phone is silent.</p>
                    </div>
                 </div>
              </ContentCard>
            </div>
            <div className="pt-6 flex gap-3 items-stretch">
              <BackButton onClick={prevStep} />
              <div className="flex-1">
                 <Button onClick={nextStep} className="h-[56px] shadow-[0_0_20px_rgba(220,38,38,0.4)]">
                   Continue to Protection
                 </Button>
              </div>
            </div>
          </>
        );

      default:
        return null;
    }
  };

  return (
    <div className="flex flex-col h-full bg-zinc-950 p-6 overflow-hidden relative">
      {/* Background Texture */}
      <div className="absolute inset-0 opacity-10 pointer-events-none bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')]" />
      
      {/* Step Indicator */}
      <div className="absolute top-0 left-0 right-0 p-6 z-10">
         <div className="flex justify-between items-center mb-2">
            <span className="text-[10px] font-mono text-zinc-500 font-bold tracking-widest uppercase">Configuration</span>
            <span className="text-[10px] font-mono text-zinc-500 font-bold">{step} / {totalSteps}</span>
         </div>
         <div className="flex gap-1 h-1 w-full">
            {Array.from({ length: totalSteps }).map((_, i) => (
               <div 
                  key={i} 
                  className={`h-full flex-1 rounded-full transition-colors duration-300 ${i < step ? 'bg-red-600' : 'bg-zinc-800'}`} 
               />
            ))}
         </div>
      </div>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col pt-8 relative z-10">
         {renderContent()}
      </div>
    </div>
  );
};