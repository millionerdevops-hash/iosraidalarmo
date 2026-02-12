
import React, { useState, useCallback, useMemo } from 'react';
import { GoogleGenAI, Type } from "@google/genai";
import { 
  ArrowLeft, 
  Trash2,
  Camera,
  X,
  Search,
  Lock
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName, UserRole } from '../types';
import { Button } from '../components/Button';
import { COMPONENTS, CATEGORIES, Category, RecyclerMode } from '../data/scrapData';
import { RecyclerModeToggle } from '../components/scrap/RecyclerModeToggle';
import { ScrapItemRow } from '../components/scrap/ScrapItemRow';
import { ScrapTotalsBar } from '../components/scrap/ScrapTotalsBar';
import { ScrapScannerModal } from '../components/scrap/ScrapScannerModal';

interface ScrapCalculatorScreenProps {
  onNavigate: (screen: ScreenName) => void;
  onCheckAiLimit: () => boolean;
  aiUsageCount: number;
  userRole: UserRole;
}

export const ScrapCalculatorScreen: React.FC<ScrapCalculatorScreenProps> = ({ 
  onNavigate,
  onCheckAiLimit,
  aiUsageCount,
  userRole
}) => {
  const [quantities, setQuantities] = useState<Record<string, number>>({});
  const [recyclerMode, setRecyclerMode] = useState<RecyclerMode>('radtown');
  const [activeCategory, setActiveCategory] = useState<Category>('ammunition'); 
  const [searchQuery, setSearchQuery] = useState('');
  
  // Scanner State
  const [showScanner, setShowScanner] = useState(false);
  const [scanImage, setScanImage] = useState<string | null>(null);
  const [scanning, setScanning] = useState(false);
  const [scanError, setScanError] = useState<string | null>(null);
  const [showLimitModal, setShowLimitModal] = useState(false);

  const isFree = userRole === 'FREE';
  const remaining = Math.max(0, 3 - aiUsageCount);

  // useCallback optimizes the row rendering since this function is passed down
  const updateQuantity = useCallback((id: string, delta: number) => {
    setQuantities(prev => {
      const current = prev[id] || 0;
      const next = Math.max(0, current + delta);
      if (next === 0) {
        const { [id]: _, ...rest } = prev;
        return rest;
      }
      return { ...prev, [id]: next };
    });
  }, []);

  const clearAll = () => setQuantities({});

  const calculateTotal = (qty: number, baseAmount: number | undefined) => {
      if (!baseAmount) return 0;
      const multiplier = recyclerMode === 'radtown' ? 1.0 : 0.8;
      return Math.floor(baseAmount * qty * multiplier);
  };

  const totals = useMemo(() => {
      return Object.entries(quantities).reduce((acc, [id, qty]) => {
        const count = Number(qty);
        const comp = COMPONENTS.find(c => c.id === id);
        if (comp) {
            acc.scrap += calculateTotal(count, comp.baseYield.scrap);
            acc.hqm += calculateTotal(count, comp.baseYield.hqm);
            acc.metal += calculateTotal(count, comp.baseYield.metal);
            acc.cloth += calculateTotal(count, comp.baseYield.cloth);
        }
        return acc;
      }, { scrap: 0, hqm: 0, metal: 0, cloth: 0 });
  }, [quantities, recyclerMode]);

  const filteredComponents = useMemo(() => {
      return COMPONENTS.filter(c => {
        const matchesSearch = c.name.toLowerCase().includes(searchQuery.toLowerCase());
        if (searchQuery.length > 0) return matchesSearch; 
        return c.category === activeCategory;
      });
  }, [searchQuery, activeCategory]);

  const handleScanRequest = (base64Image: string) => {
      // Trigger usage check first
      if (onCheckAiLimit()) {
          processInventoryScan(base64Image);
      } else {
          setShowLimitModal(true);
          setShowScanner(false);
          setScanImage(null); 
      }
  };

  const processInventoryScan = async (base64Image: string) => {
      setScanning(true);
      setScanError(null);

      try {
          const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });
          const matches = base64Image.match(/^data:(.+);base64,(.+)$/);
          if (!matches || matches.length !== 3) throw new Error("Image error.");
          
          const mimeType = matches[1];
          const base64Data = matches[2];

          const itemNames = COMPONENTS.map(c => c.name).join(", ");

          const response = await ai.models.generateContent({
              model: 'gemini-2.0-flash-exp',
              contents: {
                  parts: [
                      { inlineData: { mimeType, data: base64Data } },
                      { text: `Identify Rust game items in this inventory screenshot. Focus ONLY on these recyclable components: ${itemNames}. Count the total quantity for each stack. Return a JSON object with a list of found items and their counts.` }
                  ]
              },
              config: {
                  responseMimeType: "application/json",
                  responseSchema: {
                      type: Type.OBJECT,
                      properties: {
                          foundItems: {
                              type: Type.ARRAY,
                              items: {
                                  type: Type.OBJECT,
                                  properties: {
                                      name: { type: Type.STRING },
                                      count: { type: Type.INTEGER }
                                  }
                              }
                          }
                      }
                  }
              }
          });

          const json = JSON.parse(response.text || "{}");
          const foundItems = json.foundItems || [];

          if (foundItems.length === 0) {
              throw new Error("No recognizable scrap components found.");
          }

          const newQuantities = { ...quantities };
          
          foundItems.forEach((item: any) => {
              const match = COMPONENTS.find(c => 
                  c.name.toLowerCase().replace(/\s/g, '') === item.name.toLowerCase().replace(/\s/g, '') ||
                  item.name.toLowerCase().includes(c.name.toLowerCase())
              );

              if (match) {
                  newQuantities[match.id] = (newQuantities[match.id] || 0) + item.count;
              }
          });

          setQuantities(newQuantities);
          setShowScanner(false);
          setScanImage(null);

      } catch (err: any) {
          console.error(err);
          setScanError(err.message || "Failed to analyze inventory.");
      } finally {
          setScanning(false);
      }
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-center relative bg-[#0c0c0e] z-10 shrink-0">
        <button 
            onClick={() => onNavigate('DASHBOARD')}
            className="absolute left-4 p-2 text-zinc-400 hover:text-white transition-colors"
        >
            <ArrowLeft className="w-6 h-6" />
        </button>
        <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Scrap Calc</h2>
        
        {/* Right Actions */}
        <div className="absolute right-4 flex gap-2">
            {isFree && (
                <div className="flex items-center gap-1 bg-zinc-900 px-2 rounded-full border border-zinc-800">
                    <span className={`text-[10px] font-bold ${remaining === 0 ? 'text-red-500' : 'text-orange-500'}`}>
                        {remaining}
                    </span>
                    <Camera className="w-3 h-3 text-zinc-500" />
                </div>
            )}
            
            <button 
                onClick={() => setShowScanner(true)}
                className="w-10 h-10 rounded-full bg-zinc-800 border border-zinc-700 flex items-center justify-center text-orange-500 hover:bg-zinc-700 hover:text-white transition-all shadow-lg"
            >
                <Camera className="w-5 h-5" />
            </button>
            <button 
                onClick={clearAll}
                disabled={Object.keys(quantities).length === 0}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-red-500 hover:bg-red-900/10 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
            >
                <Trash2 className="w-5 h-5" />
            </button>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar pb-40">
         
         {/* RECYCLER MODE TOGGLE */}
         <div className="px-4 py-4">
             <RecyclerModeToggle mode={recyclerMode} onChange={setRecyclerMode} />
         </div>

         {/* SEARCH & CATEGORIES */}
         <div className="px-4 pb-2 sticky top-0 bg-[#0c0c0e] z-20 pt-2">
             <div className="relative mb-3">
                 <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
                 <input 
                    type="text" 
                    placeholder="Search components..." 
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="w-full bg-zinc-900 border border-zinc-800 rounded-lg py-2.5 pl-9 pr-4 text-xs text-white placeholder:text-zinc-600 focus:border-orange-500 outline-none transition-colors"
                 />
                 {searchQuery && (
                     <button onClick={() => setSearchQuery('')} className="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-500 hover:text-white">
                         <X className="w-3 h-3" />
                     </button>
                 )}
             </div>

             {!searchQuery && (
                 <div className="flex gap-2 overflow-x-auto no-scrollbar pb-2">
                     {CATEGORIES.map(cat => (
                         <button
                            key={cat.id}
                            onClick={() => setActiveCategory(cat.id)}
                            className={`flex items-center gap-2 px-3 py-2 rounded-lg text-[10px] font-bold uppercase border transition-all whitespace-nowrap
                                ${activeCategory === cat.id 
                                    ? 'bg-zinc-800 border-zinc-600 text-white' 
                                    : 'bg-zinc-900 border-zinc-800 text-zinc-500 hover:bg-zinc-800'}
                            `}
                         >
                             <cat.icon className="w-3 h-3" />
                             {cat.label}
                         </button>
                     ))}
                 </div>
             )}
         </div>

         {/* ITEM LIST */}
         <div className="p-4 space-y-2">
             {filteredComponents.length === 0 ? (
                 <div className="text-center py-8 text-zinc-600 text-xs italic">
                     {searchQuery ? `No items found matching "${searchQuery}"` : "This category is empty (for now)."}
                 </div>
             ) : (
                 filteredComponents.map((comp) => (
                     <ScrapItemRow 
                        key={comp.id}
                        comp={comp}
                        qty={quantities[comp.id] || 0}
                        recyclerMode={recyclerMode}
                        onUpdate={updateQuantity}
                     />
                 ))
             )}
         </div>

      </div>

      {/* FIXED BOTTOM RESULT BAR */}
      <ScrapTotalsBar totals={totals} mode={recyclerMode} />

      {/* SCANNER MODAL */}
      {showScanner && (
          <ScrapScannerModal 
            onClose={() => setShowScanner(false)}
            onScan={handleScanRequest}
            scanning={scanning}
            scanImage={scanImage}
            scanError={scanError}
            setScanImage={setScanImage}
          />
      )}

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
                          You have used all your free AI scans. Upgrade to Lifetime access for unlimited AI inventory analysis.
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
