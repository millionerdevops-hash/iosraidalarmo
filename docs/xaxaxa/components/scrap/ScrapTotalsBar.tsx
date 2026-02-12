import React from 'react';
import { Recycle } from 'lucide-react';
import { RecyclerMode } from '../../data/scrapData';

interface ScrapTotalsBarProps {
    totals: { scrap: number; hqm: number; metal: number; cloth: number };
    mode: RecyclerMode;
}

export const ScrapTotalsBar: React.FC<ScrapTotalsBarProps> = ({ totals, mode }) => {
    return (
        <div className="absolute bottom-0 left-0 right-0 bg-[#121214] border-t border-zinc-800 p-4 pb-8 shadow-[0_-10px_40px_rgba(0,0,0,0.5)] z-20">
          <div className="flex justify-between items-center mb-2">
              <span className="text-zinc-500 text-xs font-bold uppercase tracking-widest">Total Yield ({mode === 'radtown' ? '100%' : '80%'})</span>
              <Recycle className="w-4 h-4 text-zinc-600" />
          </div>
          
          <div className="grid grid-cols-4 gap-2">
              <div className="bg-black/40 rounded-xl p-2 border border-yellow-900/30 flex flex-col items-center justify-center relative overflow-hidden group">
                  <div className="absolute inset-0 bg-yellow-500/5 group-hover:bg-yellow-500/10 transition-colors" />
                  <span className="text-xl font-black text-yellow-500 tabular-nums">{totals.scrap}</span>
                  <span className="text-[9px] text-zinc-500 font-bold uppercase">Scrap</span>
              </div>

              <div className="bg-black/40 rounded-xl p-2 border border-zinc-800 flex flex-col items-center justify-center">
                  <span className="text-xl font-black text-zinc-300 tabular-nums">{totals.hqm}</span>
                  <span className="text-[9px] text-zinc-600 font-bold uppercase">HQM</span>
              </div>

              <div className="bg-black/40 rounded-xl p-2 border border-zinc-800 flex flex-col items-center justify-center">
                  <span className="text-xl font-black text-zinc-400 tabular-nums">{totals.metal}</span>
                  <span className="text-[9px] text-zinc-600 font-bold uppercase">Metal</span>
              </div>

               <div className="bg-black/40 rounded-xl p-2 border border-zinc-800 flex flex-col items-center justify-center">
                  <span className="text-xl font-black text-purple-400 tabular-nums">{totals.cloth}</span>
                  <span className="text-[9px] text-zinc-600 font-bold uppercase">Cloth</span>
              </div>
          </div>
      </div>
    );
};