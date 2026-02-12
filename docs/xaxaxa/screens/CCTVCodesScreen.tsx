
import React, { useState, useMemo } from 'react';
import { 
  ArrowLeft, 
  Search, 
  X,
  Grid,
  ListFilter
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName, CameraCode, CategoryType } from '../types';
import { CCTVCardWidget } from '../components/cctv/CCTVCardWidget';
import { CODES, CATEGORIES } from '../data/cctvData'; // Assuming data is moved or using internal constant

interface CCTVCodesScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// --- INTERNAL DATA (If not imported, keeping it here for safety based on previous file) ---
// Note: In a real refactor, moving CODES to a separate data file is better, 
// but I will include the data logic here to ensure the file works standalone as requested.

const INTERNAL_CODES: CameraCode[] = [
    // LARGE OIL RIG
    { id: 'loil_dock', label: 'Dock', code: 'OILRIG2DOCK', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2DOCK.webp&w=1920&q=90' },
    { id: 'loil_exh', label: 'Exhaust', code: 'OILRIG2EXHAUST', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2EXHAUST.webp&w=1920&q=90' },
    { id: 'loil_heli', label: 'Helipad', code: 'OILRIG2HELI', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2HELI.webp&w=1920&q=90' },
    { id: 'loil_l1', label: 'Level 1', code: 'OILRIG2L1', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2L1.webp&w=1920&q=90' },
    { id: 'loil_l2', label: 'Level 2', code: 'OILRIG2L2', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2L2.webp&w=1920&q=90' },
    { id: 'loil_l3a', label: 'Level 3A', code: 'OILRIG2L3A', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2L3A.webp&w=1920&q=90' },
    { id: 'loil_l3b', label: 'Level 3B', code: 'OILRIG2L3B', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2L3B.webp&w=1920&q=90' },
    { id: 'loil_l4', label: 'Level 4', code: 'OILRIG2L4', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2L4.webp&w=1920&q=90' },
    { id: 'loil_l5', label: 'Level 5', code: 'OILRIG2L5', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2L5.webp&w=1920&q=90' },
    { id: 'loil_l6a', label: 'Level 6A', code: 'OILRIG2L6A', category: 'large_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG2L6A.webp&w=1920&q=90' },
    // SMALL OIL RIG
    { id: 'soil_dock', label: 'Dock', code: 'OILRIG1DOCK', category: 'small_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG1DOCK.webp&w=1920&q=90' },
    { id: 'soil_heli', label: 'Helipad', code: 'OILRIG1HELI', category: 'small_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG1HELI.webp&w=1920&q=90' },
    { id: 'soil_l1', label: 'Level 1', code: 'OILRIG1L1', category: 'small_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG1L1.webp&w=1920&q=90' },
    { id: 'soil_l2', label: 'Level 2', code: 'OILRIG1L2', category: 'small_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG1L2.webp&w=1920&q=90' },
    { id: 'soil_l3', label: 'Level 3', code: 'OILRIG1L3', category: 'small_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG1L3.webp&w=1920&q=90' },
    { id: 'soil_l4', label: 'Level 4', code: 'OILRIG1L4', category: 'small_oil', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FOILRIG1L4.webp&w=1920&q=90' },
    // CARGO
    { id: 'cargo_deck', label: 'Deck', code: 'CARGODECK', category: 'cargo', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FCARGODECK.webp&w=1920&q=90' },
    { id: 'cargo_bridge', label: 'Bridge', code: 'CARGOBRIDGE', category: 'cargo', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FCARGOBRIDGE.webp&w=1920&q=90' },
    { id: 'cargo_stern', label: 'Stern', code: 'CARGOSTERN', category: 'cargo', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FCARGOSTERN.webp&w=1920&q=90' },
    // SILO
    { id: 'silo_ex1', label: 'Exit 1', code: 'SILOEXIT1', category: 'silo', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FSILOEXIT1.webp&w=1920&q=90' },
    { id: 'silo_miss', label: 'Missile', code: 'SILOMISSILE', category: 'silo', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FSILOMISSILE.webp&w=1920&q=90' },
    { id: 'silo_tow', label: 'Tower', code: 'SILOTOWER', category: 'silo', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FSILOTOWER.webp&w=1920&q=90' },
    // AIRFIELD
    { id: 'air_heli', label: 'Helipad', code: 'AIRFIELDHELIPAD', category: 'airfield', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FAIRFIELDHELIPAD.webp&w=1920&q=90' },
    // BANDIT
    { id: 'ban_cas', label: 'Casino', code: 'CASINO', category: 'bandit', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FCASINO.webp&w=1920&q=90' },
    // OUTPOST
    { id: 'out_chill', label: 'Chill Zone', code: 'COMPOUNDCHILL', category: 'outpost', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FCOMPOUNDCHILL.webp&w=1920&q=90' },
    // FERRY
    { id: 'ferry_dock', label: 'Dock', code: 'FERRYDOCK', category: 'ferry', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FFERRYDOCK.webp&w=1920&q=90' },
    // RADTOWN
    { id: 'rad_apts', label: 'Apartments', code: 'RADTOWNAPARTMENTS', category: 'radtown', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FRADTOWNAPARTMENTS.webp&w=1920&q=90' },
    // DOME
    { id: 'dome_top', label: 'Top', code: 'DOMETOP', category: 'dome', img: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2Fcctv%2FDOMETOP.webp&w=1920&q=90' },
    // LABS
    { id: 'lab_main', label: 'Lab', code: 'LAB****', category: 'labs', isRandom: true },
    { id: 'lab_sec', label: 'Security', code: 'SECURITYHALL****', category: 'labs', isRandom: true },
];

const INTERNAL_CATEGORIES: { id: CategoryType | 'ALL', label: string }[] = [
    { id: 'ALL', label: 'All Cams' },
    { id: 'large_oil', label: 'Large Oil' },
    { id: 'small_oil', label: 'Small Oil' },
    { id: 'cargo', label: 'Cargo' },
    { id: 'silo', label: 'Silo' },
    { id: 'airfield', label: 'Airfield' },
    { id: 'labs', label: 'Labs' },
    { id: 'outpost', label: 'Outpost' },
    { id: 'bandit', label: 'Bandit' },
    { id: 'dome', label: 'Dome' },
    { id: 'radtown', label: 'Radtown' },
    { id: 'ferry', label: 'Ferry' },
];

export const CCTVCodesScreen: React.FC<CCTVCodesScreenProps> = ({ onNavigate }) => {
  const [search, setSearch] = useState('');
  const [activeCategory, setActiveCategory] = useState<CategoryType | 'ALL'>('ALL');

  // Filter Logic
  const filteredItems = useMemo(() => {
      return INTERNAL_CODES.filter(item => {
          const matchesSearch = item.label.toLowerCase().includes(search.toLowerCase()) || 
                                item.code.toLowerCase().includes(search.toLowerCase());
          const matchesCategory = activeCategory === 'ALL' || item.category === activeCategory;
          
          return matchesSearch && matchesCategory;
      });
  }, [search, activeCategory]);

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
        <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>CCTV Network</h2>
      </div>

      {/* Controls Container (Search + Tabs) */}
      <div className="bg-[#0c0c0e] sticky top-0 z-20 pb-4 border-b border-zinc-800/50 pt-4">
          
          {/* Search Input */}
          <div className="px-4 mb-4">
             <div className="relative group">
                 <div className="absolute inset-y-0 left-3 flex items-center pointer-events-none">
                     <Search className="w-4 h-4 text-zinc-500 group-focus-within:text-red-500 transition-colors" />
                 </div>
                 <input 
                    type="text" 
                    placeholder="Search frequency or location..." 
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl py-3 pl-10 pr-10 text-sm text-white placeholder:text-zinc-600 focus:border-red-500/50 focus:bg-zinc-900 focus:outline-none transition-all font-mono"
                 />
                 {search && (
                     <button 
                        onClick={() => setSearch('')}
                        className="absolute inset-y-0 right-3 flex items-center text-zinc-500 hover:text-white"
                     >
                         <X className="w-4 h-4" />
                     </button>
                 )}
             </div>
          </div>

          {/* Horizontal Categories */}
          <div className="flex gap-2 overflow-x-auto no-scrollbar px-4">
              {INTERNAL_CATEGORIES.map((cat) => (
                  <button
                      key={cat.id}
                      onClick={() => setActiveCategory(cat.id)}
                      className={`px-4 py-2 rounded-lg text-[10px] font-black uppercase tracking-wider transition-all whitespace-nowrap border
                          ${activeCategory === cat.id 
                              ? 'bg-red-600 text-white border-red-500 shadow-[0_0_15px_rgba(220,38,38,0.4)]' 
                              : 'bg-zinc-900 border-zinc-800 text-zinc-500 hover:text-zinc-300 hover:border-zinc-700'}
                      `}
                  >
                      {cat.label}
                  </button>
              ))}
          </div>
      </div>

      {/* Grid Content */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-4">
         {filteredItems.length === 0 ? (
             <div className="flex flex-col items-center justify-center py-20 text-zinc-600 gap-4 opacity-50">
                 <Grid className="w-12 h-12" />
                 <span className="text-xs font-mono uppercase tracking-widest">No Signal Found</span>
             </div>
         ) : (
             <div className="grid grid-cols-2 gap-3 pb-20">
                 {filteredItems.map((item) => (
                     <CCTVCardWidget 
                        key={item.id} 
                        item={item} 
                        onClick={() => {}} // No longer needed for lightbox if we copy direct
                     />
                 ))}
             </div>
         )}
      </div>

    </div>
  );
};
