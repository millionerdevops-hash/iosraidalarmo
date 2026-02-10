import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/theme/app_theme.dart';
import 'package:raidalarm/core/constants/app_constants.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/core/router/app_router.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/providers/player_tracking_provider.dart';
import 'package:raidalarm/services/alarm_service.dart';

class RaidAlarmApp extends ConsumerStatefulWidget {
  const RaidAlarmApp({super.key});

  @override
  ConsumerState<RaidAlarmApp> createState() => _RaidAlarmAppState();
}

class _RaidAlarmAppState extends ConsumerState<RaidAlarmApp> {
  bool _providersInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (!_providersInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeProviders(context);
            _providersInitialized = true;
          });
        }
        
        return ScreenUtilInit(
          designSize: ScreenUtilHelper.designSize,
          minTextAdapt: ScreenUtilHelper.minTextAdapt,
          builder: (context, child) {
            return MaterialApp.router(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              routerConfig: AppRouter.router,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: (context, child) => child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }

  void _initializeProviders(BuildContext context) {
    unawaited(_initializeNotificationProvider(context));
  }

  Future<void> _initializeNotificationProvider(BuildContext context) async {
    try {
      if (!context.mounted) return;
      final notifProvider = ref.read(notificationProvider);
      await notifProvider.initialize();
      
      final trackingProvider = ref.read(playerTrackingProvider);
      trackingProvider.loadPlayers();
    } catch (_) {
    }
  }
}
