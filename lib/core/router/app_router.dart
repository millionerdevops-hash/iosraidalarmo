import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/screens/splash/splash_screen.dart';
import 'package:raidalarm/screens/stats/stats.dart';
import 'package:raidalarm/screens/paywall/paywall.dart';
import 'package:raidalarm/screens/settings/settings_screen.dart';
import 'package:raidalarm/screens/server/serverinfo.dart';
import 'package:raidalarm/screens/tools/tools.dart';
import 'package:raidalarm/screens/cctv_codes/cctv_codes_screen.dart';
import 'package:raidalarm/screens/legal/privacy_policy_screen.dart';
import 'package:raidalarm/screens/legal/terms_of_service_screen.dart';
import 'package:raidalarm/screens/raidcalculator/raidcalculator.dart';
import 'package:raidalarm/screens/dieselcalculator/dieselcalculator.dart';
import 'package:raidalarm/screens/teaguide/teacalculator.dart';
import 'package:raidalarm/screens/playersearch/playersearch.dart';
import 'package:raidalarm/screens/serverstatus/serverstatus.dart';
import 'package:raidalarm/screens/serversearch/serversearch.dart';
import 'package:raidalarm/screens/serverdetail/serverdetail.dart';
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

final routerProvider = Provider((ref) => AppRouter.router);

class AppRouter {
  static const _intentChannel = MethodChannel('com.raidalarm/intent');
  
  static const String _intentGoToHome = 'com.raidalarm.GO_TO_HOME';
  static const String _intentTriggerAlarm = 'com.raidalarm.TRIGGER_ALARM';
  static const String _intentDismissAlarm = 'com.raidalarm.DISMISS_ALARM';
  static const String _pathSplash = '/splash';
  static const String _pathPaywall = '/paywall';
  static const String _pathInfo = '/info';
  static const String _pathStats = '/stats';
  static const String _pathTools = '/tools';
  static const String _pathPairDevices = '/pair-devices';
  static const String _pathSettings = '/settings';
  static const String _pathPrivacyPolicy = '/privacy-policy';
  static const String _pathTermsOfService = '/terms-of-service';
  static const String _pathCCTVCodes = '/cctv-codes';
  static const String _pathRaidCalculator = '/raid-calculator';
  static const String _pathPlayerSearch = '/player-search';
  static const String _pathServerStatus = '/server-status';
  static const String _pathServerSearch = '/server-search';
  static const String _pathServerDetail = '/server-detail';
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

  static final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  static final GoRouter router = GoRouter(
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
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: PaywallScreen(
            onPurchaseComplete: () => context.go(_pathStats),
            onSkip: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(_pathStats);
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
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = 0; // Default: INFO (left)
          final path = state.uri.path;
          if (path == _pathInfo) {
            currentIndex = 0; // INFO (left)
          } else if (path == _pathStats) {
            currentIndex = 1; // ALARM (middle)
          } else if (path == _pathTools) {
            currentIndex = 2; // TOOLS (right)
          } else if (path == _pathPairDevices) {
            currentIndex = 3; // PAIR DEVICES
          }
          
          return MainScaffold(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: _pathInfo,
            name: 'info',
            builder: (context, state) => const ServerInfoScreen(),
          ),
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
        path: _pathPlayerSearch,
        name: 'player-search',
        builder: (context, state) => const PlayerSearchScreen(),
      ),

      GoRoute(
        path: _pathServerStatus,
        name: 'server-status',
        builder: (context, state) => const ServerStatusScreen(),
      ),
      GoRoute(
        path: _pathServerSearch,
        name: 'server-search',
        builder: (context, state) => const ServerSearchScreen(),
      ),
      GoRoute(
        path: _pathServerDetail,
        name: 'server-detail',
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'];
          return ServerDetailScreen(initialTab: tab ?? 'OVERVIEW');
        },
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
