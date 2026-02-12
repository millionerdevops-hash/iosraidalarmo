
import React from 'react';
import { Loader2, Terminal, Radio } from 'lucide-react';

interface LogEntry {
    id: number;
    text: string;
    playerName: string; // Used for name or ENTITY ID
    playerId: string;
    type: 'join' | 'leave' | 'error' | 'entity'; // Added 'entity' type
    time: string;
}

interface ServerLiveTabProps {
    logs: LogEntry[];
    feedError: string | null;
    onInspectPlayer: (id: string, name: string) => void;
}

export const ServerLiveTab: React.FC<ServerLiveTabProps> = ({ logs, feedError, onInspectPlayer }) => {
    return (
        <div className="flex flex-col h-full animate-in fade-in duration-300 p-4">
            <div className="bg-black border border-zinc-800 rounded-xl p-4 font-mono text-xs h-full overflow-hidden flex flex-col relative shadow-inner">
                
                {/* Console Header */}
                <div className="flex justify-between items-center border-b border-zinc-800 pb-2 mb-2">
                    <div className="flex items-center gap-2">
                        <Terminal className="w-3 h-3 text-green-500" />
                        <span className="text-green-500 font-bold">rustplusd ~ output</span>
                    </div>
                    <div className="flex gap-2 items-center">
                        {feedError ? (
                            <span className="text-[9px] text-red-500 uppercase font-bold animate-pulse">NO SIGNAL</span>
                        ) : (
                            <div className="flex items-center gap-1.5 bg-zinc-900 px-1.5 py-0.5 rounded border border-zinc-800">
                                <div className="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse" />
                                <span className="text-[9px] text-zinc-400">SOCKET OPEN</span>
                            </div>
                        )}
                    </div>
                </div>

                {/* Console Body */}
                <div className="flex-1 overflow-y-auto space-y-1.5 no-scrollbar font-mono">
                    {feedError && (
                        <div className="p-2 border border-red-900/50 bg-red-950/20 text-red-400 text-center rounded mb-2">
                            {feedError}
                        </div>
                    )}
                    {logs.length === 0 && !feedError && (
                        <div className="flex flex-col items-center justify-center h-full text-zinc-600 space-y-2">
                            <Loader2 className="w-6 h-6 animate-spin opacity-50" />
                            <span className="italic">Listening for broadcast messages...</span>
                        </div>
                    )}
                    {logs.map((log) => (
                        <div key={log.id} className="flex gap-2 animate-in slide-in-from-left-2 duration-200 leading-tight">
                            <span className="text-zinc-600 min-w-[45px] shrink-0">[{log.time}]</span>
                            
                            {log.type === 'entity' ? (
                                <div className="text-yellow-500 break-all">
                                    <span className="text-purple-400 font-bold mr-1">BROADCAST</span>
                                    entityChanged: <span className="text-white">{log.playerName}</span> value: <span className="text-red-400 font-bold">TRUE</span>
                                </div>
                            ) : (
                                <span className={log.type === 'join' ? 'text-zinc-300' : 'text-zinc-500'}>
                                    <span className={`mr-1 font-bold ${log.type === 'join' ? 'text-green-500' : 'text-red-500'}`}>
                                        {log.type === 'join' ? '+' : '-'}
                                    </span>
                                    {log.type === 'error' ? (
                                        <span className="text-red-400">{log.text}</span>
                                    ) : (
                                        <>
                                            Player <button 
                                                onClick={() => onInspectPlayer(log.playerId, log.playerName)}
                                                className="hover:underline hover:text-blue-400 cursor-pointer font-bold transition-colors text-zinc-200"
                                            >
                                                {log.playerName}
                                            </button> {log.type === 'join' ? 'connected' : 'disconnected'}
                                        </>
                                    )}
                                </span>
                            )}
                        </div>
                    ))}
                    
                    {/* Simulated "Keep-Alive" heartbeat or recent message */}
                    <div className="text-zinc-700 opacity-50 text-[10px] mt-2">
                        {'>'} monitoring smart_switch entities via wss://...
                    </div>
                </div>
            </div>
        </div>
    );
};
