
import React from 'react';
import { BarChart3, Signal, ShieldCheck } from 'lucide-react';
import { LockOverlay } from './LockOverlay';

// Mock Recent Activity Log - Empty to show Empty State
const RECENT_LOGS: any[] = []; 
/* 
// Previous Data for reference:
const RECENT_LOGS = [
    { id: 1, source: 'Outer Wall Gate', time: '2m ago', type: 'sensor' },
    { id: 2, source: 'Main Loot Room', time: '15m ago', type: 'destroy' },
    { id: 3, source: 'SAM Site #2', time: '42m ago', type: 'destroy' },
];
*/

interface AttackStatsWidgetProps {
  totalAttacks: number;
  isLocked: boolean;
  onUnlock: () => void;
}

export const AttackStatsWidget: React.FC<AttackStatsWidgetProps> = ({ 
  totalAttacks, 
  isLocked, 
  onUnlock 
}) => {
  return (
      <div className="relative">
          <div className={`bg-[#121214] border border-zinc-800 rounded-2xl p-4 transition-opacity duration-300 ${isLocked ? 'opacity-30 pointer-events-none' : ''}`}>
              <div className="flex items-center gap-2 mb-4">
                  <BarChart3 className="w-4 h-4 text-red-500" />
                  <h3 className="font-bold text-white text-sm">ATTACK STATISTICS</h3>
              </div>
              
              {/* Stats Grid - Equal Height & Text Sizing */}
              <div className="flex gap-3 mb-4">
                  <div className="flex-1 bg-red-900/10 border border-red-900/30 rounded-xl p-3 flex flex-col justify-center items-center h-24 relative overflow-hidden">
                      <span className="text-[10px] text-red-400 font-bold uppercase mb-1">Total Attacks</span>
                      <span className="text-2xl font-black text-white tracking-tighter">{totalAttacks}</span>
                  </div>
                  <div className="flex-1 bg-zinc-900/50 border border-zinc-800 rounded-xl p-3 flex flex-col justify-center items-center h-24">
                      <span className="text-[10px] text-zinc-500 font-bold uppercase mb-1">Last Attack</span>
                      <span className="text-xl font-black text-zinc-600 text-center leading-tight tracking-tight uppercase">
                          Stable
                      </span>
                  </div>
              </div>

              {/* RECENT ALERTS */}
              <div className="border-t border-zinc-800 pt-4">
                  <h4 className="text-xs font-bold text-zinc-400 uppercase mb-3 flex items-center gap-2">
                      <Signal className="w-3 h-3 text-orange-500" /> Recent Alerts
                  </h4>
                  
                  {RECENT_LOGS.length > 0 ? (
                      <div className="space-y-2">
                          {RECENT_LOGS.map((log) => (
                              <div key={log.id} className="flex items-center justify-between text-xs bg-zinc-900/30 p-2 rounded-lg border border-zinc-800/50">
                                  <div className="flex items-center gap-2">
                                      <div className={`w-1.5 h-1.5 rounded-full ${log.type === 'destroy' ? 'bg-red-500' : 'bg-yellow-500'}`} />
                                      <span className="text-zinc-300 font-mono">{log.source}</span>
                                  </div>
                                  <span className="text-zinc-600 font-mono">{log.time}</span>
                              </div>
                          ))}
                      </div>
                  ) : (
                      <div className="flex flex-col items-center justify-center py-5 text-center bg-zinc-900/20 border border-dashed border-zinc-800 rounded-xl">
                          <div className="w-10 h-10 bg-green-500/10 rounded-full flex items-center justify-center mb-2 shadow-[0_0_15px_rgba(34,197,94,0.1)] border border-green-500/20">
                              <ShieldCheck className="w-5 h-5 text-green-500" />
                          </div>
                          <span className="text-zinc-300 text-[10px] font-bold uppercase tracking-wider">Perimeter Secure</span>
                          <span className="text-zinc-600 text-[9px] mt-0.5 font-mono">No sensors triggered recently</span>
                      </div>
                  )}
              </div>
          </div>
          
          {/* LOCK OVERLAY */}
          {isLocked && <LockOverlay onUnlock={onUnlock} />}
      </div>
  );
};
