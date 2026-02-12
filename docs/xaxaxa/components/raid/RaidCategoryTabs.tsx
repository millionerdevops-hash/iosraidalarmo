
import React from 'react';
import { Hammer, DoorOpen, Bomb, Box } from 'lucide-react';

type Category = 'construction' | 'door' | 'item' | 'placeable';

interface RaidCategoryTabsProps {
    activeCategory: Category;
    onSelect: (cat: Category) => void;
}

export const RaidCategoryTabs: React.FC<RaidCategoryTabsProps> = ({ activeCategory, onSelect }) => {
    return (
        <div className="flex p-4 gap-2">
            {[
                { id: 'construction', label: 'Build', icon: Hammer },
                { id: 'door', label: 'Doors', icon: DoorOpen },
                { id: 'placeable', label: 'Items', icon: Box },
                { id: 'item', label: 'Traps', icon: Bomb } 
            ].map((cat) => (
                <button
                    key={cat.id}
                    onClick={() => onSelect(cat.id as Category)}
                    className={`flex-1 py-3 rounded-xl flex flex-col items-center justify-center gap-1.5 border text-[10px] font-black uppercase tracking-wider transition-all
                        ${activeCategory === cat.id 
                            ? 'bg-zinc-800 border-zinc-600 text-white shadow-lg' 
                            : 'bg-zinc-900/50 border-transparent text-zinc-500 hover:bg-zinc-900'}
                    `}
                >
                    <cat.icon className={`w-4 h-4 ${activeCategory === cat.id ? 'text-orange-500' : 'text-zinc-600'}`} />
                    {cat.label}
                </button>
            ))}
        </div>
    );
};
