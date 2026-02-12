import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:intl/intl.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

/// Chart Data Model
class _ChartData {
  final String label;
  final int value;

  _ChartData({required this.label, required this.value});
}

/// AttackTrafficWidget - Saldırı trafiği grafiğini gösterir
/// React Native: AttackTrafficWidget.tsx
/// Optimized with cached chart data and efficient state management
class AttackTrafficWidget extends StatefulWidget {
  final Map<String, int>? dailyCounts;
  final Map<String, int>? weeklyCounts;
  final Map<String, int>? monthlyCounts;
  final Map<int, int>? hourlyCounts;

  const AttackTrafficWidget({
    super.key,
    this.dailyCounts,
    this.weeklyCounts,
    this.monthlyCounts,
    this.hourlyCounts,
  });

  @override
  State<AttackTrafficWidget> createState() => _AttackTrafficWidgetState();
}

class _AttackTrafficWidgetState extends State<AttackTrafficWidget> {
  late String _selectedTimeRange;
  bool _isDropdownOpen = false;
  int? _activeBarIndex;

  // Performance: Static cached chart data - created once, reused
  // Date Formatters (Keys remain static as they are internal)
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _monthFormat = DateFormat('yyyy-MM');

  // Performance: Cached constants (colors only - dimensions use responsive units)
  static const _bgColor = Color(0xFF121214);
  static const _borderColor = Color(0xFF27272A);
  static const _darkBgColor = Color(0xFF18181B);
  static const _accentColor = Color(0xFF3F3F46);

  @override
  void initState() {
    super.initState();
    _selectedTimeRange = 'Day';
  }

  @override
  @override
  Widget build(BuildContext context) {
    // Generate data dynamically
    final activeData = _generateChartData();
    final maxValue = activeData.isEmpty 
        ? 0 
        : activeData.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final yAxisMax = maxValue == 0 ? 100 : (maxValue * 1.2).ceil();

    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        border: Border.all(
          color: _borderColor,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Expanded(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tr('home.traffic.title'),
                          style: RustTypography.rustStyle(
                            fontSize: 12.sp,
                            weight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),

                    // Dropdown Button
                    GestureDetector(
                      onTap: () {
                        HapticHelper.mediumImpact();
                        setState(() {
                          _isDropdownOpen = !_isDropdownOpen;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: _darkBgColor,
                          border: Border.all(
                            color: _accentColor,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                tr('home.traffic.ranges.${_selectedTimeRange.toLowerCase()}'),
                                style: RustTypography.labelSmall.copyWith(
                                  color: const Color(0xFFD4D4D8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ScreenUtilHelper.sizedBoxWidth(4.0),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 12.w,
                              color: const Color(0xFFD4D4D8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                 ScreenUtilHelper.sizedBoxHeight(12.0),

                // Chart Visual
                RepaintBoundary(
                  child: SizedBox(
                    height: 180.h,
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              // Background Grid Lines (dashed-like)
                              Positioned.fill(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        4,
                                        (index) => _DashedLine(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Bars
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children:
                                    activeData.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final data = entry.value;
                                  final heightPercent =
                                      ((data.value / yAxisMax) * 100)
                                          .clamp(5.0, 100.0);

                                  final isHigh = maxValue > 0
                                      ? data.value > (maxValue * 0.7)
                                      : false;
                                  final isActive = _activeBarIndex == idx;

                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                HapticHelper.mediumImpact();
                                                setState(() {
                                                  _activeBarIndex =
                                                      isActive ? null : idx;
                                                });
                                              },
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.bottomCenter,
                                                        child: TweenAnimationBuilder<double>(
                                                          tween: Tween<double>(
                                                            begin: 0,
                                                            end: heightPercent / 100.0,
                                                          ),
                                                          duration: const Duration(
                                                            milliseconds: 700,
                                                          ),
                                                          curve: Curves.easeOut,
                                                          builder: (context, value,
                                                              child) {
                                                            return FractionallySizedBox(
                                                              heightFactor: value,
                                                              child: child,
                                                            );
                                                          },
                                                          child:
                                                              AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                              milliseconds: 700,
                                                            ),
                                                            curve:
                                                                Curves.easeOut,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient: isHigh
                                                                  ? const LinearGradient(
                                                                      begin: Alignment
                                                                          .bottomCenter,
                                                                      end: Alignment
                                                                          .topCenter,
                                                                      colors: [
                                                                        Color(
                                                                            0xFFB91C1C),
                                                                        Color(
                                                                            0xFFEF4444),
                                                                      ],
                                                                    )
                                                                  : LinearGradient(
                                                                      begin: Alignment
                                                                          .bottomCenter,
                                                                      end: Alignment
                                                                          .topCenter,
                                                                      colors: isActive
                                                                          ? const [
                                                                              Color(
                                                                                  0xFF3F3F46),
                                                                              Color(
                                                                                  0xFF52525B),
                                                                             ]
                                                                          : const [
                                                                              Color(
                                                                                  0xFF27272A),
                                                                              Color(
                                                                                  0xFF3F3F46),
                                                                            ],
                                                                    ),
                                                              borderRadius:
                                                                   BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(2.r),
                                                                topRight: Radius
                                                                    .circular(2.r),
                                                              ),
                                                              boxShadow: isHigh
                                                                  ? [
                                                                      BoxShadow(
                                                                        color: Color(
                                                                                0xFFDC2626)
                                                                            .withOpacity(
                                                                                0.4),
                                                                        blurRadius: 15.r,
                                                                        spreadRadius: 0,
                                                                      ),
                                                                    ]
                                                                  : [],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: -8,
                                                        left: 0,
                                                        right: 0,
                                                        child: IgnorePointer(
                                                          ignoring: true,
                                                          child: AnimatedOpacity(
                                                            opacity:
                                                                isActive ? 1 : 0,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        150),
                                                            child: Center(
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .symmetric(
                                                                  horizontal: 8.w,
                                                                  vertical: 4.h,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFF27272A),
                                                                  border: Border.all(
                                                                    color: const Color(
                                                                        0xFF3F3F46),
                                                                    width: 1.w,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.r),
                                                                ),
                                                                child: FittedBox(
                                                                  fit: BoxFit.scaleDown,
                                                                  child: Text(
                                                                    data.value
                                                                        .toString(),
                                                                    style: RustTypography
                                                                        .rustStyle(
                                                                      fontSize: 10.sp,
                                                                      weight:
                                                                          FontWeight.w700,
                                                                      color:
                                                                          Colors.white,
                                                                      letterSpacing: 0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          ScreenUtilHelper.sizedBoxHeight(8.0),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              data.label,
                                              style: RustTypography.monoStyle(
                                                fontSize: 10.sp,
                                                weight: FontWeight.w700,
                                                color: const Color(0xFF71717A),
                                                letterSpacing: 1.0,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Click-outside layer for dropdown
          if (_isDropdownOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    _isDropdownOpen = false;
                  });
                },
                child: const SizedBox.expand(),
              ),
            ),

          // Dropdown Menu
          if (_isDropdownOpen)
            Positioned(
              top: 58.0,
              right: 20.0,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 150),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.95 + (0.05 * value),
                      alignment: Alignment.topRight,
                      child: child,
                    ),
                  );
                },
                child: RepaintBoundary(
                  child: Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF18181B),
                      border: Border.all(
                        color: const Color(0xFF3F3F46),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 24.0,
                          offset: Offset(0, 12.h),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: ['Day', 'Week', 'Month'].map((range) {
                          final isSelected = _selectedTimeRange == range;
                          return GestureDetector(
                            onTap: () {
                              HapticHelper.mediumImpact();
                              setState(() {
                                _selectedTimeRange = range;
                                _isDropdownOpen = false;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              color: isSelected
                                  ? const Color(0xFF27272A).withOpacity(0.5)
                                  : Colors.transparent,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  tr('home.traffic.ranges.${range.toLowerCase()}'),
                                  style: RustTypography.rustStyle(
                                    fontSize: 12.sp,
                                    weight: FontWeight.w700,
                                    color: isSelected
                                        ? const Color(0xFFF97316)
                                        : const Color(0xFFA1A1AA),
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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

  List<_ChartData> _generateChartData() {
    final now = DateTime.now();
    
    switch (_selectedTimeRange) {
      case 'Day':
        // 4-hour intervals: 00, 04, 08, 12, 16, 20
        final hours = [0, 4, 8, 12, 16, 20];
        return hours.map((hour) {
          final label = '${hour.toString().padLeft(2, '0')}:00';
          // Aggregate data for the 4-hour block
          int value = 0;
          for (int i = 0; i < 4; i++) {
            value += widget.hourlyCounts?[hour + i] ?? 0;
          }
          return _ChartData(label: label, value: value);
        }).toList();

      case 'Week':
        // Last 7 days + Today
        final locale = context.locale.toString();
        final dayNameFormat = DateFormat('E', locale);
        return List.generate(7, (index) {
          final date = now.subtract(Duration(days: 6 - index));
          final label = dayNameFormat.format(date);
          final key = _dateFormat.format(date);
          final value = widget.dailyCounts?[key] ?? 0;
          return _ChartData(label: label, value: value);
        });

      case 'Month':
        // Start from -1 previous month
        // Range: [Current-1, Current, Current+1, Current+2, Current+3, Current+4]
        final locale = context.locale.toString();
        final monthNameFormat = DateFormat('MMM', locale);
        return List.generate(6, (index) {
          final date = DateTime(now.year, now.month - 1 + index);
          final label = monthNameFormat.format(date);
          final key = _monthFormat.format(date);
          final value = widget.monthlyCounts?[key] ?? 0;
          return _ChartData(label: label, value: value);
        });

      default:
        return [];
    }
  }
}

class _DashedLine extends StatelessWidget {
  final Color color;

  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(
        painter: _DashedLinePainter(color: color),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.w;

    final dashWidth = 6.w;
    final dashSpace = 6.w;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset((startX + dashWidth).clamp(0, size.width), 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
