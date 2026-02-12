
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Search, 
  Loader2, 
  AlertTriangle,
  History,
  Trash2,
  ShieldCheck
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { fetchSteamProfile } from '../utils/api';

interface CombatSearchScreenProps {
  onNavigate: (screen: ScreenName) => void;
  onViewStats: (id: string, name: string) => void;
}

export const CombatSearchScreen: React.FC<CombatSearchScreenProps> = ({ onNavigate, onViewStats }) => {
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  
  // Recent History
  const [history, setHistory] = useState<{id: string, name: string}[]>(() => {
      try { return JSON.parse(localStorage.getItem('raid_alarm_combat_history') || '[]'); } catch { return []; }
  });

  const addToHistory = (id: string, name: string) => {
      // Avoid duplicates
      const filtered = history.filter(h => h.id !== id);
      const newHistory = [{id, name}, ...filtered].slice(0, 5);
      setHistory(newHistory);
      localStorage.setItem('raid_alarm_combat_history', JSON.stringify(newHistory));
  };

  const clearHistory = () => {
      setHistory([]);
      localStorage.removeItem('raid_alarm_combat_history');
  };

  const handleSearch = async () => {
      let searchTerm = query.trim();
      
      // Basic SteamID Validation
      if (!searchTerm || !/^\d{17}$/.test(searchTerm)) {
          setError("Please enter a valid 17-digit Steam ID.");
          return;
      }

      setLoading(true);
      setError(null);

      try {
          // Direct Steam Call via Proxy
          const profile = await fetchSteamProfile(searchTerm);
          
          if (profile && profile.steamid) {
              const name = profile.personaname || "Unknown User";
              addToHistory(profile.steamid, name);
              onViewStats(profile.steamid, name);
          } else {
              setError("Steam ID not found.");
          }

      } catch (err: any) {
          console.error(err);
          setError(err.message || "Failed to connect to Steam.");
      } finally {
          setLoading(false);
      }
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
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
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Steam Search</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Official Data Source</p>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6">
          
          {/* Search Box */}
          <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-6 mb-6 shadow-lg">
              <div className="text-center mb-6">
                  <div className="w-16 h-16 bg-[#1b2838] rounded-full flex items-center justify-center mx-auto mb-4 border border-zinc-700 shadow-xl">
                      <ShieldCheck className="w-8 h-8 text-[#66c0f4]" />
                  </div>
                  <h3 className="text-white font-bold text-lg mb-2">Check Player</h3>
                  <p className="text-zinc-400 text-xs leading-relaxed max-w-[260px] mx-auto">
                      Enter SteamID64 to view profile status, bans, and rust stats.
                  </p>
              </div>

              <div className="space-y-4">
                  <div className="relative">
                      <input 
                          type="text" 
                          placeholder="e.g. 76561199346057194" 
                          value={query}
                          onChange={(e) => setQuery(e.target.value)}
                          onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
                          className="w-full bg-zinc-900 border border-zinc-700 rounded-xl py-4 pl-4 pr-12 text-white placeholder:text-zinc-600 outline-none focus:border-[#66c0f4] transition-colors font-mono text-sm"
                      />
                      <div className="absolute right-3 top-1/2 -translate-y-1/2">
                          {loading ? (
                              <Loader2 className="w-5 h-5 text-[#66c0f4] animate-spin" />
                          ) : (
                              <Search className="w-5 h-5 text-zinc-500" />
                          )}
                      </div>
                  </div>

                  <button 
                      onClick={handleSearch}
                      disabled={loading || !query}
                      className="w-full py-4 bg-[#66c0f4] hover:bg-[#4b9bc6] text-black font-bold uppercase rounded-xl transition-all active:scale-[0.98] shadow-lg disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                      Check ID
                  </button>
              </div>

              {error && (
                  <div className="mt-4 bg-red-950/20 border border-red-900/30 p-3 rounded-xl flex items-center gap-3 text-red-400 text-xs animate-in slide-in-from-top-2">
                      <AlertTriangle className="w-4 h-4 shrink-0" />
                      {error}
                  </div>
              )}
          </div>

          {/* Recent History */}
          {history.length > 0 && (
              <div>
                  <div className="flex items-center justify-between mb-3 px-1">
                      <h4 className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest flex items-center gap-2">
                          <History className="w-3 h-3" /> Recent Checks
                      </h4>
                      <button onClick={clearHistory} className="text-zinc-600 hover:text-red-500 transition-colors">
                          <Trash2 className="w-3 h-3" />
                      </button>
                  </div>
                  <div className="space-y-2">
                      {history.map((h) => (
                          <button 
                              key={h.id}
                              onClick={() => onViewStats(h.id, h.name)}
                              className="w-full bg-[#18181b] border border-zinc-800 p-3 rounded-xl flex items-center justify-between hover:border-zinc-600 transition-colors group"
                          >
                              <div className="flex flex-col items-start">
                                  <span className="text-white font-bold text-sm">{h.name}</span>
                                  <span className="text-[10px] text-zinc-500 font-mono">ID: {h.id}</span>
                              </div>
                              <div className="w-8 h-8 rounded-lg bg-zinc-900 flex items-center justify-center text-zinc-500 group-hover:text-white transition-colors">
                                  <ArrowLeft className="w-4 h-4 rotate-180" />
                              </div>
                          </button>
                      ))}
                  </div>
              </div>
          )}

      </div>
    </div>
  );
};
