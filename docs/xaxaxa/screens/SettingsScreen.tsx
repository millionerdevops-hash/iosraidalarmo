
import React, { useState, useEffect } from 'react';
import { 
  ArrowLeft, 
  ChevronRight, 
  FileText, 
  Shield,
  AlertTriangle,
  Copy,
  Check,
  X,
  Terminal,
  Wifi,
  Smartphone,
  Server,
  Plus,
  Globe,
  Database,
  Sparkles,
  Heart,
  Bell
} from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName, AppState } from '../types';
import { AlarmModeWidget } from '../components/settings/AlarmModeWidget';
import { FakeCallWidget } from '../components/settings/FakeCallWidget';
import { SubscriptionWidget } from '../components/settings/SubscriptionWidget';

interface SettingsScreenProps {
  onNavigate: (screen: ScreenName) => void;
  state: AppState;
}

export const SettingsScreen: React.FC<SettingsScreenProps> = ({ onNavigate, state }) => {
  // Team Management State
  const [members, setMembers] = useState(() => 
    Array.from({ length: Math.max(0, state.currentMembers - 1) }).map((_, i) => ({
      id: i + 1,
      name: `Operator_${8492 + i}`,
      role: 'MEMBER',
      joined: `${i + 2}d ago`,
      status: 'offline'
    }))
  );
  
  const [kickMemberId, setKickMemberId] = useState<number | null>(null);
  const [showInviteModal, setShowInviteModal] = useState(false);
  const [showPairingModal, setShowPairingModal] = useState(false); 
  const [copied, setCopied] = useState(false);
  const [showDebugLog, setShowDebugLog] = useState(false);
  
  const inviteCode = "RUSTGOD"; 

  const isFree = state.userRole === 'FREE';

  // Sync local members with global state if it changes (e.g. simulation)
  useEffect(() => {
    const totalMembers = state.currentMembers;
    const listCount = Math.max(0, totalMembers - 1);
    
    setMembers(prev => {
        if (prev.length === listCount) return prev;
        
        if (listCount > prev.length) {
            // Member joined
            const newMembers = Array.from({ length: listCount - prev.length }).map((_, i) => ({
                id: prev.length + i + 2, 
                name: `Operator_${9000 + Math.floor(Math.random()*999)}`,
                role: 'MEMBER',
                joined: 'Just now',
                status: 'online'
            }));
            return [...prev, ...newMembers];
        } else {
            // Member left/kicked
            return prev.slice(0, listCount);
        }
    });
  }, [state.currentMembers]);

  const handleKickMember = () => {
    if (kickMemberId !== null) {
        setMembers(prev => prev.filter(m => m.id !== kickMemberId));
        setKickMemberId(null);
    }
  };

  const copyToClipboard = () => {
      navigator.clipboard.writeText(inviteCode);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
  };

  const handlePaywall = () => onNavigate('PAYWALL');

  return (
    <div className="flex flex-col h-full bg-zinc-950 text-white relative">
      {/* Unified Header */}
      <div className="h-16 px-4 border-b border-white/5 bg-zinc-950 flex items-center gap-4 relative z-20 shrink-0">
        <button 
            onClick={() => onNavigate('DASHBOARD')} 
            className="w-10 h-10 flex items-center justify-center -ml-2 text-zinc-400 hover:text-white hover:bg-white/5 rounded-full transition-all"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h2 className={`text-xl text-white ${TYPOGRAPHY.rustFont}`}>Settings</h2>
      </div>

      <div className="flex-1 overflow-y-auto p-4 space-y-6 pb-20">
        
        {/* --- SUBSCRIPTION & SQUAD WIDGET --- */}
        <SubscriptionWidget 
            plan={state.plan}
            userRole={state.userRole}
            teamSize={state.teamSize}
            currentMemberCount={members.length + 1} // +1 for self
            members={members}
            onPaywall={handlePaywall}
            onInvite={() => setShowInviteModal(true)}
            onKick={(id) => setKickMemberId(id)}
        />

        {/* --- SPECIAL OFFER BUTTON (FOR RETENTION) --- */}
        {isFree && (
            <button
                onClick={() => onNavigate('RETENTION_DISCOUNT')}
                className="w-full bg-gradient-to-r from-red-900/40 to-black border border-red-500/50 p-4 rounded-2xl flex items-center justify-between group active:scale-[0.98] transition-all shadow-[0_0_20px_rgba(220,38,38,0.1)] relative overflow-hidden"
            >
                <div className="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')] opacity-10 pointer-events-none" />
                <div className="flex items-center gap-4 z-10">
                    <div className="w-10 h-10 rounded-full bg-red-600 flex items-center justify-center animate-pulse">
                        <Sparkles className="w-5 h-5 text-white" />
                    </div>
                    <div className="text-left">
                        <h3 className="font-black text-base text-white uppercase tracking-wide">Special Offer</h3>
                        <p className="text-red-400 text-xs font-bold">Limited Time Discount Available</p>
                    </div>
                </div>
                <ChevronRight className="w-5 h-5 text-zinc-500 group-hover:text-white transition-colors z-10" />
            </button>
        )}

        {/* --- RUST+ CONNECTION SETTINGS --- */}
        <div>
            <h3 className="text-zinc-500 text-xs font-bold uppercase tracking-widest mb-3 pl-2">Rust+ Connection</h3>
            <div className="bg-[#121214] border border-zinc-800 rounded-2xl overflow-hidden">
                
                {/* Steam Login Button */}
                <button 
                    onClick={() => onNavigate('STEAM_LOGIN')}
                    className="w-full p-5 flex items-center justify-between hover:bg-zinc-900 transition-colors border-b border-zinc-800"
                >
                    <div className="flex items-center gap-4">
                        <div className="w-10 h-10 rounded-full bg-[#1b2838] flex items-center justify-center border border-[#2a475e]">
                            <Globe className="w-5 h-5 text-[#66c0f4]" />
                        </div>
                        <div className="text-left">
                            <h3 className="font-bold text-base text-white">Steam Login</h3>
                            <p className="text-zinc-500 text-xs">Authenticate via Facepunch</p>
                        </div>
                    </div>
                    <ChevronRight className="w-4 h-4 text-zinc-600" />
                </button>

                {/* Pair Server Button */}
                <button 
                    onClick={() => setShowPairingModal(true)}
                    className="w-full p-5 flex items-center justify-between hover:bg-zinc-900 transition-colors border-b border-zinc-800"
                >
                    <div className="flex items-center gap-4">
                        <div className="w-10 h-10 rounded-full bg-zinc-900 flex items-center justify-center border border-zinc-800">
                            <Server className="w-5 h-5 text-orange-500" />
                        </div>
                        <div className="text-left">
                            <h3 className="font-bold text-base text-white">Pair New Server</h3>
                            <p className="text-zinc-500 text-xs">Scan QR or Link via API</p>
                        </div>
                    </div>
                    <div className="bg-orange-500/10 text-orange-500 p-1.5 rounded-lg">
                        <Plus className="w-4 h-4" />
                    </div>
                </button>

                <button 
                    onClick={() => onNavigate('SMART_SWITCHES')}
                    className="w-full p-5 flex items-center justify-between hover:bg-zinc-900 transition-colors border-b border-zinc-800"
                >
                    <div className="flex items-center gap-4">
                        <div className="w-10 h-10 rounded-full bg-zinc-900 flex items-center justify-center border border-zinc-800">
                            <Smartphone className="w-5 h-5 text-green-500" />
                        </div>
                        <div className="text-left">
                            <h3 className="font-bold text-base text-white">Paired Devices</h3>
                            <p className="text-zinc-500 text-xs">Manage Switches & Alarms</p>
                        </div>
                    </div>
                    <ChevronRight className="w-4 h-4 text-zinc-600" />
                </button>

                <button 
                    onClick={() => onNavigate('CONNECTION_MANAGER')}
                    className="w-full p-5 flex items-center justify-between hover:bg-zinc-900 transition-colors"
                >
                    <div className="flex items-center gap-4">
                        <div className="w-10 h-10 rounded-full bg-zinc-900 flex items-center justify-center border border-zinc-800">
                            <Wifi className="w-5 h-5 text-blue-500" />
                        </div>
                        <div className="text-left">
                            <h3 className="font-bold text-base text-white">Connection Details</h3>
                            <p className="text-zinc-500 text-xs">IP, Port & Token Config</p>
                        </div>
                    </div>
                    <ChevronRight className="w-4 h-4 text-zinc-600" />
                </button>
            </div>
        </div>

        {/* --- Alarm Mode Widget --- */}
        <AlarmModeWidget isFree={isFree} onPaywall={handlePaywall} />

        {/* --- Fake Call Widget --- */}
        <FakeCallWidget isFree={isFree} onPaywall={handlePaywall} />

        {/* --- PROTOCOL DEBUGGER --- */}
        <div className="bg-[#121214] border border-zinc-800 rounded-2xl overflow-hidden">
            <button 
                onClick={() => setShowDebugLog(!showDebugLog)}
                className="w-full p-5 flex items-center justify-between hover:bg-zinc-900 transition-colors"
            >
                <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-zinc-900 flex items-center justify-center border border-zinc-800">
                        <Terminal className="w-5 h-5 text-purple-500" />
                    </div>
                    <div className="text-left">
                        <h3 className="font-bold text-base text-white">Protocol Debugger</h3>
                        <p className="text-zinc-500 text-xs">Protobuf Payload Viewer</p>
                    </div>
                </div>
                <ChevronRight className={`w-4 h-4 text-zinc-600 transition-transform ${showDebugLog ? 'rotate-90' : ''}`} />
            </button>
            
            {showDebugLog && (
                <div className="bg-black p-4 font-mono text-[10px] text-green-500 border-t border-zinc-800 space-y-1 max-h-40 overflow-y-auto no-scrollbar">
                    <div className="opacity-50">// Monitoring Socket: 28015</div>
                    <div className="opacity-50">// Protocol: Protobuf / TCP</div>
                    <div className="text-blue-400">{'>'} Handshake: OK</div>
                    <div>{'<'} EntityChanged: {"{ entityId: 12345, value: true }"}</div>
                    <div>{'<'} AppMessage: {"{ broadcast: 'ALARM' }"}</div>
                    <div className="text-yellow-500">{'>'} Request: getTeamInfo()</div>
                    <div>{'<'} AppTeamInfo: {"{ leader: 765611..., size: 4 }"}</div>
                    <div className="animate-pulse">_</div>
                </div>
            )}
        </div>

        {/* --- Legal Section --- */}
        <div>
           <h3 className="text-zinc-500 text-xs font-bold uppercase tracking-widest mb-3 pl-2">Community & Legal</h3>
           <div className="bg-[#121214] border border-zinc-800 rounded-2xl overflow-hidden">
              <button 
                onClick={() => onNavigate('NOTIFICATION_PERMISSION')}
                className="w-full p-5 flex items-center justify-between hover:bg-zinc-900 transition-colors border-b border-zinc-800"
              >
                 <div className="flex items-center gap-4">
                    <Bell className="w-5 h-5 text-white" />
                    <span className="text-sm font-medium">Test Notification Flow</span>
                 </div>
                 <ChevronRight className="w-4 h-4 text-zinc-600" />
              </button>
              
              <button 
                onClick={() => onNavigate('SOCIAL_PROOF')}
                className="w-full p-5 flex items-center justify-between hover:bg-zinc-900 transition-colors border-b border-zinc-800"
              >
                 <div className="flex items-center gap-4">
                    <Heart className="w-5 h-5 text-red-500" />
                    <span className="text-sm font-medium">Success Stories</span>
                 </div>
                 <ChevronRight className="w-4 h-4 text-zinc-600" />
              </button>

              <button 
                onClick={() => onNavigate('TERMS_OF_SERVICE')}
                className="w-full p-5 flex items-center justify-between hover:bg-zinc-900 transition-colors border-b border-zinc-800"
              >
                 <div className="flex items-center gap-4">
                    <FileText className="w-5 h-5 text-zinc-400" />
                    <span className="text-sm font-medium">Terms of Service</span>
                 </div>
                 <ChevronRight className="w-4 h-4 text-zinc-600" />
              </button>
              
              <button 
                onClick={() => onNavigate('PRIVACY_POLICY')}
                className="w-full p-5 flex items-center justify-between hover:bg-zinc-900 transition-colors"
              >
                 <div className="flex items-center gap-4">
                    <Shield className="w-5 h-5 text-zinc-400" />
                    <span className="text-sm font-medium">Privacy Policy</span>
                 </div>
                 <ChevronRight className="w-4 h-4 text-zinc-600" />
              </button>
           </div>
        </div>

        {/* --- HIDDEN ADMIN BUTTON (Developer Access) --- */}
        <div className="pt-6 pb-4 text-center">
           <button 
             onClick={() => onNavigate('ADMIN_PANEL')}
             className="text-[10px] text-zinc-700 font-mono font-medium hover:text-red-500 transition-colors"
           >
             RAID ALARM V2.1.0 • PROTO V25
           </button>
        </div>
      </div>

      {/* --- KICK CONFIRMATION MODAL --- */}
      {kickMemberId !== null && (
        <div className="absolute inset-0 z-50 bg-black/90 backdrop-blur-sm flex items-center justify-center p-6 animate-in fade-in duration-200">
            <div className="w-full max-w-xs bg-zinc-900 border border-red-900/50 rounded-2xl p-5 shadow-[0_0_50px_rgba(220,38,38,0.2)]">
                <div className="flex flex-col items-center text-center gap-4">
                    <div className="w-16 h-16 rounded-full bg-red-950/50 flex items-center justify-center border border-red-900">
                        <AlertTriangle className="w-8 h-8 text-red-500" />
                    </div>
                    <div>
                        <h3 className="text-xl text-white font-bold mb-1">Kick Operator?</h3>
                        <p className="text-sm text-zinc-400">
                            This will remove user from your squad.
                        </p>
                    </div>
                    <div className="flex flex-col gap-2 w-full mt-2">
                        <button 
                            onClick={handleKickMember}
                            className="w-full py-3 bg-red-600 hover:bg-red-500 text-white font-bold uppercase rounded-lg shadow-lg shadow-red-900/40 active:scale-[0.98] transition-all"
                        >
                            Confirm
                        </button>
                        <button 
                            onClick={() => setKickMemberId(null)}
                            className="w-full py-3 bg-transparent text-zinc-400 font-bold uppercase hover:text-white transition-colors"
                        >
                            Cancel
                        </button>
                    </div>
                </div>
            </div>
        </div>
      )}

      {/* --- INVITE CODE MODAL --- */}
      {showInviteModal && (
        <div className="absolute inset-0 z-50 flex items-end justify-center bg-black/80 backdrop-blur-[2px] animate-in fade-in duration-200">
             <div className="absolute inset-0" onClick={() => setShowInviteModal(false)} />
             
             <div className="w-full bg-[#121214] border-t border-zinc-800 rounded-t-3xl p-6 shadow-2xl relative z-10 animate-in slide-in-from-bottom duration-300">
                <div className="w-10 h-1 bg-zinc-800 rounded-full mx-auto mb-6" />
                <div className="text-center mb-6">
                    <h3 className={`text-xl text-white ${TYPOGRAPHY.rustFont} mb-2`}>Squad Frequency</h3>
                    <p className="text-zinc-500 text-xs">Share this code with your team.</p>
                </div>
                <div className="space-y-4">
                    <div className="relative group">
                        <div className="w-full bg-black/40 border border-zinc-800 rounded-xl py-5 flex items-center justify-center relative overflow-hidden">
                             <div className="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')] opacity-10 pointer-events-none" />
                             <span className="text-3xl font-black text-white font-mono tracking-[0.25em] relative z-10 select-all">{inviteCode}</span>
                        </div>
                    </div>
                    <div className="flex gap-3">
                        <button 
                            onClick={copyToClipboard}
                            className={`flex-1 py-4 rounded-xl font-bold uppercase tracking-wider flex items-center justify-center gap-2 transition-all active:scale-[0.98] ${copied ? 'bg-green-600 text-white' : 'bg-white text-black'}`}
                        >
                            {copied ? <Check className="w-4 h-4" /> : <Copy className="w-4 h-4" />}
                            {copied ? 'Copied' : 'Copy Code'}
                        </button>
                        <button onClick={() => setShowInviteModal(false)} className="w-14 flex items-center justify-center bg-zinc-900 border border-zinc-800 text-zinc-400 rounded-xl hover:text-white"><X className="w-5 h-5" /></button>
                    </div>
                </div>
             </div>
        </div>
      )}

      {/* --- SERVER PAIRING SHEET --- */}
      {showPairingModal && (
        <div className="absolute inset-0 z-[60] flex items-end justify-center">
            <div 
                className="absolute inset-0 bg-black/80 backdrop-blur-sm animate-in fade-in duration-300"
                onClick={() => setShowPairingModal(false)}
            />
            
            <div className="w-full bg-[#18181b] rounded-t-3xl shadow-2xl relative z-10 animate-in slide-in-from-bottom duration-300 border-t border-white/5 flex flex-col max-h-[90vh]">
                <div className="flex items-center justify-between p-4 border-b border-white/5">
                    <div className="w-10" /> 
                    <h2 className="text-white font-black text-sm tracking-widest uppercase">PAIR SERVER</h2>
                    <div className="w-10" /> 
                </div>

                <div className="p-6 flex-1 overflow-y-auto">
                    <div className="aspect-square w-full bg-[#27272a] rounded-lg mb-6 flex items-center justify-center border border-white/5 shadow-inner"></div>

                    <div className="text-center space-y-1 mb-8">
                        <h3 className="text-white font-bold text-2xl leading-tight">
                            Corrosion Hour Staging Server
                        </h3>
                        <p className="text-zinc-500 text-sm">
                            Corrosion Hour Staging Server
                        </p>
                    </div>

                    <div className="space-y-2 mb-8">
                        <label className="text-[10px] font-bold text-zinc-500 uppercase tracking-wider block ml-1">
                            SERVER WEBSITE
                        </label>
                        <div className="bg-[#27272a] p-4 rounded-lg flex items-center gap-3 border border-white/5">
                            <Globe className="w-4 h-4 text-zinc-500" />
                            <span className="text-zinc-300 text-sm font-medium truncate">
                                https://corrosionhour.com/
                            </span>
                        </div>
                    </div>
                </div>

                <div className="p-4 border-t border-white/5 bg-[#18181b] pb-8 flex items-center gap-3">
                    <button 
                        onClick={() => setShowPairingModal(false)}
                        className="flex-1 py-4 rounded-full font-bold text-xs uppercase tracking-widest text-zinc-400 hover:text-white hover:bg-white/5 transition-colors"
                    >
                        Cancel
                    </button>
                    <button 
                        onClick={() => { setShowPairingModal(false); onNavigate('SMART_SWITCHES'); }}
                        className="flex-[2] py-4 rounded-full font-bold text-xs uppercase tracking-widest bg-[#5c7e30] hover:bg-[#4a6626] text-white shadow-lg shadow-green-900/20 flex items-center justify-center gap-2 active:scale-[0.98] transition-all"
                    >
                        <Plus className="w-4 h-4" /> Pair Server
                    </button>
                </div>
            </div>
        </div>
      )}

    </div>
  );
};
