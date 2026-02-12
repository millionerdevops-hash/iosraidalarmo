import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/common/rust_button.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'package:raidalarm/core/utils/permission_helper.dart';

class CriticalAlertPermissionScreen extends ConsumerStatefulWidget {
  const CriticalAlertPermissionScreen({super.key});

  @override
  ConsumerState<CriticalAlertPermissionScreen> createState() => _CriticalAlertPermissionScreenState();
}

class _CriticalAlertPermissionScreenState extends ConsumerState<CriticalAlertPermissionScreen> {
  Future<void> _handleRequest() async {
    HapticHelper.mediumImpact();
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      await Permission.criticalAlerts.request();
    } 

    if (!mounted) return;
    await AppDatabase().saveAppSetting('critical_alert_permission_completed', 'true');
    
    if (!mounted) return;

    // Check if we came from dashboard
    final state = GoRouterState.of(context);
    final isFromDashboard = state.uri.queryParameters['from'] == 'dashboard';

    if (isFromDashboard) {
      // Check if Notification permission is also missing
      final notifyGranted = await PermissionHelper.checkNotificationPermission();
      if (!notifyGranted) {
        if (mounted) {
          context.pushReplacement('/notify-permission?from=dashboard');
        }
        return;
      }
      
      // All done or just this one was needed
      if (mounted) context.pop();
    } else {
      // Default flow (Onboarding)
       context.go('/social-proof'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return RustScreenLayout(
      child: Scaffold(
        backgroundColor: RustColors.background,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              const Expanded(
                child: SingleChildScrollView(
                  child: _MockupArea(),
                ),
              ),
              _ActionArea(onRequest: _handleRequest),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockupArea extends StatelessWidget {
  const _MockupArea();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 80.h),
        SizedBox(
          width: 250.w, 
          height: 380.h,
          child: const Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Phone Frame & Content
              RepaintBoundary(
                child: _PhoneFrame(),
              ),

              // Bypass Badge
              Positioned(
                bottom: -20, // Relative to stack height
                right: -24, 
                child: _BypassBadge(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 208.w,
      height: 380.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(48.r),
        border: Border.all(
          color: const Color(0xFF27272A),
          width: 8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          const _DynamicIsland(),
          const _DndIndicator(),
          const _AlarmContent(),
          Positioned(
            bottom: 32.h,
            left: 24.w,
            right: 24.w,
            child: const _VolumeBar(),
          ),
        ],
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12.h,
      left: 0, 
      right: 0,
      child: Center(
        child: Container(
          width: 80.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ),
      ),
    );
  }
}

class _DndIndicator extends StatelessWidget {
  const _DndIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 48.h,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFF27272A).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFF3F3F46).withValues(alpha: 0.5),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.moon,
                    size: 12.w,
                    color: const Color(0xFFF87171),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Do Not Disturb',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlarmContent extends StatelessWidget {
  const _AlarmContent();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(220, 38, 38, 0.5),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Icon(
              LucideIcons.bellRing,
              color: Colors.white,
              size: 32.w,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'RAID ALARM',
              style: RustTypography.rustStyle(
                fontSize: 14,
              ).copyWith(letterSpacing: 2.0.w),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xFF450A0A).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: const Color(0xFF7F1D1D).withValues(alpha: 0.5),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'CRITICAL ALERT',
                style: TextStyle(
                  color: const Color(0xFFEF4444),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeBar extends StatelessWidget {
  const _VolumeBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF27272A),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.volumeX,
            color: const Color(0xFFA1A1AA),
            size: 20.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: const Color(0xFF27272A),
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.r),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: const Color(0xFFDC2626), 
                          end: const Color(0xFFEF4444)
                        ),
                        duration: const Duration(seconds: 1),
                        builder: (_, color, __) {
                          return Container(color: color);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BypassBadge extends StatelessWidget {
  const _BypassBadge();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -5 * (math.pi / 180),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF0C0C0E),
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Color(0xFFDC2626),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.triangleAlert,
                color: Colors.white,
                size: 16.w,
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'SYSTEM',
                      style: TextStyle(
                        color: const Color(0xFF71717A),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'BYPASS',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionArea extends StatelessWidget {
  final VoidCallback onRequest;

  const _ActionArea({required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Override Silent Mode',
              style: RustTypography.rustStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 12.h),
          Text.rich(
            TextSpan(
              style: TextStyle(
                color: const Color(0xFFA1A1AA),
                fontSize: 14.sp,
                height: 1.5,
              ),
              children: const [
                TextSpan(text: 'Raid Alarm uses '),
                TextSpan(
                  text: 'Critical Alerts',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' to play loud sounds even if your iPhone is muted or Do Not Disturb is on.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),

          // Action Button
          RustButton.primary(
            onPressed: onRequest,
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Enable Critical Alerts'),
            ),
          ),
        ],
      ),
    );
  }
}
