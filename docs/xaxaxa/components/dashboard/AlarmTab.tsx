
import React, { useState } from 'react';
import { Shield } from 'lucide-react';
import { ScreenName } from '../../types';
import { AttackStatsWidget } from './AttackStatsWidget';
import { AttackTrafficWidget } from './AttackTrafficWidget';
import { Button } from '../Button';

interface AlarmTabProps {
  onNavigate: (screen: ScreenName) => void;
  isLocked: boolean;
}

export const AlarmTab: React.FC<AlarmTabProps> = ({ onNavigate, isLocked }) => {
  // Note: Total attacks logic for the Stats widget is kept simulated here.
  const totalAttacks = 1290; 

  return (
      <div className="space-y-4 animate-in fade-in slide-in-from-bottom-2 duration-300 pb-6 pt-2">
          
          {/* CARD 1: ATTACK STATISTICS WIDGET */}
          <AttackStatsWidget 
            totalAttacks={totalAttacks} 
            isLocked={isLocked} 
            onUnlock={() => onNavigate('PAYWALL')} 
          />

          {/* CARD 2: TRAFFIC CHART WIDGET */}
          <AttackTrafficWidget 
            isLocked={isLocked} 
            onUnlock={() => onNavigate('PAYWALL')} 
          />

          {/* ENABLE RAID GUARD BUTTON */}
          <div className="pt-2">
              <Button 
                variant="danger" 
                onClick={() => {}} 
                className="py-4 shadow-[0_0_30px_rgba(220,38,38,0.4)] border-red-500/50 bg-gradient-to-r from-red-800 via-red-600 to-red-800 bg-[length:200%_100%] animate-[shimmer_3s_infinite]"
              >
                  <Shield className="w-5 h-5 mr-2 fill-white/20" /> 
                  <span className="tracking-widest text-sm">ENABLE RAID GUARD</span>
              </Button>
          </div>

      </div>
  );
};
