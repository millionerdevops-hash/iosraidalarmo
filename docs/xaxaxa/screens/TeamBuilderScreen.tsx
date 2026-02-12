
import React, { useState, useRef } from 'react';
import { 
  ArrowLeft, 
  Download, 
  ChevronLeft, 
  ChevronRight, 
  Crosshair, 
  Clock, 
  MapPin, 
  Shield, 
  Zap, 
  Crown,
  RefreshCw,
  Palette,
  Swords
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface TeamBuilderScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// --- ASSETS & CONFIG ---

const BACKGROUNDS = [
    { id: 'oil', name: 'Oil Rig', color: 'from-blue-900', img: 'https://files.facepunch.com/paddy/20190205/oilrig_header_1.jpg' },
    { id: 'cargo', name: 'Cargo', color: 'from-red-900', img: 'https://files.facepunch.com/paddy/20180502/cargo_ship_header.jpg' },
    { id: 'snow', name: 'Arctic', color: 'from-cyan-900', img: 'https://files.facepunch.com/paddy/20220203/feb_update_arctic_base.jpg' },
    { id: 'desert', name: 'Desert', color: 'from-orange-900', img: 'https://files.facepunch.com/paddy/20200806/header.jpg' },
    { id: 'mil', name: 'Mil Tunnels', color: 'from-green-900', img: 'https://files.facepunch.com/paddy/20230504/missile_silo_header.jpg' },
    { id: 'launch', name: 'Launch Site', color: 'from-zinc-800', img: 'https://files.facepunch.com/paddy/20170504/header_1.jpg' },
];

const ROLES = [
    { id: 'pvp', label: 'PVPer', icon: Crosshair, color: 'text-red-500' },
    { id: 'builder', label: 'Builder', icon: Crown, color: 'text-yellow-500' },
    { id: 'farmer', label: 'Farmer', icon: Clock, color: 'text-green-500' },
    { id: 'elec', label: 'Electrician', icon: Zap, color: 'text-blue-400' },
    { id: 'pilot', label: 'Pilot', icon: Shield, color: 'text-purple-500' },
];

export const TeamBuilderScreen: React.FC<TeamBuilderScreenProps> = ({ onNavigate }) => {
  const [formData, setFormData] = useState({
      name: 'Survivor',
      hours: '1.5k',
      role: ROLES[0],
      weapon: 'AK-47',
      age: '20+',
      region: 'EU'
  });

  const [bgIndex, setBgIndex] = useState(0); // Default Oil

  // Helpers
  const nextBg = () => setBgIndex((prev) => (prev + 1) % BACKGROUNDS.length);
  const prevBg = () => setBgIndex((prev) => (prev - 1 + BACKGROUNDS.length) % BACKGROUNDS.length);

  const getWeaponImg = (weapon: string) => {
      if (weapon === 'AK-47') return 'https://rustlabs.com/img/items180/rifle.ak.png';
      if (weapon === 'MP5') return 'https://rustlabs.com/img/items180/smg.mp5.png';
      if (weapon === 'Bolty') return 'https://rustlabs.com/img/items180/rifle.bolt.png';
      if (weapon === 'L96') return 'https://rustlabs.com/img/items180/rifle.l96.png';
      if (weapon === 'M249') return 'https://rustlabs.com/img/items180/lmg.m249.png';
      if (weapon === 'Thompson') return 'https://rustlabs.com/img/items180/smg.thompson.png';
      if (weapon === 'SAR') return 'https://rustlabs.com/img/items180/rifle.semiauto.png';
      return 'https://rustlabs.com/img/items180/rock.png';
  };

  const handleDownload = () => {
      // In a real app, this would use html2canvas or similar
      alert("Generating High-Res LFG Card... (Simulation)");
  };

  const currentBg = BACKGROUNDS[bgIndex];

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Battle Card</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">LFG Profile Creator</p>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6">
          
          {/* --- THE BATTLE CARD --- */}
          <div className="relative w-full aspect-[4/5] rounded-3xl overflow-hidden shadow-2xl border-4 border-[#1a1a1a] mb-8 group select-none bg-zinc-900">
              
              {/* Background Layer */}
              <div className="absolute inset-0">
                  <img src={currentBg.img} alt="bg" className="w-full h-full object-cover blur-[2px] scale-110 opacity-60" />
                  <div className={`absolute inset-0 bg-gradient-to-t ${currentBg.color} via-[#0c0c0e]/80 to-transparent opacity-90`} />
                  <div className="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')] opacity-30 mix-blend-overlay" />
              </div>

              {/* Header: LFG Badge */}
              <div className="absolute top-4 left-4 right-4 flex justify-between items-start z-20">
                  <div className="bg-black/40 backdrop-blur-md px-3 py-1.5 rounded-lg border border-white/10 flex items-center gap-2">
                      <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse shadow-[0_0_8px_#22c55e]" />
                      <span className="text-[10px] font-black text-white uppercase tracking-widest">Looking For Group</span>
                  </div>
              </div>

              {/* CENTER CONTENT: WEAPON */}
              <div className="absolute inset-0 flex flex-col items-center justify-center z-10 -mt-10">
                  <div className="relative w-64 h-64 flex items-center justify-center">
                      {/* Glow behind weapon */}
                      <div className="absolute inset-0 bg-gradient-to-t from-white/10 to-transparent blur-3xl opacity-30 rounded-full" />
                      
                      <img 
                        src={getWeaponImg(formData.weapon)} 
                        alt="Main Weapon" 
                        className="w-full h-full object-contain drop-shadow-[0_10px_20px_rgba(0,0,0,0.5)] rotate-[-12deg] scale-125 z-10 filter brightness-110 contrast-110" 
                      />
                  </div>
                  
                  {/* Name & Region (Under Weapon) */}
                  <div className="text-center mt-2 space-y-1">
                      <h1 className={`text-4xl text-white drop-shadow-lg ${TYPOGRAPHY.rustFont} uppercase tracking-tight`}>
                          {formData.name}
                      </h1>
                      <div className="flex justify-center items-center gap-2">
                          <MapPin className="w-3.5 h-3.5 text-zinc-400" />
                          <span className="text-zinc-300 font-mono font-bold text-sm uppercase tracking-wide">{formData.region} Region</span>
                      </div>
                  </div>
              </div>

              {/* Stats Grid (Bottom Glass) */}
              <div className="absolute bottom-4 left-4 right-4 bg-black/60 backdrop-blur-xl rounded-2xl border border-white/10 p-4 z-20">
                  <div className="grid grid-cols-3 gap-2 mb-3">
                      {/* Role */}
                      <div className="flex flex-col items-center justify-center p-2 bg-white/5 rounded-xl border border-white/5">
                          <formData.role.icon className={`w-4 h-4 mb-1 ${formData.role.color}`} />
                          <span className="text-[8px] text-zinc-500 uppercase font-bold">Role</span>
                          <span className="text-xs font-bold text-white">{formData.role.label}</span>
                      </div>
                      
                      {/* Age */}
                      <div className="flex flex-col items-center justify-center p-2 bg-white/5 rounded-xl border border-white/5">
                          <Clock className="w-4 h-4 mb-1 text-zinc-400" />
                          <span className="text-[8px] text-zinc-500 uppercase font-bold">Age</span>
                          <span className="text-xs font-bold text-white">{formData.age}</span>
                      </div>

                      {/* Hours (Moved here) */}
                      <div className="flex flex-col items-center justify-center p-2 bg-white/5 rounded-xl border border-white/5">
                          <Swords className="w-4 h-4 mb-1 text-orange-500" />
                          <span className="text-[8px] text-zinc-500 uppercase font-bold">Hours</span>
                          <span className="text-xs font-bold text-white">{formData.hours}</span>
                      </div>
                  </div>
                  
                  <div className="flex items-center justify-between px-2 pt-1 border-t border-white/5">
                      <div className="flex items-center gap-1.5">
                          <img src="https://rustlabs.com/img/items180/scrap.png" className="w-3 h-3 opacity-70" alt="logo" />
                          <span className="text-[8px] text-zinc-500 font-mono font-bold">Raid Alarm</span>
                      </div>
                      <div className="text-[8px] text-zinc-600 font-mono uppercase tracking-widest">
                          ID: {Math.floor(Math.random() * 9000) + 1000}
                      </div>
                  </div>
              </div>

              {/* Overlay Texture (Scanlines) */}
              <div className="absolute inset-0 bg-[linear-gradient(rgba(18,16,16,0)_50%,rgba(0,0,0,0.1)_50%),linear-gradient(90deg,rgba(255,0,0,0.06),rgba(0,255,0,0.02),rgba(0,0,255,0.06))] bg-[length:100%_2px,3px_100%] pointer-events-none z-30 opacity-50" />
          </div>

          {/* --- CONTROLS --- */}
          <div className="space-y-6">
              
              {/* Theme Customization */}
              <div className="bg-[#18181b] border border-zinc-800 rounded-2xl p-4 flex items-center justify-between gap-4">
                  <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-zinc-900 flex items-center justify-center border border-zinc-800 text-zinc-400">
                          <Palette className="w-5 h-5" />
                      </div>
                      <div>
                          <h4 className="text-sm font-bold text-white">Card Theme</h4>
                          <p className="text-[10px] text-zinc-500 font-mono uppercase tracking-wide">{currentBg.name}</p>
                      </div>
                  </div>
                  <div className="flex items-center gap-2">
                      <button onClick={prevBg} className="w-10 h-10 bg-zinc-900 hover:bg-zinc-800 rounded-xl flex items-center justify-center border border-zinc-800 text-zinc-400 transition-colors">
                          <ChevronLeft className="w-5 h-5" />
                      </button>
                      <button onClick={nextBg} className="w-10 h-10 bg-zinc-900 hover:bg-zinc-800 rounded-xl flex items-center justify-center border border-zinc-800 text-zinc-400 transition-colors">
                          <ChevronRight className="w-5 h-5" />
                      </button>
                  </div>
              </div>

              {/* Data Input Form */}
              <div className="space-y-4 bg-[#18181b] border border-zinc-800 p-4 rounded-2xl">
                  <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-1">
                          <label className="text-[10px] font-bold text-zinc-500 uppercase ml-1">Name</label>
                          <input 
                            className="w-full bg-zinc-900 border border-zinc-800 p-2.5 rounded-xl text-white text-sm outline-none focus:border-orange-500 transition-colors"
                            value={formData.name}
                            onChange={e => setFormData({...formData, name: e.target.value})}
                            maxLength={12}
                          />
                      </div>
                      <div className="space-y-1">
                          <label className="text-[10px] font-bold text-zinc-500 uppercase ml-1">Hours</label>
                          <input 
                            className="w-full bg-zinc-900 border border-zinc-800 p-2.5 rounded-xl text-white text-sm outline-none focus:border-orange-500 transition-colors"
                            value={formData.hours}
                            onChange={e => setFormData({...formData, hours: e.target.value})}
                          />
                      </div>
                  </div>

                  <div className="space-y-1">
                      <label className="text-[10px] font-bold text-zinc-500 uppercase ml-1">Main Role</label>
                      <div className="grid grid-cols-5 gap-1">
                          {ROLES.map((role) => {
                              const isSelected = formData.role.id === role.id;
                              return (
                                  <button
                                    key={role.id}
                                    onClick={() => setFormData({...formData, role})}
                                    className={`flex flex-col items-center justify-center p-2 rounded-xl border transition-all ${isSelected ? 'bg-zinc-800 border-zinc-600' : 'bg-zinc-900 border-transparent hover:bg-zinc-800'}`}
                                  >
                                      <role.icon className={`w-4 h-4 mb-1 ${isSelected ? role.color : 'text-zinc-600'}`} />
                                  </button>
                              );
                          })}
                      </div>
                  </div>

                  <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-1">
                          <label className="text-[10px] font-bold text-zinc-500 uppercase ml-1">Main Weapon</label>
                          <select 
                            className="w-full bg-zinc-900 border border-zinc-800 p-2.5 rounded-xl text-white text-sm outline-none focus:border-orange-500 transition-colors"
                            value={formData.weapon}
                            onChange={e => setFormData({...formData, weapon: e.target.value})}
                          >
                              <option>AK-47</option>
                              <option>MP5</option>
                              <option>Thompson</option>
                              <option>SAR</option>
                              <option>Bolty</option>
                              <option>L96</option>
                              <option>M249</option>
                          </select>
                      </div>
                      <div className="space-y-1">
                          <label className="text-[10px] font-bold text-zinc-500 uppercase ml-1">Region</label>
                          <input 
                            className="w-full bg-zinc-900 border border-zinc-800 p-2.5 rounded-xl text-white text-sm outline-none focus:border-orange-500 transition-colors"
                            value={formData.region}
                            onChange={e => setFormData({...formData, region: e.target.value})}
                          />
                      </div>
                  </div>
              </div>

              <button 
                onClick={handleDownload}
                className="w-full py-4 bg-white hover:bg-zinc-200 text-black font-black uppercase rounded-2xl shadow-lg shadow-white/10 active:scale-[0.98] transition-all flex items-center justify-center gap-2"
              >
                  <Download className="w-5 h-5" /> Download Card
              </button>
          </div>

      </div>
    </div>
  );
};
