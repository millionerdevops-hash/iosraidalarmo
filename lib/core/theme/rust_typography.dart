import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';

/// RAID ALARM Typography System
/// React Native temasından Flutter'a taşınmıştır
class RustTypography {
  RustTypography._();

  // Font Families
  static const String fontFamily = 'Inter';           // Primary font (rustFont equivalent)
  static const String monoFontFamily = 'RobotoMono';  // Monospace font

  // Rust-style text (uppercase, bold, tight tracking)
  // React Native: "font-black uppercase tracking-tighter font-inter"
  static TextStyle rustStyle({
    required double fontSize,
    FontWeight weight = FontWeight.w900, // font-black
    Color? color,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize.sp,
        fontWeight: weight,
        letterSpacing: letterSpacing ?? -0.5, // tracking-tighter
        color: color ?? RustColors.textPrimary,
        height: 1.2,
      );

  // Mono font style
  // React Native: "font-mono tracking-wide"
  static TextStyle monoStyle({
    required double fontSize,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: monoFontFamily,
        fontSize: fontSize.sp,
        fontWeight: weight,
        letterSpacing: letterSpacing ?? 1.0, // tracking-wide
        color: color ?? RustColors.textPrimary,
        height: 1.4,
      );

  // Display Styles (Large headings)
  static final TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57.sp,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: -0.25,
    color: RustColors.textPrimary,
  );

  static final TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45.sp,
    fontWeight: FontWeight.w700,
    height: 1.16,
    letterSpacing: 0,
    color: RustColors.textPrimary,
  );

  static final TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
    height: 1.22,
    letterSpacing: 0,
    color: RustColors.textPrimary,
  );

  // Headline Styles
  static final TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: RustColors.textPrimary,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: 0,
    color: RustColors.textPrimary,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
    color: RustColors.textPrimary,
  );

  // Title Styles
  static final TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.27,
    letterSpacing: 0,
    color: RustColors.textPrimary,
  );

  static final TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
    color: RustColors.textPrimary,
  );

  static final TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
    color: RustColors.textPrimary,
  );

  // Body Styles
  static final TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
    color: RustColors.textPrimary,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    color: RustColors.textSecondary,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: RustColors.textSecondary,
  );

  // Label Styles
  static final TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: RustColors.textPrimary,
  );

  static final TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
    color: RustColors.textSecondary,
  );

  static final TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
    color: RustColors.textSecondary,
  );
}
