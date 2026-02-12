import React, { useEffect, useMemo, useState } from 'react';
import { Button } from '../components/Button';
import { TYPOGRAPHY, EFFECTS } from '../theme';
import { ScreenName } from '../types';

interface RiskAnalysisScreenProps {
  onNavigate: (screen: ScreenName) => void;
  onboardingData: Record<number, string>;
}

export const RiskAnalysisScreen: React.FC<RiskAnalysisScreenProps> = ({ onNavigate, onboardingData }) => {
  
  // State for animation
  const [displayPercentage, setDisplayPercentage] = useState(0);
  const [isComplete, setIsComplete] = useState(false);

  // Simulation Logic: Generate scary but realistic looking stats based on "analysis"
  const stats = useMemo(() => {
    const randomTimeStart = Math.floor(Math.random() * 5) + 1; // 1 to 5
    const randomTimeEnd = randomTimeStart + 4;
    
    // Simulate probability between 78% and 99%
    const prob = Math.floor(Math.random() * (99 - 78 + 1)) + 78;

    return {
      threatLevel: 'EXTREME', // Always keep this high for the app's purpose
      vulnerableTime: `0${randomTimeStart}:00 - 0${randomTimeEnd}:00`,
      wipeRisk: 'CRITICAL',
      raidProbability: prob // Keeping as number for calculation
    };
  }, []);

  // Animation Effect
  useEffect(() => {
    let animationFrameId: number;
    const duration = 2000; // 2 seconds to calculate
    const startTime = performance.now();

    const animate = (time: number) => {
      const elapsed = time - startTime;
      const progress = Math.min(elapsed / duration, 1);
      
      // Ease out quart for a satisfying "landing" effect
      const ease = 1 - Math.pow(1 - progress, 4);
      
      const currentVal = Math.floor(ease * stats.raidProbability);
      setDisplayPercentage(currentVal);

      if (progress < 1) {
        animationFrameId = requestAnimationFrame(animate);
      } else {
        setIsComplete(true);
      }
    };

    animationFrameId = requestAnimationFrame(animate);

    return () => cancelAnimationFrame(animationFrameId);
  }, [stats.raidProbability]);

  // SVG Calculations
  const radius = 120;
  const circumference = 754; // Approx 2 * pi * 120
  // strokeDashoffset: 754 = empty, 0 = full. 
  const strokeDashoffset = circumference - (displayPercentage / 100) * circumference;

  return (
    <div className="flex flex-col h-full bg-zinc-950 p-6 items-center justify-center relative overflow-hidden">
      {/* Background Decor */}
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_transparent_0%,_#09090b_80%)] z-10 pointer-events-none" />
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-red-900/10 rounded-full blur-3xl pointer-events-none" />

      {/* Main Content Grouped */}
      <div className="relative z-20 w-full max-w-xs flex flex-col gap-6">
        
        {/* Circle Chart Container */}
        <div className="relative w-64 h-64 mx-auto flex items-center justify-center">
          {/* Tech Circles - Outer Rings */}
          <div className="absolute inset-0 border border-zinc-800/60 rounded-full animate-[spin_10s_linear_infinite]" />
          <div className="absolute inset-4 border border-zinc-800/30 border-dashed rounded-full animate-[spin_15s_linear_infinite_reverse]" />
          
          {/* Main SVG Chart */}
          <svg 
            className="w-full h-full rotate-[-90deg] relative z-10 drop-shadow-[0_0_15px_rgba(220,38,38,0.3)] overflow-visible"
            viewBox="0 0 288 288"
          >
            {/* Background Track */}
            <circle cx="144" cy="144" r="120" className="stroke-zinc-900" strokeWidth="12" fill="none" />
            {/* Red Progress Line */}
            <circle 
              cx="144" cy="144" r="120" 
              className="stroke-red-600 transition-all duration-100 ease-linear" 
              strokeWidth="12" fill="none" 
              strokeDasharray={circumference}
              strokeDashoffset={strokeDashoffset} 
              strokeLinecap="round"
            />
          </svg>

          {/* Center Text */}
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <span className={`text-6xl text-white ${TYPOGRAPHY.rustFont} tabular-nums tracking-tighter`}>
              {displayPercentage}<span className="text-4xl align-top">%</span>
            </span>
            <span className={`font-mono text-[10px] font-bold uppercase tracking-widest px-2 py-1 rounded mt-2 border transition-all duration-300 ${isComplete ? 'text-red-500 bg-red-950/50 border-red-900/30 animate-pulse' : 'text-zinc-500 border-transparent'}`}>
              {isComplete ? 'DANGER DETECTED' : 'ANALYZING...'}
            </span>
          </div>
        </div>

        {/* Stats Grid - Fades in AFTER calculation */}
        <div className={`space-y-3 font-mono text-sm transition-all duration-1000 transform ${isComplete ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
           {/* Stat 1 */}
           <div className="flex justify-between items-center bg-zinc-900/80 p-4 border-l-2 border-red-600 backdrop-blur-sm shadow-lg">
             <span className="text-zinc-500 text-xs tracking-wider">THREAT LEVEL</span>
             <span className="text-red-500 font-bold animate-pulse">{stats.threatLevel}</span>
           </div>
           
           {/* Stat 2 */}
           <div className="flex justify-between items-center bg-zinc-900/80 p-4 border-l-2 border-orange-600 backdrop-blur-sm shadow-lg">
             <span className="text-zinc-500 text-xs tracking-wider">VULNERABLE TIME</span>
             <span className="text-white font-bold">{stats.vulnerableTime}</span>
           </div>
           
           {/* Stat 3 */}
           <div className="flex justify-between items-center bg-zinc-900/80 p-4 border-l-2 border-yellow-500 backdrop-blur-sm shadow-lg">
             <span className="text-zinc-500 text-xs tracking-wider">WIPE RISK</span>
             <span className="text-white font-bold">{stats.wipeRisk}</span>
           </div>

           {/* Stat 4 */}
           <div className="flex justify-between items-center bg-zinc-900/80 p-4 border-l-2 border-zinc-500 backdrop-blur-sm shadow-lg">
             <span className="text-zinc-500 text-xs tracking-wider">RAID PROBABILITY</span>
             <span className="text-red-400 font-bold">{stats.raidProbability}%</span>
           </div>
        </div>

        {/* Loading / Action Section */}
        <div className="min-h-[60px] flex flex-col justify-center">
            {!isComplete ? (
              <div className="text-center space-y-2">
                  <p className="text-zinc-600 font-mono text-[10px] uppercase tracking-[0.2em] animate-pulse">
                  CALCULATING SURVIVAL ODDS...
                  </p>
                  <div className="w-16 h-0.5 bg-red-900/50 mx-auto rounded-full overflow-hidden">
                      <div className="h-full bg-red-500 w-full animate-[translateX_1s_ease-in-out_infinite]" />
                  </div>
              </div>
            ) : (
              <div className="animate-in fade-in slide-in-from-bottom-4 duration-700">
                <Button onClick={() => onNavigate('HOW_IT_WORKS')} className={EFFECTS.glowRed}>
                  VIEW SOLUTION
                </Button>
              </div>
            )}
        </div>

      </div>
    </div>
  );
};