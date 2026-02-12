
export type ArmorSlot = 'Head' | 'Chest' | 'Legs' | 'Boots' | 'Hands';

export interface ArmorItem {
    id: string;
    name: string;
    slot: ArmorSlot;
    image: string;
    stats: {
        projectile: number;
        cold: number;
        radiation: number;
        explosion: number;
    };
}

export interface ArmorPreset {
    id: string;
    name: string;
    description: string;
    items: string[]; // List of Item IDs
    bg: string;
}

export interface ZoneRequirement {
    id: string;
    name: string;
    rads: number; // Minimum Rad Protection needed
    cold: number; // Recommended Cold Protection (Night)
    cards: ('Green' | 'Blue' | 'Red')[];
    fuse: number; // Fuses needed
    notes: string;
}

// Images from RustLabs
const BASE_URL = 'https://rustlabs.com/img/items180';

export const ARMOR_ITEMS: ArmorItem[] = [
    // --- HEAD ---
    { 
        id: 'metal_mask', name: 'Metal Facemask', slot: 'Head', 
        image: `${BASE_URL}/metal.facemask.png`, 
        stats: { projectile: 50, cold: -4, radiation: 7, explosion: 8 } 
    },
    { 
        id: 'heavy_helmet', name: 'Heavy Plate Helmet', slot: 'Head', 
        image: `${BASE_URL}/heavy.plate.helmet.png`, 
        stats: { projectile: 90, cold: 0, radiation: 0, explosion: 15 } 
    },
    { 
        id: 'coffee_can', name: 'Coffee Can Helmet', slot: 'Head', 
        image: `${BASE_URL}/coffeecan.helmet.png`, 
        stats: { projectile: 35, cold: 8, radiation: 5, explosion: 8 } 
    },
    { 
        id: 'wolf_head', name: 'Wolf Headdress', slot: 'Head', 
        image: `${BASE_URL}/hat.wolf.png`, 
        stats: { projectile: 30, cold: 20, radiation: 5, explosion: 5 } 
    },
    { 
        id: 'riot_helm', name: 'Riot Helmet', slot: 'Head', 
        image: `${BASE_URL}/riot.helmet.png`, 
        stats: { projectile: 25, cold: 10, radiation: 4, explosion: 3 } 
    },
    { 
        id: 'bucket_helm', name: 'Bucket Helmet', slot: 'Head', 
        image: `${BASE_URL}/bucket.helmet.png`, 
        stats: { projectile: 25, cold: 5, radiation: 3, explosion: 3 } 
    },
    { 
        id: 'diving_mask', name: 'Diving Mask', slot: 'Head', 
        image: `${BASE_URL}/diving.mask.png`, 
        stats: { projectile: 5, cold: 0, radiation: 0, explosion: 0 } 
    },
    {
        id: 'bandana', name: 'Bandana Mask', slot: 'Head',
        image: `${BASE_URL}/mask.bandana.png`,
        stats: { projectile: 5, cold: 10, radiation: 3, explosion: 0 }
    },

    // --- CHEST (Outer) ---
    { 
        id: 'heavy_jacket', name: 'Heavy Plate Jacket', slot: 'Chest', 
        image: `${BASE_URL}/heavy.plate.jacket.png`, 
        stats: { projectile: 75, cold: 0, radiation: 0, explosion: 15 } 
    },
    { 
        id: 'metal_chest', name: 'Metal Chest Plate', slot: 'Chest', 
        image: `${BASE_URL}/metal.plate.torso.png`, 
        stats: { projectile: 25, cold: -8, radiation: 5, explosion: 10 } 
    },
    { 
        id: 'roadsign_jacket', name: 'Road Sign Jacket', slot: 'Chest', 
        image: `${BASE_URL}/roadsign.jacket.png`, 
        stats: { projectile: 20, cold: -8, radiation: 3, explosion: 5 } 
    },
    { 
        id: 'jacket', name: 'Jacket', slot: 'Chest', 
        image: `${BASE_URL}/jacket.png`, 
        stats: { projectile: 15, cold: 10, radiation: 5, explosion: 2 } 
    },
    { 
        id: 'snow_jacket', name: 'Snow Jacket', slot: 'Chest', 
        image: `${BASE_URL}/jacket.snow.png`, 
        stats: { projectile: 10, cold: 40, radiation: 0, explosion: 2 } 
    },
    
    // --- CHEST (Inner/Under) ---
    // Note: Rust allows wearing Hoodie under Chestplate. 
    // In this app, users can select items for slots. 
    { 
        id: 'hoodie', name: 'Hoodie', slot: 'Chest', 
        image: `${BASE_URL}/hoodie.png`, 
        stats: { projectile: 20, cold: 8, radiation: 5, explosion: 2 } 
    },
    { 
        id: 'wetsuit', name: 'Wetsuit', slot: 'Chest', 
        image: `${BASE_URL}/diving.wetsuit.png`, 
        stats: { projectile: 5, cold: 30, radiation: 5, explosion: 2 } 
    },
    { 
        id: 'tank_top', name: 'Diving Tank', slot: 'Chest', 
        image: `${BASE_URL}/diving.tank.png`, 
        stats: { projectile: 5, cold: 0, radiation: 0, explosion: 0 } 
    },

    // --- LEGS (Outer) ---
    { 
        id: 'heavy_pants', name: 'Heavy Plate Pants', slot: 'Legs', 
        image: `${BASE_URL}/heavy.plate.pants.png`, 
        stats: { projectile: 75, cold: 0, radiation: 0, explosion: 15 } 
    },
    { 
        id: 'roadsign_kilt', name: 'Road Sign Kilt', slot: 'Legs', 
        image: `${BASE_URL}/roadsign.kilt.png`, 
        stats: { projectile: 20, cold: -8, radiation: 2, explosion: 5 } 
    },
    { 
        id: 'wooden_armor', name: 'Wood Armor Pants', slot: 'Legs', 
        image: `${BASE_URL}/wood.armor.pants.png`, 
        stats: { projectile: 10, cold: 0, radiation: 0, explosion: 0 } 
    },

    // --- LEGS (Inner) ---
    { 
        id: 'pants', name: 'Pants', slot: 'Legs', 
        image: `${BASE_URL}/pants.png`, 
        stats: { projectile: 15, cold: 8, radiation: 5, explosion: 2 } 
    },

    // --- BOOTS ---
    { 
        id: 'boots', name: 'Boots', slot: 'Boots', 
        image: `${BASE_URL}/shoes.boots.png`, 
        stats: { projectile: 10, cold: 8, radiation: 3, explosion: 3 } 
    },
    { 
        id: 'frog_boots', name: 'Frog Boots', slot: 'Boots', 
        image: `${BASE_URL}/boots.frog.png`, 
        stats: { projectile: 0, cold: 20, radiation: 15, explosion: 0 } 
    },
    { 
        id: 'fins', name: 'Diving Fins', slot: 'Boots', 
        image: `${BASE_URL}/diving.fins.png`, 
        stats: { projectile: 5, cold: 5, radiation: 0, explosion: 0 } 
    },

    // --- HANDS ---
    { 
        id: 'tac_gloves', name: 'Tactical Gloves', slot: 'Hands', 
        image: `${BASE_URL}/tactical.gloves.png`, 
        stats: { projectile: 5, cold: 15, radiation: 0, explosion: 0 } 
    },
    { 
        id: 'leather_gloves', name: 'Leather Gloves', slot: 'Hands', 
        image: `${BASE_URL}/burlap.gloves.png`, 
        stats: { projectile: 5, cold: 5, radiation: 4, explosion: 0 } 
    }, 
    { 
        id: 'roadsign_gloves', name: 'Roadsign Gloves', slot: 'Hands', 
        image: `${BASE_URL}/roadsign.gloves.png`, 
        stats: { projectile: 10, cold: -8, radiation: 2, explosion: 0 } 
    }
];

export const HAZMAT_ITEM: ArmorItem = { 
    id: 'hazmat', name: 'Hazmat Suit', slot: 'Chest', 
    image: `${BASE_URL}/hazmatsuit.png`, 
    stats: { projectile: 30, cold: 8, radiation: 50, explosion: 5 } 
};

export const PRESETS: ArmorPreset[] = [
    {
        id: 'full_metal',
        name: 'Full Metal',
        description: 'Standard PvP meta. High protection.',
        bg: 'from-red-900',
        items: ['metal_mask', 'metal_chest', 'hoodie', 'roadsign_kilt', 'pants', 'boots', 'tac_gloves'] 
    },
    {
        id: 'snow_roam',
        name: 'Arctic Warrior',
        description: 'Metal Mask + Jacket. Best armor for Snow.',
        bg: 'from-cyan-900',
        items: ['metal_mask', 'jacket', 'hoodie', 'pants', 'roadsign_kilt', 'boots', 'tac_gloves']
    },
    {
        id: 'heavy_defense',
        name: 'Base Defender',
        description: 'Heavy Plate. Slow movement, max armor.',
        bg: 'from-zinc-800',
        items: ['heavy_helmet', 'heavy_jacket', 'heavy_pants', 'boots', 'leather_gloves']
    },
    {
        id: 'rad_soldier',
        name: 'Rad Fighter',
        description: 'Roadsign kit with ~25% Rad protection.',
        bg: 'from-orange-800',
        items: ['coffee_can', 'roadsign_jacket', 'hoodie', 'pants', 'roadsign_kilt', 'boots', 'leather_gloves']
    },
    {
        id: 'ocean_ops',
        name: 'Ocean Ops',
        description: 'Wetsuit + Mask for Oil Rig counters.',
        bg: 'from-blue-900',
        items: ['diving_mask', 'wetsuit', 'tank_top', 'fins', 'tac_gloves']
    },
    {
        id: 'prim_gear',
        name: 'Wolf Hunter',
        description: 'Wolf Headdress is cheaper & better than wood.',
        bg: 'from-yellow-900',
        items: ['wolf_head', 'hoodie', 'wooden_armor', 'pants', 'boots']
    }
];

// NEW: Zone Requirements Data
export const ZONE_DATA: ZoneRequirement[] = [
    { 
        id: 'launch_site', name: 'Launch Site (Red)', rads: 50, cold: 0, cards: ['Green', 'Blue', 'Red'], fuse: 2,
        notes: "Main building requires Hazmat (50% Rad). Without it, you take rapid damage. Bradley APC patrols outside." 
    },
    { 
        id: 'nuke_silo', name: 'Nuclear Silo', rads: 50, cold: 0, cards: ['Blue'], fuse: 1,
        notes: "Endgame monument. Hazmat suit mandatory. High radiation inside. Scientists use NVG." 
    },
    { 
        id: 'mil_tunnels', name: 'Military Tunnels', rads: 25, cold: 0, cards: ['Green', 'Blue', 'Red'], fuse: 1,
        notes: "25% Rad protection required. Full kit recommended. Heavy Scientist resistance." 
    },
    { 
        id: 'power_plant', name: 'Power Plant', rads: 25, cold: 0, cards: ['Green', 'Blue'], fuse: 1,
        notes: "25% Rad protection. Many camping spots. Puzzle requires running between buildings." 
    },
    { 
        id: 'train_yard', name: 'Train Yard', rads: 25, cold: 0, cards: ['Blue'], fuse: 1,
        notes: "25% Rad protection. Good loot density. Watch tower snipers." 
    },
    { 
        id: 'water_treatment', name: 'Water Treatment', rads: 25, cold: 0, cards: ['Blue'], fuse: 1,
        notes: "25% Rad protection. Open area suitable for long-range fights." 
    },
    { 
        id: 'airfield', name: 'Airfield', rads: 10, cold: 0, cards: ['Green', 'Blue'], fuse: 2,
        notes: "10% Rad protection (Basic clothes). Wide open runway. Tunnels below have loot." 
    },
    { 
        id: 'arctic_base', name: 'Arctic Research', rads: 10, cold: 40, cards: ['Blue'], fuse: 1,
        notes: "Low Rads but Extreme Cold at night. Wear Jacket/Pants. Scientists have infinite ammo." 
    },
    { 
        id: 'sewer_branch', name: 'Sewer Branch', rads: 10, cold: 0, cards: ['Green'], fuse: 1,
        notes: "10% Rad protection. Parkour puzzle inside. Good for solo players." 
    },
    { 
        id: 'dome', name: 'The Dome', rads: 10, cold: 0, cards: [], fuse: 0,
        notes: "10% Rad protection needed to climb. 4 Military crates at the top. Fall damage risk." 
    },
    { 
        id: 'oil_rig', name: 'Oil Rig (Large/Small)', rads: 0, cold: 10, cards: ['Blue', 'Red'], fuse: 0,
        notes: "No radiation unless Locked Crate timer starts (sometimes). Cold at night on sea." 
    },
    { 
        id: 'underwater_lab', name: 'Underwater Lab', rads: 0, cold: 15, cards: ['Green', 'Blue', 'Red'], fuse: 2,
        notes: "Requires Diving Tank to reach. No Rads inside. Close quarters combat." 
    },
    { 
        id: 'snow_biome', name: 'Snow Biome (Night)', rads: 0, cold: 50, cards: [], fuse: 0,
        notes: "Freezing. Metal armor kills you here at night. Use Snow Jacket or Wetsuit combo." 
    }
];
