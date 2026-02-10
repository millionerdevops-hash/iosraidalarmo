
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/data/raidData.dart';

class ExplosiveCard extends StatefulWidget {
  const ExplosiveCard({
    super.key,
    required this.type,
    required this.totalQty,
    required this.totalSulfur,
    required this.isBestSulfur,
    required this.isImmune,
  });

  final ExplosiveType type;
  final int totalQty;
  final int totalSulfur;
  final bool isBestSulfur;
  final bool isImmune;

  @override
  State<ExplosiveCard> createState() => _ExplosiveCardState();
}

class _ExplosiveCardState extends State<ExplosiveCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // 1. Calculate totals
    final recipe = craftingRecipes[widget.type]!;
    final totalCharcoal = recipe.charcoal * widget.totalQty;
    final totalMetal = recipe.metal * widget.totalQty;
    final totalFuel = recipe.fuel * widget.totalQty;
    final totalPipes = recipe.pipes * widget.totalQty;
    final totalTech = recipe.tech * widget.totalQty;
    final totalStones = (recipe.stones ?? 0) * widget.totalQty;
    final totalWood = (recipe.wood ?? 0) * widget.totalQty;
    final totalBone = (recipe.bone ?? 0) * widget.totalQty;
    final totalRope = (recipe.rope ?? 0) * widget.totalQty;
    final totalCloth = (recipe.cloth) * widget.totalQty; // Recipe in dart has non-nullable int for cloth

    // 2. Check logic for isLootOnly (matches TS: sulfur=0, metal=0, fuel=0, tech=0, wood=0, stones=0, bone=0, rope=0, cloth=0)
    final isLootOnly = recipe.sulfur == 0 &&
        recipe.metal == 0 &&
        recipe.fuel == 0 &&
        recipe.tech == 0 &&
        (recipe.wood ?? 0) == 0 &&
        (recipe.stones ?? 0) == 0 &&
        (recipe.bone ?? 0) == 0 &&
        (recipe.rope ?? 0) == 0 &&
        (recipe.cloth) == 0;

    final locale = Localizations.localeOf(context).toString();
    final numberFormat = NumberFormat.decimalPattern(locale);

    // 3. Styling Logic
    // React Native:
    // border: isImmune ? border-zinc-800 : (isBestSulfur && !isLootOnly && totalSulfur > 0 ? border-yellow-500/50 : border-zinc-800)
    // bg: isImmune ? bg-zinc-950/50 : (isBestSulfur && !isLootOnly && totalSulfur > 0 ? bg-[#18181b] : bg-zinc-900/40)
    
    final borderNormal = const Color(0xFF27272A); // zinc-800
    final borderColor = widget.isImmune
        ? borderNormal
        : (widget.isBestSulfur && !isLootOnly && widget.totalSulfur > 0)
            ? const Color(0x80EAB308) // yellow-500/50
            : borderNormal;

    final backgroundColor = widget.isImmune
        ? const Color(0xFF09090B).withOpacity(0.5) // zinc-950/50
        : (widget.isBestSulfur && !isLootOnly && widget.totalSulfur > 0)
            ? const Color(0xFF18181B) // #18181b
            : const Color(0xFF18181B).withOpacity(0.4); // zinc-900/40 approx (#18181b is zinc-900)

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(12.r), // rounded-xl
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
          // shadow: isBestSulfur... ? shadow-[0_0_20px_rgba(234,179,8,0.1)]
          boxShadow: (widget.isBestSulfur && !isLootOnly && widget.totalSulfur > 0 && !widget.isImmune)
              ? [
                  BoxShadow(
                    color: Color(0x1AEAB308), // rgba(234,179,8,0.1)
                    blurRadius: 20.r,
                    offset: Offset(0, 0),
                  ),
                ]
              : const [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section
            Padding(
              padding: ScreenUtilHelper.paddingAll(16), // p-4
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon + Quantity/Name
                  Expanded(
                    child: Row(
                      children: [
                        // Image Container
                        _ExplosiveIcon(
                          type: widget.type,
                          highlighted: widget.isBestSulfur && !isLootOnly && widget.totalSulfur > 0,
                          isImmune: widget.isImmune,
                        ),
                        ScreenUtilHelper.sizedBoxWidth(16), // gap-4
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  tr('raid.explosives.${widget.type.key}').toUpperCase(),
                                  style: TextStyle(
                                    color: const Color(0xFFA1A1AA), // text-zinc-400
                                    fontWeight: FontWeight.bold, // font-bold
                                    fontSize: 12.sp, // text-xs
                                    fontFamily: 'Geist',
                                    letterSpacing: 0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ScreenUtilHelper.sizedBoxHeight(4),
                              if (widget.isImmune)
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    tr('raid.explosive_card.ineffective'),
                                    style: TextStyle(
                                      color: Colors.red.shade500, // text-red-500
                                      fontWeight: FontWeight.w900, // font-black
                                      fontSize: 14.sp,
                                      fontFamily: 'Geist',
                                    ),
                                  ),
                                )
                              else
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    numberFormat.format(widget.totalQty),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24.sp, // text-2xl
                                      fontFamily: 'Geist',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Right Side: Loot Only tag (Sulfur moved to breakdown)
                  if (!widget.isImmune && isLootOnly)
                    Padding(
                      padding: EdgeInsets.only(left: 8.0.w),
                      child: Container(
                        padding: ScreenUtilHelper.paddingSymmetric(horizontal: 8, vertical: 4), // px-2 py-1
                        decoration: BoxDecoration(
                          color: const Color(0x331E3A8A), // bg-blue-900/20
                          borderRadius: BorderRadius.circular(4.r), // rounded
                          border: Border.all(color: const Color(0x4D3B82F6)), // border-blue-500/30
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tr('raid.explosive_card.loot_only'),
                            style: TextStyle(
                              color: const Color(0xFF60A5FA), // text-blue-400
                              fontWeight: FontWeight.bold, // font-bold
                              fontSize: 10.sp, // text-[10px]
                              fontFamily: 'Geist',
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Material Breakdown (Grid)
            if (!isLootOnly && !widget.isImmune)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2), // bg-black/20
                  border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))), // border-t border-white/5
                ),
                padding: ScreenUtilHelper.paddingSymmetric(horizontal: 16, vertical: 12), // px-4 py-3
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // grid-cols-3 gap-2
                    // We can use a Wrap or a custom grid row implementation.
                    // Given Wrap handles varying widths better, but Grid is specified...
                    // Let's use a Wrap but try to align to thirds if possible, or just Wrap with spacing.
                    // TS uses `grid grid-cols-3 gap-2`.
                    


                    final items = [
                      if (widget.totalSulfur > 0)
                        _BreakdownItem(
                          value: numberFormat.format(widget.totalSulfur.ceil()),
                          label: tr('raid.materials.sulfur'),
                          valueColor: const Color(0xFFFACC15), // yellow-400
                          textColor: const Color(0x99EAB308), // yellow-500/60
                          dotColor: const Color(0xFFFACC15), // yellow-400
                        ),
                      if (totalCharcoal > 0)
                        _BreakdownItem(
                          value: numberFormat.format(totalCharcoal.ceil()),
                          label: tr('raid.materials.charcoal'),
                          valueColor: const Color(0xFFD4D4D8), // zinc-300
                          textColor: const Color(0xFF52525B), // zinc-600
                          dotColor: const Color(0xFF52525B), // zinc-600
                        ),
                      if (totalMetal > 0)
                        _BreakdownItem(
                          value: numberFormat.format(totalMetal.ceil()),
                          label: tr('raid.materials.fragments'),
                          valueColor: const Color(0xFFBFDBFE), // blue-200
                          textColor: const Color(0x993B82F6), // blue-500/60
                          dotColor: const Color(0xFF60A5FA), // blue-400
                        ),
                      if (totalStones > 0)
                        _BreakdownItem(
                          value: numberFormat.format(totalStones.ceil()),
                          label: tr('raid.materials.stones'),
                          valueColor: const Color(0xFFE4E4E7), // zinc-200
                          textColor: const Color(0x9971717A), // zinc-500/60
                          dotColor: const Color(0xFFA1A1AA), // zinc-400
                        ),
                      if (totalWood > 0)
                        _BreakdownItem(
                          value: numberFormat.format(totalWood.ceil()),
                          label: tr('raid.materials.wood'),
                          valueColor: const Color(0xFFFDE68A), // amber-200
                          textColor: const Color(0x99F59E0B), // amber-500/60
                          dotColor: const Color(0xFFD97706), // amber-600
                        ),
                      if (totalBone > 0)
                        _BreakdownItem(
                          value: numberFormat.format(totalBone.ceil()),
                          label: tr('raid.materials.bone'),
                          valueColor: const Color(0xFFD4D4D8), // zinc-300
                          textColor: const Color(0x9971717A), // zinc-500/60
                          dotColor: const Color(0xFFD4D4D8), // zinc-300
                        ),
                      if (totalFuel > 0)
                        _BreakdownItem(
                          value: numberFormat.format(totalFuel.ceil()),
                          label: tr('raid.materials.low_grade_fuel'),
                          valueColor: const Color(0xFFFED7AA), // orange-200
                          textColor: const Color(0x99F97316), // orange-500/60
                          dotColor: const Color(0xFFF97316), // orange-500
                        ),
                      if (totalCloth > 0)
                        _BreakdownItem(
                          value: numberFormat.format(totalCloth.ceil()),
                          label: tr('raid.materials.cloth'),
                          valueColor: const Color(0xFFE9D5FF), // purple-200
                          textColor: const Color(0x99A855F7), // purple-500/60
                          dotColor: const Color(0xFFC084FC), // purple-400
                        ),
                      if (totalRope > 0)
                         _BreakdownItem(
                           value: numberFormat.format(totalRope.ceil()),
                          label: tr('raid.materials.rope'),
                          valueColor: const Color(0xFFF59E0B), // amber-500
                          textColor: const Color(0x99B45309), // amber-700/60
                          dotColor: const Color(0xFFB45309), // amber-700
                        ),
                      if (totalPipes > 0)
                        _BreakdownItem(
                          value: totalPipes.toString(),
                          label: tr('raid.materials.pipe'),
                          valueColor: const Color(0xFFA7F3D0), // emerald-200
                          textColor: const Color(0x9910B981), // emerald-500/60
                          dotColor: const Color(0xFF10B981), // emerald-500
                        ),
                      if (totalTech > 0)
                        _BreakdownItem(
                          value: totalTech.toString(),
                          label: tr('raid.materials.tech_trash'),
                          valueColor: const Color(0xFFA5F3FC), // cyan-200
                          textColor: const Color(0x9906B6D4), // cyan-500/60
                          dotColor: const Color(0xFF06B6D4), // cyan-500
                        ),
                    ];
                    
                    // Implementing explicit Grid rows logic
                    List<Widget> rows = [];
                    for (int i = 0; i < items.length; i += 3) {
                      rows.add(
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int j = 0; j < 3; j++) ...[
                              if (j > 0) ScreenUtilHelper.sizedBoxWidth(8),
                              if (i + j < items.length)
                                Expanded(child: items[i + j])
                              else
                                const Expanded(child: SizedBox()),
                            ],
                          ],
                        ),
                      );
                      if (i + 3 < items.length) {
                        rows.add(ScreenUtilHelper.sizedBoxHeight(8)); // gap-2 vertical (approx 8px)
                      }
                    }
                    
                    return Column(children: rows);
                  },
                ),
              ),
          ],
        ),
      ),
    );

    final decorated = widget.isImmune
        ? ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0, 0, 0, 1, 0,
            ]),
            child: card,
          )
        : card;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120), // transition-all usually implies swift defaults
        curve: Curves.easeOut,
        scale: _pressed ? 0.99 : 1.0, // active:scale-[0.99]
        child: Opacity(
          opacity: widget.isImmune ? 0.6 : 1.0, // opacity-60
          child: decorated,
        ),
      ),
    );
  }
}

class _ExplosiveIcon extends StatelessWidget {
  const _ExplosiveIcon({
    required this.type,
    required this.highlighted,
    required this.isImmune,
  });

  final ExplosiveType type;
  final bool highlighted;
  final bool isImmune;

  @override
  Widget build(BuildContext context) {
    // Styling:
    // w-14 h-14 (56px) rounded-xl border p-1
    // bg: isImmune ? bg-zinc-900 border-zinc-800 : (highlighted ? bg-yellow-900/10 border-yellow-500/30 : bg-zinc-900 border-zinc-700)
    
    final borderColor = isImmune
        ? const Color(0xFF27272A)
        : highlighted
            ? const Color(0x4DEAB308) // yellow-500/30
            : const Color(0xFF3F3F46); // zinc-700
            
    final bgColor = isImmune
        ? const Color(0xFF18181B)
        : highlighted
            ? const Color(0x1A713F12) // yellow-900/10 (yellow-900 is #713f12)
            : const Color(0xFF18181B); // zinc-900

    final assetPath = explosiveImages[type];

    return Container(
      width: 56.w,
      height: 56.w,
      padding: ScreenUtilHelper.paddingAll(4), // p-1 (4px)
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: assetPath == null
          ? const SizedBox.shrink()
          : Image.asset(assetPath, fit: BoxFit.contain), // CHANGED TO IMAGE.ASSET
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  const _BreakdownItem({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.textColor,
    this.dotColor,
  });

  final String value;
  final String label;
  final Color valueColor;
  final Color textColor;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    // Layout: flex items-center gap-2
    // Dot: w-1.5 h-1.5 rounded-full
    // Text: value (xs mono bold) + label (text-[10px] uppercase sans)
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dotColor != null) ...[
          Container(
            width: 6.w, // 1.5 rem? no, tailwind w-1.5 is 0.375rem = 6px
            height: 6.w,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          ScreenUtilHelper.sizedBoxWidth(8), // gap-2 (8px)
        ],
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: valueColor, // text-zinc-300 etc
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      fontSize: 12.sp, // text-xs
                    ),
                  ),
                  WidgetSpan(child: ScreenUtilHelper.sizedBoxWidth(4)), // Keeping this constant or using ScreenUtilHelper if it accepts widget span? Better just use .w here
                  TextSpan(
                    text: label.toUpperCase(),
                    style: TextStyle(
                      color: textColor, // text-zinc-600 uppercase etc
                      fontFamily: 'sans-serif', // font-sans
                      fontSize: 10.sp, // text-[10px]
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
