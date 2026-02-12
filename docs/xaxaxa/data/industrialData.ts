
import { Zap, Flame, Box, Factory } from 'lucide-react';

export type MachineId = 'electric_furnace' | 'small_furnace' | 'large_furnace' | 'refinery';

export interface IndustrialMachine {
    id: MachineId;
    name: string;
    icon: any;
    powerPerUnit: number; // rWm
    woodPerHr: number; // Consumption
    outputPerHr: number; // Primary Output (Metal Frag equivalent rate)
    charcoalPerHr: number;
    slots: number; // Inventory slots for context
    description: string;
}

export const INDUSTRIAL_MACHINES: IndustrialMachine[] = [
    {
        id: 'electric_furnace',
        name: 'Electric Furnace',
        icon: Zap,
        powerPerUnit: 3,
        woodPerHr: 0,
        outputPerHr: 1200, // Approx 1 ore per 3s? Rustlabs says same speed as small furnace basically. Let's assume standard rate.
        charcoalPerHr: 0,
        slots: 2, // 1 in 1 out approx
        description: 'Requires power. No wood needed. Best for automation.'
    },
    {
        id: 'small_furnace',
        name: 'Small Furnace',
        icon: Flame,
        powerPerUnit: 0, // Machine itself needs 0, but system needs conveyors
        woodPerHr: 1000, // Burns ~1000 wood per hour
        outputPerHr: 1200, // Standard rate
        charcoalPerHr: 750, // Approx 0.75 per wood
        slots: 3,
        description: 'Classic. Produces charcoal. Requires fuel management.'
    },
    {
        id: 'large_furnace',
        name: 'Large Furnace',
        icon: Factory,
        powerPerUnit: 0,
        woodPerHr: 3000, // Burns faster? Or handles more capacity.
        outputPerHr: 5500, // Much higher throughput due to slots if managed well
        charcoalPerHr: 2250,
        slots: 18,
        description: 'High volume. Must be placed outside.'
    },
    {
        id: 'refinery',
        name: 'Oil Refinery',
        icon: Box, // Placeholder
        powerPerUnit: 0,
        woodPerHr: 1500, // Checks needed
        outputPerHr: 2000, // Low Grade
        charcoalPerHr: 1100,
        slots: 3,
        description: 'Refines Crude Oil into Low Grade Fuel.'
    }
];
