import React, { useState } from 'react';
import { ArrowLeft, Trash2, AlertTriangle, Clock } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface AttackHistoryScreenProps {
  onBack: () => void;
}

// Mock Data
const MOCK_HISTORY = [
  {
    id: 1,
    title: 'Raid Alarm Alert',
    message: 'Your base is under attack!',
    time: 'Just now',
    type: 'CRITICAL'
  },
  {
    id: 2,
    title: 'Raid Alarm Alert',
    message: 'Your base is under attack!',
    time: '1 minute ago',
    type: 'WARNING'
  },
  {
    id: 3,
    title: 'Raid Alarm Alert',
    message: 'Your base is under attack!',
    time: '2 minutes ago',
    type: 'WARNING'
  },
  {
    id: 4,
    title: 'Raid Alarm Alert',
    message: 'Your base is under attack!',
    time: '2 minutes ago',
    type: 'WARNING'
  }
];

export const AttackHistoryScreen: React.FC<AttackHistoryScreenProps> = ({ onBack }) => {
  const [history, setHistory] = useState(MOCK_HISTORY);

  const clearHistory = () => {
    if (confirm('Clear all notification history?')) {
      setHistory([]);
    }
  };

  return (
    <div className="flex flex-col h-full bg-zinc-950 text-white">
      {/* Unified Header */}
      <div className="h-16 px-4 border-b border-white/5 bg-zinc-950 flex items-center justify-between relative z-20 shrink-0">
        <div className="flex items-center gap-4">
          <button 
             onClick={onBack} 
             className="w-10 h-10 flex items-center justify-center -ml-2 text-zinc-400 hover:text-white hover:bg-white/5 rounded-full transition-all"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Notification History</h2>
        </div>
        <button 
            onClick={clearHistory} 
            className="w-10 h-10 flex items-center justify-center text-zinc-400 hover:text-red-500 hover:bg-red-500/10 rounded-full transition-all"
        >
          <Trash2 className="w-5 h-5" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto p-4 space-y-3">
        {history.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-full text-zinc-600 space-y-4">
            <div className="w-16 h-16 rounded-full bg-zinc-900 flex items-center justify-center">
              <Clock className="w-8 h-8" />
            </div>
            <p className="font-mono text-sm">No recent alerts</p>
          </div>
        ) : (
          history.map((item) => (
            <div 
              key={item.id}
              className={`p-4 rounded-2xl border flex flex-col gap-2 relative overflow-hidden transition-all active:scale-[0.98]
                ${item.type === 'CRITICAL' 
                  ? 'bg-[#2a1212] border-red-900/50' 
                  : 'bg-[#121214] border-zinc-800'
                }
              `}
            >
              <div className="flex items-start gap-4">
                {/* Icon Box */}
                <div className={`w-10 h-10 rounded-lg flex items-center justify-center shrink-0 border
                   ${item.type === 'CRITICAL' 
                     ? 'bg-red-900/20 border-red-500/30' 
                     : 'bg-zinc-900 border-zinc-800'
                   }
                `}>
                  <AlertTriangle className={`w-5 h-5 ${item.type === 'CRITICAL' ? 'text-red-500' : 'text-orange-500'}`} />
                </div>

                {/* Content */}
                <div className="flex-1">
                   <h3 className={`font-bold text-sm mb-1 ${item.type === 'CRITICAL' ? 'text-red-500' : 'text-white'}`}>
                     {item.title}
                   </h3>
                   <p className="text-zinc-400 text-sm leading-tight">
                     {item.message}
                   </p>
                   
                   <div className="flex items-center gap-1.5 mt-3 text-zinc-500">
                      <Clock className="w-3 h-3" />
                      <span className="text-xs font-medium">{item.time}</span>
                   </div>
                </div>
              </div>

              {/* Decorative Glow for Critical */}
              {item.type === 'CRITICAL' && (
                <div className="absolute top-0 right-0 w-32 h-32 bg-red-600/5 blur-2xl pointer-events-none -translate-y-1/2 translate-x-1/2" />
              )}
            </div>
          ))
        )}
      </div>
    </div>
  );
};