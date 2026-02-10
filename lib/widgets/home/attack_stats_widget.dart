import 'dart:async';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/data/models/notification_data.dart';
import 'package:raidalarm/data/repositories/notification_repository.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AttackStatsWidget - Saldırı istatistiklerini gösterir
/// Optimized with cached constants and efficient widget tree
class AttackStatsWidget extends ConsumerStatefulWidget {
  final int totalAttacks;
  final DateTime? lastAttackTime;

  const AttackStatsWidget({
    super.key,
    required this.totalAttacks,
    this.lastAttackTime,
  });

  @override
  ConsumerState<AttackStatsWidget> createState() => _AttackStatsWidgetState();
}

class _AttackStatsWidgetState extends ConsumerState<AttackStatsWidget> {
  // Performance: Cached static constants
  static const _bgColor = Color(0xFF121214);
  static const _borderColor = Color(0xFF27272A);
  static const _redBgColor = Color(0xFF7F1D1D);
  static const _darkBgColor = Color(0xFF18181B);

  // Repository via Riverpod
  NotificationRepository get _notificationRepo => ref.read(notificationRepoProvider);
  List<NotificationData> _recentNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentNotifications();
  }

  @override
  void didUpdateWidget(AttackStatsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.totalAttacks != oldWidget.totalAttacks) {
      _checkForNewNotifications();
    }
  }

  Future<void> _checkForNewNotifications() async {
    try {
      final newestNotification = await _notificationRepo.getLastNotification();
      final newestStorageTimestamp = newestNotification?.timestamp;
      
      final lastDisplayedTimestamp = _recentNotifications.isNotEmpty 
          ? _recentNotifications.first.timestamp 
          : 0;
      
      if (newestStorageTimestamp != null && newestStorageTimestamp > lastDisplayedTimestamp) {
        await _loadRecentNotifications();
      }
    } catch (e) {
      // Slient error
    }
  }

  Future<void> _loadRecentNotifications() async {
    try {
      final notifications = await _notificationRepo.getAttackNotifications(limit: 3);
      if (mounted) {
        setState(() {
          _recentNotifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return (number / 1000000).toStringAsFixed(1) + tr('common.million_suffix');
    } else if (number >= 1000) {
      return (number / 1000).toStringAsFixed(1) + tr('common.thousand_suffix');
    } else {
      return number.toString();
    }
  }

  String _formatTimeAgo(int timestamp) {
    final now = DateTime.now();
    final notificationTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final difference = now.difference(notificationTime);

    if (difference.inMinutes < 1) {
      return tr('home.stats.time_ago.just_now');
    } else if (difference.inMinutes < 60) {
      return tr('home.stats.time_ago.minutes', args: [difference.inMinutes.toString()]);
    } else if (difference.inHours < 24) {
      return tr('home.stats.time_ago.hours', args: [difference.inHours.toString()]);
    } else if (difference.inDays < 30) {
      return tr('home.stats.time_ago.days', args: [difference.inDays.toString()]);
    } else {
      return tr('home.stats.time_ago.months', args: [(difference.inDays / 30).floor().toString()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        border: Border.all(
          color: _borderColor,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon
            Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 16.w,
                  color: const Color(0xFFEF4444),
                ),
                ScreenUtilHelper.sizedBoxWidth(8.0),
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      tr('home.stats.title'),
                      style: RustTypography.rustStyle(
                        fontSize: 12.sp,
                        weight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ScreenUtilHelper.sizedBoxHeight(8.0),

            // Stats Grid
            Row(
              children: [
                // Total Attacks Card
                Expanded(
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: _redBgColor.withOpacity(0.1),
                      border: Border.all(
                        color: _redBgColor.withOpacity(0.3),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tr('home.stats.total_attacks'),
                            style: RustTypography.rustStyle(
                              fontSize: 10.sp,
                              weight: FontWeight.w700,
                              color: const Color(0xFFF87171),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        ScreenUtilHelper.sizedBoxHeight(4.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _formatNumber(widget.totalAttacks),
                              style: RustTypography.rustStyle(
                                fontSize: 20.sp,
                                weight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ScreenUtilHelper.sizedBoxWidth(8.0),

                // Last Attack Card
                Expanded(
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: _darkBgColor.withOpacity(0.5),
                      border: Border.all(
                        color: _borderColor,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tr('home.stats.last_attack'),
                            style: RustTypography.rustStyle(
                              fontSize: 10.sp,
                              weight: FontWeight.w700,
                              color: const Color(0xFF71717A),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        ScreenUtilHelper.sizedBoxHeight(4.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.lastAttackTime != null
                                  ? _formatTimeAgo(widget.lastAttackTime!.millisecondsSinceEpoch)
                                  : 'N/A',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: RustTypography.rustStyle(
                                fontSize: 16.sp,
                                weight: FontWeight.w900,
                                color: const Color(0xFFEF4444),
                                letterSpacing: -0.5,
                              ).copyWith(height: 1.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ScreenUtilHelper.sizedBoxHeight(12.0),

            // Divider
            Container(
              height: 1.h,
              color: _borderColor,
            ),
            ScreenUtilHelper.sizedBoxHeight(12.0),

            // Recent Alerts Section
            Row(
              children: [
                Icon(
                  Icons.signal_cellular_alt,
                  size: 12.w,
                  color: const Color(0xFFF97316),
                ),
                ScreenUtilHelper.sizedBoxWidth(8.0),
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      tr('home.stats.recent_alerts'),
                      style: RustTypography.rustStyle(
                        fontSize: 12.sp,
                        weight: FontWeight.w700,
                        color: const Color(0xFFA1A1AA),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ScreenUtilHelper.sizedBoxHeight(8.0),

            // Recent Logs List or Empty State
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (_recentNotifications.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: CustomPaint(
                  painter: _DashedBorderPainter(
                    color: _borderColor.withOpacity(0.5),
                    strokeWidth: 1.w,
                    gap: 5.0,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tr('home.stats.no_notification'),
                          style: RustTypography.bodySmall.copyWith(
                            color: const Color(0xFF52525B), // Zinc-600
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Column(
                children: _recentNotifications.map((notification) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _darkBgColor.withOpacity(0.3),
                        border: Border.all(
                          color: _borderColor.withOpacity(0.5),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 6.w,
                                  height: 6.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    borderRadius:
                                        BorderRadius.circular(999),
                                  ),
                                ),
                                ScreenUtilHelper.sizedBoxWidth(8.0),
                                Expanded(
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      tr('home.notifications.base_attack'),
                                      style:
                                          RustTypography.bodySmall.copyWith(
                                        color: const Color(0xFFD4D4D8),
                                        fontSize: 12.sp,
                                        fontFamily: 'RobotoMono',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _formatTimeAgo(notification.timestamp),
                              style: RustTypography.bodySmall.copyWith(
                                color: const Color(0xFF52525B),
                                fontSize: 11.sp,
                                fontFamily: 'RobotoMono',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(12.0),
      ));

    final Path dashPath = Path();
    final double dashWidth = gap;
    final double dashSpace = gap;
    double distance = 0.0;

    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
