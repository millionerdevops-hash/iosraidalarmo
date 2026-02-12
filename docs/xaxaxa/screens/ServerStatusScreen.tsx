import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName, ServerData } from '../types';
import { ServerSearchManager } from '../components/server/status/ServerSearchManager';
import { ServerDetailManager } from '../components/server/status/ServerDetailManager';

interface ServerStatusScreenProps {
  onNavigate: (screen: ScreenName) => void;
  savedServer: ServerData | null;
  onSaveServer: (server: ServerData | null) => void;
  wipeAlertEnabled: boolean;
  onToggleWipeAlert: (enabled: boolean) => void;
  wipeAlertMinutes?: number;
  onSetWipeAlertMinutes?: (minutes: number) => void;
}

export const ServerStatusScreen: React.FC<ServerStatusScreenProps> = ({ 
  onNavigate, 
  savedServer, 
  onSaveServer,
  wipeAlertEnabled,
  onToggleWipeAlert,
  wipeAlertMinutes = 30,
  onSetWipeAlertMinutes
}) => {
  
  // If we have a saved/selected server, show the Detailed Manager
  if (savedServer) {
      return (
          <ServerDetailManager 
              server={savedServer}
              onBack={() => onSaveServer(null)}
              onSaveServer={onSaveServer}
              wipeAlertEnabled={wipeAlertEnabled}
              onToggleWipeAlert={onToggleWipeAlert}
              wipeAlertMinutes={wipeAlertMinutes}
              onSetWipeAlertMinutes={onSetWipeAlertMinutes}
          />
      );
  }

  // Otherwise, show the Search Manager
  return (
    <div className="flex flex-col h-full bg-[#0c0c0e]">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center gap-4 bg-[#0c0c0e] z-10">
        <button onClick={() => onNavigate('DASHBOARD')} className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
           <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Server Monitor</h2>
           <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Select Server</p>
        </div>
      </div>

      <div className="flex-1 overflow-hidden flex flex-col p-6">
          <ServerSearchManager onSelectServer={onSaveServer} />
      </div>
    </div>
  );
};