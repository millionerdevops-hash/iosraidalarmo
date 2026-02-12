
// Coordinate system: 0,0 is center. 
// Positive Y = Up (Bullet Impact).
// Positive X = Right (Bullet Impact).

export interface RecoilPattern {
    id: string;
    name: string;
    rpm: number; // Rounds per minute
    ammoCapacity: number;
    description: string;
    difficulty: 'Easy' | 'Medium' | 'Hard' | 'Extreme';
    imageUrl: string;
    // Array of cumulative coordinates relative to center (0,0)
    pattern: { x: number; y: number }[];
}

// --- PATTERNS ---

const AK47_PATTERN = [
    {x:0, y:0}, 
    {x:2, y:12}, {x:3, y:25}, {x:4, y:38}, {x:5, y:50}, {x:5, y:60},
    {x:8, y:68}, {x:12, y:75}, {x:18, y:80}, {x:24, y:83}, {x:28, y:85},
    {x:25, y:87}, {x:18, y:88}, {x:8, y:89}, {x:-5, y:90}, {x:-18, y:91},
    {x:-28, y:92}, {x:-35, y:93}, {x:-38, y:93}, {x:-35, y:94}, {x:-28, y:94},
    {x:-18, y:95}, {x:-5, y:95}, {x:8, y:96}, {x:20, y:96}, {x:28, y:96},
    {x:32, y:97}, {x:28, y:97}, {x:20, y:98}, {x:10, y:98}, {x:0, y:98}
];

const LR300_PATTERN = [
    {x:0, y:0},
    {x:0, y:9}, {x:-1, y:18}, {x:-1, y:27}, {x:0, y:36}, {x:1, y:45},
    {x:2, y:53}, {x:3, y:60}, {x:3, y:66}, {x:2, y:71}, {x:0, y:76},
    {x:-2, y:80}, {x:-4, y:84}, {x:-5, y:87}, {x:-5, y:90}, {x:-4, y:93},
    {x:-2, y:95}, {x:0, y:97}, {x:2, y:98}, {x:4, y:99}, {x:5, y:100},
    {x:5, y:101}, {x:4, y:102}, {x:2, y:103}, {x:0, y:104}, {x:-2, y:104},
    {x:-3, y:105}, {x:-3, y:105}, {x:-2, y:106}, {x:0, y:106}
];

const MP5_PATTERN = [
    {x:0, y:0},
    {x:1, y:8}, {x:2, y:16}, {x:4, y:24}, {x:5, y:32}, {x:6, y:40},
    {x:8, y:48}, {x:9, y:55}, {x:10, y:62}, {x:10, y:68}, {x:9, y:74},
    {x:7, y:79}, {x:5, y:83}, {x:3, y:86}, {x:2, y:88}, {x:2, y:90},
    {x:3, y:92}, {x:5, y:93}, {x:7, y:94}, {x:9, y:95}, {x:10, y:96},
    {x:10, y:97}, {x:9, y:98}, {x:7, y:98}, {x:5, y:99}, {x:4, y:99},
    {x:4, y:100}, {x:5, y:100}, {x:6, y:101}, {x:7, y:101}
];

const THOMPSON_PATTERN = [
    {x:0, y:0},
    {x:1, y:8}, {x:3, y:16}, {x:5, y:24}, {x:7, y:32}, {x:9, y:40},
    {x:11, y:48}, {x:12, y:56}, {x:13, y:64}, {x:14, y:72}, {x:14, y:80},
    {x:14, y:88}, {x:13, y:94}, {x:11, y:100}, {x:9, y:105}, {x:7, y:110},
    {x:6, y:114}, {x:5, y:118}, {x:5, y:122}, {x:6, y:126}
];

const CUSTOM_SMG_PATTERN = [
    {x:0, y:0},
    {x:-1, y:7}, {x:-2, y:14}, {x:-3, y:21}, {x:-4, y:28}, {x:-4, y:35}, // Starts Left Up
    {x:-3, y:42}, {x:-1, y:48}, {x:2, y:54}, {x:5, y:59}, {x:7, y:63}, // Swings Right
    {x:8, y:67}, {x:7, y:70}, {x:5, y:73}, {x:2, y:75}, {x:-1, y:77}, // Wobble
    {x:-3, y:79}, {x:-4, y:81}, {x:-3, y:83}, {x:0, y:85}, {x:3, y:87},
    {x:5, y:89}, {x:6, y:90}, {x:5, y:91}
];

const HMLMG_PATTERN = [
    {x:0, y:0},
    {x:0, y:10}, {x:1, y:20}, {x:2, y:30}, {x:3, y:40}, {x:4, y:50}, // Strong Vertical
    {x:5, y:60}, {x:5, y:68}, {x:4, y:76}, {x:2, y:83}, {x:0, y:90}, // Slight Curve Left
    {x:-2, y:95}, {x:-4, y:100}, {x:-5, y:105}, {x:-5, y:110}, {x:-4, y:115},
    {x:-2, y:120}, {x:0, y:124}, {x:2, y:128}, {x:4, y:132}, {x:5, y:135},
    {x:5, y:138}, {x:4, y:140}, {x:2, y:142}, {x:0, y:143}, {x:-2, y:144},
    {x:-4, y:145}, {x:-5, y:146}, {x:-5, y:147}, {x:-4, y:148} // Continues...
];

const SAR_PATTERN = [
    {x:0, y:0},
    {x:0, y:15}, {x:0, y:30}, {x:0, y:45}, {x:0, y:60}, 
    {x:0, y:75}, {x:0, y:90}, {x:0, y:105}, {x:0, y:120}, 
    {x:0, y:135}, {x:0, y:150}, {x:0, y:165}, {x:0, y:180}, 
    {x:0, y:195}, {x:0, y:210}, {x:0, y:225} // Pure Vertical Kick per shot (Reset visual)
];

const PYTHON_PATTERN = [
    {x:0, y:0},
    {x:0, y:25}, {x:0, y:50}, {x:0, y:75}, {x:0, y:100}, 
    {x:0, y:125}, {x:0, y:150} // Massive kick
];

const M39_PATTERN = [
    {x:0, y:0},
    {x:0, y:10}, {x:0, y:20}, {x:0, y:30}, {x:0, y:40}, 
    {x:0, y:50}, {x:0, y:60}, {x:0, y:70}, {x:0, y:80}, 
    {x:0, y:90}, {x:0, y:100}, {x:0, y:110}, {x:0, y:120}, 
    {x:0, y:130}, {x:0, y:140}, {x:0, y:150}, {x:0, y:160},
    {x:0, y:170}, {x:0, y:180}, {x:0, y:190}
];

const M249_PATTERN = [
    {x:0, y:0},
    {x:0, y:15}, {x:1, y:30}, {x:1, y:45}, {x:0, y:60}, {x:-1, y:75},
    {x:-2, y:90}, {x:-2, y:100}, {x:-1, y:110}, {x:1, y:118}, {x:3, y:125},
    {x:5, y:130}, {x:6, y:135}, {x:5, y:140}, {x:3, y:145}, {x:0, y:150},
    {x:-3, y:155}, {x:-5, y:160}, {x:-6, y:163}, {x:-5, y:165}, {x:-3, y:167},
    {x:0, y:168}, {x:3, y:169}, {x:5, y:170}, {x:6, y:171}, {x:5, y:172},
    {x:3, y:173}, {x:0, y:174}, {x:-3, y:175}, {x:-5, y:176} 
];

export const WEAPONS: RecoilPattern[] = [
    { 
        id: 'ak47', 
        name: 'Assault Rifle', 
        rpm: 450, 
        ammoCapacity: 30, 
        description: 'Hardest pattern. Pull down hard, then trace the S shape.',
        difficulty: 'Hard',
        pattern: AK47_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Frifle-ak.webp&w=414&q=90'
    },
    { 
        id: 'lr300', 
        name: 'LR-300', 
        rpm: 500, 
        ammoCapacity: 30, 
        description: 'Consistent vertical rise. Pull straight down.', 
        difficulty: 'Easy',
        pattern: LR300_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Frifle-lr300.webp&w=414&q=90'
    },
    { 
        id: 'mp5', 
        name: 'MP5A4', 
        rpm: 600, 
        ammoCapacity: 30, 
        description: 'Fast fire rate. Initial kick is the hardest part.',
        difficulty: 'Medium',
        pattern: MP5_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fsmg-mp5.webp&w=414&q=90'
    },
    { 
        id: 'thompson', 
        name: 'Thompson', 
        rpm: 460, 
        ammoCapacity: 20, 
        description: 'Drifts up and to the right consistently.', 
        difficulty: 'Medium',
        pattern: THOMPSON_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fsmg-thompson.webp&w=414&q=90'
    },
    { 
        id: 'custom_smg', 
        name: 'Custom SMG', 
        rpm: 600, 
        ammoCapacity: 24, 
        description: 'Fast but shaky. Pulls left early, then erratic.', 
        difficulty: 'Medium',
        pattern: CUSTOM_SMG_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fsmg-2.webp&w=414&q=90'
    },
    { 
        id: 'hmlmg', 
        name: 'HMLMG', 
        rpm: 500, 
        ammoCapacity: 60, 
        description: 'Craftable LMG. Like AK but heavier pull.', 
        difficulty: 'Hard',
        pattern: HMLMG_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fhmlmg.webp&w=414&q=90'
    },
    { 
        id: 'sar', 
        name: 'Semi Rifle', 
        rpm: 400, // Effective tapping RPM
        ammoCapacity: 16, 
        description: 'Pure vertical recoil. Pull down after every tap.', 
        difficulty: 'Easy',
        pattern: SAR_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Frifle-semiauto.webp&w=414&q=90'
    },
    { 
        id: 'm39', 
        name: 'M39 Rifle', 
        rpm: 300, 
        ammoCapacity: 20, 
        description: 'High accuracy, moderate vertical kick.', 
        difficulty: 'Medium',
        pattern: M39_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Frifle-m39.webp&w=414&q=90'
    },
    { 
        id: 'python', 
        name: 'Python', 
        rpm: 300, 
        ammoCapacity: 6, 
        description: 'Massive kick. Requires heavy pull down.', 
        difficulty: 'Hard',
        pattern: PYTHON_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpistol-python.webp&w=414&q=90'
    },
    { 
        id: 'm249', 
        name: 'M249', 
        rpm: 500, 
        ammoCapacity: 100, 
        description: 'Extreme vertical recoil. Crouch to control.', 
        difficulty: 'Extreme',
        pattern: M249_PATTERN,
        imageUrl: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Flmg-m249.webp&w=414&q=90'
    }
];
