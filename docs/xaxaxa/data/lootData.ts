
export interface LootItem {
    name: string;
    image: string;
    chance: number; // 0-100 percentage
    min: number;
    max: number;
    scrapValue: number; // Approx recycling value
    isRare?: boolean; // For visual effect
}

export interface CrateType {
    id: string;
    name: string;
    image: string;
    description: string;
    maxSlots: number;
    lootTable: LootItem[];
}

const I = {
    ak: 'https://rustlabs.com/img/items180/rifle.ak.png',
    bolt: 'https://rustlabs.com/img/items180/rifle.bolt.png',
    mp5: 'https://rustlabs.com/img/items180/smg.mp5.png',
    c4: 'https://rustlabs.com/img/items180/explosive.timed.png',
    rocket: 'https://rustlabs.com/img/items180/ammo.rocket.basic.png',
    launcher: 'https://rustlabs.com/img/items180/rocket.launcher.png',
    metal_chest: 'https://rustlabs.com/img/items180/metal.plate.torso.png',
    metal_mask: 'https://rustlabs.com/img/items180/metal.facemask.png',
    scrap: 'https://rustlabs.com/img/items180/scrap.png',
    hqm: 'https://rustlabs.com/img/items180/metal.refined.png',
    tech_trash: 'https://rustlabs.com/img/items180/tech.trash.png',
    camera: 'https://rustlabs.com/img/items180/cctv.camera.png',
    computer: 'https://rustlabs.com/img/items180/targeting.computer.png',
    smg_body: 'https://rustlabs.com/img/items180/smgbody.png',
    rifle_body: 'https://rustlabs.com/img/items180/riflebody.png',
    semi_body: 'https://rustlabs.com/img/items180/semibody.png',
    fuse: 'https://rustlabs.com/img/items180/fuse.png',
    pipes: 'https://rustlabs.com/img/items180/metal.pipe.png',
    spring: 'https://rustlabs.com/img/items180/metalspring.png',
    tarp: 'https://rustlabs.com/img/items180/tarp.png',
    armored_door: 'https://rustlabs.com/img/items180/door.hinged.toptier.png',
    l96: 'https://rustlabs.com/img/items180/rifle.l96.png',
    m249: 'https://rustlabs.com/img/items180/lmg.m249.png',
    m39: 'https://rustlabs.com/img/items180/rifle.m39.png',
    hv_rocket: 'https://rustlabs.com/img/items180/ammo.rocket.hv.png',
    incen_rocket: 'https://rustlabs.com/img/items180/ammo.rocket.fire.png'
};

// Simplified Loot Tables based on RustLabs
export const CRATES: CrateType[] = [
    {
        id: 'elite',
        name: 'Elite Crate',
        image: 'https://rustlabs.com/img/items180/crate_elite.png',
        description: 'Found at Launch Site, Mil Tunnels, Oil Rigs.',
        maxSlots: 6,
        lootTable: [
            { name: 'Assault Rifle', image: I.ak, chance: 3, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'Bolt Action', image: I.bolt, chance: 3, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'Metal Chest Plate', image: I.metal_chest, chance: 4, min: 1, max: 1, scrapValue: 125, isRare: true },
            { name: 'Metal Facemask', image: I.metal_mask, chance: 4, min: 1, max: 1, scrapValue: 125, isRare: true },
            { name: 'Rocket Launcher', image: I.launcher, chance: 2, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'Timed Explosive', image: I.c4, chance: 1, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'Rocket', image: I.rocket, chance: 2, min: 1, max: 2, scrapValue: 200, isRare: true },
            { name: 'Rifle Body', image: I.rifle_body, chance: 15, min: 1, max: 2, scrapValue: 25 },
            { name: 'SMG Body', image: I.smg_body, chance: 15, min: 1, max: 2, scrapValue: 15 },
            { name: 'Tech Trash', image: I.tech_trash, chance: 25, min: 1, max: 4, scrapValue: 20 },
            { name: 'CCTV Camera', image: I.camera, chance: 20, min: 1, max: 2, scrapValue: 50 },
            { name: 'Targeting Computer', image: I.computer, chance: 20, min: 1, max: 2, scrapValue: 50 },
            { name: 'High Quality Metal', image: I.hqm, chance: 30, min: 10, max: 30, scrapValue: 2 },
            { name: 'Scrap', image: I.scrap, chance: 90, min: 10, max: 50, scrapValue: 1 },
            { name: 'Armored Door', image: I.armored_door, chance: 1, min: 1, max: 1, scrapValue: 500, isRare: true }
        ]
    },
    {
        id: 'bradley',
        name: 'Bradley Crate',
        image: 'https://rustlabs.com/img/items180/crate_bradley.png',
        description: 'Dropped by APC. Highest tier loot.',
        maxSlots: 6, // Actually it drops 3-4 crates, each has slots. We sim 1 crate.
        lootTable: [
            { name: 'M249', image: I.m249, chance: 8, min: 1, max: 1, scrapValue: 1000, isRare: true },
            { name: 'L96 Rifle', image: I.l96, chance: 10, min: 1, max: 1, scrapValue: 700, isRare: true },
            { name: 'M39 Rifle', image: I.m39, chance: 10, min: 1, max: 1, scrapValue: 400, isRare: true },
            { name: 'Assault Rifle', image: I.ak, chance: 10, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'Timed Explosive', image: I.c4, chance: 15, min: 1, max: 2, scrapValue: 500, isRare: true },
            { name: 'Rocket', image: I.rocket, chance: 20, min: 2, max: 4, scrapValue: 200, isRare: true },
            { name: 'HV Rocket', image: I.hv_rocket, chance: 20, min: 2, max: 4, scrapValue: 75 },
            { name: 'Incendiary Rocket', image: I.incen_rocket, chance: 20, min: 2, max: 4, scrapValue: 100 },
            { name: 'Armored Door', image: I.armored_door, chance: 5, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'High Quality Metal', image: I.hqm, chance: 50, min: 50, max: 100, scrapValue: 2 },
            { name: 'Tech Trash', image: I.tech_trash, chance: 40, min: 3, max: 6, scrapValue: 20 }
        ]
    },
    {
        id: 'heli',
        name: 'Heli Crate',
        image: 'https://rustlabs.com/img/items180/heli_crate.png',
        description: 'Patrol Helicopter loot.',
        maxSlots: 6,
        lootTable: [
            { name: 'M249', image: I.m249, chance: 8, min: 1, max: 1, scrapValue: 1000, isRare: true },
            { name: 'L96 Rifle', image: I.l96, chance: 10, min: 1, max: 1, scrapValue: 700, isRare: true },
            { name: 'Rocket Launcher', image: I.launcher, chance: 15, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'Timed Explosive', image: I.c4, chance: 20, min: 1, max: 2, scrapValue: 500, isRare: true },
            { name: 'Rocket', image: I.rocket, chance: 25, min: 2, max: 3, scrapValue: 200, isRare: true },
            { name: 'Metal Facemask', image: I.metal_mask, chance: 20, min: 1, max: 1, scrapValue: 125 },
            { name: 'Metal Chest Plate', image: I.metal_chest, chance: 20, min: 1, max: 1, scrapValue: 125 },
            { name: 'CCTV Camera', image: I.camera, chance: 40, min: 1, max: 2, scrapValue: 50 },
            { name: 'Targeting Computer', image: I.computer, chance: 40, min: 1, max: 2, scrapValue: 50 }
        ]
    },
    {
        id: 'locked',
        name: 'Locked Crate',
        image: 'https://rustlabs.com/img/items180/codelockedhackablecrate.png',
        description: 'Oil Rig and Chinooks. Requires 15m hack.',
        maxSlots: 12, // High slot count
        lootTable: [
            { name: 'Assault Rifle', image: I.ak, chance: 5, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'Bolt Action', image: I.bolt, chance: 5, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'MP5A4', image: I.mp5, chance: 10, min: 1, max: 1, scrapValue: 300, isRare: true },
            { name: 'Metal Facemask', image: I.metal_mask, chance: 8, min: 1, max: 1, scrapValue: 125 },
            { name: 'Metal Chest Plate', image: I.metal_chest, chance: 8, min: 1, max: 1, scrapValue: 125 },
            { name: 'Timed Explosive', image: I.c4, chance: 2, min: 1, max: 1, scrapValue: 500, isRare: true },
            { name: 'Scrap', image: I.scrap, chance: 100, min: 50, max: 200, scrapValue: 1 },
            { name: 'High Quality Metal', image: I.hqm, chance: 50, min: 20, max: 50, scrapValue: 2 },
            { name: 'Tech Trash', image: I.tech_trash, chance: 40, min: 2, max: 5, scrapValue: 20 },
            { name: 'Targeting Computer', image: I.computer, chance: 35, min: 1, max: 2, scrapValue: 50 },
            { name: 'CCTV Camera', image: I.camera, chance: 35, min: 1, max: 2, scrapValue: 50 }
        ]
    }
];
