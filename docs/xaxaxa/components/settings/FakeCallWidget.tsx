import React, { useState } from 'react';
import { Smartphone, Music, Clock, Repeat, Hash, Image as ImageIcon, User } from 'lucide-react';
import { PremiumLockOverlay, SettingsDropdown, SettingsToggle } from './SettingsShared';

interface FakeCallWidgetProps {
    isFree: boolean;
    onPaywall: () => void;
}

export const FakeCallWidget: React.FC<FakeCallWidgetProps> = ({ isFree, onPaywall }) => {
    const [fakeCallEnabled, setFakeCallEnabled] = useState(false);
    const [fakeCallSound, setFakeCallSound] = useState('Default');
    const [fakeCallDuration, setFakeCallDuration] = useState('30 sec');
    const [fakeCallLoop, setFakeCallLoop] = useState(false);
    const [fakeCallerName, setFakeCallerName] = useState('Rust Alert');
    const [fakeCallShowNumber, setFakeCallShowNumber] = useState(false);
    const [fakeCallBackground, setFakeCallBackground] = useState('Default Dark');

    // If locked (isFree), force expansion to show the lock overlay properly
    const showContent = fakeCallEnabled || isFree;

    return (
        <div className={`bg-[#121214] border border-zinc-800 rounded-2xl transition-all duration-300 overflow-hidden relative
            ${!fakeCallEnabled && !isFree ? 'hover:border-zinc-700' : ''}
        `}>
          {isFree && <PremiumLockOverlay onUnlock={onPaywall} />}

          <div className={`p-5 flex items-center justify-between ${isFree ? 'opacity-30 pointer-events-none grayscale' : ''}`}>
             <div className="flex items-center gap-4">
                <div className={`w-10 h-10 rounded-full flex items-center justify-center transition-colors ${fakeCallEnabled ? 'bg-green-600 shadow-[0_0_15px_rgba(34,197,94,0.4)]' : 'bg-zinc-800 text-zinc-500'}`}>
                   <Smartphone className="w-5 h-5 text-white fill-white" />
                </div>
                <div>
                   <h3 className="font-bold text-base leading-tight">Fake Call</h3>
                   <p className="text-zinc-500 text-xs">Incoming call simulation</p>
                </div>
             </div>
             <button 
               onClick={() => setFakeCallEnabled(!fakeCallEnabled)}
               className={`w-12 h-7 rounded-full p-1 transition-colors duration-200 ease-in-out ${fakeCallEnabled ? 'bg-green-500' : 'bg-zinc-700'}`}
             >
               <div className={`w-5 h-5 bg-white rounded-full shadow-md transition-transform duration-200 ease-in-out ${fakeCallEnabled ? 'translate-x-5' : 'translate-x-0'}`} />
             </button>
          </div>

          {/* Collapsible Content */}
          {showContent && (
            <div className={`px-5 pb-5 pt-5 border-t border-zinc-800/50 space-y-6 animate-in slide-in-from-top-2 fade-in duration-300 ${isFree ? 'opacity-30 pointer-events-none grayscale' : ''}`}>
               {/* Caller Name Input */}
               <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4 text-zinc-300">
                      <User className="w-5 h-5 text-zinc-500" />
                      <span className="text-sm font-medium">Caller Name</span>
                  </div>
                  <input 
                    type="text" 
                    value={fakeCallerName}
                    onChange={(e) => setFakeCallerName(e.target.value)}
                    className="bg-[#1c1c1e] text-zinc-300 text-xs font-medium py-2 px-3 rounded-lg outline-none border border-zinc-800 focus:border-zinc-600 w-32 text-right"
                    placeholder="Caller Name"
                  />
               </div>

               <SettingsToggle 
                 icon={Hash} 
                 label="Show Number" 
                 checked={fakeCallShowNumber} 
                 onChange={setFakeCallShowNumber} 
                 />

               <SettingsDropdown 
                 icon={ImageIcon} 
                 label="Background" 
                 value={fakeCallBackground} 
                 onChange={setFakeCallBackground} 
                 options={['Default Dark', 'Rust Map', 'Base Interior']} 
               />

               <div className="h-px bg-zinc-800/50 w-full" /> {/* Divider */}

               <SettingsDropdown 
                 icon={Music} 
                 label="Sound" 
                 value={fakeCallSound} 
                 onChange={setFakeCallSound} 
                 options={['Default', 'Vibrate Only', 'Rust Theme']} 
               />
               <SettingsDropdown 
                 icon={Clock} 
                 label="Call Duration" 
                 value={fakeCallDuration} 
                 onChange={setFakeCallDuration} 
                 options={['30 sec', '1 min', 'Forever']} 
               />
               <SettingsToggle 
                 icon={Repeat} 
                 label="Infinite Loop" 
                 checked={fakeCallLoop} 
                 onChange={setFakeCallLoop} 
               />
            </div>
          )}
        </div>
    );
};