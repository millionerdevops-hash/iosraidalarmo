
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Terminal, 
  Cpu, 
  Activity, 
  Wifi, 
  ShieldCheck, 
  Lock, 
  Unlock, 
  Database,
  Code2
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface NativeMockupScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// Simulating the Proto structure provided by user
interface AppMessage {
    seq: number;
    type: 'response' | 'broadcast';
    payload: string;
    size: number;
}

export const NativeMockupScreen: React.FC<NativeMockupScreenProps> = ({ onNavigate }) => {
  const [log, setLog] = useState<AppMessage[]>([]);
  const [isConnected, setIsConnected] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  // Auto-scroll log
  useEffect(() => {
      if (scrollRef.current) {
          scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
      }
  }, [log]);

  // Simulation Loop
  useEffect(() => {
      let step = 0;
      const interval = setInterval(() => {
          step++;
          
          if (step === 1) {
              setIsConnected(true);
              addLog('response', 'AppSuccess { }', 0);
          }
          if (step === 2) {
              addLog('broadcast', 'AppEntityChanged { entityId: 4921, payload: { value: true } }', 12);
          }
          if (step === 4) {
              addLog('response', 'AppInfo { name: "Rustoria Main", players: 642, mapSize: 4500 }', 86);
          }
          if (step === 6) {
              addLog('broadcast', 'AppTeamChanged { playerId: 76561198..., teamInfo: { members: 4 } }', 124);
          }
          if (step === 9) {
              addLog('broadcast', 'AppNewTeamMessage { message: { name: "Leader", message: "On my way" } }', 45);
          }
          
          // Keep alive
          if (step > 10 && step % 5 === 0) {
              addLog('response', 'AppTime { time: 14.5, dayLength: 60 }', 16);
          }

      }, 1500);

      return () => clearInterval(interval);
  }, []);

  const addLog = (type: 'response' | 'broadcast', payload: string, size: number) => {
      setLog(prev => [...prev, { seq: prev.length + 1, type, payload, size }]);
  };

  return (
    <div className="flex flex-col h-full bg-[#0a0a0a] font-mono text-xs relative overflow-hidden">
      
      {/* Matrix-like Background */}
      <div className="absolute inset-0 opacity-5 pointer-events-none" 
           style={{ backgroundImage: 'linear-gradient(0deg, transparent 24%, rgba(34, 197, 94, .3) 25%, rgba(34, 197, 94, .3) 26%, transparent 27%, transparent 74%, rgba(34, 197, 94, .3) 75%, rgba(34, 197, 94, .3) 76%, transparent 77%, transparent), linear-gradient(90deg, transparent 24%, rgba(34, 197, 94, .3) 25%, rgba(34, 197, 94, .3) 26%, transparent 27%, transparent 74%, rgba(34, 197, 94, .3) 75%, rgba(34, 197, 94, .3) 76%, transparent 77%, transparent)', backgroundSize: '50px 50px' }} 
      />

      {/* Header */}
      <div className="p-4 border-b border-zinc-800 bg-[#0c0c0e] z-10 flex justify-between items-center">
          <div className="flex items-center gap-3">
              <button 
                  onClick={() => onNavigate('DASHBOARD')}
                  className="p-2 text-zinc-500 hover:text-green-500 transition-colors"
              >
                  <ArrowLeft className="w-5 h-5" />
              </button>
              <div>
                  <h2 className="text-green-500 font-bold text-sm tracking-wider flex items-center gap-2">
                      <Terminal className="w-4 h-4" /> NATIVE PROTOCOL
                  </h2>
                  <div className="flex items-center gap-2 text-[10px] text-zinc-500">
                      <span>rustplus.proto</span>
                      <span className="text-zinc-700">•</span>
                      <span>TCP/28015</span>
                  </div>
              </div>
          </div>
          
          <div className={`px-2 py-1 rounded border flex items-center gap-2 ${isConnected ? 'bg-green-900/20 border-green-500/30 text-green-500' : 'bg-red-900/20 border-red-500/30 text-red-500'}`}>
              <Wifi className="w-3 h-3" />
              <span className="font-bold uppercase text-[9px]">{isConnected ? 'CONNECTED' : 'OFFLINE'}</span>
          </div>
      </div>

      {/* Main Console Area */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4" ref={scrollRef}>
          
          {/* Intro Block */}
          <div className="text-zinc-500 mb-6">
              <p>{'>'} Loading definitions from <span className="text-white">rustplus.proto</span>...</p>
              <p>{'>'} Compiling <span className="text-blue-400">AppRequest</span> schema... OK</p>
              <p>{'>'} Compiling <span className="text-blue-400">AppMessage</span> schema... OK</p>
              <p>{'>'} Initializing TCP Socket connection...</p>
          </div>

          {/* Messages */}
          {log.map((msg, idx) => (
              <div key={idx} className="animate-in slide-in-from-left-2 duration-300">
                  <div className="flex items-center gap-2 mb-1 opacity-50">
                      <span className="text-zinc-600">#{msg.seq.toString().padStart(4, '0')}</span>
                      <span className="text-[10px] uppercase tracking-wider text-zinc-500">
                          {msg.type === 'broadcast' ? '<-- BROADCAST' : '<-- RESPONSE'}
                      </span>
                      <span className="ml-auto text-zinc-700">{msg.size}b</span>
                  </div>
                  <div className={`p-3 rounded border font-mono break-all
                      ${msg.type === 'broadcast' 
                          ? 'bg-yellow-900/10 border-yellow-500/20 text-yellow-100' 
                          : 'bg-zinc-900 border-zinc-800 text-zinc-300'}
                  `}>
                      {highlightProto(msg.payload)}
                  </div>
              </div>
          ))}

          {/* Blinking Cursor */}
          <div className="h-4 w-2 bg-green-500 animate-pulse mt-2" />
      </div>

      {/* Footer Info */}
      <div className="p-3 border-t border-zinc-800 bg-[#0c0c0e] text-[10px] text-zinc-500 flex justify-between items-center">
          <div className="flex gap-4">
              <span className="flex items-center gap-1"><Code2 className="w-3 h-3" /> Proto3</span>
              <span className="flex items-center gap-1"><Database className="w-3 h-3" /> No Ext. Libs</span>
          </div>
          <div className="flex items-center gap-1 text-zinc-400">
              <Activity className="w-3 h-3 text-green-500" /> Direct Stream
          </div>
      </div>

    </div>
  );
};

// Helper to syntax highlight the proto text
const highlightProto = (text: string) => {
    // Basic highlighting for demo
    const parts = text.split(/({|}|:)/g);
    return (
        <span>
            {parts.map((part, i) => {
                if (part === '{' || part === '}') return <span key={i} className="text-zinc-500">{part}</span>;
                if (part === ':') return <span key={i} className="text-zinc-600 mr-1">{part}</span>;
                if (part.includes('App')) return <span key={i} className="text-blue-400 font-bold">{part}</span>;
                if (!isNaN(Number(part.trim()))) return <span key={i} className="text-purple-400">{part}</span>;
                if (part.includes('"')) return <span key={i} className="text-green-400">{part}</span>;
                if (part.trim() === 'true' || part.trim() === 'false') return <span key={i} className="text-orange-400">{part}</span>;
                return <span key={i}>{part}</span>;
            })}
        </span>
    );
};
