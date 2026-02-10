import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raidalarm/services/battlemetrics.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

// Featured server groups
const List<Map<String, String>> FEATURED_GROUPS = [
  {'name': 'Rusty Moose', 'query': 'Rusty Moose'},
  {'name': 'Rustoria', 'query': 'Rustoria'},
  {'name': 'Rustafied', 'query': 'Rustafied'},
  {'name': 'Reddit PlayRust', 'query': 'Reddit.com/r/PlayRust'},
  {'name': 'Vital', 'query': 'Vital'},
  {'name': 'Rusticated', 'query': 'Rusticated'},
  {'name': 'Stevious', 'query': 'Stevious'},
  {'name': 'Bloo Lagoon', 'query': 'Bloo Lagoon'},
  {'name': 'Pickle', 'query': 'Pickle'},
  {'name': 'Paranoid', 'query': 'Paranoid'},
  {'name': 'Renegade', 'query': 'Renegade'},
  {'name': 'Werwolf', 'query': 'Werwolf'},
  {'name': 'Hollow', 'query': 'Hollow'},
  {'name': 'Atlas', 'query': 'Atlas'},
  {'name': 'Upsurge', 'query': 'Upsurge'},
  {'name': 'Garnet', 'query': 'Garnet'},
];

class ServerSearchManager extends StatefulWidget {
  final Function(ServerData) onSelectServer;

  const ServerSearchManager({
    super.key,
    required this.onSelectServer,
  });

  @override
  State<ServerSearchManager> createState() => _ServerSearchManagerState();
}

class _ServerSearchManagerState extends State<ServerSearchManager> {
  final BattleMetricsApi _api = BattleMetricsApi();
  final AppDatabase _db = AppDatabase();
  final TextEditingController _controller = TextEditingController();

  String _searchMode = 'SEARCH'; // 'SEARCH' | 'FAVORITES' | 'FEATURED'
  String _query = '';
  List<ServerData> _results = [];
  List<ServerData> _favorites = [];
  bool _loading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
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

  void _onQueryChanged(String value) {
    setState(() => _query = value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (_query.length > 2 && _searchMode == 'SEARCH') {
        _searchServers(_query);
      } else if (_query.length <= 2 && _searchMode == 'SEARCH') {
        setState(() => _results = []);
      }
    });
  }

  Future<void> _searchServers(String searchQuery) async {
    if (mounted) setState(() => _loading = true);
    try {
      final params =
          '?filter[game]=rust&filter[search]=${Uri.encodeComponent(searchQuery)}&page[size]=10';
      final json = await _api.fetchBattleMetrics('/servers', queryParams: params);
      if (!mounted) return;
      final data = (json['data'] is List) ? json['data'] as List : [];
      setState(() {
        _results = data.map((e) => ServerData.fromJson(e)).toList();
      });
    } catch (e) {
      
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggleFavorite(ServerData server) async {
    final id = server.id;
    final isFav = _favorites.any((f) => f.id == id);
    
    HapticHelper.mediumImpact();
    
    setState(() {
      if (isFav) {
        _favorites.removeWhere((f) => f.id == id);
      } else {
        _favorites.add(server);
      }
    });

    if (isFav) {
      await _db.removeFavorite(id);
    } else {
      await _db.saveFavorite(server.toJson());
    }
  }

  bool _isFavorite(String serverId) => _favorites.any((f) => f.id == serverId);

  void _handleFeaturedClick(String groupQuery) {
    HapticHelper.mediumImpact();
    
    setState(() {
      _searchMode = 'SEARCH';
      _query = groupQuery;
    });
    _controller.text = groupQuery;
    _searchServers(groupQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // View Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _SearchTabButton(
                label: tr('server.search.tabs.search'),
                active: _searchMode == 'SEARCH',
                onTap: () => setState(() => _searchMode = 'SEARCH'),
              ),
              ScreenUtilHelper.sizedBoxWidth(8.0),
              _SearchTabButton(
                label: tr('server.search.tabs.favorites'),
                active: _searchMode == 'FAVORITES',
                onTap: () => setState(() => _searchMode = 'FAVORITES'),
              ),
              ScreenUtilHelper.sizedBoxWidth(8.0),
              _SearchTabButton(
                label: tr('server.search.tabs.featured'),
                active: _searchMode == 'FEATURED',
                onTap: () => setState(() => _searchMode = 'FEATURED'),
              ),
            ],
          ),
        ),
        ScreenUtilHelper.sizedBoxHeight(24.0),

        // Content
        Expanded(
          child: _searchMode == 'SEARCH'
              ? _buildSearchView()
              : _searchMode == 'FAVORITES'
                  ? _buildFavoritesView()
                  : _buildFeaturedView(),
        ),
      ],
    );
  }

  Widget _buildSearchView() {
    return Column(
      children: [
        // Search Input
        TextField(
          controller: _controller,
          onChanged: _onQueryChanged,
          autofocus: true,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'RobotoMono',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1C1C1E),
            hintText: tr('server.search.placeholder'),
            hintStyle: TextStyle(color: const Color(0xFF52525B), fontSize: 14.sp),
            prefixIcon: Icon(LucideIcons.search, size: 20.w, color: const Color(0xFF71717A)),
            suffixIcon: _query.isNotEmpty
                ? InkWell(
                    onTap: () {
                      HapticHelper.mediumImpact();
                      _controller.clear();
                      setState(() {
                        _query = '';
                        _results = [];
                      });
                    },
                    child: Icon(LucideIcons.x, size: 20.w, color: const Color(0xFF71717A)),
                  )
                : null,
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
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
        ),
        ScreenUtilHelper.sizedBoxHeight(24.0),

        // Results
        Expanded(
          child: _loading
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF71717A)),
                        ),
                      ),
                      ScreenUtilHelper.sizedBoxWidth(12.0),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tr('server.search.searching'),
                          style: TextStyle(color: Color(0xFF71717A), fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                )
              : _results.isEmpty && _query.length > 2
                  ? Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tr('server.search.no_results'),
                          style: TextStyle(color: Color(0xFF71717A), fontSize: 12.sp),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 32.h),
                      itemCount: _results.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _ServerListItem(
                          server: _results[index],
                          isFavorite: _isFavorite(_results[index].id),
                          onTap: () {
                            HapticHelper.mediumImpact();
                            widget.onSelectServer(_results[index]);
                          },
                          onToggleFavorite: () => _toggleFavorite(_results[index]),
                        ),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildFavoritesView() {
    return _favorites.isEmpty
        ? Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('server.search.no_favorites'),
                style: TextStyle(color: Color(0xFF71717A), fontSize: 12.sp),
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 32.h),
            itemCount: _favorites.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _ServerListItem(
                server: _favorites[index],
                isFavorite: true,
                onTap: () {
                  HapticHelper.mediumImpact();
                  widget.onSelectServer(_favorites[index]);
                },
                onToggleFavorite: () => _toggleFavorite(_favorites[index]),
              ),
            ),
          );
  }

  Widget _buildFeaturedView() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 32.h),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: FEATURED_GROUPS.length,
            itemBuilder: (context, index) {
              final group = FEATURED_GROUPS[index];
              return _FeaturedGroupButton(
                name: group['name']!,
                onTap: () => _handleFeaturedClick(group['query']!),
              );
            },
          ),
          ScreenUtilHelper.sizedBoxHeight(32.0),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0x4D18181B),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0x8027272A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.flame, size: 16.w, color: Color(0xFFF97316)),
                    ScreenUtilHelper.sizedBoxWidth(8.0),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        tr('server.search.official_section.title'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Geist',
                        ),
                      ),
                    ),
                  ],
                ),
                ScreenUtilHelper.sizedBoxHeight(8.0),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr('server.search.official_section.desc'),
                    style: TextStyle(
                      color: Color(0xFF71717A),
                      fontSize: 10.sp,
                      height: 1.5,
                      fontFamily: 'Geist',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Search Tab Button
class _SearchTabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SearchTabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticHelper.mediumImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF4F4F5) : const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: active ? Colors.white : const Color(0xFF27272A),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: active ? Colors.black : const Color(0xFF71717A),
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              fontFamily: 'Geist',
            ),
          ),
        ),
      ),
    );
  }
}

// Server List Item
class _ServerListItem extends StatefulWidget {
  final ServerData server;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const _ServerListItem({
    required this.server,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  State<_ServerListItem> createState() => _ServerListItemState();
}

class _ServerListItemState extends State<_ServerListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: _pressed ? 0.98 : 1.0,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF121214),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF27272A)),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 32.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.server.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Geist',
                          ),
                        ),
                      ),
                    ),
                    ScreenUtilHelper.sizedBoxHeight(8.0),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.users, size: 12.w, color: const Color(0xFF71717A)),
                            ScreenUtilHelper.sizedBoxWidth(6.0),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${widget.server.players}/${widget.server.maxPlayers}',
                                style: TextStyle(
                                  color: Color(0xFF71717A),
                                  fontSize: 12.sp,
                                  fontFamily: 'RobotoMono',
                                ),
                              ),
                            ),
                          ],
                        ),
                        ScreenUtilHelper.sizedBoxWidth(16.0),
                        Flexible(
                          child: Row(
                            children: [
                              Icon(LucideIcons.map, size: 12.w, color: Color(0xFF71717A)),
                              ScreenUtilHelper.sizedBoxWidth(6.0),
                              Flexible(
                                child: Text(
                                  widget.server.map ?? tr('server.map.procedural'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF71717A),
                                    fontSize: 10.sp,
                                    fontFamily: 'RobotoMono',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: widget.onToggleFavorite,
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        widget.isFavorite ? Icons.star : Icons.star_border,
                        size: 16.w,
                        color: widget.isFavorite ? const Color(0xFFEAB308) : const Color(0xFF52525B),
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

// Featured Group Button
class _FeaturedGroupButton extends StatefulWidget {
  final String name;
  final VoidCallback onTap;

  const _FeaturedGroupButton({
    required this.name,
    required this.onTap,
  });

  @override
  State<_FeaturedGroupButton> createState() => _FeaturedGroupButtonState();
}

class _FeaturedGroupButtonState extends State<_FeaturedGroupButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: _pressed ? 0.95 : 1.0,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF18181B),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFF27272A),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF27272A),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Icon(
                    LucideIcons.globe,
                    size: 20.w,
                    color: Color(0xFF71717A),
                  ),
                ),
                ScreenUtilHelper.sizedBoxHeight(12.0),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFD4D4D8),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Geist',
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
