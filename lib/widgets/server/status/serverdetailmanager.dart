import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raidalarm/services/battlemetrics.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/widgets/server/status/serversearchmanager.dart';
import 'package:raidalarm/widgets/server/detail/serverlivetab.dart';
import 'package:raidalarm/widgets/server/detail/serveroverviewtab.dart';
import 'package:raidalarm/widgets/server/detail/serverheader.dart';
import 'package:raidalarm/widgets/server/detail/serverwipetab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:intl/intl.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

// Log Entry Model
class LogEntry {
  final double id;
  final String text;
  final String playerName;
  final String playerId;
  final String type; // 'join' | 'leave'
  final String time;

  const LogEntry({
    required this.id,
    required this.text,
    required this.playerName,
    required this.playerId,
    required this.type,
    required this.time,
  });
}

class ServerDetailManager extends StatefulWidget {
  final ServerData server;
  final VoidCallback onBack;
  final Function(ServerData?) onSaveServer;
  final bool wipeAlertEnabled;
  final Function(bool) onToggleWipeAlert;
  final int wipeAlertMinutes;

  const ServerDetailManager({
    super.key,
    required this.server,
    required this.onBack,
    required this.onSaveServer,
    required this.wipeAlertEnabled,
    required this.onToggleWipeAlert,
    required this.wipeAlertMinutes,
  });

  @override
  State<ServerDetailManager> createState() => _ServerDetailManagerState();
}

class _ServerDetailManagerState extends State<ServerDetailManager> {
  final BattleMetricsApi _api = BattleMetricsApi();
  final AppDatabase _db = AppDatabase();

  String _activeTab = 'OVERVIEW'; // 'OVERVIEW' | 'LIVE' | 'TARGETS' | 'WIPE'
  List<LogEntry> _logs = [];
  List<dynamic> _trackedTargets = [];
  bool _refreshing = false;
  List<ServerData> _favorites = [];
  Timer? _pollTimer;
  Map<String, String> _playerCache = {};
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    if (_activeTab == 'LIVE') {
      _startPolling();
    }
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  @override
  void didUpdateWidget(ServerDetailManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.server.id != widget.server.id) {
      _stopPolling();
      _isFirstLoad = true;
      _playerCache.clear();
      _logs.clear();
      _refreshServerData();
      if (_activeTab == 'LIVE' || _activeTab == 'TARGETS') {
        _startPolling();
      }
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final favs = await _db.getFavorites();
      if (!mounted) return;
      setState(() {
        _favorites = favs.map((e) => ServerData.fromJson(e)).toList();
      });
    } catch (e) {
      
    }
  }

  // _saveFavorites is no longer needed as toggle handles it individually

  void _toggleFavorite() async {
    final id = widget.server.id;
    final isFav = _favorites.any((f) => f.id == id);
    
    HapticHelper.mediumImpact();
    
    setState(() {
      if (isFav) {
        _favorites.removeWhere((f) => f.id == id);
      } else {
        _favorites.add(widget.server);
      }
    });

    if (isFav) {
      await _db.removeFavorite(id);
    } else {
      await _db.saveFavorite(widget.server.toJson());
    }
  }

  bool get _isFavorite => _favorites.any((f) => f.id == widget.server.id);

  void _startPolling() {
    _stopPolling();
    _fetchLiveFeed();
    // Poll every 30 seconds while on the LIVE tab
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) => _fetchLiveFeed());
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _refreshServerData() async {
    if (mounted) setState(() => _refreshing = true);
    try {
      final json = await _api.fetchBattleMetrics('/servers/${widget.server.id}');
      if (json['data'] != null && mounted) {
        widget.onSaveServer(ServerData.fromJson(json['data']));
      }
    } catch (e) {
      
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  Future<void> _fetchLiveFeed() async {
    if (widget.server.status.toLowerCase() != 'online') return;

    try {
      final json = await _api.fetchBattleMetrics(
        '/servers/${widget.server.id}',
        queryParams: '?include=player',
      );
      if (!mounted) return;
      
      if (json['data'] != null) {
        // Keep server details sync with live feed
        widget.onSaveServer(ServerData.fromJson(json['data']));
      }

      if (json['included'] != null) {
        _processPlayerDiff(json['included']);
      }
    } catch (e) {
      
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

    if (_isFirstLoad) {
      _playerCache = currentMap;
      _isFirstLoad = false;
      // Initial logs
      if (!mounted) return;
      final recentPlayers = currentPlayers.take(4).toList();
      setState(() {
        _logs = recentPlayers.map((p) {
          return LogEntry(
            id: DateTime.now().millisecondsSinceEpoch.toDouble() + (recentPlayers.indexOf(p) * 0.1),
            text: tr('server.logs.connected'),
            playerName: p['attributes']?['name']?.toString() ?? '',
            playerId: p['id']?.toString() ?? '',
            type: 'join',
            time: tr('server.logs.recently'),
          );
        }).toList();
      });
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

  String _formatCountdown(String? isoDate) {
    if (isoDate == null) return tr('server.detail.unknown');
    try {
      final wipeDate = DateTime.parse(isoDate);
      final diff = wipeDate.difference(DateTime.now());
      if (diff.isNegative) return tr('server.detail.overdue');
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      return '${hours}h ${minutes}m';
    } catch (e) {
      return tr('server.detail.unknown');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        _buildHeader(),
        // Tabs
        _buildTabs(),
        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }


  Widget _buildHeader() {
    return ServerHeader(
      server: widget.server,
      isFavorite: _isFavorite,
      onToggleFavorite: _toggleFavorite,
      onNavigate: widget.onBack,
    );
  }


  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0C0C0E),
        border: Border(bottom: BorderSide(color: Color(0xFF27272A))),
      ),
      child: Row(
        children: [
          _TabButton(
            label: tr('server.detail.tabs.overview'),
            icon: LucideIcons.activity,
            active: _activeTab == 'OVERVIEW',
            onTap: () {
              setState(() => _activeTab = 'OVERVIEW');
              _stopPolling();
            },
          ),
          _TabButton(
            label: tr('server.detail.tabs.live'),
            icon: LucideIcons.terminal,
            active: _activeTab == 'LIVE',
            onTap: () {
              setState(() => _activeTab = 'LIVE');
              _startPolling();
            },
          ),
          _TabButton(
            label: tr('server.detail.tabs.targets'),
            icon: LucideIcons.crosshair,
            active: _activeTab == 'TARGETS',
            onTap: () {
              setState(() => _activeTab = 'TARGETS');
              _stopPolling();
            },
          ),
          _TabButton(
            label: tr('server.detail.tabs.wipe'),
            icon: LucideIcons.calendarDays,
            active: _activeTab == 'WIPE',
            onTap: () {
              setState(() => _activeTab = 'WIPE');
              _stopPolling();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_activeTab) {
      case 'OVERVIEW':
        return _buildOverviewTab();
      case 'LIVE':
        return _buildLiveTab();
      case 'TARGETS':
        return _buildTargetsTab();
      case 'WIPE':
        return _buildWipeTab();
      default:
        return const SizedBox();
    }
  }


  Widget _buildOverviewTab() {
    return ServerOverviewTab(
      server: widget.server,
      onChangeServer: widget.onBack,
      wipeAlertEnabled: widget.wipeAlertEnabled,
      onToggleWipeAlert: widget.onToggleWipeAlert,
      wipeAlertMinutes: widget.wipeAlertMinutes,
      onSetWipeAlertMinutes: (minutes) {
        // This is handled by the parent screen through onToggleWipeAlert usually
        // but adding local feedback if needed.
      },
    );
  }



  Widget _buildLiveTab() {
    return ServerLiveTab(
      logs: _logs,
      feedError: widget.server.status.toLowerCase() != 'online' 
          ? tr('server.status.offline') 
          : null,
      onInspectPlayer: (id, name) {
        // TODO: Implement player inspection
        
      },
    );
  }


  Widget _buildTargetsTab() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          tr('server.targets.no_targets'),
          style: TextStyle(color: Color(0xFF71717A), fontSize: 12.sp),
        ),
      ),
    );
  }


  Widget _buildWipeTab() {
    return ServerWipeTab(
      nextWipe: widget.server.nextWipe,
      wipeAlertEnabled: widget.wipeAlertEnabled,
      onToggleWipeAlert: widget.onToggleWipeAlert,
      formatCountdown: _formatCountdown,
    );
  }
}

// Tab Button
class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticHelper.mediumImpact();
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: active ? const Color(0x8018181B) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: active ? const Color(0xFFF97316) : Colors.transparent,
                width: 2.h,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.w,
                color: active ? Colors.white : const Color(0xFF52525B),
              ),
              ScreenUtilHelper.sizedBoxWidth(8.0),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      color: active ? Colors.white : const Color(0xFF52525B),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontFamily: 'Geist',
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
