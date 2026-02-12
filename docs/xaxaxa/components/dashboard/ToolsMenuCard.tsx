
import React from 'react';
import { ChevronRight, Lock } from 'lucide-react';
import { TYPOGRAPHY } from '../../theme';

interface ToolsMenuCardProps {
  title: string;
  subtitle: string;
  icon: React.ElementType;
  image: string;
  onClick: () => void;
  color: string;
  comingSoon?: boolean;
}

export const ToolsMenuCard: React.FC<ToolsMenuCardProps> = ({ 
  title, 
  subtitle, 
  icon: Icon, 
  image, 
  onClick, 
  color,
  comingSoon = false
}) => {
  return (
    <button
        onClick={comingSoon ? undefined : onClick}
        disabled={comingSoon}
        className={`relative w-full h-28 rounded-2xl overflow-hidden group border border-zinc-800 transition-all active:scale-[0.98]
            ${comingSoon ? 'cursor-not-allowed opacity-80' : 'hover:border-zinc-600'}
        `}
    >
        {/* Background Image */}
        <div className="absolute inset-0">
            <img
                src={image}
                alt={title}
                className={`w-full h-full object-cover transition-transform duration-700 ${comingSoon ? 'grayscale opacity-30' : 'opacity-60 group-hover:scale-105'}`}
            />
            {/* Gradient Overlay for Text Readability */}
            <div className="absolute inset-0 bg-gradient-to-r from-black via-black/90 to-transparent" />
        </div>

        {/* Content */}
        <div className="relative z-10 h-full flex items-center px-5 justify-between">
            <div className="flex items-center gap-4">
                <div className={`w-12 h-12 rounded-xl bg-zinc-900/80 backdrop-blur-md border border-white/5 flex items-center justify-center ${comingSoon ? 'text-zinc-600' : color} shadow-lg`}>
                    <Icon className="w-6 h-6" />
                </div>
                <div className="text-left">
                    <h3 className={`text-xl text-white leading-none mb-1 ${TYPOGRAPHY.rustFont} ${comingSoon ? 'text-zinc-500' : ''}`}>{title}</h3>
                    <p className="text-zinc-400 text-xs font-medium tracking-wide">{subtitle}</p>
                </div>
            </div>
            
            {comingSoon ? (
                <div className="bg-zinc-900 border border-zinc-700 px-3 py-1.5 rounded-lg flex items-center gap-2">
                    <Lock className="w-3 h-3 text-zinc-500" />
                    <span className="text-[9px] font-black text-zinc-500 uppercase tracking-widest">Coming Soon</span>
                </div>
            ) : (
                <div className="w-8 h-8 rounded-full bg-white/5 border border-white/5 flex items-center justify-center group-hover:bg-white/10 transition-colors">
                    <ChevronRight className="w-5 h-5 text-white/50 group-hover:text-white" />
                </div>
            )}
        </div>
    </button>
  );
};
