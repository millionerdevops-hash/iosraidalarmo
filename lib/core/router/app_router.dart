import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/screens/splash/splash_screen.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/screens/stats/stats.dart';
import 'package:raidalarm/screens/paywall/paywall.dart';
import 'package:raidalarm/screens/settings/settings_screen.dart';
import 'package:raidalarm/screens/tools/tools.dart';
import 'package:raidalarm/screens/cctv_codes/cctv_codes_screen.dart';
import 'package:raidalarm/screens/legal/privacy_policy_screen.dart';
import 'package:raidalarm/screens/legal/terms_of_service_screen.dart';
import 'package:raidalarm/screens/raidcalculator/raidcalculator.dart';
import 'package:raidalarm/screens/dieselcalculator/dieselcalculator.dart';
import 'package:raidalarm/screens/teaguide/teacalculator.dart';
import 'package:raidalarm/screens/recoiltrainer/recoiltrainer.dart';
import 'package:raidalarm/screens/matchgame/matchgame.dart';
import 'package:raidalarm/screens/codelock/codelock.dart';
import 'package:raidalarm/screens/pairdevices/pairdevices.dart';
import 'package:raidalarm/widgets/main/main_scaffold.dart';
import 'package:raidalarm/features/auth/steam_login_screen.dart';
import 'package:raidalarm/features/devices/device_pairing_screen.dart';
import 'package:raidalarm/features/automation/automation_list_screen.dart';
import 'package:raidalarm/features/automation/rule_editor_screen.dart';
import 'package:raidalarm/features/automation/automation_info_screen.dart';
import 'package:raidalarm/screens/blackjack/blackjack.dart';
import 'package:raidalarm/screens/bugreport/bugreport.dart';
import 'package:raidalarm/screens/criticalalertpermission/criticalalertpermission.dart';
import 'package:raidalarm/screens/notifypermission/notificationpermissionscreen.dart';
import 'package:raidalarm/screens/socialproof/socialproof.dart';
import 'package:raidalarm/screens/howitworks/howitworks.dart';
import 'package:raidalarm/screens/getstarted/getstarted.dart';

final routerProvider = Provider((ref) => AppRouter.router);

class AppRouter {
  static const _intentChannel = MethodChannel('com.raidalarm/intent');
  
  static const String _intentGoToHome = 'com.raidalarm.GO_TO_HOME';
  static const String _intentTriggerAlarm = 'com.raidalarm.TRIGGER_ALARM';
  static const String _intentDismissAlarm = 'com.raidalarm.DISMISS_ALARM';
  static const String _pathSplash = '/splash';
  static const String _pathPaywall = '/paywall';
  static const String _pathStats = '/stats';
  static const String _pathTools = '/tools';
  static const String _pathPairDevices = '/pair-devices';
  static const String _pathSettings = '/settings';
  static const String _pathPrivacyPolicy = '/privacy-policy';
  static const String _pathTermsOfService = '/terms-of-service';
  static const String _pathCCTVCodes = '/cctv-codes';
  static const String _pathRaidCalculator = '/raid-calculator';
  static const String _pathTeaCalculator = '/tea-calculator';
  static const String _pathDieselCalculator = '/diesel-calculator';
  static const String _pathRecoilTrainer = '/recoil-trainer';
  static const String _pathMatchGame = '/match-game';
  static const String _pathCodeRaider = '/code-raider';
  static const String _queryFromDismissAlarm = 'dismiss-alarm';
  static const String _pathSteamLogin = '/steam-login';
  static const String _pathServerDashboardBase = '/server'; 
  static const String _pathAutomation = 'automation';
  static const String _pathAutomationAdd = 'add';
  static const String _pathAutomationInfo = 'info';
  static const String _pathDevicePairing = '/device-pairing';
  static const String _pathBlackjack = '/blackjack';
  static const String _pathBugReport = '/bug-report';
  static const String _pathCriticalAlertPermission = '/critical-alert-permission';
  static const String _pathNotifyPermission = '/notify-permission';
  static const String _pathSocialProof = '/social-proof';
  static const String _pathHowItWorks = '/how-it-works';
  static const String _pathGetStarted = '/get-started';

  static final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: _pathSplash,
    observers: [routeObserver],
    redirect: (context, state) => _handleRedirect(context, state),
    routes: [
      GoRoute(
        path: _pathSplash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: _pathPaywall,
        name: 'paywall',
        pageBuilder: (context, state) {
          final isOffer = state.uri.queryParameters['isOffer'] == 'true';
          return CustomTransitionPage(
            key: state.pageKey,
            child: PaywallScreen(
              isOffer: isOffer,
              onPurchaseComplete: () async {
                await AppDatabase().saveAppSetting('paywall_completed', 'true');
                if (context.mounted) context.go(_pathStats);
              },
            onSkip: () async {
              // Don't save paywall_completed so it shows again next launch
              if (context.mounted) {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(_pathStats);
                }
              }
            },
            onPrivacyPolicy: () => context.push(_pathPrivacyPolicy),
            onTerms: () => context.push(_pathTermsOfService),
          ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
      ),
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = 0; // Default: STATS/ALARM
          final path = state.uri.path;
          if (path == _pathStats) {
            currentIndex = 0; // ALARM
          } else if (path == _pathTools) {
            currentIndex = 1; // TOOLS
          } else if (path == _pathPairDevices) {
            currentIndex = 2; // PAIR DEVICES
          }
          
          return MainScaffold(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: _pathStats,
            name: 'stats',
            builder: (context, state) => const StatsScreen(),
          ),
          GoRoute(
            path: _pathTools,
            name: 'tools',
            builder: (context, state) => const ToolsScreen(),
          ),
          GoRoute(
            path: _pathPairDevices,
            name: 'pair-devices',
            builder: (context, state) => const PairDevicesScreen(),
          ),
        ],
      ),
      // Standalone routes (not in bottom navigation)
      GoRoute(
        path: _pathSettings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: _pathPrivacyPolicy,
        name: 'privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: _pathTermsOfService,
        name: 'terms-of-service',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        path: _pathCCTVCodes,
        name: 'cctv-codes',
        builder: (context, state) => const CCTVCodesScreen(),
      ),
      GoRoute(
        path: _pathRaidCalculator,
        name: 'raid-calculator',
        builder: (context, state) => const RaidCalculatorScreen(),
      ),
      GoRoute(
        path: _pathTeaCalculator,
        name: 'tea-calculator',
        builder: (context, state) => const TeaCalculatorScreen(),
      ),
      GoRoute(
        path: _pathDieselCalculator,
        name: 'diesel-calculator',
        builder: (context, state) => const DieselCalculatorScreen(),
      ),
      GoRoute(
        path: _pathRecoilTrainer,
        name: 'recoil-trainer',
        builder: (context, state) => const RecoilTrainerScreen(),
      ),
      GoRoute(
        path: _pathMatchGame,
        name: 'match-game',
        builder: (context, state) => const MatchGameScreen(),
      ),
      GoRoute(
        path: _pathCodeRaider,
        name: 'code_raider',
        builder: (context, state) => const CodeBreakerScreen(),
      ),
      GoRoute(
        path: _pathSteamLogin,
        name: 'steam-login',
        builder: (context, state) => const SteamLoginScreen(),
      ),
      GoRoute(
        path: '$_pathServerDashboardBase/:id/automation',
        name: 'automation-list',
        builder: (context, state) {
          final serverId = int.parse(state.pathParameters['id']!);
          return AutomationListScreen(serverId: serverId);
        },
        routes: [
          GoRoute(
            path: _pathAutomationAdd,
            name: 'automation-add',
            builder: (context, state) {
              final serverId = int.parse(state.pathParameters['id']!);
              final extra = state.extra as Map<String, dynamic>?;
              return RuleEditorScreen(
                serverId: serverId,
                rule: extra?['rule'],
              );
            },
          ),
          GoRoute(
            path: _pathAutomationInfo,
            name: 'automation-info',
            builder: (context, state) => const AutomationInfoScreen(),
          ),
        ],
      ),
    GoRoute(
        path: _pathDevicePairing,
        name: 'device-pairing',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DevicePairingScreen(
            serverId: extra['serverId'],
            entityId: extra['entityId'],
            entityType: extra['entityType'],
          );
        },
      ),
      GoRoute(
        path: _pathBlackjack,
        name: 'blackjack',
        builder: (context, state) => const BlackjackScreen(),
      ),
      GoRoute(
        path: _pathBugReport,
        name: 'bug-report',
        builder: (context, state) => const BugReportScreen(),
      ),
      GoRoute(
        path: _pathCriticalAlertPermission,
        name: 'critical-alert-permission',
        builder: (context, state) => const CriticalAlertPermissionScreen(),
      ),
      GoRoute(
        path: _pathNotifyPermission,
        name: 'notify-permission',
        builder: (context, state) => const NotificationPermissionScreen(),
      ),
      GoRoute(
        path: _pathSocialProof,
        name: 'social-proof',
        builder: (context, state) => const SocialProofScreen(),
      ),
      GoRoute(
        path: _pathHowItWorks,
        name: 'how-it-works',
        builder: (context, state) => const HowItWorksScreen(),
      ),
      GoRoute(
        path: _pathGetStarted,
        name: 'get-started',
        builder: (context, state) => const GetStartedScreen(),
      ),
    ],
  );

  static Future<String?> _handleRedirect(BuildContext context, GoRouterState state) async {
    final location = state.uri.path;

    if (location == _pathSplash) {
      if (Platform.isAndroid) {
        try {
          final String? intentAction = await _intentChannel.invokeMethod<String>('getIntentAction');
          
          if (intentAction == _intentGoToHome) {
            final bool? fromAlarmDismiss = await _intentChannel.invokeMethod<bool>('getIntentExtra', 'from_alarm_dismiss');
            if (fromAlarmDismiss == true) {
              return '$_pathStats?from=$_queryFromDismissAlarm';
            }
            return _pathStats;
          }
          
          if (intentAction == _intentTriggerAlarm) {
            return _pathStats;
          }
          
          if (intentAction == _intentDismissAlarm) {
            return '$_pathStats?from=$_queryFromDismissAlarm';
          }
        } catch (e) {
        }
      }
      return null;
    }

    return null;
  }
}
