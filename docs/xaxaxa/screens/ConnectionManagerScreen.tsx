
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Server, 
  Key, 
  Hash, 
  Wifi, 
  Save, 
  Play,
  HelpCircle
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface ConnectionManagerScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const ConnectionManagerScreen: React.FC<ConnectionManagerScreenProps> = ({ onNavigate }) => {
  // Default values simulating a local test server or what you'd find from the bot
  const [ip, setIp] = useState('127.0.0.1');
  const [port, setPort] = useState('28082'); // Rust+ default port is usually 28082, Game port is 28015
  const [playerId, setPlayerId] = useState('');
  const [playerToken, setPlayerToken] = useState('');
  
  const [status, setStatus] = useState<'IDLE' | 'CONNECTING' | 'SUCCESS' | 'FAILED'>('IDLE');

  const handleConnect = () => {
      setStatus('CONNECTING');
      
      // Simulate Connection Attempt
      setTimeout(() => {
          if (ip && port && playerId && playerToken) {
              setStatus('SUCCESS');
          } else {
              setStatus('FAILED');
          }
      }, 1500);
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-bottom duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center gap-4 bg-[#0c0c0e] z-10">
        <button 
            onClick={() => onNavigate('SETTINGS')}
            className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
        >
            <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
            <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Manual Link</h2>
            <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Developer Access</p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto p-6 space-y-6">
          
          <div className="bg-blue-900/10 border border-blue-500/20 p-4 rounded-xl flex gap-3">
              <HelpCircle className="w-5 h-5 text-blue-400 shrink-0" />
              <p className="text-xs text-blue-200/80 leading-relaxed">
                  If automated pairing fails, you can enter your connection details manually. These can be obtained by analyzing the FCM payload from the official app.
              </p>
          </div>

          {/* Connection Form */}
          <div className="space-y-4">
              
              {/* IP & Port */}
              <div className="grid grid-cols-3 gap-3">
                  <div className="col-span-2 space-y-2">
                      <label className="text-[10px] font-bold text-zinc-500 uppercase flex items-center gap-2">
                          <Server className="w-3 h-3" /> Server IP
                      </label>
                      <input 
                        type="text" 
                        value={ip}
                        onChange={(e) => setIp(e.target.value)}
                        className="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white font-mono text-sm focus:border-orange-500 outline-none"
                        placeholder="192.168.1.50"
                      />
                  </div>
                  <div className="space-y-2">
                      <label className="text-[10px] font-bold text-zinc-500 uppercase flex items-center gap-2">
                          <Hash className="w-3 h-3" /> Port
                      </label>
                      <input 
                        type="text" 
                        value={port}
                        onChange={(e) => setPort(e.target.value)}
                        className="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white font-mono text-sm focus:border-orange-500 outline-none text-center"
                        placeholder="28082"
                      />
                  </div>
              </div>

              {/* Player ID */}
              <div className="space-y-2">
                  <label className="text-[10px] font-bold text-zinc-500 uppercase flex items-center gap-2">
                      <Hash className="w-3 h-3" /> Steam ID (64-bit)
                  </label>
                  <input 
                    type="text" 
                    value={playerId}
                    onChange={(e) => setPlayerId(e.target.value)}
                    className="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white font-mono text-sm focus:border-orange-500 outline-none"
                    placeholder="76561198..."
                  />
              </div>

              {/* Player Token */}
              <div className="space-y-2">
                  <label className="text-[10px] font-bold text-zinc-500 uppercase flex items-center gap-2">
                      <Key className="w-3 h-3" /> Player Token (Integer)
                  </label>
                  <input 
                    type="number" 
                    value={playerToken}
                    onChange={(e) => setPlayerToken(e.target.value)}
                    className="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white font-mono text-sm focus:border-orange-500 outline-none"
                    placeholder="-123456789"
                  />
                  <p className="text-[9px] text-zinc-600">
                      This is the secret key generated when you click "Pair" in-game.
                  </p>
              </div>

          </div>

          {/* Status Display */}
          <div className="border-t border-zinc-800 pt-6">
              {status === 'IDLE' && (
                  <button 
                    onClick={handleConnect}
                    className="w-full py-4 bg-white text-black font-black uppercase rounded-xl flex items-center justify-center gap-2 hover:bg-zinc-200 transition-colors"
                  >
                      <Save className="w-4 h-4" /> Save & Connect
                  </button>
              )}

              {status === 'CONNECTING' && (
                  <div className="w-full py-4 bg-zinc-800 text-zinc-400 font-bold uppercase rounded-xl flex items-center justify-center gap-3 animate-pulse">
                      <Wifi className="w-4 h-4 animate-bounce" /> Negotiating...
                  </div>
              )}

              {status === 'SUCCESS' && (
                  <div className="w-full py-4 bg-green-500 text-black font-black uppercase rounded-xl flex items-center justify-center gap-2 shadow-[0_0_20px_#22c55e]">
                      <Play className="w-4 h-4" /> Socket Connected
                  </div>
              )}

              {status === 'FAILED' && (
                  <div className="w-full py-4 bg-red-900/50 text-red-400 font-bold uppercase rounded-xl flex items-center justify-center gap-2 border border-red-500/50">
                      Connection Refused
                  </div>
              )}
          </div>

      </div>
    </div>
  );
};
