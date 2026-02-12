
import React from 'react';
import { ArrowLeft, ChevronRight, BookOpen } from 'lucide-react';
import { ScreenName } from '../types';
import { TYPOGRAPHY } from '../theme';
import { GUIDES } from '../data/guidesData';

interface GuideListScreenProps {
  onNavigate: (screen: ScreenName) => void;
  onSelectGuide: (id: string) => void;
}

export const GuideListScreen: React.FC<GuideListScreenProps> = ({ onNavigate, onSelectGuide }) => {
  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Survival Guides</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Knowledge Base</p>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 space-y-4">
          
          {GUIDES.map((guide) => (
              <button
                key={guide.id}
                onClick={() => {
                    onSelectGuide(guide.id);
                    onNavigate('GUIDE_DETAIL');
                }}
                className="w-full relative h-40 rounded-2xl overflow-hidden group border border-zinc-800 hover:border-zinc-600 transition-all active:scale-[0.98] shadow-lg"
              >
                  {/* Background Image */}
                  <div className="absolute inset-0">
                      <img 
                        src={guide.heroImage} 
                        alt={guide.title} 
                        className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105 opacity-60"
                      />
                      <div className="absolute inset-0 bg-gradient-to-r from-black via-black/60 to-transparent" />
                  </div>

                  {/* Content */}
                  <div className="relative z-10 p-5 h-full flex flex-col justify-center items-start text-left">
                      <div className="bg-zinc-900/80 backdrop-blur-md p-2 rounded-lg border border-white/10 mb-2 shadow-lg">
                          <BookOpen className="w-5 h-5 text-orange-500" />
                      </div>
                      <h3 className={`text-2xl text-white leading-none mb-1 ${TYPOGRAPHY.rustFont}`}>{guide.title}</h3>
                      <p className="text-zinc-300 text-xs font-medium tracking-wide">{guide.subtitle}</p>
                      
                      <div className="absolute bottom-5 right-5 w-8 h-8 rounded-full bg-white/10 backdrop-blur flex items-center justify-center group-hover:bg-white/20 transition-colors">
                          <ChevronRight className="w-5 h-5 text-white" />
                      </div>
                  </div>
              </button>
          ))}

      </div>
    </div>
  );
};
