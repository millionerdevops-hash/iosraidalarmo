import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/screen_util_helper.dart';
import '../../models/camera_code.dart';
import '../../data/cctv_data.dart';
import '../../widgets/CCTVCardWidget.dart';
import '../../widgets/common/rust_screen_layout.dart';
import '../../core/theme/rust_typography.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class CCTVCodesScreen extends ConsumerStatefulWidget {
  const CCTVCodesScreen({super.key});

  @override
  ConsumerState<CCTVCodesScreen> createState() => _CCTVCodesScreenState();
}

class _CCTVCodesScreenState extends ConsumerState<CCTVCodesScreen> {
  String _activeCategory = 'ALL';
  
  void _handleBack() {
    if (!mounted) return;
    if (mounted) context.go('/tools');
  }

  @override
  void initState() {
    super.initState();
  }

  void _onCategoryChanged(String category) {
    if (_activeCategory != category) {
      HapticHelper.lightImpact();
      setState(() => _activeCategory = category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0E),
      body: RustScreenLayout(
        child: SafeArea(
          child: Column(
            children: [
              // Static Header - never rebuilds
              _CCTVHeader(onBack: _handleBack),
              
              // Category Tabs - only rebuilds when category changes
              _CategoryTabs(
                activeCategory: _activeCategory,
                onCategoryChanged: _onCategoryChanged,
              ),
              
              // Grid Content - only rebuilds when category changes
              Expanded(
                child: _CCTVGrid(
                  activeCategory: _activeCategory,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// Static Header Widget - NEVER rebuilds
class _CCTVHeader extends StatelessWidget {
  const _CCTVHeader({required this.onBack});
  
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0E),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
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
                HapticHelper.lightImpact();
                onBack();
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
                tr('cctv_codes.ui.title'),
                style: RustTypography.rustStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  weight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Category Tabs Widget - only rebuilds when activeCategory changes
class _CategoryTabs extends StatelessWidget {
  final String activeCategory;
  final ValueChanged<String> onCategoryChanged;

  const _CategoryTabs({
    required this.activeCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0C0C0E),
        border: Border(
          bottom: BorderSide(
            color: Color(0x1A27272A),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: SizedBox(
        height: 32.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: cctvCategories.length,
          separatorBuilder: (context, index) => ScreenUtilHelper.sizedBoxWidth(8),
          itemBuilder: (context, index) {
            final category = cctvCategories[index];
            final isActive = activeCategory == category.id;

            return _CategoryTab(
              category: category,
              isActive: isActive,
              onTap: () => onCategoryChanged(category.id),
            );
          },
        ),
      ),
    );
  }
}

// Individual Category Tab - stateless for better performance
class _CategoryTab extends StatelessWidget {
  final CCTVCategory category;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.category,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 0,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFDC2626)
              : const Color(0xFF18181B),
          border: Border.all(
            color: isActive
                ? const Color(0xFFDC2626)
                : const Color(0xFF27272A),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr(category.label).toUpperCase(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                color: isActive
                    ? Colors.white
                    : const Color(0xFF71717A),
                letterSpacing: 1.5.w,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Grid Widget - only rebuilds when activeCategory changes
class _CCTVGrid extends StatefulWidget {
  final String activeCategory;

  const _CCTVGrid({
    required this.activeCategory,
  });

  @override
  State<_CCTVGrid> createState() => _CCTVGridState();
}

class _CCTVGridState extends State<_CCTVGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<CameraCode> get _filteredItems {
    return cctvCodes.where((item) {
      return widget.activeCategory == 'ALL' || item.category == widget.activeCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    if (filteredItems.isEmpty) {
      return const _EmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjusted aspect ratio to 0.95 for a bit more height (safeguard for padding)
        const double childAspectRatio = 0.95;

        return GridView.builder(
          key: PageStorageKey<String>('cctv_grid_${widget.activeCategory}'),
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h), // Better padding for list
          cacheExtent: 500,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w, // Slightly tighter spacing
            mainAxisSpacing: 10.h,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return RepaintBoundary(
              child: CCTVCardWidget(
                key: ValueKey(item.id),
                item: item,
                onTap: () {
                  HapticHelper.lightImpact();
                  // Clipboard logic removed/not present in original, just generic tap for now
                },
              ),
            );
          },
        );
      },
    );
  }
}

// Empty State Widget - const for performance
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.grid_4x4,
              size: 48.w,
              color: const Color(0xFF52525B),
            ),
            ScreenUtilHelper.sizedBoxHeight(16),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('cctv_codes.ui.no_signal'),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF52525B),
                  fontFamily: 'monospace',
                  letterSpacing: 1.5.w,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
