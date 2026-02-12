import React, { useState, useRef } from 'react';
import { GoogleGenAI, Type } from "@google/genai";
import { 
  ArrowLeft, 
  Camera, 
  Upload, 
  Loader2, 
  AlertTriangle,
  Target,
  Bomb,
  Shield,
  ScanEye,
  Hammer,
  Maximize,
  Lock
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName, UserRole } from '../types';
import { Button } from '../components/Button';

interface AIAnalyzerScreenProps {
  onNavigate: (screen: ScreenName) => void;
  onCheckAiLimit: () => boolean;
  aiUsageCount: number;
  userRole: UserRole;
}

interface AnalysisResult {
  tier: string;
  structure: string;
  cost: string;
  raidPath: string;
  weakness: string;
  advice: string;
}

export const AIAnalyzerScreen: React.FC<AIAnalyzerScreenProps> = ({ 
  onNavigate, 
  onCheckAiLimit,
  aiUsageCount,
  userRole 
}) => {
  const [image, setImage] = useState<string | null>(null);
  const [analyzing, setAnalyzing] = useState(false);
  const [result, setResult] = useState<AnalysisResult | null>(null);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [showLimitModal, setShowLimitModal] = useState(false);
  
  const fileInputRef = useRef<HTMLInputElement>(null);

  const isFree = userRole === 'FREE';
  const remaining = Math.max(0, 3 - aiUsageCount);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setImage(reader.result as string);
        setResult(null); 
        setErrorMsg(null);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleAnalyze = async () => {
    if (!image) return;

    // --- USAGE CHECK ---
    if (!onCheckAiLimit()) {
        setShowLimitModal(true);
        return;
    }

    setAnalyzing(true);
    setResult(null);
    setErrorMsg(null);

    try {
        const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });
        const matches = image.match(/^data:(.+);base64,(.+)$/);
        if (!matches || matches.length !== 3) {
            throw new Error("Invalid image format. Please try another photo.");
        }
        const mimeType = matches[1];
        const base64Data = matches[2];

        const response = await ai.models.generateContent({
            model: 'gemini-2.0-flash-exp',
            contents: {
                parts: [
                    { inlineData: { mimeType, data: base64Data } },
                    { text: "You are a Rust game expert. Analyze this base screenshot. Identify the base design, material tier, and estimate the explosive resources needed to raid it. Be precise." }
                ]
            },
            config: {
                responseMimeType: "application/json",
                responseSchema: {
                    type: Type.OBJECT,
                    properties: {
                        tier: { type: Type.STRING, description: "Dominant material (Wood, Stone, Metal, HQM)" },
                        structure: { type: Type.STRING, description: "Description of the layout (e.g. 2x2, Bunker, Compound)" },
                        cost: { type: Type.STRING, description: "Estimated explosives needed to reach TC (e.g. '8 Rockets')" },
                        raidPath: { type: Type.STRING, description: "Best tactical entry point description" },
                        weakness: { type: Type.STRING, description: "Visible weak spots or flaws" },
                        advice: { type: Type.STRING, description: "Tactical advice for the raider" }
                    },
                    required: ["tier", "structure", "cost", "raidPath", "weakness", "advice"]
                }
            }
        });

        const responseText = response.text;
        if (!responseText) throw new Error("No analysis received from AI");

        const parsed = JSON.parse(responseText);

        setResult({
            tier: parsed.tier || "Unknown",
            structure: parsed.structure || "Unknown structure",
            cost: parsed.cost || "Calc Failed",
            raidPath: parsed.raidPath || "Direct",
            weakness: parsed.weakness || "None visible",
            advice: parsed.advice || "Proceed with caution."
        });

    } catch (err: any) {
        console.error("Analysis failed", err);
        setErrorMsg(err.message || "Connection to Google AI failed. Please try again.");
    } finally {
        setAnalyzing(false);
    }
  };

  const reset = () => {
      setImage(null);
      setResult(null);
      setErrorMsg(null);
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>AI Raid Advisor</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Powered by Google Gemini</p>
            </div>
        </div>
        {isFree && (
            <div className="flex items-center gap-2 bg-zinc-900 px-3 py-1.5 rounded-full border border-zinc-800">
                <span className={`text-[10px] font-bold ${remaining === 0 ? 'text-red-500' : 'text-orange-500'}`}>
                    {remaining} FREE SCANS
                </span>
            </div>
        )}
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6 flex flex-col">
         
         {!image ? (
             <div className="flex-1 flex flex-col justify-center items-center gap-6 border-2 border-dashed border-zinc-800 rounded-3xl bg-zinc-900/20 p-8">
                 <div className="w-20 h-20 bg-zinc-900 rounded-full flex items-center justify-center border border-zinc-700 shadow-[0_0_30px_rgba(249,115,22,0.1)]">
                     <Camera className="w-10 h-10 text-zinc-500" />
                 </div>
                 <div className="text-center">
                     <h3 className="text-white font-bold text-lg mb-2">Upload Base Screenshot</h3>
                     <p className="text-zinc-500 text-sm max-w-[200px] mx-auto">
                         Take a photo or upload a screenshot of a base to identify weaknesses and raid cost.
                     </p>
                 </div>
                 <input 
                    type="file" 
                    accept="image/*" 
                    className="hidden" 
                    ref={fileInputRef}
                    onChange={handleFileChange}
                 />
                 <Button onClick={() => fileInputRef.current?.click()} className="w-48">
                    <Upload className="w-4 h-4" /> Select Image
                 </Button>
             </div>
         ) : (
             <div className="flex-1 flex flex-col">
                 {/* Image Preview Area */}
                 <div className="relative w-full aspect-video bg-black rounded-2xl overflow-hidden border border-zinc-700 shadow-2xl mb-6 group shrink-0">
                     <img src={image} alt="Target Base" className={`w-full h-full object-cover transition-all duration-700 ${analyzing ? 'opacity-50 blur-sm scale-105' : 'opacity-100'}`} />
                     
                     {/* Scanning Animation Overlay */}
                     {analyzing && (
                         <div className="absolute inset-0 z-10 flex flex-col items-center justify-center">
                             <div className="absolute inset-0 bg-gradient-to-b from-orange-500/20 to-transparent h-[50%] w-full animate-[scan_2s_linear_infinite] border-b-2 border-orange-500" />
                             <div className="bg-black/80 backdrop-blur px-4 py-2 rounded-full border border-orange-500/50 flex items-center gap-3">
                                 <Loader2 className="w-4 h-4 animate-spin text-orange-500" />
                                 <div className="flex flex-col items-start">
                                    <span className="text-orange-500 font-mono text-xs font-bold uppercase tracking-widest">Scanning Structure...</span>
                                 </div>
                             </div>
                         </div>
                     )}

                     {!analyzing && !result && (
                         <button onClick={reset} className="absolute top-2 right-2 bg-black/60 p-2 rounded-full text-white hover:bg-red-600 transition-colors">
                             <ArrowLeft className="w-4 h-4" />
                         </button>
                     )}
                 </div>

                 {errorMsg && (
                    <div className="bg-red-950/30 border border-red-900/50 rounded-xl p-4 mb-4 flex items-center gap-3 text-red-200 text-sm animate-in fade-in slide-in-from-top-2">
                        <AlertTriangle className="w-5 h-5 text-red-500 shrink-0" />
                        <div>
                            <span className="font-bold block">Analysis Failed</span>
                            <span className="text-xs opacity-80">{errorMsg}</span>
                        </div>
                    </div>
                 )}

                 {!result && !analyzing && !errorMsg && (
                     <div className="mt-auto">
                         <div className="bg-zinc-900/50 border border-zinc-800 p-4 rounded-xl mb-4">
                             <div className="flex items-start gap-3">
                                 <ScanEye className="w-5 h-5 text-orange-500 shrink-0 mt-0.5" />
                                 <div>
                                     <h4 className="text-white font-bold text-sm">Ready to Scan</h4>
                                     <p className="text-zinc-500 text-xs mt-1">
                                         Our AI will calculate costs based on material tier, honeycomb layers, and potential roof access.
                                     </p>
                                 </div>
                             </div>
                         </div>
                         <Button onClick={handleAnalyze} className="shadow-[0_0_30px_rgba(249,115,22,0.3)]">
                             Analyze Base
                         </Button>
                     </div>
                 )}

                 {/* RESULT CARD */}
                 {result && !analyzing && (
                     <div className="animate-in slide-in-from-bottom-10 duration-500 pb-8">
                         <div className="flex items-center justify-between mb-4">
                             <h3 className="text-white font-black uppercase text-lg flex items-center gap-2">
                                 <Target className="w-5 h-5 text-red-500" /> Tactical Report
                             </h3>
                             <button onClick={reset} className="text-xs text-zinc-500 underline hover:text-white">New Scan</button>
                         </div>

                         <div className="bg-[#18181b] border border-zinc-800 rounded-2xl p-4 shadow-xl space-y-3">
                             
                             {/* ROW 1: COST & TIER */}
                             <div className="grid grid-cols-2 gap-3">
                                 <div className="bg-red-950/20 border border-red-900/30 rounded-xl p-3 flex flex-col justify-center">
                                     <div className="flex items-center gap-2 mb-1.5">
                                         <Bomb className="w-4 h-4 text-red-500" />
                                         <span className="text-[10px] text-red-400 font-bold uppercase">Raid Cost</span>
                                     </div>
                                     <div className="text-white font-mono font-bold text-sm leading-tight">{result.cost}</div>
                                     <div className="text-[9px] text-red-400/60 font-mono mt-1">To Main Loot</div>
                                 </div>

                                 <div className="bg-zinc-900 border border-zinc-800 rounded-xl p-3 flex flex-col justify-center">
                                     <div className="flex items-center gap-2 mb-1.5">
                                         <Hammer className="w-4 h-4 text-zinc-500" />
                                         <span className="text-[10px] text-zinc-500 font-bold uppercase">Material</span>
                                     </div>
                                     <div className="text-white font-bold text-sm leading-tight">{result.tier}</div>
                                     <div className="text-[9px] text-zinc-600 font-mono mt-1">Dominant Tier</div>
                                 </div>
                             </div>

                             {/* ROW 2: ARCHITECTURE */}
                             <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-3">
                                 <div className="flex items-center gap-2 mb-2">
                                     <Maximize className="w-4 h-4 text-orange-500" />
                                     <span className="text-[10px] text-orange-500 font-bold uppercase">Architecture Analysis</span>
                                 </div>
                                 <p className="text-zinc-300 text-xs leading-relaxed whitespace-pre-wrap">
                                     {result.structure}
                                 </p>
                             </div>

                             {/* ROW 3: PATH & WEAKNESS */}
                             <div className="space-y-3 pt-1">
                                 <div className="flex gap-3 items-start">
                                     <Target className="w-4 h-4 text-green-500 shrink-0 mt-0.5" />
                                     <div>
                                         <h4 className="text-green-500 font-bold text-xs uppercase mb-0.5">Recommended Path</h4>
                                         <p className="text-white text-xs font-bold">{result.raidPath}</p>
                                     </div>
                                 </div>
                                 <div className="h-px bg-zinc-800/50" />
                                 <div className="flex gap-3 items-start">
                                     <AlertTriangle className="w-4 h-4 text-yellow-500 shrink-0 mt-0.5" />
                                     <div>
                                         <h4 className="text-yellow-500 font-bold text-xs uppercase mb-0.5">Vulnerability</h4>
                                         <p className="text-zinc-400 text-xs leading-relaxed">{result.weakness}</p>
                                     </div>
                                 </div>
                                 <div className="h-px bg-zinc-800/50" />
                                 <div className="flex gap-3 items-start">
                                     <Shield className="w-4 h-4 text-blue-500 shrink-0 mt-0.5" />
                                     <div>
                                         <h4 className="text-blue-500 font-bold text-xs uppercase mb-0.5">Advisor Note</h4>
                                         <p className="text-zinc-300 text-xs leading-relaxed italic">"{result.advice}"</p>
                                     </div>
                                 </div>
                             </div>

                         </div>
                     </div>
                 )}
             </div>
         )}

      </div>

      {/* LIMIT REACHED MODAL */}
      {showLimitModal && (
          <div className="absolute inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm p-6 animate-in fade-in duration-200">
              <div className="bg-[#18181b] border border-orange-500/50 rounded-2xl w-full max-w-sm p-6 shadow-2xl relative overflow-hidden">
                  <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-orange-600 to-red-600" />
                  
                  <div className="flex flex-col items-center text-center">
                      <div className="w-16 h-16 bg-orange-900/20 rounded-full flex items-center justify-center mb-4 border border-orange-500/30">
                          <Lock className="w-8 h-8 text-orange-500" />
                      </div>
                      
                      <h3 className={`text-2xl text-white mb-2 ${TYPOGRAPHY.rustFont}`}>Usage Limit Reached</h3>
                      <p className="text-zinc-400 text-sm mb-6">
                          You have used all your free AI scans. Upgrade to Lifetime access for unlimited AI analysis.
                      </p>
                      
                      <Button onClick={() => onNavigate('PAYWALL')} className="w-full mb-3 shadow-orange-900/20">
                          Upgrade Now
                      </Button>
                      <button onClick={() => setShowLimitModal(false)} className="text-xs text-zinc-500 hover:text-white uppercase font-bold tracking-wider">
                          Maybe Later
                      </button>
                  </div>
              </div>
          </div>
      )}

    </div>
  );
};