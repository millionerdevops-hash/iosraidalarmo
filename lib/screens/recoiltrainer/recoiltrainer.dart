import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/data/recoil_data.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

class RecoilTrainerScreen extends ConsumerStatefulWidget {
  const RecoilTrainerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RecoilTrainerScreen> createState() => _RecoilTrainerScreenState();
}

class _RecoilTrainerScreenState extends ConsumerState<RecoilTrainerScreen> {
  String _selectedWeaponId = 'ak47';
  bool _isPlaying = false;
  double _speedMultiplier = 1.0;
  bool _showControl = true; 
  final ValueNotifier<int> _shotIndexNotifier = ValueNotifier<int>(0);
  Timer? _animationTimer;

  late RecoilPattern _weapon;

  @override
  void initState() {
    super.initState();
    _updateWeapon();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _shotIndexNotifier.dispose();
    super.dispose();
  }

  void _updateWeapon() {
    _weapon = weapons.firstWhere((w) => w.id == _selectedWeaponId, orElse: () => weapons[0]);
  }

  void _reset() {
    _isPlaying = false;
    _shotIndexNotifier.value = 0;
    setState(() {});
    _animationTimer?.cancel();
  }

  void _togglePlay() {
    if (_shotIndexNotifier.value >= _weapon.pattern.length - 1) {
      _shotIndexNotifier.value = 0;
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      HapticHelper.soft(); // Trigger soft pulse for first shot
      _startAnimation();
    } else {
      _animationTimer?.cancel();
    }
  }

  void _startAnimation() {
    _animationTimer?.cancel();
    final msPerShot = ((60000 / _weapon.rpm) / _speedMultiplier).round();
    
    _animationTimer = Timer.periodic(Duration(milliseconds: msPerShot), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_shotIndexNotifier.value >= _weapon.pattern.length - 1) {
        setState(() {
          _isPlaying = false;
        });
        timer.cancel();
        return;
      }

      _shotIndexNotifier.value++;
      HapticHelper.soft(); // Rhythmic pulse for sequence
    });
  }

  // Visualization Helpers
  static const double _center = 150.0;

  double get _dynamicScale {
    double maxDist = 0;
    for (var p in _weapon.pattern) {
      maxDist = max(maxDist, max(p.x.abs(), p.y.abs()));
    }
    if (maxDist == 0) return 2.0;

    const availableRadius = 120.0;
    final calculatedScale = availableRadius / maxDist;
    return min(2.5, max(0.5, calculatedScale));
  }

  Offset _getCoordinates(RecoilPoint p) {
    final scale = _dynamicScale;
    final impactX = _center + (p.x * scale);
    final impactY = _center - (p.y * scale);

    final controlX = _center - (p.x * scale);
    final controlY = _center + (p.y * scale);

    return _showControl ? Offset(controlX, controlY) : Offset(impactX, impactY);
  }

  Map<String, dynamic> _getDynamicHint(int shotIndex) {
    if (!_isPlaying && shotIndex == 0) {
      return {'text': tr('recoil_trainer.ready'), 'icon': LucideIcons.crosshair, 'color': Colors.grey};
    }
    if (shotIndex >= _weapon.pattern.length - 1) {
      return {'text': tr('recoil_trainer.complete'), 'icon': LucideIcons.rotateCcw, 'color': Colors.green};
    }

    final current = _weapon.pattern[shotIndex];
    final next = _weapon.pattern[min(shotIndex + 3, _weapon.pattern.length - 1)];

    final dx = next.x - current.x;
    final dy = next.y - current.y;

    if (dy > 2) return {'text': tr('recoil_trainer.pull_down'), 'icon': LucideIcons.moveDown, 'color': Colors.red};
    if (dx > 2) return {'text': tr('recoil_trainer.pull_left'), 'icon': LucideIcons.moveLeft, 'color': Colors.orange};
    if (dx < -2) return {'text': tr('recoil_trainer.pull_right'), 'icon': LucideIcons.moveRight, 'color': Colors.orange};

    return {'text': tr('recoil_trainer.stabilize'), 'icon': LucideIcons.target, 'color': Colors.blue};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0E),
      body: RustScreenLayout(
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _buildWeaponSelector(),
                      _buildVisualizer(),
                      _buildControls(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isSmall = ScreenUtilHelper.isSmallDevice;
    return Container(
      height: isSmall ? 50.h : 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0E),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1.w,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left: Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                HapticHelper.mediumImpact();

                context.go('/tools');
              },
              icon: Icon(LucideIcons.arrowLeft, color: const Color(0xFFA1A1AA), size: isSmall ? 20.w : 22.w),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          
          // Center: Title
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tr('recoil_trainer.title'),
                  style: TextStyle(
                    fontSize: isSmall ? 16.sp : 18.sp, 
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rust', 
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponSelector() {
    final isSmall = ScreenUtilHelper.isSmallDevice;
    final itemWidth = isSmall ? 70.w : 90.w;
    final height = isSmall ? 70.h : 90.h;
    
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: weapons.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final w = weapons[index];
          final isSelected = _selectedWeaponId == w.id;
          return GestureDetector(
            onTap: () {
              HapticHelper.selection();
              setState(() {
                _selectedWeaponId = w.id;
                _updateWeapon();
                _reset();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: itemWidth,
              padding: EdgeInsets.all(isSmall ? 6.w : 8.w),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF18181B) : const Color(0xFF09090B),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected ? const Color(0xFFF97316) : const Color(0xFF27272A),
                  width: 1.5.w,
                ),
                boxShadow: isSelected? [BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10)] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: isSelected ? 1.0 : 0.4,
                      child: Image.asset(w.imageUrl, fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  FittedBox(
                    child: Text(
                      w.name.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF71717A),
                        fontSize: isSmall ? 8.sp : 9.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVisualizer() {
    final isSmall = ScreenUtilHelper.isSmallDevice;
    final height = isSmall ? 280.h : 370.h;
    
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(vertical: isSmall ? 8.h : 12.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFF27272A), width: 4.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Static Grid Layer
          const Positioned.fill(
            child: RepaintBoundary(
              child: _StaticGridLayer(),
            ),
          ),

          // 2. Pattern Visualizer (Dynamic)
          RepaintBoundary(
            child: ValueListenableBuilder<int>(
              valueListenable: _shotIndexNotifier,
              builder: (context, shotIndex, _) {
                return _PatternPainterLayer(
                  weapon: _weapon,
                  shotIndex: shotIndex,
                  showControl: _showControl,
                  scale: _dynamicScale,
                );
              },
            ),
          ),

          // 3. CRT Effects (Optimized Layer)
          const Positioned.fill(
            child: RepaintBoundary(
              child: _StaticEffectsLayer(),
            ),
          ),

          // 4. Overlays
          Positioned(
            top: 12.h,
            left: 12.w,
            child: _buildModeToggle(),
          ),

          Positioned(
            top: 12.h,
            right: 12.w,
            child: ValueListenableBuilder<int>(
              valueListenable: _shotIndexNotifier,
              builder: (context, shotIndex, _) {
                final hint = _getDynamicHint(shotIndex);
                return _buildHintOverlay(hint);
              },
            ),
          ),

          // 5. Shot Progress (Center Bottom)
          Positioned(
            bottom: 12.h,
            left: 0,
            right: 0,
            child: Center(
              child: ValueListenableBuilder<int>(
                valueListenable: _shotIndexNotifier,
                builder: (context, shotIndex, _) {
                  return _buildShotProgressOverlay(shotIndex);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrtEffects() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [Colors.white.withOpacity(0.05), Colors.transparent],
            ),
          ),
          child: CustomPaint(
            painter: _CrtScanlinePainter(),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _GridPainter(),
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return InkWell(
      onTap: () {
        HapticHelper.soft();
        setState(() => _showControl = !_showControl);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _showControl ? LucideIcons.mousePointer2 : LucideIcons.crosshair,
              color: _showControl ? Colors.green : Colors.red,
              size: 14.w,
            ),
            SizedBox(width: 6.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tr(_showControl ? 'recoil_trainer.mouse_move' : 'recoil_trainer.impact_point').toUpperCase(),
                  style: TextStyle(
                    color: _showControl ? Colors.green : Colors.red,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintOverlay(Map<String, dynamic> hint) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: (hint['color'] as Color).withOpacity(0.2), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(hint['icon'] as IconData, color: hint['color'] as Color, size: 16.w),
          SizedBox(width: 8.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 120.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                (hint['text'] as String).toUpperCase(),
                style: TextStyle(color: hint['color'] as Color, fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShotProgressOverlay(int shotIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${tr('recoil_trainer.shot')} ${shotIndex + 1}/${_weapon.pattern.length}'.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 9.sp,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: 100.w,
          height: 4.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r),
            boxShadow: [
              BoxShadow(color: const Color(0xFFF97316).withOpacity(0.1), blurRadius: 4),
            ],
          ),
          child: LinearProgressIndicator(
            value: shotIndex / (_weapon.pattern.length - 1),
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation(Color(0xFFF97316)),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    final isSmall = ScreenUtilHelper.isSmallDevice;
    return Container(
      padding: EdgeInsets.all(isSmall ? 12.w : 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF111114),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_weapon.name.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: isSmall ? 14.sp : 16.sp, fontWeight: FontWeight.w900)),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      _buildInfoBadge('${_weapon.rpm} RPM'),
                      SizedBox(width: 6.w),
                      _buildDifficultyBadge(_weapon.difficulty),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isSmall ? 12.h : 20.h),
          Row(
            children: [
              _buildControlBtn(
                onTap: () {
                  HapticHelper.soft();
                  setState(() {
                    if (_speedMultiplier == 1.0) _speedMultiplier = 0.5;
                    else if (_speedMultiplier == 0.5) _speedMultiplier = 0.25;
                    else _speedMultiplier = 1.0;
                    if (_isPlaying) _startAnimation();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.zap, size: 16.w, color: _speedMultiplier < 1.0 ? Colors.blue : const Color(0xFF71717A)),
                    Text('${_speedMultiplier}X', style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w900, color: _speedMultiplier < 1.0 ? Colors.blue : const Color(0xFF71717A))),
                  ],
                ),
                width: isSmall ? 50.w : 60.w,
                isActive: _speedMultiplier < 1.0,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildControlBtn(
                  onTap: () {
                    HapticHelper.heavyImpact();
                    _togglePlay();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isPlaying ? LucideIcons.pause : LucideIcons.flame, color: _isPlaying ? Colors.white : Colors.black, size: 18.w),
                      SizedBox(width: 10.w),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tr(_isPlaying ? 'recoil_trainer.pause' : 'recoil_trainer.fire').toUpperCase(),
                            style: TextStyle(color: _isPlaying ? Colors.white : Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                  color: _isPlaying ? const Color(0xFF27272A) : Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              _buildControlBtn(
                onTap: () {
                  HapticHelper.mediumImpact();
                  _reset();
                },
                child: Icon(LucideIcons.rotateCcw, size: 20.w, color: const Color(0xFF71717A)),
                width: isSmall ? 50.w : 60.w,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(color: const Color(0xFF18181B), borderRadius: BorderRadius.circular(4.r)),
      child: Text(text, style: TextStyle(color: const Color(0xFF71717A), fontSize: 9.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDifficultyBadge(RecoilDifficulty difficulty) {
    Color color;
    switch (difficulty) {
      case RecoilDifficulty.easy: color = Colors.green; break;
      case RecoilDifficulty.medium: color = Colors.yellow; break;
      case RecoilDifficulty.hard: color = Colors.red; break;
      case RecoilDifficulty.extreme: color = Colors.deepPurple; break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(color: color.withOpacity(0.1), border: Border.all(color: color.withOpacity(0.5)), borderRadius: BorderRadius.circular(4.r)),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          tr('recoil_trainer.difficulty.${difficulty.name}').toUpperCase(), 
          style: TextStyle(color: color, fontSize: 9.sp, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _buildControlBtn({required VoidCallback onTap, required Widget child, double? width, Color color = const Color(0xFF18181B), bool isActive = false}) {
    final isSmall = ScreenUtilHelper.isSmallDevice;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: isSmall ? 48.h : 54.h,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.1) : color,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: isActive ? Colors.blue.withOpacity(0.3) : Colors.white.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: child,
      ),
    );
  }
}

// --- TOP-LEVEL WIDGETS ---

class _StaticGridLayer extends StatelessWidget {
  const _StaticGridLayer();
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _GridPainter()),
    );
  }
}

class _StaticEffectsLayer extends StatelessWidget {
  const _StaticEffectsLayer();
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Colors.white.withOpacity(0.03), Colors.transparent],
          ),
        ),
        child: CustomPaint(painter: _CrtScanlinePainter()),
      ),
    );
  }
}

class _PatternPainterLayer extends StatelessWidget {
  final RecoilPattern weapon;
  final int shotIndex;
  final bool showControl;
  final double scale;

  const _PatternPainterLayer({
    required this.weapon,
    required this.shotIndex,
    required this.showControl,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          size: const Size(300, 300),
          painter: _RecoilPatternPainter(
            weapon: weapon,
            shotIndex: shotIndex,
            showControl: showControl,
            scale: scale,
          ),
        ),
      ),
    );
  }
}

class _RecoilPatternPainter extends CustomPainter {
  final RecoilPattern weapon;
  final int shotIndex;
  final bool showControl;
  final double scale;

  _RecoilPatternPainter({required this.weapon, required this.shotIndex, required this.showControl, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paintLine = Paint()
      ..color = (showControl ? Colors.green : Colors.red).withOpacity(0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 1. Draw ghost path
    final path = Path();
    for (int i = 0; i < weapon.pattern.length; i++) {
        final offset = _getOffset(weapon.pattern[i], center);
        if (i == 0) path.moveTo(offset.dx, offset.dy);
        else path.lineTo(offset.dx, offset.dy);
    }
    canvas.drawPath(path, paintLine);

    // 2. Draw dots and trail
    for (int i = 0; i <= shotIndex; i++) {
        if (i < shotIndex - 5) continue;

        final offset = _getOffset(weapon.pattern[i], center);
        final isCurrent = i == shotIndex;
        final opacity = isCurrent ? 1.0 : (1.0 - (shotIndex - i) * 0.15);
        
        final color = (showControl ? const Color(0xFF4ade80) : const Color(0xFFf87171)).withOpacity(opacity);
        
        if (i > 0 && i > shotIndex - 5) {
          final prevOffset = _getOffset(weapon.pattern[i-1], center);
          canvas.drawLine(prevOffset, offset, Paint()..color = color..strokeWidth = isCurrent ? 3 : 2);
        }

        canvas.drawCircle(offset, isCurrent ? 5 : 3, Paint()..color = color);
        canvas.drawCircle(offset, isCurrent ? 5 : 3, Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 1);
    }
  }

  Offset _getOffset(RecoilPoint p, Offset center) {
    if (showControl) {
      // Mouse Control Mode: Pull Down to counter recoil (Invert both)
      return Offset(center.dx - (p.x * scale), center.dy + (p.y * scale));
    } else {
      // Impact Mode: Direct visualization of pattern
      return Offset(center.dx + (p.x * scale), center.dy - (p.y * scale));
    }
  }

  @override
  bool shouldRepaint(_RecoilPatternPainter oldDelegate) => 
      oldDelegate.shotIndex != shotIndex || oldDelegate.selectedWeaponId != weapon.id || oldDelegate.showControl != showControl;
}

extension on _RecoilPatternPainter {
  String get selectedWeaponId => weapon.id;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green.withOpacity(0.05)..strokeWidth = 1;
    final centerPaint = Paint()..color = Colors.green.withOpacity(0.15)..strokeWidth = 0.5;
    
    const step = 40.0;
    final midX = size.width / 2;
    final midY = size.height / 2;

    // Background Grid
    for (double i = midX; i < size.width; i += step) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = midX; i > 0; i -= step) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = midY; i < size.height; i += step) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    for (double i = midY; i > 0; i -= step) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);

    // Center Crosshair Lines
    canvas.drawLine(Offset(midX, 0), Offset(midX, size.height), centerPaint);
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), centerPaint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _CrtScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.1)..strokeWidth = 1;
    for (double i = 0; i < size.height; i += 4) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
