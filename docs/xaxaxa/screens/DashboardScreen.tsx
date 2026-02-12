
import React, { useState, useEffect, useRef } from 'react';
import { TYPOGRAPHY } from '../theme';
import { AppState, ScreenName, UpkeepState, TargetPlayer } from '../types';
import { fetchBattleMetrics } from '../utils/api';
import { 
  Shield, 
  Settings, 
  Calculator, 
  Globe, 
} from 'lucide-react';
import { AlarmTab } from '../components/dashboard/AlarmTab';
import { ToolsTab } from '../components/dashboard/ToolsTab';
import { InfoTab } from '../components/dashboard/InfoTab';
import { PlayerDetailSheet } from '../components/player/PlayerDetailSheet';

interface DashboardScreenProps {
  state: AppState;
  onNavigate: (screen: ScreenName) => void;
  onShowInviteModal: (show: boolean) => void;
  showInviteModal: boolean;
  onSimulateJoin: () => void;
  onToggleOnlineStatus: () => void;
  onUpdateUpkeep: (upkeep: UpkeepState) => void;
  onUpdateTargets: (targets: TargetPlayer[]) => void;
  onTargetOffline: (target: TargetPlayer) => void; 
  onViewStats?: (id: string, name: string) => void; // Added Prop
}

type TabType = 'ALARM' | 'TOOLS' | 'INFO';

export const DashboardScreen: React.FC<DashboardScreenProps> = ({ 
  state, 
  onNavigate, 
  onUpdateUpkeep,
  onUpdateTargets,
  onTargetOffline,
  onViewStats
}) => {
  const [activeTab, setActiveTab] = useState<TabType>('ALARM');
  const pollIntervalRef = useRef<number | null>(null);
  
  // Target Selection for Detail Sheet
  const [selectedSheetTarget, setSelectedSheetTarget] = useState<any | null>(null);
  
  const isLocked = state.userRole === 'FREE';

  // --- TARGET TRACKING POLLING (30s Interval) ---
  useEffect(() => {
      const targets = state.trackedTargets;
      if (!targets || targets.length === 0) {
          if (pollIntervalRef.current) clearInterval(pollIntervalRef.current);
          return;
      }

      const checkTargets = async () => {
          const ids = targets.filter(t => t.id).map(t => t.id).join(',');
          if (!ids) return;

          try {
              const response = await fetchBattleMetrics('/players', `?filter[ids]=${ids}&page[size]=100&include=server`);
              
              if (response.data) {
                  const now = new Date();
                  const timeString = now.toLocaleTimeString([], { hour12: false });
                  
                  const updatedTargets = targets.map(t => {
                      const playerData = response.data.find((p: any) => p.id === t.id);
                      if (!playerData) return t; 

                      const serverRel = playerData.relationships?.servers?.data;
                      const isOnline = serverRel && serverRel.length > 0;
                      
                      let lastSeen = t.lastSeen;
                      
                      if (isOnline !== t.isOnline) {
                          lastSeen = isOnline ? 'Online now' : `Left at ${timeString}`;
                          if (t.isOnline && !isOnline) {
                              onTargetOffline({ ...t, isOnline, lastSeen });
                          }
                      } else if (isOnline) {
                          lastSeen = 'Online now';
                      }

                      return { ...t, isOnline, lastSeen };
                  });

                  if (JSON.stringify(updatedTargets) !== JSON.stringify(targets)) {
                      onUpdateTargets(updatedTargets);
                  }
              }
          } catch (err) {
              console.error("Target poll failed", err);
          }
      };

      checkTargets();
      pollIntervalRef.current = window.setInterval(checkTargets, 30000);

      return () => {
          if (pollIntervalRef.current) clearInterval(pollIntervalRef.current);
      };
  }, [state.trackedTargets.length]); 

  // Convert TargetPlayer to the format PlayerDetailSheet expects
  const handleSelectTarget = (target: TargetPlayer) => {
      setSelectedSheetTarget({
          id: target.id || '',
          name: target.name,
          status: target.isOnline ? 'online' : 'offline',
          private: false, // will be updated by sheet fetch
          firstSeen: new Date().toISOString(), // placeholder
          country: 'Unknown'
      });
  };

  const handleTrackUpdate = (name: string, id: string) => {
      // Logic to update tracking (e.g. stop tracking) could go here
      // For now, just close sheet
      setSelectedSheetTarget(null);
  };

  return (
      <div className="flex flex-col h-full bg-zinc-950 relative">
        {/* Unified Header */}
        <div className="h-16 px-4 border-b border-white/5 bg-zinc-950 flex items-center justify-between relative z-20 shrink-0">
          <h1 className={`text-xl text-white flex items-center gap-2 ${TYPOGRAPHY.rustFont}`}>
            RAID ALARM <span className="text-[10px] bg-zinc-800 text-zinc-400 px-1.5 py-0.5 rounded border border-zinc-700 font-mono tracking-normal">V2</span>
          </h1>
          
          <div className="flex items-center gap-1">
             {activeTab === 'ALARM' && (
               <button 
                  onClick={() => onNavigate('SETTINGS')}
                  className="w-10 h-10 flex items-center justify-center text-zinc-400 hover:text-white hover:bg-white/5 rounded-full transition-all"
               >
                   <Settings className="w-5 h-5" />
               </button>
             )}
          </div>
        </div>

        {/* Content Area */}
        <div className="p-4 overflow-y-auto no-scrollbar relative flex-1 pb-24">
            {activeTab === 'ALARM' && (
              <AlarmTab 
                onNavigate={onNavigate}
                isLocked={isLocked}
              />
            )}
            {activeTab === 'TOOLS' && (
              <ToolsTab 
                onNavigate={onNavigate} 
              />
            )}
            {activeTab === 'INFO' && (
              <InfoTab 
                state={state}
                onNavigate={onNavigate}
                onUpdateUpkeep={onUpdateUpkeep}
                onSelectTarget={handleSelectTarget}
              />
            )}
        </div>

        {/* Bottom Navigation Bar */}
        <div className="absolute bottom-0 left-0 right-0 h-20 bg-zinc-950 border-t border-zinc-900 flex items-center justify-around px-2 z-50">
            <button 
                onClick={() => setActiveTab('ALARM')}
                className={`flex flex-col items-center gap-1 p-2 rounded-2xl transition-all w-20
                    ${activeTab === 'ALARM' ? 'text-red-500' : 'text-zinc-600 hover:text-zinc-400'}
                `}
            >
                <div className={`w-10 h-10 rounded-xl flex items-center justify-center transition-all ${activeTab === 'ALARM' ? 'bg-red-500/10' : ''}`}>
                    <Shield className={`w-6 h-6 ${activeTab === 'ALARM' ? 'fill-current' : ''}`} />
                </div>
                <span className="text-[10px] font-bold uppercase tracking-wide">Alarm</span>
            </button>

            <button 
                onClick={() => setActiveTab('TOOLS')}
                className={`flex-col items-center gap-1 p-2 rounded-2xl transition-all w-20 flex
                    ${activeTab === 'TOOLS' ? 'text-cyan-400' : 'text-zinc-600 hover:text-zinc-400'}
                `}
            >
                <div className={`w-10 h-10 rounded-xl flex items-center justify-center transition-all ${activeTab === 'TOOLS' ? 'bg-cyan-500/10' : ''}`}>
                    <Calculator className="w-6 h-6" />
                </div>
                <span className="text-[10px] font-bold uppercase tracking-wide">Tools</span>
            </button>

            <button 
                onClick={() => setActiveTab('INFO')}
                className={`flex flex-col items-center gap-1 p-2 rounded-2xl transition-all w-20
                    ${activeTab === 'INFO' ? 'text-green-500' : 'text-zinc-600 hover:text-zinc-400'}
                `}
            >
                <div className={`w-10 h-10 rounded-xl flex items-center justify-center transition-all ${activeTab === 'INFO' ? 'bg-green-500/10' : ''}`}>
                    <Globe className="w-6 h-6" />
                </div>
                <span className="text-[10px] font-bold uppercase tracking-wide">Info</span>
            </button>
        </div>

        {/* --- DETAIL SHEET OVERLAY --- */}
        {selectedSheetTarget && (
            <PlayerDetailSheet 
                player={selectedSheetTarget}
                loading={false}
                onClose={() => setSelectedSheetTarget(null)}
                onTrack={handleTrackUpdate}
                isFreeUser={state.userRole === 'FREE'}
                onPaywall={() => onNavigate('PAYWALL')}
                onViewStats={onViewStats} // Passed down
            />
        )}

      </div>
  );
};
