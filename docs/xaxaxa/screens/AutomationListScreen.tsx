
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Plus, 
  Trash2, 
  Zap, 
  Bell, 
  Shield, 
  Power,
  Workflow,
  ArrowRight,
  Box,
  Radio
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface AutomationListScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

interface AutomationRule {
    id: string;
    name: string;
    isActive: boolean;
    trigger: { type: string; label: string; icon: any; };
    action: { type: string; label: string; icon: any; };
}

const INITIAL_RULES: AutomationRule[] = [
    {
        id: '1',
        name: 'Turret Defense',
        isActive: true,
        trigger: { type: 'turret', label: 'Turret Acquires Target', icon: Shield },
        action: { type: 'alarm', label: 'Turn ON Smart Alarm', icon: Bell }
    },
    {
        id: '2',
        name: 'Auto Sorter',
        isActive: false,
        trigger: { type: 'storage', label: 'Drop Box Full', icon: Box },
        action: { type: 'conveyor', label: 'Activate Conveyor', icon: Workflow }
    }
];

export const AutomationListScreen: React.FC<AutomationListScreenProps> = ({ onNavigate }) => {
  const [rules, setRules] = useState<AutomationRule[]>(INITIAL_RULES);

  const toggleRule = (id: string) => {
      setRules(prev => prev.map(r => r.id === id ? { ...r, isActive: !r.isActive } : r));
  };

  const deleteRule = (id: string) => {
      if(confirm('Delete this rule?')) {
          setRules(prev => prev.filter(r => r.id !== id));
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
                <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Automations</h2>
                <div className="flex items-center gap-1.5 text-zinc-500 text-xs font-mono uppercase tracking-wider">
                    <Workflow className="w-3 h-3" /> Smart Logic
                </div>
            </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-4 space-y-4">
          
          {rules.length === 0 && (
              <div className="flex flex-col items-center justify-center py-20 opacity-50">
                  <div className="w-24 h-24 bg-zinc-900 rounded-full flex items-center justify-center border-4 border-zinc-800 border-dashed mb-4">
                      <Workflow className="w-10 h-10 text-zinc-600" />
                  </div>
                  <p className="text-zinc-500 text-sm font-mono uppercase tracking-wider">No Active Rules</p>
                  <p className="text-zinc-600 text-xs mt-1">Create your first automation</p>
              </div>
          )}

          {rules.map((rule) => (
              <div 
                key={rule.id}
                className={`relative bg-[#121214] border rounded-2xl overflow-hidden transition-all duration-300
                    ${rule.isActive ? 'border-red-900/50 shadow-[0_0_20px_rgba(220,38,38,0.05)]' : 'border-zinc-800 opacity-80'}
                `}
              >
                  {/* Active Indicator Line */}
                  <div className={`absolute left-0 top-0 bottom-0 w-1 ${rule.isActive ? 'bg-red-600' : 'bg-zinc-800'}`} />

                  <div className="p-4 pl-5">
                      <div className="flex items-start justify-between mb-4">
                          <h3 className="text-white font-bold text-lg uppercase tracking-wide">{rule.name}</h3>
                          
                          {/* Toggle Switch (Rust Style Red) */}
                          <button 
                            onClick={() => toggleRule(rule.id)}
                            className={`w-12 h-6 rounded-full p-1 transition-colors duration-200 relative ${rule.isActive ? 'bg-red-600' : 'bg-zinc-800'}`}
                          >
                              <div className={`w-4 h-4 bg-white rounded-full shadow-md transition-transform duration-200 ${rule.isActive ? 'translate-x-6' : 'translate-x-0'}`} />
                          </button>
                      </div>

                      {/* Logic Flow Visual */}
                      <div className="flex items-center gap-3 bg-black/20 p-3 rounded-xl border border-white/5 relative">
                          {/* Background Grid for Tech feel */}
                          <div className="absolute inset-0 opacity-5 bg-[linear-gradient(45deg,transparent_25%,rgba(255,255,255,0.2)_25%,rgba(255,255,255,0.2)_50%,transparent_50%,transparent_75%,rgba(255,255,255,0.2)_75%,rgba(255,255,255,0.2)_100%)] bg-[length:10px_10px]" />

                          {/* Trigger */}
                          <div className="flex-1 flex flex-col gap-1 items-start min-w-0 z-10">
                              <div className="flex items-center gap-1.5 text-orange-500 text-[10px] font-bold uppercase">
                                  <Radio className="w-3 h-3" /> IF
                              </div>
                              <div className="text-zinc-300 text-xs font-medium truncate w-full flex items-center gap-2">
                                  <rule.trigger.icon className="w-4 h-4 text-zinc-500 shrink-0" />
                                  <span className="truncate">{rule.trigger.label}</span>
                              </div>
                          </div>

                          {/* Arrow */}
                          <div className="text-zinc-600 z-10">
                              <ArrowRight className="w-4 h-4" />
                          </div>

                          {/* Action */}
                          <div className="flex-1 flex flex-col gap-1 items-end min-w-0 z-10">
                              <div className="flex items-center gap-1.5 text-orange-500 text-[10px] font-bold uppercase">
                                  <Zap className="w-3 h-3" /> THEN
                              </div>
                              <div className="text-zinc-300 text-xs font-medium truncate w-full flex items-center justify-end gap-2">
                                  <span className="truncate text-right">{rule.action.label}</span>
                                  <rule.action.icon className="w-4 h-4 text-zinc-500 shrink-0" />
                              </div>
                          </div>
                      </div>

                      <div className="flex justify-between items-center mt-3">
                          <div className="flex gap-2">
                              <span className="text-[9px] bg-zinc-900 border border-zinc-800 text-zinc-500 px-2 py-1 rounded font-mono uppercase">
                                  Persistent (2x)
                              </span>
                          </div>
                          <button 
                            onClick={() => deleteRule(rule.id)}
                            className="flex items-center gap-1 text-[10px] text-zinc-600 hover:text-red-500 font-bold uppercase transition-colors"
                          >
                              <Trash2 className="w-3 h-3" /> Remove
                          </button>
                      </div>
                  </div>
              </div>
          ))}

      </div>

      {/* FAB: Add New */}
      <div className="absolute bottom-6 right-6 z-20">
          <button 
            onClick={() => onNavigate('AUTOMATION_DETAIL')}
            className="w-14 h-14 rounded-2xl bg-red-600 hover:bg-red-500 text-white shadow-[0_0_30px_rgba(220,38,38,0.4)] flex items-center justify-center transition-transform active:scale-90"
          >
              <Plus className="w-8 h-8" />
          </button>
      </div>

    </div>
  );
};
