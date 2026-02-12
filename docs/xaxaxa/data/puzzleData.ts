
export interface PuzzleRequirement {
    type: 'Fuse' | 'Green Card' | 'Blue Card' | 'Red Card';
    count: number;
}

export interface PuzzleStep {
    id: number;
    title: string;
    description: string;
    image: string; // Using item icons as placeholders for steps
}

export interface MonumentPuzzle {
    id: string;
    name: string;
    difficulty: 'Easy' | 'Medium' | 'Hard' | 'Elite';
    requirements: PuzzleRequirement[];
    steps: PuzzleStep[];
    thumbnail: string;
    lootGrade: 'Low' | 'Medium' | 'High' | 'Elite';
}

const ICONS = {
    fuse: 'https://rustlabs.com/img/items180/fuse.png',
    green: 'https://rustlabs.com/img/items180/keycard_green.png',
    blue: 'https://rustlabs.com/img/items180/keycard_blue.png',
    red: 'https://rustlabs.com/img/items180/keycard_red.png',
    switch: 'https://rustlabs.com/img/items180/switch.png',
    valve: 'https://rustlabs.com/img/items180/water.catcher.small.png', // Placeholder for Wheel
    crate: 'https://rustlabs.com/img/items180/crate_elite.png',
    door: 'https://rustlabs.com/img/items180/door.hinged.metal.png'
};

export const MONUMENT_PUZZLES: MonumentPuzzle[] = [
    // --- TIER 1: EASY ---
    {
        id: 'satellite_dish',
        name: 'Satellite Dish',
        difficulty: 'Easy',
        lootGrade: 'Low',
        thumbnail: 'https://rustlabs.com/img/monuments/satellite-dish-array.png',
        requirements: [
            { type: 'Fuse', count: 1 },
            { type: 'Green Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Fuse Shack',
                description: 'Locate the small shack with the fuse box. Insert Fuse and flip the switch on the back wall.',
                image: ICONS.fuse
            },
            {
                id: 2,
                title: 'Green Cabin',
                description: 'Run to the double trailers. Swipe Green Card to access the loot and Blue Card spawn.',
                image: ICONS.green
            }
        ]
    },
    {
        id: 'sewer_branch',
        name: 'Sewer Branch',
        difficulty: 'Easy',
        lootGrade: 'Medium',
        thumbnail: 'https://rustlabs.com/img/monuments/sewer-branch.png',
        requirements: [
            { type: 'Fuse', count: 1 },
            { type: 'Green Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Power Switch',
                description: 'Find the red brick building. Insert Fuse and flip the switch to power the tunnel entrance.',
                image: ICONS.switch
            },
            {
                id: 2,
                title: 'Main Entrance',
                description: 'Go to the hole in the ground. Swipe Green Card to enter the tunnels.',
                image: ICONS.green
            },
            {
                id: 3,
                title: 'Jump Puzzle',
                description: 'Navigate the jumping puzzle in the sewer to reach the main loot room.',
                image: ICONS.crate
            }
        ]
    },

    // --- TIER 2: MEDIUM ---
    {
        id: 'water_treatment',
        name: 'Water Treatment',
        difficulty: 'Medium',
        lootGrade: 'Medium',
        thumbnail: 'https://rustlabs.com/img/monuments/water-treatment-plant.png',
        requirements: [
            { type: 'Fuse', count: 1 },
            { type: 'Blue Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Turn the Wheel',
                description: 'Locate the 2-story building in the middle. Turn the red wheel on the side to open the security door.',
                image: ICONS.valve
            },
            {
                id: 2,
                title: 'Fuse & Timer',
                description: 'Run inside the door you just opened. Insert Fuse and flip the Timer Switch.',
                image: ICONS.fuse
            },
            {
                id: 3,
                title: 'Blue Room',
                description: 'Run to the building with the garage door. Swipe Blue Card to enter the loot room.',
                image: ICONS.blue
            }
        ]
    },
    {
        id: 'train_yard',
        name: 'Train Yard',
        difficulty: 'Medium',
        lootGrade: 'High',
        thumbnail: 'https://rustlabs.com/img/monuments/train-yard.png',
        requirements: [
            { type: 'Fuse', count: 1 },
            { type: 'Blue Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Tower Switch',
                description: 'Climb the tall concrete tower. Flip the electric switch at the top to activate the grid.',
                image: ICONS.switch
            },
            {
                id: 2,
                title: 'Fuse Cabin',
                description: 'Go to the red brick building near the tracks. Insert Fuse and flip the timer switch.',
                image: ICONS.fuse
            },
            {
                id: 3,
                title: 'Main Building',
                description: 'Run up the stairs of the main office building. Swipe Blue Card to access Red Card spawn.',
                image: ICONS.blue
            }
        ]
    },
    {
        id: 'airfield',
        name: 'Airfield',
        difficulty: 'Medium',
        lootGrade: 'Medium',
        thumbnail: 'https://rustlabs.com/img/monuments/airfield.png',
        requirements: [
            { type: 'Fuse', count: 2 },
            { type: 'Green Card', count: 1 },
            { type: 'Blue Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Main Terminal',
                description: 'Go to the main terminal building. Insert a Fuse and flip the switch.',
                image: ICONS.fuse
            },
            {
                id: 2,
                title: 'Hangar Fuse',
                description: 'Cross the runway to the Hangar. Insert the second Fuse and flip the switch.',
                image: ICONS.fuse
            },
            {
                id: 3,
                title: 'Underground',
                description: 'Enter the tunnel hatch. Swipe Green Card first, then Blue Card deeper inside.',
                image: ICONS.blue
            }
        ]
    },
    {
        id: 'power_plant',
        name: 'Power Plant',
        difficulty: 'Medium',
        lootGrade: 'High',
        thumbnail: 'https://rustlabs.com/img/monuments/power-plant.png',
        requirements: [
            { type: 'Fuse', count: 1 },
            { type: 'Green Card', count: 1 },
            { type: 'Blue Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Timer Switch',
                description: 'Find the small shack near the cooling towers. Flip the timer switch (no fuse needed yet).',
                image: ICONS.switch
            },
            {
                id: 2,
                title: 'Core Fuse',
                description: 'Run to the central building with the slanted roof. Insert Fuse and flip the switch.',
                image: ICONS.fuse
            },
            {
                id: 3,
                title: 'Puzzle Building',
                description: 'Swipe Green Card to enter the central building, then find the Blue door upstairs.',
                image: ICONS.blue
            }
        ]
    },
    {
        id: 'arctic_base',
        name: 'Arctic Research',
        difficulty: 'Medium',
        lootGrade: 'High',
        thumbnail: 'https://rustlabs.com/img/monuments/arctic-research-base.png',
        requirements: [
            { type: 'Fuse', count: 1 },
            { type: 'Blue Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Blue Container',
                description: 'Locate the blue shipping container office. Insert Fuse and flip the switch.',
                image: ICONS.fuse
            },
            {
                id: 2,
                title: 'Main Lab',
                description: 'Go to the large garage building. Swipe Blue Card to access the loot and snowmobiles.',
                image: ICONS.blue
            }
        ]
    },

    // --- TIER 3: HARD / ELITE ---
    {
        id: 'military_tunnels',
        name: 'Military Tunnels',
        difficulty: 'Hard',
        lootGrade: 'Elite',
        thumbnail: 'https://rustlabs.com/img/monuments/military-tunnels.png',
        requirements: [
            { type: 'Fuse', count: 1 },
            { type: 'Green Card', count: 1 },
            { type: 'Blue Card', count: 1 },
            { type: 'Red Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Entrance Fuse',
                description: 'Inside the tunnel entrance on the right, put a Fuse in the box inside the small room.',
                image: ICONS.fuse
            },
            {
                id: 2,
                title: 'The Lab',
                description: 'Swipe Green to enter. Clear Scientists. Swipe Blue to progress deeper.',
                image: ICONS.green
            },
            {
                id: 3,
                title: 'Red Room',
                description: 'The final loot room requires a Red Card. Contains Elite Crates. Watch for scientists!',
                image: ICONS.red
            }
        ]
    },
    {
        id: 'missile_silo',
        name: 'Missile Silo',
        difficulty: 'Hard',
        lootGrade: 'Elite',
        thumbnail: 'https://rustlabs.com/img/monuments/missile-silo.png',
        requirements: [
            { type: 'Fuse', count: 1 },
            { type: 'Blue Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Bunker Entrance',
                description: 'Enter the silo. Beware of high radiation and heavy scientist presence.',
                image: ICONS.door
            },
            {
                id: 2,
                title: 'Security Room',
                description: 'Locate the security room deep inside. Insert Fuse and swipe Blue Card.',
                image: ICONS.blue
            },
            {
                id: 3,
                title: 'Warhead',
                description: 'Reach the bottom. Press the button to reveal the elite loot. Exfiltrate quickly.',
                image: ICONS.crate
            }
        ]
    },
    {
        id: 'launch_site',
        name: 'Launch Site',
        difficulty: 'Elite',
        lootGrade: 'Elite',
        thumbnail: 'https://rustlabs.com/img/monuments/launch-site.png',
        requirements: [
            { type: 'Fuse', count: 2 },
            { type: 'Green Card', count: 1 },
            { type: 'Blue Card', count: 1 },
            { type: 'Red Card', count: 1 }
        ],
        steps: [
            {
                id: 1,
                title: 'Power Station',
                description: 'Locate the two small buildings opposite the main factory. Insert 2 Fuses and flip switches.',
                image: ICONS.fuse
            },
            {
                id: 2,
                title: 'Red Swipe',
                description: 'Swipe Red Card at the main factory door. Enter and locate the second Red door inside.',
                image: ICONS.red
            },
            {
                id: 3,
                title: 'The Roof',
                description: 'Navigate to the roof for Elite Crates. Watch out for the Bradley APC patrolling outside!',
                image: ICONS.crate
            }
        ]
    }
];
