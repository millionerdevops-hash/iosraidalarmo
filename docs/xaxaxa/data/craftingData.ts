

export type CraftCategory = 'Weapon' | 'Attire' | 'Meds' | 'Build' | 'Tool' | 'Ammo' | 'Elec';

export interface CraftableItem {
    id: string;
    name: string;
    category: CraftCategory;
    image: string;
    workbench?: 1 | 2 | 3;
    recipe: {
        wood?: number;
        stone?: number;
        metal?: number;
        hqm?: number;
        cloth?: number;
        leather?: number;
        fuel?: number;
        sulfur?: number;
        gunpowder?: number;
        fat?: number;
        bone?: number;
        // Components
        rope?: number;
        sewing?: number;
        gears?: number;
        spring?: number;
        blade?: number;
        pipe?: number;
        body_rifle?: number;
        body_smg?: number;
        body_semi?: number;
        roadsign?: number;
        tarp?: number;
        tech_trash?: number;
        explosives?: number;
    };
}

export const CRAFTABLES: CraftableItem[] = [
    // --- WEAPONS ---
    { id: 'ak47', name: 'Assault Rifle', category: 'Weapon', workbench: 3, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Frifle-ak.webp&w=414&q=90', recipe: { wood: 50, hqm: 50, body_rifle: 1, spring: 4 } },
    { id: 'bolt', name: 'Bolt Action', category: 'Weapon', workbench: 3, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Frifle-bolt.webp&w=414&q=90', recipe: { hqm: 20, body_rifle: 1, pipe: 3, spring: 2 } },
    { id: 'mp5', name: 'MP5A4', category: 'Weapon', workbench: 3, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fsmg-mp5.webp&w=414&q=90', recipe: { hqm: 15, body_smg: 1, spring: 2 } },
    { id: 'tommy', name: 'Thompson', category: 'Weapon', workbench: 2, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fsmg-thompson.webp&w=414&q=90', recipe: { wood: 100, hqm: 10, body_smg: 1, spring: 1 } },
    { id: 'sar', name: 'Semi Rifle', category: 'Weapon', workbench: 2, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Frifle-semiauto.webp&w=414&q=90', recipe: { metal: 450, hqm: 4, body_semi: 1, spring: 1 } },
    { id: 'python', name: 'Python', category: 'Weapon', workbench: 2, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpistol-python.webp&w=414&q=90', recipe: { metal: 100, hqm: 3, pipe: 3, spring: 1 } },
    { id: 'revo', name: 'Revolver', category: 'Weapon', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpistol-revolver.webp&w=414&q=90', recipe: { pipe: 1, cloth: 25, metal: 125 } },
    { id: 'db', name: 'Double Barrel', category: 'Weapon', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fshotgun-double.webp&w=414&q=90', recipe: { metal: 175, pipe: 2 } },

    // --- ATTIRE ---
    { id: 'facemask', name: 'Metal Facemask', category: 'Attire', workbench: 3, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fmetal-facemask.webp&w=414&q=90', recipe: { hqm: 15, leather: 50, sewing: 6 } },
    { id: 'chestplate', name: 'Metal Chestplate', category: 'Attire', workbench: 3, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fmetal-plate-torso.webp&w=414&q=90', recipe: { hqm: 25, leather: 50, sewing: 8 } },
    { id: 'roadsign_jacket', name: 'Roadsign Jacket', category: 'Attire', workbench: 2, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Froadsign-jacket.webp&w=414&q=90', recipe: { leather: 40, roadsign: 3, sewing: 3 } },
    { id: 'roadsign_kilt', name: 'Roadsign Kilt', category: 'Attire', workbench: 2, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Froadsign-kilt.webp&w=414&q=90', recipe: { leather: 20, roadsign: 2, sewing: 2 } },
    { id: 'hoodie', name: 'Hoodie', category: 'Attire', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fhoodie.webp&w=414&q=90', recipe: { cloth: 80, sewing: 1 } },
    { id: 'pants', name: 'Pants', category: 'Attire', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpants.webp&w=414&q=90', recipe: { cloth: 80, sewing: 1 } },
    { id: 'hazmat', name: 'Hazmat Suit', category: 'Attire', workbench: 2, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fhazmatsuit.webp&w=414&q=90', recipe: { tarp: 5, sewing: 2, hqm: 8 } },

    // --- MEDS ---
    { id: 'syringe', name: 'Med Syringe', category: 'Meds', workbench: 2, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fsyringe-medical.webp&w=414&q=90', recipe: { cloth: 15, metal: 10, fuel: 10 } },
    { id: 'bandage', name: 'Bandage', category: 'Meds', image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fbandage.webp&w=414&q=90', recipe: { cloth: 4 } },
    { id: 'medkit', name: 'Large Medkit', category: 'Meds', workbench: 2, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Flarge-medkit.webp&w=414&q=90', recipe: { cloth: 50, fuel: 10 } }, // Simplified logic (needs syringe usually)

    // --- AMMO ---
    { id: 'ammo_556', name: '5.56 Ammo', category: 'Ammo', workbench: 2, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fammo-rifle.webp&w=414&q=90', recipe: { metal: 10, gunpowder: 5 } }, // Batch of 2
    { id: 'ammo_pistol', name: 'Pistol Ammo', category: 'Ammo', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fammo-pistol.webp&w=414&q=90', recipe: { metal: 5, gunpowder: 5 } }, // Batch of 3
    { id: 'ammo_shotgun', name: '12 Gauge', category: 'Ammo', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fammo-shotgun.webp&w=414&q=90', recipe: { metal: 5, gunpowder: 10 } }, // Batch of 2

    // --- BUILD ---
    { id: 'sheet_door', name: 'Sheet Door', category: 'Build', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fdoor-double-hinged-metal.webp&w=414&q=90', recipe: { metal: 150 } },
    { id: 'garage_door', name: 'Garage Door', category: 'Build', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fwall-frame-garagedoor.webp&w=414&q=90', recipe: { metal: 300, gears: 2 } },
    { id: 'armored_door', name: 'Armored Door', category: 'Build', workbench: 3, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fdoor-double-hinged-toptier.webp&w=414&q=90', recipe: { hqm: 20, gears: 5 } },
    { id: 'ladder_hatch', name: 'Ladder Hatch', category: 'Build', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Ffloor-ladder-hatch.webp&w=414&q=90', recipe: { wood: 300, metal: 300, gears: 3 } },
    { id: 'large_box', name: 'Large Box', category: 'Build', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fbox-wooden-large.webp&w=414&q=90', recipe: { wood: 250, metal: 30 } },
    { id: 'tc', name: 'Tool Cupboard', category: 'Build', image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fcupboard-tool.webp&w=414&q=90', recipe: { wood: 1000 } },

    // --- TOOLS & EXPLOSIVES ---
    { id: 'hatchet', name: 'Metal Hatchet', category: 'Tool', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fhatchet.webp&w=414&q=90', recipe: { wood: 100, metal: 75 } },
    { id: 'pickaxe', name: 'Metal Pickaxe', category: 'Tool', workbench: 1, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fpickaxe.webp&w=414&q=90', recipe: { wood: 100, metal: 125 } },
    { id: 'jackhammer', name: 'Jackhammer', category: 'Tool', image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fjackhammer.webp&w=414&q=90', recipe: { } }, // Cannot craft, useful for list?
    { id: 'c4', name: 'Timed Charge', category: 'Tool', workbench: 3, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fexplosive-timed.webp&w=414&q=90', recipe: { gunpowder: 2000, metal: 200, fuel: 60, sulfur: 200, tech_trash: 2, cloth: 5 } }, // Simplified explosive recipe
    { id: 'rocket', name: 'Rocket', category: 'Tool', workbench: 3, image: 'https://rusthelp.com/_next/image?url=https%3A%2F%2Fcdn.rusthelp.com%2Fimages%2F256%2Fammo-rocket-basic.webp&w=414&q=90', recipe: { gunpowder: 150, explosives: 10, pipe: 2 } },
];