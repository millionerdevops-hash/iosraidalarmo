
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Power, 
  Trash2, 
  Wifi
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface SmartSwitchesScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

type DeviceType = 'smart_switch' | 'smart_alarm' | 'turret';

interface PairedDevice {
    id: string;
    name: string;
    type: DeviceType;
    isActive: boolean;
    image: string;
}

export const SmartSwitchesScreen: React.FC<SmartSwitchesScreenProps> = ({ onNavigate }) => {
  
  const [devices, setDevices] = useState<PairedDevice[]>([
      { 
          id: '1', 
          name: 'Front Turret', 
          type: 'turret', 
          isActive: true, 
          image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fautoturret.webp&w=414&q=90'
      },
      { 
          id: '2', 
          name: 'Raid Alarm', 
          type: 'smart_alarm', 
          isActive: false, 
          image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fsmart-alarm.webp&w=414&q=90'
      },
      { 
          id: '3', 
          name: 'Main Lights', 
          type: 'smart_switch', 
          isActive: true, 
          image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fsmart-switch.webp&w=414&q=90'
      }
  ]);

  const toggleDevice = (id: string) => {
      setDevices(prev => prev.map(d => {
          if (d.id === id) {
              return { ...d, isActive: !d.isActive };
          }
          return d;
      }));
  };

  const deleteDevice = (e: React.MouseEvent, id: string) => {
      e.stopPropagation();
      if(confirm('Unpair this device?')) {
          setDevices(prev => prev.filter(d => d.id !== id));
      }
  };

  const getStatusText = (device: PairedDevice) => {
      if (device.type === 'smart_alarm') return device.isActive ? 'TRIGGERED' : 'ARMED';
      if (device.type === 'turret') return device.isActive ? 'ACTIVE' : 'OFF';
      return device.isActive ? 'ON' : 'OFF';
  };

  const getStatusColor = (device: PairedDevice) => {
      if (device.type === 'smart_alarm') return device.isActive ? 'text-red-500' : 'text-zinc-500';
      return device.isActive ? 'text-green-500' : 'text-zinc-500';
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="h-16 px-4 bg-[#0c0c0e] border-b border-zinc-800 flex items-center justify-between shrink-0 z-20">
          <div className="flex items-center gap-4">
              <button 
                  onClick={() => onNavigate('DASHBOARD')}
                  className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
              >
                  <ArrowLeft className="w-6 h-6" />
              </button>
              <div className="flex flex-col">
                  <span className="text-zinc-500 text-[10px] font-bold tracking-widest uppercase">Connected to</span>
                  <span className="text-white font-bold text-sm tracking-wide flex items-center gap-2">
                      [EU] FACEPUNCH 1 <span className="w-2 h-2 rounded-full bg-green-500" />
                  </span>
              </div>
          </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 space-y-3">
         
         {devices.map((device) => (
             <div 
                key={device.id}
                onClick={() => toggleDevice(device.id)}
                className={`relative flex items-center gap-4 p-3 pr-4 rounded-2xl border transition-all duration-200 active:scale-[0.99] group cursor-pointer overflow-hidden
                    ${device.isActive 
                        ? 'bg-[#121214] border-zinc-700 shadow-lg' 
                        : 'bg-[#0c0c0e] border-zinc-800 opacity-80'}
                `}
             >
                 {/* Background Glow for Active State */}
                 {device.isActive && (
                     <div className={`absolute left-0 top-0 bottom-0 w-1 ${device.type === 'smart_alarm' ? 'bg-red-500' : 'bg-green-500'}`} />
                 )}

                 {/* Icon Image Container */}
                 <div className="w-16 h-16 rounded-xl bg-black/40 flex items-center justify-center shrink-0 border border-zinc-800 relative">
                     <img src={device.image} alt={device.name} className="w-12 h-12 object-contain drop-shadow-md" />
                 </div>

                 {/* Info */}
                 <div className="flex-1 min-w-0 flex flex-col justify-center">
                     <h3 className="text-white font-bold text-base leading-tight mb-1 truncate">
                         {device.name}
                     </h3>
                     <span className={`text-[10px] font-black uppercase tracking-widest ${getStatusColor(device)}`}>
                         {getStatusText(device)}
                     </span>
                 </div>

                 {/* Controls (Switch & Delete) */}
                 <div className="flex items-center gap-4">
                     {/* Toggle Switch Visual */}
                     <div className={`w-10 h-6 rounded-full p-1 transition-colors duration-300 relative ${device.isActive ? (device.type === 'smart_alarm' ? 'bg-red-900/50' : 'bg-green-900/50') : 'bg-zinc-800'}`}>
                         <div className={`w-4 h-4 rounded-full shadow-md transition-transform duration-300 ${device.isActive ? 'translate-x-4 ' + (device.type === 'smart_alarm' ? 'bg-red-500' : 'bg-green-500') : 'translate-x-0 bg-zinc-500'}`} />
                     </div>

                     {/* Delete Button */}
                     <button 
                        onClick={(e) => deleteDevice(e, device.id)}
                        className="w-8 h-8 flex items-center justify-center rounded-full text-zinc-600 hover:text-red-500 hover:bg-red-900/10 transition-colors"
                     >
                         <Trash2 className="w-4 h-4" />
                     </button>
                 </div>
             </div>
         ))}

         {devices.length === 0 && (
             <div className="flex flex-col items-center justify-center py-20 text-zinc-600 gap-4 opacity-50">
                 <Wifi className="w-12 h-12" />
                 <span className="text-xs font-mono uppercase tracking-widest">No Devices Paired</span>
             </div>
         )}

      </div>

    </div>
  );
};
