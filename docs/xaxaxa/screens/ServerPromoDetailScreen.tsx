
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Map as MapIcon, 
  Users, 
  Globe, 
  ShoppingCart, 
  MessageCircle, 
  Zap, 
  Calendar,
  Shield,
  Copy,
  Check,
  Server,
  Youtube,
  Clock,
  Box,
  Hammer,
  Anchor,
  Leaf,
  Layers
} from 'lucide-react';
import { ServerData } from '../types';
import { TYPOGRAPHY } from '../theme';
import { Button } from '../components/Button';

interface ServerPromoDetailScreenProps {
  server: ServerData;
  onBack: () => void;
  onMonitor: () => void;
}

export const ServerPromoDetailScreen: React.FC<ServerPromoDetailScreenProps> = ({ 
  server, 
  onBack,
  onMonitor
}) => {
  const [copied, setCopied] = useState(false);

  const copyIp = () => {
      if (!server.ip || !server.port) return;
      navigator.clipboard.writeText(`client.connect ${server.ip}:${server.port}`);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
  };

  const details = server.promoDetails || {};

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* 1. HERO HEADER */}
      <div className="relative h-72 shrink-0">
          {/* Background Image */}
          <div className="absolute inset-0">
              <img 
                src={server.headerImage || "https://files.facepunch.com/paddy/20240206/jungle_ruins_header.jpg"} 
                alt={server.name} 
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-b from-black/60 via-transparent to-[#0c0c0e]" />
          </div>

          {/* Navigation */}
          <button 
            onClick={onBack}
            className="absolute top-6 left-4 w-10 h-10 rounded-full bg-black/40 backdrop-blur-md flex items-center justify-center text-white hover:bg-black/60 transition-all z-20 border border-white/10"
          >
              <ArrowLeft className="w-5 h-5" />
          </button>

          {/* Title Area */}
          <div className="absolute bottom-0 left-0 right-0 p-6 pt-12 bg-gradient-to-t from-[#0c0c0e] via-[#0c0c0e]/80 to-transparent">
              <div className="flex items-center gap-2 mb-2">
                  <div className={`px-2 py-0.5 rounded text-[10px] font-black uppercase tracking-wider flex items-center gap-1.5 ${server.status === 'online' ? 'bg-green-500/20 text-green-400 border border-green-500/30' : 'bg-red-500 text-white'}`}>
                      <div className={`w-1.5 h-1.5 rounded-full ${server.status === 'online' ? 'bg-green-400 animate-pulse' : 'bg-red-200'}`} />
                      {server.status === 'online' ? 'ONLINE' : 'OFFLINE'}
                  </div>
                  {server.country && (
                      <div className="px-2 py-0.5 rounded bg-zinc-800 border border-zinc-700 text-zinc-300 text-[10px] font-bold uppercase tracking-wider">
                          {server.country} Region
                      </div>
                  )}
              </div>
              <h1 className="text-2xl font-black text-white leading-tight drop-shadow-lg shadow-black mb-1">
                  {server.name}
              </h1>
              <div className="flex items-center gap-2 text-zinc-400 text-xs font-mono">
                  <span className="text-orange-500 font-bold">{server.players}/{server.maxPlayers}</span> Players Online
              </div>
          </div>
      </div>

      {/* 2. MAIN CONTENT SCROLL */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-5 pt-0 space-y-6">
          
          {/* IP ADDRESS BAR */}
          <button 
              onClick={copyIp}
              className="w-full bg-[#18181b] border border-zinc-800 p-1 pr-4 rounded-xl flex items-center justify-between group active:scale-[0.98] transition-all hover:border-zinc-700"
          >
              <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-lg bg-zinc-900 flex items-center justify-center border border-zinc-800">
                      <Globe className="w-5 h-5 text-zinc-400 group-hover:text-white transition-colors" />
                  </div>
                  <div className="text-left">
                      <div className="text-[9px] font-bold text-zinc-500 uppercase tracking-wider">Server IP</div>
                      <div className="text-xs font-mono text-white font-bold">{server.ip}:{server.port}</div>
                  </div>
              </div>
              <div className={`text-[10px] font-bold uppercase transition-colors px-3 py-1.5 rounded-lg border ${copied ? 'bg-green-500/10 border-green-500/30 text-green-500' : 'bg-zinc-800 border-zinc-700 text-zinc-400 group-hover:text-white'}`}>
                  {copied ? 'COPIED' : 'COPY'}
              </div>
          </button>

          {/* SERVER SETTINGS GRID */}
          <div className="space-y-2">
              <h3 className="text-[10px] font-black text-zinc-500 uppercase tracking-widest pl-1">Server Settings</h3>
              <div className="grid grid-cols-2 gap-2">
                  <div className="bg-[#18181b] border border-zinc-800 p-3 rounded-xl flex items-center gap-3">
                      <div className="w-8 h-8 rounded bg-yellow-500/10 flex items-center justify-center text-yellow-500">
                          <Zap className="w-4 h-4" />
                      </div>
                      <div>
                          <div className="text-[9px] text-zinc-500 font-bold uppercase">Rate</div>
                          <div className="text-white font-bold text-xs">{details.rates || '1x'}</div>
                      </div>
                  </div>
                  <div className="bg-[#18181b] border border-zinc-800 p-3 rounded-xl flex items-center gap-3">
                      <div className="w-8 h-8 rounded bg-blue-500/10 flex items-center justify-center text-blue-500">
                          <Users className="w-4 h-4" />
                      </div>
                      <div>
                          <div className="text-[9px] text-zinc-500 font-bold uppercase">Limit</div>
                          <div className="text-white font-bold text-xs">{details.groupLimit || 'Unknown'}</div>
                      </div>
                  </div>
                  <div className="bg-[#18181b] border border-zinc-800 p-3 rounded-xl flex items-center gap-3">
                      <div className="w-8 h-8 rounded bg-purple-500/10 flex items-center justify-center text-purple-500">
                          <Box className="w-4 h-4" />
                      </div>
                      <div>
                          <div className="text-[9px] text-zinc-500 font-bold uppercase">Kits</div>
                          <div className="text-white font-bold text-xs">{details.kits || 'None'}</div>
                      </div>
                  </div>
                  <div className="bg-[#18181b] border border-zinc-800 p-3 rounded-xl flex items-center gap-3">
                      <div className="w-8 h-8 rounded bg-green-500/10 flex items-center justify-center text-green-500">
                          <Leaf className="w-4 h-4" />
                      </div>
                      <div>
                          <div className="text-[9px] text-zinc-500 font-bold uppercase">Upkeep</div>
                          <div className="text-white font-bold text-xs">{details.upkeep || '100%'}</div>
                      </div>
                  </div>
              </div>
          </div>

          {/* WIPE SCHEDULE */}
          {details.wipeSchedule && (
              <div className="bg-gradient-to-br from-orange-900/20 to-zinc-900 border border-orange-500/20 rounded-2xl p-4 relative overflow-hidden">
                  <div className="absolute right-0 top-0 p-3 opacity-10">
                      <Calendar className="w-20 h-20 text-orange-500" />
                  </div>
                  <div className="relative z-10">
                      <div className="flex items-center gap-2 mb-3">
                          <Clock className="w-4 h-4 text-orange-500" />
                          <span className="text-xs font-bold text-orange-400 uppercase tracking-widest">Wipe Schedule</span>
                      </div>
                      <div className="space-y-2">
                          {details.wipeSchedule.map((line, i) => (
                              <div key={i} className="flex gap-2 items-start">
                                  <div className="w-1.5 h-1.5 rounded-full bg-orange-500 mt-1.5 shrink-0" />
                                  <p className="text-zinc-300 text-xs leading-relaxed">{line}</p>
                              </div>
                          ))}
                      </div>
                  </div>
              </div>
          )}

          {/* MAP INFO */}
          <div className="bg-[#18181b] border border-zinc-800 rounded-2xl overflow-hidden">
              <div className="p-3 border-b border-zinc-800/50 bg-black/20 flex items-center justify-between">
                  <span className="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Map Information</span>
                  <a href={`https://rustmaps.com/map/${server.mapSize}_${server.seed}`} target="_blank" rel="noreferrer" className="text-[10px] text-blue-400 hover:underline">
                      View Full Map
                  </a>
              </div>
              <div className="p-4 flex gap-4">
                  <div className="w-20 h-20 bg-zinc-900 rounded-lg border border-zinc-700 flex items-center justify-center shrink-0 overflow-hidden relative">
                      <img src="https://rustmaps.com/img/prefabs/monuments/sphere_tank.png" className="w-full h-full object-cover opacity-50" alt="" />
                      <div className="absolute inset-0 flex items-center justify-center">
                          <MapIcon className="w-6 h-6 text-zinc-500" />
                      </div>
                  </div>
                  <div className="flex-1 grid grid-cols-2 gap-y-3">
                      <div>
                          <span className="text-[9px] text-zinc-500 font-bold uppercase block">Size</span>
                          <span className="text-sm font-mono font-bold text-white">{server.mapSize}</span>
                      </div>
                      <div>
                          <span className="text-[9px] text-zinc-500 font-bold uppercase block">Seed</span>
                          <span className="text-sm font-mono font-bold text-white">{server.seed}</span>
                      </div>
                      <div>
                          <span className="text-[9px] text-zinc-500 font-bold uppercase block">Entities</span>
                          <span className="text-sm font-mono font-bold text-zinc-400">{server.entities ? (server.entities / 1000).toFixed(0) + 'k' : 'N/A'}</span>
                      </div>
                      <div>
                          <span className="text-[9px] text-zinc-500 font-bold uppercase block">Monuments</span>
                          <span className="text-sm font-mono font-bold text-zinc-400">{details.monuments || 0}</span>
                      </div>
                  </div>
              </div>
          </div>

          {/* FEATURES LIST */}
          {details.features && (
              <div className="space-y-2">
                  <h3 className="text-[10px] font-black text-zinc-500 uppercase tracking-widest pl-1">Server Features</h3>
                  <div className="bg-[#18181b] border border-zinc-800 rounded-xl p-4">
                      <div className="grid grid-cols-1 gap-2">
                          {details.features.map((feat, i) => (
                              <div key={i} className="flex items-center gap-2">
                                  <Check className="w-3.5 h-3.5 text-green-500" />
                                  <span className="text-zinc-300 text-xs">{feat}</span>
                              </div>
                          ))}
                      </div>
                  </div>
              </div>
          )}

          {/* SOCIAL LINKS */}
          {details.socials && (
              <div className="grid grid-cols-4 gap-2">
                  {details.socials.discord && (
                      <button 
                        onClick={() => window.open(details.socials?.discord, '_blank')}
                        className="bg-[#5865F2]/10 border border-[#5865F2]/20 p-3 rounded-xl flex flex-col items-center justify-center gap-1 hover:bg-[#5865F2]/20 transition-colors"
                      >
                          <MessageCircle className="w-5 h-5 text-[#5865F2]" />
                          <span className="text-[9px] font-bold text-[#5865F2] uppercase mt-1">Discord</span>
                      </button>
                  )}
                  {details.socials.store && (
                      <button 
                        onClick={() => window.open(details.socials?.store, '_blank')}
                        className="bg-yellow-500/10 border border-yellow-500/20 p-3 rounded-xl flex flex-col items-center justify-center gap-1 hover:bg-yellow-500/20 transition-colors"
                      >
                          <ShoppingCart className="w-5 h-5 text-yellow-500" />
                          <span className="text-[9px] font-bold text-yellow-500 uppercase mt-1">Store</span>
                      </button>
                  )}
                  {details.socials.youtube && (
                      <button 
                        onClick={() => window.open(details.socials?.youtube, '_blank')}
                        className="bg-red-600/10 border border-red-600/20 p-3 rounded-xl flex flex-col items-center justify-center gap-1 hover:bg-red-600/20 transition-colors"
                      >
                          <Youtube className="w-5 h-5 text-red-500" />
                          <span className="text-[9px] font-bold text-red-500 uppercase mt-1">Youtube</span>
                      </button>
                  )}
                  {details.socials.website && (
                      <button 
                        onClick={() => window.open(details.socials?.website, '_blank')}
                        className="bg-zinc-800/50 border border-zinc-700 p-3 rounded-xl flex flex-col items-center justify-center gap-1 hover:bg-zinc-800 transition-colors"
                      >
                          <Anchor className="w-5 h-5 text-zinc-400" />
                          <span className="text-[9px] font-bold text-zinc-400 uppercase mt-1">Web</span>
                      </button>
                  )}
              </div>
          )}

          {/* Description Text */}
          <div className="p-4 bg-[#18181b] border border-zinc-800 rounded-xl">
              <p className="text-zinc-400 text-xs leading-relaxed whitespace-pre-wrap">
                  {server.description}
              </p>
          </div>

          <div className="h-10" />
      </div>

      {/* 3. FOOTER: MONITOR ACTION */}
      <div className="p-4 bg-[#0c0c0e] border-t border-zinc-800 pb-8 shrink-0">
          <Button onClick={onMonitor} className="h-14 shadow-[0_0_30px_rgba(220,38,38,0.2)]">
              <Server className="w-5 h-5 mr-2" />
              Monitor in Raid Alarm
          </Button>
          <p className="text-center text-[10px] text-zinc-600 mt-3">
              Get notified for wipes, queue changes, and player activity.
          </p>
      </div>

    </div>
  );
};
