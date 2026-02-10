import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/core/constants/app_constants.dart';

/// RAID ALARM App Theme
/// React Native temasından Flutter'a taşınmıştır
class AppTheme {
  AppTheme._();

  // ThemeData - Dark theme only
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: RustColors.primary,
      primaryContainer: RustColors.primaryDark,
      secondary: RustColors.accent,
      secondaryContainer: RustColors.accent,
      surface: RustColors.surface,
      surfaceContainerHighest: RustColors.cardBackground,
      onSurface: RustColors.textPrimary,
      onSurfaceVariant: RustColors.textSecondary,
      error: RustColors.error,
      onError: RustColors.textPrimary,
      outline: RustColors.divider,
    ),

    // Scaffold
    scaffoldBackgroundColor: RustColors.background,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: RustColors.background,
      foregroundColor: RustColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: RustTypography.titleLarge,
      centerTitle: false,
      iconTheme: const IconThemeData(
        color: RustColors.textPrimary,
        size: AppConstants.iconSizeStandard,
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: RustColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.cardMarginHorizontal,
        vertical: AppConstants.cardMarginVertical,
      ),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: RustColors.divider.withOpacity(0.5),
      thickness: 1,
      space: 1,
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: RustColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing4,
        vertical: AppConstants.spacing3,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: const BorderSide(color: RustColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: const BorderSide(color: RustColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: const BorderSide(color: RustColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        borderSide: const BorderSide(color: RustColors.error),
      ),
      labelStyle: RustTypography.bodyMedium,
      hintStyle: RustTypography.bodyMedium.copyWith(
        color: RustColors.textMuted,
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: RustColors.primary,
        foregroundColor: RustColors.textPrimary,
        elevation: 0,
        disabledBackgroundColor: RustColors.textMuted,
        disabledForegroundColor: RustColors.textSecondary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing6,
          vertical: AppConstants.spacing3,
        ),
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        textStyle: RustTypography.labelLarge,
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: RustColors.primary,
        disabledForegroundColor: RustColors.textMuted,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing4,
          vertical: AppConstants.spacing2,
        ),
        minimumSize: const Size(64, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        textStyle: RustTypography.labelLarge,
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: RustColors.textPrimary,
        side: const BorderSide(color: RustColors.primary),
        disabledForegroundColor: RustColors.textMuted,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing6,
          vertical: AppConstants.spacing3,
        ),
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        textStyle: RustTypography.labelLarge,
      ),
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return RustColors.primary;
        }
        return RustColors.textMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return RustColors.primary.withOpacity(0.5);
        }
        return RustColors.divider;
      }),
    ),

    // Slider
    sliderTheme: SliderThemeData(
      activeTrackColor: RustColors.primary,
      inactiveTrackColor: RustColors.divider,
      thumbColor: RustColors.primary,
      overlayColor: RustColors.primary.withOpacity(0.2),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return RustColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(RustColors.textPrimary),
      side: const BorderSide(color: RustColors.divider, width: 2),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return RustColors.primary;
        }
        return RustColors.divider;
      }),
    ),

    // Typography
    textTheme: TextTheme(
      displayLarge: RustTypography.displayLarge,
      displayMedium: RustTypography.displayMedium,
      displaySmall: RustTypography.displaySmall,
      headlineLarge: RustTypography.headlineLarge,
      headlineMedium: RustTypography.headlineMedium,
      headlineSmall: RustTypography.headlineSmall,
      titleLarge: RustTypography.titleLarge,
      titleMedium: RustTypography.titleMedium,
      titleSmall: RustTypography.titleSmall,
      bodyLarge: RustTypography.bodyLarge,
      bodyMedium: RustTypography.bodyMedium,
      bodySmall: RustTypography.bodySmall,
      labelLarge: RustTypography.labelLarge,
      labelMedium: RustTypography.labelMedium,
      labelSmall: RustTypography.labelSmall,
    ).apply(
      fontFamily: RustTypography.fontFamily,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: RustColors.textPrimary,
      size: AppConstants.iconSizeStandard,
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: RustColors.surface,
      selectedItemColor: RustColors.primary,
      unselectedItemColor: RustColors.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: RustColors.primary,
      foregroundColor: RustColors.textPrimary,
      elevation: 4,
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: RustColors.cardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      titleTextStyle: RustTypography.titleLarge,
      contentTextStyle: RustTypography.bodyMedium,
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: RustColors.cardBackground,
      contentTextStyle: RustTypography.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Progress Indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: RustColors.primary,
      linearTrackColor: RustColors.divider,
      circularTrackColor: RustColors.divider,
    ),

    // List Tile
    listTileTheme: const ListTileThemeData(
      textColor: RustColors.textPrimary,
      iconColor: RustColors.textPrimary,
      tileColor: RustColors.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacing4,
        vertical: AppConstants.spacing2,
      ),
    ),
  );
}
