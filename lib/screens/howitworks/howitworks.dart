import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/common/rust_button.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';

import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/throttler.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui';

class HowItWorksScreen extends ConsumerStatefulWidget {
  const HowItWorksScreen({
    super.key,
  });

  @override
  ConsumerState<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends ConsumerState<HowItWorksScreen> {
  final Throttler _throttler = Throttler(delay: const Duration(milliseconds: 1000));
  
  // Demo Mode State: Toggle between ALARM and CALL
  String _demoMode = 'ALARM'; // 'ALARM' or 'CALL'
  
  // Animation State Loop
  // IDLE: Phone clean
  // NOTIFIED: Notification appears
  // ACTIVE: Alarm/Call screen takes over
  final ValueNotifier<String> _animState = ValueNotifier('IDLE'); // 'IDLE', 'NOTIFIED', 'ACTIVE'
  
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();

    _isMounted = true;
    _runSequence();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  // Animation Loop Logic
  Future<void> _runSequence() async {
    if (!_isMounted) return;

    // 0. Start Hidden (IDLE) - Allows animation to reset
    _animState.value = 'IDLE';
    await Future.delayed(const Duration(milliseconds: 800));
    if (!_isMounted) return;

    // 1. Show Notification (Slide Down)
    _animState.value = 'NOTIFIED';
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!_isMounted) return;

    // 2. Trigger Alarm/Call (ACTIVE) -> Notification Hides
    _animState.value = 'ACTIVE';
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!_isMounted) return;

    // Loop
    _runSequence();
  }

  void _handleContinue() async {
    // Mark as completed
    await AppDatabase().saveAppSetting('howitworks_completed', 'true');
    
    if (!mounted) return;
    
    // If coming from settings, go back
    final fromSettings = GoRouterState.of(context).uri.queryParameters['fromSettings'] == 'true';
    if (fromSettings) {
      if (context.canPop()) {
        context.pop();
        return;
      }
    }

    // Default flow: Go to NotificationPermission
    context.pushReplacement('/notify-permission');
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = ScreenUtilHelper.isSmallDevice;
    return Scaffold(
      backgroundColor: const Color(0xFF09090B), // zinc-950
      body: RustScreenLayout(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, isSmall ? 16.h : 48.h, 24.w, isSmall ? 16.h : 24.h),
                child: Column(
                  children: [
                    // Main Title
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        tr('how_it_works.title'),
                        style: RustTypography.rustStyle(
                          fontSize: isSmall ? 18.sp : 22.sp,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ScreenUtilHelper.sizedBoxHeight(4),
                    
                    // Description
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        tr('how_it_works.description'),
                        style: TextStyle(
                          fontSize: isSmall ? 12.sp : 14.sp,
                          color: const Color(0xFFA1A1AA),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ScreenUtilHelper.sizedBoxHeight(8),

                    // Secondary Punchline
                    Text(
                        tr('how_it_works.subtitle'),
                        style: RustTypography.rustStyle(
                          fontSize: isSmall ? 14.sp : 16.sp,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

                // Toggle
                Container(
                  margin: ScreenUtilHelper.paddingHorizontal(24),
                  padding: ScreenUtilHelper.paddingAll(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF18181B), // bg-zinc-900
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF27272A)),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      return Stack(
                        children: [
                          // Moving Background
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: _demoMode == 'ALARM' ? 0 : width / 2,
                            top: 0,
                            bottom: 0,
                            width: width / 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF3F3F46), // bg-zinc-700
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              // ALARM MODE Button
                              Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      _throttler.run(() => setState(() => _demoMode = 'ALARM'));
                                    },
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.notifications_active,
                                          size: 16.w,
                                          color: _demoMode == 'ALARM' ? Colors.white : const Color(0xFF71717A),
                                        ),
                                        ScreenUtilHelper.sizedBoxWidth(8),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              tr('how_it_works.mode_alarm'),
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.bold,
                                                color: _demoMode == 'ALARM' ? Colors.white : const Color(0xFF71717A),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // FAKE CALL Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _throttler.run(() => setState(() => _demoMode = 'CALL'));
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone_android,
                                          size: 16.w,
                                          color: _demoMode == 'CALL' ? Colors.white : const Color(0xFF71717A),
                                        ),
                                        ScreenUtilHelper.sizedBoxWidth(8),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              tr('how_it_works.mode_call'),
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.bold,
                                                color: _demoMode == 'CALL' ? Colors.white : const Color(0xFF71717A),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

                ScreenUtilHelper.sizedBoxHeight(isSmall ? 16 : 32),

                // Dynamic Preview Container
                Expanded(
                  child: Center(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _animState,
                      builder: (context, animState, child) {
                        return RepaintBoundary(
                          child: _PhoneShell(
                          borderColor: (animState == 'ACTIVE' && _demoMode == 'ALARM')
                              ? const Color(0xFF7F1D1D) // border-red-900
                              : const Color(0xFF18181B), // border-zinc-900
                          child: Stack(
                            children: [
                              // Layer 1: Base State (Wallpaper + Notification)
                              const _LockScreenContent(),

                              // Notification (hides when Alarm/Call becomes ACTIVE)
                              _InternalNotification(
                                visible: animState == 'NOTIFIED',
                                title: tr('how_it_works.demo.notification_title'),
                                message: tr('how_it_works.demo.notification_message'),
                              ),

                              // Layer 2: ACTIVE STATE - ALARM OVERLAY
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: (_demoMode == 'ALARM' && animState == 'ACTIVE') ? 1.0 : 0.0,
                                child: Transform.translate(
                                  offset: (_demoMode == 'ALARM' && animState == 'ACTIVE')
                                      ? Offset.zero
                                      : Offset(0, 500.h),
                                  child: Container(
                                    color: const Color(0xFF450A0A), // bg-[#450a0a]
                                    child: Stack(
                                      children: [
                                        // Radial gradient background
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: RadialGradient(
                                                radius: 0.7,
                                                colors: [
                                                  const Color(0xFFDC2626).withOpacity(0.5),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Content
                                        Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.notifications_active,
                                                size: 56.w,
                                                color: Colors.white,
                                              ),
                                              ScreenUtilHelper.sizedBoxHeight(16),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  tr('how_it_works.demo.raid_alarm_title'),
                                                  textAlign: TextAlign.center,
                                                  style: RustTypography.rustStyle(
                                                    fontSize: 24.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              ScreenUtilHelper.sizedBoxHeight(16),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    tr('how_it_works.demo.activated'),
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      letterSpacing: 2.w,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Layer 3: ACTIVE STATE - CALL OVERLAY
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: (_demoMode == 'CALL' && animState == 'ACTIVE') ? 1.0 : 0.0,
                                child: Transform.translate(
                                  offset: (_demoMode == 'CALL' && animState == 'ACTIVE')
                                      ? Offset.zero
                                      : Offset(0, 500.h),
                                  child: Container(
                                    color: Colors.black,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Top: Caller Info
                                        Padding(
                                          padding: EdgeInsets.only(top: 56.h),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 64.w,
                                                height: 64.w,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF18181B),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  'assets/logo/raidalarm-logo2.png',
                                                  fit: BoxFit.contain,
                                                  cacheWidth: 160,
                                                ),
                                              ),
                                              ScreenUtilHelper.sizedBoxHeight(16),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  tr('how_it_works.demo.incoming_call_name'),
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    letterSpacing: 0.5.w,
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  tr('how_it_works.demo.calling_status'),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: const Color(0xFF71717A),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Bottom: Call Buttons
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 32.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              // Decline Button
                                              Container(
                                                width: 50.w,
                                                height: 50.w,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFDC2626),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Transform.rotate(
                                                  angle: 2.356, // 135 degrees
                                                  child: Icon(
                                                    Icons.phone,
                                                    size: 24.w,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),

                                              // Accept Button
                                              Container(
                                                width: 50.w,
                                                height: 50.w,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF22C55E),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.phone,
                                                  size: 24.w,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        );
                      },
                    ),
                  ),
                ),

                // Button
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, isSmall ? 16.h : 32.h),
                  child: Column(
                    children: [
                      RustButton(
                        onPressed: () {
                          HapticHelper.lightImpact();
                          _throttler.run(() {

                            _handleContinue();
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(tr('how_it_works.button_continue')),
                            ),
                            ScreenUtilHelper.sizedBoxWidth(8),
                            Icon(Icons.arrow_forward, size: 16.w),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

// Phone Shell Component
class _PhoneShell extends StatelessWidget {
  final Widget child;
  final Color borderColor;

  const _PhoneShell({
    required this.child,
    this.borderColor = const Color(0xFF18181B),
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = ScreenUtilHelper.isSmallDevice;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isSmall ? 220.w : 288.w, // reduced width for small devices
      height: isSmall ? 340.h : 460.h, // reduced height for small devices
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(isSmall ? 32.r : 48.r), // rounded-[3rem]
        border: Border.all(color: borderColor, width: isSmall ? 6.w : 8.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 40.r,
            spreadRadius: 5.r,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isSmall ? 28.r : 40.r),
        child: Stack(
          children: [
            child,
            // Dynamic Island / Notch
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: isSmall ? 100.w : 128.w, // w-32
                  height: isSmall ? 22.h : 28.h, // h-7
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Internal Notification - Positioned below the clock for Lock Screen visibility
class _InternalNotification extends StatelessWidget {
  final bool visible;
  final String title;
  final String message;
  final String time;

  const _InternalNotification({
    required this.visible,
    required this.title,
    required this.message,
    this.time = 'now',
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = ScreenUtilHelper.isSmallDevice;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      top: visible ? (isSmall ? 120.h : 180.h) : (isSmall ? 100.h : 160.h),
      left: 12.w,
      right: 12.w,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: visible ? 1.0 : 0.0,
        child: Transform.scale(
          scale: visible ? 1.0 : 0.95,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F3F46).withOpacity(0.9), // zinc-800/90
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFF52525B).withOpacity(0.5), // zinc-600/50
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20.r,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCE422B),
                                borderRadius: BorderRadius.circular(6.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFCE422B).withOpacity(0.3),
                                    blurRadius: 4.r,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.inbox,
                                size: 12.w,
                                color: Colors.white,
                              ),
                            ),
                            ScreenUtilHelper.sizedBoxWidth(8),
                            Text(
                              tr('how_it_works.demo.rust_plus'),
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 0.5.w,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          time == 'now' ? tr('how_it_works.demo.time_now') : time,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    ScreenUtilHelper.sizedBoxHeight(8), 

                    // Body
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                    ScreenUtilHelper.sizedBoxHeight(2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFFE4E4E7), // zinc-200
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Wallpaper & Clock (Shared background)
class _LockScreenContent extends StatelessWidget {
  const _LockScreenContent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base black background
        Container(color: Colors.black),

        // Radial gradient
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 0.8,
              colors: [
                const Color(0xFF27272A).withOpacity(0.8),
                Colors.black,
              ],
              stops: const [0.0, 0.7],
            ),
          ),
        ),

        // Lock Screen Time
        Positioned(
          top: 64.h,
          left: 0,
          right: 0,
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '19:23',
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFFF4F4F5), // zinc-100
                    height: 1.0,
                    letterSpacing: -2.w,
                  ),
                ),
              ),
              ScreenUtilHelper.sizedBoxHeight(8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tr('how_it_works.demo.lock_screen_date'),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFA1A1AA), // zinc-400
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
