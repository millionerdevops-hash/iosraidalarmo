
export interface RecyclerLocation {
    id: string;
    name: string;
    description: string;
    safety: 'Safe' | 'Unsafe' | 'Rad';
    yield: number; // 1.0 or 0.8
    radiation: 'None' | 'Low' | 'Medium' | 'High';
    npc: boolean; // Scientists present?
    requirements: string[]; // What to bring
    tactics: string; // Specific advice
    images: string[];
}

export const RECYCLER_LOCATIONS: RecyclerLocation[] = [
    {
        id: 'outpost',
        name: 'Outpost',
        description: "The primary Safe Zone. Contains 3 Recyclers. One near the Research Table, two in the back processing area.",
        safety: 'Safe',
        yield: 0.8,
        radiation: 'None',
        npc: true,
        requirements: ['None'],
        tactics: "100% Safe but yields 20% less resources. Ideal for AFK recycling huge batches. Scientists are friendly unless you hold a weapon longer than 5s.",
        images: [
            'https://rustlabs.com/img/monuments/outpost.png',
            'https://files.facepunch.com/paddy/20220301/outpost_recyclers.jpg' 
        ]
    },
    {
        id: 'bandit',
        name: 'Bandit Camp',
        description: "Located in the Swamp (or combined with Outpost on small maps). Recycler is in the Casino room, second floor.",
        safety: 'Safe',
        yield: 0.8,
        radiation: 'None',
        npc: true,
        requirements: ['None'],
        tactics: "Safezone penalty applies (80% yield). Be careful leaving; campers often hold the swamp exits. You can gamble scrap while recycling.",
        images: [
            'https://rustlabs.com/img/monuments/bandit-camp.png',
            'https://files.facepunch.com/paddy/20180802/bandit_town_header.jpg'
        ]
    },
    {
        id: 'arctic_base',
        name: 'Arctic Research',
        description: "Always spawns in the Snow Biome. Recycler is located outside the main garage building, near the blue containers.",
        safety: 'Unsafe',
        yield: 1.0,
        radiation: 'Low',
        npc: true,
        requirements: ['Hazmat Suit', 'Weapon', 'Meds'],
        tactics: "Heavily guarded by Scientists and a Snowmobile patrol. High PvP zone due to easy Blue/Red card access. Cold protection is mandatory.",
        images: [
            'https://rustlabs.com/img/monuments/arctic-research-base.png',
            'https://files.facepunch.com/paddy/20220203/feb_update_arctic_base.jpg'
        ]
    },
    {
        id: 'supermarket',
        name: 'Supermarket',
        description: "Tier 1 Monument found on roadsides. Recycler is in the fenced back alley.",
        safety: 'Unsafe',
        yield: 1.0,
        radiation: 'None',
        npc: false,
        requirements: ['None'],
        tactics: "Very high traffic for fresh spawns. The roof is a popular camping spot for bow kids. Check for Green Card on the desk inside.",
        images: [
            'https://rustlabs.com/img/monuments/supermarket.png',
            'https://i.imgur.com/supermarket_rec.jpg'
        ]
    },
    {
        id: 'oxums',
        name: 'Oxum\'s Gas Station',
        description: "Tier 1 Monument. Recycler is inside the garage bay (left side).",
        safety: 'Unsafe',
        yield: 1.0,
        radiation: 'None',
        npc: false,
        requirements: ['None'],
        tactics: "The garage has multiple peek angles (roof hole, back door). Dangerous to recycle alone as you can be trapped easily.",
        images: [
            'https://rustlabs.com/img/monuments/oxums-gas-station.png',
            'https://i.imgur.com/oxums_rec.jpg'
        ]
    },
    {
        id: 'mining_outpost',
        name: 'Mining Outpost',
        description: "Tier 1 Monument. Recycler is inside the small L-shaped warehouse.",
        safety: 'Unsafe',
        yield: 1.0,
        radiation: 'None',
        npc: false,
        requirements: ['None'],
        tactics: "Often overlooked. Good for quick solo runs. Be careful of players hiding on the pallet shelves inside the room.",
        images: [
            'https://rustlabs.com/img/monuments/mining-outpost.png',
            'https://i.imgur.com/mining_rec.jpg'
        ]
    },
    {
        id: 'lighthouse',
        name: 'Lighthouse',
        description: "Coastal Monument. Recycler is on the balcony halfway up the tower.",
        safety: 'Unsafe',
        yield: 1.0,
        radiation: 'None',
        npc: false,
        requirements: ['None'],
        tactics: "Zero radiation. Only one way up/down (the stairs), making it a death trap if a clan pushes you. Jump off into the water to escape.",
        images: [
            'https://rustlabs.com/img/monuments/lighthouse.png',
            'https://i.imgur.com/lighthouse_rec.jpg'
        ]
    },
    {
        id: 'satellites',
        name: 'Satellites',
        description: "Two recyclers exist here. One on the platform of the tilted dish, another in a small tin shack nearby.",
        safety: 'Unsafe',
        yield: 1.0,
        radiation: 'Low',
        npc: false,
        requirements: ['Clothing (10% Rad)'],
        tactics: "Very open area, sniper haven. The dish platform recycler is safer as you have the high ground advantage.",
        images: [
            'https://images.squarespace-cdn.com/content/v1/5420d068e4b09194f76b2af6/1480363937615-GWUBHPXJ264ZTCC88YYO/sat.jpg?format=2500w',
            'https://images.squarespace-cdn.com/content/v1/5420d068e4b09194f76b2af6/1480364148001-2ZHR0INWE4FHYXLSNXDP/image-asset.jpeg?format=2500w'
        ]
    },
    {
        id: 'junkyard',
        name: 'Junkyard',
        description: "Recycler is on the raised platform near the Magnet Crane.",
        safety: 'Unsafe',
        yield: 1.0,
        radiation: 'None',
        npc: true,
        requirements: ['Weapon'],
        tactics: "Scientists patrol this area. You can also use the Magnet Crane to drop cars into the Shredder for huge amounts of Scrap.",
        images: [
            'https://rustlabs.com/img/monuments/junkyard.png',
            'https://i.imgur.com/junk_rec.jpg'
        ]
    },
    {
        id: 'water_treatment',
        name: 'Water Treatment',
        description: "Inside the long middle building with the wheel handle. Upstairs.",
        safety: 'Rad',
        yield: 1.0,
        radiation: 'Medium',
        npc: true,
        requirements: ['Hazmat Suit', 'Weapon', 'Fuse (Optional)'],
        tactics: "Scientists guard the exterior. The loot density is high. You don't need a card to access the recycler, but you need a Hazmat suit.",
        images: [
            'https://rustlabs.com/img/monuments/water-treatment-plant.png',
            'https://i.imgur.com/water_rec.jpg'
        ]
    },
    {
        id: 'train_yard',
        name: 'Train Yard',
        description: "In the large central building (Puzzle Building), usually on the balcony/second floor.",
        safety: 'Rad',
        yield: 1.0,
        radiation: 'Medium',
        npc: true,
        requirements: ['Hazmat Suit', 'Weapon'],
        tactics: "Heavily guarded by scientists. High-tier loot crates spawn nearby. A favorite spot for clans to hold.",
        images: [
            'https://rustlabs.com/img/monuments/train-yard.png',
            'https://i.imgur.com/train_rec.jpg'
        ]
    },
    {
        id: 'power_plant',
        name: 'Power Plant',
        description: "Located in one of the smaller sheds near the cooling towers or the puzzle building.",
        safety: 'Rad',
        yield: 1.0,
        radiation: 'Medium',
        npc: true,
        requirements: ['Hazmat Suit', 'Weapon'],
        tactics: "Many dark corners for campers. Scientists patrol the puzzle area. Requires radiation protection.",
        images: [
            'https://rustlabs.com/img/monuments/power-plant.png',
            'https://i.imgur.com/power_rec.jpg'
        ]
    },
    {
        id: 'airfield',
        name: 'Airfield',
        description: "Inside the Garage attached to the main terminal building.",
        safety: 'Rad',
        yield: 1.0,
        radiation: 'Low',
        npc: true,
        requirements: ['Weapon', 'Basic Clothes'],
        tactics: "Wide open tarmac makes you a sniper target entering/exiting. Scientists spawn in the underground tunnels and around the terminal.",
        images: [
            'https://rustlabs.com/img/monuments/airfield.png',
            'https://i.imgur.com/airfield_rec.jpg'
        ]
    },
    {
        id: 'harbor',
        name: 'Harbors',
        description: "Recycler is usually near the first building on the dock or near the large crane.",
        safety: 'Unsafe',
        yield: 1.0,
        radiation: 'None',
        npc: false,
        requirements: ['None'],
        tactics: "Accessible by boat. Great for recycling components from sea barrel runs. No radiation makes it a grub favorite.",
        images: [
            'https://rustlabs.com/img/monuments/harbor-1.png',
            'https://i.imgur.com/harbor_rec.jpg'
        ]
    }
];
