
import React, { useState, useRef } from 'react';
import { GoogleGenAI, Type } from "@google/genai";
import { 
  ArrowLeft, 
  Camera, 
  Upload, 
  Loader2, 
  Flame,
  Share2,
  Skull,
  Ghost
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { Button } from '../components/Button';

interface BaseRoastScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

interface RoastResult {
  score: number;
  title: string;
  roast: string;
  verdict: 'CHAD' | 'RAT' | 'ROLEPLAYER' | 'NOOB';
}

export const BaseRoastScreen: React.FC<BaseRoastScreenProps> = ({ onNavigate }) => {
  const [image, setImage] = useState<string | null>(null);
  const [analyzing, setAnalyzing] = useState(false);
  const [result, setResult] = useState<RoastResult | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setImage(reader.result as string);
        setResult(null); 
      };
      reader.readAsDataURL(file);
    }
  };

  const handleRoast = async () => {
    if (!image) return;
    setAnalyzing(true);

    try {
        const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });
        const matches = image.match(/^data:(.+);base64,(.+)$/);
        if (!matches || matches.length !== 3) throw new Error("Image error");
        
        const mimeType = matches[1];
        const base64Data = matches[2];

        const response = await ai.models.generateContent({
            model: 'gemini-2.0-flash-exp',
            contents: {
                parts: [
                    { inlineData: { mimeType, data: base64Data } },
                    { text: "You are a toxic, veteran Rust player. Analyze this base screenshot. Roast the design heavily. Be mean, funny, and use Rust slang (prim locked, grub, roleplayer, zerg, soft side, honeycomb). Give it a score out of 10. Decide if they are a Chad, Rat, Roleplayer, or Noob." }
                ]
            },
            config: {
                responseMimeType: "application/json",
                responseSchema: {
                    type: Type.OBJECT,
                    properties: {
                        score: { type: Type.INTEGER },
                        title: { type: Type.STRING },
                        roast: { type: Type.STRING },
                        verdict: { type: Type.STRING, enum: ['CHAD', 'RAT', 'ROLEPLAYER', 'NOOB'] }
                    }
                }
            }
        });

        const json = JSON.parse(response.text || "{}");
        setResult(json);

    } catch (err) {
        console.error(err);
        alert("AI Roast Failed. Try again.");
    } finally {
        setAnalyzing(false);
    }
  };

  const getVerdictColor = (v: string) => {
      switch(v) {
          case 'CHAD': return 'text-red-500 border-red-500 bg-red-900/20';
          case 'RAT': return 'text-zinc-400 border-zinc-500 bg-zinc-900';
          case 'ROLEPLAYER': return 'text-blue-400 border-blue-500 bg-blue-900/20';
          default: return 'text-green-400 border-green-500 bg-green-900/20';
      }
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
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Base Roast</h2>
                <div className="flex items-center gap-1.5 text-orange-500 text-xs font-mono uppercase tracking-wider">
                    <Flame className="w-3 h-3" /> AI Critique
                </div>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6">
          
          {!image ? (
             <div className="h-full flex flex-col justify-center items-center gap-6 border-2 border-dashed border-zinc-800 rounded-3xl bg-zinc-900/20 p-8">
                 <div className="w-24 h-24 bg-orange-900/20 rounded-full flex items-center justify-center border border-orange-500/30 shadow-[0_0_40px_rgba(249,115,22,0.15)] animate-pulse">
                     <Skull className="w-12 h-12 text-orange-500" />
                 </div>
                 <div className="text-center">
                     <h3 className="text-white font-bold text-xl mb-2">Upload Your Base</h3>
                     <p className="text-zinc-500 text-sm max-w-[220px] mx-auto">
                         Prepare your feelings. Our AI is toxic and honest.
                     </p>
                 </div>
                 <input type="file" accept="image/*" className="hidden" ref={fileInputRef} onChange={handleFileChange} />
                 <Button onClick={() => fileInputRef.current?.click()} className="w-48 bg-orange-600 hover:bg-orange-500 border-orange-400">
                    <Upload className="w-4 h-4" /> Upload Screenshot
                 </Button>
             </div>
          ) : (
             <div className="flex flex-col gap-6">
                 {/* Image Preview */}
                 <div className="relative w-full aspect-video bg-black rounded-2xl overflow-hidden border border-zinc-700 shadow-2xl">
                     <img src={image} className={`w-full h-full object-cover transition-all duration-700 ${analyzing ? 'blur-sm scale-105 opacity-50' : ''}`} alt="Base" />
                     
                     {analyzing && (
                         <div className="absolute inset-0 flex flex-col items-center justify-center z-10">
                             <Loader2 className="w-8 h-8 text-orange-500 animate-spin mb-3" />
                             <span className="text-white font-black uppercase tracking-widest text-lg drop-shadow-md">Judging You...</span>
                         </div>
                     )}

                     {!result && !analyzing && (
                         <button onClick={() => setImage(null)} className="absolute top-3 right-3 bg-black/60 p-2 rounded-full text-white hover:bg-red-600 transition-colors">
                             <ArrowLeft className="w-4 h-4" />
                         </button>
                     )}
                 </div>

                 {!result && !analyzing && (
                     <Button onClick={handleRoast} className="shadow-[0_0_30px_rgba(249,115,22,0.3)] bg-gradient-to-r from-orange-600 to-red-600 py-5">
                         <Flame className="w-5 h-5 mr-2" /> ROAST ME
                     </Button>
                 )}

                 {/* Result Card */}
                 {result && (
                     <div className="animate-in slide-in-from-bottom duration-500">
                         <div className="bg-[#18181b] border-2 border-orange-500/30 rounded-3xl p-6 shadow-2xl relative overflow-hidden">
                             <div className="absolute -right-10 -top-10 w-40 h-40 bg-orange-500/10 rounded-full blur-3xl pointer-events-none" />
                             
                             {/* Verdict Badge */}
                             <div className="flex justify-center mb-6">
                                 <div className={`px-4 py-1.5 rounded-full border-2 text-sm font-black uppercase tracking-widest shadow-lg ${getVerdictColor(result.verdict)}`}>
                                     {result.verdict}
                                 </div>
                             </div>

                             {/* Score */}
                             <div className="text-center mb-6">
                                 <div className="text-6xl font-black text-white leading-none tracking-tighter drop-shadow-xl">
                                     {result.score}<span className="text-3xl text-zinc-600">/10</span>
                                 </div>
                                 <div className="text-zinc-500 text-[10px] uppercase font-bold tracking-widest mt-1">Durability Score</div>
                             </div>

                             {/* Text */}
                             <div className="space-y-4 text-center">
                                 <h3 className="text-xl font-bold text-white uppercase">{result.title}</h3>
                                 <p className="text-zinc-300 text-sm leading-relaxed italic">"{result.roast}"</p>
                             </div>

                             <div className="mt-8 pt-6 border-t border-zinc-800 flex gap-3">
                                 <Button onClick={() => setImage(null)} variant="secondary" className="flex-1">
                                     Try Again
                                 </Button>
                                 <button className="flex-1 bg-white text-black font-black uppercase rounded-xl flex items-center justify-center gap-2 hover:bg-zinc-200">
                                     <Share2 className="w-4 h-4" /> Share
                                 </button>
                             </div>
                         </div>
                     </div>
                 )}
             </div>
          )}
      </div>
    </div>
  );
};
