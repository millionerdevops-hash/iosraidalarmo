
import React, { useState, useEffect } from 'react';
import { CreditCard, Users, Shield, Crown, User, UserMinus, Plus, ShoppingCart, Server, Activity, Power } from 'lucide-react';
import { PlanType, UserRole } from '../../types';

interface Member {
    id: number;
    name: string;
    role: string;
    joined: string;
    status: string;
}

interface SubscriptionWidgetProps {
    plan: PlanType;
    userRole: UserRole;
    teamSize: number;
    currentMemberCount: number; // Total count (Owner + Members)
    members: Member[];
    onPaywall: () => void;
    onInvite: () => void;
    onKick: (id: number) => void;
}

export const SubscriptionWidget: React.FC<SubscriptionWidgetProps> = ({
    plan,
    userRole,
    teamSize,
    currentMemberCount,
    members,
    onPaywall,
    onInvite,
    onKick
}) => {
    const isFree = userRole === 'FREE';
    const isOwner = userRole === 'OWNER';
    const showTeamManagement = !isFree;
    const isTeamFull = currentMemberCount >= teamSize;

    // Simulated Backend Status
    const [backendLatency, setBackendLatency] = useState(45);
    const [backendStatus, setBackendStatus] = useState<'ONLINE' | 'OFFLINE'>('ONLINE');

    // Simulate ping fluctuation
    useEffect(() => {
        const interval = setInterval(() => {
            setBackendLatency(prev => Math.max(20, Math.min(90, prev + (Math.random() > 0.5 ? 5 : -5))));
        }, 2000);
        return () => clearInterval(interval);
    }, []);

    // Handler for buying extra slots (Simulated)
    const handleBuySlot = () => {
        if(confirm("Purchase 1 Extra Team Slot for $14.99?")) {
            alert("Redirecting to payment provider...");
        }
    };

    return (
        <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-5 relative overflow-hidden transition-all duration-300">
           {/* Pro Badge */}
           {(plan === 'CLAN' || plan === 'TRIO' || plan === 'DUO') && (
              <div className="absolute top-0 right-0 bg-orange-500 text-black text-[10px] font-black px-2 py-1 uppercase rounded-bl-lg z-10 shadow-lg shadow-orange-500/20">
                Pro Active
              </div>
           )}
           
           {/* PART 1: Subscription Info */}
           <div className="flex flex-col gap-4">
              <div className="flex items-center gap-4">
                <div className={`w-12 h-12 rounded-full flex items-center justify-center border shrink-0
                  ${isFree ? 'bg-zinc-800 border-zinc-700' : 'bg-gradient-to-br from-red-600 to-red-900 border-red-500 shadow-[0_0_15px_rgba(220,38,38,0.3)]'}
                `}>
                  <CreditCard className="w-6 h-6 text-white" />
                </div>
                <div>
                  <h3 className="font-black text-lg leading-none uppercase tracking-wider text-white">
                     {plan ? (plan === 'TRIO' ? 'SQUAD' : plan) : 'FREE TIER'}
                  </h3>
                  <p className="text-zinc-500 text-xs mt-1 font-medium">
                    {isFree ? 'Limited Features' : 'Lifetime License Active'}
                  </p>
                </div>
              </div>

              {/* Stats Row */}
              <div className="grid grid-cols-2 gap-3 mt-1">
                 {/* Team Slots */}
                 <div className="bg-zinc-900/50 p-3 rounded-xl border border-zinc-800 flex justify-between items-center relative overflow-hidden">
                    <div>
                        <div className="flex items-center gap-2 text-zinc-500 text-[10px] uppercase font-bold mb-1">
                        <Users className="w-3 h-3" /> Team Slots
                        </div>
                        <div className="text-white font-mono font-bold text-lg leading-none">
                        {currentMemberCount}<span className="text-zinc-600 text-sm">/{teamSize}</span>
                        </div>
                    </div>
                    {!isFree && isOwner && (
                        <button 
                            onClick={handleBuySlot}
                            className="bg-zinc-800 hover:bg-green-900/30 text-zinc-400 hover:text-green-400 p-2 rounded-lg border border-zinc-700 hover:border-green-500/50 transition-all active:scale-95"
                            title="Buy Extra Slot"
                        >
                            <ShoppingCart className="w-4 h-4" />
                        </button>
                    )}
                 </div>

                 {/* BACKEND STATUS (NEW) */}
                 <div className="bg-zinc-900/50 p-3 rounded-xl border border-zinc-800 relative overflow-hidden">
                    <div className="flex items-center justify-between mb-1">
                       <div className="flex items-center gap-2 text-zinc-500 text-[10px] uppercase font-bold">
                          <Server className="w-3 h-3" /> Raid Guard
                       </div>
                       {!isFree && (
                           <div className={`w-1.5 h-1.5 rounded-full animate-pulse ${backendStatus === 'ONLINE' ? 'bg-green-500' : 'bg-red-500'}`} />
                       )}
                    </div>
                    
                    {isFree ? (
                        <div className="text-zinc-500 font-mono font-bold text-lg leading-none">LOCKED</div>
                    ) : (
                        <div className="flex items-end gap-2">
                            <div className="text-green-500 font-mono font-bold text-lg leading-none">ONLINE</div>
                            <span className="text-[10px] text-zinc-600 font-mono mb-0.5">{backendLatency}ms</span>
                        </div>
                    )}
                 </div>
              </div>
              
              {isFree && (
                 <button 
                   onClick={onPaywall}
                   className="mt-2 w-full py-3 bg-red-900/20 border border-red-500/30 text-red-500 text-xs font-bold uppercase rounded-lg hover:bg-red-900/40 hover:border-red-500/50 transition-all active:scale-[0.98]"
                 >
                   Upgrade to Unlock Cloud Guard
                 </button>
              )}
           </div>

           {/* PART 2: Squad Roster */}
           {showTeamManagement && (
               <div className="animate-in fade-in slide-in-from-bottom-2 duration-500">
                   <div className="h-px bg-zinc-800 w-full my-6" /> {/* Divider */}
                   
                   <div className="space-y-5">
                        <div className="flex items-center justify-between">
                            <div>
                                <h3 className="font-bold text-base leading-tight text-white">Squad Roster</h3>
                                <p className="text-zinc-500 text-xs mt-0.5">Manage team access</p>
                            </div>
                        </div>

                        {/* Member List */}
                        <div className="space-y-2">
                            {/* Owner (Self or Leader) */}
                            <div className="flex items-center justify-between p-3 bg-zinc-900/50 border border-zinc-800 rounded-xl">
                                <div className="flex items-center gap-3">
                                    <div className="w-9 h-9 rounded-full bg-orange-900/20 border border-orange-500/50 flex items-center justify-center shrink-0">
                                        <Crown className="w-4 h-4 text-orange-500" />
                                    </div>
                                    <div>
                                        <div className="text-sm font-bold text-white flex items-center gap-2">
                                            {isOwner ? 'You' : 'Squad Leader'} <span className="text-[9px] bg-zinc-800 px-1.5 py-0.5 rounded text-zinc-400 font-bold tracking-wide">OWNER</span>
                                        </div>
                                        <div className="text-[10px] text-green-500 font-mono font-bold flex items-center gap-1.5">
                                            <div className="w-1.5 h-1.5 bg-green-500 rounded-full animate-pulse" /> Online
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* Members Grid */}
                            {members.length > 0 ? (
                                <div className="grid grid-cols-1 gap-2">
                                    {members.map((member) => (
                                        <div key={member.id} className="flex items-center justify-between p-2.5 bg-zinc-900/30 border border-zinc-800/50 rounded-xl group hover:border-zinc-700 transition-colors">
                                            <div className="flex items-center gap-3 min-w-0">
                                                <div className="w-9 h-9 rounded-full bg-zinc-800 flex items-center justify-center text-zinc-500 relative shrink-0 border border-zinc-700">
                                                    <User className="w-4 h-4" />
                                                    <div className={`absolute -bottom-0.5 -right-0.5 w-3 h-3 rounded-full border-2 border-[#18181b] ${member.status === 'online' ? 'bg-green-500' : 'bg-zinc-600'} `} />
                                                </div>
                                                <div className="min-w-0">
                                                    <div className="text-xs font-bold text-zinc-200 truncate">{member.name}</div>
                                                    <div className="text-[9px] text-zinc-500 font-mono truncate">Joined {member.joined}</div>
                                                </div>
                                            </div>
                                            {isOwner && (
                                                <button 
                                                    onClick={() => onKick(member.id)}
                                                    className="w-8 h-8 flex items-center justify-center text-zinc-600 hover:text-red-500 hover:bg-red-950/20 rounded-lg transition-all shrink-0 ml-1"
                                                >
                                                    <UserMinus className="w-4 h-4" />
                                                </button>
                                            )}
                                        </div>
                                    ))}
                                </div>
                            ) : (
                                <div className="text-center py-6 border border-dashed border-zinc-800 rounded-xl bg-zinc-900/20">
                                    <p className="text-xs text-zinc-500 font-medium">No active members in squad.</p>
                                </div>
                            )}
                        </div>

                        <div className="flex flex-col gap-2">
                            {isTeamFull && isOwner && (
                                <button
                                    onClick={handleBuySlot}
                                    className="w-full py-3 bg-zinc-900 border border-dashed border-zinc-700 rounded-xl text-zinc-400 text-xs font-bold uppercase hover:text-white hover:border-green-500 transition-all flex items-center justify-center gap-2 mb-1"
                                >
                                    <Plus className="w-4 h-4" /> Add Extra Slot ($14.99)
                                </button>
                            )}

                            <button
                                onClick={onInvite}
                                disabled={isTeamFull}
                                className={`w-full py-4 rounded-xl font-bold uppercase tracking-wider text-xs flex items-center justify-center gap-2 border transition-all active:scale-[0.98]
                                    ${isTeamFull 
                                        ? 'bg-zinc-900 border-zinc-800 text-zinc-600 cursor-not-allowed opacity-50' 
                                        : 'bg-zinc-800 border-zinc-700 text-zinc-300 hover:bg-zinc-700 hover:text-white hover:border-zinc-500'}
                                `}
                            >
                                {isTeamFull ? (
                                    <>Team Full</>
                                ) : (
                                    <>
                                        <Plus className="w-4 h-4" /> Invite New Operator
                                    </>
                                )}
                            </button>
                        </div>
                   </div>
               </div>
           )}
        </div>
    );
};
