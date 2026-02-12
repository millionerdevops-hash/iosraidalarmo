
import { 
    Sun, 
    Hammer, 
    Heart, 
    Axe, 
    Home, 
    Map as MapIcon,
    Recycle,
    Settings,
    Disc,
    Box,
    Layers,
    Scissors,
    Zap,
    Anchor,
    Gauge
} from 'lucide-react';

export interface GuideSection {
    id: string;
    title: string;
    icon: any;
    content: string;
    items?: { name: string; image: string }[];
    tip?: string;
}

export interface Guide {
    id: string;
    title: string;
    subtitle: string;
    heroImage: string;
    sections: GuideSection[];
}

// Images
const RUSTLABS_BASE = "https://rustlabs.com/img/items180";

export const GETTING_STARTED_GUIDE: Guide = {
    id: 'getting_started',
    title: 'Getting Started',
    subtitle: 'From Naked to Base Owner',
    heroImage: 'https://files.facepunch.com/paddy/20210204/Feb_Update_Header.jpg',
    sections: [
        {
            id: 'waking_up',
            title: 'Waking Up',
            icon: Sun,
            content: "You wake up on a beach, completely naked. Rust is brutal and unforgiving. There is no tutorial. You have a Rock and a Torch. Your rock is your first tool and weapon.",
            items: [
                { name: 'Rock', image: `${RUSTLABS_BASE}/rock.png` },
                { name: 'Torch', image: `${RUSTLABS_BASE}/torch.png` }
            ],
            tip: "Do not light your torch at night unless absolutely necessary. It makes you a visible target from miles away."
        },
        {
            id: 'vitals',
            title: 'Vitals Management',
            icon: Heart,
            content: "Keep an eye on the bottom right. Health (Green), Calories (Orange), and Hydration (Blue). If calories drop to 0, you starve. If hydration drops, you can't sprint.",
            items: [
                { name: 'Bandage', image: `${RUSTLABS_BASE}/bandage.png` },
                { name: 'Pumpkin', image: `${RUSTLABS_BASE}/pumpkin.png` }
            ],
            tip: "Eat food to heal. Bandages stop bleeding immediately."
        },
        {
            id: 'gathering',
            title: 'Equipment & Gathering',
            icon: Axe,
            content: "Hit trees with your rock to get Wood. Hit stones (nodes) to get Stone. Look for hemp plants to get Cloth. You need these 3 basics to craft your first tools.",
            items: [
                { name: 'Wood', image: `${RUSTLABS_BASE}/wood.png` },
                { name: 'Stone', image: `${RUSTLABS_BASE}/stones.png` },
                { name: 'Hemp', image: `${RUSTLABS_BASE}/seed.hemp.png` } // Hemp seed icon as proxy for plant
            ]
        },
        {
            id: 'crafting',
            title: 'First Tools',
            icon: Hammer,
            content: "Once you have resources, craft a Stone Hatchet and Stone Pickaxe. They gather much faster than your rock. Also craft a Wooden Spear for defense.",
            items: [
                { name: 'Stone Hatchet', image: `${RUSTLABS_BASE}/hatchet.png` },
                { name: 'Stone Pickaxe', image: `${RUSTLABS_BASE}/pickaxe.png` },
                { name: 'Wooden Spear', image: `${RUSTLABS_BASE}/spear.wooden.png` }
            ]
        },
        {
            id: 'building',
            title: 'Building Your Base',
            icon: Home,
            content: "Craft a Building Plan and a Hammer. Use the Plan to place foundations (Twig). Use the Hammer (with wood in inventory) to upgrade them to Wood or Stone. Don't forget a Tool Cupboard!",
            items: [
                { name: 'Building Plan', image: `${RUSTLABS_BASE}/building.planner.png` },
                { name: 'Hammer', image: `${RUSTLABS_BASE}/hammer.png` },
                { name: 'Tool Cupboard', image: `${RUSTLABS_BASE}/cupboard.tool.png` },
                { name: 'Key Lock', image: `${RUSTLABS_BASE}/lock.key.png` }
            ],
            tip: "Always build an 'Airlock' (two doors) so enemies can't rush in when you open your front door."
        },
        {
            id: 'sleeping',
            title: 'Spawn Point',
            icon: MapIcon,
            content: "Craft a Sleeping Bag (30 Cloth) and place it down immediately. This allows you to respawn at your base if you die.",
            items: [
                { name: 'Sleeping Bag', image: `${RUSTLABS_BASE}/sleepingbag.png` }
            ]
        }
    ]
};

export const COMPONENT_GUIDE: Guide = {
    id: 'component_guide',
    title: 'Component Guide',
    subtitle: 'Items, Scrap & Recycling',
    heroImage: 'https://files.facepunch.com/paddy/20161101/devblog134_header.jpg',
    sections: [
        {
            id: 'scrap',
            title: 'Scrap',
            icon: Recycle,
            content: "Scrap is the currency of the component system. It is used to research new items, craft components at a workbench, or gamble at Bandit Camp. You can obtain it by recycling components.",
            items: [
                { name: 'Scrap', image: `${RUSTLABS_BASE}/scrap.png` }
            ],
            tip: "Barrels drop 2 scrap. Crates drop 5+. Recycling is the fastest way to get rich."
        },
        {
            id: 'mechanical',
            title: 'Mechanical Parts',
            icon: Settings,
            content: "Gears, Springs, and Pipes are essential. Gears are used for garage doors and armored doors. Springs are vital for crafting guns. Pipes are used for rockets and launchers.",
            items: [
                { name: 'Gears', image: `${RUSTLABS_BASE}/gears.png` },
                { name: 'Metal Spring', image: `${RUSTLABS_BASE}/metalspring.png` },
                { name: 'Metal Pipe', image: `${RUSTLABS_BASE}/metalpipe.png` }
            ],
            tip: "Don't recycle Gears early game! You need them for garage doors."
        },
        {
            id: 'blades_signs',
            title: 'Blades & Signs',
            icon: Disc,
            content: "Metal Blades and Road Signs are common but valuable. Road Signs recycle into High Quality Metal (HQM). Blades are used for melee tools and salvaged tools.",
            items: [
                { name: 'Metal Blade', image: `${RUSTLABS_BASE}/metalblade.png` },
                { name: 'Road Sign', image: `${RUSTLABS_BASE}/roadsigns.png` }
            ]
        },
        {
            id: 'fabrics',
            title: 'Fabrics & Rope',
            icon: Anchor,
            content: "Rope, Sewing Kits, and Tarps. These are your main source of Cloth. Sewing Kits and Rope are also used to craft armor sets.",
            items: [
                { name: 'Rope', image: `${RUSTLABS_BASE}/rope.png` },
                { name: 'Sewing Kit', image: `${RUSTLABS_BASE}/sewingkit.png` },
                { name: 'Tarp', image: `${RUSTLABS_BASE}/tarp.png` }
            ],
            tip: "Recycling a Tarp gives 50 Cloth. It's the best source of cloth if you don't have a hemp farm."
        },
        {
            id: 'bodies',
            title: 'Weapon Bodies',
            icon: Layers,
            content: "You cannot craft guns without their specific bodies. These are found in crates. Semi Bodies are common, Rifle and SMG bodies are rarer.",
            items: [
                { name: 'Semi Body', image: `${RUSTLABS_BASE}/semibody.png` },
                { name: 'SMG Body', image: `${RUSTLABS_BASE}/smgbody.png` },
                { name: 'Rifle Body', image: `${RUSTLABS_BASE}/riflebody.png` }
            ],
            tip: "Rifle Bodies recycle into 2 HQM and 25 Scrap. Only recycle if you have too many."
        },
        {
            id: 'tech',
            title: 'Advanced Tech',
            icon: Zap,
            content: "Tech Trash, CCTV Cameras, and Targeting Computers. These are high-tier components used for C4, Auto Turrets, and Holosights.",
            items: [
                { name: 'Tech Trash', image: `${RUSTLABS_BASE}/techparts.png` },
                { name: 'CCTV Camera', image: `${RUSTLABS_BASE}/cctv.camera.png` },
                { name: 'Computer', image: `${RUSTLABS_BASE}/targeting.computer.png` }
            ],
            tip: "Tech Trash is the most scrap-dense item to recycle (20 Scrap each)."
        },
        {
            id: 'recycler',
            title: 'The Recycler',
            icon: Recycle,
            content: "Found at most monuments (Gas Station, Supermarket, Lighthouse, etc.). Inputs items and outputs raw resources. Safezone recyclers (Outpost/Bandit) yield 20% less resources but are safe.",
            items: [
                { name: 'Recycler', image: 'https://rustlabs.com/img/items180/recycler_static.png' }
            ]
        }
    ]
};

export const GUIDES: Guide[] = [GETTING_STARTED_GUIDE, COMPONENT_GUIDE];
