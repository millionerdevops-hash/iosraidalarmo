import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/data/teaData.dart'; // Import created Tea Data
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeaCalculatorScreen extends ConsumerStatefulWidget {
  const TeaCalculatorScreen({super.key});

  @override
  ConsumerState<TeaCalculatorScreen> createState() => _TeaCalculatorScreenState();
}

class _TeaCalculatorScreenState extends ConsumerState<TeaCalculatorScreen> {
  String _activeCategory = 'Ore';
  TeaDef? _selectedTea;
  
  void _handleBack() {
    if (!mounted) return;
    if (mounted) context.go('/tools');
  }

  @override
  void initState() {
    super.initState();
    _updateSelectedTea();
  }

  void _updateSelectedTea() {
    // Default to the Basic tea of the category
    final firstTea = teaDatabase.firstWhere(
      (t) => t.type == _activeCategory && t.tier == 'Basic',
      orElse: () => teaDatabase.firstWhere((t) => t.type == _activeCategory),
    );
    setState(() {
      _selectedTea = firstTea;
    });
  }

  void _setActiveCategory(String categoryId) {
    if (_activeCategory != categoryId) {
      HapticHelper.lightImpact();
      setState(() {
        _activeCategory = categoryId;
      });
      _updateSelectedTea();
    }
  }

  List<TeaDef> get _sortedTeas {
    final filtered = teaDatabase.where((t) => t.type == _activeCategory).toList();
    // Sort: Basic -> Advanced -> Pure
    final order = {'Basic': 0, 'Advanced': 1, 'Pure': 2};
    filtered.sort((a, b) => (order[a.tier] ?? 99).compareTo(order[b.tier] ?? 99));
    return filtered;
  }

  // Category Definitions
  final List<Map<String, dynamic>> _categories = [
    {'id': 'Ore', 'label': 'tea_guide_details.categories.Ore', 'icon': LucideIcons.pickaxe, 'color': const Color(0xFFEAB308)}, // yellow-500
    {'id': 'Wood', 'label': 'tea_guide_details.categories.Wood', 'icon': LucideIcons.trees, 'color': const Color(0xFFD97706)}, // amber-600
    {'id': 'Scrap', 'label': 'tea_guide_details.categories.Scrap', 'icon': LucideIcons.recycle, 'color': const Color(0xFFD4D4D8)}, // zinc-300
    {'id': 'Harvesting', 'label': 'tea_guide_details.categories.Harvesting', 'icon': LucideIcons.wheat, 'color': const Color(0xFFA3E635)}, // lime-400
    {'id': 'MaxHealth', 'label': 'tea_guide_details.categories.MaxHealth', 'icon': LucideIcons.heart, 'color': const Color(0xFF10B981)}, // emerald-500
    {'id': 'Healing', 'label': 'tea_guide_details.categories.Healing', 'icon': LucideIcons.activity, 'color': const Color(0xFFEF4444)}, // red-500
    {'id': 'Rad', 'label': 'tea_guide_details.categories.Rad', 'icon': LucideIcons.radiation, 'color': const Color(0xFFF97316)}, // orange-500
    {'id': 'Cooling', 'label': 'tea_guide_details.categories.Cooling', 'icon': LucideIcons.snowflake, 'color': const Color(0xFF22D3EE)}, // cyan-400
    {'id': 'Warming', 'label': 'tea_guide_details.categories.Warming', 'icon': LucideIcons.flame, 'color': const Color(0xFFFDBA74)}, // orange-300
    {'id': 'Crafting', 'label': 'tea_guide_details.categories.Crafting', 'icon': LucideIcons.hammer, 'color': const Color(0xFFC084FC)}, // purple-400
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0E),
      body: RustScreenLayout(
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Category Tabs
              _buildCategoryTabs(),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      // Selected Tea Detail Card
                      if (_selectedTea != null) _buildDetailCard(_selectedTea!),
                      
                      ScreenUtilHelper.sizedBoxHeight(24.0),

                      // Tea List Selection
                      _buildTeaList(context),

                      SizedBox(height: 32.h), // Bottom padding
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
                HapticHelper.lightImpact();
                _handleBack();
              },
              icon: Icon(Icons.arrow_back, color: const Color(0xFFA1A1AA), size: 24.w),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tr('tea_guide_details.ui.title'),
                  style: RustTypography.rustStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0E),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF18181B), // zinc-900 matches
            width: 1.h,
          ),
        ),
      ),
      child: SizedBox(
        height: 32.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: _categories.length,
          separatorBuilder: (context, index) => ScreenUtilHelper.sizedBoxWidth(8.0),
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final isActive = _activeCategory == cat['id'];
            final iconColor = isActive ? (cat['color'] as Color) : const Color(0xFF52525B); // zinc-600

            return GestureDetector(
              onTap: () => _setActiveCategory(cat['id']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF27272A) : const Color(0xFF18181B), // zinc-800 : zinc-900
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isActive ? const Color(0xFF52525B) : Colors.transparent, // zinc-600 : transparent
                    width: 1.w,
                  ),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.05),
                      blurRadius: 15,
                      spreadRadius: 0,
                    )
                  ] : [],
                ),
                child: Row(
                  children: [
                    Icon(cat['icon'], size: 12.w, color: iconColor),
                    SizedBox(width: 8.w),
                    FittedBox(
                      child: Text(
                        tr(cat['label']).toUpperCase(),
                        style: RustTypography.monoStyle(
                          fontSize: 10.sp,
                          weight: FontWeight.bold,
                          color: isActive ? Colors.white : const Color(0xFF71717A), // zinc-500
                          letterSpacing: 0.5.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailCard(TeaDef tea) {
    final catColor = _categories.firstWhere((c) => c['id'] == tea.type)['color'] as Color;
    
    return Column(
      children: [
        // Main Tea Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C0E), 
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                catColor.withOpacity(0.15),
                const Color(0xFF0C0C0E),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: catColor.withOpacity(0.3),
              width: 1.w,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Content (With Padding)
              Padding(
                padding: EdgeInsets.all(24.w), // Original Input Padding
                child: Column(
                  children: [
                    SizedBox(height: 16.h), // Top spacing for visual balance if needed, or remove
                    // Image
                    Container(
                      width: 128.w, // Match RN w-32 (128px)
                      height: 128.w,
                      margin: EdgeInsets.only(bottom: 8.h), // Match RN mb-2 (8px)
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: ResizeImage(AssetImage(tea.image), width: 256), // cacheWidth: 256
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Name
                    FittedBox(
                      child: Text(
                        tr(tea.name).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: RustTypography.rustStyle(
                          fontSize: 16.sp,
                          weight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h), // Match RN mb-3 (12px)

                    // Stats Pills
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: tea.stats.map((stat) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (stat.label == 'tea_guide_details.stats.hydration') ...[
                                Icon(LucideIcons.droplets, size: 12.w, color: const Color(0xFF22D3EE)), // cyan-400
                                SizedBox(width: 6.w),
                              ],
                              FittedBox(
                                child: Text(
                                  '${tr(stat.label)} ',
                                  style: RustTypography.monoStyle(
                                    fontSize: 10.sp,
                                    weight: FontWeight.bold,
                                    color: const Color(0xFFA1A1AA), // zinc-400
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  stat.value,
                                  style: RustTypography.monoStyle(
                                    fontSize: 10.sp,
                                    weight: FontWeight.bold,
                                    color: stat.isPositive 
                                        ? const Color(0xFF4ADE80) // green-400
                                        : const Color(0xFFF87171), // red-400
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 16.h, // Match RN top-4 (16px)
                right: 16.w, // Match RN right-4 (16px)
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.timer, size: 12.w, color: Colors.white.withOpacity(0.7)),
                      SizedBox(width: 6.w),
                      FittedBox(
                        child: Text(
                          tr(tea.duration),
                          style: RustTypography.monoStyle(
                            fontSize: 10.sp,
                            weight: FontWeight.bold,
                            color: const Color(0xFFE4E4E7), // zinc-200
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Mixing Table Recipe Box
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF18181B), // zinc-900 (approx)
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFF27272A), width: 1.h), // zinc-800
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.flaskConical, size: 16.w, color: const Color(0xFFA855F7)), // purple-500
                  SizedBox(width: 8.w),
                  FittedBox(
                    child: Text(
                      tr('tea_guide_details.ui.mixing_table_recipe'),
                      style: RustTypography.rustStyle(
                        fontSize: 10.sp,
                        weight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2.w,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start, // Align everything to top so image boxes match icons
                children: [
                  // Inputs
                  ...tea.recipe.inputs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final input = entry.value;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align top
                      children: [
                        if (index > 0)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: SizedBox( // Sized box for alignment
                              height: 56.w, 
                              child: Center(
                                child: Text('+', style: TextStyle(color: const Color(0xFF52525B), fontSize: 18.sp, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        _buildIngredientItem(tr(input.name), input.count, input.img),
                      ],
                    );
                  }).toList(),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column( // Wrap in Column to match structure
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox( // Align with the box height
                           height: 56.w,
                           child: Center(
                              child: Icon(Icons.arrow_forward, size: 16.w, color: const Color(0xFF71717A)),
                           ),
                        ),
                      ],
                    ),
                  ),

                  // Output (This Tea)
                  _buildIngredientItem(tr('tea_guide_details.tiers.${tea.tier}'), 1, tea.image, isOutput: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientItem(String name, int count, String imgPath, {bool isOutput = false}) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: isOutput ? const Color(0xFF27272A) : Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isOutput ? const Color(0xFF52525B) : const Color(0xFF3F3F46),
                ),
                boxShadow: isOutput ? [const BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))] : null,
              ),
              alignment: Alignment.center,
              child: Image.asset(imgPath, width: 40.w, height: 40.w, fit: BoxFit.contain, cacheWidth: 80),
            ),
            Positioned(
              top: -6.h,
              right: -6.w,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: isOutput ? const Color(0xFF22C55E) : const Color(0xFF27272A),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isOutput ? const Color(0xFF4ADE80) : const Color(0xFF52525B),
                    width: 1,
                  ),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                alignment: Alignment.center,
                  child: FittedBox(
                    child: Text(
                      isOutput ? '1' : 'x$count',
                      style: RustTypography.monoStyle(
                        fontSize: 10.sp,
                        weight: FontWeight.bold,
                        color: isOutput ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
              ),
            ),
          ],
        ),
        ScreenUtilHelper.sizedBoxHeight(8.0),
        SizedBox(
          width: 60.w,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              name.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: RustTypography.monoStyle(
                fontSize: 9.sp,
                weight: FontWeight.bold,
                color: isOutput ? Colors.white : const Color(0xFF71717A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeaList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: FittedBox(
            child: Text(
              tr('tea_guide_details.ui.select_tier'),
              style: RustTypography.rustStyle(
                fontSize: 12.sp,
                weight: FontWeight.bold,
                color: const Color(0xFF71717A),
                letterSpacing: 1.5.w,
              ),
            ),
          ),
        ),
        ..._sortedTeas.map((tea) {
          final isSelected = _selectedTea?.id == tea.id;
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticHelper.lightImpact();
                  setState(() => _selectedTea = tea);
                },
                borderRadius: BorderRadius.circular(12.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF27272A) : const Color(0xFF18181B).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF52525B) : const Color(0xFF27272A),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.h),
                            ),
                            child: Image.asset(tea.image, fit: BoxFit.contain, cacheWidth: 80),
                          ),
                          SizedBox(width: 12.w),
                          FittedBox(
                            child: Text(
                              tr(tea.name),
                              style: RustTypography.rustStyle(
                                fontSize: 12.sp,
                                weight: FontWeight.bold,
                                color: isSelected ? Colors.white : const Color(0xFFA1A1AA),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Tier Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            tr('tea_guide_details.tiers.${tea.tier}').toUpperCase(),
                            style: RustTypography.monoStyle(
                              fontSize: 9.sp,
                              weight: FontWeight.bold,
                              color: tea.color.contains('text-') 
                                  ? _categories.firstWhere((c) => c['id'] == tea.type)['color'] as Color // Dynamic color match
                                  : Colors.white, 
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
