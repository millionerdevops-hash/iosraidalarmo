import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'dart:ui' as ui;

class TargetPlayer {
  final String? id;
  final String name;
  final bool isOnline;
  final String lastSeen;
  final bool notifyOnOnline;
  final bool notifyOnOffline;

  const TargetPlayer({
    this.id,
    required this.name,
    required this.isOnline,
    required this.lastSeen,
    this.notifyOnOnline = true,
    this.notifyOnOffline = false,
  });
}

class ServerTargetsTab extends StatelessWidget {
  final List<TargetPlayer> trackedTargets;
  final String targetInput;
  final Function(String) onTargetInputChange;
  final bool verifyingTarget;
  final VoidCallback onVerifyAndAdd;
  final String? targetError;
  final Function(TargetPlayer) onEditTarget;
  final Function(TargetPlayer) onDeleteTarget;
  final VoidCallback onGoToLive;

  const ServerTargetsTab({
    super.key,
    required this.trackedTargets,
    required this.targetInput,
    required this.onTargetInputChange,
    required this.verifyingTarget,
    required this.onVerifyAndAdd,
    required this.targetError,
    required this.onEditTarget,
    required this.onDeleteTarget,
    required this.onGoToLive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Manual Entry Input
                  _TargetInputRow(
                    targetInput: targetInput,
                    verifyingTarget: verifyingTarget,
                    onTargetInputChange: onTargetInputChange,
                    onVerifyAndAdd: onVerifyAndAdd,
                  ),

                  // Error Message
                  if (targetError != null)
                    _ErrorMessage(error: targetError!),
                  
                  ScreenUtilHelper.sizedBoxHeight(16.0),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: trackedTargets.isNotEmpty,
            child: trackedTargets.isEmpty
                ? _EmptyTargetsDisplay(onGoToLive: onGoToLive)
                : _TargetsList(
                    trackedTargets: trackedTargets,
                    onEditTarget: onEditTarget,
                    onDeleteTarget: onDeleteTarget,
                  ),
          ),
        ],
      ),
    );
  }
}

class _TargetInputRow extends StatelessWidget {
  final String targetInput;
  final bool verifyingTarget;
  final Function(String) onTargetInputChange;
  final VoidCallback onVerifyAndAdd;

  const _TargetInputRow({
    required this.targetInput,
    required this.verifyingTarget,
    required this.onTargetInputChange,
    required this.onVerifyAndAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextField(
              onChanged: onTargetInputChange,
              onSubmitted: (_) {
                if (targetInput.isNotEmpty) {
                  FocusScope.of(context).unfocus();
                  HapticHelper.mediumImpact();
                  onVerifyAndAdd();
                }
              },
              cursorColor: const Color(0xFFF97316),
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: 'RobotoMono',
              ),
              controller: TextEditingController(text: targetInput)..selection = TextSelection.fromPosition(TextPosition(offset: targetInput.length)),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF18181B), // bg-zinc-900
                hintText: tr('server.targets.enter_player_name'),
                hintStyle: TextStyle(
                  color: const Color(0xFF52525B), // text-zinc-600
                  fontSize: 13.sp,
                  fontFamily: 'RobotoMono',
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                counterText: "", // Hides the counter
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFF27272A)), // border-zinc-800
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFFF97316)), // orange-500
                ),
              ),
              maxLength: 30,
            ),
          ),
          ScreenUtilHelper.sizedBoxWidth(8.0),
          AspectRatio(
            aspectRatio: 1.0,
            child: Material(
              color: const Color(0x7F450A0A), // bg-red-900/50
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: const BorderSide(color: Color(0xFF7F1D1D)), // border-red-800
              ),
              child: InkWell(
                onTap: (verifyingTarget || targetInput.isEmpty) ? null : () {
                  FocusScope.of(context).unfocus();
                  HapticHelper.mediumImpact();
                  onVerifyAndAdd();
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: verifyingTarget
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Container( // The small square from TSX
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: const Color(0x33EF4444), // bg-red-500/20
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String error;

  const _ErrorMessage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 4.w),
      child: Row(
        children: [
          Icon(
            LucideIcons.triangleAlert,
            size: 14.w,
            color: const Color(0xFFEF4444),
          ),
          ScreenUtilHelper.sizedBoxWidth(6.0),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: const Color(0xFFEF4444),
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Geist',
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTargetsDisplay extends StatelessWidget {
  final VoidCallback onGoToLive;

  const _EmptyTargetsDisplay({required this.onGoToLive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: CustomPaint(
      painter: _DashedBorderPainter(
        color: const Color(0xFF27272A),
        strokeWidth: 1.0,
        gap: 5.0,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.crosshair,
              size: 32.w,
              color: const Color(0xFF71717A).withOpacity(0.3),
            ),
            ScreenUtilHelper.sizedBoxHeight(8.0),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('server.targets.no_targets'),
                style: TextStyle(
                  color: const Color(0xFF71717A), // text-zinc-500/600 concept
                  fontSize: 12.sp,
                  fontFamily: 'Geist',
                ),
              ),
            ),
            ScreenUtilHelper.sizedBoxHeight(8.0),
            InkWell(
              onTap: () {
                HapticHelper.mediumImpact();
                onGoToLive();
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tr('server.targets.go_to_live'),
                  style: TextStyle(
                    color: const Color(0xFF3B82F6),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Geist',
                  ),
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
        const Radius.circular(12),
      ));

    final Path dashedPath = _dashPath(path, width: 5.0, space: gap);
    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(Path source, {required double width, required double space}) {
    final Path dest = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dest.addPath(
          metric.extractPath(distance, distance + width),
          Offset.zero,
        );
        distance += width + space;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        gap != oldDelegate.gap;
  }
}

class _TargetsList extends StatelessWidget {
  final List<TargetPlayer> trackedTargets;
  final Function(TargetPlayer) onEditTarget;
  final Function(TargetPlayer) onDeleteTarget;

  const _TargetsList({
    required this.trackedTargets,
    required this.onEditTarget,
    required this.onDeleteTarget,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trackedTargets.length,
      padding: EdgeInsets.only(top: 8.h, bottom: 90.h), // Added bottom padding for safe area
      itemBuilder: (context, index) {
        final target = trackedTargets[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _TargetItem(
            target: target,
            onEditTarget: onEditTarget,
            onDeleteTarget: onDeleteTarget,
          ),
        );
      },
    );
  }
}

class _TargetItem extends StatelessWidget {
  final TargetPlayer target;
  final Function(TargetPlayer) onEditTarget;
  final Function(TargetPlayer) onDeleteTarget;

  const _TargetItem({
    required this.target,
    required this.onEditTarget,
    required this.onDeleteTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0x8018181B), // bg-zinc-900/50
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF27272A)), // border-zinc-800
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // Online Indicator
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: target.isOnline
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF52525B),
                    borderRadius: BorderRadius.circular(999.r),
                    boxShadow: target.isOnline
                        ? [
                            BoxShadow(
                              color: const Color(0xFF22C55E).withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                ),
                ScreenUtilHelper.sizedBoxWidth(12.0),
          
                // Player Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          target.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Geist',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ScreenUtilHelper.sizedBoxHeight(2.0),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          target.lastSeen,
                          style: TextStyle(
                            color: const Color(0xFF71717A),
                            fontSize: 10.sp,
                            fontFamily: 'Geist',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: [
              // Delete Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticHelper.mediumImpact();
                    onDeleteTarget(target);
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      LucideIcons.trash2,
                      size: 16.w,
                      color: const Color(0xFF71717A),
                    ),
                  ),
                ),
              ),
              
              ScreenUtilHelper.sizedBoxWidth(4.0),

              // Settings Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticHelper.mediumImpact();
                    onEditTarget(target);
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      LucideIcons.settings,
                      size: 16.w,
                      color: const Color(0xFF71717A),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
