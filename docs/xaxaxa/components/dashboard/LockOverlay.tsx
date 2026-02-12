import React from 'react';
import { Lock } from 'lucide-react';

interface LockOverlayProps {
  onUnlock: () => void;
}

export const LockOverlay: React.FC<LockOverlayProps> = ({ onUnlock }) => (
    <div className="absolute inset-0 z-50 backdrop-blur-md bg-black/60 flex flex-col items-center justify-center rounded-2xl border border-white/5 animate-in fade-in duration-500">
        <div className="w-12 h-12 bg-zinc-800/80 rounded-full flex items-center justify-center mb-3 border border-zinc-700 shadow-xl">
            <Lock className="w-6 h-6 text-zinc-400" />
        </div>
        <span className="text-zinc-300 font-bold text-xs uppercase tracking-widest mb-3">Premium Data</span>
        <button 
            onClick={(e) => { e.stopPropagation(); onUnlock(); }} 
            className="px-5 py-2 bg-gradient-to-r from-red-700 to-red-600 text-white text-[10px] font-black uppercase tracking-wider rounded-lg hover:from-red-600 hover:to-red-500 shadow-lg shadow-red-900/40 transition-all active:scale-95"
        >
            Upgrade to View
        </button>
    </div>
);