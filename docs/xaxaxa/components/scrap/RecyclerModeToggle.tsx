import React from 'react';
import { Factory, ShieldCheck } from 'lucide-react';
import { RecyclerMode } from '../../data/scrapData';

interface RecyclerModeToggleProps {
    mode: RecyclerMode;
    onChange: (mode: RecyclerMode) => void;
}

export const RecyclerModeToggle: React.FC<RecyclerModeToggleProps> = ({ mode, onChange }) => {
    return (
        <div className="bg-zinc-900 p-1 rounded-xl border border-zinc-800 flex relative">
             <div 
                className={`absolute top-1 bottom-1 w-[calc(50%-4px)] bg-zinc-800 rounded-lg shadow-sm transition-all duration-300 ${mode === 'radtown' ? 'left-1' : 'left-[calc(50%+2px)]'}`}
             />
             
             <button 
                onClick={() => onChange('radtown')}
                className={`flex-1 relative z-10 py-2.5 flex items-center justify-center gap-2 text-xs font-bold uppercase transition-colors ${mode === 'radtown' ? 'text-white' : 'text-zinc-500'}`}
             >
                 <Factory className="w-4 h-4" />
                 Radtown (x1.0)
             </button>
             <button 
                onClick={() => onChange('safezone')}
                className={`flex-1 relative z-10 py-2.5 flex items-center justify-center gap-2 text-xs font-bold uppercase transition-colors ${mode === 'safezone' ? 'text-green-400' : 'text-zinc-500'}`}
             >
                 <ShieldCheck className="w-4 h-4" />
                 Safezone (x0.8)
             </button>
         </div>
    );
};