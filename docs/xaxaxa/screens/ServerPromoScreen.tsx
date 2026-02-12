
import React, { useState, useEffect } from 'react';
import { 
  ArrowLeft, 
  Flame, 
  Star, 
  Map as MapIcon, 
  Users, 
  ArrowRight,
  TrendingUp,
  Megaphone,
  Loader2,
  Mail,
  MessageCircle
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName, ServerData } from '../types';

interface ServerPromoScreenProps {
  onNavigate: (screen: ScreenName) => void;
  onSelectServer: (server: ServerData) => void;
}

// --- MOCK DATA SOURCE (Simulating Supabase Response) ---
// In a real app, this data comes from: await supabase.from('promoted_servers').select('*')
const FETCH_PROMOTED_FROM_DB = (): Promise<ServerData[]> => {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve([
                {
                    id: 'promo_atlas',
                    name: 'Atlas Rust 2x | Main',
                    players: 614,
                    maxPlayers: 650,
                    status: 'online',
                    rank: 1,
                    ip: '205.178.168.170',
                    port: 28010,
                    map: 'Procedural Map',
                    mapSize: 4750,
                    seed: 1337,
                    entities: 709546,
                    headerImage: 'https://files.facepunch.com/paddy/20240206/jungle_ruins_header.jpg', 
                    description: 'Atlas Rust Servers | Made for the most competitive. 24 hours discord staff support.',
                    official: false,
                    modded: true,
                    country: 'GB',
                    url: 'https://atlasrust.com',
                    promoDetails: {
                        groupLimit: 'None',
                        blueprints: 'Enabled',
                        kits: 'No Kits',
                        decay: '100%',
                        upkeep: '100%',
                        rates: '2x',
                        monuments: 54,
                        wipeSchedule: [
                            'Map wipe on force wipe.',
                            'Map wipe at 5:00 PM on the 4th, and 5th Thursday of the month.'
                        ],
                        features: [
                            '2x Gather',
                            '2x Loot (removed junk)',
                            'Free QoL',
                            'No paid features',
                            'Active Staff Support'
                        ],
                        socials: {
                            store: 'https://store.atlasrust.com/store/',
                            website: 'https://atlasrust.com/',
                            discord: 'https://discord.gg/atlasrust',
                            youtube: 'https://www.youtube.com/channel/UCdGRfuxAa6FICru5brORa5g'
                        }
                    }
                },
                {
                    id: 'promo_vital',
                    name: 'Vital 10x | No BPs',
                    players: 380,
                    maxPlayers: 400,
                    status: 'online',
                    rank: 5,
                    ip: '104.238.229.201',
                    port: 28015,
                    map: 'Barren',
                    headerImage: 'https://hone.gg/blog/wp-content/uploads/2025/05/rust-banner_1rust-banner.webp',
                    description: 'Fast paced PVP action. Perfect for clans. 10x Loot, Instant Craft, Teleport.',
                    modded: true,
                    country: 'US',
                    promoDetails: {
                        rates: '10x',
                        kits: 'Available',
                        blueprints: 'Unlocked',
                        groupLimit: 'No Limit',
                        wipeSchedule: ['Wipes every Friday & Monday'],
                        features: ['Teleport', 'MyMini', 'Instant Craft', 'Clans']
                    }
                }
            ]);
        }, 800); // Simulate network delay
    });
};

const TRENDING_SERVERS: ServerData[] = [
    {
        id: 'trend_1',
        name: 'Bloo Lagoon 1.5x',
        players: 250,
        maxPlayers: 300,
        status: 'online',
        ip: '0.0.0.0',
        port: 0,
        headerImage: 'https://hone.gg/blog/wp-content/uploads/2025/05/rust-banner_1rust-banner.webp',
        modded: true
    },
    {
        id: 'trend_2',
        name: 'Stevious 2x Solo/Duo',
        players: 198,
        maxPlayers: 250,
        status: 'online',
        ip: '0.0.0.0',
        port: 0,
        headerImage: 'https://hone.gg/blog/wp-content/uploads/2025/05/rust-banner_1rust-banner.webp',
        modded: true
    }
];

export const ServerPromoScreen: React.FC<ServerPromoScreenProps> = ({ onNavigate, onSelectServer }) => {
  const [promotedServers, setPromotedServers] = useState<ServerData[]>([]);
  const [loading, setLoading] = useState(true);
  const [showContactModal, setShowContactModal] = useState(false);

  // Simulate fetching data on mount
  useEffect(() => {
      const loadData = async () => {
          setLoading(true);
          try {
              const data = await FETCH_PROMOTED_FROM_DB();
              setPromotedServers(data);
          } catch (e) {
              console.error(e);
          } finally {
              setLoading(false);
          }
      };
      loadData();
  }, []);
  
  const handleServerClick = (server: ServerData) => {
      onSelectServer(server);
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
        <div>
            <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont} text-center`}>Server Spotlight</h2>
            <div className="flex items-center gap-1 justify-center">
                <Flame className="w-3 h-3 text-orange-500" />
                <p className="text-orange-500 text-xs font-bold uppercase tracking-wider">Featured & Trending</p>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar pb-10 p-4 space-y-6">
         
         {/* SECTION 1: PROMOTED (Dynamic Data) */}
         <div>
             <div className="flex items-center gap-2 mb-3">
                 <Star className="w-4 h-4 text-yellow-500 fill-yellow-500" />
                 <span className="text-xs font-bold text-white uppercase tracking-widest">Featured Communities</span>
             </div>

             {loading ? (
                 <div className="flex flex-col items-center justify-center py-12 gap-2 text-zinc-500">
                     <Loader2 className="w-6 h-6 animate-spin text-yellow-500" />
                     <span className="text-xs font-mono uppercase">Loading Spotlight...</span>
                 </div>
             ) : (
                 <div className="space-y-4">
                     {promotedServers.map((server) => (
                         <button
                            key={server.id}
                            onClick={() => handleServerClick(server)}
                            className="w-full relative group rounded-2xl overflow-hidden border border-zinc-800 hover:border-yellow-500/50 transition-all active:scale-[0.98] bg-[#121214] text-left"
                         >
                             {/* Banner Image */}
                             <div className="h-32 w-full relative overflow-hidden">
                                 <img 
                                    src={server.headerImage} 
                                    alt={server.name}
                                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700"
                                 />
                                 <div className="absolute inset-0 bg-gradient-to-t from-[#121214] to-transparent opacity-90" />
                                 
                                 {/* Badges */}
                                 <div className="absolute top-3 left-3 flex gap-2">
                                     <span className="bg-yellow-500 text-black text-[9px] font-black px-2 py-1 rounded uppercase shadow-lg shadow-yellow-500/20">
                                         Promoted
                                     </span>
                                     {server.official && <span className="bg-blue-600 text-white text-[9px] font-black px-2 py-1 rounded uppercase">Official</span>}
                                     {server.modded && <span className="bg-purple-600 text-white text-[9px] font-black px-2 py-1 rounded uppercase">Modded</span>}
                                 </div>
                             </div>

                             {/* Content */}
                             <div className="p-4 pt-2 relative z-10 -mt-8">
                                 <h3 className="text-lg font-black text-white uppercase leading-tight mb-1 drop-shadow-md">
                                     {server.name}
                                 </h3>
                                 {server.description && (
                                     <p className="text-xs text-zinc-400 line-clamp-1 mb-3">{server.description}</p>
                                 )}
                                 
                                 <div className="flex items-center justify-between border-t border-zinc-800/50 pt-3">
                                     <div className="flex items-center gap-4 text-xs font-mono text-zinc-300">
                                         <span className="flex items-center gap-1.5"><Users className="w-3 h-3 text-zinc-500" /> {server.players}/{server.maxPlayers}</span>
                                         <span className="flex items-center gap-1.5"><MapIcon className="w-3 h-3 text-zinc-500" /> {server.mapSize}</span>
                                     </div>
                                     <div className="flex items-center gap-1 text-xs font-bold text-yellow-500 group-hover:underline">
                                         View Details <ArrowRight className="w-3 h-3" />
                                     </div>
                                 </div>
                             </div>
                         </button>
                     ))}
                 </div>
             )}
         </div>

         {/* SECTION 2: ADVERTISE CTA */}
         <div className="bg-gradient-to-r from-orange-900/20 to-red-900/20 border border-orange-500/30 rounded-2xl p-5 flex items-center justify-between relative overflow-hidden group">
             <div className="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')] opacity-10" />
             <div className="relative z-10 flex-1 pr-4">
                 <div className="flex items-center gap-2 mb-1">
                     <Megaphone className="w-4 h-4 text-orange-500" />
                     <h4 className="text-sm font-black text-white uppercase">Server Owner?</h4>
                 </div>
                 <p className="text-[10px] text-zinc-400 leading-relaxed">
                     Get your server listed here and reach thousands of players daily. Boost your population now.
                 </p>
             </div>
             <button 
                onClick={() => setShowContactModal(true)}
                className="relative z-10 bg-orange-600 hover:bg-orange-500 text-white px-4 py-2.5 rounded-xl text-xs font-bold uppercase shadow-lg shadow-orange-900/20 active:scale-95 transition-all whitespace-nowrap"
             >
                 Promote Here
             </button>
         </div>

         {/* SECTION 3: TRENDING */}
         <div>
             <div className="flex items-center gap-2 mb-3">
                 <TrendingUp className="w-4 h-4 text-blue-400" />
                 <span className="text-xs font-bold text-zinc-400 uppercase tracking-widest">Trending Now</span>
             </div>

             <div className="grid grid-cols-2 gap-3">
                 {TRENDING_SERVERS.map((server) => (
                     <button
                        key={server.id}
                        onClick={() => handleServerClick(server)}
                        className="bg-[#121214] border border-zinc-800 rounded-xl overflow-hidden hover:border-zinc-600 transition-all active:scale-[0.98] group text-left"
                     >
                         <div className="h-20 w-full relative">
                             <img src={server.headerImage} alt={server.name} className="w-full h-full object-cover opacity-60 group-hover:opacity-80 transition-opacity" />
                             <div className="absolute bottom-2 left-2 bg-black/60 backdrop-blur px-1.5 py-0.5 rounded text-[9px] font-mono text-white flex items-center gap-1">
                                 <Users className="w-2.5 h-2.5" /> {server.players}
                             </div>
                         </div>
                         <div className="p-3">
                             <h4 className="text-xs font-bold text-white line-clamp-1 mb-1">{server.name}</h4>
                             <span className="text-[9px] text-green-500 font-mono uppercase">Just Wiped</span>
                         </div>
                     </button>
                 ))}
             </div>
         </div>

      </div>

      {/* CONTACT MODAL */}
      {showContactModal && (
          <div className="absolute inset-0 z-50 flex items-end justify-center bg-black/80 backdrop-blur-sm animate-in fade-in duration-200">
              <div 
                className="absolute inset-0" 
                onClick={() => setShowContactModal(false)}
              />
              <div className="w-full bg-[#18181b] border-t border-zinc-800 rounded-t-3xl p-6 shadow-2xl relative z-10 animate-in slide-in-from-bottom duration-300">
                  <div className="w-12 h-1 bg-zinc-700 rounded-full mx-auto mb-6" />
                  
                  <div className="text-center mb-6">
                      <div className="w-16 h-16 bg-orange-900/20 rounded-full flex items-center justify-center border border-orange-500/30 mx-auto mb-4">
                          <Megaphone className="w-8 h-8 text-orange-500" />
                      </div>
                      <h2 className="text-2xl font-black text-white uppercase mb-2">Promote Your Server</h2>
                      <p className="text-zinc-400 text-sm leading-relaxed">
                          Contact our marketing team to book a spotlight slot. Spots are limited and rotate weekly.
                      </p>
                  </div>

                  <div className="space-y-3">
                      <button 
                        onClick={() => window.open('mailto:advertising@raidalarm.app', '_blank')}
                        className="w-full bg-white text-black p-4 rounded-xl flex items-center justify-center gap-3 font-bold uppercase hover:bg-zinc-200 transition-colors"
                      >
                          <Mail className="w-5 h-5" /> Email Us
                      </button>
                      <button 
                        onClick={() => window.open('https://discord.gg/raidalarm', '_blank')}
                        className="w-full bg-[#5865F2] text-white p-4 rounded-xl flex items-center justify-center gap-3 font-bold uppercase hover:bg-[#4752c4] transition-colors"
                      >
                          <MessageCircle className="w-5 h-5" /> Join Discord
                      </button>
                  </div>
                  
                  <button 
                    onClick={() => setShowContactModal(false)}
                    className="w-full mt-4 py-3 text-zinc-500 font-bold text-xs uppercase hover:text-white"
                  >
                      Cancel
                  </button>
              </div>
          </div>
      )}

    </div>
  );
};
