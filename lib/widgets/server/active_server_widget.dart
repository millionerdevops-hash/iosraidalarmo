import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

import 'package:raidalarm/core/utils/connectivity_helper.dart';

import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/services/battlemetrics.dart';

/// ActiveServerWidget - Aktif sunucu
/// React Native: ActiveServerWidget.tsx
class ActiveServerWidget extends StatefulWidget {
  final ServerData? server;
  final VoidCallback? onEmptyTap;

  const ActiveServerWidget({
    Key? key,
    this.server,
    this.onEmptyTap,
  }) : super(key: key);

  @override
  State<ActiveServerWidget> createState() => _ActiveServerWidgetState();
}

class _ActiveServerWidgetState extends State<ActiveServerWidget> {
  final BattleMetricsApi _api = BattleMetricsApi();
  ServerData? _displayServer;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _displayServer = widget.server;
    
    if (widget.server != null) {
      _fetchLiveUpdates();
      _startPeriodicRefresh();
    }
  }

  @override
  void didUpdateWidget(ActiveServerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.server?.id != widget.server?.id) {
       setState(() {
         _displayServer = widget.server;
       });
       if (widget.server != null) {
         _fetchLiveUpdates();
         _startPeriodicRefresh();
       } else {
         _stopPeriodicRefresh();
       }
    }
  }

  @override
  void dispose() {
    _stopPeriodicRefresh();
    super.dispose();
  }

  void _startPeriodicRefresh() {
    _stopPeriodicRefresh();
    // Refresh every 5 minutes to update player count, status etc.
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _fetchLiveUpdates();
    });
  }

  void _stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> _fetchLiveUpdates() async {
    if (widget.server == null) return;

    // Check internet connection first
    final hasInternet = await ConnectivityHelper.hasInternet();
    if (!hasInternet) {
      return;
    }

    try {
      final json = await _api.fetchBattleMetrics('/servers/${widget.server!.id}');
      if (json['data'] != null && mounted) {
        setState(() {
          _displayServer = ServerData.fromJson(json['data']);
        });
      }
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_displayServer == null) {
      return _buildEmptyState(context);
    }

    final server = _displayServer!;
    return GestureDetector(
      onTap: () {
        HapticHelper.mediumImpact();
        context.push('/server-detail');
      },
      child: Container(
        height: 160.0.h, 
        decoration: BoxDecoration(
          color: const Color(0xFF121214), 
          border: Border.all(
            color: const Color(0xFF27272A), 
            width: 1.0.w,
          ),
          borderRadius: BorderRadius.circular(16.0.r), 
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            if (server.headerImage != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.network(
                      server.headerImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF121214),
                        );
                      },
                    ),
                  ),
                ),
              ),

            // Gradient Overlay
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF09090B), // zinc-950
                        const Color(0xFF09090B).withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Status + Wipe Timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Badge
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.0.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0.w, 
                                vertical: 4.0.h, 
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1.0.w,
                                ),
                                borderRadius: BorderRadius.circular(4.0.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.0.w,
                                    height: 8.0.w,
                                    decoration: BoxDecoration(
                                      color: server.status == 'online'
                                          ? const Color(0xFF22C55E)
                                          : const Color(0xFFEF4444),
                                      borderRadius:
                                          BorderRadius.circular(999.r),
                                      boxShadow: server.status == 'online'
                                          ? [
                                              BoxShadow(
                                                color:
                                                    const Color(0xFF22C55E)
                                                        .withOpacity(0.8),
                                                blurRadius: 8.0.r,
                                              ),
                                            ]
                                          : [],
                                    ),
                                  ),
                                  SizedBox(width: 6.0.w),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      (server.status == 'online' ? tr('server.status.online') : tr('server.status.offline')).toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Wipe Timer Badge (Extracted)
                        if (server.nextWipe != null)
                          _WipeTimer(nextWipe: server.nextWipe!),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Server Name
                        Text(
                          server.name.toUpperCase(),
                          style: RustTypography.rustStyle(
                            fontSize: 12.0,
                            weight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ).copyWith(
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ScreenUtilHelper.sizedBoxHeight(8.0), 

                        // Server Stats
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row 1: Players & FPS
                            Row(
                              children: [
                                // Players
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      size: 12.0.w, 
                                      color: const Color(0xFFD4D4D8), 
                                    ),
                                    ScreenUtilHelper.sizedBoxWidth(6.0), 
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${server.players}/${server.maxPlayers}',
                                        style: TextStyle(
                                          fontSize: 12.0.sp, 
                                          color: const Color(0xFFD4D4D8),
                                          fontFamily: 'RobotoMono',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // FPS
                                if (server.fps != null) ...[
                                  ScreenUtilHelper.sizedBoxWidth(16.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.memory,
                                        size: 12.0.w, 
                                        color: const Color(0xFFD4D4D8),
                                      ),
                                      ScreenUtilHelper.sizedBoxWidth(6.0),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '${server.fps} ${tr('server.overview.fps')}',
                                          style: TextStyle(
                                            fontSize: 12.0.sp, 
                                            color: const Color(0xFFD4D4D8),
                                            fontFamily: 'RobotoMono',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            
                            ScreenUtilHelper.sizedBoxHeight(4.0),

                            // Row 2: Map
                            Row(
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  size: 12.0.w, 
                                  color: const Color(0xFFD4D4D8),
                                ),
                                  ScreenUtilHelper.sizedBoxWidth(6.0),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        server.map ?? tr('server.map.procedural'),
                                        style: TextStyle(
                                          fontSize: 12.0.sp, 
                                          color: const Color(0xFFD4D4D8),
                                          fontFamily: 'RobotoMono',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        HapticHelper.mediumImpact();
        if (widget.onEmptyTap != null) {
          widget.onEmptyTap!();
        } else {
           context.push('/server-search');
        }
      },
      child: CustomPaint(
        foregroundPainter: _DashedRRectPainter(
          color: const Color(0xFF27272A), 
          radius: 16.0.r,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF18181B).withOpacity(0.3), 
            borderRadius: BorderRadius.circular(16.0.r),
          ),
          padding: EdgeInsets.all(32.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi,
                size: 32.0.w,
                color: const Color(0xFF71717A), 
              ),
              ScreenUtilHelper.sizedBoxHeight(12.0),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tr('server.active_widget.select'),
                  style: RustTypography.labelSmall.copyWith(
                    color: const Color(0xFF71717A), 
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WipeTimer extends StatefulWidget {
  final String nextWipe;
  const _WipeTimer({required this.nextWipe});

  @override
  State<_WipeTimer> createState() => _WipeTimerState();
}

class _WipeTimerState extends State<_WipeTimer> {
  @override
  void initState() {
    super.initState();
    // Local timer removed. Backend handles the alert timing.
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _formatWipeCountdown(String? isoDate) {
    if (isoDate == null) return tr('server.overview.unknown');
    try {
      final wipeDate = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = wipeDate.difference(now);

      if (diff.isNegative) return tr('server.active_widget.wiped');

      final days = diff.inDays;
      final hours = diff.inHours % 24;
      final minutes = diff.inMinutes % 60;

      if (days > 0) return '${days}d ${hours}h';
      return '${hours}h ${minutes}m';
    } catch (e) {
      return tr('server.overview.unknown');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0.w,
            vertical: 4.0.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF7C2D12)
                .withOpacity(0.8),
            border: Border.all(
              color: const Color(0xFFF97316)
                  .withOpacity(0.3),
              width: 1.0.w,
            ),
            borderRadius:
                BorderRadius.circular(4.0.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timer,
                size: 12.0.w,
                color: const Color(0xFFF97316),
              ),
              ScreenUtilHelper.sizedBoxWidth(4.0),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _formatWipeCountdown(widget.nextWipe),
                  style: TextStyle(
                    fontSize: 10.0.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFB923C),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
