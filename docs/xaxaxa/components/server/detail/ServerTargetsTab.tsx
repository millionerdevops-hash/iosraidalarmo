import React from 'react';
import { Crosshair, Plus, AlertTriangle, Loader2, Settings } from 'lucide-react';
import { TargetPlayer } from '../../../types';
import { Button } from '../../Button';

interface ServerTargetsTabProps {
    trackedTargets: TargetPlayer[];
    targetInput: string;
    onTargetInputChange: (val: string) => void;
    verifyingTarget: boolean;
    onVerifyAndAdd: () => void;
    targetError: string | null;
    onEditTarget: (target: TargetPlayer) => void;
    onGoToLive: () => void;
}

export const ServerTargetsTab: React.FC<ServerTargetsTabProps> = ({
    trackedTargets,
    targetInput,
    onTargetInputChange,
    verifyingTarget,
    onVerifyAndAdd,
    targetError,
    onEditTarget,
    onGoToLive
}) => {
    return (
        <div className="flex flex-col h-full animate-in fade-in duration-300 p-4">
            {/* Manual Entry Input */}
            <div className="mb-4">
                <div className="flex gap-2">
                     <input 
                        type="text"
                        value={targetInput}
                        onChange={(e) => onTargetInputChange(e.target.value)}
                        placeholder="Enter exact player name..."
                        className="flex-1 bg-zinc-900 border border-zinc-800 rounded-xl px-4 text-sm text-white focus:border-orange-500 focus:outline-none placeholder:text-zinc-600 font-mono"
                        onKeyDown={(e) => e.key === 'Enter' && onVerifyAndAdd()}
                     />
                     <Button onClick={onVerifyAndAdd} disabled={verifyingTarget || !targetInput} className="w-12 p-0 flex items-center justify-center bg-red-900/50 hover:bg-red-800 border-red-800">
                         {verifyingTarget ? <Loader2 className="w-4 h-4 animate-spin" /> : <div className="w-4 h-4 bg-red-500/20" />}
                     </Button>
                </div>
                {targetError && (
                    <div className="mt-2 text-[10px] text-red-500 font-bold flex items-center gap-1.5 px-1 animate-in slide-in-from-top-1">
                        <AlertTriangle className="w-3 h-3" />
                        {targetError}
                    </div>
                )}
            </div>

            {trackedTargets.length === 0 ? (
                <div className="text-center py-12 text-zinc-600 border border-dashed border-zinc-800 rounded-xl">
                    <Crosshair className="w-8 h-8 mx-auto mb-2 opacity-30" />
                    <p className="text-xs">No targets tracked.</p>
                    <button onClick={onGoToLive} className="text-[10px] text-blue-500 mt-2 hover:underline">
                        Go to Live Feed
                    </button>
                </div>
            ) : (
                <div className="space-y-2">
                    {trackedTargets.map((target, idx) => (
                        <div key={idx} className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-4 flex items-center justify-between">
                            <div className="flex items-center gap-3">
                                <div className={`w-3 h-3 rounded-full ${target.isOnline ? 'bg-green-500' : 'bg-zinc-600'}`} />
                                <div>
                                    <div className="font-bold text-white text-sm">{target.name}</div>
                                    <div className="text-[10px] text-zinc-500">{target.lastSeen}</div>
                                </div>
                            </div>
                            <button 
                                onClick={() => onEditTarget(target)} 
                                className="p-2 -mr-2 text-zinc-500 hover:text-white hover:bg-zinc-800 rounded-lg transition-all"
                            >
                                <Settings className="w-4 h-4" />
                            </button>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};