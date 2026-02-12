import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/data/models/notification_data.dart';
import 'package:raidalarm/services/alarm_service.dart';
import 'package:raidalarm/data/repositories/settings_repository.dart';
import 'package:raidalarm/data/repositories/notification_repository.dart';
import 'package:raidalarm/data/repositories/attack_statistics_repository.dart';
import 'package:raidalarm/core/router/app_router.dart';
import 'package:raidalarm/services/adapty_service.dart';
import 'package:raidalarm/data/database/app_database.dart';

final notificationProvider = ChangeNotifierProvider((ref) => NotificationProvider(ref));

class NotificationProvider extends ChangeNotifier {
  final Ref _ref;

  NotificationProvider(this._ref);

  AlarmService get _alarmService => _ref.read(alarmServiceProvider);
  AppDatabase get _db => _ref.read(appDatabaseProvider);
  
  NotificationRepository get _notificationRepo => _ref.read(notificationRepoProvider);
  AttackStatisticsRepository get _attackStatsRepo => _ref.read(attackStatsRepoProvider);
  SettingsRepository get _settingsRepo => _ref.read(settingsRepoProvider);
  
  StreamSubscription<bool>? _premiumStatusSubscription;
  
  List<NotificationData> _notifications = [];
  NotificationData? _lastNotification;
  
  int _totalAttackCount = 0;
  DateTime? _lastAttackTime;
  

  bool _hasLifetime = false; // Initial value, updated in initialize
  bool _isInitialized = false;
  
  List<NotificationData> get notifications => List.unmodifiable(_notifications);
  NotificationData? get lastNotification => _lastNotification;
  int get totalAttackCount => _totalAttackCount;
  DateTime? get lastAttackTime => _lastAttackTime;

  bool get hasLifetime => _hasLifetime;
  bool get isAlarmPlaying => _alarmService.isPlaying;
  
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    await _loadNotificationHistory();
    
    // Lifetime: DB-first for instant unlock, then refresh from Adapty in background
    try {
      _hasLifetime = await _db.getBoolSetting('has_lifetime');
    } catch (_) {
      _hasLifetime = _ref.read(adaptyServiceProvider).isPremiumCached;
    }
    notifyListeners();

    // Subscribe to Adapty premium updates (purchase/restore) and self-heal local cache
    await _premiumStatusSubscription?.cancel();
    _premiumStatusSubscription = _ref.read(adaptyServiceProvider).premiumStatusStream.listen((isPremium) async {
      if (isPremium) {
        try {
          await _db.saveAppSetting('has_lifetime', 'true');
        } catch (_) {}
      }
      if (_hasLifetime != isPremium) {
        _hasLifetime = isPremium;
        notifyListeners();
      }
    });

    // Final refresh (may be slow/network) but should be correct; AdaptyService already has DB fallback too.
    _hasLifetime = await _ref.read(adaptyServiceProvider).hasPremiumAccess();
    

    
    
    _isInitialized = true;
  }
  
  
  // Method removed: _checkForNewNotificationsFromDatabase (Legacy polling)
  
  
  Future<void> _loadAttackStatistics() async {
    try {
      // Toplam saldırı ve son saldırı zamanını paralel olarak yükle
      final results = await Future.wait<dynamic>([
        _attackStatsRepo.getTotalAttackCount(),
        _attackStatsRepo.getLastAttackTime(),
      ]);
      
      _totalAttackCount = results[0] as int;
      _lastAttackTime = results[1] as DateTime?;
    } catch (e) {
      // Error loading attack statistics
    }
  }
  
  Future<void> _loadNotificationHistory() async {
    try {
      _notifications = await _notificationRepo.getNotifications();
      
      if (_notifications.isNotEmpty) {
        _lastNotification = _notifications.first;
      }
      
      await _loadAttackStatistics();
    } catch (e) {
      _notifications = [];
      try {
        await _loadAttackStatistics();
      } catch (e2) {
        // Error loading attack statistics
      }
    }
  }
  
  Future<Map<String, int>> getDailyAttackCounts({int days = 7}) async {
    return await _attackStatsRepo.getDailyAttackCounts(days: days);
  }
  
  Future<Map<String, int>> getWeeklyAttackCounts({int weeks = 4}) async {
    return await _attackStatsRepo.getWeeklyAttackCounts(weeks: weeks);
  }
  
  Future<int> getAllWeeklyAttackCountsTotal() async {
    return await _attackStatsRepo.getAllWeeklyAttackCountsTotal();
  }
  
  Future<Map<String, int>> getMonthlyAttackCounts({int months = 6}) async {
    return await _attackStatsRepo.getMonthlyAttackCounts(months: months);
  }
  
  Future<Map<int, int>> getHourlyAttackCounts() async {
    return await _attackStatsRepo.getHourlyAttackCounts();
  }
  
  Future<Map<String, dynamic>> getAttackTrend({int days = 7}) async {
    final dailyCounts = await getDailyAttackCounts(days: days);
    final values = dailyCounts.values.toList();
    
    if (values.length < 2) {
      return {
        'trend': 'stable',
        'percentage': 0.0,
        'direction': 'none',
      };
    }
    
    final firstHalf = values.sublist(0, values.length ~/ 2);
    final secondHalf = values.sublist(values.length ~/ 2);
    
    final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
    
    double percentage = 0.0;
    String trend = 'stable';
    String direction = 'none';
    
    if (firstAvg > 0) {
      percentage = ((secondAvg - firstAvg) / firstAvg) * 100;
      
      if (percentage > 10) {
        trend = 'increasing';
        direction = 'up';
      } else if (percentage < -10) {
        trend = 'decreasing';
        direction = 'down';
      } else {
        trend = 'stable';
        direction = 'none';
      }
    }
    
    return {
      'trend': trend,
      'percentage': percentage.abs(),
      'direction': direction,
      'firstHalfAvg': firstAvg,
      'secondHalfAvg': secondAvg,
    };
  }
  
  Future<AlarmSettings> _loadAlarmSettings() async {
    try {
      return await _settingsRepo.loadAlarmSettings();
    } catch (e) {
      return AlarmSettings(); // Varsayılan ayarlar
    }
  }
  
  
  
  Future<void> clearHistory() async {
    _notifications.clear();
    _lastNotification = null;
    
    try {
      await _notificationRepo.clearHistory();
    } catch (e) {
      // Error clearing history
    }
    
    notifyListeners();
  }
  
  Future<void> stopAlarm() async {
    await _alarmService.stopAlarm();
    notifyListeners();
  }
  
  Future<void> triggerAlarmFromNative(String mode) async {
    try {
      final settings = await _loadAlarmSettings();
      
      switch (mode) {
        case 'vibration':
          settings.mode = AlarmMode.vibration;
          _alarmService.updateSettings(settings);
          break;
          
        default:
          settings.mode = AlarmMode.sound;
          _alarmService.updateSettings(settings);
          break;
      }
    } catch (e) {
      // Error triggering alarm from native
    }
  }
  
  void _navigateToHome() {
    try {
      AppRouter.router.go('/stats?from=dismiss-alarm');
    } catch (e) {
      // Error navigating to home
    }
  }
  

  
  Future<void> updateLifetimeStatus(bool status) async {
    _hasLifetime = status;
    notifyListeners();
    
    // Save to local DB for persistence and instant unlock on next cold start
    try {
      await _db.saveAppSetting('has_lifetime', status ? 'true' : 'false');
    } catch (_) {
      // Silent error
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

