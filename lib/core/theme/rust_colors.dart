import 'package:flutter/material.dart';

/// RAID ALARM Design System & Color Palette
/// React Native temasından Flutter'a taşınmıştır
class RustColors {
  RustColors._();

  // Core Colors
  static const Color background = Color(0xFF0C0C0E);  // #0c0c0e - Main app background (Darker, slightly warm black)
  static const Color surface = Color(0xFF09090B);     // #09090b - Card/Container background (zinc-950)
  
  // Brand Colors
  static const Color primary = Color(0xFFDC2626);     // #dc2626 (red-600) - Main Action / Danger
  static const Color primaryDark = Color(0xFF7F1D1D); // #7f1d1d (red-900) - Backgrounds/Gradients
  
  // Secondary / Functional
  static const Color accent = Color(0xFFF97316);      // #f97316 (orange-500) - Highlights/Warning
  static const Color success = Color(0xFF22C55E);     // #22c55e (green-500) - Safe/Connected
  
  // Typography
  static const Color textPrimary = Color(0xFFFFFFFF);   // #ffffff - White
  static const Color textSecondary = Color(0xFFA1A1AA); // #a1a1aa (zinc-400)
  static const Color textMuted = Color(0xFF52525B);     // #52525b (zinc-600)
  
  // UI Elements (derived colors)
  static const Color divider = Color(0xFF27272A);       // zinc-800
  static const Color cardBackground = Color(0xFF18181B); // zinc-900
  
  // Status Colors
  static const Color error = Color(0xFFDC2626);         // red-600 (primary ile aynı)
  static const Color warning = Color(0xFFEAB308);       // #eab308 (yellow-500)
  static const Color info = Color(0xFF3B82F6);          // #3b82f6 (blue-500)
}
