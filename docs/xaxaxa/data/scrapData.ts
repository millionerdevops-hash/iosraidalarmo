import { Package, Gem, Zap, Shirt, Wrench, AlertOctagon, Crosshair, Sword, HeartPulse, Briefcase, Gamepad2, MoreHorizontal } from 'lucide-react';

export type RecyclerMode = 'radtown' | 'safezone';

export type Category = 
  | 'ammunition'
  | 'attire'
  | 'component'
  | 'construction'
  | 'electrical'
  | 'fun'
  | 'items'
  | 'medical'
  | 'misc'
  | 'resources'
  | 'tool'
  | 'traps'
  | 'weapon';

export interface ComponentItem {
  id: string;
  name: string;
  category: Category;
  baseYield: {
    scrap?: number;
    hqm?: number; 
    metal?: number; 
    cloth?: number;
    leather?: number;
    wood?: number;
    gunpowder?: number;
    stones?: number;
    sulfur?: number;
    low_grade?: number;
    bone?: number;
    charcoal?: number;
    animal_fat?: number;
    medical_syringe?: number;
    gears?: number;
    blades?: number;
    pipe?: number;
    rope?: number;
    spring?: number;
    tech_trash?: number;
    explosives?: number;
    propane?: number;
    sewing?: number;
    rifle_body?: number;
    smg_body?: number;
    semi_body?: number;
    road_sign?: number;
    computer?: number;
    cctv?: number;
  };
}

// Data Source: RustLabs (Vanilla Rates)
export const COMPONENTS: ComponentItem[] = [
  // --- COMPONENT ---
  { id: 'tech_trash', name: 'Tech Trash', category: 'component', baseYield: { scrap: 20, hqm: 1 } },
  { id: 'rifle_body', name: 'Rifle Body', category: 'component', baseYield: { scrap: 25, hqm: 2 } },
  { id: 'smg_body', name: 'SMG Body', category: 'component', baseYield: { scrap: 15, hqm: 2 } },
  { id: 'semi_body', name: 'Semi Body', category: 'component', baseYield: { scrap: 15, hqm: 2, metal: 75 } },
  { id: 'gears', name: 'Gears', category: 'component', baseYield: { scrap: 10, metal: 13 } },
  { id: 'spring', name: 'Metal Spring', category: 'component', baseYield: { scrap: 10, hqm: 1 } },
  { id: 'sheet_metal', name: 'Sheet Metal', category: 'component', baseYield: { scrap: 8, metal: 100, hqm: 1 } },
  { id: 'pipe', name: 'Metal Pipe', category: 'component', baseYield: { scrap: 5, hqm: 1 } },
  { id: 'road_sign', name: 'Road Sign', category: 'component', baseYield: { scrap: 5, hqm: 1 } },
  { id: 'blade', name: 'Metal Blade', category: 'component', baseYield: { scrap: 2, metal: 15 } },
  { id: 'propane', name: 'Propane Tank', category: 'component', baseYield: { scrap: 1, metal: 50 } },
  { id: 'tarp', name: 'Tarp', category: 'component', baseYield: { cloth: 50 } },
  { id: 'rope', name: 'Rope', category: 'component', baseYield: { cloth: 15 } },
  { id: 'sewing', name: 'Sewing Kit', category: 'component', baseYield: { rope: 2, cloth: 10 } }, 

  // --- RESOURCES ---
  { id: 'cctv', name: 'CCTV Camera', category: 'resources', baseYield: { tech_trash: 2, hqm: 2 } },
  { id: 'computer', name: 'Targeting Computer', category: 'resources', baseYield: { tech_trash: 3, metal: 50, hqm: 1 } },
  { id: 'empty_can_beans', name: 'Empty Can Of Beans', category: 'resources', baseYield: { metal: 15 } },
  { id: 'empty_tuna_can', name: 'Empty Tuna Can', category: 'resources', baseYield: { metal: 10 } },
  { id: 'explosives_item', name: 'Explosives', category: 'resources', baseYield: { gunpowder: 25, sulfur: 5, metal: 5, low_grade: 1.5 } }, 
  { id: 'gunpowder_item', name: 'Gun Powder', category: 'resources', baseYield: { charcoal: 1.5, sulfur: 1 } }, 
  { id: 'low_grade_fuel', name: 'Low Grade Fuel', category: 'resources', baseYield: { } }, 
  { id: 'paper', name: 'Paper', category: 'resources', baseYield: { wood: 2.5 } },

  // --- MEDICAL ---
  { id: 'bandage', name: 'Bandage', category: 'medical', baseYield: { cloth: 2 } },
  { id: 'large_medkit', name: 'Large Medkit', category: 'medical', baseYield: { medical_syringe: 1, cloth: 25, low_grade: 5 } },
  { id: 'medical_syringe', name: 'Medical Syringe', category: 'medical', baseYield: { cloth: 8, metal: 5, low_grade: 5 } },

  // --- ELECTRICAL ---
  { id: 'fuse', name: 'Electric Fuse', category: 'electrical', baseYield: { scrap: 20 } },
  { id: 'laser_sight', name: 'Weapon Lasersight', category: 'electrical', baseYield: { scrap: 10, hqm: 2 } },
  { id: 'holo_sight', name: 'Holosight', category: 'electrical', baseYield: { scrap: 10, hqm: 1 } },
  { id: 'scope_8x', name: '8x Zoom Scope', category: 'electrical', baseYield: { hqm: 25 } },
  { id: 'scope_16x', name: '16x Zoom Scope', category: 'electrical', baseYield: { hqm: 20 } },
  { id: 'nvg', name: 'Night Vision Goggles', category: 'electrical', baseYield: { scrap: 10, hqm: 6 } },
  { id: 'solar_large', name: 'Large Solar Panel', category: 'electrical', baseYield: { scrap: 10, hqm: 3 } },
  { id: 'battery_large', name: 'Large Rech. Battery', category: 'electrical', baseYield: { scrap: 20, hqm: 2, metal: 50 } },
  { id: 'battery_medium', name: 'Medium Rech. Battery', category: 'electrical', baseYield: { scrap: 10, hqm: 1, metal: 25 } },
  { id: 'battery_small', name: 'Small Rech. Battery', category: 'electrical', baseYield: { hqm: 2 } },
  { id: 'rf_pager', name: 'RF Pager', category: 'electrical', baseYield: { scrap: 10, hqm: 1 } },
  { id: 'rf_receiver', name: 'RF Receiver', category: 'electrical', baseYield: { scrap: 10, hqm: 1 } },
  { id: 'rf_broadcaster', name: 'RF Broadcaster', category: 'electrical', baseYield: { scrap: 10, hqm: 1 } },
  { id: 'smart_switch', name: 'Smart Switch', category: 'electrical', baseYield: { scrap: 10, hqm: 1, metal: 5 } },
  { id: 'igniter', name: 'Igniter', category: 'electrical', baseYield: { scrap: 2, metal: 10 } }, 

  // --- ATTIRE ---
  { id: 'tac_gloves', name: 'Tactical Gloves', category: 'attire', baseYield: { cloth: 200 } }, 
  { id: 'hazmat', name: 'Hazmat Suit', category: 'attire', baseYield: { hqm: 4, cloth: 100 } }, 
  { id: 'hoodie', name: 'Hoodie', category: 'attire', baseYield: { cloth: 40, sewing: 1 } }, 
  { id: 'pants', name: 'Pants', category: 'attire', baseYield: { cloth: 40, sewing: 1 } }, 
  { id: 'roadsign_jacket', name: 'Roadsign Jacket', category: 'attire', baseYield: { leather: 20, sewing: 2, road_sign: 1 } }, 
  { id: 'roadsign_kilt', name: 'Roadsign Kilt', category: 'attire', baseYield: { leather: 20, sewing: 2, road_sign: 1 } }, 
  { id: 'metal_facemask', name: 'Metal Facemask', category: 'attire', baseYield: { hqm: 7, sewing: 3, leather: 25 } }, 
  { id: 'metal_chestplate', name: 'Metal Chestplate', category: 'attire', baseYield: { hqm: 12, sewing: 4, leather: 25 } }, 
  { id: 'riot_helmet', name: 'Riot Helmet', category: 'attire', baseYield: { metal: 10, cloth: 5 } },
  { id: 'bucket_helmet', name: 'Bucket Helmet', category: 'attire', baseYield: { metal: 25 } },

  // --- TOOL ---
  { id: 'binoculars', name: 'Binoculars', category: 'tool', baseYield: { scrap: 24, gears: 1 } },
  { id: 'chainsaw', name: 'Chainsaw', category: 'tool', baseYield: { hqm: 3, gears: 3, blades: 3 } },
  { id: 'compass', name: 'Compass', category: 'tool', baseYield: { metal: 10 } },
  { id: 'flare', name: 'Flare', category: 'tool', baseYield: { gunpowder: 5, metal: 5 } },
  { id: 'flashlight', name: 'Flashlight', category: 'tool', baseYield: { metal: 5 } },
  { id: 'jackhammer', name: 'Jackhammer', category: 'tool', baseYield: { hqm: 2, blades: 3 } },
  { id: 'hatchet', name: 'Hatchet', category: 'tool', baseYield: { wood: 50, metal: 38 } },
  { id: 'pickaxe', name: 'Pickaxe', category: 'tool', baseYield: { wood: 50, metal: 63 } },
  { id: 'satchel', name: 'Satchel Charge', category: 'tool', baseYield: { gunpowder: 240, charcoal: 360, metal: 40, rope: 0.5 } }, 
  { id: 'c4', name: 'Timed Explosive Charge', category: 'tool', baseYield: { explosives: 10, tech_trash: 1 } },

  // --- TRAPS ---
  { id: 'auto_turret', name: 'Auto Turret', category: 'traps', baseYield: { hqm: 5, computer: 1, cctv: 1 } },
  { id: 'flame_turret', name: 'Flame Turret', category: 'traps', baseYield: { metal: 150, propane: 1, tech_trash: 1, pipe: 2 } },
  { id: 'shotgun_trap', name: 'Shotgun Trap', category: 'traps', baseYield: { wood: 250, metal: 125, gears: 1 } },

  // --- WEAPON ---
  { id: 'ak47', name: 'Assault Rifle', category: 'weapon', baseYield: { wood: 25, rifle_body: 1, spring: 2 } },
  { id: 'bolt_rifle', name: 'Bolt Action Rifle', category: 'weapon', baseYield: { metal: 10, rifle_body: 1, spring: 1, pipe: 2 } },
  { id: 'mp5', name: 'MP5A4', category: 'weapon', baseYield: { smg_body: 1, spring: 1, metal: 8 } },
  { id: 'thompson', name: 'Thompson', category: 'weapon', baseYield: { wood: 50, smg_body: 1, spring: 1 } },
  { id: 'custom_smg', name: 'Custom SMG', category: 'weapon', baseYield: { smg_body: 1, spring: 1, metal: 5 } },
  { id: 'semi_rifle', name: 'Semi-Automatic Rifle', category: 'weapon', baseYield: { metal: 225, semi_body: 1, spring: 1 } },
  { id: 'semi_pistol', name: 'Semi-Automatic Pistol', category: 'weapon', baseYield: { metal: 3, semi_body: 1, pipe: 1 } },
  { id: 'python', name: 'Python Revolver', category: 'weapon', baseYield: { metal: 3, spring: 1, pipe: 3 } },
  { id: 'revolver', name: 'Revolver', category: 'weapon', baseYield: { metal: 13, pipe: 1 } },
  { id: 'lr300', name: 'LR-300', category: 'weapon', baseYield: { rifle_body: 1, spring: 1, metal: 20 } },
  { id: 'm249', name: 'M249', category: 'weapon', baseYield: { rifle_body: 1, spring: 2, metal: 25 } },
  { id: 'rocket_launcher', name: 'Rocket Launcher', category: 'weapon', baseYield: { hqm: 25, pipe: 5 } },

  // --- AMMUNITION ---
  { id: 'ammo_rifle', name: '5.56 Rifle Ammo', category: 'ammunition', baseYield: { gunpowder: 2.5, metal: 1.5 } },
  { id: 'ammo_rifle_explo', name: 'Explosive 5.56 Rifle Ammo', category: 'ammunition', baseYield: { gunpowder: 5, metal: 2.5, sulfur: 2.5 } },
  { id: 'ammo_rifle_hv', name: 'HV 5.56 Rifle Ammo', category: 'ammunition', baseYield: { gunpowder: 10, metal: 5 } },
  { id: 'ammo_rifle_incen', name: 'Incendiary 5.56 Rifle Ammo', category: 'ammunition', baseYield: { gunpowder: 5, metal: 2.5, sulfur: 2.5 } },
  { id: 'ammo_pistol', name: 'Pistol Bullet', category: 'ammunition', baseYield: { gunpowder: 1.66, metal: 0.83 } },
  { id: 'ammo_pistol_hv', name: 'HV Pistol Ammo', category: 'ammunition', baseYield: { gunpowder: 3.33, metal: 1.66 } },
  { id: 'ammo_pistol_incen', name: 'Incendiary Pistol Bullet', category: 'ammunition', baseYield: { gunpowder: 3.33, metal: 1.66, sulfur: 1.66 } },
  { id: 'ammo_shotgun', name: '12 Gauge Buckshot', category: 'ammunition', baseYield: { gunpowder: 7.5, metal: 7.5 } },
  { id: 'ammo_shotgun_slug', name: '12 Gauge Slug', category: 'ammunition', baseYield: { gunpowder: 5, metal: 5 } },
  { id: 'ammo_shotgun_incen', name: '12 Gauge Incendiary Shell', category: 'ammunition', baseYield: { gunpowder: 5, metal: 2.5, sulfur: 5 } },
  { id: 'ammo_handmade', name: 'Handmade Shell', category: 'ammunition', baseYield: { gunpowder: 2.5, stones: 2.5 } },
  { id: 'arrow_wooden', name: 'Wooden Arrow', category: 'ammunition', baseYield: { wood: 12.5, stones: 2.5 } },
  { id: 'arrow_bone', name: 'Bone Arrow', category: 'ammunition', baseYield: { bone: 5 } },
  { id: 'arrow_fire', name: 'Fire Arrow', category: 'ammunition', baseYield: { wood: 10, cloth: 1, low_grade: 2 } },
  { id: 'arrow_hv', name: 'High Velocity Arrow', category: 'ammunition', baseYield: { wood: 10, stones: 2.5 } },
  { id: 'rocket_basic', name: 'Rocket', category: 'ammunition', baseYield: { gunpowder: 75, explosives: 5, pipe: 1 } },
  { id: 'rocket_hv', name: 'High Velocity Rocket', category: 'ammunition', baseYield: { gunpowder: 50, pipe: 1 } },
  { id: 'rocket_incen', name: 'Incendiary Rocket', category: 'ammunition', baseYield: { gunpowder: 125, explosives: 1, pipe: 1, low_grade: 25 } },
];

export const CATEGORIES: { id: Category, label: string, icon: any }[] = [
    { id: 'component', label: 'Comps', icon: Package },
    { id: 'resources', label: 'Res', icon: Gem },
    { id: 'electrical', label: 'Elec', icon: Zap },
    { id: 'attire', label: 'Attire', icon: Shirt },
    { id: 'tool', label: 'Tool', icon: Wrench },
    { id: 'traps', label: 'Traps', icon: AlertOctagon },
    { id: 'ammunition', label: 'Ammo', icon: Crosshair },
    { id: 'weapon', label: 'Weapon', icon: Sword },
    { id: 'medical', label: 'Meds', icon: HeartPulse },
    { id: 'items', label: 'Items', icon: Briefcase },
    { id: 'fun', label: 'Fun', icon: Gamepad2 },
    { id: 'misc', label: 'Misc', icon: MoreHorizontal },
];