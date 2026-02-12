
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Recycle,
  Shield,
  ShieldAlert,
  ChevronLeft,
  ChevronRight,
  ImageIcon,
  MapPin,
  TrendingUp,
  Skull,
  Radio,
  Lightbulb,
  Backpack
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { RECYCLER_LOCATIONS, RecyclerLocation } from '../data/recyclerData';

interface RecyclerGuideScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const RecyclerGuideScreen: React.FC<RecyclerGuideScreenProps> = ({ onNavigate }) => {
  const [selectedLocation, setSelectedLocation] = useState<RecyclerLocation | null>(null);
  const [currentImageIndex, setCurrentImageIndex] = useState(0);

  const handleSelect = (loc: RecyclerLocation) => {
      setSelectedLocation(loc);
      setCurrentImageIndex(0);
  };

  const nextImage = () => {
      if (selectedLocation && currentImageIndex < selectedLocation.images.length - 1) {
          setCurrentImageIndex(prev => prev + 1);
      }
  };

  const prevImage = () => {
      if (currentImageIndex > 0) {
          setCurrentImageIndex(prev => prev - 1);
      }
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => {
                    if (selectedLocation) setSelectedLocation(null);
                    else onNavigate('DASHBOARD');
                }}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Recyclers</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">
                    {selectedLocation ? selectedLocation.name : 'Location Guide'}
                </p>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4">
         
         {!selectedLocation ? (
             <div className="grid grid-cols-1 gap-3 pb-8">
                 {RECYCLER_LOCATIONS.map((loc) => (
                     <button
                        key={loc.id}
                        onClick={() => handleSelect(loc)}
                        className="w-full bg-[#121214] border border-zinc-800 hover:border-zinc-600 rounded-2xl overflow-hidden text-left transition-all group active:scale-[0.98] shadow-md flex items-center h-24"
                     >
                         {/* Thumbnail Side */}
                         <div className="w-24 h-full relative shrink-0">
                             <img 
                                src={loc.images[0]} 
                                alt={loc.name} 
                                className="w-full h-full object-cover opacity-60 group-hover:opacity-100 transition-opacity" 
                             />
                             <div className="absolute inset-0 bg-gradient-to-r from-transparent to-[#121214]" />
                         </div>

                         {/* Info Side */}
                         <div className="flex-1 p-3">
                             <div className="flex justify-between items-start mb-1">
                                 <h3 className={`text-lg font-black uppercase text-white leading-none ${TYPOGRAPHY.rustFont}`}>{loc.name}</h3>
                             </div>
                             
                             <div className="flex items-center gap-2 mt-2">
                                 <span className={`text-[9px] font-bold uppercase px-2 py-0.5 rounded border flex items-center gap-1 ${
                                     loc.safety === 'Safe' ? 'bg-green-900/20 text-green-400 border-green-900/50' : 
                                     loc.safety === 'Rad' ? 'bg-yellow-900/20 text-yellow-400 border-yellow-900/50' :
                                     'bg-red-900/20 text-red-400 border-red-900/50'
                                 }`}>
                                     {loc.safety === 'Safe' ? <Shield className="w-3 h-3" /> : <ShieldAlert className="w-3 h-3" />}
                                     {loc.safety}
                                 </span>
                                 
                                 {/* Yield Badge for Safe Zones */}
                                 {loc.yield < 1 && (
                                     <span className="text-[9px] font-bold uppercase px-2 py-0.5 rounded border bg-orange-900/20 border-orange-500/30 text-orange-400">
                                         -{Math.round((1 - loc.yield) * 100)}% Yield
                                     </span>
                                 )}
                             </div>
                         </div>
                     </button>
                 ))}
             </div>
         ) : (
             <div className="flex flex-col h-full pb-8">
                 
                 {/* Detail Card */}
                 <div className="flex-1 bg-[#18181b] border border-zinc-800 rounded-2xl overflow-hidden flex flex-col relative shadow-2xl">
                     
                     {/* Image Container with Nav */}
                     <div className="aspect-[16/9] w-full relative bg-black flex items-center justify-center overflow-hidden">
                         <img 
                            src={selectedLocation.images[currentImageIndex]} 
                            alt={`${selectedLocation.name} View ${currentImageIndex + 1}`} 
                            className="w-full h-full object-cover transition-opacity duration-300"
                         />
                         
                         {/* Navigation Overlay */}
                         <div className="absolute inset-0 flex items-center justify-between p-2 pointer-events-none">
                             <button 
                                onClick={prevImage}
                                disabled={currentImageIndex === 0}
                                className={`w-10 h-10 rounded-full bg-black/50 backdrop-blur border border-white/10 flex items-center justify-center text-white pointer-events-auto transition-opacity ${currentImageIndex === 0 ? 'opacity-0' : 'opacity-100'}`}
                             >
                                 <ChevronLeft className="w-6 h-6" />
                             </button>
                             <button 
                                onClick={nextImage}
                                disabled={currentImageIndex === selectedLocation.images.length - 1}
                                className={`w-10 h-10 rounded-full bg-black/50 backdrop-blur border border-white/10 flex items-center justify-center text-white pointer-events-auto transition-opacity ${currentImageIndex === selectedLocation.images.length - 1 ? 'opacity-0' : 'opacity-100'}`}
                             >
                                 <ChevronRight className="w-6 h-6" />
                             </button>
                         </div>

                         {/* Image Count Badge */}
                         <div className="absolute bottom-3 right-3 bg-black/60 backdrop-blur px-2 py-1 rounded text-[10px] font-bold text-white border border-white/10">
                             {currentImageIndex + 1} / {selectedLocation.images.length}
                         </div>
                     </div>

                     {/* Content */}
                     <div className="p-5 relative z-10 flex-1 flex flex-col border-t border-zinc-800 bg-[#18181b]">
                         
                         {/* Header Row */}
                         <div className="flex items-center gap-3 mb-4">
                             <div className="w-10 h-10 rounded-xl bg-zinc-800 flex items-center justify-center border border-zinc-700 shadow-lg shrink-0">
                                 <Recycle className="w-6 h-6 text-zinc-400" />
                             </div>
                             <div>
                                 <h3 className="text-2xl font-black text-white leading-none uppercase">{selectedLocation.name}</h3>
                                 <div className="flex items-center gap-1.5 mt-1 text-zinc-500 text-[10px] font-bold uppercase tracking-wider">
                                     <MapPin className="w-3 h-3" /> Location Guide
                                 </div>
                             </div>
                         </div>
                         
                         {/* STATS GRID */}
                         <div className="grid grid-cols-3 gap-2 mb-4">
                             {/* Yield */}
                             <div className={`rounded-xl p-2 border flex flex-col items-center justify-center ${selectedLocation.yield === 1 ? 'bg-green-900/10 border-green-500/20' : 'bg-red-900/10 border-red-500/20'}`}>
                                 <TrendingUp className={`w-4 h-4 mb-1 ${selectedLocation.yield === 1 ? 'text-green-500' : 'text-red-500'}`} />
                                 <span className={`text-[10px] font-bold uppercase ${selectedLocation.yield === 1 ? 'text-green-400' : 'text-red-400'}`}>
                                     {Math.round(selectedLocation.yield * 100)}% Yield
                                 </span>
                             </div>
                             
                             {/* Rads */}
                             <div className="rounded-xl p-2 border bg-zinc-900/30 border-zinc-800 flex flex-col items-center justify-center">
                                 <Radio className={`w-4 h-4 mb-1 ${selectedLocation.radiation !== 'None' ? 'text-yellow-500' : 'text-zinc-500'}`} />
                                 <span className={`text-[10px] font-bold uppercase ${selectedLocation.radiation !== 'None' ? 'text-yellow-500' : 'text-zinc-500'}`}>
                                     {selectedLocation.radiation === 'None' ? 'No Rads' : `${selectedLocation.radiation} Rads`}
                                 </span>
                             </div>

                             {/* NPCs */}
                             <div className="rounded-xl p-2 border bg-zinc-900/30 border-zinc-800 flex flex-col items-center justify-center">
                                 <Skull className={`w-4 h-4 mb-1 ${selectedLocation.npc ? 'text-orange-500' : 'text-zinc-500'}`} />
                                 <span className={`text-[10px] font-bold uppercase ${selectedLocation.npc ? 'text-orange-500' : 'text-zinc-500'}`}>
                                     {selectedLocation.npc ? 'Scientists' : 'No NPCs'}
                                 </span>
                             </div>
                         </div>

                         {/* Requirements Section */}
                         {selectedLocation.requirements && selectedLocation.requirements.length > 0 && selectedLocation.requirements[0] !== 'None' && (
                             <div className="flex items-center gap-2 mb-4 bg-zinc-900 px-3 py-2 rounded-lg border border-zinc-800">
                                 <Backpack className="w-4 h-4 text-zinc-400" />
                                 <div className="flex flex-wrap gap-2">
                                     {selectedLocation.requirements.map((req, i) => (
                                         <span key={i} className="text-[10px] text-white font-bold bg-black/40 px-2 py-0.5 rounded border border-zinc-700">
                                             {req}
                                         </span>
                                     ))}
                                 </div>
                             </div>
                         )}

                         {/* Description */}
                         <div className="bg-zinc-900/50 p-4 rounded-xl border border-zinc-800 mb-4">
                             <p className="text-zinc-300 text-sm leading-relaxed">
                                 {selectedLocation.description}
                             </p>
                         </div>

                         {/* Tactical Intel */}
                         <div className="bg-blue-900/10 border border-blue-500/20 p-4 rounded-xl relative overflow-hidden">
                             <div className="flex gap-3 relative z-10">
                                 <Lightbulb className="w-5 h-5 text-blue-400 shrink-0 mt-0.5" />
                                 <div>
                                     <h4 className="text-blue-400 font-bold text-xs uppercase mb-1">Tactical Brief</h4>
                                     <p className="text-blue-200/80 text-xs leading-relaxed italic">
                                         "{selectedLocation.tactics}"
                                     </p>
                                 </div>
                             </div>
                         </div>

                         {/* Steps / Hints */}
                         <div className="mt-auto pt-4">
                             <div className="flex items-center gap-2 mb-2 justify-center">
                                 <div className={`h-1.5 w-8 rounded-full ${currentImageIndex === 0 ? 'bg-orange-500' : 'bg-zinc-800'}`} />
                                 <div className={`h-1.5 w-8 rounded-full ${currentImageIndex === 1 ? 'bg-orange-500' : 'bg-zinc-800'}`} />
                                 {selectedLocation.images.length > 2 && <div className={`h-1.5 w-8 rounded-full ${currentImageIndex === 2 ? 'bg-orange-500' : 'bg-zinc-800'}`} />}
                             </div>
                             <p className="text-center text-[10px] text-zinc-500 uppercase font-bold">
                                 {currentImageIndex === 0 ? 'Monument View' : 'Recycler Location'}
                             </p>
                         </div>
                     </div>
                 </div>

             </div>
         )}

      </div>
    </div>
  );
};
