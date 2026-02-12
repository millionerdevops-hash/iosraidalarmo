
import React from 'react';
import { RaidMethod, getAmmo } from '../../data/raidData';

interface ExplosiveCardProps {
    method: RaidMethod;
    targetQty: number; // How many targets we are raiding
    targetHp: number; // HP of one target
    targetId?: string; // Optional ID to check for damage overrides
}

// Resource Style Configuration
const RESOURCE_CONFIG: Record<string, { label: string; img: string; textColor: string; valueColor: string }> = {
    sulfur: { 
        label: 'Sulfur', 
        img: 'https://rustlabs.com/img/items180/sulfur.png', 
        textColor: 'text-[#eab308]', // Yellow-500
        valueColor: 'text-[#facc15]'  // Yellow-400
    },
    charcoal: { 
        label: 'Charcoal', 
        img: 'https://rustlabs.com/img/items180/charcoal.png', 
        textColor: 'text-zinc-500', 
        valueColor: 'text-zinc-300' 
    },
    gunpowder: { 
        label: 'Gunpowder', 
        img: 'https://rustlabs.com/img/items180/gunpowder.png', 
        textColor: 'text-zinc-400', 
        valueColor: 'text-zinc-200' 
    },
    fuel: { 
        label: 'LGF', 
        img: 'https://rustlabs.com/img/items180/lowgradefuel.png', 
        textColor: 'text-orange-600', 
        valueColor: 'text-orange-500' 
    },
    metal: { 
        label: 'Frags', 
        img: 'https://rustlabs.com/img/items180/metal.fragments.png', 
        textColor: 'text-blue-400', 
        valueColor: 'text-blue-300' 
    },
    pipes: { 
        label: 'Pipe', 
        img: 'https://rustlabs.com/img/items180/metal.pipe.png', 
        textColor: 'text-zinc-400', 
        valueColor: 'text-white' 
    },
    tech: { 
        label: 'Tech Trash', 
        img: 'https://rustlabs.com/img/items180/tech.trash.png', 
        textColor: 'text-cyan-600', 
        valueColor: 'text-cyan-400' 
    },
    stones: { 
        label: 'Stones', 
        img: 'https://rustlabs.com/img/items180/stones.png', 
        textColor: 'text-zinc-500', 
        valueColor: 'text-zinc-300' 
    },
    cloth: { 
        label: 'Cloth', 
        img: 'https://rustlabs.com/img/items180/cloth.png', 
        textColor: 'text-[#86efac]', // Green-300
        valueColor: 'text-[#4ade80]'  // Green-400
    },
    animal_fat: { 
        label: 'Animal Fat', 
        img: 'https://rustlabs.com/img/items180/fat.animal.png', 
        textColor: 'text-orange-300', 
        valueColor: 'text-white' 
    }
};

export const ExplosiveCard: React.FC<ExplosiveCardProps> = ({ 
    method, 
    targetQty, 
    targetHp,
    targetId
}) => {
    
    // 1. Calculate Damage
    let damage = method.damage;
    if (targetId && method.damageOverride && method.damageOverride[targetId]) {
        damage = method.damageOverride[targetId];
    }

    if (damage <= 0) return null; 

    // 2. Calculate Shots Required
    const shotsPerTarget = Math.ceil(targetHp / damage);
    const totalShots = shotsPerTarget * targetQty;

    // 3. Get Data Objects
    const ammo = getAmmo(method.ammoId);
    if (!ammo) return null;

    // 4. Calculate Raw Materials
    const r = ammo.recipe;
    const totals: Record<string, number> = {
        sulfur: (r.sulfur || 0) * totalShots,
        gunpowder: (r.gunpowder || 0) * totalShots,
        fuel: (r.fuel || 0) * totalShots,
        metal: (r.metal || 0) * totalShots,
        charcoal: (r.charcoal || 0) * totalShots,
        pipes: (r.pipes || 0) * totalShots,
        tech: (r.tech || 0) * totalShots,
        cloth: (r.cloth || 0) * totalShots,
        stones: (r.stones || 0) * totalShots
    };

    // Filter resources that have a value > 0
    const resources = Object.entries(totals).filter(([_, qty]) => qty > 0);

    // Format Numbers (e.g. 1500 -> 1.5k)
    const formatNumber = (num: number) => {
        if (num >= 1000) {
            // Check if it's a clean thousand (e.g. 2000 -> 2k)
            if (num % 1000 === 0) return `${(num / 1000).toFixed(0)}k`;
            return `${(num / 1000).toFixed(1)}k`;
        }
        return num.toLocaleString();
    };

    return (
        <div className="flex w-full mb-2 rounded-xl overflow-hidden bg-[#141416] border border-white/5 relative group h-[72px]">
            
            {/* LEFT PANEL: AMMO IDENTITY */}
            <div className="w-[80px] bg-[#1c1c1e] flex flex-col items-center justify-center relative shrink-0 border-r border-white/5">
                
                {/* Image */}
                <div className="relative z-10 w-10 h-10 mb-1">
                    <img 
                        src={ammo.img} 
                        alt={ammo.name} 
                        className="w-full h-full object-contain drop-shadow-md" 
                    />
                </div>

                {/* Name */}
                <span className="text-[9px] font-black text-zinc-400 uppercase tracking-tight text-center leading-none px-1 line-clamp-1 w-full">
                    {ammo.name.replace('Rocket', '').replace('Grenade', '').trim()}
                </span>

                {/* Floating Quantity Badge (Top Right of Left Panel) */}
                <div className="absolute top-1.5 right-1.5 bg-[#facc15] text-black text-[9px] font-black px-1.5 py-0.5 rounded-[4px] shadow-sm z-20 flex items-center justify-center min-w-[22px] leading-none">
                    <span className="opacity-70 text-[8px] mr-0.5">x</span>{totalShots}
                </div>
            </div>

            {/* RIGHT PANEL: RESOURCE GRID */}
            <div className="flex-1 flex items-center px-4 bg-[#141416]">
                {resources.length > 0 ? (
                    <div className="grid grid-cols-2 w-full gap-x-6 gap-y-1">
                        {resources.map(([key, qty]) => {
                            const config = RESOURCE_CONFIG[key] || { 
                                label: key, 
                                img: '', 
                                textColor: 'text-zinc-500', 
                                valueColor: 'text-white' 
                            };
                            
                            return (
                                <div key={key} className="flex items-center justify-between min-w-0">
                                    <div className="flex items-center gap-1.5 overflow-hidden">
                                        <img 
                                            src={config.img} 
                                            alt={config.label} 
                                            className="w-3 h-3 object-contain opacity-80" 
                                        />
                                        <span className={`text-[10px] font-black uppercase tracking-wide truncate ${config.textColor}`}>
                                            {config.label}
                                        </span>
                                    </div>
                                    <span className={`text-xs font-mono font-bold ${config.valueColor}`}>
                                        {formatNumber(qty)}
                                    </span>
                                </div>
                            );
                        })}
                    </div>
                ) : (
                    <div className="w-full flex items-center justify-center opacity-30">
                        <span className="text-[10px] text-zinc-500 font-mono italic tracking-widest uppercase">
                            No craft cost
                        </span>
                    </div>
                )}
            </div>

        </div>
    );
};
