import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/constants/app_constants.dart';

class ScreenUtilHelper {
  ScreenUtilHelper._();

  static const Size designSize = Size(375, 812);
  static const bool minTextAdapt = true;
  static const bool splitScreenMode = false;
  

    
  static double get spacing1 => AppConstants.spacing1.w;
  static double get spacing2 => AppConstants.spacing2.w;
  static double get spacing3 => AppConstants.spacing3.w;
  static double get spacing4 => AppConstants.spacing4.w;
  static double get spacing5 => AppConstants.spacing5.w;
  static double get spacing6 => AppConstants.spacing6.w;
  static double get spacing8 => AppConstants.spacing8.w;

  static double get pagePadding => AppConstants.pagePadding.w;
  static double get cardMarginHorizontal => AppConstants.cardMarginHorizontal.w;
  static double get cardMarginVertical => AppConstants.cardMarginVertical.w;
  static double get cardPadding => AppConstants.cardPadding.w;
  static double get sectionSpacing => AppConstants.sectionSpacing.w;

  static double get headlineLarge => 32.0.sp;
  static double get headlineMedium => 28.0.sp;
  static double get headlineSmall => 24.0.sp;
  
  static double get titleLarge => 22.0.sp;
  static double get titleMedium => 18.0.sp;
  static double get titleSmall => 16.0.sp;
  
  static double get bodyLarge => 16.0.sp;
  static double get bodyMedium => 14.0.sp;
  static double get bodySmall => 12.0.sp;
  
  static double get labelLarge => 14.0.sp;
  static double get labelMedium => 12.0.sp;
  static double get labelSmall => 11.0.sp;
    
  static double get iconSizeSmall => AppConstants.iconSizeSmall.w;
  static double get iconSizeStandard => AppConstants.iconSizeStandard.w;
  static double get iconSizeMedium => AppConstants.iconSizeMedium.w;
  static double get iconSizeLarge => AppConstants.iconSizeLarge.w;
  static double get iconSizeXLarge => AppConstants.iconSizeXLarge.w;
  
  static double get radiusSmall => AppConstants.radiusSmall.r;
  static double get radiusMedium => AppConstants.radiusMedium.r;
  static double get radiusLarge => AppConstants.radiusLarge.r;
  static double get radiusCard => AppConstants.radiusCard.r;

  static double get elevationNone => AppConstants.elevationNone;
  static double get elevationLow => AppConstants.elevationLow;
  static double get elevationMedium => AppConstants.elevationMedium;
  static double get elevationHigh => AppConstants.elevationHigh;
  static double get elevationXHigh => AppConstants.elevationXHigh;

  
  static double get buttonHeightSmall => 36.0.h;
  static double get buttonHeightStandard => 48.0.h;
  static double get buttonHeightLarge => 56.0.h;

  static double get appBarHeight => 56.0.h;

  static double get cardMinHeight => 80.0.h;

  static EdgeInsets paddingAll(double value) => EdgeInsets.all(value.w);
  static EdgeInsets paddingHorizontal(double value) => EdgeInsets.symmetric(horizontal: value.w);
  static EdgeInsets paddingVertical(double value) => EdgeInsets.symmetric(vertical: value.h);
  static EdgeInsets paddingSymmetric({required double horizontal, required double vertical}) =>
      EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h);
  
  static SizedBox sizedBoxWidth(double value) => SizedBox(width: value.w);
  static SizedBox sizedBoxHeight(double value) => SizedBox(height: value.h);
  static SizedBox sizedBox({double? width, double? height}) =>
      SizedBox(width: width?.w, height: height?.h);
}

