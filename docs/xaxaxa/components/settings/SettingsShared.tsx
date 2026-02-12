import React from 'react';
import { Lock } from 'lucide-react';

export const PremiumLockOverlay = ({ onUnlock }: { onUnlock: () => void }) => (
    <div className="absolute inset-0 z-20 backdrop-blur-[2px] bg-black/60 flex flex-col items-center justify-center rounded-2xl border border-white/5 transition-all animate-in fade-in">
        <div className="flex flex-col items-center gap-3 p-4 text-center">
            <div className="w-10 h-10 bg-zinc-800 rounded-full flex items-center justify-center border border-zinc-700 shadow-xl">
                <Lock className="w-5 h-5 text-zinc-400" />
            </div>
            <div>
                <h4 className="text-white font-bold text-sm uppercase tracking-wide">Premium Feature</h4>
                <p className="text-zinc-400 text-[10px] mt-1">Upgrade to unlock advanced controls</p>
            </div>
            <button 
                onClick={(e) => { e.stopPropagation(); onUnlock(); }}
                className="mt-1 px-5 py-2 bg-gradient-to-r from-red-700 to-red-600 text-white text-[10px] font-black uppercase tracking-wider rounded-lg hover:from-red-600 hover:to-red-500 shadow-lg shadow-red-900/40 transition-all active:scale-95"
            >
                Unlock Now
            </button>
        </div>
    </div>
);

export const SettingsDropdown = ({ icon: Icon, label, value, onChange, options }: any) => (
  <div className="flex items-center justify-between">
    <div className="flex items-center gap-4 text-zinc-300">
        <Icon className="w-5 h-5 text-zinc-500" />
        <span className="text-sm font-medium">{label}</span>
    </div>
    <div className="relative">
        <select 
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="bg-[#1c1c1e] text-zinc-300 text-xs font-medium py-2 pl-3 pr-8 rounded-lg outline-none border border-zinc-800 appearance-none min-w-[90px]"
        >
          {options.map((opt: string) => <option key={opt}>{opt}</option>)}
        </select>
        <ChevronDownIcon className="w-3 h-3 text-zinc-500 absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none" />
    </div>
  </div>
);

export const SettingsToggle = ({ icon: Icon, label, checked, onChange }: any) => (
  <div className="flex items-center justify-between">
    <div className="flex items-center gap-4 text-zinc-300">
        <Icon className="w-5 h-5 text-zinc-500" />
        <span className="text-sm font-medium">{label}</span>
    </div>
    <button 
      onClick={() => onChange(!checked)}
      className={`w-10 h-6 rounded-full p-1 transition-colors duration-200 ease-in-out ${checked ? 'bg-red-600' : 'bg-zinc-700'}`}
    >
      <div className={`w-4 h-4 bg-white rounded-full shadow-md transition-transform duration-200 ease-in-out ${checked ? 'translate-x-4' : 'translate-x-0'}`} />
    </button>
  </div>
);

const ChevronDownIcon = ({ className }: { className?: string }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}><path d="m6 9 6 6 6-6"/></svg>
);