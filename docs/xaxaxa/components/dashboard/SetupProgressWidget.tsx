import React from 'react';
import { Check, BookOpen, Sliders } from 'lucide-react';

interface SetupProgressWidgetProps {
  tutorialCompleted: boolean;
  onTutorialClick: () => void;
  onSetupClick: () => void;
}

export const SetupProgressWidget: React.FC<SetupProgressWidgetProps> = ({
  tutorialCompleted,
  onTutorialClick,
  onSetupClick
}) => {
  return (
      <div className="grid grid-cols-2 gap-3">
          {/* Card A: How It Works */}
          <button 
              onClick={onTutorialClick}
              className={`relative overflow-hidden rounded-2xl p-4 border text-left transition-all active:scale-[0.98] group flex flex-col justify-between h-28
                  ${tutorialCompleted 
                      ? 'bg-zinc-900 border-green-500/50' 
                      : 'bg-gradient-to-br from-blue-900/20 to-zinc-900 border-blue-500/50 hover:border-blue-400'
                  }
              `}
          >
              <div className="flex justify-between items-start w-full">
                  <div className={`p-2 rounded-lg ${tutorialCompleted ? 'bg-green-500/20 text-green-500' : 'bg-blue-500/20 text-blue-400'}`}>
                      {tutorialCompleted ? <Check className="w-5 h-5" /> : <BookOpen className="w-5 h-5" />}
                  </div>
                  {!tutorialCompleted && <div className="w-2 h-2 bg-blue-500 rounded-full" />}
              </div>
              <div>
                  <span className={`text-[10px] font-bold uppercase tracking-wider ${tutorialCompleted ? 'text-green-500' : 'text-blue-400'}`}>
                      Step 1
                  </span>
                  <h4 className="text-white font-bold text-sm leading-tight mt-0.5">How It Works</h4>
              </div>
          </button>

          {/* Card B: Setup Configuration */}
          <button 
              onClick={onSetupClick}
              disabled={!tutorialCompleted}
              className={`relative overflow-hidden rounded-2xl p-4 border text-left transition-all active:scale-[0.98] flex flex-col justify-between h-28
                  ${!tutorialCompleted 
                      ? 'bg-zinc-900/50 border-zinc-800 opacity-60 grayscale cursor-not-allowed' 
                      : 'bg-zinc-900 border-zinc-700 hover:border-orange-500 hover:bg-zinc-800 cursor-pointer animate-in fade-in zoom-in-95'
                  }
              `}
          >
              <div className="flex justify-between items-start w-full">
                  <div className={`p-2 rounded-lg ${!tutorialCompleted ? 'bg-zinc-800 text-zinc-500' : 'bg-orange-500/20 text-orange-500'}`}>
                      {!tutorialCompleted ? <div className="w-5 h-5" /> : <Sliders className="w-5 h-5" />}
                  </div>
              </div>
              <div>
                  <span className={`text-[10px] font-bold uppercase tracking-wider ${!tutorialCompleted ? 'text-zinc-600' : 'text-orange-500'}`}>
                      Step 2
                  </span>
                  <h4 className={`font-bold text-sm leading-tight mt-0.5 ${!tutorialCompleted ? 'text-zinc-500' : 'text-white'}`}>
                      Setup Config
                  </h4>
              </div>
          </button>
      </div>
  );
};