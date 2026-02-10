import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/widgets/ads/banner_ad_widget.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  late int _currentIndex;

  // Performance: Cached color constants
  static const _infoColor = Color(0xFF22C55E);     // green-500
  static const _alarmColor = Color(0xFFEF4444);    // red-500
  static const _toolsColor = Color(0xFF22D3EE);    // cyan-400
  static const _pairColor = Color(0xFFA855F7);     // purple-500 (new)
  static const _inactiveColor = Color(0xFF52525B); // zinc-600
  static const _bgColor = Color(0xFF09090B);       // zinc-950
  static const _borderColor = Color(0xFF18181B);   // zinc-900

  // Performance: Cached background colors (created once)
  static final _infoBgColor = _infoColor.withOpacity(0.1);
  static final _alarmBgColor = _alarmColor.withOpacity(0.1);
  static final _toolsBgColor = _toolsColor.withOpacity(0.1);
  static final _pairBgColor = _pairColor.withOpacity(0.1);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(MainScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _currentIndex = widget.currentIndex;
    }
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;

    HapticHelper.mediumImpact();
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/info'); // INFO
        break;
      case 1:
        context.go('/stats'); // ALARM
        break;
      case 2:
        context.go('/tools'); // TOOLS
        break;
      case 3:
        context.go('/pair-devices'); // PAIR DEVICES
        break;
    }
  }

  // Get active background color (cached with opacity)
  Color _getActiveBackgroundColor(int index) {
    switch (index) {
      case 0:
        return _infoBgColor;
      case 1:
        return _alarmBgColor;
      case 2:
        return _toolsBgColor;
      case 3:
        return _pairBgColor;
      default:
        return _alarmBgColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final bottomNavBarHeight = 60.h; 
    
    return Scaffold(
      body: Stack(
        children: [
          // Layout Column: Content, Ad, Spacer for Nav
          Column(
            children: [
              Expanded(child: widget.child),
              
              // Banner Ad (Self-managing, hides if premium)
              const BannerAdWidget(),
              
              // Spacer for Bottom Navigation Bar
              SizedBox(height: bottomNavBarHeight + bottomPadding),
            ],
          ),
          
          // Bottom Navigation Bar
          
          // Bottom Navigation Bar (Absolute positioned like React Native)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: RepaintBoundary(
                child: Container(
                  height: bottomNavBarHeight,
                  decoration: const BoxDecoration(
                    color: _bgColor, // bg-zinc-950
                    border: Border(
                      top: BorderSide(
                        color: _borderColor, // border-zinc-900
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // justify-around
                    children: [
                      // INFO Tab (index 0)
                      _buildTabButton(
                        index: 0,
                        icon: Icons.public,
                        activeColor: _infoColor,
                      ),

                      // ALARM Tab (index 1 - middle)
                      _buildTabButton(
                        index: 1,
                        icon: Icons.shield,
                        activeColor: _alarmColor,
                      ),
                      
                      // TOOLS Tab (index 2)
                      _buildTabButton(
                        index: 2,
                        icon: Icons.calculate,
                        activeColor: _toolsColor,
                      ),

                      // PAIR Tab (index 3)
                      _buildTabButton(
                        index: 3,
                        icon: Icons.bluetooth,
                        activeColor: _pairColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required IconData icon,
    required Color activeColor,
  }) {
    final isActive = _currentIndex == index;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(16.r), // rounded-2xl
        child: Container(
          width: 80.w, // w-20 = 80px
          height: 60.h, // Match new navbar height
          alignment: Alignment.center,
          child: Container(
            width: 40.w, // w-10 = 40px
            height: 40.h, // h-10 = 40px
            decoration: BoxDecoration(
              color: isActive ? _getActiveBackgroundColor(index) : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r), // rounded-xl
            ),
            child: Icon(
              icon,
              size: 24.w, // w-6 h-6 = 24px
              color: isActive 
                  ? activeColor 
                  : _inactiveColor, // text-zinc-600
              fill: isActive && index == 1 ? 1.0 : 0.0, // fill-current only for ALARM when active
            ),
          ),
        ),
      ),
    );
  }
}