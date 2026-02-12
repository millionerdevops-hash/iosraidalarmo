import React, { useState } from 'react';
import { Copy, Check, ShieldAlert, Radio } from 'lucide-react';
import { CameraCode } from '../../types';

interface CCTVCardWidgetProps {
    item: CameraCode;
    onClick: (item: CameraCode) => void;
}

export const CCTVCardWidget: React.FC<CCTVCardWidgetProps> = ({ item, onClick }) => {
    const [copied, setCopied] = useState(false);

    const handleClick = () => {
        if (item.isRandom) {
            onClick(item);
            return;
        }

        navigator.clipboard.writeText(item.code);
        setCopied(true);
        setTimeout(() => setCopied(false), 1500);
        
        onClick(item);
    };

    return (
        <button 
            onClick={handleClick}
            className={`w-full text-left bg-black border rounded-xl overflow-hidden flex flex-col group relative h-full transition-all duration-200 active:scale-[0.98] outline-none
                ${copied ? 'border-green-500 shadow-[0_0_20px_rgba(34,197,94,0.2)]' : 'border-zinc-800 hover:border-zinc-600'}
                ${item.isRandom ? 'cursor-default' : 'cursor-pointer'}
            `}
        >
            
            {/* Monitor Screen Area */}
            <div className="aspect-video relative bg-zinc-900 w-full overflow-hidden">
                {/* Image */}
                {item.img ? (
                    <img 
                        src={item.img} 
                        alt={item.label} 
                        className={`w-full h-full object-cover transition-all duration-500 
                            ${copied ? 'opacity-20 grayscale blur-[2px]' : 'opacity-80 group-hover:opacity-100 grayscale group-hover:grayscale-0'}
                        `} 
                        loading="lazy"
                    />
                ) : (
                    <div className="w-full h-full flex items-center justify-center">
                        <Radio className="w-8 h-8 text-zinc-700" />
                    </div>
                )}
                
                {/* "REC" Overlay - Hide when copied */}
                {!copied && (
                    <div className="absolute top-2 left-2 flex items-center gap-1.5 bg-black/60 backdrop-blur px-1.5 py-0.5 rounded-sm border border-white/10 z-20">
                        <div className="w-1.5 h-1.5 rounded-full bg-red-600 animate-pulse shadow-[0_0_5px_#dc2626]" />
                        <span className="text-[8px] font-black text-white tracking-widest">REC</span>
                    </div>
                )}

                {/* Copied Overlay */}
                {copied && (
                    <div className="absolute inset-0 flex flex-col items-center justify-center z-30 animate-in fade-in zoom-in duration-200">
                        <div className="w-10 h-10 rounded-full bg-green-500 flex items-center justify-center shadow-[0_0_20px_rgba(34,197,94,0.5)] mb-2">
                            <Check className="w-6 h-6 text-black stroke-[3]" />
                        </div>
                        <span className="text-[10px] font-black text-green-500 uppercase tracking-widest bg-black/50 px-2 py-1 rounded backdrop-blur-md">
                            COPIED
                        </span>
                    </div>
                )}

                {/* Scanlines Effect */}
                <div className="absolute inset-0 bg-[linear-gradient(rgba(18,16,16,0)_50%,rgba(0,0,0,0.25)_50%),linear-gradient(90deg,rgba(255,0,0,0.06),rgba(0,255,0,0.02),rgba(0,0,255,0.06))] z-[1] bg-[length:100%_4px,6px_100%] pointer-events-none opacity-20" />
                
                {/* Vignette */}
                <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,transparent_50%,rgba(0,0,0,0.6))] pointer-events-none" />
            </div>

            {/* Control Panel (Bottom) */}
            <div className="p-3 bg-[#0c0c0e] border-t border-zinc-800 relative z-10 flex flex-col gap-1">
                <div className="flex justify-between items-start">
                    <span className="text-[9px] font-bold text-zinc-500 uppercase tracking-wider truncate max-w-[85%]">{item.label}</span>
                    {item.isRandom && <ShieldAlert className="w-3 h-3 text-orange-500" />}
                </div>
                
                <div className="flex items-center justify-between">
                    <span className={`font-mono text-xs font-bold truncate tracking-wider transition-colors
                        ${copied ? 'text-green-500' : 'text-zinc-300'}
                    `}>
                        {item.isRandom ? '****' : item.code}
                    </span>
                    
                    {/* Subtle Hint Icon */}
                    {!item.isRandom && !copied && (
                        <Copy className="w-3 h-3 text-zinc-700 group-hover:text-zinc-500 transition-colors" />
                    )}
                </div>
                
                {item.isRandom && (
                    <span className="text-[8px] text-zinc-600 font-mono">Randomized Code</span>
                )}
            </div>
        </button>
    );
};