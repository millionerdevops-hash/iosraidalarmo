import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/widgets/server/status/serverdetailmanager.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

class ServerLiveTab extends StatelessWidget {
  final List<LogEntry> logs;
  final String? feedError;
  final Function(String id, String name) onInspectPlayer;

  const ServerLiveTab({
    super.key,
    required this.logs,
    required this.feedError,
    required this.onInspectPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Info Card
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF18181B),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF27272A)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.timerReset, size: 18.w, color: const Color(0xFFA1A1AA)),
                ScreenUtilHelper.sizedBoxWidth(12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('server.live.auto_refresh_active'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          fontFamily: 'Geist',
                        ),
                      ),
                      ScreenUtilHelper.sizedBoxHeight(2.0),
                      Text(
                        tr('server.live.auto_refresh_desc'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF71717A),
                          fontSize: 11.sp,
                          fontFamily: 'Geist',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          ScreenUtilHelper.sizedBoxHeight(12.0),

          // Main Terminal Console
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF27272A)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Terminal Header
                  _TerminalHeader(feedError: feedError),
      
                  // Terminal Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: feedError != null
                          ? _ErrorDisplay(error: feedError!)
                          : logs.isEmpty
                              ? const _LoadingDisplay()
                              : _LogsList(
                                  logs: logs,
                                  onInspectPlayer: onInspectPlayer,
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted terminal header to prevent rebuilds
class _TerminalHeader extends StatelessWidget {
  final String? feedError;

  const _TerminalHeader({required this.feedError});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF27272A)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('server.live.activity_title'),
              style: TextStyle(
                color: const Color(0xFF22C55E),
                fontSize: 12.sp,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
          if (feedError != null)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('server.live.no_signal'),
                style: TextStyle(
                  color: const Color(0xFFEF4444),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  fontFamily: 'Geist',
                ),
              ),
            )
          else
            Row(
              children: [
                const _PulsingDot(),
                ScreenUtilHelper.sizedBoxWidth(6.0),
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F3F46),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Extracted error display
class _ErrorDisplay extends StatelessWidget {
  final String error;

  const _ErrorDisplay({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0x33450A0A),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0x807F1D1D)),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFFCA5A5),
              fontSize: 12.sp,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted loading display
class _LoadingDisplay extends StatelessWidget {
  const _LoadingDisplay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: const AlwaysStoppedAnimation(Color(0x8052525B)),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(8.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('server.live.fetching_data'),
              style: TextStyle(
                color: const Color(0xFF52525B),
                fontSize: 12.sp,
                fontStyle: FontStyle.italic,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted logs list with ListView.builder optimization
class _LogsList extends StatelessWidget {
  final List<LogEntry> logs;
  final Function(String id, String name) onInspectPlayer;

  const _LogsList({
    required this.logs,
    required this.onInspectPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Performance optimization
      itemCount: logs.length,
      padding: EdgeInsets.only(bottom: 120.h),
      // Add keys for better performance
      itemBuilder: (context, index) {
        final log = logs[index];
        return _LogEntryItem(
          key: ValueKey(log.id),
          log: log,
          onInspectPlayer: onInspectPlayer,
        );
      },
    );
  }
}

// Extracted log entry item to prevent rebuilds
class _LogEntryItem extends StatelessWidget {
  final LogEntry log;
  final Function(String id, String name) onInspectPlayer;

  const _LogEntryItem({
    super.key,
    required this.log,
    required this.onInspectPlayer,
  });

  @override
  Widget build(BuildContext context) {
    final isJoin = log.type == 'join';

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timestamp - increased width to fit [HH:mm:ss] in one line
          SizedBox(
            width: 75.w,
            child: Text(
              '[${log.time}]',
              style: TextStyle(
                color: const Color(0xFF52525B),
                fontSize: 11.sp,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxWidth(8.0),

          // Log Content
          Expanded(
            child: Row(
              children: [
                // +/- Indicator
                Text(
                  isJoin ? '+' : '-',
                  style: TextStyle(
                    color: isJoin
                        ? const Color(0xFF4ADE80)
                        : const Color(0xFFFCA5A5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                ScreenUtilHelper.sizedBoxWidth(4.0),

                // Player Name (Clickable) - removed FittedBox for proper ellipsis
                Expanded(
                  child: InkWell(
                    onTap: () {
                      HapticHelper.mediumImpact();
                      onInspectPlayer(
                        log.playerId,
                        log.playerName,
                      );
                    },
                    child: Text(
                      log.playerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFFE4E4E7),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'RobotoMono',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Pulsing Dot Widget - Optimized
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smoother animation
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => child!,
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: const Color(0xFF3F3F46),
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
      ),
    );
  }
}
