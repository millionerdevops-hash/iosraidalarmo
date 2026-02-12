
import React, { useState, useEffect } from 'react';
import { Button } from '../components/Button';
import { ScreenName } from '../types';
import { TYPOGRAPHY, EFFECTS } from '../theme';

interface GetStartedScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

const SLIDES = [
  {
    l1: "DETECT",
    l2: "OFFLINE",
    l3: "PLAYERS.",
  },
  {
    l1: "TURN RUST+",
    l2: "ALERTS INTO",
    l3: "ALARMS.",
  }
];

export const GetStartedScreen: React.FC<GetStartedScreenProps> = ({ onNavigate }) => {
  const [index, setIndex] = useState(0);
  const [animating, setAnimating] = useState(true);
  const [showButton, setShowButton] = useState(false);

  // Text Rotation Interval
  useEffect(() => {
    const interval = setInterval(() => {
        setAnimating(false); // Start exit animation
        setTimeout(() => {
            setIndex((prev) => (prev + 1) % SLIDES.length);
            setAnimating(true); // Start enter animation
        }, 600); // Wait for exit to finish
    }, 4000); // Change every 4 seconds

    return () => clearInterval(interval);
  }, []);

  // Button Appearance Delay
  useEffect(() => {
      // Show button after the first slide finishes and the second one starts (approx 4.2s)
      const timer = setTimeout(() => {
          setShowButton(true);
      }, 4200);
      return () => clearTimeout(timer);
  }, []);

  const slide = SLIDES[index];

  // Helper to adjust font size for long words
  const getFontSize = (text: string) => {
      if (text.length > 12) return "text-4xl"; 
      if (text.length > 8) return "text-6xl";
      return "text-7xl";
  };

  return (
    <div className="flex flex-col flex-1 h-full bg-zinc-950 relative overflow-hidden">
      <style>{`
        @keyframes slideIn {
          from { opacity: 0; transform: translateY(20px); filter: blur(10px); }
          to { opacity: 1; transform: translateY(0); filter: blur(0); }
        }
        @keyframes slideOut {
          from { opacity: 1; transform: translateY(0); filter: blur(0); }
          to { opacity: 0; transform: translateY(-20px); filter: blur(10px); }
        }
        @keyframes impactScale {
          0% { opacity: 0; transform: scale(2); filter: blur(20px); }
          100% { opacity: 1; transform: scale(1); filter: blur(0); }
        }
        @keyframes expandLine {
          from { width: 0; opacity: 0; }
          to { width: 6rem; opacity: 1; }
        }
        @keyframes fadeInButton {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
        
        .enter-1 { animation: slideIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .enter-2 { animation: slideIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) 0.1s forwards; }
        .enter-3 { animation: impactScale 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) 0.2s forwards; }
        
        .exit-1 { animation: slideOut 0.4s ease-in forwards; }
        .exit-2 { animation: slideOut 0.4s ease-in 0.1s forwards; }
        .exit-3 { animation: slideOut 0.4s ease-in 0.2s forwards; }

        .anim-line { animation: expandLine 0.8s ease-out 0.6s forwards; }
        .btn-enter { animation: fadeInButton 0.8s ease-out forwards; }
      `}</style>

      {/* Background Image Container */}
      <div className="absolute inset-0 z-0">
        <img 
          src="https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2670&auto=format&fit=crop" 
          alt="Rust landscape" 
          className="w-full h-full object-cover opacity-60 grayscale contrast-125"
        />
        {/* Gradient for text readability */}
        <div className="absolute inset-0 bg-gradient-to-t from-black via-black/20 to-black/40" />
      </div>

      <div className="relative z-10 flex flex-col h-full px-6 py-8">
        
        {/* Title Section - Centered Vertically */}
        <div className="flex-1 flex flex-col justify-center">
          <div className={`text-white leading-[0.9] drop-shadow-[0_4px_4px_rgba(0,0,0,0.5)] ${TYPOGRAPHY.rustFont}`}>
            
            <div className={`${getFontSize(slide.l1)} ${animating ? "opacity-0 enter-1" : "exit-1"}`}>
                {slide.l1}
            </div>
            
            <div className={`${getFontSize(slide.l2)} ${animating ? "opacity-0 enter-2" : "exit-2"}`}>
                {slide.l2}
            </div>
            
            <div className={`${getFontSize(slide.l3)} text-red-600 ${animating ? "opacity-0 enter-3" : "exit-3"}`}>
                {slide.l3}
            </div>

          </div>
          <div className="h-2 bg-red-600 mt-6 shadow-[0_0_15px_rgba(220,38,38,0.5)] opacity-0 anim-line" />
        </div>

        {/* Bottom Actions - Pushed to bottom */}
        {/* Only renders or becomes visible after delay */}
        <div className={`mt-auto pb-6 space-y-3 ${showButton ? 'btn-enter' : 'opacity-0'}`}>
          <Button onClick={() => onNavigate('SERVER_PROMO')} className={EFFECTS.glowRed}>
            INITIATE SETUP
          </Button>
        </div>
      </div>
    </div>
  );
};
