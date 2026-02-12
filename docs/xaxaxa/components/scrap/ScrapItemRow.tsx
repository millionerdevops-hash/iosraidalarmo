import React from 'react';
import { Minus, Plus } from 'lucide-react';
import { ComponentItem, RecyclerMode } from '../../data/scrapData';

interface ScrapItemRowProps {
    comp: ComponentItem;
    qty: number;
    recyclerMode: RecyclerMode;
    onUpdate: (id: string, delta: number) => void;
}

export const ScrapItemRow: React.FC<ScrapItemRowProps> = React.memo(({ comp, qty, recyclerMode, onUpdate }) => {
    
    const renderYieldText = () => {
        const yields = comp.baseYield;
        const parts = [];
        const m = recyclerMode === 'radtown' ? 1.0 : 0.8;
  
        const formatVal = (val: number) => {
            const total = val * m;
            return total < 1 ? total.toFixed(1) : Math.floor(total);
        };
  
        if (yields.scrap) parts.push(<span key="s" className="text-yellow-500 font-bold">{formatVal(yields.scrap)} Scrap</span>);
        if (yields.hqm) parts.push(<span key="h" className="text-zinc-400 font-bold">{formatVal(yields.hqm)} HQM</span>);
        if (yields.metal) parts.push(<span key="m" className="text-zinc-500">{formatVal(yields.metal)} Metal</span>);
        if (yields.cloth) parts.push(<span key="c" className="text-purple-400">{formatVal(yields.cloth)} Cloth</span>);
        
        return (
            <div className="flex flex-wrap gap-x-2 gap-y-0.5 text-[10px] font-mono mt-0.5 opacity-80">
                {parts.length > 0 ? parts : <span className="text-zinc-600">Recyclable</span>}
            </div>
        );
    };

    return (
        <div className={`flex items-center justify-between p-3 rounded-xl border transition-all ${qty > 0 ? 'bg-zinc-900 border-yellow-500/30' : 'bg-zinc-900/30 border-zinc-800'}`}>
            <div className="flex items-center gap-3">
                <div className={`w-10 h-10 rounded-lg flex items-center justify-center font-bold text-xs ${qty > 0 ? 'bg-yellow-500 text-black' : 'bg-zinc-800 text-zinc-600'}`}>
                    {qty > 0 ? qty : 0}
                </div>
                <div>
                    <div className={`font-bold text-sm ${qty > 0 ? 'text-white' : 'text-zinc-400'}`}>
                        {comp.name} 
                    </div>
                    {renderYieldText()}
                </div>
            </div>
            
            <div className="flex items-center gap-1">
                <button 
                   onClick={() => onUpdate(comp.id, -1)}
                   className="w-8 h-8 rounded bg-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white active:scale-90 transition-all"
                >
                    <Minus className="w-4 h-4" />
                </button>
                <button 
                   onClick={() => onUpdate(comp.id, 1)}
                   className="w-8 h-8 rounded bg-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white hover:bg-zinc-700 active:scale-90 transition-all"
                >
                    <Plus className="w-4 h-4" />
                </button>
                <button 
                   onClick={() => onUpdate(comp.id, 10)}
                   className="w-8 h-8 rounded bg-zinc-800 border border-zinc-700 flex items-center justify-center text-[10px] font-bold text-zinc-400 hover:text-yellow-500 hover:border-yellow-500 active:scale-90 transition-all ml-1"
                >
                    +10
                </button>
            </div>
        </div>
    );
});