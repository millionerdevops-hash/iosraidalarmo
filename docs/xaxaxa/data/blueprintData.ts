
export type BPTier = 'Tier 1' | 'Tier 2' | 'Tier 3';

export interface BlueprintItem {
    id: string;
    name: string;
    tier: BPTier;
    cost: number; // Research Table Cost
    category: 'Weapon' | 'Ammo' | 'Tool' | 'Construction' | 'Medical' | 'Electrical' | 'Traps' | 'Component' | 'Attire';
    image: string;
}

// Images sourced from reliable Rust CDN mirrors or placeholders
const CDN_BASE = "https://rustlabs.com/img/items180";

export const BLUEPRINTS: BlueprintItem[] = [
    // --- TIER 1 (WORKBENCH LEVEL 1) ---
    // Weapons
    { id: 'revolver', name: 'Revolver', tier: 'Tier 1', cost: 75, category: 'Weapon', image: `${CDN_BASE}/pistol.revolver.png` },
    { id: 'db', name: 'Double Barrel Shotgun', tier: 'Tier 1', cost: 125, category: 'Weapon', image: `${CDN_BASE}/shotgun.double.png` },
    { id: 'crossy', name: 'Crossbow', tier: 'Tier 1', cost: 75, category: 'Weapon', image: `${CDN_BASE}/crossbow.png` },
    { id: 'compound_bow', name: 'Compound Bow', tier: 'Tier 1', cost: 75, category: 'Weapon', image: `${CDN_BASE}/bow.compound.png` },
    { id: 'nailgun', name: 'Nailgun', tier: 'Tier 1', cost: 75, category: 'Weapon', image: `${CDN_BASE}/pistol.nailgun.png` },
    // Ammo
    { id: 'pistol_ammo', name: 'Pistol Ammo', tier: 'Tier 1', cost: 75, category: 'Ammo', image: `${CDN_BASE}/ammo.pistol.png` },
    { id: 'buckshot', name: '12 Gauge Buckshot', tier: 'Tier 1', cost: 75, category: 'Ammo', image: `${CDN_BASE}/ammo.shotgun.png` },
    // Tools / Boom
    { id: 'satchel', name: 'Satchel Charge', tier: 'Tier 1', cost: 125, category: 'Tool', image: `${CDN_BASE}/explosive.satchel.png` },
    { id: 'beancan', name: 'Beancan Grenade', tier: 'Tier 1', cost: 75, category: 'Tool', image: `${CDN_BASE}/grenade.beancan.png` },
    { id: 'molotov', name: 'Molotov Cocktail', tier: 'Tier 1', cost: 75, category: 'Tool', image: `${CDN_BASE}/grenade.molotov.png` },
    // Construction
    { id: 'double_metal_door', name: 'Double Sheet Door', tier: 'Tier 1', cost: 75, category: 'Construction', image: `${CDN_BASE}/door.double.hinged.metal.png` },
    { id: 'bed', name: 'Bed', tier: 'Tier 1', cost: 75, category: 'Construction', image: `${CDN_BASE}/bed.png` },
    { id: 'guntrap', name: 'Shotgun Trap', tier: 'Tier 1', cost: 125, category: 'Traps', image: `${CDN_BASE}/guntrap.png` },
    
    // --- TIER 2 (WORKBENCH LEVEL 2) ---
    // Weapons
    { id: 'sar', name: 'Semi-Automatic Rifle', tier: 'Tier 2', cost: 125, category: 'Weapon', image: `${CDN_BASE}/rifle.semiauto.png` },
    { id: 'tommy', name: 'Thompson', tier: 'Tier 2', cost: 125, category: 'Weapon', image: `${CDN_BASE}/smg.thompson.png` },
    { id: 'custom_smg', name: 'Custom SMG', tier: 'Tier 2', cost: 125, category: 'Weapon', image: `${CDN_BASE}/smg.2.png` },
    { id: 'python', name: 'Python Revolver', tier: 'Tier 2', cost: 125, category: 'Weapon', image: `${CDN_BASE}/pistol.python.png` },
    { id: 'sap', name: 'Semi-Automatic Pistol', tier: 'Tier 2', cost: 75, category: 'Weapon', image: `${CDN_BASE}/pistol.semiauto.png` },
    // Ammo
    { id: 'ammo_556', name: '5.56 Rifle Ammo', tier: 'Tier 2', cost: 125, category: 'Ammo', image: `${CDN_BASE}/ammo.rifle.png` },
    // Meds
    { id: 'med_syringe', name: 'Medical Syringe', tier: 'Tier 2', cost: 75, category: 'Medical', image: `${CDN_BASE}/syringe.medical.png` },
    { id: 'large_medkit', name: 'Large Medkit', tier: 'Tier 2', cost: 75, category: 'Medical', image: `${CDN_BASE}/large.medkit.png` },
    // Construction
    { id: 'garage_door', name: 'Garage Door', tier: 'Tier 2', cost: 75, category: 'Construction', image: `${CDN_BASE}/wall.frame.garagedoor.png` },
    { id: 'ladder_hatch', name: 'Ladder Hatch', tier: 'Tier 2', cost: 125, category: 'Construction', image: `${CDN_BASE}/floor.ladder.hatch.png` },
    { id: 'high_wall_stone', name: 'High Ext Stone Wall', tier: 'Tier 2', cost: 125, category: 'Construction', image: `${CDN_BASE}/wall.external.high.stone.png` },
    { id: 'high_gate_stone', name: 'High Ext Stone Gate', tier: 'Tier 2', cost: 125, category: 'Construction', image: `${CDN_BASE}/gates.external.high.stone.png` },
    { id: 'furnace_large', name: 'Large Furnace', tier: 'Tier 2', cost: 125, category: 'Construction', image: `${CDN_BASE}/furnace.large.png` },
    { id: 'refinery', name: 'Small Oil Refinery', tier: 'Tier 2', cost: 125, category: 'Construction', image: `${CDN_BASE}/small.oil.refinery.png` },
    // Tools
    { id: 'jackhammer', name: 'Jackhammer', tier: 'Tier 2', cost: 125, category: 'Tool', image: `${CDN_BASE}/jackhammer.png` },
    { id: 'chainsaw', name: 'Chainsaw', tier: 'Tier 2', cost: 125, category: 'Tool', image: `${CDN_BASE}/chainsaw.png` },
    // Attire
    { id: 'roadsign_jacket', name: 'Roadsign Jacket', tier: 'Tier 2', cost: 75, category: 'Attire', image: `${CDN_BASE}/roadsign.jacket.png` },
    { id: 'roadsign_kilt', name: 'Roadsign Kilt', tier: 'Tier 2', cost: 75, category: 'Attire', image: `${CDN_BASE}/roadsign.kilt.png` },
    // Elec / Traps (Note: Turret and Windmill are 500 scrap to research even though they are WB2)
    { id: 'auto_turret', name: 'Auto Turret', tier: 'Tier 2', cost: 500, category: 'Traps', image: `${CDN_BASE}/autoturret.png` },
    { id: 'wind_turbine', name: 'Wind Turbine', tier: 'Tier 2', cost: 500, category: 'Electrical', image: `${CDN_BASE}/generator.wind.scrap.png` },
    { id: 'solar_panel', name: 'Large Solar Panel', tier: 'Tier 2', cost: 75, category: 'Electrical', image: `${CDN_BASE}/solar.panel.large.png` },
    { id: 'battery_medium', name: 'Medium Battery', tier: 'Tier 2', cost: 75, category: 'Electrical', image: `${CDN_BASE}/battery.medium.png` },
    { id: 'battery_large', name: 'Large Battery', tier: 'Tier 2', cost: 75, category: 'Electrical', image: `${CDN_BASE}/battery.large.png` },

    // --- TIER 3 (WORKBENCH LEVEL 3) ---
    // Weapons
    { id: 'ak47', name: 'Assault Rifle', tier: 'Tier 3', cost: 500, category: 'Weapon', image: `${CDN_BASE}/rifle.ak.png` },
    { id: 'bolt', name: 'Bolt Action Rifle', tier: 'Tier 3', cost: 500, category: 'Weapon', image: `${CDN_BASE}/rifle.bolt.png` },
    { id: 'mp5', name: 'MP5A4', tier: 'Tier 3', cost: 500, category: 'Weapon', image: `${CDN_BASE}/smg.mp5.png` },
    { id: 'launcher', name: 'Rocket Launcher', tier: 'Tier 3', cost: 500, category: 'Weapon', image: `${CDN_BASE}/rocket.launcher.png` },
    // Boom
    { id: 'c4', name: 'Timed Explosive', tier: 'Tier 3', cost: 500, category: 'Tool', image: `${CDN_BASE}/explosive.timed.png` },
    { id: 'rocket', name: 'Rocket', tier: 'Tier 3', cost: 500, category: 'Ammo', image: `${CDN_BASE}/ammo.rocket.basic.png` },
    { id: 'hv_rocket', name: 'HV Rocket', tier: 'Tier 3', cost: 500, category: 'Ammo', image: `${CDN_BASE}/ammo.rocket.hv.png` },
    { id: 'incen_rocket', name: 'Incendiary Rocket', tier: 'Tier 3', cost: 500, category: 'Ammo', image: `${CDN_BASE}/ammo.rocket.fire.png` },
    { id: 'explo_ammo', name: 'Explosive 5.56', tier: 'Tier 3', cost: 500, category: 'Ammo', image: `${CDN_BASE}/ammo.rifle.explosive.png` },
    // Armor
    { id: 'facemask', name: 'Metal Facemask', tier: 'Tier 3', cost: 500, category: 'Attire', image: `${CDN_BASE}/metal.facemask.png` },
    { id: 'chestplate', name: 'Metal Chestplate', tier: 'Tier 3', cost: 500, category: 'Attire', image: `${CDN_BASE}/metal.plate.torso.png` },
    // Construction
    { id: 'armored_door', name: 'Armored Door', tier: 'Tier 3', cost: 500, category: 'Construction', image: `${CDN_BASE}/door.double.hinged.toptier.png` },
    { id: 'armored_double', name: 'Armored Double Door', tier: 'Tier 3', cost: 500, category: 'Construction', image: `${CDN_BASE}/door.double.hinged.toptier.png` },
    // Components
    { id: 'scope_8x', name: '8x Zoom Scope', tier: 'Tier 3', cost: 125, category: 'Component', image: `${CDN_BASE}/weapon.mod.8x.scope.png` },
    { id: 'laser', name: 'Weapon Lasersight', tier: 'Tier 3', cost: 75, category: 'Component', image: `${CDN_BASE}/weapon.mod.lasersight.png` }
];
