
export type ScreenName = 
  | 'SPLASH'
  | 'DISCLAIMER'
  | 'GET_STARTED'
  | 'JOIN_CODE'
  | 'ONBOARDING'
  | 'RISK_ANALYSIS'
  | 'HOW_IT_WORKS'
  | 'ALARM_PREVIEW'
  | 'FAKE_CALL_PREVIEW'
  | 'SETUP_READY'
  | 'PAYWALL'
  | 'DASHBOARD'
  | 'PRIVACY_POLICY'
  | 'TERMS_OF_SERVICE'
  | 'SETTINGS'
  | 'RAID_CALCULATOR'
  | 'SCRAP_CALCULATOR'
  | 'CCTV_CODES'
  | 'SERVER_SEARCH'
  | 'SERVER_DETAIL'
  | 'SERVER_PROMO'
  | 'SERVER_PROMO_DETAIL'
  | 'PLAYER_SEARCH'
  | 'COMBAT_SEARCH'
  | 'PLAYER_STATS'
  | 'AI_ANALYZER'
  | 'TEA_CALCULATOR'
  | 'CRAFTING_CALCULATOR'
  | 'GENE_CALCULATOR'
  | 'MLRS_CALCULATOR'
  | 'DIESEL_CALCULATOR'
  | 'ELECTRICITY_SIMULATOR'
  | 'INDUSTRIAL_CALCULATOR'
  | 'RECOIL_TRAINER'
  | 'MONUMENT_PUZZLES'
  | 'TECH_TREE'
  | 'BLUEPRINT_TRACKER'
  | 'UPKEEP_CALCULATOR'
  | 'MARKET_MONITOR'
  | 'SMART_SWITCHES'
  | 'DEVICE_PAIRING'
  | 'CONNECTION_MANAGER'
  | 'STEAM_LOGIN'
  | 'ADMIN_PANEL'
  | 'NEWS_FEED'
  | 'GUIDE_LIST'
  | 'GUIDE_DETAIL'
  | 'RECYCLER_GUIDE'
  | 'ANIMAL_GUIDE'
  | 'PARTNERS'
  | 'SKIN_HUB'
  | 'BUILDING_SIMULATOR'
  | 'CRATE_SIMULATOR'
  | 'MINI_GAME'
  | 'BASE_ROAST'
  | 'SOUNDBOARD'
  | 'CODE_BREAKER'
  | 'TEAM_BUILDER'
  | 'LOOT_SIMULATOR'
  | 'AIM_TRAINER'
  | 'ARMOR_CALCULATOR'
  | 'AUTOMATION_LIST'
  | 'AUTOMATION_DETAIL'
  | 'BLACKJACK'
  | 'WHEEL_GAME'
  | 'DECAY_TIMERS'
  | 'RETENTION_DISCOUNT'
  | 'SOCIAL_PROOF'
  | 'NOTIFICATION_PERMISSION'
  | 'CRITICAL_ALERT_PERMISSION';

export type UserRole = 'FREE' | 'OWNER' | 'MEMBER';

export type PlanType = 'SOLO' | 'DUO' | 'TRIO' | 'SQUAD' | 'CLAN';

export interface Question {
  id: number;
  text: string;
  options: string[];
}

export interface PlanDetails {
  id: PlanType;
  name: string;
  slots: number;
  price: string;
  popular?: boolean;
}

export interface ServerPromoDetails {
  groupLimit?: string;
  blueprints?: string;
  kits?: string;
  decay?: string;
  upkeep?: string;
  rates?: string;
  monuments?: number;
  wipeSchedule?: string[];
  features?: string[];
  socials?: {
    store?: string;
    website?: string;
    discord?: string;
    youtube?: string;
  };
}

export interface ServerData {
  id: string;
  name: string;
  ip: string;
  port: number;
  players: number;
  maxPlayers: number;
  status: string;
  rank?: number;
  country?: string;
  map?: string;
  mapSize?: number;
  seed?: number;
  lastWipe?: string;
  nextWipe?: string;
  description?: string;
  url?: string;
  official?: boolean;
  modded?: boolean;
  pve?: boolean;
  fps?: number;
  uptime?: number;
  headerImage?: string;
  entities?: number;
  promoDetails?: ServerPromoDetails;
}

export interface ResourceUpkeep {
  costPerDay: number;
  amount: number;
}

export interface UpkeepState {
  wood: ResourceUpkeep;
  stone: ResourceUpkeep;
  metal: ResourceUpkeep;
  hqm: ResourceUpkeep;
  lastUpdated: number;
}

export interface AlertConfig {
  onOnline: boolean;
  onOffline: boolean;
}

export interface TargetPlayer {
  id?: string;
  name: string;
  isOnline: boolean;
  lastSeen: string;
  alertConfig?: AlertConfig;
}

export interface AppState {
  currentScreen: ScreenName;
  userRole: UserRole;
  plan: PlanType | null;
  teamSize: number;
  currentMembers: number;
  onboardingData: Record<number, string>;
  savedServer: ServerData | null;
  isOnlineInGame: boolean;
  wipeAlertEnabled: boolean;
  wipeAlertMinutes: number;
  upkeep: UpkeepState;
  trackedTargets: TargetPlayer[];
  aiUsageCount: number;
}

export interface ActiveRaid {
  targetName: string;
  targetId?: string;
  startTime: number;
}

export type CategoryType = 
  | 'large_oil' 
  | 'small_oil' 
  | 'cargo' 
  | 'silo' 
  | 'airfield' 
  | 'bandit' 
  | 'outpost' 
  | 'ferry' 
  | 'radtown' 
  | 'dome' 
  | 'labs';

export interface CameraCode {
  id: string;
  label: string;
  code: string;
  category: CategoryType;
  img?: string;
  isRandom?: boolean;
}
