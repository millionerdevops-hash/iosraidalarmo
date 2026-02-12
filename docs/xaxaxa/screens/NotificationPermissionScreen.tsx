
import React from 'react';
import { ShieldAlert, RefreshCw, Crosshair, ChevronRight, Bell } from 'lucide-react';
import { TYPOGRAPHY, EFFECTS } from '../theme';
import { ScreenName } from '../types';
import { Button } from '../components/Button';

interface NotificationPermissionScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

// Custom Alerts for Raid, Wipe, and Tracking
const MOCK_ALERTS = [
    {
        id: 1,
        title: 'Raid Alert',
        message: 'Your base is under attack!',
        time: 'NOW',
        icon: <ShieldAlert className="w-5 h-5 text-red-500" />,
        color: 'bg-red-500/10 border-red-500/30'
    },
    {
        id: 2,
        title: 'Wipe Incoming',
        message: 'Server wiping in 15 minutes.',
        time: '15m',
        icon: <RefreshCw className="w-5 h-5 text-orange-500" />,
        color: 'bg-orange-500/10 border-orange-500/30'
    },
    {
        id: 3,
        title: 'Target Online',
        message: "Nemesis 'RoofCamper' is now online.",
        time: '2m',
        icon: <Crosshair className="w-5 h-5 text-cyan-400" />,
        color: 'bg-cyan-500/10 border-cyan-500/30'
    }
];

export const NotificationPermissionScreen: React.FC<NotificationPermissionScreenProps> = ({ onNavigate }) => {
  
  const handleAllow = () => {
      // First request standard permissions
      // Then navigate to Critical Alerts request
      onNavigate('CRITICAL_ALERT_PERMISSION'); 
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] relative overflow-hidden font-sans">
      
      {/* 1. VISUAL AREA (Top Half) */}
      <div className="flex-1 relative overflow-hidden pt-12 px-6 flex flex-col justify-center">
          
          {/* Faded Background Elements */}
          <div className="absolute top-0 left-0 right-0 h-32 bg-gradient-to-b from-[#0c0c0e] to-transparent z-10" />

          {/* STATIC NOTIFICATION ICON - TOP CENTER */}
          <div className="flex justify-center mb-8 relative z-20">
              <div className="w-[50px] h-[50px] bg-red-600 rounded-2xl flex items-center justify-center shadow-[0_0_30px_rgba(220,38,38,0.3)] border border-red-500/50">
                  <Bell className="w-6 h-6 text-white fill-white" />
              </div>
          </div>

          <div className="space-y-4 opacity-100 relative z-20">
              {MOCK_ALERTS.map((alert, idx) => (
                  <div 
                    key={alert.id}
                    className={`relative flex items-center gap-4 p-4 rounded-2xl border backdrop-blur-sm ${alert.color} transform transition-transform duration-700 shadow-xl`}
                    style={{ 
                        transform: `scale(${1 - (idx * 0.03)}) translateY(${idx * 5}px)`,
                        opacity: 1 - (idx * 0.1),
                        zIndex: 10 - idx
                    }}
                  >
                      <div className="w-12 h-12 rounded-full bg-[#0c0c0e] flex items-center justify-center border border-white/5 shrink-0 shadow-lg">
                          {alert.icon}
                      </div>
                      <div className="flex-1 min-w-0">
                          <div className="flex justify-between items-center mb-0.5">
                              <h4 className="text-white font-bold text-sm leading-none">{alert.title}</h4>
                              <span className="text-[10px] text-zinc-500 uppercase font-bold">{alert.time}</span>
                          </div>
                          <p className="text-zinc-400 text-xs truncate">{alert.message}</p>
                      </div>
                      <ChevronRight className="w-4 h-4 text-zinc-600" />
                  </div>
              ))}
          </div>

          {/* Gradient Fade to Bottom Content */}
          <div className="absolute bottom-0 left-0 right-0 h-40 bg-gradient-to-t from-[#0c0c0e] via-[#0c0c0e] to-transparent z-10" />
      </div>

      {/* 2. ACTION AREA (Bottom Half) */}
      <div className="p-8 pb-10 z-30 relative bg-[#0c0c0e] flex flex-col items-center text-center">
          
          <h2 className={`text-2xl text-white mb-3 ${TYPOGRAPHY.rustFont}`}>
              Total Awareness
          </h2>
          
          <p className="text-zinc-400 text-sm leading-relaxed mb-10 max-w-xs">
              Enable notifications to receive critical alerts for <span className="text-white font-bold">Raids</span>, <span className="text-white font-bold">Wipes</span>, and <span className="text-white font-bold">Targets</span>.
          </p>

          <Button 
            onClick={handleAllow}
            className={`w-full ${EFFECTS.glowRed}`}
          >
              Allow 3 Alerts
          </Button>

      </div>

    </div>
  );
};
