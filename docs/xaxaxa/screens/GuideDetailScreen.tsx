
import React, { useRef, useMemo } from 'react';
import { 
  ArrowLeft, 
  Lightbulb,
  ArrowUp
} from 'lucide-react';
import { ScreenName } from '../types';
import { TYPOGRAPHY } from '../theme';
import { GUIDES } from '../data/guidesData';

interface GuideDetailScreenProps {
  onNavigate: (screen: ScreenName) => void;
  guideId: string;
}

export const GuideDetailScreen: React.FC<GuideDetailScreenProps> = ({ onNavigate, guideId }) => {
  const scrollRef = useRef<HTMLDivElement>(null);
  
  const guide = useMemo(() => {
      return GUIDES.find(g => g.id === guideId) || GUIDES[0];
  }, [guideId]);

  const scrollToTop = () => {
      scrollRef.current?.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* 1. HERO HEADER (Sticky) */}
      <div className="relative h-64 shrink-0">
          <div className="absolute inset-0">
              <img 
                src={guide.heroImage} 
                alt={guide.title} 
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-b from-black/60 via-transparent to-[#0c0c0e]" />
          </div>

          <button 
            onClick={() => onNavigate('GUIDE_LIST')}
            className="absolute top-6 left-4 w-10 h-10 rounded-full bg-black/40 backdrop-blur-md flex items-center justify-center text-white hover:bg-black/60 transition-all z-20 border border-white/10"
          >
              <ArrowLeft className="w-5 h-5" />
          </button>

          <div className="absolute bottom-0 left-0 right-0 p-6 pt-12 bg-gradient-to-t from-[#0c0c0e] via-[#0c0c0e]/90 to-transparent">
              <span className="text-orange-500 font-bold text-xs uppercase tracking-widest mb-2 block">Survival Guide</span>
              <h1 className="text-3xl font-black text-white leading-none drop-shadow-lg shadow-black mb-2">
                  {guide.title}
              </h1>
              <p className="text-zinc-400 text-sm font-medium">
                  {guide.subtitle}
              </p>
          </div>
      </div>

      {/* 2. CONTENT SCROLL */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-8 pb-24" ref={scrollRef}>
          
          {guide.sections.map((section, idx) => (
              <div key={section.id} className="relative">
                  {/* Connector Line */}
                  {idx !== guide.sections.length - 1 && (
                      <div className="absolute left-[19px] top-10 bottom-[-32px] w-0.5 bg-zinc-800" />
                  )}

                  <div className="flex gap-4">
                      {/* Icon Bubble */}
                      <div className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center shrink-0 relative z-10">
                          <section.icon className="w-5 h-5 text-orange-500" />
                      </div>

                      <div className="flex-1 pb-2">
                          <h3 className="text-lg font-black text-white uppercase mb-2">{section.title}</h3>
                          
                          <p className="text-zinc-400 text-sm leading-relaxed mb-4">
                              {section.content}
                          </p>

                          {/* Related Items Grid */}
                          {section.items && (
                              <div className="flex flex-wrap gap-2 mb-4">
                                  {section.items.map((item, i) => (
                                      <div key={i} className="flex items-center gap-2 bg-zinc-900/50 border border-zinc-800 rounded-lg p-1.5 pr-3">
                                          <div className="w-8 h-8 bg-black/40 rounded flex items-center justify-center">
                                              <img src={item.image} alt={item.name} className="w-6 h-6 object-contain" />
                                          </div>
                                          <span className="text-xs font-bold text-zinc-300">{item.name}</span>
                                      </div>
                                  ))}
                              </div>
                          )}

                          {/* Pro Tip Box */}
                          {section.tip && (
                              <div className="bg-blue-900/10 border-l-2 border-blue-500 p-3 rounded-r-lg flex gap-3">
                                  <Lightbulb className="w-4 h-4 text-blue-400 shrink-0 mt-0.5" />
                                  <p className="text-xs text-blue-200/80 leading-relaxed italic">
                                      {section.tip}
                                  </p>
                              </div>
                          )}
                      </div>
                  </div>
              </div>
          ))}

          <div className="h-px bg-zinc-800 w-full my-8" />

          {/* Footer */}
          <div className="text-center space-y-4">
              <p className="text-zinc-500 text-xs">Knowledge is power. Loot is better.</p>
              <button 
                onClick={scrollToTop}
                className="inline-flex items-center gap-2 text-xs font-bold text-zinc-400 hover:text-white uppercase tracking-wider"
              >
                  Back to Top <ArrowUp className="w-3 h-3" />
              </button>
          </div>

      </div>
    </div>
  );
};
