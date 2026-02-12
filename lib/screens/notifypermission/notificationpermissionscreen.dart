import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/widgets/common/rust_button.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';

import 'package:raidalarm/core/utils/permission_helper.dart';

class NotificationPermissionScreen extends ConsumerStatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  ConsumerState<NotificationPermissionScreen> createState() => _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState extends ConsumerState<NotificationPermissionScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleAllow() async {
    HapticHelper.mediumImpact();
    await Permission.notification.request();
    if (!mounted) return;
    await AppDatabase().saveAppSetting('notify_permission_completed', 'true');
    
    if (!mounted) return;

    // Check if we came from dashboard
    final state = GoRouterState.of(context);
    final isFromDashboard = state.uri.queryParameters['from'] == 'dashboard';

    if (isFromDashboard) {
       // Check if Critical Alerts permission is also missing
      final criticalGranted = await PermissionHelper.checkCriticalAlertsPermission();
      if (!criticalGranted) {
        if (mounted) {
          context.pushReplacement('/critical-alert-permission?from=dashboard');
        }
        return;
      }
      
      // All done
      if (mounted) context.pop();
    } else {
      if (mounted) {
        context.go('/critical-alert-permission');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RustScreenLayout(
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0C0E),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              const Expanded(
                child: _VisualArea(),
              ),
              _ActionArea(onAllow: _handleAllow),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisualArea extends StatelessWidget {
  const _VisualArea();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Gradient from Top
        const _TopGradient(),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),
            // STATIC NOTIFICATION ICON
            const RepaintBoundary(
              child: _BellIcon(),
            ),
            SizedBox(height: 32.h),

            // ALERTS LIST
            const _AlertList(),
          ],
        ),
      ],
    );
  }
}

class _TopGradient extends StatelessWidget {
  const _TopGradient();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 128.h,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0C0C0E),
              const Color(0xFF0C0C0E).withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _BellIcon extends StatelessWidget {
  const _BellIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFDC2626).withValues(alpha: 0.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(220, 38, 38, 0.3),
            blurRadius: 30,
          ),
        ],
      ),
      child: Icon(
        LucideIcons.bell,
        color: Colors.white,
        size: 24.w,
      ),
    );
  }
}

class _AlertList extends StatelessWidget {
  const _AlertList();

  static const List<_AlertItemData> _mockAlerts = [
    _AlertItemData(
      id: 1,
      title: 'Raid Alert',
      message: 'Your base is under attack!',
      time: 'NOW',
      backgroundColor: Color(0x1AEF4444),
      borderColor: Color(0x4DEF4444),
    ),
    _AlertItemData(
      id: 2,
      title: 'Wipe Incoming',
      message: 'Server wiping in 15 minutes.',
      time: '15m',
      backgroundColor: Color(0x1AF97316),
      borderColor: Color(0x4DF97316),
    ),
    _AlertItemData(
      id: 3,
      title: 'Target Online',
      message: "Nemesis 'RoofCamper' is now online.",
      time: '2m',
      backgroundColor: Color(0x1A06B6D4),
      borderColor: Color(0x4D06B6D4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_mockAlerts.length, (idx) {
        return _AlertCard(
          idx: idx,
          alert: _mockAlerts[idx],
        );
      }),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final int idx;
  final _AlertItemData alert;

  const _AlertCard({
    required this.idx,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = 1.0 - (idx * 0.03);
    final double translateY = idx * 5.0.h;

    return Transform.translate(
      offset: Offset(0, translateY),
      child: Transform.scale(
        scale: scale,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: alert.backgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: alert.borderColor,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 25,
                offset: Offset(0, 20),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 8),
                spreadRadius: -6,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              alert.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            alert.time,
                            style: const TextStyle(
                              color: Color(0xFF52525B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        alert.message,
                        style: const TextStyle(
                          color: Color(0xFFA1A1AA),
                          fontSize: 13,
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
    );
  }
}

class _ActionArea extends StatelessWidget {
  final VoidCallback onAllow;

  const _ActionArea({required this.onAllow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'TOTAL AWARENESS',
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
                TextSpan(text: 'Enable notifications to receive critical alerts for '),
                TextSpan(
                  text: 'Raids',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ', '),
                TextSpan(
                  text: 'Wipes',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Targets',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),

          // Action Button
          RustButton.primary(
            onPressed: onAllow,
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('ALLOW 3 ALERTS'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertItemData {
  final int id;
  final String title;
  final String message;
  final String time;
  final Color backgroundColor;
  final Color borderColor;

  const _AlertItemData({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.backgroundColor,
    required this.borderColor,
  });
}
