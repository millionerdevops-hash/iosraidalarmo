
import React from 'react';
import { X, Globe } from 'lucide-react';
import { TYPOGRAPHY } from '../theme';
import { ScreenName } from '../types';

interface SteamLoginScreenProps {
  onNavigate: (screen: ScreenName) => void;
}

export const SteamLoginScreen: React.FC<SteamLoginScreenProps> = ({ onNavigate }) => {
  return (
    <div className="flex flex-col h-full bg-[#1b2838] relative animate-in slide-in-from-bottom duration-300">
      {/* Header - Styled like a browser or simple modal header */}
      <div className="flex items-center justify-between p-4 bg-[#171a21] border-b border-[#2a475e] shadow-md z-10 shrink-0">
        <div className="flex items-center gap-2">
            <Globe className="w-4 h-4 text-[#66c0f4]" />
            <span className="text-xs font-bold text-[#c7d5e0]">Steam Community</span>
        </div>
        <button 
            onClick={() => onNavigate('SETTINGS')}
            className="p-2 bg-[#2a475e] rounded hover:bg-[#66c0f4] hover:text-[#171a21] text-[#c7d5e0] transition-colors"
        >
            <X className="w-5 h-5" />
        </button>
      </div>

      {/* WebView Container */}
      <div className="flex-1 relative bg-white">
         <iframe 
            src="https://companion-rust.facepunch.com/login" 
            className="w-full h-full border-0"
            title="Steam Login"
            sandbox="allow-scripts allow-same-origin allow-forms allow-popups"
         />
      </div>
    </div>
  );
};
