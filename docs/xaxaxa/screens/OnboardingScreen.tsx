import React, { useState, useEffect } from 'react';
import { Question } from '../types';

interface OnboardingScreenProps {
  question: Question;
  currentStepIndex: number;
  totalSteps: number;
  onAnswer: (option: string) => void;
}

export const OnboardingScreen: React.FC<OnboardingScreenProps> = ({ 
  question, 
  currentStepIndex, 
  totalSteps, 
  onAnswer 
}) => {
  const [selectedOption, setSelectedOption] = useState<string | null>(null);

  // Guard against undefined question
  if (!question) return null;

  // Reset selection when the question changes
  useEffect(() => {
    setSelectedOption(null);
  }, [question.id]);

  const handleSelect = (opt: string) => {
    setSelectedOption(opt);
    // Add a small delay so the user sees the visual selection before navigating
    setTimeout(() => {
      onAnswer(opt);
    }, 250);
  };

  const progress = ((currentStepIndex + 1) / totalSteps) * 100;

  return (
    <div className="flex flex-col h-full bg-zinc-950">
      {/* Progress Header */}
      <div className="p-6 pb-4">
         <div className="flex justify-between items-end mb-2">
            <span className="text-orange-500 font-mono text-xs font-bold">CONFIGURING PROFILE</span>
            <span className="text-zinc-500 font-mono text-xs">{currentStepIndex + 1} / {totalSteps}</span>
         </div>
         <div className="w-full bg-zinc-900 h-2 rounded-full overflow-hidden border border-zinc-800">
           <div className="bg-orange-600 h-full transition-all duration-300 ease-out relative" style={{ width: `${progress}%` }}>
             <div className="absolute right-0 top-0 bottom-0 w-[2px] bg-white/50 shadow-[0_0_10px_white]"></div>
           </div>
         </div>
      </div>

      <div className="flex-1 p-6 flex flex-col justify-center pb-20">
        <h2 className="text-3xl font-bold text-white mb-10 leading-snug">{question.text}</h2>

        <div className="space-y-3">
          {question.options.map((opt) => {
            const isSelected = selectedOption === opt;
            
            return (
              <button
                key={opt}
                onClick={() => handleSelect(opt)}
                className={`w-full text-left p-5 border transition-all flex items-center justify-between group active:scale-[0.98] rounded-sm
                  ${isSelected 
                    ? 'bg-zinc-900 border-orange-500 shadow-[0_0_15px_rgba(249,115,22,0.15)]' // Selected State
                    : 'bg-zinc-900/40 border-zinc-800' // Default State (No hover border)
                  }
                `}
              >
                <span className={`font-semibold transition-colors ${isSelected ? 'text-white' : 'text-zinc-400'}`}>
                  {opt}
                </span>
                
                {/* Checkbox Visual */}
                <div className={`w-5 h-5 rounded-sm border-2 flex items-center justify-center transition-colors
                  ${isSelected ? 'border-orange-500 bg-orange-500/10' : 'border-zinc-700'}
                `}>
                  {/* Inner Square */}
                  <div className={`w-2.5 h-2.5 bg-orange-500 rounded-[1px] transition-opacity duration-200 
                    ${isSelected ? 'opacity-100' : 'opacity-0'}
                  `} />
                </div>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
};