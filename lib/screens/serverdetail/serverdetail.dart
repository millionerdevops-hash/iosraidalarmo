import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/services/battlemetrics.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/core/utils/permission_helper.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/widgets/server/status/serverdetailmanager.dart';
import 'package:raidalarm/widgets/server/detail/serverheader.dart';
import 'package:raidalarm/widgets/server/detail/serveroverviewtab.dart';
import 'package:raidalarm/widgets/server/detail/servermaptab.dart';
import 'package:raidalarm/widgets/server/detail/serverlivetab.dart';
import 'package:raidalarm/widgets/server/detail/servertargetstab.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/widgets/player/playerdetailsheet.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/player_tracking_provider.dart';
import 'package:raidalarm/core/router/app_router.dart';
import 'package:raidalarm/services/local_notification_service.dart';
import 'package:raidalarm/core/utils/connectivity_helper.dart';
import 'package:raidalarm/providers/notification_provider.dart';

class ServerDetailScreen extends ConsumerStatefulWidget {
  final String initialTab;
  
  const ServerDetailScreen({
    super.key, 
    this.initialTab = 'OVERVIEW',
  });

  @override
  ConsumerState<ServerDetailScreen> createState() => _ServerDetailScreenState();
}

class _ServerDetailScreenState extends ConsumerState<ServerDetailScreen> with RouteAware {
  final BattleMetricsApi _api = BattleMetricsApi();
  final AppDatabase _db = AppDatabase();

  late String _activeTab; // 'OVERVIEW' | 'MAP' | 'LIVE' | 'TARGETS'

  ServerData? _server;
  bool _refreshing = false;
  String? _serverError;
  DateTime? _lastRefreshTime; // API Throttle tracking

  // Live Feed State
  List<LogEntry> _logs = [];
  String? _feedError;
  Map<String, String> _playerCache = {};
  bool _isFirstLoad = true;
  Timer? _pollTimer;

  // Favorites
  List<ServerData> _favorites = [];

  // Throttling Locks
  bool _isTogglingFavorite = false;
  bool _isChangingServer = false;

  // Wipe Alert Settings
  bool _wipeAlertEnabled = false;
  int _wipeAlertMinutes = 30;

  // Targets management moved to PlayerTrackingProvider
  String _targetInput = '';
  bool _verifyingTarget = false;
  String? _targetError;

  // Modals
  PlayerDetail? _inspectingPlayer;
  TargetPlayer? _editingTarget;
  bool _loadingPlayerDetails = false;
  Map<String, bool> _tempAlertConfig = {'onOnline': true, 'onOffline': false};
  
  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
    _loadServerData();
    _loadFavorites();
  }

  Future<void> _loadWipeSettings(String serverId) async {
    try {
      final settings = await _db.getWipeAlert(serverId);
      if (settings != null && mounted) {
        setState(() {
          _wipeAlertEnabled = settings['is_enabled'] == 1;
          _wipeAlertMinutes = settings['alert_minutes'];
        });
      }
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route observer
    try {
      final route = ModalRoute.of(context);
      if (route != null) {
        AppRouter.routeObserver.subscribe(this, route);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    try {
      AppRouter.routeObserver.unsubscribe(this);
    } catch (_) {}
    _stopPolling();
    super.dispose();
  }

  @override
  void didPushNext() {
    // Stop polling when we push another screen on top (e.g. Settings, WebView)
    _stopPolling();
  }

  @override
  void didPopNext() {
    // Resume polling when we return to this screen, IF we were on the LIVE tab
    if (_activeTab == 'LIVE' && _server != null) {
      _startPolling(_server!.id);
    }
  }

  Future<void> _loadServerData() async {
    try {
      final data = await _db.getActiveServer();
      if (data != null) {
        final server = ServerData.fromJson(data);
        if (mounted) {
          setState(() => _server = server);
          _refreshServerData(server.id);
          
          // Only start polling if we are on the LIVE tab initially
          if (_activeTab == 'LIVE') {
            _startPolling(server.id);
          }
          
          
          // Load tracked players via provider
          ref.read(playerTrackingProvider).loadPlayers();
          
          // Load wipe settings
          _loadWipeSettings(server.id);
        }
      }
    } catch (e) {

    }
  }

  Future<void> _loadFavorites() async {
    try {
      final favs = await _db.getFavorites();
      if (mounted) {
        setState(() {
          _favorites = favs.map((e) => ServerData.fromJson(e)).toList();
        });
      }
    } catch (e) {

    }
  }

  // _saveFavorites is no longer needed as toggle handles it individually

  // Wipe alert settings logic
  Future<void> _updateWipeAlert() async {
    if (_server == null || _server!.nextWipe == null) return;
    
    final serverId = _server!.id;
    final serverName = _server!.name;
    final nextWipeStr = _server!.nextWipe!;
    
    // Update via Server API
    try {
      await ref.read(playerTrackingProvider).updateWipeAlert(
        serverId: serverId,
        serverName: serverName,
        wipeTime: nextWipeStr,
        alertMinutes: _wipeAlertMinutes,
        isEnabled: _wipeAlertEnabled,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(tr('server.detail.errors.connection'))),
        );
      }
    }
  }

  // Server config save removed - no longer using web API

  // Target loading/saving methods removed as handled by Provider

  void _toggleFavorite() async {
    if (_server == null || _isTogglingFavorite) return;
    
    setState(() => _isTogglingFavorite = true);
    
    try {
      final id = _server!.id;
      final isFav = _favorites.any((f) => f.id == id);
      
      HapticHelper.mediumImpact();
      if (isFav) {
        setState(() => _favorites.removeWhere((f) => f.id == id));
        await _db.removeFavorite(id);
      } else {
        setState(() => _favorites.add(_server!));
        await _db.saveFavorite(_server!.toJson());
      }
    } finally {
      if (mounted) {
        // Add specific delay to prevent accidental double taps
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _isTogglingFavorite = false);
        });
      }
    }
  }

  void _handleBack() {
    if (!mounted) return;
    context.go('/server-search');
  }

  bool get _isFavorite => _server != null && _favorites.any((f) => f.id == _server!.id);

  void _startPolling(String serverId) {
    _stopPolling();
    _fetchLiveFeed(serverId);
    // Poll every 15 seconds while on the LIVE tab for better "Live" feel
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        if (_server != null) { // Ensure _server is not null before accessing its id
          _refreshServerData(_server!.id);
          _fetchLiveFeed(_server!.id);
          // _checkTargets(); // This method does not exist in the provided code, so it's commented out to maintain syntactical correctness.
        }
      }
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _refreshServerData(String serverId) async {
    if (!mounted) return;
    if (_refreshing) return;

    if (mounted) {
      setState(() {
        _refreshing = true;
        _serverError = null;
      });
    }

    // Check internet connection
    final hasInternet = await ConnectivityHelper.hasInternet();
    if (!hasInternet) {
      if (mounted) {
        setState(() => _refreshing = false);
        // Silent return for background refreshes or show snackbar?
        // User explicitly asked for snackbar on API screens.
        ConnectivityHelper.showNoInternetSnackBar(context);
      }
      return;
    }

    try {
      final json = await _api.fetchBattleMetrics('/servers/$serverId');
      if (!mounted) return;
      
      if (json['data'] != null) {
        final newServer = ServerData.fromJson(json['data']);
        setState(() {
          _server = newServer;
          _lastRefreshTime = DateTime.now(); // Update throttle time
        });
        
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('raid_alarm_server', jsonEncode(newServer.toJson()));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _serverError = tr('server.detail.errors.unstable'));
      }

    } finally {
      if (mounted) {
        setState(() => _refreshing = false);
      }
    }
  }

  Future<void> _fetchLiveFeed(String serverId) async {
    // Background polling - maybe don't show snackbar every 15s?
    // But if it's the first load or user-triggered, it's good.
    // For now let's just do it.
    final hasInternet = await ConnectivityHelper.hasInternet();
    if (!hasInternet) return;

    try {
      // Add cachebuster timestamp to bypass proxy cache for truly live data
      final json = await _api.fetchBattleMetrics(
        '/servers/$serverId',
        queryParams: '?include=player'
      );
      if (mounted) {
        setState(() => _feedError = null);
        if (json['included'] != null) {
          _processPlayerDiff(json['included']);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _feedError = tr('server.detail.errors.signal_lost'));
      }
    }
  }

  void _processPlayerDiff(List<dynamic> includedData) {
    final currentPlayers = includedData.where((item) => item['type'] == 'player').toList();
    final Map<String, String> currentMap = {};
    final List<LogEntry> newLogs = [];
    final now = DateTime.now();
    final timeString = DateFormat('HH:mm:ss').format(now);

    for (final p in currentPlayers) {
      final id = p['id']?.toString() ?? '';
      final name = p['attributes']?['name']?.toString() ?? '';
      if (id.isNotEmpty && name.isNotEmpty) {
        currentMap[id] = name;
      }
    }

    // Live feed processing for local UI feedback
    // No longer updating tracked targets here as provider manages them
    
    if (_isFirstLoad) {
      _playerCache = currentMap;
      _isFirstLoad = false;
      // Do not add fake "Recently" logs on first load as it confuses users.
      // We just seed the cache and wait for real changes.
      return;
    }

    // Detect joins
    currentMap.forEach((id, name) {
      if (!_playerCache.containsKey(id)) {
        newLogs.add(LogEntry(
          id: DateTime.now().millisecondsSinceEpoch.toDouble() + (newLogs.length * 0.1),
          text: tr('server.logs.connected'),
          playerName: name,
          playerId: id,
          type: 'join',
          time: timeString,
        ));
      }
    });

    // Detect leaves
    _playerCache.forEach((id, name) {
      if (!currentMap.containsKey(id)) {
        newLogs.add(LogEntry(
          id: DateTime.now().millisecondsSinceEpoch.toDouble() + (newLogs.length * 0.1),
          text: tr('server.logs.disconnected'),
          playerName: name,
          playerId: id,
          type: 'leave',
          time: timeString,
        ));
      }
    });

    _playerCache = currentMap;
    if (newLogs.isNotEmpty && mounted) {
      setState(() {
        _logs = [...newLogs, ..._logs].take(50).toList();
      });
    }
  }

  Future<void> _handleInspectPlayer(String playerId, String playerName) async {
    if (_loadingPlayerDetails || (_inspectingPlayer != null && _inspectingPlayer!.id == playerId)) return;
    
    final isOnlineRealtime = _playerCache.containsKey(playerId);
    
    // Check internet connection
    final hasInternet = await ConnectivityHelper.hasInternet();
    if (!hasInternet) {
      if (!mounted) return;
      ConnectivityHelper.showNoInternetSnackBar(context);
      return;
    }

    setState(() {
      _inspectingPlayer = PlayerDetail(
        id: playerId,
        name: playerName,
        isOnlineRealtime: isOnlineRealtime,
        lastSeen: isOnlineRealtime ? tr('server.logs.just_now') : null,
      );
      _loadingPlayerDetails = true;
    });

    try {
      final json = await _api.fetchBattleMetrics('/players/$playerId');
      final attrs = json['data']?['attributes'];
      if (attrs != null) {
        if (mounted) {
          setState(() {
            _inspectingPlayer = PlayerDetail(
              id: playerId,
              name: playerName,
              isOnlineRealtime: isOnlineRealtime,
              firstSeen: attrs['createdAt'],
              isPrivate: attrs['private'],
              sessionEvents: _logs.where((l) => l.playerId == playerId).length,
              lastSeen: isOnlineRealtime ? tr('server.logs.just_now') : null,
            );
          });
        }
      }
    } catch (e) {

    } finally {
      if (mounted) setState(() => _loadingPlayerDetails = false);
    }
  }

  Future<void> _addOrUpdateTarget(String name, {String? id, bool notifyOnOnline = true, bool notifyOnOffline = false, String? lastSeen}) async {
    final isOnline = _playerCache.values.any((n) => n.toLowerCase() == name.toLowerCase());

    try {
      if (id != null) {
        await ref.read(playerTrackingProvider).trackPlayer(
          id, 
          name, 
          isOnline,
          notifyOnOnline: notifyOnOnline,
          notifyOnOffline: notifyOnOffline,
          lastSeen: lastSeen,
        );
        
        setState(() {
          _inspectingPlayer = null;
          _editingTarget = null;
          // _activeTab = 'TARGETS'; // Removed to prevent unexpected tab switching
        });
      } else {
        // Fallback or search again if ID is missing (usually provided by inspection)

      }
      
      // NEW: Check permissions AFTER adding target
      if (mounted) {
        final hasPermissions = await PermissionHelper.checkAllCriticalPermissions(ref);
        if (!hasPermissions && mounted) {
           context.push('/setup-ready?step=4');
        }
      }
    } catch (e) {

      
      // Show error message to user
      if (mounted && e.toString().contains('Maximum')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                tr('server.detail.tracking.max_limit'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            margin: ScreenUtilHelper.paddingAll(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
      
      // Close modals even on error
      setState(() {
        _inspectingPlayer = null;
        _editingTarget = null;
      });
    }
  }

  Future<void> _verifyAndAddTarget() async {
    if (_targetInput.length < 2 || _server == null) return;

    setState(() {
      HapticHelper.mediumImpact();
      _verifyingTarget = true;
      _targetError = null;
    });

    // Check internet connection
    final hasInternet = await ConnectivityHelper.hasInternet();
    if (!hasInternet) {
      if (mounted) {
        setState(() => _verifyingTarget = false);
        ConnectivityHelper.showNoInternetSnackBar(context);
      }
      return;
    }

    try {
      // Fetch more results to find the exact match within top results
      final params = '?filter[search]=${Uri.encodeComponent(_targetInput)}&filter[servers]=${_server!.id}&page[size]=25';
      final json = await _api.fetchBattleMetrics('/players', queryParams: params);

      if (json['data'] != null && (json['data'] as List).isNotEmpty) {
        final List<dynamic> players = json['data'];
        
        // Look for exact case-insensitive matches
        final exactMatches = players.where(
          (p) => (p['attributes']['name'] as String).toLowerCase() == _targetInput.toLowerCase(),
        ).toList();

        if (exactMatches.isNotEmpty) {
          if (mounted) {
             _showCandidateSelectionSheet(exactMatches);
             setState(() => _targetInput = ''); 
          }
        } else {
           if (mounted) {
             setState(() => _targetError = tr('server.detail.tracking.not_found_exact', args: [_targetInput]));
           }
        }
      } else {
        if (mounted) {
          setState(() => _targetError = tr('server.detail.tracking.not_found_on_server'));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _targetError = tr('server.detail.errors.connection'));
      }

    } finally {
      if (mounted) {
        setState(() => _verifyingTarget = false);
      }
    }
  }

  void _showCandidateSelectionSheet(List<dynamic> candidates) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0C0C0E),
      isScrollControlled: true,
      isDismissible: false, // Prevent closing on tap outside
      enableDrag: false,    // Prevent closing by dragging
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        side: BorderSide(color: const Color(0xFF27272A), width: 1.h),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final isPremium = ref.watch(notificationProvider).hasLifetime;
            
            return Container(
              padding: ScreenUtilHelper.paddingAll(16),
              height: 400.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            tr('server.detail.tracking.select_player'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Geist',
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(LucideIcons.x, color: const Color(0xFF71717A), size: 20.w),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  ScreenUtilHelper.sizedBoxHeight(16.0),
                  Expanded(
                    child: ListView.separated(
                      itemCount: candidates.length,
                      separatorBuilder: (_, __) => Divider(color: const Color(0xFF27272A), height: 1.h),
                      itemBuilder: (context, index) {
                        final p = candidates[index];
                        final attrs = p['attributes'];
                        final pId = p['id'].toString();
                        final pName = attrs['name'] ?? 'Unknown';

                        // Determine player status using _playerCache
                        // Note: _playerCache keys are IDs, values are Names.
                        final isOnline = _playerCache.containsKey(pId);

                        return InkWell(
                          onTap: () {
                            // Premium Check on Selection
                            if (!isPremium) {
                                Navigator.pop(context); // Close sheet first
                                HapticHelper.mediumImpact();
                                context.pushNamed('paywall');
                                return;
                            }

                            Navigator.pop(context);
                            // Determine notification preferences based on status
                            final notifyOnOnline = !isOnline;
                            final notifyOnOffline = isOnline;
                            _addOrUpdateTarget(pName, id: pId, notifyOnOnline: notifyOnOnline, notifyOnOffline: notifyOnOffline);
                          },
                          child: Padding(
                            padding: ScreenUtilHelper.paddingVertical(12),
                            child: Row(
                              children: [
                                  // Online/Offline indicator
                                  Container(
                                    width: 12.w,
                                    height: 12.w,
                                    decoration: BoxDecoration(
                                      color: isOnline ? const Color(0xFF10B981) : const Color(0xFF52525B), // Green for online, Grey for offline
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  ScreenUtilHelper.sizedBoxWidth(12.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          alignment: Alignment.centerLeft,
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            pName,
                                            style: TextStyle(
                                              color: Colors.white, 
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Geist'
                                            )
                                          ),
                                        ),
                                        ScreenUtilHelper.sizedBoxHeight(2.0),
                                        FittedBox(
                                          alignment: Alignment.centerLeft,
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '${tr('player_search.ui.player_id')}: $pId',
                                            style: TextStyle(
                                              color: const Color(0xFF71717A), 
                                              fontSize: 12.sp,
                                              fontFamily: 'Geist'
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(LucideIcons.chevronRight, color: const Color(0xFF52525B), size: 16.w),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _removeTarget() async {
    if (_editingTarget == null) return;
    final name = _editingTarget!.name;
    
    await ref.read(playerTrackingProvider).untrackPlayer(name);
    
    setState(() {
      _editingTarget = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_server == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0C0C0E),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xFFF97316)),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        HapticHelper.mediumImpact();
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0C0E),
        body: RustScreenLayout(
          child: SafeArea(
            bottom: true,
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header
                    ServerHeader(
                      server: _server!,
                      isFavorite: _isFavorite,
                      onToggleFavorite: _toggleFavorite,
                      onNavigate: () {
                        HapticHelper.mediumImpact();
                        _handleBack();
                      },
                    ),

                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C0C0E),
                        border: Border(
                            bottom: BorderSide(
                                color: const Color(0xFF27272A), width: 1.h)),
                      ),
                      child: Row(
                        children: [
                          _TabButton(
                            label: tr('server.detail.tabs.overview'),
                            active: _activeTab == 'OVERVIEW',
                            onTap: () {
                              HapticHelper.mediumImpact();
                              setState(() => _activeTab = 'OVERVIEW');
                              _stopPolling();
                            },
                          ),
                          _TabButton(
                            label: tr('server.detail.tabs.map'),
                            active: _activeTab == 'MAP',
                            onTap: () {
                              HapticHelper.mediumImpact();
                              setState(() => _activeTab = 'MAP');
                              _stopPolling();
                            },
                          ),
                          _TabButton(
                            label: tr('server.detail.tabs.live'),
                            active: _activeTab == 'LIVE',
                            onTap: () {
                              HapticHelper.mediumImpact();
                              setState(() => _activeTab = 'LIVE');
                              if (_server != null) _startPolling(_server!.id);
                            },
                          ),
                          _TabButton(
                            label: tr('server.detail.tabs.targets'),
                            active: _activeTab == 'TARGETS',
                            onTap: () {
                              HapticHelper.mediumImpact();
                              setState(() => _activeTab = 'TARGETS');
                              _stopPolling();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildTabContent(),
                    ),
                  ],
                ),
                if (_inspectingPlayer != null) _buildInspectionModal(),
                if (_editingTarget != null) _buildEditingModal(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 'OVERVIEW':
        return ServerOverviewTab(
          server: _server!,
          onChangeServer: () async {
            if (_isChangingServer) return;
            setState(() => _isChangingServer = true);
            try {
              await _db.clearActiveServer();
              if (mounted) {
                context.go('/server-search');
              }
            } finally {
               if (mounted) {
                 Future.delayed(const Duration(milliseconds: 1000), () {
                   if (mounted) setState(() => _isChangingServer = false);
                 });
               }
            }
          },
          wipeAlertEnabled: _wipeAlertEnabled,
          onToggleWipeAlert: (enabled) async {
            if (_server == null || _server!.nextWipe == null) return;
            
            setState(() => _wipeAlertEnabled = enabled);
            
            // Check permissions first if enabling
            if (enabled) {
              final granted = await LocalNotificationService().requestPermissions();
              if (!granted) {
                if (mounted) setState(() => _wipeAlertEnabled = false);
                return;
              }
            }
            
            await _updateWipeAlert();
          },
          wipeAlertMinutes: _wipeAlertMinutes,
          onSetWipeAlertMinutes: (mins) async {
            setState(() => _wipeAlertMinutes = mins);
            if (_wipeAlertEnabled) {
              await _updateWipeAlert();
            }
          },
        );
      case 'MAP':
        return ServerMapTab(server: _server!);
      case 'LIVE':
        return ServerLiveTab(
          logs: _logs,
          feedError: _feedError,
          onInspectPlayer: _handleInspectPlayer,
        );
      case 'TARGETS':
        return Consumer(
          builder: (context, ref, child) {
            final trackingProvider = ref.watch(playerTrackingProvider);
            return ServerTargetsTab(
              trackedTargets: trackingProvider.trackedPlayers.map((t) => TargetPlayer(
                id: t.playerId,
                name: t.name,
                isOnline: t.isOnline,
                lastSeen: t.lastSeen,
                notifyOnOnline: t.hasAlert,
                notifyOnOffline: t.notifyOnOffline,
              )).toList(),
              targetInput: _targetInput,
              onTargetInputChange: (val) => setState(() => _targetInput = val),
              verifyingTarget: _verifyingTarget,
              onVerifyAndAdd: _verifyAndAddTarget,
              targetError: _targetError,
              onEditTarget: (target) => setState(() => _editingTarget = target),
              onDeleteTarget: (target) async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFF18181B),
                    title: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(tr('server.targets.stop_tracking.title'), style: const TextStyle(color: Colors.white))
                    ),
                    content: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(tr('server.targets.stop_tracking.confirm', args: [target.name]), style: const TextStyle(color: Colors.white70))
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
              onGoToLive: () => setState(() => _activeTab = 'LIVE'),
            );
          }
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildInspectionModal() {
    return GestureDetector(
      onTap: () => setState(() => _inspectingPlayer = null),
      child: Container(
        color: const Color(0xCC000000),
        child: GestureDetector(
          onTap: () {}, // Prevent closing when tapping modal content
          child: Align(
            alignment: Alignment.bottomCenter,
            child: PlayerDetailSheet(
              playerName: _inspectingPlayer!.name,
              playerId: _inspectingPlayer!.id,
              isOnline: _inspectingPlayer!.isOnlineRealtime,
              lastSeen: _inspectingPlayer!.lastSeen,
              initialNotifyOnOnline: !_inspectingPlayer!.isOnlineRealtime,
              initialNotifyOnOffline: _inspectingPlayer!.isOnlineRealtime,
              onUpdate: (onOnline, onOffline) {
                _addOrUpdateTarget(
                  _inspectingPlayer!.name,
                  id: _inspectingPlayer!.id,
                  notifyOnOnline: onOnline,
                  notifyOnOffline: onOffline,
                  lastSeen: _inspectingPlayer!.lastSeen,
                );
              },
              onClose: () => setState(() => _inspectingPlayer = null),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditingModal() {
    return GestureDetector(
      onTap: () => setState(() => _editingTarget = null),
      child: Container(
        color: const Color(0xCC000000),
        child: GestureDetector(
          onTap: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: PlayerDetailSheet(
              playerName: _editingTarget!.name,
              playerId: _editingTarget!.id,
              isOnline: _editingTarget!.isOnline,
              initialNotifyOnOnline: _editingTarget!.notifyOnOnline,
              initialNotifyOnOffline: _editingTarget!.notifyOnOffline,
              onUpdate: (onOnline, onOffline) {
                _addOrUpdateTarget(
                  _editingTarget!.name,
                  id: _editingTarget!.id,
                  notifyOnOnline: onOnline,
                  notifyOnOffline: onOffline,
                  lastSeen: _editingTarget!.lastSeen,
                );
              },
              onClose: () => setState(() => _editingTarget = null),
            ),
          ),
        ),
      ),
    );
  }
}

// Tab Button Widget
class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: ScreenUtilHelper.paddingVertical(12),
          decoration: BoxDecoration(
            color: active ? const Color(0x8018181B) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: active ? const Color(0xFFF97316) : Colors.transparent,
                width: 2.h,
              ),
            ),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: RustTypography.monoStyle(
                  color: active ? Colors.white : const Color(0xFF52525B),
                  fontSize: 10.sp,
                  weight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Player Detail Model
class PlayerDetail {
  final String id;
  final String name;
  final String? firstSeen;
  final bool? isPrivate;
  final int? sessionEvents;
  final bool isOnlineRealtime;

  PlayerDetail({
    required this.id,
    required this.name,
    this.firstSeen,
    this.isPrivate,
    this.sessionEvents,
    required this.isOnlineRealtime,
    this.lastSeen,
  });

  final String? lastSeen;
}
