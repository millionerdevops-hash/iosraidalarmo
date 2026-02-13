import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/data/raidData.dart';
import 'package:raidalarm/widgets/raid/explosivecard.dart';
import 'package:raidalarm/widgets/raid/raidcategorytabs.dart';
import 'package:raidalarm/widgets/raid/raidtargetgrid.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';


class RaidCalculatorScreen extends ConsumerStatefulWidget {
  const RaidCalculatorScreen({super.key});

  @override
  ConsumerState<RaidCalculatorScreen> createState() => _RaidCalculatorScreenState();
}

class _CartItem {
  const _CartItem({
    required this.id,
    required this.count,
  });

  final String id;
  final int count;
}

class _RaidOption {
  const _RaidOption({
    required this.type,
    required this.totalQty,
    required this.totalSulfur,
    required this.isImmune,
  });

  final ExplosiveType type;
  final int totalQty;
  final int totalSulfur;
  final bool isImmune;
}

class _RaidCalculatorScreenState extends ConsumerState<RaidCalculatorScreen>
    with SingleTickerProviderStateMixin {
  String _selectedTargetId = 'metal_door';
  int _count = 1;
  RaidCategory _activeCategory = RaidCategory.door;

  final List<_CartItem> _raidCart = []; 

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  RaidTarget get _target {
    return targets.firstWhere(
      (t) => t.id == _selectedTargetId,
      orElse: () => targets.first,
    );
  }

  List<RaidTarget> get _filteredTargets {
    return targets.where((t) => t.category == _activeCategory).toList();
  }

  void _increment() {
    HapticHelper.lightImpact();
    setState(() => _count = (_count + 1).clamp(1, 99));
  }

  void _decrement() {
    HapticHelper.lightImpact();
    setState(() => _count = (_count - 1).clamp(1, 99));
  }

  void _removeFromCart(String id) {
    HapticHelper.lightImpact();
    setState(() {
      _raidCart.removeWhere((item) => item.id == id);
    });
  }

  void _clearCart() {
    HapticHelper.lightImpact();
    setState(() {
      _raidCart.clear();
    });
  }
  
  void _handleBack() {
    if (!mounted) return;
    context.go('/tools');
  }

  // --- CALCULATION LOGIC ---
  List<_RaidOption> _calculateOptions() {
    // Determine what to calculate: The Cart OR The Single Selection
    final itemsToCalculate = _raidCart.isNotEmpty
        ? _raidCart
        : [_CartItem(id: _selectedTargetId, count: _count)];

    // Determine valid explosives list to iterate (Filter Logic)
    List<ExplosiveType> explosivesToIterate = mandatoryLoadout;
    
    // Check if there is a recommended loadout for the current selection (Single item mode only)
    if (_raidCart.isEmpty && recommendedLoadouts.containsKey(_selectedTargetId)) {
      explosivesToIterate = recommendedLoadouts[_selectedTargetId]!;
    }
    
    // Map to results
    final options = explosivesToIterate.map((explosiveType) {
      var totalQty = 0;
      var isImmune = true; // Assume immune until proven otherwise

      for (final item in itemsToCalculate) {
        final currentTarget = targets.where((t) => t.id == item.id).firstOrNull;
        if (currentTarget == null) continue;

        // 1. Check for Hardcoded Cost in Data
        // Cost is partial map, if missing used logic below.
        int? qtyPerItem = currentTarget.cost[explosiveType];
        var currentIsImmune = false;

        // 2. Logic for Undefined Costs
        if (qtyPerItem == null) {
          // If User wants strict manual control, skip auto-calc
          if (currentTarget.explicitCostsOnly) {
             continue; 
          }

          final isHardStructure = [
            Tier.stone,
            Tier.metal,
            Tier.hqm,
            Tier.glass
          ].contains(currentTarget.tier);
          
          final isConstruction = [
            RaidCategory.construction,
            RaidCategory.placeable,
            RaidCategory.door
          ].contains(currentTarget.category);

          // Explosive Class Definitions
          final isTrueExplosive = [
            ExplosiveType.c4,
            ExplosiveType.rocket,
            ExplosiveType.satchel,
            ExplosiveType.beancan,
            ExplosiveType.heGrenade,
            ExplosiveType.heGrenade40mm,
            ExplosiveType.explo556,
            ExplosiveType.hvRocket,
            ExplosiveType.mlrsRocket, 
            ExplosiveType.propaneBomb,
            ExplosiveType.surveyCharge,
          ].contains(explosiveType);

          final isFireDamage = [
            ExplosiveType.molotov,
            ExplosiveType.incenRocket,
            ExplosiveType.arrowFire,
            ExplosiveType.ammoIncenShell,
            ExplosiveType.ammoRifleIncen,
            ExplosiveType.ammoPistolIncen,
          ].contains(explosiveType);

          final isMeleeOrBullet = [
            ExplosiveType.ammoRifle,
            ExplosiveType.ammoPistol,
            ExplosiveType.ammoBuckshot,
            ExplosiveType.ammoSlug,
            ExplosiveType.arrowWooden,
            ExplosiveType.arrowHv,
            ExplosiveType.arrowBone,
          ].contains(explosiveType);

          // Immunity Rules
          if (isHardStructure && isConstruction) {
             // Hard structures take NO damage from standard bullets/arrows/melee
             if (isMeleeOrBullet) {
               currentIsImmune = true;
               qtyPerItem = 0;
             }
             // Hard structures take NO damage from Fire (except Incen Rocket)
             else if (isFireDamage && explosiveType != ExplosiveType.incenRocket) {
               currentIsImmune = true;
               qtyPerItem = 0;
             }
             // Must be explosive
             else if (!isTrueExplosive) {
               currentIsImmune = true;
               qtyPerItem = 0;
             }
          }

          // If still valid, calculate based on HP
          if (!currentIsImmune) {
            final dmg = damagePerHit[explosiveType] ?? 0;
            if (dmg > 0) {
              qtyPerItem = (currentTarget.hp / dmg).ceil();
            } else {
              currentIsImmune = true;
              qtyPerItem = 0;
            }
          }
        }

        // Accumulate if damageable
        if (!currentIsImmune && qtyPerItem != null) {
          isImmune = false; // at least one item can be damaged
          totalQty += (qtyPerItem * item.count);
        }
      }

      // Calculate Sulfur Cost for total batch
      final recipe = craftingRecipes[explosiveType];
      final totalSulfur = recipe != null ? recipe.sulfur * totalQty : 0;

      return _RaidOption(
        type: explosiveType,
        totalQty: totalQty,
        totalSulfur: totalSulfur.ceil(),
        isImmune: isImmune,
      );
    }).toList();

    // Sort logic
    options.sort((a, b) {
      if (a.isImmune && !b.isImmune) return 1;
      if (!a.isImmune && b.isImmune) return -1;
      
      if (a.totalSulfur != b.totalSulfur) {
        return a.totalSulfur.compareTo(b.totalSulfur);
      }
      return a.totalQty.compareTo(b.totalQty);
    });

    return options.where((opt) => !opt.isImmune && opt.totalQty > 0).toList();
  }



  @override
  Widget build(BuildContext context) {
    final options = _calculateOptions();
    final cheapestSulfur = options.fold<int>(
      1000000000, // Infinity placeholder
      (min, opt) {
        if (!opt.isImmune && opt.totalSulfur > 0 && opt.totalSulfur < min) return opt.totalSulfur;
        return min;
      },
    );

    return RustScreenLayout(
      child: Scaffold(
      backgroundColor: const Color(0xFF0C0C0E), // bg-[#0c0c0e]
      body: SafeArea(
        child: Column(
          children: [
            // Header
              _Header(
                onBack: _handleBack,
              ),
            
            Expanded(
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                       // Voice Prompt Banner usually fixed, but here let's follow logic. 
                       // In RN it is fixed top-20. We will put it in Stack.
                       
                       // Cart Mode or Single Mode
                       if (_raidCart.isNotEmpty)
                          SliverToBoxAdapter(
                            child: _CartModeUI(
                              cart: _raidCart,
                              onClear: _clearCart,
                              onRemove: _removeFromCart,
                            ),
                          )
                       else ...[
                          // Category Tabs
                          SliverToBoxAdapter(
                            child: RaidCategoryTabs(
                              activeCategory: _activeCategory,
                              onSelect: (cat) {
                                HapticHelper.lightImpact();
                                setState(() {
                                  _activeCategory = cat;
                                  _selectedTargetId = targets.firstWhere((t) => t.category == cat).id;
                                });
                              },
                            ),
                          ),
                          
                          // Sticky Action Bar
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _StickyActionBarDelegate(
                                target: _target,
                                count: _count,
                                onIncrement: _increment,
                                onDecrement: _decrement,
                            ),
                          ),
                          
                          // Target Grid
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(top: 14.h),
                              child: RaidTargetGrid(
                                targets: _filteredTargets,
                                selectedId: _selectedTargetId,
                                onSelect: (id) {
                                  HapticHelper.lightImpact();
                                  setState(() => _selectedTargetId = id);
                                },
                              ),
                            ),
                          ),
                       ],
                       
                       // Results List
                       SliverPadding(
                         padding: EdgeInsets.symmetric(horizontal: 16.w),
                         sliver: SliverList(
                           delegate: SliverChildListDelegate([
                             // Title
                             Padding(
                               padding: EdgeInsets.only(bottom: 12.h),
                               child: Row(
                                 children: [
                                   Icon(LucideIcons.listFilter, size: 12.w, color: const Color(0xFFF97316)), // orange-500
                                   SizedBox(width: 8.w),
                                   FittedBox(
                                     child: Text(
                                       _raidCart.isNotEmpty ? tr('raid.calculator.materials_breakdown') : tr('raid.calculator.materials_breakdown'),
                                       style: TextStyle(
                                         color: const Color(0xFF71717A), // zinc-500
                                         fontSize: 10.sp,
                                         fontWeight: FontWeight.bold,
                                         letterSpacing: 1.2.w,
                                         fontFamily: 'Geist',
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             
                             // Cards
                             ...options.map((opt) => Padding(
                               padding: EdgeInsets.only(bottom: 12.h),
                               child: ExplosiveCard(
                                 type: opt.type,
                                 totalQty: opt.totalQty,
                                 totalSulfur: opt.totalSulfur,
                                 isBestSulfur: opt.totalSulfur == cheapestSulfur && opt.totalSulfur > 0,
                                 isImmune: opt.isImmune,
                               ),
                             )),
                             
                             SizedBox(height: 24.h),
                           ]),
                         ),
                       ),
                    ],
                  ),
                  
                  // Microphone Button (Floating)
                  // if (_raidCart.isEmpty)... (Not implemented yet as per code view)

                ],
              ),
            ),

          ],
        ),
      ),
      ),
    );
  }
}

// --- WIDGETS ---

class _Header extends StatelessWidget {
  const _Header({
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    // Buttons styling logic


    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0E),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1.w,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left: Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                HapticHelper.lightImpact();
                onBack();
              },
              icon: Icon(LucideIcons.arrowLeft, color: const Color(0xFFA1A1AA), size: 22.w),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          
          // Center: Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('raid.calculator.title'),
                style: TextStyle(
                  fontSize: 18.sp, 
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rust', 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}



class _StickyActionBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyActionBarDelegate({
    required this.target,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  final RaidTarget target;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: const Color(0xF20C0C0E), // bg-[#0c0c0e]/95
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.symmetric(horizontal: BorderSide(color: const Color(0xFF27272A), width: 1.w)), // border-zinc-800
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   // Left Info
                   Expanded(
                     child: Padding(
                       padding: EdgeInsets.only(right: 8.w), // Add padding to avoid touching buttons
                       child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tr('raid.calculator.select_target').toUpperCase(), 
                              style: TextStyle(color: const Color(0xFF71717A), fontSize: 9.sp, fontWeight: FontWeight.w900, letterSpacing: 1.5.w)
                            ),
                          ),
                          SizedBox(height: 4.h),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tr(target.label).toUpperCase(), 
                              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w900, height: 1.0)
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF27272A),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: const Color(0xFF3F3F46), width: 1.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.shield, size: 12.w, color: const Color(0xFF3B82F6)),
                                SizedBox(width: 4.w),
                                Text(
                                  '${target.hp} HP', 
                                  style: TextStyle(color: const Color(0xFFD4D4D8), fontFamily: 'monospace', fontSize: 10.sp, fontWeight: FontWeight.bold)
                                ),
                              ],
                            ),
                          ),
                       ],
                     ),
                   ),
                   ),
                   
                   // Right Counter
                   Container(
                     padding: EdgeInsets.all(4.w),
                     decoration: BoxDecoration(
                       color: Colors.black,
                       borderRadius: BorderRadius.circular(8.r),
                       border: Border.all(color: const Color(0xFF27272A), width: 1.w),
                     ),
                     child: Row(
                       children: [
                         _CounterBtn(icon: LucideIcons.minus, onTap: onDecrement, color: const Color(0xFF18181B), iconColor: const Color(0xFFA1A1AA)),
                         SizedBox(
                           width: 36.w,
                           child: Text(
                             '$count', 
                             textAlign: TextAlign.center, 
                             style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold, fontFamily: 'monospace')
                           ),
                         ),
                         _CounterBtn(icon: LucideIcons.plus, onTap: onIncrement, color: const Color(0xFFEA580C), iconColor: Colors.white), // orange-600
                       ],
                     ),
                   ),
                ],
              ),
            ), 
          ),
        ),
    );
  }

  @override
  double get maxExtent => 110.h; // Adjust based on content height

  @override
  double get minExtent => 110.h;

  @override
  bool shouldRebuild(covariant _StickyActionBarDelegate oldDelegate) {
    return oldDelegate.target != target || oldDelegate.count != count;
  }
}

class _CounterBtn extends StatelessWidget {
  const _CounterBtn({required this.icon, required this.onTap, required this.color, required this.iconColor});
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w, height: 28.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            icon == LucideIcons.minus ? '−' : '+',
            style: TextStyle(
              color: iconColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CartModeUI extends StatelessWidget {
  const _CartModeUI({required this.cart, required this.onClear, required this.onRemove});
  final List<_CartItem> cart;
  final VoidCallback onClear;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.listPlus, size: 16.w, color: const Color(0xFFF97316)),
                  SizedBox(width: 8.w),
                  FittedBox(
                    child: Text(tr('raid.calculator.custom_plan'), style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: Colors.transparent, // hover bg-red-950/20 ignored
                  ),
                  child: FittedBox(
                    child: Text(tr('raid.calculator.clear_all'), style: TextStyle(color: const Color(0xFFEF4444), fontSize: 10.sp, fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 12.h),
          ...cart.map((item) {
             final t = targets.firstWhere((element) => element.id == item.id, orElse: ()=>targets.first);
             return Container(
               margin: EdgeInsets.only(bottom: 8.h),
               padding: EdgeInsets.all(8.w),
               decoration: BoxDecoration(
                 color: const Color(0xFF18181B), // zinc-900
                 border: Border.all(color: const Color(0xFF27272A), width: 1.w),
                 borderRadius: BorderRadius.circular(8.r),
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                    Expanded(
                      child: Row(
                        children: [
                           Container(
                             width: 32.w, height: 32.w,
                             decoration: BoxDecoration(
                               color: Colors.black,
                               borderRadius: BorderRadius.circular(4.r),
                               border: Border.all(color: const Color(0xFF27272A), width: 1.w),
                             ),
                             padding: EdgeInsets.all(4.w),
                             child: Image.asset(t.img, fit: BoxFit.contain, cacheWidth: 64),
                           ),
                           SizedBox(width: 12.w),
                           Expanded(
                             child: FittedBox(
                               fit: BoxFit.scaleDown,
                               alignment: Alignment.centerLeft,
                               child: Text(
                                 tr(t.label), 
                                 style: TextStyle(color: const Color(0xFFE4E4E7), fontSize: 12.sp, fontWeight: FontWeight.bold)
                               ),
                             ),
                           ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text('x${item.count}', style: TextStyle(color: const Color(0xFFF97316), fontFamily: 'monospace', fontSize: 12.sp, fontWeight: FontWeight.w900)),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () => onRemove(item.id),
                          child: Icon(LucideIcons.x, size: 16.w, color: const Color(0xFF52525B)), // text-zinc-600
                        ),
                      ],
                    )
                 ],
               ),
             );
          }).toList(),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: const Color(0xFF27272A)),
        ],
      ),
    );
  }
}
