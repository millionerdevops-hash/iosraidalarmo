import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raidalarm/services/battlemetrics.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/core/utils/connectivity_helper.dart';

const List<Map<String, String>> SORT_OPTIONS = [
  {'id': 'rank', 'label': 'server.search.sort.relevance'},
  {'id': '-players', 'label': 'server.search.sort.high_pop'},
  {'id': 'players', 'label': 'server.search.sort.low_pop'},
  {'id': '-details.rust_last_wipe', 'label': 'server.search.sort.just_wiped'},
];

class ServerSearchScreen extends ConsumerStatefulWidget {
  const ServerSearchScreen({super.key});

  @override
  ConsumerState<ServerSearchScreen> createState() => _ServerSearchScreenState();
}

class _ServerSearchScreenState extends ConsumerState<ServerSearchScreen> {
  final BattleMetricsApi _api = BattleMetricsApi();
  final AppDatabase _db = AppDatabase();
  final TextEditingController _controller = TextEditingController();

  String _searchMode = 'SEARCH'; // 'SEARCH' | 'FAVORITES'
  String _query = '';
  List<ServerData> _results = [];
  List<ServerData> _favorites = [];
  bool _loading = false;
  String? _error;
  String _sortBy = 'rank';

  // Filters
  String _groupFilter = 'ALL'; // 'ALL', 'SOLO', 'DUO', 'TRIO'
  String _moddedFilter = 'ALL'; // 'ALL', 'VANILLA', 'MODDED'
  String _rateFilter = 'ALL'; // 'ALL', '2X', '3X+'
  bool _noBpFilter = false;
  bool _kitsFilter = false;

  Timer? _debounce;
  bool _refreshOnBack = false;

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
      if (mounted) {
        setState(() {
          _favorites = favs.map((e) => ServerData.fromJson(e)).toList();
        });
      }
    } catch (e) {

    }
  }

  // _saveFavorites is no longer needed as toggle handles it individually

  void _onQueryChanged(String value) {
    setState(() {
      _query = value;
      
      // Build combined query from text input and chips
      String combinedQuery = value.trim();
      
      List<String> chipTerms = [];
      if (_groupFilter != 'ALL') chipTerms.add('"${_groupFilter.toLowerCase()}"');
      if (_moddedFilter != 'ALL') chipTerms.add('"${_moddedFilter.toLowerCase()}"');
      if (_rateFilter != 'ALL') chipTerms.add('"${_rateFilter.toLowerCase()}"');
      if (_noBpFilter) chipTerms.add('"nobp"');
      if (_kitsFilter) chipTerms.add('"kit"');

      for (var term in chipTerms) {
        String rawTerm = term.replaceAll('"', '');
        if (!combinedQuery.toLowerCase().contains(rawTerm)) {
          combinedQuery += ' $term';
        }
      }

      if (combinedQuery.trim().isEmpty) {
        _debounce?.cancel();
        _results = [];
        _error = null;
      }
    });
  }

  void _onSearchSubmitted(String value) {
    if (value.trim().length > 2 && _searchMode == 'SEARCH') {
      HapticHelper.mediumImpact();
      
      // Combine with chips
      String combinedQuery = value.trim();
      List<String> chipTerms = [];
      if (_groupFilter != 'ALL') chipTerms.add('"${_groupFilter.toLowerCase()}"');
      if (_moddedFilter != 'ALL') chipTerms.add('"${_moddedFilter.toLowerCase()}"');
      if (_rateFilter != 'ALL') chipTerms.add('"${_rateFilter.toLowerCase()}"');
      if (_noBpFilter) chipTerms.add('"nobp"');
      if (_kitsFilter) chipTerms.add('"kit"');

      for (var term in chipTerms) {
        String rawTerm = term.replaceAll('"', '');
        if (!combinedQuery.toLowerCase().contains(rawTerm)) {
          combinedQuery += ' $term';
        }
      }
      
      _searchServers(combinedQuery.trim(), _sortBy);
    } else if (value.trim().length <= 2 && _searchMode == 'SEARCH') {
      setState(() {
        _results = [];
        _error = null;
      });
    }
  }

  Future<void> _searchServers(String searchQuery, String sortOption) async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

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
      // Quote terms for precise BattleMetrics results if requested
      // We check if it's already quoted to avoid double quotes
      String finalQuery = searchQuery.split(' ').map((term) {
        if (term.startsWith('"') && term.endsWith('"')) return term;
        return '"$term"';
      }).join(' ');

      final params =
          '?filter[game]=rust&filter[search]=${Uri.encodeComponent(finalQuery)}&sort=$sortOption&page[size]=100';
      final json = await _api.fetchBattleMetrics('/servers', queryParams: params);
      final data = (json['data'] is List) ? json['data'] as List : [];
      final List<ServerData> parsedResults = data.map((e) => ServerData.fromJson(e)).toList();

      // Prioritize Exact Matches
      final queryRaw = searchQuery.trim();
      final queryLower = queryRaw.toLowerCase();
      
      final exactMatches = <ServerData>[];
      final otherResults = <ServerData>[];
      
      for (final server in parsedResults) {
         bool isMatch = false;
         // Check Name (Case Insensitive)
         if (server.name.toLowerCase() == queryLower) isMatch = true;
         // Check IP (Exact)
         if (server.ip == queryRaw) isMatch = true;
         // Check IP:Port (Exact)
         if ('${server.ip}:${server.port}' == queryRaw) isMatch = true;
         
         if (isMatch) {
           exactMatches.add(server);
         } else {
           otherResults.add(server);
         }
      }

      if (mounted) {
        setState(() {
          _results = [...exactMatches, ...otherResults];
        });
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _results = [];
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggleFavorite(ServerData server) async {
    final id = server.id;
    final isFav = _favorites.any((f) => f.id == id);
    
    setState(() {
      HapticHelper.mediumImpact();
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

  bool get _isAnyFilterActive {
    return _groupFilter != 'ALL' || 
           _moddedFilter != 'ALL' || 
           _rateFilter != 'ALL' || 
           _noBpFilter || 
           _kitsFilter;
  }

  List<ServerData> get _filteredResults {
    if (_results.isEmpty) return [];

    return _results.where((server) {
      final nameLower = server.name.toLowerCase();
      final descLower = (server.description ?? '').toLowerCase();
      final searchableText = '$nameLower $descLower';

      // 1. Modded Filter
      if (_moddedFilter == 'VANILLA' && server.modded) return false;
      if (_moddedFilter == 'MODDED' && !server.modded) return false;

      // 2. Group Size Filter (Solo/Duo/Trio)
      if (_groupFilter != 'ALL') {
        bool hasMatch = false;
        if (_groupFilter == 'SOLO') {
          if (searchableText.contains('solo') || 
              searchableText.contains('max 1') || 
              searchableText.contains('lone wolf')) hasMatch = true;
        } else if (_groupFilter == 'DUO') {
          if (searchableText.contains('duo') || 
              searchableText.contains('max 2')) hasMatch = true;
        } else if (_groupFilter == 'TRIO') {
          if (searchableText.contains('trio') || 
              searchableText.contains('max 3')) hasMatch = true;
        }
        if (!hasMatch) return false;
      }

      // 3. Rate Filter
      if (_rateFilter != 'ALL') {
        bool hasMatch = false;
        if (_rateFilter == '2X') {
          if (searchableText.contains('2x')) hasMatch = true;
        } else if (_rateFilter == '3X+') {
          if (searchableText.contains('3x') || 
              searchableText.contains('4x') || 
              searchableText.contains('5x') || 
              searchableText.contains('10x') || 
              searchableText.contains('100x')) hasMatch = true;
        }
        if (!hasMatch) return false;
      }

      // 4. Blueprints Filter
      if (_noBpFilter) {
        if (!searchableText.contains('no bp') && 
            !searchableText.contains('nobp') && 
            !searchableText.contains('no blueprint')) return false;
      }

      // 5. Kits Filter
      if (_kitsFilter) {
        if (!searchableText.contains('kit')) return false;
      }

      return true;
    }).toList();
  }

  void _handleSelectServer(ServerData server) async {
    try {
      await _db.saveActiveServer(server.toJson());
      _refreshOnBack = true;
    } catch (e) {

    }
    if (!mounted) return;
    HapticHelper.mediumImpact();
    // Redirect to detail as requested
    // Passing server as extra just in case, though it should load from DB if configured
    context.push('/server-detail', extra: server); 
  }

  void _handleFeaturedClick(String groupQuery) {
    setState(() {
      _searchMode = 'SEARCH';
      _query = groupQuery;
      _sortBy = 'rank';
    });
    _controller.text = groupQuery;
    _searchServers(groupQuery, 'rank');
  }

  void _handleSortChange(String newSort) {
    setState(() {
      HapticHelper.mediumImpact();
      _sortBy = newSort;
      
      // Client-side sorting of existing results
      if (_results.isNotEmpty) {
        _results = List.from(_results);
        switch (newSort) {
          case 'rank':
            _results.sort((a, b) => (b.rank ?? 0).compareTo(a.rank ?? 0));
            break;
          case '-players':
            // High Pop: Most players first (descending)
            _results.sort((a, b) => b.players.compareTo(a.players));
            break;
          case 'players':
            // Low Pop: Least players first (ascending)
            _results.sort((a, b) => a.players.compareTo(b.players));
            break;
          case '-details.rust_last_wipe':
            // Just Wiped: Newest wipe first (descending timestamp)
            _results.sort((a, b) {
              final aWipe = a.lastWipe != null ? DateTime.tryParse(a.lastWipe!) ?? DateTime(1970) : DateTime(1970);
              final bWipe = b.lastWipe != null ? DateTime.tryParse(b.lastWipe!) ?? DateTime(1970) : DateTime(1970);
              return bWipe.compareTo(aWipe);
            });
            break;
          case 'details.rust_last_wipe':
            // Oldest Map: Oldest wipe first (ascending timestamp)
            _results.sort((a, b) {
              final aWipe = a.lastWipe != null ? DateTime.tryParse(a.lastWipe!) ?? DateTime(1970) : DateTime(1970);
              final bWipe = b.lastWipe != null ? DateTime.tryParse(b.lastWipe!) ?? DateTime(1970) : DateTime(1970);
              return aWipe.compareTo(bWipe);
            });
            break;
        }
      }
    });
  }

  String get _activeSortLabel {
    return tr(SORT_OPTIONS.firstWhere(
      (s) => s['id'] == _sortBy,
      orElse: () => {'id': 'rank', 'label': 'server.search.sort.relevance'},
    )['label']!);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (!mounted) return;
        HapticHelper.mediumImpact();
        if (mounted) {
          if (context.canPop()) {
            context.pop(_refreshOnBack);
          } else {
            context.go('/info');
          }
        }
      },
      child: RustScreenLayout(
        child: Scaffold(
          backgroundColor: const Color(0xFF0C0C0E),
          body: SafeArea(
            bottom: true,
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header
                    _buildHeader(),
                    
                    // Content
                    Expanded(
                      child: Padding(
                        padding: ScreenUtilHelper.paddingSymmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          children: [
                            
                            // Content
                            Expanded(child: _buildContent()),
                          ],
                        ),
                      ),
                    ),
                    // BannerAdWidget removed
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64.h,
      padding: ScreenUtilHelper.paddingHorizontal(16),
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
                if (!mounted) return;
                HapticHelper.mediumImpact();
                if (context.canPop()) {
                  context.pop(_refreshOnBack);
                } else {
                  context.go('/info');
                }
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
                tr('server.search.title'),
                style: TextStyle(
                  fontFamily: 'Geist',
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Favorites Toggle
                GestureDetector(
                  onTap: () {
                    HapticHelper.mediumImpact();
                    setState(() {
                      if (_searchMode == 'FAVORITES') {
                        _searchMode = 'SEARCH';
                      } else {
                        _searchMode = 'FAVORITES';
                      }
                    });
                  },
                  child: Icon(
                    _searchMode == 'FAVORITES' ? Icons.star : Icons.star_border,
                    size: 24.w,
                    color: _searchMode == 'FAVORITES'
                        ? const Color(0xFFEAB308)
                        : const Color(0xFF71717A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildContent() {
    switch (_searchMode) {
      case 'SEARCH':
        return _buildSearchView();
      case 'FAVORITES':
        return _buildFavoritesView();
      default:
        return const SizedBox();
    }
  }

  Widget _buildSearchView() {
    return Column(
      children: [
        // Search Input
        TextField(
          controller: _controller,
          onChanged: _onQueryChanged,
          onSubmitted: _onSearchSubmitted,
          textInputAction: TextInputAction.search,
          autofocus: false,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'RobotoMono',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1C1C1E),
            hintText: tr('server.search.placeholder'),
            hintStyle: TextStyle(color: const Color(0xFF71717A)),
            prefixIcon: Icon(LucideIcons.search, size: 20.w, color: const Color(0xFF71717A)),
            suffixIcon: _query.isNotEmpty
                ? InkWell(
                    onTap: () {
                      _controller.clear();
                      setState(() {
                        _query = '';
                        _results = [];
                        _error = null;
                        // Reset all filters too
                        _groupFilter = 'ALL';
                        _moddedFilter = 'ALL';
                        _rateFilter = 'ALL';
                        _noBpFilter = false;
                        _kitsFilter = false;
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
            contentPadding: ScreenUtilHelper.paddingSymmetric(horizontal: 16, vertical: 16),
          ),
        ),
        ScreenUtilHelper.sizedBoxHeight(16.0),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: ScreenUtilHelper.paddingVertical(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFilterChips(),

                // Error State
                if (_error != null)
                  Container(
                    padding: ScreenUtilHelper.paddingAll(16),
                    decoration: BoxDecoration(
                      color: const Color(0x33991B1B),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0x4D7F1D1D)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: const Color(0x337F1D1D),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Icon(LucideIcons.wifiOff, size: 20.w, color: const Color(0xFFEF4444)),
                        ),
                        ScreenUtilHelper.sizedBoxHeight(8.0),
                        FittedBox(
                          child: Text(
                            tr('server.search.error.title'),
                            style: TextStyle(
                              color: const Color(0xFFFCA5A5),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Geist',
                            ),
                          ),
                        ),
                        ScreenUtilHelper.sizedBoxHeight(4.0),
                        FittedBox(
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0x99FCA5A5),
                              fontSize: 12.sp,
                              fontFamily: 'Geist',
                            ),
                          ),
                        ),
                        ScreenUtilHelper.sizedBoxHeight(12.0),
                        ElevatedButton(
                          onPressed: () => _searchServers(_query, _sortBy),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0x667F1D1D),
                            foregroundColor: const Color(0xFFFECDD3),
                            padding: ScreenUtilHelper.paddingSymmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          ),
                          child: FittedBox(
                            child: Text(
                                tr('server.search.error.retry'),
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Active Sort Indicator
                if (_query.length > 2 && !_loading && _error == null && _results.isNotEmpty)
                  Padding(
                        padding: ScreenUtilHelper.paddingSymmetric(horizontal: 4, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  tr('server.search.results_label') + ' (${_filteredResults.length})',
                                  style: TextStyle(
                                    color: const Color(0xFF71717A),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.4,
                                    fontFamily: 'Geist',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                // Loading
                if (_loading)
                  Padding(
                    padding: ScreenUtilHelper.paddingVertical(250),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 32.w,
                          height: 32.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation(Color(0xFFF97316)),
                          ),
                        ),
                        ScreenUtilHelper.sizedBoxHeight(12.0),
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

                // No Results
                if (!_loading && _error == null && _results.isEmpty && _query.length > 2)
                  Container(
                    padding: ScreenUtilHelper.paddingVertical(48),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFF27272A), style: BorderStyle.solid),
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          tr('server.search.no_results', args: [_query]),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF71717A),
                            fontSize: 12.sp,
                            fontFamily: 'Geist',
                          ),
                        ),
                      ),
                    ),
                  ),

                // Server List or Featured Grid
                if (_query.length > 2 || _isAnyFilterActive)
                  Column(
                    children: _filteredResults
                        .map((server) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: ServerListItem(
                                server: server,
                                isFavorite: _isFavorite(server.id),
                                onSelect: () => _handleSelectServer(server),
                                onToggleFavorite: () => _toggleFavorite(server),
                              ),
                            ))
                        .toList(),
                  )
                else if (!_loading && _error == null)
                  FeaturedServersGrid(onGroupSelect: _handleFeaturedClick),
              ],
            ),
          ),
        ),
          ],
        );
  }

  Widget _buildFavoritesView() {
    if (_favorites.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: ScreenUtilHelper.paddingVertical(12),
          child: Container(
            padding: ScreenUtilHelper.paddingVertical(80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF27272A), style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(Icons.star_border, size: 48.w, color: const Color(0x3371717A)),
                ScreenUtilHelper.sizedBoxHeight(16.0),
                FittedBox(
                  child: Text(
                    tr('server.search.no_favorites'),
                    style: TextStyle(
                      color: const Color(0xFFA1A1AA),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Geist',
                    ),
                  ),
                ),
                ScreenUtilHelper.sizedBoxHeight(8.0),
                Padding(
                  padding: ScreenUtilHelper.paddingHorizontal(40),
                  child: FittedBox(
                    child: Text(
                      tr('server.search.favorites_help'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF52525B),
                        fontSize: 12.sp,
                        fontFamily: 'Geist',
                      ),
                    ),
                  ),
                ),
                ScreenUtilHelper.sizedBoxHeight(24.0),
                InkWell(
                  onTap: () => setState(() => _searchMode = 'SEARCH'),
                  child: FittedBox(
                    child: Text(
                      tr('server.search.tabs.search').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFF97316),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
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

    return ListView.separated(
      padding: ScreenUtilHelper.paddingVertical(12),
      itemCount: _favorites.length,
      separatorBuilder: (_, __) => ScreenUtilHelper.sizedBoxHeight(12.0),
      itemBuilder: (context, index) {
        final server = _favorites[index];
        return ServerListItem(
          server: server,
          isFavorite: true,
          onSelect: () => _handleSelectServer(server),
          onToggleFavorite: () => _toggleFavorite(server),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          _FilterChip(
            label: 'SOLO',
            active: _groupFilter == 'SOLO',
            onTap: () => _toggleGlobalFilter('SOLO'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'DUO',
            active: _groupFilter == 'DUO',
            onTap: () => _toggleGlobalFilter('DUO'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'TRIO',
            active: _groupFilter == 'TRIO',
            onTap: () => _toggleGlobalFilter('TRIO'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'VANILLA',
            active: _moddedFilter == 'VANILLA',
            onTap: () => _toggleGlobalFilter('VANILLA'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'MODDED',
            active: _moddedFilter == 'MODDED',
            onTap: () => _toggleGlobalFilter('MODDED'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: '2X',
            active: _rateFilter == '2X',
            onTap: () => _toggleGlobalFilter('2X'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: '3X+',
            active: _rateFilter == '3X+',
            onTap: () => _toggleGlobalFilter('3X+'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'NO BP',
            active: _noBpFilter,
            onTap: () => _toggleGlobalFilter('NO BP'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'KITS',
            active: _kitsFilter,
            onTap: () => _toggleGlobalFilter('KITS'),
          ),
          SizedBox(width: 16.w),
          // Sort Options as Chips
          _FilterChip(
            label: tr('server.search.sort.high_pop').toUpperCase(),
            active: _sortBy == '-players',
            onTap: () => _handleSortChange('-players'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: tr('server.search.sort.low_pop').toUpperCase(),
            active: _sortBy == 'players',
            onTap: () => _handleSortChange('players'),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: tr('server.search.sort.just_wiped').toUpperCase(),
            active: _sortBy == '-details.rust_last_wipe',
            onTap: () => _handleSortChange('-details.rust_last_wipe'),
          ),
        ],
      ),
    );
  }

  void _toggleGlobalFilter(String label) {
    setState(() {
      if (label == 'SOLO') _groupFilter = _groupFilter == 'SOLO' ? 'ALL' : 'SOLO';
      else if (label == 'DUO') _groupFilter = _groupFilter == 'DUO' ? 'ALL' : 'DUO';
      else if (label == 'TRIO') _groupFilter = _groupFilter == 'TRIO' ? 'ALL' : 'TRIO';
      else if (label == 'VANILLA') _moddedFilter = _moddedFilter == 'VANILLA' ? 'ALL' : 'VANILLA';
      else if (label == 'MODDED') _moddedFilter = _moddedFilter == 'MODDED' ? 'ALL' : 'MODDED';
      else if (label == '2X') _rateFilter = _rateFilter == '2X' ? 'ALL' : '2X';
      else if (label == '3X+') _rateFilter = _rateFilter == '3X+' ? 'ALL' : '3X+';
      else if (label == 'NO BP') _noBpFilter = !_noBpFilter;
      else if (label == 'KITS') _kitsFilter = !_kitsFilter;

      // Build combined query from text input and chips
      String combinedQuery = _controller.text.trim();
      
      List<String> chipTerms = [];
      if (_groupFilter != 'ALL') chipTerms.add('"${_groupFilter.toLowerCase()}"');
      if (_moddedFilter != 'ALL') chipTerms.add('"${_moddedFilter.toLowerCase()}"');
      if (_rateFilter != 'ALL') chipTerms.add('"${_rateFilter.toLowerCase()}"');
      if (_noBpFilter) chipTerms.add('"nobp"');
      if (_kitsFilter) chipTerms.add('"kit"');

      // If we have chips, add them to the query
      if (chipTerms.isNotEmpty) {
        // Avoid duplicating if text input already has the term
        for (var term in chipTerms) {
          String rawTerm = term.replaceAll('"', '');
          if (!combinedQuery.toLowerCase().contains(rawTerm)) {
            combinedQuery += ' $term';
          }
        }
      }

      if (combinedQuery.trim().isNotEmpty) {
         _query = combinedQuery.trim();
         
         // Trigger search with debounce
         _debounce?.cancel();
         _debounce = Timer(const Duration(milliseconds: 300), () {
           _searchServers(_query, _sortBy);
         });
      } else {
        // If everything is cleared, return to initial state
        _debounce?.cancel();
        _query = '';
        _results = [];
        _error = null;
      }
    });
  }
}

class ServerListItem extends StatefulWidget {
  final ServerData server;
  final bool isFavorite;
  final VoidCallback onSelect;
  final VoidCallback onToggleFavorite;

  const ServerListItem({
    super.key,
    required this.server,
    required this.isFavorite,
    required this.onSelect,
    required this.onToggleFavorite,
  });

  @override
  State<ServerListItem> createState() => _ServerListItemState();
}

class _ServerListItemState extends State<ServerListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          HapticHelper.mediumImpact();
          setState(() => _pressed = false);
          widget.onSelect();
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
              border: Border.all(color: const Color(0xFF27272A), width: 1.h),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Server Name - removed FittedBox for proper ellipsis
                    Padding(
                      padding: EdgeInsets.only(right: 32.w),
                      child: Text(
                        widget.server.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Geist',
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    
                    // Server Stats
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Players
                        Row(
                          children: [
                            Icon(LucideIcons.users, size: 12.w, color: const Color(0xFF71717A)),
                            SizedBox(width: 6.w),
                            FittedBox(
                              child: Text(
                                '${widget.server.players}/${widget.server.maxPlayers}',
                                style: TextStyle(
                                  color: const Color(0xFF71717A),
                                  fontSize: 12.sp,
                                  fontFamily: 'RobotoMono',
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 4.h),
                        
                        // Map - removed Expanded+FittedBox for proper ellipsis
                        if (widget.server.map != null)
                          Row(
                            children: [
                              Icon(LucideIcons.map, size: 12.w, color: const Color(0xFF71717A)),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: Text(
                                  widget.server.map!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: const Color(0xFF71717A),
                                    fontSize: 10.sp,
                                    fontFamily: 'RobotoMono',
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${widget.server.ip}:${widget.server.port}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF52525B),
                                fontSize: 12.sp,
                                fontFamily: 'RobotoMono',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                // Favorite Star
                Positioned(
                  top: -8.h,
                  right: -8.w,
                  child: InkWell(
                    onTap: () {
                      HapticHelper.mediumImpact();
                      widget.onToggleFavorite();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        widget.isFavorite ? Icons.star : Icons.star_border,
                        size: 26.w,
                        color: widget.isFavorite 
                            ? const Color(0xFFEAB308) 
                            : const Color(0xFF52525B),
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

const List<Map<String, String>> FEATURED_GROUPS = [
  {'name': 'Facepunch', 'query': 'Facepunch'},
  {'name': 'Rusty Moose', 'query': 'Rusty Moose'},
  {'name': 'Rustoria', 'query': 'Rustoria.co'},
  {'name': 'Rustafied', 'query': 'Rustafied.com'},
  {'name': 'Reddit PlayRust', 'query': 'Reddit.com/r/PlayRust'},
  {'name': 'Vital', 'query': 'Vital Rust'},
  {'name': 'Rusticated', 'query': 'Rusticated.com'},
  {'name': 'Stevious', 'query': 'Stevious'},
  {'name': 'Bloo Lagoon', 'query': 'Bloo Lagoon'},
  {'name': 'Pickle', 'query': 'Pickle'},
  {'name': 'Paranoid', 'query': 'Paranoid'},
  {'name': 'Renegade', 'query': 'Renegade'},
  {'name': 'Werwolf', 'query': 'Werwolf'},
  {'name': 'Hollow', 'query': 'HollowServers.co'},
  {'name': 'Atlas', 'query': 'Atlas'},
  {'name': 'Upsurge', 'query': 'Upsurge'},
  {'name': 'Garnet', 'query': 'Garnet.gg'},
  {'name': 'RustReborn', 'query': 'RustReborn.gg'},
  {'name': 'UKN.GG', 'query': 'UKN.GG'},
  {'name': 'Magic Rust', 'query': 'Magic Rust'},
  {'name': 'WARBANDITS', 'query': 'WARBANDITS.GG'},
  {'name': 'Rustopia', 'query': 'Rustopia.gg'},
  {'name': 'Bestrust', 'query': 'Bestrust'},
  {'name': 'Survivors.gg', 'query': 'Survivors.gg'},
  {'name': 'AceRust', 'query': 'AceRust.com'},
  {'name': 'RustResort', 'query': 'RustResort.com'},
  {'name': 'Brasa.gg', 'query': 'Brasa.gg'},
  {'name': 'Lone Wolf', 'query': 'Lone Wolf'},
  {'name': 'Intoxicated', 'query': 'Intoxicated'},
  {'name': 'Rustadia', 'query': 'Rustadia'},
  {'name': 'Rust for Noobs', 'query': 'RustForNoobs.com'},
];

class FeaturedServersGrid extends StatelessWidget {
  final Function(String) onGroupSelect;

  const FeaturedServersGrid({
    super.key,
    required this.onGroupSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Icon(LucideIcons.flame, size: 16.w, color: const Color(0xFFF97316)),
              ScreenUtilHelper.sizedBoxWidth(8),
              FittedBox(
                child: Text(
                  tr('server.featured.title'),
                  style: TextStyle(
                    color: const Color(0xFFA1A1AA),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    fontFamily: 'Geist',
                  ),
                ),
              ),
            ],
          ),
        ),
        ScreenUtilHelper.sizedBoxHeight(16),

        // Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 8.h,
          ),
          itemCount: FEATURED_GROUPS.length,
          itemBuilder: (context, index) {
            final group = FEATURED_GROUPS[index];
            return _FeaturedGroupButton(
              name: group['name']!,
              onTap: () {
                HapticHelper.mediumImpact();
                onGroupSelect(group['query']!);
              },
            );
          },
        ),
      ],
    );
  }
}

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
        scale: _pressed ? 0.98 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF18181B),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFF27272A),
            ),
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                widget.name.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  fontFamily: 'Geist',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
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
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF97316).withOpacity(0.1) : const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: active ? const Color(0xFFF97316) : const Color(0xFF27272A),
          ),
        ),
        child: FittedBox(
          child: Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFFF97316) : const Color(0xFFA1A1AA),
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Geist',
            ),
          ),
        ),
      ),
    );
  }
}


