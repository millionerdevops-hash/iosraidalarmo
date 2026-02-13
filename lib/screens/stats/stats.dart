import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/home/index.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart'; // Added import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/data/repositories/attack_statistics_repository.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/services/alarm_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Data State
  int _totalAttackCount = 0;
  DateTime? _lastAttackTime;
  
  // Chart Data State
  Map<String, int> _dailyCounts = {};
  Map<String, int> _weeklyCounts = {}; // Note: Repository likely returns daily counts for the last week
  Map<String, int> _monthlyCounts = {};
  Map<int, int> _hourlyCounts = {};
  
  // Repositories & Helpers
  AttackStatisticsRepository get _attackStatsRepo => ref.read(attackStatsRepoProvider);
  
  // Optimization: Debouncing & Caching
  DateTime? _lastRefreshCallTime;
  static const Duration _refreshDebounceDuration = Duration(milliseconds: 300);
  bool _isRefreshing = false;
  
  // App Lifecycle for resume updates
  AppLifecycleState? _appLifecycleState;



  @override
  void initState() {
    super.initState();
    
    _setupAnimations();
    
    WidgetsBinding.instance.addObserver(this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouterState.of(context);
      final isFromAlarmDismiss = state.uri.queryParameters['from'] == 'dismiss-alarm';
      
      if (isFromAlarmDismiss) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _initializeAfterContextReady();
        });
      } else {
        _initializeAfterContextReady();
      }
    });
  }

  void _initializeAfterContextReady() {
    if (!mounted) return;
    
    _refreshFromSQLite();
    
    // Listen to provider changes for real-time updates
    // Note: With Riverpod, we can use ref.listen in build, 
    // but for manual refresh like this, we'll keep the logic or adapt.
    // Actually, ref.watch in build is better for most cases.
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _appLifecycleState = state;
    if (state == AppLifecycleState.resumed) {
      // Add a small delay on resume to ensure native DB ops are finished
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _refreshFromSQLite();
      });
    }
  }



  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );


    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _refreshFromSQLite() async {
    if (!mounted) return;
    
    // Debounce
    final now = DateTime.now();
    if (_lastRefreshCallTime != null && 
        now.difference(_lastRefreshCallTime!) < _refreshDebounceDuration) {
      return;
    }
    _lastRefreshCallTime = now;
    
    if (_isRefreshing) return;
    _isRefreshing = true;
    
    try {
      final results = await Future.wait([
        _attackStatsRepo.getTotalAttackCount(),
        _attackStatsRepo.getLastAttackTime(),
        _attackStatsRepo.getDailyAttackCounts(), 
        _attackStatsRepo.getWeeklyAttackCounts(),
        _attackStatsRepo.getMonthlyAttackCounts(),
        _attackStatsRepo.getHourlyAttackCounts(),
      ]);
      
      if (!mounted) return;
      
      final totalCount = results[0] as int;
      final lastAttackTime = results[1] as DateTime?;
      final dailyData = results[2] as Map<String, int>; 
      
      final monthlyData = results[4] as Map<String, int>;
      final hourlyData = results[5] as Map<int, int>;
      
      if (totalCount != _totalAttackCount || _lastAttackTime != lastAttackTime) {
        setState(() {
          _totalAttackCount = totalCount;
          _lastAttackTime = lastAttackTime;
          _dailyCounts = dailyData;
          _monthlyCounts = monthlyData;
          _hourlyCounts = hourlyData;
        });
      }
    } catch (e) {

    } finally {
      if (mounted) _isRefreshing = false;
    }
  }
  
  Future<void> _refreshFromSQLiteFast() async {
    if (!mounted) return;
    
    // Debounce
    final now = DateTime.now();
    if (_lastRefreshCallTime != null && 
        now.difference(_lastRefreshCallTime!) < _refreshDebounceDuration) {
      return;
    }
    _lastRefreshCallTime = now;
    
    try {
      final provider = ref.read(notificationProvider);
      final totalCount = provider.totalAttackCount;
      final lastAttackTime = provider.lastAttackTime;
      
      if (totalCount != _totalAttackCount || _lastAttackTime != lastAttackTime) {
         setState(() {
          _totalAttackCount = totalCount;
          _lastAttackTime = lastAttackTime;
        });
      }
    } catch(e) {
       // fallback to full refresh if provider fails
       _refreshFromSQLite();
    }
  }




  void _handleStopAlarm() {
    HapticHelper.lightImpact();
    ref.read(notificationProvider).stopAlarm();
  }
  @override
  Widget build(BuildContext context) {
    return RustScreenLayout(
      child: Container(
        color: const Color(0xFF09090B),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                        child: Column(
                          children: [
                            // CARD 1: ATTACK STATISTICS WIDGET
                            AttackStatsWidget(
                              totalAttacks: _totalAttackCount,
                              lastAttackTime: _lastAttackTime,
                            ),
                            ScreenUtilHelper.sizedBoxHeight(16),
 
                            // CARD 2: TRAFFIC CHART WIDGET
                            AttackTrafficWidget(
                              dailyCounts: _dailyCounts, // Used for 'Week' view (days)
                              weeklyCounts: {}, // Not used directly in new V2 logic (we generate mon-sun from dailyCounts)
                              monthlyCounts: _monthlyCounts,
                              hourlyCounts: _hourlyCounts,
                            ),
                            ScreenUtilHelper.sizedBoxHeight(8),

                            // STOP ALARM BUTTON (Visible only when alarm is playing)
                            _buildAlarmStopButton(),
                            

                            ScreenUtilHelper.sizedBoxHeight(12),
                          ],
                        ),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64.h,
      padding: ScreenUtilHelper.paddingHorizontal(16),
      decoration: BoxDecoration(
        color: const Color(0xFF09090B),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered Logo
          Center(
            child: Image.asset(
              'assets/logo/raidalarm-logo2.png',
              height: 80.w,
              fit: BoxFit.contain,
              cacheWidth: 160,
            ),
          ),
          // Settings button positioned on the right
          Positioned(
            right: 0,
            child: Material(
            color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticHelper.lightImpact();
                  context.push('/settings');
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.settings,
                    size: 20.w,
                    color: const Color(0xFFA1A1AA),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildAlarmStopButton() {
    final provider = ref.watch(notificationProvider);
    if (!provider.isAlarmPlaying) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 0.h),
      child: GestureDetector(
        onTap: _handleStopAlarm,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626), // Red 600
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFEF4444).withOpacity(0.5),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDC2626).withOpacity(0.4),
                blurRadius: 30.0,
                spreadRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.stop_circle_outlined,
                size: 22.sp,
                color: Colors.white,
              ),
              ScreenUtilHelper.sizedBoxWidth(8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tr('home.alarm.stop'),
                    style: RustTypography.rustStyle(
                      fontSize: 12.sp,
                      weight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 2.0.w,
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

