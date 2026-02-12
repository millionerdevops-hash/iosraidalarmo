import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/widgets/server/active_server_widget.dart';
import 'package:raidalarm/widgets/server/tracked_targets_widget.dart';
import 'package:raidalarm/widgets/tools/tools_menu_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/player_tracking_provider.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/widgets/player/playerdetailsheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

/// Server Info Screen - Sunucu bilgileri sekmesi
/// React Native: InfoTab.tsx
class ServerInfoScreen extends ConsumerStatefulWidget {
  const ServerInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ServerInfoScreen> createState() => _ServerInfoScreenState();
}

class _ServerInfoScreenState extends ConsumerState<ServerInfoScreen> with WidgetsBindingObserver {
  final AppDatabase _db = AppDatabase();
  // Removed animation controllers

  Future<ServerData?>? _activeServerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshServer();
    // Start auto-refresh for player tracking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playerTrackingProvider).startAutoRefresh();
    });
  }
  
  @override
  void dispose() {
    // ref.read(playerTrackingProvider).stopAutoRefresh(); // Removed to prevent "Bad state: Cannot use ref after widget is disposed"
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(playerTrackingProvider).startAutoRefresh();
    } else if (state == AppLifecycleState.paused) {
      ref.read(playerTrackingProvider).stopAutoRefresh();
    }
  }

  void _refreshServer() {
    setState(() {
      _activeServerFuture = _loadServer();
    });
  }

  Future<ServerData?> _loadServer() async {
    final Map<String, dynamic>? data = await _db.getActiveServer();
    if (!mounted) return null;
    
    if (data != null) {
      final server = ServerData.fromJson(data);
      // Load tracked players using provider
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(playerTrackingProvider).loadPlayers();
        }
      });
      return server;
    }
    return null;
  }



  Future<void> _handleServerSelection() async {
    HapticHelper.mediumImpact();
    final result = await context.push('/server-search');
    if (!mounted) return;
    if (result == true) {
      _refreshServer();
    }
  }

  void _showPlayerDetailSheet(BuildContext context, TrackedTarget target) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlayerDetailSheet(
        playerName: target.name,
        playerId: target.playerId,
        isOnline: target.isOnline,
        lastSeen: target.lastSeen,
        initialNotifyOnOnline: target.hasAlert,
        initialNotifyOnOffline: target.notifyOnOffline,
        onUpdate: (notifyOnOnline, notifyOnOffline) async {
          // Update notification settings in database
          await ref.read(playerTrackingProvider).trackPlayer(
            target.playerId ?? '', 
            target.name, 
            target.isOnline,
            notifyOnOnline: notifyOnOnline,
            notifyOnOffline: notifyOnOffline,
            lastSeen: target.lastSeen,
          );
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RustScreenLayout(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _ServerInfoHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: ScreenUtilHelper.paddingSymmetric(horizontal: 16, vertical: 16),
                  child: Column(
                        children: [
                          // ACTIVE SERVER WIDGET
                          FutureBuilder<ServerData?>(
                            future: _activeServerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  height: 160.h, 
                                  child: const Center(child: CircularProgressIndicator(color: Color(0xFFF97316)))
                                );
                              }

                              final server = snapshot.data;
                              
                              return ActiveServerWidget(
                                server: server,
                                onEmptyTap: _handleServerSelection,
                              );
                            },
                          ),
                          
                          ScreenUtilHelper.sizedBoxHeight(16),

                          // TRACKED TARGETS
                          TrackedTargetsWidget(
                            targets: ref.watch(playerTrackingProvider).trackedPlayers,
                            onRemove: (target) async {
                              HapticHelper.mediumImpact();
                              // Show confirmation dialog before deleting
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: const Color(0xFF18181B),
                                  title: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(tr('server.targets.stop_tracking.title'), style: const TextStyle(color: Colors.white))
                                  ),
                                  content: Text(
                                    tr('server.targets.stop_tracking.confirm', args: [target.name]),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(tr('server.targets.stop_tracking.cancel'), style: const TextStyle(color: Colors.white54))
                                      ),
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                    ),
                                    TextButton(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(tr('server.targets.stop_tracking.button'), style: const TextStyle(color: Color(0xFFEF4444)))
                                      ),
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await ref.read(playerTrackingProvider).untrackPlayer(target.name);
                              }
                            },
                            onSearchPlayers: () async {
                              HapticHelper.mediumImpact();
                              final server = await _db.getActiveServer();
                              if (server != null && mounted) {
                                context.push('/server-detail?tab=TARGETS').then((_) => _refreshServer());
                                ref.read(playerTrackingProvider).loadPlayers();
                              } else if (mounted) {
                                _handleServerSelection();
                              }
                            },
                            onTap: (target) {
                              HapticHelper.mediumImpact();
                              _showPlayerDetailSheet(context, target);
                            },
                          ),
                          ScreenUtilHelper.sizedBoxHeight(16),

                          // DISCOVERY CARDS
                          _ServerDiscoverySection(
                            onFindServer: _handleServerSelection,
                            onFindPlayer: () {
                              HapticHelper.mediumImpact();
                              context.push('/player-search');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _ServerInfoHeader extends StatelessWidget {
  const _ServerInfoHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      width: double.infinity,
      padding: ScreenUtilHelper.paddingHorizontal(16),
      decoration: BoxDecoration(
        color: const Color(0xFF09090B),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1.h,
          ),
        ),
      ),
      child:           Center(
        child: Image.asset(
          'assets/logo/raidalarm-logo2.png',
              height: 80.w,
          fit: BoxFit.contain,
          cacheWidth: 160,
        ),
      ),
    );
  }
}

class _ServerDiscoverySection extends StatelessWidget {
  final VoidCallback onFindServer;
  final VoidCallback onFindPlayer;

  const _ServerDiscoverySection({
    required this.onFindServer,
    required this.onFindPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FIND SERVER
        ToolsMenuCard(
          title: tr('server.discovery.find_server.title'),
          subtitle: tr('server.discovery.find_server.subtitle'),
          icon: Icons.public,
          imageUrl: 'assets/images/jpg/searchserver.jpg',
          onClick: onFindServer,
          color: const Color(0xFF22C55E),
          height: 100.h,
        ),
        ScreenUtilHelper.sizedBoxHeight(12),

        // FIND PLAYER
        ToolsMenuCard(
          title: tr('server.discovery.find_player.title'),
          subtitle: tr('server.discovery.find_player.subtitle'),
          icon: Icons.search,
          imageUrl: 'assets/images/jpg/findplayer.jpg',
          onClick: onFindPlayer,
          color: const Color(0xFFA855F7),
          height: 100.h,
        ),
      ],
    );
  }
}

