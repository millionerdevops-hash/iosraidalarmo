
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Save, 
  Shield, 
  Bell, 
  Zap, 
  Box, 
  Power, 
  Radio, 
  Clock, 
  AlertTriangle,
  ChevronDown
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';
import { Button } from '../components/Button';

interface AutomationDetailScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const AutomationDetailScreen: React.FC<AutomationDetailScreenProps> = ({ onNavigate }) => {
  const [name, setName] = useState('');
  const [triggerDevice, setTriggerDevice] = useState('');
  const [actionDevice, setActionDevice] = useState('');
  const [autoOff, setAutoOff] = useState(false);
  const [threshold, setThreshold] = useState(1);

  // Mock Options
  const DEVICES = [
      { id: 'turret', label: 'Auto Turret', icon: Shield },
      { id: 'switch', label: 'Smart Switch', icon: Zap },
      { id: 'alarm', label: 'Smart Alarm', icon: Bell },
      { id: 'storage', label: 'Storage Monitor', icon: Box },
      { id: 'sensor', label: 'HBHF Sensor', icon: Radio },
  ];

  const handleSave = () => {
      // In a real app, this would save to state/db
      onNavigate('AUTOMATION_LIST');
  };

  return (
    <div className="flex flex-col h-full bg-[#0c0c0e] animate-in slide-in-from-right duration-300 relative">
      
      {/* Header */}
      <div className="p-4 pt-6 border-b border-white/5 flex items-center justify-between bg-[#0c0c0e] z-10 shrink-0">
        <div className="flex items-center gap-4">
            <button 
                onClick={() => onNavigate('AUTOMATION_LIST')}
                className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white transition-colors"
            >
                <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>New Rule</h2>
                <p className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Logic Builder</p>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-6 space-y-8">
          
          {/* 1. Name */}
          <div className="space-y-3">
              <label className="text-[10px] text-zinc-500 font-bold uppercase tracking-widest block pl-1">1. Rule Name</label>
              <input 
                type="text" 
                placeholder="e.g. Base Lockdown" 
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full bg-[#121214] border border-zinc-800 rounded-xl p-4 text-white placeholder:text-zinc-600 outline-none focus:border-red-500/50 transition-colors"
              />
          </div>

          {/* 2. Trigger (IF) */}
          <div className="space-y-3">
              <label className="text-[10px] text-orange-500 font-bold uppercase tracking-widest block pl-1">2. Trigger (IF)</label>
              <div className="relative">
                  <select 
                    value={triggerDevice}
                    onChange={(e) => setTriggerDevice(e.target.value)}
                    className="w-full bg-[#121214] border border-zinc-800 rounded-xl p-4 text-white outline-none appearance-none focus:border-orange-500/50"
                  >
                      <option value="" disabled>Select Device</option>
                      {DEVICES.map(d => <option key={d.id} value={d.id}>{d.label}</option>)}
                  </select>
                  <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-zinc-500 pointer-events-none" />
              </div>
              
              {/* Dynamic Condition Options based on Trigger */}
              {triggerDevice && (
                  <div className="grid grid-cols-2 gap-3 animate-in fade-in slide-in-from-top-2">
                      <button className="bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-left hover:border-orange-500/50 active:bg-zinc-800 transition-colors">
                          <span className="text-xs font-bold text-white block">Turns ON</span>
                          <span className="text-[9px] text-zinc-500 uppercase">Power State</span>
                      </button>
                      <button className="bg-zinc-900 border border-zinc-800 p-3 rounded-xl text-left hover:border-orange-500/50 active:bg-zinc-800 transition-colors">
                          <span className="text-xs font-bold text-white block">Has Target</span>
                          <span className="text-[9px] text-zinc-500 uppercase">Sensor Data</span>
                      </button>
                  </div>
              )}
          </div>

          {/* 3. Action (THEN) */}
          <div className="space-y-3">
              <label className="text-[10px] text-red-500 font-bold uppercase tracking-widest block pl-1">3. Action (THEN)</label>
              <div className="relative">
                  <select 
                    value={actionDevice}
                    onChange={(e) => setActionDevice(e.target.value)}
                    className="w-full bg-[#121214] border border-zinc-800 rounded-xl p-4 text-white outline-none appearance-none focus:border-red-500/50"
                  >
                      <option value="" disabled>Select Device</option>
                      {DEVICES.map(d => <option key={d.id} value={d.id}>{d.label}</option>)}
                  </select>
                  <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-zinc-500 pointer-events-none" />
              </div>
          </div>

          {/* 4. Advanced */}
          <div className="space-y-3">
              <label className="text-[10px] text-zinc-500 font-bold uppercase tracking-widest block pl-1">4. Advanced Options</label>
              <div className="bg-[#121214] border border-zinc-800 rounded-xl p-4 space-y-4">
                  
                  {/* Auto Off Toggle */}
                  <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                          <div className="w-8 h-8 rounded-lg bg-zinc-900 flex items-center justify-center text-zinc-500">
                              <Clock className="w-4 h-4" />
                          </div>
                          <div>
                              <div className="text-sm font-bold text-white">Auto-Off</div>
                              <div className="text-[10px] text-zinc-500">Reverse action when trigger stops</div>
                          </div>
                      </div>
                      <button 
                        onClick={() => setAutoOff(!autoOff)}
                        className={`w-12 h-6 rounded-full p-1 transition-colors duration-200 relative ${autoOff ? 'bg-orange-500' : 'bg-zinc-800'}`}
                      >
                          <div className={`w-4 h-4 bg-white rounded-full shadow-md transition-transform duration-200 ${autoOff ? 'translate-x-6' : 'translate-x-0'}`} />
                      </button>
                  </div>

                  <div className="h-px bg-zinc-800 w-full" />

                  {/* Threshold Counter */}
                  <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                          <div className="w-8 h-8 rounded-lg bg-zinc-900 flex items-center justify-center text-zinc-500">
                              <AlertTriangle className="w-4 h-4" />
                          </div>
                          <div>
                              <div className="text-sm font-bold text-white">Trigger Threshold</div>
                              <div className="text-[10px] text-zinc-500">How many hits before activation</div>
                          </div>
                      </div>
                      <div className="flex items-center gap-3">
                          <button onClick={() => setThreshold(Math.max(1, threshold-1))} className="w-8 h-8 rounded-full bg-zinc-900 text-zinc-400 hover:text-white flex items-center justify-center">-</button>
                          <span className="text-white font-mono font-bold">{threshold}</span>
                          <button onClick={() => setThreshold(threshold+1)} className="w-8 h-8 rounded-full bg-zinc-900 text-zinc-400 hover:text-white flex items-center justify-center">+</button>
                      </div>
                  </div>

              </div>
          </div>

          <div className="h-10" />
      </div>

      {/* Footer Save */}
      <div className="p-4 bg-[#0c0c0e] border-t border-zinc-800 pb-8 shrink-0">
          <Button onClick={handleSave} className="bg-red-600 hover:bg-red-500 border-red-500 shadow-lg shadow-red-900/40">
              <Save className="w-5 h-5 mr-2" />
              Save Automation
          </Button>
      </div>

    </div>
  );
};
