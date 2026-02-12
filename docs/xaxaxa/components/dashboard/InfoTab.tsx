
import React from 'react';
import { 
  Globe, 
  Search,
  Flame,
  Sword,
  Newspaper,
  BookOpen,
  Dog,
  Gift
} from 'lucide-react';
import { AppState, ScreenName, UpkeepState, TargetPlayer } from '../../types';
import { TrackedTargetsWidget } from './TrackedTargetsWidget';
import { ActiveServerWidget } from './ActiveServerWidget';
import { ToolsMenuCard } from './ToolsMenuCard';

interface InfoTabProps {
  state: AppState;
  onNavigate: (screen: ScreenName) => void;
  onUpdateUpkeep: (upkeep: UpkeepState) => void;
  onSelectTarget: (target: TargetPlayer) => void;
}

export const InfoTab: React.FC<InfoTabProps> = ({ state, onNavigate, onUpdateUpkeep, onSelectTarget }) => {
  
  return (
      <div className="space-y-4 animate-in fade-in slide-in-from-bottom-2 duration-300 pb-24">
          
          {/* 1. ACTIVE SERVER WIDGET */}
          <ActiveServerWidget 
            server={state.savedServer} 
            onNavigate={onNavigate} 
          />

          {/* 2. TRACKED TARGETS */}
          <TrackedTargetsWidget 
            targets={state.trackedTargets} 
            onNavigate={onNavigate} 
            onSelectTarget={onSelectTarget}
          />

          {/* 3. DISCOVERY SECTION */}
          <div className="px-1 pt-2 flex items-center justify-between">
              <span className="text-xs font-bold text-zinc-500 uppercase tracking-widest">Discovery</span>
          </div>

          <div className="space-y-3">
               
               {/* NEW: SKIN HUB / CODES */}
               <ToolsMenuCard 
                  title="SKIN HUB"
                  subtitle="Free Codes & Daily Crate"
                  icon={Gift}
                  image="https://rustlabs.com/img/items180/crate_elite.png"
                  onClick={() => onNavigate('SKIN_HUB')}
                  color="text-pink-500"
               />

               {/* GUIDES */}
               <ToolsMenuCard 
                  title="SURVIVAL GUIDES"
                  subtitle="Basics, Components & More"
                  icon={BookOpen}
                  image="https://files.facepunch.com/paddy/20210204/Feb_Update_Header.jpg"
                  onClick={() => onNavigate('GUIDE_LIST')}
                  color="text-blue-400"
               />

               {/* ANIMAL GUIDE */}
               <ToolsMenuCard 
                  title="FAUNA GUIDE"
                  subtitle="Harvest Yields & Stats"
                  icon={Dog}
                  image="https://files.facepunch.com/paddy/20220203/feb_update_arctic_base.jpg"
                  onClick={() => onNavigate('ANIMAL_GUIDE')}
                  color="text-red-400"
               />

               {/* NEWS FEED */}
               <ToolsMenuCard 
                  title="NEWS FEED"
                  subtitle="Devblogs & Updates"
                  icon={Newspaper}
                  image="https://files.facepunch.com/paddy/20240206/jungle_ruins_header.jpg"
                  onClick={() => onNavigate('NEWS_FEED')}
                  color="text-orange-500"
               />

               {/* PROMOTED SERVERS */}
               <ToolsMenuCard 
                  title="SERVER SPOTLIGHT"
                  subtitle="Promoted & Featured"
                  icon={Flame}
                  image="https://hone.gg/blog/wp-content/uploads/2025/05/rust-banner_1rust-banner.webp"
                  onClick={() => onNavigate('SERVER_PROMO')}
                  color="text-yellow-500"
               />

               {/* COMBAT RECORD */}
               <ToolsMenuCard 
                  title="COMBAT RECORD"
                  subtitle="K/D, Weapons & Accuracy"
                  icon={Sword}
                  image="https://files.facepunch.com/paddy/20231201/attack_heli_header.jpg"
                  onClick={() => onNavigate('COMBAT_SEARCH')}
                  color="text-red-600"
               />

               {/* SERVER SEARCH */}
               <ToolsMenuCard 
                  title="FIND SERVER"
                  subtitle="Browse & Track Wipes"
                  icon={Globe}
                  image="https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=2670&auto=format&fit=crop"
                  onClick={() => onNavigate('SERVER_SEARCH')}
                  color="text-green-500"
               />

               {/* PLAYER SEARCH */}
               <ToolsMenuCard 
                  title="FIND PLAYER"
                  subtitle="Steam ID & Online Status"
                  icon={Search}
                  image="https://images.unsplash.com/photo-1552820728-8b83bb6b773f?q=80&w=2670&auto=format&fit=crop"
                  onClick={() => onNavigate('PLAYER_SEARCH')}
                  color="text-purple-500"
               />
          </div>

      </div>
  );
};
