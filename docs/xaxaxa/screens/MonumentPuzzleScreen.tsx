
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Map as MapIcon, 
  CreditCard, 
  Zap, 
  CheckCircle2,
  ChevronLeft,
  ChevronRight,
  Shield,
  Box,
  AlertTriangle
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { MONUMENT_PUZZLES, MonumentPuzzle } from '../data/puzzleData';

interface MonumentPuzzleScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const MonumentPuzzleScreen: React.FC<MonumentPuzzleScreenProps> = ({ onNavigate }) => {
  const [selectedMonument, setSelectedMonument] = useState<MonumentPuzzle | null>(null);
  const [currentStep, setCurrentStep] = useState(0);

  const handleSelectMonument = (monument: MonumentPuzzle) => {
      setSelectedMonument(monument);
      setCurrentStep(0);
  };

  const nextStep = () => {
      if (selectedMonument && currentStep < selectedMonument.steps.length - 1) {
          setCurrentStep(prev => prev + 1);
      }
  };

  const prevStep = () => {
      if (currentStep > 0) {
          setCurrentStep(prev => prev - 1);
      }
  };

  const getRequirementIcon = (type: string) => {
      if (type === 'Fuse') return <Zap className="w-4 h-4 text-yellow-500" />;
      if (type.includes('Card')) return <CreditCard className={`w-4 h-4 ${type.includes('Green') ? 'text-green-500' : type.includes('Blue') ? 'text-blue-500' : 'text-red-500'}`} />;
      return <Box className="w-4 h-4 text-white" />;
  };

  const step = selectedMonument ? selectedMonument.steps[currentStep] : null;

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => {
                    if (selectedMonument) setSelectedMonument(null);
                    else onNavigate('DASHBOARD');
                }}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>{selectedMonument ? selectedMonument.name : 'Puzzle Guides'}</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">
                    {selectedMonument ? `Step ${currentStep + 1}/${selectedMonument.steps.length}` : 'Select Monument'}
                </p>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4">
         
         {!selectedMonument ? (
             <div className="space-y-3 pb-8">
                 {MONUMENT_PUZZLES.map((monument) => (
                     <button
                        key={monument.id}
                        onClick={() => handleSelectMonument(monument)}
                        className="w-full bg-[#121214] border border-zinc-800 hover:border-zinc-600 rounded-2xl overflow-hidden text-left transition-all group active:scale-[0.98] shadow-md flex items-stretch h-28"
                     >
                         {/* Thumbnail Side */}
                         <div className="w-28 relative shrink-0">
                             <img 
                                src={monument.thumbnail} 
                                alt={monument.name} 
                                className="w-full h-full object-cover opacity-60 group-hover:opacity-100 transition-opacity" 
                             />
                             <div className="absolute inset-0 bg-gradient-to-r from-transparent to-[#121214]" />
                         </div>

                         {/* Info Side */}
                         <div className="flex-1 p-3 flex flex-col justify-center">
                             <div className="flex justify-between items-start mb-1">
                                 <h3 className={`text-lg font-black uppercase text-white leading-none ${TYPOGRAPHY.rustFont}`}>{monument.name}</h3>
                             </div>
                             
                             <div className="flex flex-wrap gap-2 mt-2">
                                 <span className={`text-[9px] font-bold uppercase px-2 py-0.5 rounded border ${
                                     monument.difficulty === 'Easy' ? 'bg-green-900/20 text-green-400 border-green-900/50' : 
                                     monument.difficulty === 'Medium' ? 'bg-yellow-900/20 text-yellow-400 border-yellow-900/50' : 
                                     'bg-red-900/20 text-red-400 border-red-900/50'
                                 }`}>
                                     {monument.difficulty}
                                 </span>
                                 <span className="text-[9px] font-bold uppercase px-2 py-0.5 rounded border bg-zinc-900 border-zinc-700 text-zinc-400">
                                     {monument.lootGrade} Loot
                                 </span>
                             </div>

                             <div className="flex items-center gap-1 mt-3">
                                 {monument.requirements.map((req, i) => (
                                     <div key={i} className="bg-black/40 p-1 rounded-md border border-white/5" title={`${req.count}x ${req.type}`}>
                                         {getRequirementIcon(req.type)}
                                     </div>
                                 ))}
                             </div>
                         </div>
                     </button>
                 ))}
             </div>
         ) : (
             <div className="flex flex-col h-full pb-8">
                 
                 {/* Requirement Bar */}
                 <div className="bg-[#121214] border border-zinc-800 rounded-xl p-3 mb-4 flex flex-wrap gap-3 items-center justify-center">
                     <span className="text-[10px] font-bold text-zinc-500 uppercase">Required:</span>
                     {selectedMonument.requirements.map((req, idx) => (
                         <div key={idx} className="flex items-center gap-1.5 bg-zinc-900 px-2 py-1 rounded border border-zinc-800">
                             {getRequirementIcon(req.type)}
                             <span className="text-xs font-bold text-white">{req.count}x {req.type.replace('Card','').replace('Electric ','')}</span>
                         </div>
                     ))}
                 </div>

                 {/* Step Card */}
                 <div className="flex-1 bg-[#18181b] border border-zinc-800 rounded-2xl overflow-hidden flex flex-col relative shadow-2xl">
                     {/* Image Container */}
                     <div className="h-64 relative bg-[#0c0c0e] flex items-center justify-center">
                         {/* Radial Gradient Background */}
                         <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_#27272a_0%,_#0c0c0e_70%)]" />
                         
                         {/* Step Image (Item Icon) */}
                         <img 
                            src={step?.image} 
                            alt={step?.title} 
                            className="w-32 h-32 object-contain relative z-10 drop-shadow-[0_0_30px_rgba(0,0,0,0.5)]"
                         />
                     </div>

                     {/* Content */}
                     <div className="p-6 relative z-10 flex-1 flex flex-col border-t border-zinc-800 bg-[#18181b]">
                         <div className="flex items-center gap-3 mb-4">
                             <div className="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center font-black text-white text-sm shadow-lg shadow-blue-900/50 shrink-0">
                                 {step?.id}
                             </div>
                             <h3 className="text-2xl font-bold text-white leading-none tracking-tight">{step?.title}</h3>
                         </div>
                         <p className="text-zinc-400 text-sm leading-relaxed mb-6 pl-11">
                             {step?.description}
                         </p>

                         {/* Navigation Controls */}
                         <div className="flex items-center gap-4 mt-auto">
                             <button 
                                onClick={prevStep}
                                disabled={currentStep === 0}
                                className="w-14 h-14 rounded-2xl bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                             >
                                 <ChevronLeft className="w-6 h-6" />
                             </button>
                             
                             <div className="flex-1 flex flex-col gap-2">
                                 <div className="text-center text-[10px] text-zinc-500 uppercase font-bold tracking-widest">
                                     Progress
                                 </div>
                                 <div className="h-2 bg-zinc-800 rounded-full overflow-hidden">
                                     <div 
                                        className="h-full bg-blue-600 transition-all duration-300" 
                                        style={{ width: `${((currentStep + 1) / selectedMonument.steps.length) * 100}%` }}
                                     />
                                 </div>
                             </div>

                             <button 
                                onClick={nextStep}
                                disabled={currentStep === selectedMonument.steps.length - 1}
                                className="w-14 h-14 rounded-2xl bg-blue-600 text-white flex items-center justify-center shadow-lg shadow-blue-900/30 hover:bg-blue-500 disabled:opacity-30 disabled:bg-zinc-800 disabled:shadow-none transition-all"
                             >
                                 <ChevronRight className="w-6 h-6" />
                             </button>
                         </div>
                     </div>
                 </div>

             </div>
         )}

      </div>
    </div>
  );
};
