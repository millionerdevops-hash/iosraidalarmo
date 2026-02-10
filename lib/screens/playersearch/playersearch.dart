import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/services/battlemetrics.dart';
import 'package:raidalarm/widgets/player/playerdetailsheet.dart';
import 'package:raidalarm/widgets/player/playerlistitem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/player_tracking_provider.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/permission_helper.dart';
import 'package:raidalarm/services/ad_service.dart';
import 'package:raidalarm/widgets/ads/banner_ad_widget.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/core/utils/connectivity_helper.dart';

class PlayerSearchScreen extends ConsumerStatefulWidget {
  const PlayerSearchScreen({super.key});

  @override
  ConsumerState<PlayerSearchScreen> createState() => _PlayerSearchScreenState();
}

class _PlayerSearchScreenState extends ConsumerState<PlayerSearchScreen> {
  final BattleMetricsApi _api = BattleMetricsApi();
  final TextEditingController _controller = TextEditingController();

  String _query = '';
  List<PlayerFullDetails> _results = [];
  bool _loading = false;
  String? _error;

  PlayerFullDetails? _selectedPlayer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _query = value;
    });
    if (value.trim().length > 2) {
      _searchPlayers(value.trim());
    } else {
      setState(() {
        _results = [];
        _error = null;
      });
    }
  }

  Future<void> _searchPlayers(String searchQuery) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // Check internet connection
    final hasInternet = await ConnectivityHelper.hasInternet();
    if (!hasInternet) {
      if (mounted) {
        setState(() => _loading = false);
        ConnectivityHelper.showNoInternetSnackBar(context);
      }
      return;
    }

    try {
      // Check if input is a valid numeric ID (BattleMetrics IDs are usually 8-10 digits)
      final isNumeric = RegExp(r'^\d+$').hasMatch(searchQuery);
      
      if (isNumeric && searchQuery.length >= 6) {
        try {
          // Direct ID lookup
          final json = await _api.fetchBattleMetrics('/players/$searchQuery', queryParams: '?include=server');
          final data = json['data'];
          if (data != null && data is Map) {
             final mapped = <PlayerFullDetails>[];
             final servers = (json['included'] is List) ? json['included'] as List : const [];
             
             // Reuse the extraction logic (extract to method if possible, but for now inline is fine for single item)
             final item = data;
             final id = item['id']?.toString() ?? '';
             final attr = (item['attributes'] is Map) ? item['attributes'] as Map : const {};
             final name = attr['name']?.toString() ?? '';
             final isPrivate = (attr['private'] == true);
             final createdAtRaw = attr['createdAt']?.toString();
             final createdAt = createdAtRaw != null
                 ? DateTime.tryParse(createdAtRaw) ?? DateTime.now()
                 : DateTime.now();

             String? currentServerName;
             var isOnline = false;

             final rel = item['relationships'] is Map ? item['relationships'] as Map? : null;
             final serversRel = rel != null && rel['servers'] is Map ? rel['servers'] as Map? : null;
             final serversData = serversRel != null && serversRel['data'] is List ? serversRel['data'] as List? : null;
             final serverRel0 = (serversData != null && serversData.isNotEmpty) ? serversData.first : null;
             final serverRelId = (serverRel0 is Map) ? serverRel0['id']?.toString() : null;

             if (serverRelId != null) {
               final serverObj = servers.whereType<Map>().firstWhere(
                     (s) => s['id']?.toString() == serverRelId,
                     orElse: () => const {},
                   );
               if (serverObj.isNotEmpty) {
                 final sAttr = (serverObj['attributes'] is Map) ? serverObj['attributes'] as Map : const {};
                 currentServerName = sAttr['name']?.toString();
                 if (currentServerName != null && currentServerName.isNotEmpty) {
                   isOnline = true;
                 }
               }
             }

             mapped.add(
               PlayerFullDetails(
                 id: id,
                 name: name,
                 status: isOnline ? PlayerStatus.online : PlayerStatus.offline,
                 currentServer: currentServerName,
                 isPrivate: isPrivate,
                 firstSeen: createdAt,
                 country: tr('player_search.ui.global'),
               ),
             );
             
             if (mounted) {
               setState(() {
                 _results = mapped;
               });
             }
             return; // Success, exit
          }
        } catch (e) {
        }
      }

      // Standard Name Search
      final params =
          '?filter[search]=${Uri.encodeComponent(searchQuery)}&filter[public]=true&include=server&page[size]=50';
      final json =
          await _api.fetchBattleMetrics('/players', queryParams: params);

      final servers =
          (json['included'] is List) ? json['included'] as List : const [];
      final data = (json['data'] is List) ? json['data'] as List : const [];

      final mapped = <PlayerFullDetails>[];
      for (final item in data) {
        if (item is! Map) continue;
        final id = item['id']?.toString() ?? '';
        final attr =
            (item['attributes'] is Map) ? item['attributes'] as Map : const {};
        final name = attr['name']?.toString() ?? '';
        final isPrivate = (attr['private'] == true);
        final createdAtRaw = attr['createdAt']?.toString();
        final createdAt = createdAtRaw != null
            ? DateTime.tryParse(createdAtRaw) ?? DateTime.now()
            : DateTime.now();

        String? currentServerName;
        var isOnline = false;

        final rel =
            item['relationships'] is Map ? item['relationships'] as Map? : null;
        final serversRel = rel != null && rel['servers'] is Map
            ? rel['servers'] as Map?
            : null;
        final serversData = serversRel != null && serversRel['data'] is List
            ? serversRel['data'] as List?
            : null;
        final serverRel0 = (serversData != null && serversData.isNotEmpty)
            ? serversData.first
            : null;
        final serverRelId =
            (serverRel0 is Map) ? serverRel0['id']?.toString() : null;

        if (serverRelId != null) {
          final serverObj = servers.whereType<Map>().firstWhere(
                (s) => s['id']?.toString() == serverRelId,
                orElse: () => const {},
              );
          if (serverObj.isNotEmpty) {
            final sAttr = (serverObj['attributes'] is Map)
                ? serverObj['attributes'] as Map
                : const {};
            currentServerName = sAttr['name']?.toString();
            if (currentServerName != null && currentServerName.isNotEmpty) {
              isOnline = true;
            }
          }
        }

        if (id.isEmpty || name.isEmpty) continue;
        mapped.add(
          PlayerFullDetails(
            id: id,
            name: name,
            status: isOnline ? PlayerStatus.online : PlayerStatus.offline,
            currentServer: currentServerName,
            isPrivate: isPrivate,
            firstSeen: createdAt,
            country: tr('player_search.ui.global'),
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _results = mapped;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _results = [];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  void _handleSelectPlayer(PlayerFullDetails basicPlayer) {
    HapticHelper.mediumImpact();
    setState(() {
      _selectedPlayer = basicPlayer;
    });
  }

  Future<void> _handleTrackPlayer(String name, String id) async {
    if (_selectedPlayer == null) return;
    
    final isOnline = _selectedPlayer!.status == PlayerStatus.online;
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator(color: Color(0xFFF97316))),
      );

      await ref.read(playerTrackingProvider).trackPlayer(id, name, isOnline);
      
      if (mounted) {
        // Pop loading
        Navigator.of(context).pop(); 
        
        setState(() {
          _selectedPlayer = null;
        });

        // Check permissions AFTER adding target
        final hasPermissions = await PermissionHelper.checkAllCriticalPermissions(ref);
        if (!hasPermissions && mounted) {
           context.push('/setup-ready?step=4');
        } else if (mounted) {
           context.go('/info');
        }
      }
    } catch (e) {
      if (mounted) {
         // Pop loading
        Navigator.of(context).pop(); 
        Navigator.of(context).pop(); 
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(tr('player_search.ui.error_snackbar', args: [e.toString()]))));
      }
    }
  }

  void _handleBack() {
    if (!mounted) return;
    final hasLifetime = ref.read(notificationProvider).hasLifetime;
    if (!hasLifetime) {
      AdService().showInterstitialAd();
    }
    if (mounted) {
      context.go('/info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0E),
      body: RustScreenLayout(
        child: SafeArea(
          bottom: true,
          child: Stack(
            children: [
            Column(
              children: [
                Container(
                  height: 64.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C0C0E),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.05),
                        width: 1.h,
                      ),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                                HapticHelper.mediumImpact();
                                _handleBack();
                              },
                          icon: Icon(Icons.arrow_back, color: const Color(0xFFA1A1AA), size: 24.w),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48.w),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tr('player_search.ui.title'),
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                        child: _SearchInput(
                          controller: _controller,
                          onSubmitted: _onSearchSubmitted,
                          onClear: () {
                            HapticHelper.mediumImpact();
                            _controller.clear();
                            setState(() {
                              _query = '';
                              _results = [];
                              _error = null;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                              16.w, 0, 16.w, 16.h), 
                          child: Column(
                            children: [
                              if (_loading)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 40.h), 
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 32.w, 
                                        height: 32.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(0xFFA855F7)),
                                        ),
                                      ),
                                      ScreenUtilHelper.sizedBoxHeight(16), 
                                      FittedBox(
                                        child: Text(
                                          tr('server.search.searching'),
                                          style: TextStyle(
                                            color: const Color(0xFF71717A),
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 2.0,
                                            fontFamily: 'Geist',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (_error != null)
                                _ErrorCard(
                                  error: _error!,
                                  onRetry: () {
                                    if (_query.trim().length > 2) {
                                      _searchPlayers(_query.trim());
                                    }
                                  },
                                ),
                              if (!_loading &&
                                  _error == null &&
                                  _results.isEmpty &&
                                  _query.length > 2)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 40.h), 
                                  child: Column(
                                    children: [
                                      Icon(
                                        LucideIcons.ghost,
                                        size: 48.w,
                                        color: const Color(0x3352525B),
                                      ),
                                      ScreenUtilHelper.sizedBoxHeight(16), 
                                      FittedBox(
                                        child: Text(
                                          tr('player_search.ui.empty_state'),
                                          style: TextStyle(
                                            color: const Color(0xFF71717A),
                                            fontSize: 12.sp,
                                            fontFamily: 'Geist',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (_results.isNotEmpty)
                                Column(
                                  children: [
                                    for (final p in _results) ...[
                                      PlayerListItem(
                                        player: PlayerSearchResultItem(
                                          id: p.id,
                                          name: p.name,
                                          status: p.status,
                                          currentServer: p.currentServer,
                                        ),
                                        onClick: (_) => _handleSelectPlayer(p),
                                      ),
                                      SizedBox(height: 12.h),
                                    ],
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const BannerAdWidget(),
              ],
            ),
            if (_selectedPlayer != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: PlayerDetailSheet(
                  playerName: _selectedPlayer!.name,
                  playerId: _selectedPlayer!.id,
                  isOnline: _selectedPlayer!.status == PlayerStatus.online,
                  initialNotifyOnOnline: _selectedPlayer!.status != PlayerStatus.online,
                  initialNotifyOnOffline: _selectedPlayer!.status == PlayerStatus.online,
                  onUpdate: (onOnline, onOffline) {
                    HapticHelper.mediumImpact();
                    _handleTrackPlayer(
                      _selectedPlayer!.name,
                      _selectedPlayer!.id,
                    );
                  },
                  onClose: () {
                    HapticHelper.mediumImpact();
                    setState(() => _selectedPlayer = null);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _SearchInput extends StatelessWidget {
  const _SearchInput({
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    // Determine input height and padding
    // We want a premium, chunky feel.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
          autofocus: false, // Disabled autofocus
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'RobotoMono',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1C1C1E),
            hintText: tr('player_search.ui.search_hint'),
            hintStyle: const TextStyle(
              color: Color(0xFF52525B),
              fontFamily: 'Geist',
            ),
            prefixIcon: Icon(
              LucideIcons.search,
              size: 20.w,
              color: const Color(0xFF71717A),
            ),
            suffixIcon: value.text.isEmpty
                ? null
                : InkWell(
                    onTap: onClear,
                    child: Icon(
                      LucideIcons.x,
                      size: 20.w,
                      color: const Color(0xFF71717A),
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF27272A)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF27272A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFF97316)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
        );
      },
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0x331F0A0A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0x4D7F1D1D)),
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0x331F0A0A),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Icon(
              LucideIcons.triangleAlert,
              size: 20.w,
              color: const Color(0xFFEF4444),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(10),
          FittedBox(
            child: Text(
              tr('player_search.ui.error_title'),
              style: TextStyle(
                color: const Color(0xFFEF4444),
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                fontFamily: 'Geist',
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(6),
          FittedBox(
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0x80FECACA),
                fontSize: 12.sp,
                fontFamily: 'Geist',
              ),
            ),
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0x66451111),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: FittedBox(
              child: Text(
                tr('player_search.ui.retry_button'),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  fontFamily: 'Geist',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerFullDetails {
  final String id;
  final String name;
  final PlayerStatus status;
  final String? currentServer;
  final bool isPrivate;
  final DateTime firstSeen;
  final String? country;

  PlayerFullDetails({
    required this.id,
    required this.name,
    required this.status,
    this.currentServer,
    this.isPrivate = false,
    required this.firstSeen,
    this.country,
  });
}
