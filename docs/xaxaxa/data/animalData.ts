
export interface ResourceDrop {
    name: string;
    amount: number;
    icon: string;
}

export interface HarvestTool {
    name: string;
    icon: string; // Tool image
    drops: ResourceDrop[];
}

export interface Animal {
    id: string;
    name: string;
    hp: number;
    description: string;
    image: string;
    harvest: HarvestTool[];
}

// Resource Icons
const R = {
    leather: 'https://rustlabs.com/img/items180/leather.png',
    meat: 'https://rustlabs.com/img/items180/meat.bear.cooked.png', // Generic cooked icon often used, or raw
    raw_meat: 'https://rustlabs.com/img/items180/meat.wolf.raw.png', // Specific wolf meat, deer meat uses same mostly
    pork: 'https://rustlabs.com/img/items180/meat.pork.raw.png', // Added Pork
    fat: 'https://rustlabs.com/img/items180/fat.animal.png',
    bone: 'https://rustlabs.com/img/items180/bone.fragments.png',
    cloth: 'https://rustlabs.com/img/items180/cloth.png',
    skull: 'https://rustlabs.com/img/items180/skull.wolf.png',
    chicken_raw: 'https://rustlabs.com/img/items180/chicken.raw.png',
    rope: 'https://rustlabs.com/img/items180/rope.png',
    raw_fish: 'https://rustlabs.com/img/items180/meat.fish.raw.png'
};

// Tool Icons
const T = {
    combat: 'https://rustlabs.com/img/items180/knife.combat.png',
    bone_knife: 'https://rustlabs.com/img/items180/bone.knife.png',
    skinning: 'https://rustlabs.com/img/items180/knife.skinning.png',
    hatchet: 'https://rustlabs.com/img/items180/hatchet.png',
    axe: 'https://rustlabs.com/img/items180/axe.salvaged.png',
    cleaver: 'https://rustlabs.com/img/items180/cleaver.salvaged.png',
    machete: 'https://rustlabs.com/img/items180/machete.png',
    longsword: 'https://rustlabs.com/img/items180/longsword.png',
    sword: 'https://rustlabs.com/img/items180/salvaged.sword.png',
    mace: 'https://rustlabs.com/img/items180/mace.png',
    stone_hatchet: 'https://rustlabs.com/img/items180/stone.hatchet.png',
    bone_club: 'https://rustlabs.com/img/items180/bone.club.png',
    chainsaw: 'https://rustlabs.com/img/items180/chainsaw.png',
    jackhammer: 'https://rustlabs.com/img/items180/jackhammer.png',
    icepick: 'https://rustlabs.com/img/items180/icepick.salvaged.png',
    pickaxe: 'https://rustlabs.com/img/items180/pickaxe.png',
    stone_pick: 'https://rustlabs.com/img/items180/stone.pickaxe.png',
    hammer: 'https://rustlabs.com/img/items180/hammer.salvaged.png',
    rock: 'https://rustlabs.com/img/items180/rock.png'
};

// --- DATA DEFINITIONS ---

// Helper for Wolf High Tier (100%)
const WOLF_BEST_DROPS = [
    { name: 'Leather', amount: 75, icon: R.leather },
    { name: 'Bone', amount: 40, icon: R.bone },
    { name: 'Animal Fat', amount: 35, icon: R.fat },
    { name: 'Raw Meat', amount: 10, icon: R.raw_meat },
    { name: 'Cloth', amount: 5, icon: R.cloth },
    { name: 'Wolf Skull', amount: 1, icon: R.skull }
];

export const ANIMALS: Animal[] = [
    {
        id: 'chicken',
        name: 'Chicken',
        hp: 25,
        description: "Small, passive birds found in temperate forests. They provide cloth and raw chicken breast. Very easy to kill and often hunted by fresh spawns.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fchicken.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: UNIQUE BEST (Skinning Knife) ---
            {
                name: 'Skinning Knife',
                icon: T.skinning,
                drops: [
                    { name: 'Bone', amount: 12, icon: R.bone },
                    { name: 'Cloth', amount: 6, icon: R.cloth },
                    { name: 'Raw Chicken', amount: 2, icon: R.chicken_raw },
                    { name: 'Skull', amount: 1, icon: R.skull }
                ]
            },
            // --- TIER 2: HIGH (Most Tools + Stone Pickaxe) ---
            ...['Jackhammer', 'Combat Knife', 'Bone Knife', 'Hatchet', 'Salvaged Axe', 'Stone Pickaxe', 'Machete', 'Salvaged Sword', 'Salvaged Icepick', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Jackhammer' ? T.jackhammer : name === 'Combat Knife' ? T.combat : name === 'Bone Knife' ? T.bone_knife : name === 'Hatchet' ? T.hatchet : name === 'Salvaged Axe' ? T.axe : name === 'Stone Pickaxe' ? T.stone_pick : name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Icepick' ? T.icepick : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Bone', amount: 12, icon: R.bone },
                    { name: 'Cloth', amount: 6, icon: R.cloth },
                    { name: 'Raw Chicken', amount: 2, icon: R.chicken_raw }
                ]
            })),
            // --- TIER 3: STONE HATCHET ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Bone', amount: 8, icon: R.bone },
                    { name: 'Cloth', amount: 4, icon: R.cloth },
                    { name: 'Raw Chicken', amount: 2, icon: R.chicken_raw }
                ]
            },
            // --- TIER 4: LOW (Rock, Bone Club, Hammer, Pickaxe) ---
            ...['Bone Club', 'Rock', 'Salvaged Hammer', 'Pickaxe'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : name === 'Rock' ? T.rock : name === 'Salvaged Hammer' ? T.hammer : T.pickaxe,
                drops: [
                    { name: 'Bone', amount: 6, icon: R.bone },
                    { name: 'Cloth', amount: 3, icon: R.cloth },
                    { name: 'Raw Chicken', amount: 1, icon: R.chicken_raw }
                ]
            }))
        ]
    },
    {
        id: 'crocodile',
        name: 'Crocodile',
        hp: 450,
        description: "A tough reptile found in Swamps and Rivers. High health pool but yields excellent amounts of Leather, Bone, and Fat.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fcrocodile.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: UNIQUE BEST (Skinning Knife) ---
            {
                name: 'Skinning Knife',
                icon: T.skinning,
                drops: [
                    { name: 'Leather', amount: 170, icon: R.leather },
                    { name: 'Bone', amount: 170, icon: R.bone },
                    { name: 'Animal Fat', amount: 120, icon: R.fat },
                    { name: 'Cloth', amount: 30, icon: R.cloth },
                    { name: 'Raw Meat', amount: 19, icon: R.raw_meat },
                    { name: 'Skull', amount: 1, icon: R.skull }
                ]
            },
            // --- TIER 2: HIGH (100% Yield - No Skull) ---
            ...['Combat Knife', 'Hatchet', 'Bone Knife', 'Salvaged Axe'].map(name => ({
                name,
                icon: name === 'Combat Knife' ? T.combat : name === 'Hatchet' ? T.hatchet : name === 'Bone Knife' ? T.bone_knife : T.axe,
                drops: [
                    { name: 'Leather', amount: 170, icon: R.leather },
                    { name: 'Bone', amount: 170, icon: R.bone },
                    { name: 'Animal Fat', amount: 120, icon: R.fat },
                    { name: 'Cloth', amount: 30, icon: R.cloth },
                    { name: 'Raw Meat', amount: 19, icon: R.raw_meat }
                ]
            })),
            // --- TIER 3: MACHETE GROUP ---
            ...['Machete', 'Salvaged Sword', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Leather', amount: 142, icon: R.leather },
                    { name: 'Bone', amount: 142, icon: R.bone },
                    { name: 'Animal Fat', amount: 101, icon: R.fat },
                    { name: 'Cloth', amount: 25, icon: R.cloth },
                    { name: 'Raw Meat', amount: 16, icon: R.raw_meat }
                ]
            })),
            // --- TIER 4: JACKHAMMER/ICEPICK/STONE PICKAXE ---
            ...['Jackhammer', 'Salvaged Icepick', 'Stone Pickaxe'].map(name => ({
                name,
                icon: name === 'Jackhammer' ? T.jackhammer : name === 'Salvaged Icepick' ? T.icepick : T.stone_pick,
                drops: [
                    { name: 'Leather', amount: 122, icon: R.leather },
                    { name: 'Bone', amount: 122, icon: R.bone },
                    { name: 'Animal Fat', amount: 86, icon: R.fat },
                    { name: 'Cloth', amount: 22, icon: R.cloth },
                    { name: 'Raw Meat', amount: 14, icon: R.raw_meat }
                ]
            })),
            // --- TIER 5: CHAINSAW ---
            {
                name: 'Chainsaw',
                icon: T.chainsaw,
                drops: [
                    { name: 'Leather', amount: 114, icon: R.leather },
                    { name: 'Bone', amount: 114, icon: R.bone },
                    { name: 'Animal Fat', amount: 80, icon: R.fat },
                    { name: 'Cloth', amount: 20, icon: R.cloth },
                    { name: 'Raw Meat', amount: 13, icon: R.raw_meat }
                ]
            },
            // --- TIER 6: STONE HATCHET ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 102, icon: R.leather },
                    { name: 'Bone', amount: 102, icon: R.bone },
                    { name: 'Animal Fat', amount: 72, icon: R.fat },
                    { name: 'Cloth', amount: 18, icon: R.cloth },
                    { name: 'Raw Meat', amount: 12, icon: R.raw_meat }
                ]
            },
            // --- TIER 7: BONE CLUB/ROCK ---
            ...['Bone Club', 'Rock'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : T.rock,
                drops: [
                    { name: 'Leather', amount: 85, icon: R.leather },
                    { name: 'Bone', amount: 85, icon: R.bone },
                    { name: 'Animal Fat', amount: 60, icon: R.fat },
                    { name: 'Cloth', amount: 15, icon: R.cloth },
                    { name: 'Raw Meat', amount: 10, icon: R.raw_meat }
                ]
            })),
            // --- TIER 8: PICKAXE/HAMMER ---
            ...['Salvaged Hammer', 'Pickaxe'].map(name => ({
                name,
                icon: name === 'Salvaged Hammer' ? T.hammer : T.pickaxe,
                drops: [
                    { name: 'Leather', amount: 78, icon: R.leather },
                    { name: 'Bone', amount: 78, icon: R.bone },
                    { name: 'Animal Fat', amount: 55, icon: R.fat },
                    { name: 'Cloth', amount: 14, icon: R.cloth },
                    { name: 'Raw Meat', amount: 9, icon: R.raw_meat }
                ]
            }))
        ]
    },
    {
        id: 'horse',
        name: 'Horse',
        hp: 400,
        description: "Horses are passive rideable animals found in temperate and desert biomes. They have high health and yield decent resources including leather and cloth.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fhorse.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: BEST (100% Yield) ---
            {
                name: 'Skinning Knife',
                icon: T.skinning,
                drops: [
                    { name: 'Leather', amount: 50, icon: R.leather },
                    { name: 'Bone', amount: 50, icon: R.bone },
                    { name: 'Animal Fat', amount: 25, icon: R.fat },
                    { name: 'Raw Meat', amount: 10, icon: R.raw_meat },
                    { name: 'Cloth', amount: 5, icon: R.cloth },
                    { name: 'Skull', amount: 1, icon: R.skull }
                ]
            },
            ...['Combat Knife', 'Bone Knife', 'Hatchet', 'Salvaged Axe'].map(name => ({
                name,
                icon: name === 'Combat Knife' ? T.combat : name === 'Bone Knife' ? T.bone_knife : name === 'Hatchet' ? T.hatchet : T.axe,
                drops: [
                    { name: 'Leather', amount: 50, icon: R.leather },
                    { name: 'Bone', amount: 50, icon: R.bone },
                    { name: 'Animal Fat', amount: 25, icon: R.fat },
                    { name: 'Raw Meat', amount: 10, icon: R.raw_meat },
                    { name: 'Cloth', amount: 5, icon: R.cloth }
                ]
            })),

            // --- TIER 2: HIGH ---
            ...['Machete', 'Salvaged Sword', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Leather', amount: 44, icon: R.leather },
                    { name: 'Bone', amount: 44, icon: R.bone },
                    { name: 'Animal Fat', amount: 22, icon: R.fat },
                    { name: 'Raw Meat', amount: 9, icon: R.raw_meat },
                    { name: 'Cloth', amount: 5, icon: R.cloth }
                ]
            })),

            // --- TIER 3: MID-HIGH ---
            ...['Jackhammer', 'Salvaged Icepick'].map(name => ({
                name,
                icon: name === 'Jackhammer' ? T.jackhammer : T.icepick,
                drops: [
                    { name: 'Leather', amount: 39, icon: R.leather },
                    { name: 'Bone', amount: 39, icon: R.bone },
                    { name: 'Animal Fat', amount: 19, icon: R.fat },
                    { name: 'Raw Meat', amount: 8, icon: R.raw_meat },
                    { name: 'Cloth', amount: 4, icon: R.cloth }
                ]
            })),

            // --- TIER 4: CHAINSAW ---
            {
                name: 'Chainsaw',
                icon: T.chainsaw,
                drops: [
                    { name: 'Leather', amount: 38, icon: R.leather },
                    { name: 'Bone', amount: 38, icon: R.bone },
                    { name: 'Animal Fat', amount: 19, icon: R.fat },
                    { name: 'Raw Meat', amount: 8, icon: R.raw_meat },
                    { name: 'Cloth', amount: 4, icon: R.cloth }
                ]
            },

            // --- TIER 5: MID ---
            {
                name: 'Stone Pickaxe',
                icon: T.stone_pick,
                drops: [
                    { name: 'Leather', amount: 37, icon: R.leather },
                    { name: 'Bone', amount: 37, icon: R.bone },
                    { name: 'Animal Fat', amount: 19, icon: R.fat },
                    { name: 'Raw Meat', amount: 8, icon: R.raw_meat },
                    { name: 'Cloth', amount: 4, icon: R.cloth }
                ]
            },

            // --- TIER 6: STONE HATCHET ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 31, icon: R.leather },
                    { name: 'Bone', amount: 31, icon: R.bone },
                    { name: 'Animal Fat', amount: 16, icon: R.fat },
                    { name: 'Raw Meat', amount: 6, icon: R.raw_meat },
                    { name: 'Cloth', amount: 3, icon: R.cloth }
                ]
            },

            // --- TIER 7: LOW ---
            ...['Bone Club', 'Rock'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : T.rock,
                drops: [
                    { name: 'Leather', amount: 25, icon: R.leather },
                    { name: 'Bone', amount: 25, icon: R.bone },
                    { name: 'Animal Fat', amount: 13, icon: R.fat },
                    { name: 'Raw Meat', amount: 5, icon: R.raw_meat },
                    { name: 'Cloth', amount: 3, icon: R.cloth }
                ]
            })),

            // --- TIER 8: LOWEST ---
            ...['Salvaged Hammer', 'Pickaxe'].map(name => ({
                name,
                icon: name === 'Salvaged Hammer' ? T.hammer : T.pickaxe,
                drops: [
                    { name: 'Leather', amount: 24, icon: R.leather },
                    { name: 'Bone', amount: 24, icon: R.bone },
                    { name: 'Animal Fat', amount: 12, icon: R.fat },
                    { name: 'Raw Meat', amount: 5, icon: R.raw_meat },
                    { name: 'Cloth', amount: 3, icon: R.cloth }
                ]
            }))
        ]
    },
    {
        id: 'panther',
        name: 'Panther',
        hp: 240,
        description: "A fast and lethal predator found in the Jungle biome. High health pool and damage output. Yields excellent resources, especially Animal Fat.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpanther.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: UNIQUE BEST (Skinning Knife) ---
            {
                name: 'Skinning Knife',
                icon: T.skinning,
                drops: [
                    { name: 'Leather', amount: 150, icon: R.leather },
                    { name: 'Bone', amount: 100, icon: R.bone },
                    { name: 'Animal Fat', amount: 100, icon: R.fat },
                    { name: 'Cloth', amount: 50, icon: R.cloth },
                    { name: 'Raw Meat', amount: 19, icon: R.raw_meat },
                    { name: 'Skull', amount: 1, icon: R.skull }
                ]
            },
            // --- TIER 2: HIGH (100% Yield - No Skull) ---
            ...['Combat Knife', 'Hatchet', 'Bone Knife', 'Salvaged Axe'].map(name => ({
                name,
                icon: name === 'Combat Knife' ? T.combat : name === 'Hatchet' ? T.hatchet : name === 'Bone Knife' ? T.bone_knife : T.axe,
                drops: [
                    { name: 'Leather', amount: 150, icon: R.leather },
                    { name: 'Bone', amount: 100, icon: R.bone },
                    { name: 'Animal Fat', amount: 100, icon: R.fat },
                    { name: 'Cloth', amount: 50, icon: R.cloth },
                    { name: 'Raw Meat', amount: 19, icon: R.raw_meat }
                ]
            })),
            // --- TIER 3: MACHETE GROUP ---
            ...['Machete', 'Salvaged Sword', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Leather', amount: 126, icon: R.leather },
                    { name: 'Bone', amount: 84, icon: R.bone },
                    { name: 'Animal Fat', amount: 84, icon: R.fat },
                    { name: 'Cloth', amount: 42, icon: R.cloth },
                    { name: 'Raw Meat', amount: 16, icon: R.raw_meat }
                ]
            })),
            // --- TIER 4: JACKHAMMER/ICEPICK ---
            ...['Jackhammer', 'Salvaged Icepick'].map(name => ({
                name,
                icon: name === 'Jackhammer' ? T.jackhammer : T.icepick,
                drops: [
                    { name: 'Leather', amount: 109, icon: R.leather },
                    { name: 'Bone', amount: 73, icon: R.bone },
                    { name: 'Animal Fat', amount: 73, icon: R.fat },
                    { name: 'Cloth', amount: 36, icon: R.cloth },
                    { name: 'Raw Meat', amount: 14, icon: R.raw_meat }
                ]
            })),
            // --- TIER 5: STONE PICKAXE ---
            {
                name: 'Stone Pickaxe',
                icon: T.stone_pick,
                drops: [
                    { name: 'Leather', amount: 109, icon: R.leather },
                    { name: 'Bone', amount: 72, icon: R.bone },
                    { name: 'Animal Fat', amount: 72, icon: R.fat },
                    { name: 'Cloth', amount: 36, icon: R.cloth },
                    { name: 'Raw Meat', amount: 14, icon: R.raw_meat }
                ]
            },
            // --- TIER 6: CHAINSAW ---
            {
                name: 'Chainsaw',
                icon: T.chainsaw,
                drops: [
                    { name: 'Leather', amount: 100, icon: R.leather },
                    { name: 'Bone', amount: 67, icon: R.bone },
                    { name: 'Animal Fat', amount: 67, icon: R.fat },
                    { name: 'Cloth', amount: 34, icon: R.cloth },
                    { name: 'Raw Meat', amount: 13, icon: R.raw_meat }
                ]
            },
            // --- TIER 7: STONE HATCHET ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 90, icon: R.leather },
                    { name: 'Bone', amount: 60, icon: R.bone },
                    { name: 'Animal Fat', amount: 60, icon: R.fat },
                    { name: 'Cloth', amount: 30, icon: R.cloth },
                    { name: 'Raw Meat', amount: 12, icon: R.raw_meat }
                ]
            },
            // --- TIER 8: BONE CLUB/ROCK ---
            ...['Bone Club', 'Rock'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : T.rock,
                drops: [
                    { name: 'Leather', amount: 75, icon: R.leather },
                    { name: 'Bone', amount: 50, icon: R.bone },
                    { name: 'Animal Fat', amount: 50, icon: R.fat },
                    { name: 'Cloth', amount: 25, icon: R.cloth },
                    { name: 'Raw Meat', amount: 10, icon: R.raw_meat }
                ]
            })),
            // --- TIER 9: PICKAXE/HAMMER ---
            ...['Salvaged Hammer', 'Pickaxe'].map(name => ({
                name,
                icon: name === 'Salvaged Hammer' ? T.hammer : T.pickaxe,
                drops: [
                    { name: 'Leather', amount: 69, icon: R.leather },
                    { name: 'Bone', amount: 46, icon: R.bone },
                    { name: 'Animal Fat', amount: 46, icon: R.fat },
                    { name: 'Cloth', amount: 23, icon: R.cloth },
                    { name: 'Raw Meat', amount: 9, icon: R.raw_meat }
                ]
            }))
        ]
    },
    {
        id: 'polar_bear',
        name: 'Polar Bear',
        hp: 420,
        description: "The strongest animal in Rust found in the Snow biome. Extremely aggressive and yields the highest amount of resources.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpolar-bear.webp&w=414&q=90',
        harvest: [
             // Skinning Knife (Unique with Skull/Bag)
            {
                name: 'Skinning Knife',
                icon: T.skinning,
                drops: [
                    { name: 'Leather', amount: 170, icon: R.leather },
                    { name: 'Bone', amount: 125, icon: R.bone },
                    { name: 'Animal Fat', amount: 120, icon: R.fat },
                    { name: 'Cloth', amount: 50, icon: R.cloth },
                    { name: 'Raw Meat', amount: 22, icon: R.raw_meat },
                    { name: 'Skull', amount: 1, icon: R.skull }
                ]
            },
            // Combat/Bone/Hatchet/Axe (High Tier without Skull)
            ...['Combat Knife', 'Bone Knife', 'Hatchet', 'Salvaged Axe'].map(name => ({
                name,
                icon: name === 'Combat Knife' ? T.combat : name === 'Bone Knife' ? T.bone_knife : name === 'Hatchet' ? T.hatchet : T.axe,
                drops: [
                    { name: 'Leather', amount: 170, icon: R.leather },
                    { name: 'Bone', amount: 125, icon: R.bone },
                    { name: 'Animal Fat', amount: 120, icon: R.fat },
                    { name: 'Cloth', amount: 50, icon: R.cloth },
                    { name: 'Raw Meat', amount: 22, icon: R.raw_meat }
                ]
            })),
            // Machete/Sword/Cleaver/Mace/Longsword
            ...['Machete', 'Salvaged Sword', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Leather', amount: 143, icon: R.leather },
                    { name: 'Bone', amount: 106, icon: R.bone },
                    { name: 'Animal Fat', amount: 102, icon: R.fat },
                    { name: 'Cloth', amount: 42, icon: R.cloth },
                    { name: 'Raw Meat', amount: 19, icon: R.raw_meat }
                ]
            })),
            // Jackhammer/Icepick
            ...['Jackhammer', 'Salvaged Icepick'].map(name => ({
                name,
                icon: name === 'Jackhammer' ? T.jackhammer : T.icepick,
                drops: [
                    { name: 'Leather', amount: 124, icon: R.leather },
                    { name: 'Bone', amount: 91, icon: R.bone },
                    { name: 'Animal Fat', amount: 87, icon: R.fat },
                    { name: 'Cloth', amount: 37, icon: R.cloth },
                    { name: 'Raw Meat', amount: 16, icon: R.raw_meat }
                ]
            })),
            // Stone Pickaxe
            {
                name: 'Stone Pickaxe',
                icon: T.stone_pick,
                drops: [
                    { name: 'Leather', amount: 123, icon: R.leather },
                    { name: 'Bone', amount: 90, icon: R.bone },
                    { name: 'Animal Fat', amount: 87, icon: R.fat },
                    { name: 'Cloth', amount: 36, icon: R.cloth },
                    { name: 'Raw Meat', amount: 16, icon: R.raw_meat }
                ]
            },
            // Chainsaw
            {
                name: 'Chainsaw',
                icon: T.chainsaw,
                drops: [
                    { name: 'Leather', amount: 114, icon: R.leather },
                    { name: 'Bone', amount: 84, icon: R.bone },
                    { name: 'Animal Fat', amount: 80, icon: R.fat },
                    { name: 'Cloth', amount: 34, icon: R.cloth },
                    { name: 'Raw Meat', amount: 15, icon: R.raw_meat }
                ]
            },
            // Stone Hatchet
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 103, icon: R.leather },
                    { name: 'Bone', amount: 76, icon: R.bone },
                    { name: 'Animal Fat', amount: 73, icon: R.fat },
                    { name: 'Cloth', amount: 30, icon: R.cloth },
                    { name: 'Raw Meat', amount: 14, icon: R.raw_meat }
                ]
            },
            // Bone Club / Rock
            ...['Bone Club', 'Rock'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : T.rock,
                drops: [
                    { name: 'Leather', amount: 85, icon: R.leather },
                    { name: 'Bone', amount: 63, icon: R.bone },
                    { name: 'Animal Fat', amount: 60, icon: R.fat },
                    { name: 'Cloth', amount: 25, icon: R.cloth },
                    { name: 'Raw Meat', amount: 11, icon: R.raw_meat }
                ]
            })),
            // Pickaxe / Hammer
            ...['Pickaxe', 'Salvaged Hammer'].map(name => ({
                name,
                icon: name === 'Pickaxe' ? T.pickaxe : T.hammer,
                drops: [
                    { name: 'Leather', amount: 79, icon: R.leather },
                    { name: 'Bone', amount: 58, icon: R.bone },
                    { name: 'Animal Fat', amount: 56, icon: R.fat },
                    { name: 'Cloth', amount: 23, icon: R.cloth },
                    { name: 'Raw Meat', amount: 10, icon: R.raw_meat }
                ]
            }))
        ]
    },
    {
        id: 'shark',
        name: 'Shark',
        hp: 148,
        description: "Aggressive aquatic predator found in the ocean. Requires a boat or submarine to hunt effectively. Yields Raw Fish and Meat.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fshark.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: BEST (100% Yield) ---
            ...['Skinning Knife', 'Combat Knife', 'Hatchet', 'Bone Knife', 'Salvaged Axe'].map(name => ({
                name,
                icon: name === 'Skinning Knife' ? T.skinning : name === 'Combat Knife' ? T.combat : name === 'Hatchet' ? T.hatchet : name === 'Bone Knife' ? T.bone_knife : T.axe,
                drops: [
                    { name: 'Leather', amount: 50, icon: R.leather },
                    { name: 'Bone', amount: 40, icon: R.bone },
                    { name: 'Animal Fat', amount: 40, icon: R.fat },
                    { name: 'Raw Fish', amount: 20, icon: R.raw_fish },
                    { name: 'Raw Meat', amount: 18, icon: R.raw_meat }
                ]
            })),

            // --- TIER 2: HIGH (Approx 85%) ---
            ...['Machete', 'Salvaged Sword', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Leather', amount: 43, icon: R.leather },
                    { name: 'Bone', amount: 34, icon: R.bone },
                    { name: 'Animal Fat', amount: 34, icon: R.fat },
                    { name: 'Raw Fish', amount: 17, icon: R.raw_fish },
                    { name: 'Raw Meat', amount: 15, icon: R.raw_meat }
                ]
            })),

            // --- TIER 3: CHAINSAW ---
            {
                name: 'Chainsaw',
                icon: T.chainsaw,
                drops: [
                    { name: 'Leather', amount: 38, icon: R.leather },
                    { name: 'Bone', amount: 30, icon: R.bone },
                    { name: 'Animal Fat', amount: 30, icon: R.fat },
                    { name: 'Raw Fish', amount: 15, icon: R.raw_fish },
                    { name: 'Raw Meat', amount: 14, icon: R.raw_meat }
                ]
            },

            // --- TIER 4: MID (Jackhammer/Pickaxes) ---
            ...['Stone Pickaxe', 'Jackhammer', 'Salvaged Icepick'].map(name => ({
                name,
                icon: name === 'Stone Pickaxe' ? T.stone_pick : name === 'Jackhammer' ? T.jackhammer : T.icepick,
                drops: [
                    { name: 'Leather', amount: 37, icon: R.leather },
                    { name: 'Bone', amount: 29, icon: R.bone },
                    { name: 'Animal Fat', amount: 29, icon: R.fat },
                    { name: 'Raw Fish', amount: 15, icon: R.raw_fish },
                    { name: 'Raw Meat', amount: 13, icon: R.raw_meat }
                ]
            })),

            // --- TIER 5: STONE HATCHET ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 31, icon: R.leather },
                    { name: 'Bone', amount: 25, icon: R.bone },
                    { name: 'Animal Fat', amount: 25, icon: R.fat },
                    { name: 'Raw Fish', amount: 12, icon: R.raw_fish },
                    { name: 'Raw Meat', amount: 11, icon: R.raw_meat }
                ]
            },

            // --- TIER 6: LOW (Rock/Bone Club) ---
            ...['Bone Club', 'Rock'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : T.rock,
                drops: [
                    { name: 'Leather', amount: 25, icon: R.leather },
                    { name: 'Bone', amount: 20, icon: R.bone },
                    { name: 'Animal Fat', amount: 20, icon: R.fat },
                    { name: 'Raw Fish', amount: 10, icon: R.raw_fish },
                    { name: 'Raw Meat', amount: 9, icon: R.raw_meat }
                ]
            })),

            // --- TIER 7: LOWEST (Pickaxe/Hammer) ---
            ...['Pickaxe', 'Salvaged Hammer'].map(name => ({
                name,
                icon: name === 'Pickaxe' ? T.pickaxe : T.hammer,
                drops: [
                    { name: 'Leather', amount: 24, icon: R.leather }, // Avg between 23/24
                    { name: 'Bone', amount: 19, icon: R.bone },
                    { name: 'Animal Fat', amount: 19, icon: R.fat },
                    { name: 'Raw Fish', amount: 10, icon: R.raw_fish },
                    { name: 'Raw Meat', amount: 9, icon: R.raw_meat }
                ]
            }))
        ]
    },
    {
        id: 'snake',
        name: 'Snake',
        hp: 50,
        description: "Small, hostile reptile found primarily in Jungle biomes. Hard to spot in grass. Yields are low but easy to kill. Unique drop: Rope with Skinning Knife.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fsnake.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: UNIQUE BEST (Skinning Knife) ---
            {
                name: 'Skinning Knife',
                icon: T.skinning,
                drops: [
                    { name: 'Cloth', amount: 10, icon: R.cloth },
                    { name: 'Raw Meat', amount: 5, icon: R.raw_meat },
                    { name: 'Animal Fat', amount: 4, icon: R.fat },
                    { name: 'Rope', amount: 1, icon: R.rope }
                ]
            },

            // --- TIER 2: HIGH (Most Tools) ---
            ...['Jackhammer', 'Combat Knife', 'Chainsaw', 'Hatchet', 'Bone Knife', 'Salvaged Axe', 'Machete', 'Salvaged Sword', 'Salvaged Icepick', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Jackhammer' ? T.jackhammer : name === 'Combat Knife' ? T.combat : name === 'Chainsaw' ? T.chainsaw : name === 'Hatchet' ? T.hatchet : name === 'Bone Knife' ? T.bone_knife : name === 'Salvaged Axe' ? T.axe : name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Icepick' ? T.icepick : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Cloth', amount: 10, icon: R.cloth },
                    { name: 'Raw Meat', amount: 5, icon: R.raw_meat },
                    { name: 'Animal Fat', amount: 4, icon: R.fat }
                ]
            })),

            // --- TIER 3: MID (Stone Pickaxe) ---
            {
                name: 'Stone Pickaxe',
                icon: T.stone_pick,
                drops: [
                    { name: 'Cloth', amount: 8, icon: R.cloth },
                    { name: 'Raw Meat', amount: 4, icon: R.raw_meat },
                    { name: 'Animal Fat', amount: 3, icon: R.fat }
                ]
            },

            // --- TIER 4: MID-LOW (Stone Hatchet) ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Cloth', amount: 7, icon: R.cloth },
                    { name: 'Raw Meat', amount: 3, icon: R.raw_meat },
                    { name: 'Animal Fat', amount: 3, icon: R.fat }
                ]
            },

            // --- TIER 5: LOW (Rock, Hammer, Pickaxe, Bone Club) ---
            ...['Bone Club', 'Salvaged Hammer', 'Rock', 'Pickaxe'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : name === 'Salvaged Hammer' ? T.hammer : name === 'Rock' ? T.rock : T.pickaxe,
                drops: [
                    { name: 'Cloth', amount: 5, icon: R.cloth },
                    { name: 'Raw Meat', amount: 3, icon: R.raw_meat },
                    { name: 'Animal Fat', amount: 2, icon: R.fat }
                ]
            }))
        ]
    },
    {
        id: 'stag',
        name: 'Stag',
        hp: 150,
        description: "Stags are large, passive animals found in temperate biomes. They flee when attacked but yield significant resources.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fstag.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: BEST (100% Yield) ---
            ...['Skinning Knife', 'Combat Knife', 'Bone Knife', 'Hatchet', 'Salvaged Axe'].map(name => ({
                name,
                icon: name === 'Skinning Knife' ? T.skinning : name === 'Combat Knife' ? T.combat : name === 'Bone Knife' ? T.bone_knife : name === 'Hatchet' ? T.hatchet : T.axe,
                drops: [
                    { name: 'Leather', amount: 50, icon: R.leather },
                    { name: 'Bone', amount: 50, icon: R.bone },
                    { name: 'Animal Fat', amount: 25, icon: R.fat },
                    { name: 'Cloth', amount: 10, icon: R.cloth },
                    { name: 'Raw Meat', amount: 4, icon: R.raw_meat },
                    { name: 'Skull', amount: 1, icon: R.skull }
                ]
            })),

            // --- TIER 2: HIGH (Approx 88%) ---
            ...['Machete', 'Salvaged Sword', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Leather', amount: 44, icon: R.leather },
                    { name: 'Bone', amount: 44, icon: R.bone },
                    { name: 'Animal Fat', amount: 22, icon: R.fat },
                    { name: 'Cloth', amount: 9, icon: R.cloth },
                    { name: 'Raw Meat', amount: 4, icon: R.raw_meat }
                ]
            })),

            // --- TIER 3: MID-HIGH (Jackhammer/Icepick) ---
            ...['Jackhammer', 'Salvaged Icepick'].map(name => ({
                name,
                icon: name === 'Jackhammer' ? T.jackhammer : T.icepick,
                drops: [
                    { name: 'Leather', amount: 39, icon: R.leather },
                    { name: 'Bone', amount: 39, icon: R.bone },
                    { name: 'Animal Fat', amount: 19, icon: R.fat },
                    { name: 'Cloth', amount: 8, icon: R.cloth },
                    { name: 'Raw Meat', amount: 3, icon: R.raw_meat }
                ]
            })),

            // --- TIER 4: CHAINSAW ---
            {
                name: 'Chainsaw',
                icon: T.chainsaw,
                drops: [
                    { name: 'Leather', amount: 38, icon: R.leather },
                    { name: 'Bone', amount: 38, icon: R.bone },
                    { name: 'Animal Fat', amount: 19, icon: R.fat },
                    { name: 'Cloth', amount: 8, icon: R.cloth },
                    { name: 'Raw Meat', amount: 3, icon: R.raw_meat }
                ]
            },

            // --- TIER 5: MID (Stone Pickaxe) ---
            {
                name: 'Stone Pickaxe',
                icon: T.stone_pick,
                drops: [
                    { name: 'Leather', amount: 37, icon: R.leather },
                    { name: 'Bone', amount: 37, icon: R.bone },
                    { name: 'Animal Fat', amount: 19, icon: R.fat },
                    { name: 'Cloth', amount: 8, icon: R.cloth },
                    { name: 'Raw Meat', amount: 3, icon: R.raw_meat }
                ]
            },

            // --- TIER 6: LOW-MID (Stone Hatchet) ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 31, icon: R.leather },
                    { name: 'Bone', amount: 31, icon: R.bone },
                    { name: 'Animal Fat', amount: 16, icon: R.fat },
                    { name: 'Cloth', amount: 6, icon: R.cloth },
                    { name: 'Raw Meat', amount: 3, icon: R.raw_meat }
                ]
            },

            // --- TIER 7: LOW (Rock/Bone Club) ---
            ...['Bone Club', 'Rock'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : T.rock,
                drops: [
                    { name: 'Leather', amount: 25, icon: R.leather },
                    { name: 'Bone', amount: 25, icon: R.bone },
                    { name: 'Animal Fat', amount: 13, icon: R.fat },
                    { name: 'Cloth', amount: 5, icon: R.cloth },
                    { name: 'Raw Meat', amount: 2, icon: R.raw_meat }
                ]
            })),

            // --- TIER 8: LOWEST (Pickaxe/Hammer) ---
            ...['Salvaged Hammer', 'Pickaxe'].map(name => ({
                name,
                icon: name === 'Salvaged Hammer' ? T.hammer : T.pickaxe,
                drops: [
                    { name: 'Leather', amount: 24, icon: R.leather },
                    { name: 'Bone', amount: 24, icon: R.bone },
                    { name: 'Animal Fat', amount: 12, icon: R.fat },
                    { name: 'Raw Meat', amount: 5, icon: R.raw_meat },
                    { name: 'Cloth', amount: 3, icon: R.cloth }
                ]
            }))
        ]
    },
    {
        id: 'tiger',
        name: 'Tiger',
        hp: 240,
        description: "The Tiger is a formidable predator found in arid and tropical biomes. It has high health and deals significant damage. yields immense resources, surpassing even the Bear.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Ftiger.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: BEST (100% Yield) ---
            ...['Skinning Knife', 'Combat Knife', 'Bone Knife', 'Hatchet', 'Salvaged Axe'].map(name => ({
                name,
                icon: name === 'Skinning Knife' ? T.skinning : name === 'Combat Knife' ? T.combat : name === 'Bone Knife' ? T.bone_knife : name === 'Hatchet' ? T.hatchet : T.axe,
                drops: [
                    { name: 'Leather', amount: 150, icon: R.leather },
                    { name: 'Bone', amount: 100, icon: R.bone },
                    { name: 'Animal Fat', amount: 70, icon: R.fat },
                    { name: 'Cloth', amount: 70, icon: R.cloth },
                    { name: 'Raw Meat', amount: 19, icon: R.raw_meat },
                    { name: 'Skull', amount: 1, icon: R.skull }
                ]
            })),

            // --- TIER 2: HIGH (Approx 84%) ---
            ...['Machete', 'Salvaged Sword', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Leather', amount: 126, icon: R.leather },
                    { name: 'Bone', amount: 84, icon: R.bone },
                    { name: 'Animal Fat', amount: 59, icon: R.fat },
                    { name: 'Cloth', amount: 59, icon: R.cloth },
                    { name: 'Raw Meat', amount: 16, icon: R.raw_meat }
                ]
            })),

            // --- TIER 3: MID (Approx 72% - Jackhammer/Pickaxes) ---
            ...['Stone Pickaxe', 'Jackhammer', 'Salvaged Icepick'].map(name => ({
                name,
                icon: name === 'Stone Pickaxe' ? T.stone_pick : name === 'Jackhammer' ? T.jackhammer : T.icepick,
                drops: [
                    { name: 'Leather', amount: 108, icon: R.leather },
                    { name: 'Bone', amount: 72, icon: R.bone },
                    { name: 'Animal Fat', amount: 51, icon: R.fat },
                    { name: 'Cloth', amount: 51, icon: R.cloth },
                    { name: 'Raw Meat', amount: 14, icon: R.raw_meat }
                ]
            })),

            // --- TIER 4: CHAINSAW ---
            {
                name: 'Chainsaw',
                icon: T.chainsaw,
                drops: [
                    { name: 'Leather', amount: 100, icon: R.leather },
                    { name: 'Bone', amount: 67, icon: R.bone },
                    { name: 'Animal Fat', amount: 47, icon: R.fat },
                    { name: 'Cloth', amount: 47, icon: R.cloth },
                    { name: 'Raw Meat', amount: 13, icon: R.raw_meat }
                ]
            },

            // --- TIER 5: STONE HATCHET (Approx 60%) ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 91, icon: R.leather },
                    { name: 'Bone', amount: 61, icon: R.bone },
                    { name: 'Animal Fat', amount: 43, icon: R.fat },
                    { name: 'Cloth', amount: 43, icon: R.cloth },
                    { name: 'Raw Meat', amount: 12, icon: R.raw_meat }
                ]
            },

            // --- TIER 6: LOW (Approx 50% - Rock/Bone Club) ---
            ...['Bone Club', 'Rock'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : T.rock,
                drops: [
                    { name: 'Leather', amount: 75, icon: R.leather },
                    { name: 'Bone', amount: 50, icon: R.bone },
                    { name: 'Animal Fat', amount: 35, icon: R.fat },
                    { name: 'Cloth', amount: 35, icon: R.cloth },
                    { name: 'Raw Meat', amount: 10, icon: R.raw_meat }
                ]
            })),

            // --- TIER 7: LOWEST (Pickaxe/Hammer) ---
            ...['Salvaged Hammer', 'Pickaxe'].map(name => ({
                name,
                icon: name === 'Salvaged Hammer' ? T.hammer : T.pickaxe,
                drops: [
                    { name: 'Leather', amount: 69, icon: R.leather },
                    { name: 'Bone', amount: 46, icon: R.bone },
                    { name: 'Animal Fat', amount: 32, icon: R.fat },
                    { name: 'Cloth', amount: 32, icon: R.cloth },
                    { name: 'Raw Meat', amount: 9, icon: R.raw_meat }
                ]
            }))
        ]
    },
    {
        id: 'wolf',
        name: 'Wolf',
        hp: 150,
        description: "Wolves are fast, aggressive pack animals. While they yield fewer resources than Bears, they are a primary source of Wolf Skulls used for the Wolf Headdress (Tier 2 helmet).",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fwolf.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: BEST (100% Yield) ---
            { name: 'Skinning Knife', icon: T.skinning, drops: WOLF_BEST_DROPS },
            { name: 'Combat Knife', icon: T.combat, drops: WOLF_BEST_DROPS },
            { name: 'Bone Knife', icon: T.bone_knife, drops: WOLF_BEST_DROPS },
            { name: 'Hatchet', icon: T.hatchet, drops: WOLF_BEST_DROPS },
            { name: 'Salvaged Axe', icon: T.axe, drops: WOLF_BEST_DROPS },

            // --- TIER 2: HIGH (Approx 85%) ---
            // Swords/Machetes/Cleavers
            ...['Salvaged Sword', 'Machete', 'Salvaged Cleaver', 'Longsword', 'Mace'].map(name => ({
                name,
                icon: name === 'Salvaged Sword' ? T.sword : name === 'Machete' ? T.machete : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Longsword' ? T.longsword : T.mace,
                drops: [
                    { name: 'Leather', amount: 64, icon: R.leather },
                    { name: 'Bone', amount: 34, icon: R.bone },
                    { name: 'Animal Fat', amount: 30, icon: R.fat },
                    { name: 'Raw Meat', amount: 9, icon: R.raw_meat },
                    { name: 'Cloth', amount: 5, icon: R.cloth },
                    { name: 'Wolf Skull', amount: 1, icon: R.skull }
                ]
            })),

            // --- TIER 3: MID (Approx 70% - Pickaxes) ---
            ...['Stone Pickaxe', 'Pickaxe', 'Salvaged Icepick'].map(name => ({
                name,
                icon: name === 'Stone Pickaxe' ? T.stone_pick : name === 'Pickaxe' ? T.pickaxe : T.icepick,
                drops: [
                    { name: 'Leather', amount: 56, icon: R.leather },
                    { name: 'Bone', amount: 30, icon: R.bone },
                    { name: 'Animal Fat', amount: 26, icon: R.fat },
                    { name: 'Raw Meat', amount: 8, icon: R.raw_meat },
                    { name: 'Cloth', amount: 4, icon: R.cloth }
                ]
            })),

            // --- TIER 4: STONE HATCHET (Approx 60%) ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 46, icon: R.leather },
                    { name: 'Bone', amount: 25, icon: R.bone },
                    { name: 'Animal Fat', amount: 22, icon: R.fat },
                    { name: 'Raw Meat', amount: 6, icon: R.raw_meat },
                    { name: 'Cloth', amount: 3, icon: R.cloth }
                ]
            },

            // --- TIER 5: LOW (Approx 50% - Rock/Bone Club) ---
            ...['Rock', 'Bone Club'].map(name => ({
                name,
                icon: name === 'Rock' ? T.rock : T.bone_club,
                drops: [
                    { name: 'Leather', amount: 38, icon: R.leather },
                    { name: 'Bone', amount: 20, icon: R.bone },
                    { name: 'Animal Fat', amount: 18, icon: R.fat },
                    { name: 'Raw Meat', amount: 5, icon: R.raw_meat },
                    { name: 'Cloth', amount: 3, icon: R.cloth }
                ]
            }))
        ]
    },
    {
        id: 'bear',
        name: 'Bear',
        hp: 325,
        description: "A powerful predator found in most biomes. Bears are fast and capable of killing players in seconds. Avoid until you have firearms or high ground.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fbear.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: BEST (100% Yield) ---
            {
                name: 'Skinning Knife',
                icon: T.skinning,
                drops: [
                    { name: 'Leather', amount: 150, icon: R.leather },
                    { name: 'Bone', amount: 100, icon: R.bone },
                    { name: 'Animal Fat', amount: 100, icon: R.fat },
                    { name: 'Cloth', amount: 50, icon: R.cloth },
                    { name: 'Raw Meat', amount: 20, icon: R.raw_meat }
                ]
            },
            ...['Combat Knife', 'Bone Knife', 'Hatchet', 'Salvaged Axe'].map(name => ({
                name,
                icon: name === 'Combat Knife' ? T.combat : name === 'Bone Knife' ? T.bone_knife : name === 'Hatchet' ? T.hatchet : T.axe,
                drops: [
                    { name: 'Leather', amount: 150, icon: R.leather },
                    { name: 'Bone', amount: 100, icon: R.bone },
                    { name: 'Animal Fat', amount: 100, icon: R.fat },
                    { name: 'Cloth', amount: 50, icon: R.cloth },
                    { name: 'Raw Meat', amount: 20, icon: R.raw_meat }
                ]
            })),

            // --- TIER 2: HIGH ---
            ...['Machete', 'Salvaged Sword', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Leather', amount: 126, icon: R.leather },
                    { name: 'Bone', amount: 84, icon: R.bone },
                    { name: 'Animal Fat', amount: 84, icon: R.fat },
                    { name: 'Cloth', amount: 42, icon: R.cloth },
                    { name: 'Raw Meat', amount: 17, icon: R.raw_meat }
                ]
            })),

            // --- TIER 3: JACKHAMMER/ICEPICK ---
            ...['Jackhammer', 'Salvaged Icepick'].map(name => ({
                name,
                icon: name === 'Jackhammer' ? T.jackhammer : T.icepick,
                drops: [
                    { name: 'Leather', amount: 109, icon: R.leather },
                    { name: 'Bone', amount: 73, icon: R.bone },
                    { name: 'Animal Fat', amount: 73, icon: R.fat },
                    { name: 'Cloth', amount: 36, icon: R.cloth },
                    { name: 'Raw Meat', amount: 15, icon: R.raw_meat }
                ]
            })),

            // --- TIER 4: STONE PICKAXE ---
            {
                name: 'Stone Pickaxe',
                icon: T.stone_pick,
                drops: [
                    { name: 'Leather', amount: 109, icon: R.leather },
                    { name: 'Bone', amount: 72, icon: R.bone },
                    { name: 'Animal Fat', amount: 72, icon: R.fat },
                    { name: 'Cloth', amount: 36, icon: R.cloth },
                    { name: 'Raw Meat', amount: 15, icon: R.raw_meat }
                ]
            },

            // --- TIER 5: CHAINSAW ---
            {
                name: 'Chainsaw',
                icon: T.chainsaw,
                drops: [
                    { name: 'Leather', amount: 100, icon: R.leather },
                    { name: 'Bone', amount: 67, icon: R.bone },
                    { name: 'Animal Fat', amount: 67, icon: R.fat },
                    { name: 'Cloth', amount: 34, icon: R.cloth },
                    { name: 'Raw Meat', amount: 14, icon: R.raw_meat }
                ]
            },

            // --- TIER 6: STONE HATCHET ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 90, icon: R.leather },
                    { name: 'Bone', amount: 60, icon: R.bone },
                    { name: 'Animal Fat', amount: 60, icon: R.fat },
                    { name: 'Cloth', amount: 30, icon: R.cloth },
                    { name: 'Raw Meat', amount: 12, icon: R.raw_meat }
                ]
            },

            // --- TIER 7: BONE CLUB/ROCK ---
            ...['Bone Club', 'Rock'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : T.rock,
                drops: [
                    { name: 'Leather', amount: 75, icon: R.leather },
                    { name: 'Bone', amount: 50, icon: R.bone },
                    { name: 'Animal Fat', amount: 50, icon: R.fat },
                    { name: 'Cloth', amount: 25, icon: R.cloth },
                    { name: 'Raw Meat', amount: 10, icon: R.raw_meat }
                ]
            })),

            // --- TIER 8: HAMMER/PICKAXE ---
            ...['Salvaged Hammer', 'Pickaxe'].map(name => ({
                name,
                icon: name === 'Salvaged Hammer' ? T.hammer : T.pickaxe,
                drops: [
                    { name: 'Leather', amount: 69, icon: R.leather },
                    { name: 'Bone', amount: 46, icon: R.bone },
                    { name: 'Animal Fat', amount: 46, icon: R.fat },
                    { name: 'Cloth', amount: 23, icon: R.cloth },
                    { name: 'Raw Meat', amount: 10, icon: R.raw_meat }
                ]
            }))
        ]
    },
    {
        id: 'boar',
        name: 'Boar',
        hp: 150,
        description: "A boar is a small, black animal that can be found in any biome. Like other animals, boars are attracted to seeds and will fight any competing animals for them.",
        image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fboar.webp&w=414&q=90',
        harvest: [
            // --- TIER 1: BEST (100% Yield) ---
            {
                name: 'Skinning Knife',
                icon: T.skinning,
                drops: [
                    { name: 'Leather', amount: 50, icon: R.leather },
                    { name: 'Bone', amount: 40, icon: R.bone },
                    { name: 'Animal Fat', amount: 20, icon: R.fat },
                    { name: 'Cloth', amount: 10, icon: R.cloth },
                    { name: 'Raw Pork', amount: 8, icon: R.pork },
                    { name: 'Skull', amount: 1, icon: R.skull }
                ]
            },
            ...['Combat Knife', 'Bone Knife', 'Hatchet', 'Salvaged Axe'].map(name => ({
                name,
                icon: name === 'Combat Knife' ? T.combat : name === 'Bone Knife' ? T.bone_knife : name === 'Hatchet' ? T.hatchet : T.axe,
                drops: [
                    { name: 'Leather', amount: 50, icon: R.leather },
                    { name: 'Bone', amount: 40, icon: R.bone },
                    { name: 'Animal Fat', amount: 20, icon: R.fat },
                    { name: 'Cloth', amount: 10, icon: R.cloth },
                    { name: 'Raw Pork', amount: 8, icon: R.pork }
                ]
            })),

            // --- TIER 2: HIGH ---
            ...['Machete', 'Salvaged Sword', 'Salvaged Cleaver', 'Mace', 'Longsword'].map(name => ({
                name,
                icon: name === 'Machete' ? T.machete : name === 'Salvaged Sword' ? T.sword : name === 'Salvaged Cleaver' ? T.cleaver : name === 'Mace' ? T.mace : T.longsword,
                drops: [
                    { name: 'Leather', amount: 44, icon: R.leather },
                    { name: 'Bone', amount: 35, icon: R.bone },
                    { name: 'Animal Fat', amount: 18, icon: R.fat },
                    { name: 'Cloth', amount: 9, icon: R.cloth },
                    { name: 'Raw Pork', amount: 7, icon: R.pork }
                ]
            })),

            // --- TIER 3: MID-HIGH (Jackhammer/Chainsaw/Icepick) ---
            ...['Jackhammer', 'Chainsaw', 'Salvaged Icepick'].map(name => ({
                name,
                icon: name === 'Jackhammer' ? T.jackhammer : name === 'Chainsaw' ? T.chainsaw : T.icepick,
                drops: [
                    { name: 'Leather', amount: 38, icon: R.leather },
                    { name: 'Bone', amount: 30, icon: R.bone },
                    { name: 'Animal Fat', amount: 15, icon: R.fat },
                    { name: 'Cloth', amount: 8, icon: R.cloth },
                    { name: 'Raw Pork', amount: 6, icon: R.pork }
                ]
            })),

            // --- TIER 4: STONE PICKAXE ---
            {
                name: 'Stone Pickaxe',
                icon: T.stone_pick,
                drops: [
                    { name: 'Leather', amount: 36, icon: R.leather },
                    { name: 'Bone', amount: 29, icon: R.bone },
                    { name: 'Animal Fat', amount: 15, icon: R.fat },
                    { name: 'Cloth', amount: 8, icon: R.cloth },
                    { name: 'Raw Pork', amount: 6, icon: R.pork }
                ]
            },

            // --- TIER 5: STONE HATCHET ---
            {
                name: 'Stone Hatchet',
                icon: T.stone_hatchet,
                drops: [
                    { name: 'Leather', amount: 31, icon: R.leather },
                    { name: 'Bone', amount: 25, icon: R.bone },
                    { name: 'Animal Fat', amount: 12, icon: R.fat },
                    { name: 'Cloth', amount: 6, icon: R.cloth },
                    { name: 'Raw Pork', amount: 5, icon: R.pork }
                ]
            },

            // --- TIER 6: LOW (Bone Club/Rock) ---
            ...['Bone Club', 'Rock'].map(name => ({
                name,
                icon: name === 'Bone Club' ? T.bone_club : T.rock,
                drops: [
                    { name: 'Leather', amount: 25, icon: R.leather },
                    { name: 'Bone', amount: 20, icon: R.bone },
                    { name: 'Animal Fat', amount: 10, icon: R.fat },
                    { name: 'Cloth', amount: 5, icon: R.cloth },
                    { name: 'Raw Pork', amount: 4, icon: R.pork }
                ]
            })),

            // --- TIER 7: LOWEST (Hammer/Pickaxe) ---
            ...['Salvaged Hammer', 'Pickaxe'].map(name => ({
                name,
                icon: name === 'Salvaged Hammer' ? T.hammer : T.pickaxe,
                drops: [
                    { name: 'Leather', amount: 23, icon: R.leather },
                    { name: 'Bone', amount: 19, icon: R.bone },
                    { name: 'Animal Fat', amount: 10, icon: R.fat },
                    { name: 'Cloth', amount: 5, icon: R.cloth },
                    { name: 'Raw Pork', amount: 4, icon: R.pork }
                ]
            }))
        ]
    }
];
