import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/widgets/server/tracked_targets_widget.dart';
import 'package:raidalarm/core/utils/native_notification_helper.dart';
import 'package:raidalarm/core/utils/connectivity_helper.dart';

final playerTrackingProvider = ChangeNotifierProvider((ref) => PlayerTrackingProvider(ref));

class PlayerTrackingProvider extends ChangeNotifier {
  final Ref _ref;
  
  PlayerTrackingProvider(this._ref);

  AppDatabase get _db => _ref.read(appDatabaseProvider);
  static const _platform = MethodChannel('com.raidalarm/native_tracking');
  
  // Max tracked players limit
  static const int MAX_TRACKED_PLAYERS = 3;
  
  String? _activeServerId;
  String? _activeServerName;
  
  List<TrackedTarget> _trackedPlayers = [];
  List<TrackedTarget> get trackedPlayers => _trackedPlayers;

  bool _loading = false;
  bool get loading => _loading;
  
  Timer? _refreshTimer;
  bool _isForeground = false; // Add state to track lifecycle

  /// Start auto-refresh (call when app becomes active)
  void startAutoRefresh() {
    _isForeground = true;
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      refreshPlayerStatus();
    });
    // Trigger update to stop native (since now foreground)
    _updateNativeTracking(); 
    debugPrint('[PlayerTracking] Auto-refresh started (Foreground mode)');
  }

  /// Stop auto-refresh (call when app goes to background)
  void stopAutoRefresh() {
    _isForeground = false;
    _refreshTimer?.cancel();
    _refreshTimer = null;
    // Trigger update to start native (since now background)
    _updateNativeTracking(); 
    debugPrint('[PlayerTracking] Auto-refresh stopped (Background mode)');
  }

  /// Fetch fresh player status from BattleMetrics (Batched)
  Future<void> refreshPlayerStatus() async {
    if (_trackedPlayers.isEmpty || _activeServerId == null) return;
    
    // Silent internet check for background polling
    try {
      final hasInternet = await ConnectivityHelper.hasInternet();
      if (!hasInternet) return;
    } catch (_) {
      return;
    }
    
    try {
      debugPrint('[PlayerTracking] Refreshing status for ${_trackedPlayers.length} players');
      
      // 1. Batch IDs
      final playerIds = _trackedPlayers
          .where((p) => p.playerId != null)
          .map((p) => p.playerId!)
          .join(',');
          
      if (playerIds.isEmpty) return;

      // 2. Single API Call
      final url = 'https://api.battlemetrics.com/players?filter[ids]=$playerIds&include=server&page[size]=100';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final dataArgs = (json['data'] as List?) ?? [];
        final included = (json['included'] as List?) ?? [];

        // 3. Process each tracked player against the batch response
        for (final player in _trackedPlayers) {
           if (player.playerId == null) continue;

           // Find player data in response
           final playerData = dataArgs.firstWhere(
             (d) => d['id'].toString() == player.playerId,
             orElse: () => null,
           );

           if (playerData == null) continue;

           bool isOnline = false;
           String lastSeen = tr('player_search.details.unknown');

           // Find server status in 'included' for the ACTIVE server
           bool isOnActiveServer = false;
           final rels = playerData['relationships'];
           if (rels != null && rels['servers'] != null) {
              final serverDataList = (rels['servers']['data'] as List?) ?? [];
              isOnActiveServer = serverDataList.any((s) => s['id'].toString() == _activeServerId);
           }

           if (isOnActiveServer) {
              isOnline = true;

              // Now find the server object in 'included' to get online status
              final serverObj = included.firstWhere(
                (inc) => inc['type'] == 'server' && inc['id'].toString() == _activeServerId,
                orElse: () => null,
              );

              if (serverObj != null && serverObj['meta'] != null) {
                  // isOnline = serverObj['meta']['online'] ?? false; // REMOVED: Don't rely on server status for player
                  final rawLastSeen = serverObj['meta']['lastSeen'];
                  
                  if (rawLastSeen != null && rawLastSeen is String) {
                      try {
                        final dt = DateTime.parse(rawLastSeen).toLocal();
                        lastSeen = DateFormat('HH:mm').format(dt);
                      } catch (e) {
                        lastSeen = rawLastSeen;
                      }
                  }
              }
           }

           debugPrint('[PlayerTracking] Player ${player.name} checked. IsOnline: $isOnline');

           // CHECK FOR STATUS CHANGE & NOTIFY
            if (player.isOnline != isOnline) {
               bool shouldNotify = false;
               if (isOnline && player.hasAlert) { // hasAlert is notifyOnOnline
                 shouldNotify = true;
               } else if (!isOnline && player.notifyOnOffline) {
                 shouldNotify = true;
               }

               if (shouldNotify) {
                 debugPrint('[PlayerTracking] Sending Foreground Notification for ${player.name}');
                 NativeNotificationHelper.showNotification(
                   playerName: player.name,
                   serverName: _activeServerName ?? tr('player_search.details.unknown'),
                   isOnline: isOnline,
                 );
               }
               
               await _db.updateTrackedPlayerStatus(
                 serverId: _activeServerId!,
                 playerId: player.playerId!,
                 isOnline: isOnline,
                 lastSeen: lastSeen,
                 notificationSent: shouldNotify,
               );
            } else {
              await _db.updateTrackedPlayerStatus(
                serverId: _activeServerId!,
                playerId: player.playerId!,
                isOnline: isOnline,
                lastSeen: lastSeen,
              );
            }
        } // end for loop
      }
      
      // Reload UI
      await loadPlayers(syncWithNative: false);
      debugPrint('[PlayerTracking] Refresh complete');

    } catch (e) {
      debugPrint('[PlayerTracking] Refresh error: $e');
    }
  }
  
  /// Loads tracked players from LOCAL DB.
  Future<void> loadPlayers({bool syncWithNative = true}) async {
    _loading = true;
    notifyListeners();
    
    try {
      // 1. Get Active Server
      final serverJson = await _db.getActiveServer();
      if (serverJson == null) {
        _activeServerId = null;
        _trackedPlayers = [];
        return;
      }
      
      final server = ServerData.fromJson(serverJson);
      _activeServerId = server.id;
      _activeServerName = server.name;

      // 2. Get Tracked Players for this server
      final trackedListRaw = await _db.getTrackedPlayers(server.id);
      
      _trackedPlayers = trackedListRaw.map((raw) {
        return TrackedTarget(
          name: raw['name'] as String,
          playerId: raw['player_id'] as String?,
          isOnline: (raw['is_online'] as int) == 1,
          lastSeen: raw['last_seen'] as String,
          hasAlert: (raw['notify_on_online'] as int) == 1,
          notifyOnOffline: (raw['notify_on_offline'] as int) == 1,
        );
      }).toList();

    } catch (e) {
      debugPrint('[PlayerTracking] Error loading players: $e');
    } finally {
      _loading = false;
      notifyListeners();
      await _updateNativeTracking();
    }
  }

  /// Adds a player to tracking (Local DB only)
  Future<void> trackPlayer(String playerId, String playerName, bool isOnline, {bool notifyOnOffline = false, bool notifyOnOnline = true, String? lastSeen}) async {
    // Ensure we have an active server ID
    if (_activeServerId == null) {
       final serverJson = await _db.getActiveServer();
       if (serverJson != null) {
         _activeServerId = ServerData.fromJson(serverJson).id;
       } else {
         debugPrint('[PlayerTracking] Cannot track player: No active server selected.');
         return;
       }
    }
    
    try {
      _loading = true;
      
      // Check max limit (allow updates for existing players)
      final isNewPlayer = !_trackedPlayers.any((p) => p.playerId == playerId);
      if (isNewPlayer && _trackedPlayers.length >= MAX_TRACKED_PLAYERS) {
        throw Exception(tr('player_tracking.max_limit_reached', args: [MAX_TRACKED_PLAYERS.toString()]));
      }
      
      debugPrint('[PlayerTracking] Tracking player: $playerName (ID: $playerId) for server: $_activeServerId');

      // Save to Local DB
      await _db.saveTrackedPlayer(
        serverId: _activeServerId!,
        name: playerName,
        playerId: playerId,
        isOnline: isOnline,
        lastSeen: lastSeen ?? (isOnline ? tr('server.targets.online_now') : tr('player_tracking.status.just_added')),
        notifyOnOnline: notifyOnOnline,
        notifyOnOffline: notifyOnOffline,
      );

      // Refresh List
      await loadPlayers();

    } catch (e) {
      debugPrint('[PlayerTracking] Error in trackPlayer: $e');
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
      await _updateNativeTracking();
    }
  }

  /// Removes a player from tracking (Local DB only)
  Future<void> untrackPlayer(String playerName) async {
    if (_activeServerId == null) {
       final serverJson = await _db.getActiveServer();
       if (serverJson != null) {
         _activeServerId = ServerData.fromJson(serverJson).id;
       } else {
         return;
       }
    }

    try {
      _loading = true;
      notifyListeners();

      // Remove from Local DB
      await _db.removeTrackedPlayer(_activeServerId!, playerName);

      // Refresh List
      await loadPlayers();

    } catch (e) {
      debugPrint('[PlayerTracking] Error untracking player: $e');
    } finally {
      _loading = false;
      notifyListeners();
      await _updateNativeTracking();
    }
  }

  
  /// Notifies native side to start/stop tracking based on list size and lifecycle
  Future<void> _updateNativeTracking() async {
    try {
      if (_trackedPlayers.isNotEmpty && _activeServerId != null) {
          if (_isForeground) {
             // App is open: Flutter handles polling. Stop Native to avoid conflict/double-use.
             await _platform.invokeMethod('stopTracking');
             debugPrint('[PlayerTracking] Native tracking PAUSED (App in Foreground)');
          } else {
             // App is background: Start Native tracking.
             await _platform.invokeMethod('startTracking');
             debugPrint('[PlayerTracking] Native tracking STARTED (App in Background)');
          }
      } else {
          // No players: Stop Native Tracking completely.
          await _platform.invokeMethod('stopTracking');
          debugPrint('[PlayerTracking] Native tracking STOPPED (No players)');
      }
    } catch (e) {
      debugPrint('[PlayerTracking] Error updating native tracking: $e');
    }
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
