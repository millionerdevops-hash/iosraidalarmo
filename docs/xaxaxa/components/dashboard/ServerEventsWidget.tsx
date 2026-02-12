
import React, { useState, useEffect } from 'react';
import { Ship, Plane, Box, Radio, Bell, BellOff, Crosshair } from 'lucide-react';

interface ServerEvent {
    id: string;
    name: string;
    icon: any;
    isActive: boolean;
    lastActive?: string;
    cooldown?: string;
    color: string;
}

export const ServerEventsWidget: React.FC = () => {
    // Simulated State
    const [events, setEvents] = useState<ServerEvent[]>([
        { id: 'cargo', name: 'Cargo Ship', icon: Ship, isActive: true, color: 'text-blue-400' },
        { id: 'heli', name: 'Patrol Heli', icon: Plane, isActive: false, lastActive: '2h ago', color: 'text-red-500' },
        { id: 'bradley', name: 'Bradley APC', icon: Crosshair, isActive: false, lastActive: '15m ago', color: 'text-yellow-500' },
        { id: 'chinook', name: 'Chinook (CH47)', icon: Radio, isActive: false, lastActive: '45m ago', color: 'text-green-500' },
        { id: 'crate', name: 'Locked Crate', icon: Box, isActive: true, color: 'text-orange-500' },
    ]);

    const [notifications, setNotifications] = useState<Record<string, boolean>>({
        cargo: true,
        heli: true
    });

    const toggleNotify = (id: string) => {
        setNotifications(prev => ({ ...prev, [id]: !prev[id] }));
    };

    return (
        <div className="bg-[#121214] border border-zinc-800 rounded-2xl p-4">
            <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                    <Radio className="w-4 h-4 text-orange-500 animate-pulse" />
                    <h3 className="font-bold text-white text-sm uppercase tracking-wider">Server Events</h3>
                </div>
                <span className="text-[9px] bg-red-900/20 text-red-400 px-2 py-1 rounded border border-red-900/30 font-bold uppercase">
                    Live
                </span>
            </div>

            <div className="space-y-2">
                {events.map((event) => (
                    <div key={event.id} className="flex items-center justify-between p-3 rounded-xl bg-zinc-900/30 border border-zinc-800/50">
                        <div className="flex items-center gap-3">
                            <div className={`w-8 h-8 rounded-lg flex items-center justify-center border ${event.isActive ? 'bg-zinc-800 border-zinc-700' : 'bg-zinc-900 border-zinc-800 opacity-50'}`}>
                                <event.icon className={`w-4 h-4 ${event.isActive ? event.color : 'text-zinc-600'}`} />
                            </div>
                            <div>
                                <div className={`text-xs font-bold ${event.isActive ? 'text-white' : 'text-zinc-500'}`}>{event.name}</div>
                                <div className="text-[9px] font-mono">
                                    {event.isActive ? (
                                        <span className={event.color}>ACTIVE ON MAP</span>
                                    ) : (
                                        <span className="text-zinc-600">Last seen: {event.lastActive}</span>
                                    )}
                                </div>
                            </div>
                        </div>

                        <button 
                            onClick={() => toggleNotify(event.id)}
                            className={`p-2 rounded-lg transition-colors ${notifications[event.id] ? 'text-zinc-300 hover:text-white' : 'text-zinc-700 hover:text-zinc-500'}`}
                        >
                            {notifications[event.id] ? <Bell className="w-4 h-4" /> : <BellOff className="w-4 h-4" />}
                        </button>
                    </div>
                ))}
            </div>
            
            <div className="mt-3 text-center">
                <p className="text-[9px] text-zinc-600 italic">
                    Requires Rust+ Connection for real-time map tracking.
                </p>
            </div>
        </div>
    );
};
