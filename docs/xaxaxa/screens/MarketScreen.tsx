
import React, { useState, useMemo } from 'react';
import { 
  ArrowLeft, 
  Search, 
  Coins, 
  ArrowRight,
  TrendingUp,
  MapPin,
  RefreshCw,
  ShoppingCart,
  Shirt,
  Sprout
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { MARKET_ITEMS, MarketItem, MarketCategory } from '../data/marketData';

interface MarketScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// Helper Icons locally if not imported
const CrosshairIcon = () => <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><line x1="22" x2="18" y1="12" y2="12"/><line x1="6" x2="2" y1="12" y2="12"/><line x1="12" x2="12" y1="6" y2="2"/><line x1="12" x2="12" y1="22" y2="18"/></svg>;
const CarIcon = () => <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><circle cx="17" cy="17" r="2"/></svg>;
const HammerIcon = () => <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 12-8.5 8.5c-.83.83-2.17.83-3 0 0 0 0 0 0 0a2.12 2.12 0 0 1 0-3L12 9"/><path d="M17.64 15 22 10.64"/><path d="m20.91 11.7-1.25-1.25c-.6-.6-.93-1.4-.93-2.25V7.86c0-.55-.45-1-1-1H14.5c-.85 0-1.65-.33-2.25-.93L11 4.64"/></svg>;

const CATEGORIES: { id: MarketCategory; label: string; icon: any }[] = [
    { id: 'Exchange', label: 'Res', icon: RefreshCw },
    { id: 'Weapon', label: 'Guns', icon: CrosshairIcon },
    { id: 'Vehicle', label: 'Transport', icon: CarIcon },
    { id: 'Gear', label: 'Gear', icon: Shirt },
    { id: 'Farm', label: 'Farm', icon: Sprout },
    { id: 'Build', label: 'Build', icon: HammerIcon },
];

export const MarketScreen: React.FC<MarketScreenProps> = ({ onNavigate }) => {
  const [activeCategory, setActiveCategory] = useState<MarketCategory>('Exchange');
  const [inputQty, setInputQty] = useState<Record<string, string>>({}); // Store input by Item ID

  // Filter Items
  const filteredItems = useMemo(() => {
      return MARKET_ITEMS.filter(item => item.category === activeCategory);
  }, [activeCategory]);

  const handleInputChange = (id: string, val: string) => {
      // Only allow numbers
      if (!/^\d*$/.test(val)) return;
      setInputQty(prev => ({ ...prev, [id]: val }));
  };

  const getCalculation = (item: MarketItem) => {
      const qty = parseInt(inputQty[item.id] || '1'); // Default to 1 if empty
      const totalCost = item.cost * qty;
      const totalOutput = item.outputAmount * qty;
      
      // Formatting for display
      const format = (n: number) => n >= 10000 ? `${(n/1000).toFixed(1)}k` : n.toLocaleString();

      return { totalCost, totalOutput, qty, format };
  };

  const getLocationColor = (loc: string) => {
      switch(loc) {
          case 'Bandit': return 'text-red-400';
          case 'Outpost': return 'text-blue-400';
          case 'Fishing': return 'text-cyan-400';
          case 'Stables': return 'text-orange-400';
          default: return 'text-zinc-500';
      }
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('DASHBOARD')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Market Monitor</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">NPC Vendor Rates</p>
            </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex bg-[#0c0c0e] p-4 gap-2 overflow-x-auto no-scrollbar shrink-0 border-b border-zinc-900">
          {CATEGORIES.map(cat => (
              <button
                  key={cat.id}
                  onClick={() => { setActiveCategory(cat.id); setInputQty({}); }}
                  className={`px-3 py-2 rounded-xl text-[10px] font-bold uppercase transition-all whitespace-nowrap border flex items-center gap-2
                      ${activeCategory === cat.id 
                          ? 'bg-zinc-800 border-zinc-600 text-white shadow-lg' 
                          : 'bg-zinc-900 border-zinc-800 text-zinc-500 hover:text-zinc-300'}
                  `}
              >
                  <cat.icon className="w-3 h-3" />
                  {cat.label}
              </button>
          ))}
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 space-y-3 pb-24">
         
         {/* Info Banner for Farm */}
         {activeCategory === 'Farm' && (
             <div className="bg-green-950/20 border border-green-500/20 p-3 rounded-xl flex items-center gap-3 mb-2">
                 <Sprout className="w-5 h-5 text-green-500" />
                 <p className="text-[10px] text-green-200/70 leading-relaxed">
                     Exchange your farm produce for scrap at Bandit Camp. Best rates for <strong className="text-green-400">Fertilizer</strong>.
                 </p>
             </div>
         )}

         {filteredItems.map((item) => {
             const calc = getCalculation(item);
             
             return (
                 <div key={item.id} className="bg-[#121214] border border-zinc-800 rounded-2xl p-4 transition-all hover:border-zinc-700 group">
                     {/* Header: Item & Location */}
                     <div className="flex justify-between items-start mb-4">
                         <div className="flex items-center gap-3">
                             <div className="w-12 h-12 bg-black/40 rounded-xl flex items-center justify-center border border-zinc-800 p-1">
                                 <img src={item.image} alt={item.name} className="w-full h-full object-contain" />
                             </div>
                             <div>
                                 <h3 className="text-white font-bold text-sm">{item.name}</h3>
                                 <div className="flex items-center gap-1 mt-1">
                                     <MapPin className={`w-3 h-3 ${getLocationColor(item.location)}`} />
                                     <span className={`text-[10px] uppercase font-bold ${getLocationColor(item.location)}`}>{item.location}</span>
                                 </div>
                             </div>
                         </div>
                         {/* Unit Price Badge */}
                         <div className="bg-zinc-900 px-2 py-1 rounded text-[10px] font-mono text-zinc-400 border border-zinc-800 text-right">
                             <span className="block text-[8px] uppercase font-bold text-zinc-600 mb-0.5">Rate</span>
                             {item.outputAmount} = {item.cost} {item.currency}
                         </div>
                     </div>

                     {/* Calculator Input Area */}
                     <div className="bg-black/20 rounded-xl p-3 border border-zinc-800/50 flex items-center gap-3">
                         
                         {/* Quantity Input */}
                         <div className="flex-1">
                             <label className="text-[9px] text-zinc-500 font-bold uppercase block mb-1">Buy Amount</label>
                             <input 
                                type="text" 
                                value={inputQty[item.id] || ''} 
                                onChange={(e) => handleInputChange(item.id, e.target.value)}
                                placeholder="1"
                                className="w-full bg-zinc-900 border border-zinc-700 rounded-lg py-2 px-3 text-white font-mono text-sm focus:border-green-500 outline-none transition-colors"
                             />
                         </div>

                         <div className="flex flex-col items-center justify-center pt-3">
                             <ArrowRight className="w-4 h-4 text-zinc-600" />
                         </div>

                         {/* Result Cost */}
                         <div className="flex-1 text-right">
                             <label className="text-[9px] text-zinc-500 font-bold uppercase block mb-1">Total Cost</label>
                             <div className="text-lg font-black text-green-400 font-mono leading-tight">
                                 {calc.format(calc.totalCost)}
                             </div>
                             <div className="text-[9px] text-green-600 font-bold uppercase">{item.currency}</div>
                         </div>

                     </div>
                     
                     {/* Output Context (Total Received) */}
                     {calc.qty > 1 && (
                         <div className="mt-2 text-center">
                             <span className="text-[9px] text-zinc-500">
                                 Receiving: <strong className="text-white">{calc.format(calc.totalOutput)}</strong> items
                             </span>
                         </div>
                     )}
                 </div>
             );
         })}

      </div>
    </div>
  );
};
