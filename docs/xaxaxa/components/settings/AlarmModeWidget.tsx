import React, { useState } from 'react';
import { Bell, Music, Repeat, Clock } from 'lucide-react';
import { PremiumLockOverlay, SettingsDropdown, SettingsToggle } from './SettingsShared';

interface AlarmModeWidgetProps {
    isFree: boolean;
    onPaywall: () => void;
}

export const AlarmModeWidget: React.FC<AlarmModeWidgetProps> = ({ isFree, onPaywall }) => {
    const [alarmEnabled, setAlarmEnabled] = useState(true);
    const [alarmDuration, setAlarmDuration] = useState('30 sec');
    const [alarmSound, setAlarmSound] = useState('Siren');
    const [alarmLoop, setAlarmLoop] = useState(false);

    // If locked (isFree), force expansion to show the lock overlay properly
    const showContent = alarmEnabled || isFree;

    return (
        <div className={`bg-[#121214] border border-zinc-800 rounded-2xl transition-all duration-300 overflow-hidden relative
            ${!alarmEnabled && !isFree ? 'hover:border-zinc-700' : ''}
        `}>
          {isFree && <PremiumLockOverlay onUnlock={onPaywall} />}
          
          <div className={`p-5 flex items-center justify-between ${isFree ? 'opacity-30 pointer-events-none grayscale' : ''}`}>
             <div className="flex items-center gap-4">
                <div className={`w-10 h-10 rounded-full flex items-center justify-center transition-colors ${alarmEnabled ? 'bg-red-600 shadow-[0_0_15px_rgba(220,38,38,0.4)]' : 'bg-zinc-800 text-zinc-500'}`}>
                   <Bell className="w-5 h-5 text-white fill-white" />
                </div>
                <div>
                   <h3 className="font-bold text-base leading-tight">Alarm Mode</h3>
                   <p className="text-zinc-500 text-xs">Sound and vibration settings</p>
                </div>
             </div>
             <button 
               onClick={() => setAlarmEnabled(!alarmEnabled)}
               className={`w-12 h-7 rounded-full p-1 transition-colors duration-200 ease-in-out ${alarmEnabled ? 'bg-red-600' : 'bg-zinc-700'}`}
             >
               <div className={`w-5 h-5 bg-white rounded-full shadow-md transition-transform duration-200 ease-in-out ${alarmEnabled ? 'translate-x-5' : 'translate-x-0'}`} />
             </button>
          </div>

          {/* Collapsible Content */}
          {showContent && (
            <div className={`px-5 pb-5 pt-5 border-t border-zinc-800/50 space-y-6 animate-in slide-in-from-top-2 fade-in duration-300 ${isFree ? 'opacity-30 pointer-events-none grayscale' : ''}`}>
               <SettingsDropdown 
                 icon={Music} 
                 label="Alarm Sound" 
                 value={alarmSound} 
                 onChange={setAlarmSound} 
                 options={['Siren', 'Radar', 'Nuclear', 'Air Raid']} 
               />
               <SettingsToggle 
                 icon={Repeat} 
                 label="Infinite Loop" 
                 checked={alarmLoop} 
                 onChange={setAlarmLoop} 
               />
               <SettingsDropdown 
                 icon={Clock} 
                 label="Alarm Duration" 
                 value={alarmDuration} 
                 onChange={setAlarmDuration} 
                 options={['30 sec', '1 min', '5 min', 'Until Stopped']} 
               />
            </div>
          )}
        </div>
    );
};