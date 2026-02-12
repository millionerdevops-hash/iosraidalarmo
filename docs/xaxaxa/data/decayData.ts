
export type DecayCategory = 'Structure' | 'Deployable' | 'Vehicle' | 'Despawn' | 'Trap';

export interface DecayItem {
    id: string;
    name: string;
    category: DecayCategory;
    time: string; // Display string (e.g. "8 Hours")
    seconds: number; // For sorting
    image: string;
    notes?: string;
}

const BASE_URL = 'https://rustlabs.com/img/items180';

export const DECAY_DATA: DecayItem[] = [
    // --- STRUCTURES (TC Boşken Çürüme Süresi) ---
    { id: 'twig', name: 'Twig Structure', category: 'Structure', time: '1 Hour', seconds: 3600, image: `${BASE_URL}/building.planner.png`, notes: 'TC yetkisi olmadan çürüme süresi.' },
    { id: 'wood_struct', name: 'Wood Structure', category: 'Structure', time: '3 Hours', seconds: 10800, image: `${BASE_URL}/wall.external.high.wood.png`, notes: 'Tüm ahşap yapılar için.' },
    { id: 'stone_struct', name: 'Stone Structure', category: 'Structure', time: '5 Hours', seconds: 18000, image: `${BASE_URL}/wall.external.high.stone.png`, notes: 'Tüm taş yapılar için.' },
    { id: 'metal_struct', name: 'Sheet Metal Structure', category: 'Structure', time: '8 Hours', seconds: 28800, image: `${BASE_URL}/metal.wall.png`, notes: 'Sac metal yapılar.' },
    { id: 'hqm_struct', name: 'Armored Structure', category: 'Structure', time: '12 Hours', seconds: 43200, image: `${BASE_URL}/metal.wall.png`, notes: 'Yüksek kaliteli metal.' },
    
    // --- DOORS ---
    { id: 'wood_door', name: 'Wood Door', category: 'Deployable', time: '3 Hours', seconds: 10800, image: `${BASE_URL}/door.double.hinged.wood.png` },
    { id: 'metal_door', name: 'Sheet Metal Door', category: 'Deployable', time: '8 Hours', seconds: 28800, image: `${BASE_URL}/door.hinged.metal.png` },
    { id: 'garage_door', name: 'Garage Door', category: 'Deployable', time: '8 Hours', seconds: 28800, image: `${BASE_URL}/wall.frame.garagedoor.png` },
    { id: 'armored_door', name: 'Armored Door', category: 'Deployable', time: '12 Hours', seconds: 43200, image: `${BASE_URL}/door.hinged.toptier.png` },
    { id: 'ladder_hatch', name: 'Ladder Hatch', category: 'Deployable', time: '8 Hours', seconds: 28800, image: `${BASE_URL}/floor.ladder.hatch.png` },

    // --- DEPLOYABLES (Dışarıda Bırakılırsa) ---
    { id: 'sleeping_bag', name: 'Sleeping Bag', category: 'Deployable', time: '4 Days', seconds: 345600, image: `${BASE_URL}/sleepingbag.png` },
    { id: 'bed', name: 'Bed', category: 'Deployable', time: '4 Days', seconds: 345600, image: `${BASE_URL}/bed.png` },
    { id: 'tc', name: 'Tool Cupboard', category: 'Deployable', time: '2 Days', seconds: 172800, image: `${BASE_URL}/cupboard.tool.png` },
    { id: 'large_box', name: 'Large Wood Box', category: 'Deployable', time: '4 Days', seconds: 345600, image: `${BASE_URL}/box.wooden.large.png` },
    { id: 'small_box', name: 'Wood Storage Box', category: 'Deployable', time: '2 Days', seconds: 172800, image: `${BASE_URL}/box.wooden.png` },
    { id: 'furnace', name: 'Furnace', category: 'Deployable', time: '2 Days', seconds: 172800, image: `${BASE_URL}/furnace.png` },
    { id: 'large_furnace', name: 'Large Furnace', category: 'Deployable', time: '4 Days', seconds: 345600, image: `${BASE_URL}/furnace.large.png` },
    { id: 'wb1', name: 'Workbench Lvl 1', category: 'Deployable', time: '4 Days', seconds: 345600, image: `${BASE_URL}/workbench1.png` },
    { id: 'wb2', name: 'Workbench Lvl 2', category: 'Deployable', time: '4 Days', seconds: 345600, image: `${BASE_URL}/workbench2.png` },
    { id: 'wb3', name: 'Workbench Lvl 3', category: 'Deployable', time: '4 Days', seconds: 345600, image: `${BASE_URL}/workbench3.png` },

    // --- VEHICLES (Çatısı kapalı değilse) ---
    { id: 'minicopter', name: 'Minicopter', category: 'Vehicle', time: '8 Hours', seconds: 28800, image: `${BASE_URL}/minicopter.png`, notes: 'İçeride: 48 Saat. Dışarıda: 8 Saat.' },
    { id: 'scrap_heli', name: 'Scrap Heli', category: 'Vehicle', time: '8 Hours', seconds: 28800, image: `${BASE_URL}/scraptransporthelicopter.png`, notes: 'İçeride: 48 Saat.' },
    { id: 'rowboat', name: 'Rowboat', category: 'Vehicle', time: '3 Hours', seconds: 10800, image: `${BASE_URL}/rowboat.png`, notes: 'Kıyıda: 3 Saat. Açıkta: 2 Saat.' },
    { id: 'rhib', name: 'RHIB', category: 'Vehicle', time: '4 Hours', seconds: 14400, image: `${BASE_URL}/rhib.png` },
    { id: 'horse', name: 'Horse', category: 'Vehicle', time: '3 Hours', seconds: 10800, image: `${BASE_URL}/saddle.png`, notes: 'Yemliksiz 3 saatte ölür.' },
    { id: 'submarine', name: 'Submarine', category: 'Vehicle', time: '4 Hours', seconds: 14400, image: `${BASE_URL}/submarineduo.png` },
    { id: 'balloon', name: 'Hot Air Balloon', category: 'Vehicle', time: '3 Hours', seconds: 10800, image: 'https://rustlabs.com/img/items180/hotairballoon.png' },

    // --- DESPAWN (Yere Atılan Eşyalar) ---
    { id: 'body', name: 'Player Body', category: 'Despawn', time: '5-60 Mins', seconds: 3600, image: `${BASE_URL}/skull.human.png`, notes: 'Loot miktarına göre değişir.' },
    { id: 'bag', name: 'Loot Bag (Dropped)', category: 'Despawn', time: '5-60 Mins', seconds: 3600, image: `${BASE_URL}/supply.signal.png`, notes: 'İçeriğin değerine göre artar.' },
    { id: 'gun_t3', name: 'Tier 3 Weapons', category: 'Despawn', time: '60 Mins', seconds: 3600, image: `${BASE_URL}/rifle.ak.png`, notes: 'AK, Bolt, L96, M249 vb.' },
    { id: 'explosives', name: 'Explosives / C4', category: 'Despawn', time: '60 Mins', seconds: 3600, image: `${BASE_URL}/explosive.timed.png`, notes: 'C4, Roketler.' },
    { id: 'gun_t2', name: 'Tier 2 Weapons', category: 'Despawn', time: '60 Mins', seconds: 3600, image: `${BASE_URL}/smg.thompson.png` },
    { id: 'ammo', name: 'Ammo / Meds', category: 'Despawn', time: '20 Mins', seconds: 1200, image: `${BASE_URL}/ammo.rifle.png` },
    { id: 'resources', name: 'Resources (Stone/Wood)', category: 'Despawn', time: '60 Mins', seconds: 3600, image: `${BASE_URL}/stones.png` },
    { id: 'clothes', name: 'Clothing / Armor', category: 'Despawn', time: '20 Mins', seconds: 1200, image: `${BASE_URL}/metal.plate.torso.png` },
    { id: 'trash', name: 'Junk Items', category: 'Despawn', time: '5 Mins', seconds: 300, image: `${BASE_URL}/seed.hemp.png`, notes: 'Tohumlar, değersiz eşyalar.' },

    // --- TRAPS ---
    { id: 'turret', name: 'Auto Turret', category: 'Trap', time: '12 Hours', seconds: 43200, image: `${BASE_URL}/autoturret.png`, notes: 'TC dışında' },
    { id: 'sam', name: 'SAM Site', category: 'Trap', time: '12 Hours', seconds: 43200, image: `${BASE_URL}/samsite.png` },
    { id: 'shotgun_trap', name: 'Shotgun Trap', category: 'Trap', time: '2 Days', seconds: 172800, image: `${BASE_URL}/guntrap.png` },
    { id: 'flame_turret', name: 'Flame Turret', category: 'Trap', time: '2 Days', seconds: 172800, image: `${BASE_URL}/flameturret.png` },
    { id: 'landmine', name: 'Landmine', category: 'Trap', time: '2 Days', seconds: 172800, image: `${BASE_URL}/trap.landmine.png` },
    { id: 'bear_trap', name: 'Snap Trap', category: 'Trap', time: '2 Days', seconds: 172800, image: `${BASE_URL}/trap.bear.png` },
    { id: 'high_wall', name: 'High Ext Wall', category: 'Trap', time: '8 Hours', seconds: 28800, image: `${BASE_URL}/wall.external.high.stone.png`, notes: 'TC dışında hızlı çürür.' },
];
