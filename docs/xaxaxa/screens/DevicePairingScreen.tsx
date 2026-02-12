
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  ShieldCheck, 
  Zap, 
  Power, 
  Radio, 
  BellRing, 
  Cpu, 
  Settings
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface DevicePairingScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

type DeviceType = 'SWITCH' | 'ALARM' | 'TURRET' | 'STORAGE';

interface SmartDevice {
    id: string;
    name: string;
    type: DeviceType;
    status: 'ONLINE' | 'OFFLINE';
    isActive: boolean; 
}

const COLORS: Record<DeviceType, { bg: string; border: string; text: string; glow: string }> = {
    SWITCH: { bg: 'bg-cyan-500/10', border: 'border-cyan-500/50', text: 'text-cyan-400', glow: 'shadow-cyan-500/20' },
    ALARM: { bg: 'bg-red-500/10', border: 'border-red-500/50', text: 'text-red-400', glow: 'shadow-red-500/20' },
    TURRET: { bg: 'bg-amber-500/10', border: 'border-amber-500/50', text: 'text-amber-400', glow: 'shadow-amber-500/20' },
    STORAGE: { bg: 'bg-purple-500/10', border: 'border-purple-500/50', text: 'text-purple-400', glow: 'shadow-purple-500/20' }
};

export const DevicePairingScreen: React.FC<DevicePairingScreenProps> = ({ onNavigate }) => {
  const [devices, setDevices] = useState<SmartDevice[]>([
      { id: '1', name: 'Node_8492', type: 'SWITCH', status: 'ONLINE', isActive: true },
      { id: '2', name: 'Node_3301', type: 'ALARM', status: 'ONLINE', isActive: true },
      { id: '3', name: 'Node_1095', type: 'TURRET', status: 'OFFLINE', isActive: false },
      { id: '4', name: 'Node_7742', type: 'STORAGE', status: 'ONLINE', isActive: true },
  ]);

  const toggleDevice = (id: string) => {
      setDevices(prev => prev.map(d => 
          d.id === id ? { ...d, isActive: !d.isActive } : d
      ));
  };

  const getIcon = (type: DeviceType) => {
      switch(type) {
          case 'SWITCH': return Zap;
          case 'ALARM': return BellRing;
          case 'TURRET': return ShieldCheck;
          case 'STORAGE': return Cpu;
          default: return Radio;
      }
  };

  return (
    <div className="flex flex-col h-full bg-[#050505] relative overflow-hidden font-sans">
      
      {/* 1. ANIMATED BACKGROUND */}
      <div className="absolute inset-0 z-0 pointer-events-none">
          <div className="absolute inset-0 bg-gradient-to-b from-[#1a1a1a] to-black" />
          <div 
            className="absolute inset-0 opacity-10" 
            style={{ 
                backgroundImage: 'linear-gradient(#333 1px, transparent 1px), linear-gradient(90deg, #333 1px, transparent 1px)', 
                backgroundSize: '30px 30px' 
            }} 
          />
      </div>

      {/* 2. HEADER */}
      <div className="relative z-20 p-6 pt-8 flex items-center justify-between bg-gradient-to-b from-black/80 to-transparent">
          <div className="flex items-center gap-4">
              <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-white/5 border border-white/10 flex items-center justify-center text-zinc-400 hover:text-white backdrop-blur-md transition-all active:scale-95"
              >
                  <ArrowLeft className="w-5 h-5" />
              </button>
              
              <h2 className={`text-xl text-white tracking-tight ${TYPOGRAPHY.rustFont}`}>DEVICES</h2>
          </div>

          <button className="w-10 h-10 rounded-full bg-white/5 border border-white/10 flex items-center justify-center text-zinc-400 hover:text-white backdrop-blur-md transition-all active:scale-95">
              <Settings className="w-5 h-5" />
          </button>
      </div>

      {/* 3. DEVICE GRID */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-6 pt-2 relative z-10">
          
          <div className="space-y-4 pb-24">
              {devices.map((device) => {
                  const Icon = getIcon(device.type);
                  // Safety check if type doesn't exist in COLORS
                  const theme = COLORS[device.type] || COLORS['SWITCH'];
                  const isOnline = device.status === 'ONLINE';

                  return (
                      <div 
                        key={device.id}
                        className={`relative group rounded-2xl border backdrop-blur-xl transition-all duration-500 overflow-hidden
                            ${isOnline 
                                ? `bg-zinc-900/40 border-zinc-800 hover:border-zinc-700` 
                                : 'bg-black/40 border-zinc-800 opacity-60 grayscale'
                            }
                        `}
                      >
                          {/* Active Glow border effect - Manual shadow to be safe */}
                          {device.isActive && isOnline && (
                              <div className={`absolute inset-0 rounded-2xl border opacity-50 pointer-events-none ${theme.border} ${theme.glow}`} />
                          )}

                          <div className="p-4 flex items-center gap-4 relative z-10">
                              
                              {/* ICON BOX */}
                              <div className={`w-14 h-14 rounded-xl flex items-center justify-center shrink-0 border transition-colors
                                  ${isOnline 
                                      ? (device.isActive ? `${theme.bg} ${theme.border} ${theme.text}` : 'bg-zinc-800 border-zinc-700 text-zinc-500') 
                                      : 'bg-zinc-900 border-zinc-800 text-zinc-700'}
                              `}>
                                  <Icon className="w-6 h-6" />
                              </div>

                              {/* INFO */}
                              <div className="flex-1 min-w-0">
                                  <div className="flex justify-between items-center mb-1">
                                      <h3 className={`font-bold text-base truncate ${isOnline ? 'text-white' : 'text-zinc-500'}`}>
                                          {device.name}
                                      </h3>
                                  </div>
                                  
                                  <div className="flex items-center">
                                      <span className="text-[10px] font-bold text-zinc-600 uppercase bg-black/30 px-1.5 py-0.5 rounded border border-white/5">
                                          {device.type}
                                      </span>
                                  </div>
                              </div>

                              {/* TOGGLE BUTTON */}
                              <button
                                  onClick={() => isOnline && toggleDevice(device.id)}
                                  disabled={!isOnline}
                                  className={`w-10 h-10 rounded-full flex items-center justify-center border transition-all active:scale-90
                                      ${isOnline
                                          ? (device.isActive ? `bg-white text-black border-white shadow-[0_0_15px_white]` : 'bg-transparent border-zinc-600 text-zinc-500 hover:border-white hover:text-white')
                                          : 'border-zinc-800 text-zinc-700 cursor-not-allowed'}
                                  `}
                              >
                                  <Power className="w-4 h-4" />
                              </button>
                          </div>
                      </div>
                  );
              })}
          </div>
      </div>

    </div>
  );
};
