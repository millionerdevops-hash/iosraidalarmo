import React, { useState } from 'react';
import { ChevronDown } from 'lucide-react';
import { LockOverlay } from './LockOverlay';

type TimeRange = 'Day' | 'Week' | 'Month';

// Mock Data for the Chart
const CHART_DATA = {
  Day: [
    { label: '00:00', value: 12 },
    { label: '04:00', value: 5 },
    { label: '08:00', value: 8 },
    { label: '12:00', value: 145 },
    { label: '16:00', value: 320 },
    { label: '20:00', value: 210 },
  ],
  Week: [
    { label: 'Mon', value: 150 },
    { label: 'Tue', value: 230 },
    { label: 'Wed', value: 180 },
    { label: 'Thu', value: 390 },
    { label: 'Fri', value: 500 },
    { label: 'Sat', value: 420 },
  ],
  Month: [
    { label: 'Jun', value: 1200 },
    { label: 'Jul', value: 1850 },
    { label: 'Aug', value: 2100 },
    { label: 'Sep', value: 1600 },
    { label: 'Oct', value: 2400 },
    { label: 'Nov', value: 3100 },
  ]
};

interface AttackTrafficWidgetProps {
  isLocked: boolean;
  onUnlock: () => void;
}

export const AttackTrafficWidget: React.FC<AttackTrafficWidgetProps> = ({ isLocked, onUnlock }) => {
  const [timeRange, setTimeRange] = useState<TimeRange>('Week'); // Default to Week to show bars
  const [isChartDropdownOpen, setIsChartDropdownOpen] = useState(false);

  // --- CHART LOGIC ---
  const activeData = CHART_DATA[timeRange];
  const maxValue = Math.max(...activeData.map(d => d.value));
  const yAxisMax = maxValue === 0 ? 100 : Math.ceil(maxValue * 1.2);

  return (
      <div className="relative">
          <div className={`bg-[#121214] border border-zinc-800 rounded-2xl p-5 z-10 transition-opacity duration-300 ${isLocked ? 'opacity-30 pointer-events-none' : ''}`}>
              {/* Header with Dropdown */}
              <div className="flex justify-between items-start mb-6">
                  <div>
                      <h3 className="text-white font-bold text-base">Attack Traffic</h3>
                  </div>
                  
                  {/* Dropdown UI */}
                  <div className="relative">
                      <button 
                          onClick={() => setIsChartDropdownOpen(!isChartDropdownOpen)}
                          className="flex items-center gap-2 bg-zinc-900 border border-zinc-700 px-3 py-1.5 rounded-lg text-xs font-medium text-zinc-300 hover:border-zinc-500 transition-colors"
                      >
                          {timeRange} <ChevronDown className="w-3 h-3" />
                      </button>
                      
                      {isChartDropdownOpen && (
                          <div className="absolute right-0 top-full mt-2 bg-zinc-900 border border-zinc-700 rounded-lg shadow-xl overflow-hidden z-20 w-32 animate-in fade-in zoom-in-95">
                              {['Day', 'Week', 'Month'].map((range) => (
                                  <button 
                                      key={range}
                                      onClick={() => { setTimeRange(range as TimeRange); setIsChartDropdownOpen(false); }}
                                      className={`w-full text-left px-4 py-3 text-xs font-bold hover:bg-zinc-800 transition-colors ${timeRange === range ? 'text-orange-500 bg-zinc-800/50' : 'text-zinc-400'}`}
                                  >
                                      {range}
                                  </button>
                              ))}
                          </div>
                      )}
                  </div>
              </div>

              {/* Chart Visual */}
              <div className="h-48 flex flex-col justify-end">
                  <div className="flex-1 flex items-end gap-2.5 relative">
                      {activeData.map((data, idx) => {
                          const heightPercent = Math.max(5, (data.value / yAxisMax) * 100);
                          
                          return (
                              <div key={idx} className="flex-1 flex flex-col items-center gap-2 h-full justify-end group">
                                  {/* Bar Container */}
                                  <div className="w-full relative flex-1 flex items-end rounded-t-sm">
                                      {/* The Bar */}
                                      <div 
                                          className={`w-full rounded-t-sm transition-all duration-700 ease-out relative
                                              ${data.value > (maxValue * 0.7) 
                                                  ? 'bg-gradient-to-t from-red-700 to-red-500 shadow-[0_0_15px_rgba(220,38,38,0.4)]' 
                                                  : 'bg-gradient-to-t from-zinc-800 to-zinc-700 group-hover:from-zinc-700 group-hover:to-zinc-600'}
                                          `}
                                          style={{ height: `${heightPercent}%` }} 
                                      >
                                          {/* Hover Tooltip */}
                                          <div className="absolute -top-8 left-1/2 -translate-x-1/2 bg-zinc-800 text-white text-[10px] font-bold px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity border border-zinc-700 pointer-events-none whitespace-nowrap z-20">
                                              {data.value}
                                          </div>
                                      </div>
                                  </div>
                                  <span className="text-[10px] text-zinc-500 font-mono font-bold uppercase tracking-wider">{data.label}</span>
                              </div>
                          );
                      })}
                      
                      {/* Background Grid Lines */}
                      <div className="absolute inset-0 pointer-events-none flex flex-col justify-between opacity-10 pb-6">
                          <div className="w-full h-px bg-white border-t border-dashed" />
                          <div className="w-full h-px bg-white border-t border-dashed" />
                          <div className="w-full h-px bg-white border-t border-dashed" />
                          <div className="w-full h-px bg-white border-t border-dashed" />
                      </div>
                  </div>
              </div>
          </div>

          {/* Lock Overlay for Chart */}
          {isLocked && <LockOverlay onUnlock={onUnlock} />}
      </div>
  );
};