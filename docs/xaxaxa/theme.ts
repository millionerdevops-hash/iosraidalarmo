// RAID ALARM Design System & Color Palette

export const PALETTE = {
  // Core Colors
  background: '#0c0c0e', // Main app background (Darker, slightly warm black)
  surface: '#09090b',    // Card/Container background (zinc-950)
  
  // Brand Colors
  primary: '#dc2626',    // Rust Red (red-600) - Main Action / Danger
  primaryDark: '#7f1d1d', // Deep Red (red-900) - Backgrounds/Gradients
  
  // Secondary / Functional
  accent: '#f97316',     // Safety Orange (orange-500) - Highlights/Warning
  success: '#22c55e',    // Green (green-500) - Safe/Connected
  
  // Typography
  textPrimary: '#ffffff', // White
  textSecondary: '#a1a1aa', // Zinc-400
  textMuted: '#52525b',     // Zinc-600
};

export const TYPOGRAPHY = {
  // Common Tailwind class strings for consistent font usage
  rustFont: "font-black uppercase tracking-tighter font-inter",
  monoFont: "font-mono tracking-wide",
};

export const EFFECTS = {
  // Common effect classes
  glowRed: "shadow-[0_0_20px_rgba(220,38,38,0.3)]",
  glowOrange: "shadow-[0_0_20px_rgba(249,115,22,0.2)]",
  glassPanel: "bg-black/40 backdrop-blur-md border border-white/10",
};
