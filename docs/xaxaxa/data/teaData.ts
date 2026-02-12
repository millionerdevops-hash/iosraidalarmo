
export type TeaTier = 'Basic' | 'Advanced' | 'Pure';
export type TeaType = 'Ore' | 'Wood' | 'Scrap' | 'Harvesting' | 'MaxHealth' | 'Healing' | 'Rad' | 'Cooling' | 'Warming' | 'Crafting';

export interface TeaRecipe {
    inputs: { name: string; count: number; img: string }[];
}

export interface TeaDef {
    id: string;
    name: string;
    type: TeaType;
    tier: TeaTier;
    duration: string;
    description: string;
    stats: { label: string; value: string; isPositive: boolean }[];
    recipe: TeaRecipe;
    color: string; // Tailwind color class for visual identification
    image: string; 
}

const BERRY_IMAGES = {
    Yellow: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fyellow-berry.webp&w=414&q=90',
    White: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fwhite-berry.webp&w=414&q=90',
    Red: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fred-berry.webp&w=414&q=90',
    Green: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fgreen-berry.webp&w=414&q=90',
    Blue: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fblue-berry.webp&w=414&q=90'
};

const TEA_IMAGES = {
    // Basic
    rad_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fradiationresisttea.webp&w=414&q=90',
    healing_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fhealingtea.webp&w=414&q=90',
    hp_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fmaxhealthtea.webp&w=414&q=90',
    cooling_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fcoolingtea.webp&w=414&q=90',
    warming_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fwarmingtea.webp&w=414&q=90',
    crafting_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fcraftingtea-quality.webp&w=414&q=90',
    ore_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Foretea.webp&w=414&q=90',
    harvest_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fharvestingtea.webp&w=414&q=90',
    wood_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fwoodtea.webp&w=414&q=90',
    scrap_basic: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fscraptea.webp&w=414&q=90',

    // Advanced
    rad_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fradiationresisttea-advanced.webp&w=414&q=90',
    healing_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fhealingtea-advanced.webp&w=414&q=90',
    hp_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fmaxhealthtea-advanced.webp&w=414&q=90',
    cooling_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fadvancedcoolingtea.webp&w=414&q=90',
    warming_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fadvancedwarmingtea.webp&w=414&q=90',
    crafting_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fadvancedcraftingtea-quality.webp&w=414&q=90',
    ore_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Foretea-advanced.webp&w=414&q=90',
    scrap_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fscraptea-advanced.webp&w=414&q=90',
    harvest_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fadvanceharvestingtea.webp&w=414&q=90',
    wood_adv: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fwoodtea-advanced.webp&w=414&q=90',

    // Pure
    rad_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fradiationresisttea-pure.webp&w=414&q=90',
    healing_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fhealingtea-pure.webp&w=414&q=90',
    hp_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fmaxhealthtea-pure.webp&w=414&q=90',
    cooling_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpurecoolingtea.webp&w=414&q=90',
    warming_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpurewarmingtea.webp&w=414&q=90',
    crafting_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpurecraftingtea-quality.webp&w=414&q=90',
    ore_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Foretea-pure.webp&w=414&q=90',
    scrap_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fscraptea-pure.webp&w=414&q=90',
    harvest_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpureharvestingtea.webp&w=414&q=90',
    wood_pure: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fwoodtea-pure.webp&w=414&q=90',
};

// Helper to construct the full 3-tier family for a specific tea
const createTeaFamily = (
    type: TeaType,
    colorClass: string,
    imgKeys: { basic: string, adv: string, pure: string },
    basicData: { 
        inputs: { name: string, count: number, img: string }[],
        duration: string,
        stats: { label: string, value: string, isPositive: boolean }[]
    },
    advData: { duration: string, stats: { label: string, value: string, isPositive: boolean }[] },
    pureData: { duration: string, stats: { label: string, value: string, isPositive: boolean }[] }
): TeaDef[] => {
    
    // Basic Definition
    const basicTea: TeaDef = {
        id: `${type}_basic`,
        name: `Basic ${type} Tea`,
        type,
        tier: 'Basic',
        duration: basicData.duration,
        description: `Basic tier ${type} tea.`,
        stats: basicData.stats,
        recipe: { inputs: basicData.inputs },
        color: colorClass,
        image: imgKeys.basic
    };

    // Advanced Definition
    const advTea: TeaDef = {
        id: `${type}_adv`,
        name: `Advanced ${type} Tea`,
        type,
        tier: 'Advanced',
        duration: advData.duration,
        description: `Advanced tier ${type} tea.`,
        stats: advData.stats,
        recipe: {
            inputs: [{ name: `Basic ${type} Tea`, count: 4, img: imgKeys.basic }]
        },
        color: colorClass,
        image: imgKeys.adv
    };

    // Pure Definition
    const pureTea: TeaDef = {
        id: `${type}_pure`,
        name: `Pure ${type} Tea`,
        type,
        tier: 'Pure',
        duration: pureData.duration,
        description: `Pure tier ${type} tea.`,
        stats: pureData.stats,
        recipe: {
            inputs: [{ name: `Adv. ${type} Tea`, count: 4, img: imgKeys.adv }]
        },
        color: colorClass,
        image: imgKeys.pure
    };

    return [basicTea, advTea, pureTea];
};

export const TEA_DATABASE: TeaDef[] = [
    // 1. ANTI-RAD TEA
    // Basic: Red Berry x2, Green Berry x2
    ...createTeaFamily(
        'Rad', 
        'text-orange-500 bg-orange-900/10 border-orange-500/50',
        { basic: TEA_IMAGES.rad_basic, adv: TEA_IMAGES.rad_adv, pure: TEA_IMAGES.rad_pure },
        {
            inputs: [
                { name: 'Red Berry', count: 2, img: BERRY_IMAGES.Red },
                { name: 'Green Berry', count: 2, img: BERRY_IMAGES.Green }
            ],
            duration: '30m',
            stats: [
                { label: 'Rad Res', value: '+15%', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: '30m',
            stats: [{ label: 'Rad Res', value: '+30%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        },
        { // Pure
            duration: '30m',
            stats: [{ label: 'Rad Res', value: '+45%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        }
    ),

    // 2. COOLING TEA
    // Basic: White Berry x2, Blue Berry x2
    ...createTeaFamily(
        'Cooling', 
        'text-cyan-400 bg-cyan-900/10 border-cyan-500/50',
        { basic: TEA_IMAGES.cooling_basic, adv: TEA_IMAGES.cooling_adv, pure: TEA_IMAGES.cooling_pure },
        {
            inputs: [
                { name: 'White Berry', count: 2, img: BERRY_IMAGES.White },
                { name: 'Blue Berry', count: 2, img: BERRY_IMAGES.Blue }
            ],
            duration: '20m',
            stats: [
                { label: 'Temp', value: '+10°', isPositive: true },
                { label: 'Max Temp', value: '+40°', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: '45m',
            stats: [
                { label: 'Temp', value: '+15°', isPositive: true },
                { label: 'Max Temp', value: '+40°', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Pure
            duration: '1h',
            stats: [
                { label: 'Temp', value: '+20°', isPositive: true },
                { label: 'Max Temp', value: '+40°', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        }
    ),

    // 3. CRAFTING QUALITY TEA
    // Basic: Green Berry x3, White Berry x1
    ...createTeaFamily(
        'Crafting', 
        'text-purple-400 bg-purple-900/10 border-purple-500/50',
        { basic: TEA_IMAGES.crafting_basic, adv: TEA_IMAGES.crafting_adv, pure: TEA_IMAGES.crafting_pure },
        {
            inputs: [
                { name: 'Green Berry', count: 3, img: BERRY_IMAGES.Green },
                { name: 'White Berry', count: 1, img: BERRY_IMAGES.White }
            ],
            duration: '3m 20s',
            stats: [
                { label: 'Quality', value: '+50%', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: '5m',
            stats: [{ label: 'Quality', value: '+75%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        },
        { // Pure
            duration: '6m 40s',
            stats: [{ label: 'Quality', value: '+85%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        }
    ),

    // 4. HARVESTING TEA
    // Basic: Yellow Berry x1, Green Berry x3
    ...createTeaFamily(
        'Harvesting', 
        'text-lime-400 bg-lime-900/10 border-lime-500/50',
        { basic: TEA_IMAGES.harvest_basic, adv: TEA_IMAGES.harvest_adv, pure: TEA_IMAGES.harvest_pure },
        {
            inputs: [
                { name: 'Yellow Berry', count: 1, img: BERRY_IMAGES.Yellow },
                { name: 'Green Berry', count: 3, img: BERRY_IMAGES.Green }
            ],
            duration: '20m',
            stats: [
                { label: 'Yield', value: '+35%', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: '20m',
            stats: [{ label: 'Yield', value: '+50%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        },
        { // Pure
            duration: '20m',
            stats: [{ label: 'Yield', value: '+65%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        }
    ),

    // 5. HEALING TEA
    // Basic: Red Berry x4
    ...createTeaFamily(
        'Healing', 
        'text-red-500 bg-red-900/10 border-red-500/50',
        { basic: TEA_IMAGES.healing_basic, adv: TEA_IMAGES.healing_adv, pure: TEA_IMAGES.healing_pure },
        {
            inputs: [
                { name: 'Red Berry', count: 4, img: BERRY_IMAGES.Red }
            ],
            duration: 'Instant',
            stats: [
                { label: 'HoT', value: '+30 HP', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: 'Instant',
            stats: [
                { label: 'HoT', value: '+50 HP', isPositive: true }, 
                { label: 'Inst. HP', value: '+5 HP', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Pure
            duration: 'Instant',
            stats: [
                { label: 'HoT', value: '+75 HP', isPositive: true }, 
                { label: 'Inst. HP', value: '+10 HP', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        }
    ),

    // 6. MAX HEALTH TEA
    // Basic: Red Berry x3, Yellow Berry x1
    ...createTeaFamily(
        'MaxHealth', 
        'text-emerald-500 bg-emerald-900/10 border-emerald-500/50',
        { basic: TEA_IMAGES.hp_basic, adv: TEA_IMAGES.hp_adv, pure: TEA_IMAGES.hp_pure },
        {
            inputs: [
                { name: 'Red Berry', count: 3, img: BERRY_IMAGES.Red },
                { name: 'Yellow Berry', count: 1, img: BERRY_IMAGES.Yellow }
            ],
            duration: '20m',
            stats: [
                { label: 'Max HP', value: '+5%', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: '20m',
            stats: [{ label: 'Max HP', value: '+12.5%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        },
        { // Pure
            duration: '20m',
            stats: [{ label: 'Max HP', value: '+20%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        }
    ),

    // 7. ORE TEA
    // Basic: Yellow Berry x2, Blue Berry x2
    ...createTeaFamily(
        'Ore', 
        'text-yellow-500 bg-yellow-900/10 border-yellow-500/50',
        { basic: TEA_IMAGES.ore_basic, adv: TEA_IMAGES.ore_adv, pure: TEA_IMAGES.ore_pure },
        {
            inputs: [
                { name: 'Yellow Berry', count: 2, img: BERRY_IMAGES.Yellow },
                { name: 'Blue Berry', count: 2, img: BERRY_IMAGES.Blue }
            ],
            duration: '30m',
            stats: [
                { label: 'Yield', value: '+20%', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: '30m',
            stats: [{ label: 'Yield', value: '+35%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        },
        { // Pure
            duration: '30m',
            stats: [{ label: 'Yield', value: '+50%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        }
    ),

    // 8. SCRAP TEA
    // Basic: Yellow Berry x2, White Berry x2
    ...createTeaFamily(
        'Scrap', 
        'text-zinc-300 bg-zinc-900/10 border-zinc-500/50',
        { basic: TEA_IMAGES.scrap_basic, adv: TEA_IMAGES.scrap_adv, pure: TEA_IMAGES.scrap_pure },
        {
            inputs: [
                { name: 'Yellow Berry', count: 2, img: BERRY_IMAGES.Yellow },
                { name: 'White Berry', count: 2, img: BERRY_IMAGES.White }
            ],
            duration: '30m',
            stats: [
                { label: 'Yield', value: '+100%', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: '45m',
            stats: [{ label: 'Yield', value: '+225%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        },
        { // Pure
            duration: '1h',
            stats: [{ label: 'Yield', value: '+350%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        }
    ),

    // 9. WARMING TEA
    // Basic: White Berry x2, Yellow Berry x2
    ...createTeaFamily(
        'Warming', 
        'text-orange-300 bg-orange-900/10 border-orange-300/50',
        { basic: TEA_IMAGES.warming_basic, adv: TEA_IMAGES.warming_adv, pure: TEA_IMAGES.warming_pure },
        {
            inputs: [
                { name: 'White Berry', count: 2, img: BERRY_IMAGES.White },
                { name: 'Yellow Berry', count: 2, img: BERRY_IMAGES.Yellow }
            ],
            duration: '20m',
            stats: [
                { label: 'Temp', value: '+5°', isPositive: true },
                { label: 'Min Temp', value: '-15°', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: '45m',
            stats: [
                { label: 'Temp', value: '+10°', isPositive: true },
                { label: 'Min Temp', value: '-8°', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Pure
            duration: '1h',
            stats: [
                { label: 'Temp', value: '+15°', isPositive: true },
                { label: 'Min Temp', value: '0°', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        }
    ),

    // 10. WOOD TEA
    // Basic: Red Berry x2, Blue Berry x2
    ...createTeaFamily(
        'Wood', 
        'text-amber-600 bg-amber-900/10 border-amber-600/50',
        { basic: TEA_IMAGES.wood_basic, adv: TEA_IMAGES.wood_adv, pure: TEA_IMAGES.wood_pure },
        {
            inputs: [
                { name: 'Red Berry', count: 2, img: BERRY_IMAGES.Red },
                { name: 'Blue Berry', count: 2, img: BERRY_IMAGES.Blue }
            ],
            duration: '30m',
            stats: [
                { label: 'Yield', value: '+50%', isPositive: true },
                { label: 'Hydration', value: '+30', isPositive: true }
            ]
        },
        { // Adv
            duration: '30m',
            stats: [{ label: 'Yield', value: '+100%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        },
        { // Pure
            duration: '30m',
            stats: [{ label: 'Yield', value: '+200%', isPositive: true }, { label: 'Hydration', value: '+30', isPositive: true }]
        }
    )
];
