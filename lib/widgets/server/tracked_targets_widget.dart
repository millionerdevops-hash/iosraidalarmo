import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

/// Tracked Target Model
class TrackedTarget {
  final String name;
  final String? playerId; // Added to enable details lookup
  final bool isOnline;
  final String lastSeen;
  final bool hasAlert; // notifyOnOnline
  final bool notifyOnOffline;

  TrackedTarget({
    required this.name,
    this.playerId,
    required this.isOnline,
    required this.lastSeen,
    this.hasAlert = false,
    this.notifyOnOffline = false,
  });
}

/// TrackedTargetsWidget - İzlenen hedefler
/// React Native: TrackedTargetsWidget.tsx
class TrackedTargetsWidget extends StatefulWidget {
  final List<TrackedTarget> targets;
  final VoidCallback? onSearchPlayers;
  final Function(TrackedTarget)? onRemove;
  final Function(TrackedTarget)? onTap;
  const TrackedTargetsWidget({
    Key? key,
    required this.targets,
    this.onSearchPlayers,
    this.onRemove,
    this.onTap,
  }) : super(key: key);

  @override
  State<TrackedTargetsWidget> createState() => _TrackedTargetsWidgetState();
}

class _TrackedTargetsWidgetState extends State<TrackedTargetsWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseOpacity;


  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targets = widget.targets;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121214),
        border: Border.all(
          color: const Color(0xFF27272A),
          width: 1.0.w,
        ),
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.center_focus_strong,
                    size: 16.0.w,
                    color: const Color(0xFFEF4444),
                  ),
                  ScreenUtilHelper.sizedBoxWidth(8.0),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tr('server.targets.title'),
                      style: RustTypography.rustStyle(
                        fontSize: 14.0.sp,
                        weight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              // Count Badge
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.0.w, vertical: 4.0.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF18181B),
                  border: Border.all(
                    color: const Color(0xFF27272A),
                    width: 1.0.w,
                  ),
                  borderRadius: BorderRadius.circular(4.0.r),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${targets.length} ${tr('server.targets.active_badge')}',
                    style: TextStyle(
                      fontSize: 10.0.sp,
                      color: const Color(0xFF71717A),
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ),
              ),
            ],
          ),
          ScreenUtilHelper.sizedBoxHeight(16.0),

          // Content
          if (targets.isEmpty) _buildEmptyState(context) else _buildTargetsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedRRectPainter(
        color: const Color(0xFF27272A),
        radius: 12.0,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.0.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0.r),
          color: const Color(0xFF18181B).withOpacity(0.2),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('server.targets.empty'),
                style: TextStyle(
                  fontSize: 12.0.sp,
                  color: const Color(0xFF71717A),
                ),
              ),
            ),
            ScreenUtilHelper.sizedBoxHeight(8.0),
            _SearchLink(onTap: () {
               if (widget.onSearchPlayers != null) {
                  widget.onSearchPlayers!();
               } else {
                  context.push('/player-search');
               }
            }),
          ],
        ),
      ),
    );
  }




  Widget _buildTargetsList() {
    final targets = widget.targets;
    return Column(
      children: List.generate(
        targets.length,
        (index) {
          final target = targets[index];
          return Padding(
            padding:
                EdgeInsets.only(bottom: index < targets.length - 1 ? 8.0.h : 0),
            child: InkWell(
              onTap: widget.onTap != null ? () {
                HapticHelper.mediumImpact();
                widget.onTap!(target);
              } : null,
              borderRadius: BorderRadius.circular(12.0.r),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF18181B).withOpacity(0.5),
                  border: Border.all(
                    color: const Color(0xFF27272A).withOpacity(0.5),
                    width: 1.0.w,
                  ),
                  borderRadius: BorderRadius.circular(12.0.r),
                ),
              padding: EdgeInsets.all(12.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 32.0.w,
                              height: 32.0.w,
                              decoration: BoxDecoration(
                                color: target.isOnline
                                    ? const Color(0xFF14532D).withOpacity(0.2)
                                    : const Color(0xFF27272A),
                                border: Border.all(
                                  color: target.isOnline
                                      ? const Color(0xFF22C55E)
                                          .withOpacity(0.3)
                                      : const Color(0xFF3F3F46),
                                  width: 1.0.w,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 16.0.w,
                                color: target.isOnline
                                    ? const Color(0xFF22C55E)
                                    : const Color(0xFF71717A),
                              ),
                            ),
                            Positioned(
                              bottom: -2.0.w,
                              right: -2.0.w,
                              child: FadeTransition(
                                opacity: target.isOnline
                                    ? _pulseOpacity
                                    : const AlwaysStoppedAnimation(1.0),
                                child: Container(
                                  width: 10.0.w,
                                  height: 10.0.w,
                                  decoration: BoxDecoration(
                                    color: target.isOnline
                                        ? const Color(0xFF22C55E)
                                        : const Color(0xFF71717A),
                                    borderRadius: BorderRadius.circular(999.r),
                                    border: Border.all(
                                      color: const Color(0xFF121214),
                                      width: 2.0.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ScreenUtilHelper.sizedBoxWidth(12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  target.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                              ScreenUtilHelper.sizedBoxHeight(4.0),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  target.isOnline
                                      ? tr('server.targets.online_now')
                                      : _formatLastSeen(target.lastSeen),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.0.sp,
                                    color: const Color(0xFF71717A),
                                    fontFamily: 'RobotoMono',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                       if (target.hasAlert)
                        Container(
                          margin: EdgeInsets.only(right: 8.0.w),
                          padding: EdgeInsets.all(6.0.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.1),
                            border: Border.all(
                              color: const Color(0xFFEF4444).withOpacity(0.2),
                              width: 1.0.w,
                            ),
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          child: Icon(
                            Icons.notifications,
                            size: 12.0.w,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      if (widget.onRemove != null)
                        InkWell(
                          onTap: () {
                            HapticHelper.mediumImpact();
                            widget.onRemove!(target);
                          },
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.all(6.0.w),
                            child: Icon(
                              Icons.delete_outline,
                              size: 18.0.w,
                              color: const Color(0xFF71717A),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        },
      ),
    );
  }
  String _formatLastSeen(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      // Format to HH:mm
      return DateFormat('HH:mm').format(date.toLocal());
    } catch (e) {
      return timestamp;
    }
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedRRectPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const dashWidth = 6.0;
    const dashSpace = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        final extract = metric.extractPath(distance, next);
        canvas.drawPath(extract, paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

class _SearchLink extends StatefulWidget {
  final VoidCallback onTap;
  const _SearchLink({required this.onTap});

  @override
  State<_SearchLink> createState() => _SearchLinkState();
}

class _SearchLinkState extends State<_SearchLink> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticHelper.mediumImpact();
        widget.onTap();
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          tr('server.targets.search_link'),
          style: TextStyle(
            fontSize: 10.0.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF97316),
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
