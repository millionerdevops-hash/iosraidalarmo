import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/steam_login_screen.dart';
import '../../features/home/server_list_screen.dart';
import '../../features/dashboard/server_dashboard_screen.dart';
import '../../features/devices/device_pairing_screen.dart';
import '../../features/automation/automation_list_screen.dart';
import '../../features/automation/rule_editor_screen.dart';
import '../../features/automation/automation_info_screen.dart';
import '../../features/devices/storage_monitor_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ServerListScreen(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => const SteamLoginScreen(),
        ),
        GoRoute(
          path: 'server/:id',
          builder: (context, state) {
             final id = int.parse(state.pathParameters['id']!);
             final extra = state.extra as Map<String, dynamic>?;
             final name = extra?['name'] ?? 'Server';
             return ServerDashboardScreen(serverId: id, serverName: name);
          },
          routes: [
            GoRoute(
              path: 'automation',
              builder: (context, state) {
                final serverId = int.parse(state.pathParameters['id']!);
                return AutomationListScreen(serverId: serverId);
              },
              routes: [
                GoRoute(
                  path: 'add',
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
                  path: 'info',
                  builder: (context, state) => const AutomationInfoScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'pair_device',
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
          path: 'storage/:serverId/:entityId',
          builder: (context, state) {
            final serverId = int.parse(state.pathParameters['serverId']!);
            final entityId = int.parse(state.pathParameters['entityId']!);
            final extra = state.extra as Map<String, dynamic>?;
            final name = extra?['name'] ?? 'Storage Monitor';
            return StorageMonitorScreen(
              serverId: serverId,
              entityId: entityId,
              deviceName: name,
            );
          },
        ),
      ],
    ),
  ],
);
