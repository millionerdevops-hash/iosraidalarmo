
// --- TYPES ---

export type Tier = 'wood' | 'stone' | 'metal' | 'hqm' | 'item' | 'glass' | 'twig';

export interface RaidTarget {
  id: string;
  label: string;
  subLabel?: string; 
  tier: Tier;
  category: 'construction' | 'door' | 'item' | 'placeable';
  hp: number;
  img: string;
}

export interface RaidWeapon {
    id: string;
    name: string;
    img: string;
}

export interface RaidAmmo {
    id: string;
    name: string;
    img: string;
    sulfurCost: number;
    // Simplified crafting costs for display
    recipe: {
        sulfur?: number;
        charcoal?: number;
        metal?: number;
        gunpowder?: number;
        fuel?: number;
        pipes?: number;
        tech?: number;
        stones?: number;
        wood?: number;
        cloth?: number;
        animal_fat?: number;
    }
}

export interface RaidMethod {
    id: string;
    weaponId: string | null; // null for thrown items like C4
    ammoId: string;
    damage: number; // Base damage per shot against standard structures
    damageOverride?: Record<string, number>; // Specific damage against specific Target IDs (e.g. turret)
    fireRate?: number; // Shots per minute (approx)
    isMelee?: boolean;
    isEco?: boolean; // For filtering
}

// --- DATA: WEAPONS ---
const WEAPONS: Record<string, RaidWeapon> = {
    waterpipe: { id: 'waterpipe', name: 'Waterpipe', img: 'https://rustlabs.com/img/items180/shotgun.waterpipe.png' },
    db: { id: 'db', name: 'Double Barrel', img: 'https://rustlabs.com/img/items180/shotgun.double.png' },
    spas: { id: 'spas', name: 'Spas-12', img: 'https://rustlabs.com/img/items180/shotgun.spas12.png' },
    ak: { id: 'ak', name: 'Assault Rifle', img: 'https://rustlabs.com/img/items180/rifle.ak.png' },
    sar: { id: 'sar', name: 'Semi Rifle', img: 'https://rustlabs.com/img/items180/rifle.semiauto.png' },
    launcher: { id: 'launcher', name: 'Rocket Launcher', img: 'https://rustlabs.com/img/items180/rocket.launcher.png' },
    mlrs: { id: 'mlrs', name: 'MLRS', img: 'https://rustlabs.com/img/items180/mlrs.png' },
    mgl: { id: 'mgl', name: 'MGL', img: 'https://rustlabs.com/img/items180/multiplegrenadelauncher.png' }, // Added for 40mm
    spear_wood: { id: 'spear_wood', name: 'Wooden Spear', img: 'https://rustlabs.com/img/items180/spear.wooden.png' },
    spear_stone: { id: 'spear_stone', name: 'Stone Spear', img: 'https://rustlabs.com/img/items180/spear.stone.png' },
};

// --- DATA: AMMO / EXPLOSIVES ---
export const AMMO: Record<string, RaidAmmo> = {
    c4: { 
        id: 'c4', name: 'Timed Explosive', 
        img: 'https://rustlabs.com/img/items180/explosive.timed.png', 
        sulfurCost: 2200, 
        recipe: { sulfur: 2200, charcoal: 3000, metal: 200, fuel: 60, tech: 2, cloth: 5 } 
    },
    rocket: { 
        id: 'rocket', name: 'Rocket', 
        img: 'https://rustlabs.com/img/items180/ammo.rocket.basic.png', 
        sulfurCost: 1400,
        recipe: { sulfur: 1400, charcoal: 1950, metal: 100, fuel: 30, pipes: 2 }
    },
    hv_rocket: { 
        id: 'hv_rocket', name: 'HV Rocket', 
        img: 'https://rustlabs.com/img/items180/ammo.rocket.hv.png', 
        sulfurCost: 200,
        recipe: { sulfur: 200, charcoal: 300, pipes: 1 }
    },
    incen_rocket: { 
        id: 'incen_rocket', name: 'Incen Rocket', 
        img: 'https://rustlabs.com/img/items180/ammo.rocket.fire.png', 
        sulfurCost: 610, // Approx value considering fuel
        recipe: { sulfur: 300, charcoal: 450, fuel: 75, pipes: 2 }
    },
    satchel: { 
        id: 'satchel', name: 'Satchel Charge', 
        img: 'https://rustlabs.com/img/items180/explosive.satchel.png', 
        sulfurCost: 480,
        recipe: { sulfur: 480, charcoal: 720, metal: 80, cloth: 10 }
    },
    beancan: { 
        id: 'beancan', name: 'Beancan Grenade', 
        img: 'https://rustlabs.com/img/items180/grenade.beancan.png', 
        sulfurCost: 120,
        recipe: { sulfur: 120, charcoal: 180, metal: 20 }
    },
    f1_grenade: { 
        id: 'f1_grenade', name: 'F1 Grenade', 
        img: 'https://rustlabs.com/img/items180/grenade.f1.png', 
        sulfurCost: 60, // 30 GP
        recipe: { sulfur: 60, charcoal: 90, metal: 15 }
    },
    he_40mm: {
        id: 'he_40mm', name: '40mm HE',
        img: 'https://rustlabs.com/img/items180/ammo.grenadelauncher.he.png',
        sulfurCost: 0, // Uncraftable / Scrap cost usually
        recipe: { } 
    },
    explo556: { 
        id: 'explo556', name: 'Explosive 5.56', 
        img: 'https://rustlabs.com/img/items180/ammo.rifle.explosive.png', 
        sulfurCost: 25,
        recipe: { sulfur: 25, charcoal: 30, metal: 10 }
    },
    handmade: { 
        id: 'handmade', name: 'Handmade Shell', 
        img: 'https://rustlabs.com/img/items180/ammo.handmade.shell.png', 
        sulfurCost: 5,
        recipe: { sulfur: 5, charcoal: 7.5, stones: 2.5 }
    },
    buckshot: { 
        id: 'buckshot', name: 'Buckshot', 
        img: 'https://rustlabs.com/img/items180/ammo.shotgun.png', 
        sulfurCost: 10, // Simplified GP cost
        recipe: { sulfur: 5, charcoal: 7.5, metal: 10 } // Simplified
    },
    molotov: {
        id: 'molotov', name: 'Molotov',
        img: 'https://rustlabs.com/img/items180/grenade.molotov.png',
        sulfurCost: 0,
        recipe: { cloth: 10, fuel: 50 }
    }
};

// --- DATA: RAID METHODS (Combinations) ---
export const RAID_METHODS: RaidMethod[] = [
    // EXPLOSIVES (No Weapon)
    { 
        id: 'method_c4', 
        weaponId: null, 
        ammoId: 'c4', 
        damage: 550, // Wall damage
        damageOverride: { 'turret': 1000 } // 1 C4 kills turret
    },
    { 
        id: 'method_rocket', 
        weaponId: 'launcher', 
        ammoId: 'rocket', 
        damage: 350,
        damageOverride: { 'turret': 500 } // 2 Rockets kill turret
    },
    { 
        id: 'method_hv_rocket', 
        weaponId: 'launcher', 
        ammoId: 'hv_rocket', 
        damage: 325, 
        damageOverride: { 'turret': 334 } // 3 HV Rockets kill turret (1000/334 = 2.99 -> 3)
    },
    { 
        id: 'method_incen_rocket', 
        weaponId: 'launcher', 
        ammoId: 'incen_rocket', 
        damage: 0, // Generally useless vs walls for boom
        damageOverride: { 'turret': 500 } // 2 Incen rockets kill turret
    },
    { 
        id: 'method_satchel', 
        weaponId: null, 
        ammoId: 'satchel', 
        damage: 95, 
        damageOverride: { 'turret': 250 } // 4 Satchels kill turret
    },
    { 
        id: 'method_beancan', 
        weaponId: null, 
        ammoId: 'beancan', 
        damage: 18,
        damageOverride: { 'turret': 63 } // ~16 Beancans
    },
    { 
        id: 'method_f1', 
        weaponId: null, 
        ammoId: 'f1_grenade', 
        damage: 10, // Very low vs walls
        damageOverride: { 'turret': 19 } // ~53-54 Grenades
    },
    { 
        id: 'method_40mm', 
        weaponId: 'mgl', 
        ammoId: 'he_40mm', 
        damage: 15, // Low vs walls
        damageOverride: { 'turret': 77 } // ~13 shots
    },

    // FIRE
    { 
        id: 'method_molotov', 
        weaponId: null, 
        ammoId: 'molotov', 
        damage: 15, 
        damageOverride: { 'turret': 125 }, // ~8 Molotovs
        isEco: true 
    },

    // EXPLO AMMO
    { 
        id: 'method_ak_explo', 
        weaponId: 'ak', 
        ammoId: 'explo556', 
        damage: 2.5,
        damageOverride: { 'turret': 9.5 } // ~106 shots
    }, 
    { 
        id: 'method_sar_explo', 
        weaponId: 'sar', 
        ammoId: 'explo556', 
        damage: 2.5,
        damageOverride: { 'turret': 9.5 }
    },

    // ECO / SHOTGUNS
    { id: 'method_waterpipe_handmade', weaponId: 'waterpipe', ammoId: 'handmade', damage: 4.5, isEco: true }, 
    { id: 'method_spas_handmade', weaponId: 'spas', ammoId: 'handmade', damage: 3.5, isEco: true }, 
    { id: 'method_db_handmade', weaponId: 'db', ammoId: 'handmade', damage: 4.5, isEco: true },
    
    { id: 'method_waterpipe_buckshot', weaponId: 'waterpipe', ammoId: 'buckshot', damage: 5.2, isEco: true },
    { id: 'method_db_buckshot', weaponId: 'db', ammoId: 'buckshot', damage: 5.2, isEco: true },
    { id: 'method_spas_buckshot', weaponId: 'spas', ammoId: 'buckshot', damage: 4.0, isEco: true },
];

export const getWeapon = (id: string | null) => id ? WEAPONS[id] : null;
export const getAmmo = (id: string) => AMMO[id];

// --- DATA: TARGETS ---
export const TARGETS: RaidTarget[] = [
  // CONSTRUCTION
  { id: 'wood_wall', label: 'Wood Wall', tier: 'wood', category: 'construction', hp: 250, img: 'https://rustlabs.com/img/items180/wall.external.high.wood.png' }, 
  { id: 'stone_wall', label: 'Stone Wall', tier: 'stone', category: 'construction', hp: 500, img: 'https://rustlabs.com/img/items180/wall.external.high.stone.png' },
  { id: 'metal_wall', label: 'Metal Wall', tier: 'metal', category: 'construction', hp: 1000, img: 'https://rustlabs.com/img/items180/metal.wall.png' }, 
  { id: 'hqm_wall', label: 'Armored Wall', tier: 'hqm', category: 'construction', hp: 2000, img: 'https://rustlabs.com/img/items180/metal.wall.png' },

  // DOORS
  { id: 'wood_door', label: 'Wood Door', tier: 'wood', category: 'door', hp: 200, img: 'https://rustlabs.com/img/items180/door.double.hinged.wood.png' },
  { id: 'sheet_door', label: 'Sheet Door', tier: 'metal', category: 'door', hp: 250, img: 'https://rustlabs.com/img/items180/door.hinged.metal.png' },
  { id: 'garage_door', label: 'Garage Door', tier: 'metal', category: 'door', hp: 600, img: 'https://rustlabs.com/img/items180/wall.frame.garagedoor.png' },
  { id: 'armored_door', label: 'Armored Door', tier: 'hqm', category: 'door', hp: 1000, img: 'https://rustlabs.com/img/items180/door.hinged.toptier.png' },
  
  // ITEMS
  { id: 'tc', label: 'Tool Cupboard', tier: 'wood', category: 'item', hp: 100, img: 'https://rustlabs.com/img/items180/cupboard.tool.png' },
  { id: 'turret', label: 'Auto Turret', tier: 'metal', category: 'item', hp: 1000, img: 'https://rustlabs.com/img/items180/autoturret.png' },
  { id: 'high_wall_stone', label: 'High Stone Wall', tier: 'stone', category: 'placeable', hp: 500, img: 'https://rustlabs.com/img/items180/wall.external.high.stone.png' },
];
