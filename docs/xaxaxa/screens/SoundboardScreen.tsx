
import React, { useState } from 'react';
import { ArrowLeft, Volume2, Music, AlertTriangle, Skull, Bomb, Bell } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface SoundboardScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

const SOUNDS = [
    { id: 'c4_beep', label: 'C4 Beep', icon: Bomb, color: 'bg-red-500', type: 'danger' },
    { id: 'rocket_launch', label: 'Rocket Launch', icon: Skull, color: 'bg-orange-500', type: 'danger' },
    { id: 'ak_spray', label: 'AK Spray', icon:  AlertTriangle, color: 'bg-yellow-500', type: 'combat' },
    { id: 'door_knock', label: 'Door Knock', icon:  Bell, color: 'bg-zinc-500', type: 'misc' },
    { id: 'code_lock', label: 'Code Lock', icon:  Bell, color: 'bg-green-500', type: 'misc' },
    { id: 'headshot', label: 'Crunch', icon:  Skull, color: 'bg-red-700', type: 'combat' },
    { id: 'samsite', label: 'SAM Site', icon:  Bomb, color: 'bg-blue-500', type: 'danger' },
    { id: 'geiger', label: 'Radiation', icon:  AlertTriangle, color: 'bg-yellow-600', type: 'misc' },
];

export const SoundboardScreen: React.FC<SoundboardScreenProps> = ({ onNavigate }) => {
  const [playing, setPlaying] = useState<string | null>(null);

  const playSound = (id: string) => {
      setPlaying(id);
      // Simulating audio playback visualization since we don't have files
      setTimeout(() => setPlaying(null), 800);
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Soundboard</h2>
                <div className="flex items-center gap-1.5 text-pink-500 text-xs font-mono uppercase tracking-wider">
                    <Music className="w-3 h-3" /> Trolling Kit
                </div>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6">
          <div className="grid grid-cols-2 gap-4">
              {SOUNDS.map((sound) => {
                  const isPlaying = playing === sound.id;
                  return (
                      <button
                        key={sound.id}
                        onClick={() => playSound(sound.id)}
                        className={`aspect-square rounded-2xl flex flex-col items-center justify-center gap-3 transition-all active:scale-95 relative overflow-hidden group border-2
                            ${isPlaying ? 'border-white scale-95 shadow-[0_0_30px_rgba(255,255,255,0.3)]' : 'border-zinc-800 bg-[#121214] hover:border-zinc-600'}
                        `}
                      >
                          {/* Pulse Effect */}
                          {isPlaying && (
                              <div className={`absolute inset-0 opacity-20 ${sound.color} animate-ping`} />
                          )}
                          
                          <div className={`w-16 h-16 rounded-full flex items-center justify-center text-white shadow-lg transition-transform duration-200 ${sound.color} ${isPlaying ? 'scale-110' : 'scale-100'}`}>
                              <sound.icon className="w-8 h-8 fill-current" />
                          </div>
                          
                          <span className={`text-xs font-black uppercase tracking-widest ${isPlaying ? 'text-white' : 'text-zinc-500 group-hover:text-zinc-300'}`}>
                              {sound.label}
                          </span>
                      </button>
                  );
              })}
          </div>
          
          <div className="mt-8 p-4 bg-zinc-900/50 border border-zinc-800 rounded-xl text-center">
              <p className="text-zinc-500 text-xs">
                  Pro Tip: Use a virtual audio cable to pipe these sounds directly into your microphone for maximum effect in-game.
              </p>
          </div>
      </div>
    </div>
  );
};
