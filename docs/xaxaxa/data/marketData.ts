
export type MarketCategory = 'Exchange' | 'Weapon' | 'Vehicle' | 'Component' | 'Build' | 'Gear' | 'Farm';

export interface MarketItem {
    id: string;
    name: string;
    category: MarketCategory;
    cost: number;
    currency: 'Scrap' | 'Stone' | 'Sulfur' | 'HQM' | 'Wood' | 'Cloth' | 'Fertilizer' | 'Trout';
    outputAmount: number; // How much you get per cost (Batch size)
    location: 'Outpost' | 'Bandit' | 'Fishing' | 'Stables';
    image: string;
}

// Data based on vanilla Rust rates
export const MARKET_ITEMS: MarketItem[] = [
    // --- EXCHANGE (Outpost) ---
    { id: 'wood_exch', name: 'Wood (Bulk)', category: 'Exchange', cost: 150, currency: 'Stone', outputAmount: 500, location: 'Outpost', image: 'https://rustlabs.com/img/items180/wood.png' },
    { id: 'stone_exch', name: 'Stone (Bulk)', category: 'Exchange', cost: 500, currency: 'Wood', outputAmount: 150, location: 'Outpost', image: 'https://rustlabs.com/img/items180/stones.png' },
    { id: 'metal_exch', name: 'Metal Frags', category: 'Exchange', cost: 25, currency: 'Scrap', outputAmount: 250, location: 'Outpost', image: 'https://rustlabs.com/img/items180/metal.fragments.png' },
    { id: 'lgf_exch', name: 'Low Grade Fuel', category: 'Exchange', cost: 10, currency: 'Scrap', outputAmount: 20, location: 'Outpost', image: 'https://rustlabs.com/img/items180/lowgradefuel.png' },
    { id: 'smoke_exch', name: 'Smoke Grenade', category: 'Exchange', cost: 5, currency: 'Scrap', outputAmount: 1, location: 'Outpost', image: 'https://rustlabs.com/img/items180/grenade.smoke.png' },
    
    // --- FARM / TRADING (Bandit & Fishing) ---
    { id: 'fert_exch', name: 'Scrap (Fertilizer)', category: 'Farm', cost: 2, currency: 'Fertilizer', outputAmount: 3, location: 'Bandit', image: 'https://rustlabs.com/img/items180/scrap.png' },
    { id: 'fish_exch', name: 'Scrap (Trout)', category: 'Farm', cost: 1, currency: 'Trout', outputAmount: 10, location: 'Fishing', image: 'https://rustlabs.com/img/items180/scrap.png' },
    { id: 'corn_seed', name: 'Corn Seed', category: 'Farm', cost: 10, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/seed.corn.png' },
    { id: 'pickles', name: 'Pickles', category: 'Farm', cost: 1, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/pickle.png' },

    // --- WEAPONS (Bandit) ---
    { id: 'lr300', name: 'LR-300', category: 'Weapon', cost: 500, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/rifle.lr300.png' },
    { id: 'm92', name: 'M92 Pistol', category: 'Weapon', cost: 250, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/pistol.m92.png' },
    { id: 'm39', name: 'M39 Rifle', category: 'Weapon', cost: 400, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/rifle.m39.png' },
    { id: 'l96', name: 'L96 Sniper', category: 'Weapon', cost: 700, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/rifle.l96.png' },
    { id: 'spas', name: 'Spas-12', category: 'Weapon', cost: 250, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/shotgun.spas12.png' },
    { id: 'f1', name: 'F1 Grenade', category: 'Weapon', cost: 8, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/grenade.f1.png' },

    // --- VEHICLES (Fishing & Bandit & Stables) ---
    { id: 'minicopter', name: 'Minicopter', category: 'Vehicle', cost: 750, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/minicopter.png' },
    { id: 'scrap_heli', name: 'Scrap Heli', category: 'Vehicle', cost: 1250, currency: 'Scrap', outputAmount: 1, location: 'Bandit', image: 'https://rustlabs.com/img/items180/scraptransporthelicopter.png' },
    { id: 'boat_small', name: 'Rowboat', category: 'Vehicle', cost: 125, currency: 'Scrap', outputAmount: 1, location: 'Fishing', image: 'https://rustlabs.com/img/items180/rowboat.png' },
    { id: 'boat_rhib', name: 'RHIB', category: 'Vehicle', cost: 300, currency: 'Scrap', outputAmount: 1, location: 'Fishing', image: 'https://rustlabs.com/img/items180/rhib.png' },
    { id: 'horse', name: 'Saddle (Claim Horse)', category: 'Vehicle', cost: 75, currency: 'Scrap', outputAmount: 1, location: 'Stables', image: 'https://rustlabs.com/img/items180/saddle.png' },
    { id: 'horse_shoes', name: 'High Quality Shoes', category: 'Vehicle', cost: 40, currency: 'Scrap', outputAmount: 1, location: 'Stables', image: 'https://rustlabs.com/img/items180/horse.shoes.advanced.png' },

    // --- GEAR (Fishing & Outpost) ---
    { id: 'tac_gloves', name: 'Tactical Gloves', category: 'Gear', cost: 40, currency: 'Scrap', outputAmount: 1, location: 'Outpost', image: 'https://rustlabs.com/img/items180/tactical.gloves.png' },
    { id: 'diving_tank', name: 'Diving Tank', category: 'Gear', cost: 35, currency: 'Scrap', outputAmount: 1, location: 'Fishing', image: 'https://rustlabs.com/img/items180/diving.tank.png' },
    { id: 'diving_mask', name: 'Diving Mask', category: 'Gear', cost: 15, currency: 'Scrap', outputAmount: 1, location: 'Fishing', image: 'https://rustlabs.com/img/items180/diving.mask.png' },
    { id: 'diving_fins', name: 'Diving Fins', category: 'Gear', cost: 15, currency: 'Scrap', outputAmount: 1, location: 'Fishing', image: 'https://rustlabs.com/img/items180/diving.fins.png' },
    { id: 'fishing_rod', name: 'Fishing Rod', category: 'Gear', cost: 80, currency: 'Scrap', outputAmount: 1, location: 'Fishing', image: 'https://rustlabs.com/img/items180/fishing.rod.png' },

    // --- BUILD / COMPONENT ---
    { id: 'jackhammer', name: 'Jackhammer', category: 'Build', cost: 150, currency: 'Scrap', outputAmount: 1, location: 'Outpost', image: 'https://rustlabs.com/img/items180/jackhammer.png' },
    { id: 'blue_card', name: 'Blue Keycard', category: 'Component', cost: 100, currency: 'Scrap', outputAmount: 1, location: 'Outpost', image: 'https://rustlabs.com/img/items180/keycard_blue.png' },
    { id: 'sam_site', name: 'SAM Site', category: 'Build', cost: 500, currency: 'Scrap', outputAmount: 1, location: 'Outpost', image: 'https://rustlabs.com/img/items180/samsite.png' },
    { id: 'ladder', name: 'Ladder', category: 'Build', cost: 150, currency: 'Scrap', outputAmount: 1, location: 'Outpost', image: 'https://rustlabs.com/img/items180/ladder.wooden.wall.png' },
];
