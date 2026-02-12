
import { Zap, Battery, Lightbulb, Fan, Shield, Wifi, Heater, MousePointer2 } from 'lucide-react';

export type ElecCategory = 'Source' | 'Battery' | 'Consumer' | 'Control';

export interface ElecItem {
    id: string;
    name: string;
    category: ElecCategory;
    power: number; // For Source: Generation, For Consumer: Consumption
    icon: any;
    desc: string;
}

export const ELEC_ITEMS: ElecItem[] = [
    // SOURCES
    { id: 'solar', name: 'Solar Panel', category: 'Source', power: 20, icon: Zap, desc: 'Produces power during day only.' },
    { id: 'wind', name: 'Wind Turbine', category: 'Source', power: 100, icon: Fan, desc: 'Variable power based on height/wind.' },
    { id: 'small_gen', name: 'Small Generator', category: 'Source', power: 40, icon: Zap, desc: 'Consumes Low Grade Fuel.' },
    { id: 'test_gen', name: 'Test Generator', category: 'Source', power: 100, icon: Zap, desc: 'Creative/Admin power source.' },

    // BATTERIES (Power value represents Capacity in rWm minutes usually, but here we simplify logic)
    // Capacity in Rust is Watt Minutes. 
    // Small: 150 rWm, Max Output 10
    // Medium: 9,000 rWm, Max Output 50
    // Large: 24,000 rWm, Max Output 100
    { id: 'small_bat', name: 'Small Battery', category: 'Battery', power: 150, icon: Battery, desc: '15 mins max load capacity.' },
    { id: 'med_bat', name: 'Medium Battery', category: 'Battery', power: 9000, icon: Battery, desc: '3 hrs max load capacity.' },
    { id: 'large_bat', name: 'Large Battery', category: 'Battery', power: 24000, icon: Battery, desc: '4 hrs max load capacity.' },

    // CONSUMERS
    { id: 'turret', name: 'Auto Turret', category: 'Consumer', power: 10, icon: Shield, desc: 'Requires 10 power to function.' },
    { id: 'sam', name: 'SAM Site', category: 'Consumer', power: 25, icon: Shield, desc: 'Heavy power usage.' },
    { id: 'light', name: 'Ceiling Light', category: 'Consumer', power: 2, icon: Lightbulb, desc: 'Basic lighting.' },
    { id: 'heater', name: 'Electric Heater', category: 'Consumer', power: 3, icon: Heater, desc: 'Provides warmth.' },
    { id: 'sensor', name: 'HBHF Sensor', category: 'Consumer', power: 1, icon: Wifi, desc: 'Target detection.' },
    { id: 'door_controller', name: 'Door Controller', category: 'Consumer', power: 1, icon: MousePointer2, desc: 'Automated doors.' },
    { id: 'branch', name: 'Elec. Branch', category: 'Control', power: 1, icon: Zap, desc: 'Consumes 1 power itself.' },
    { id: 'splitter', name: 'Splitter', category: 'Control', power: 1, icon: Zap, desc: 'Consumes 1 power itself.' },
    { id: 'blocker', name: 'Blocker', category: 'Control', power: 1, icon: Zap, desc: 'Consumes 1 power itself.' },
    { id: 'switch', name: 'Smart Switch', category: 'Control', power: 1, icon: Wifi, desc: 'Remote control.' },
];
