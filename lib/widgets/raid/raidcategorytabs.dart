
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/data/raidData.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

class RaidCategoryTabs extends StatelessWidget {
  const RaidCategoryTabs({
    super.key,
    required this.activeCategory,
    required this.onSelect,
  });

  final RaidCategory activeCategory;
  final ValueChanged<RaidCategory> onSelect;

  @override
  Widget build(BuildContext context) {
    // Mapping:
    // construction -> Build (Hammer)
    // door -> Doors (DoorOpen)
    // placeable -> Items (Box)
    // item -> Traps (Bomb)
    
    final items = <_TabItemData>[
      _TabItemData(
        id: RaidCategory.construction,
        label: tr('raid.categories.construction'),
        icon: LucideIcons.hammer,
      ),
      _TabItemData(
        id: RaidCategory.door,
        label: tr('raid.categories.door'),
        icon: LucideIcons.doorOpen,
      ),
      _TabItemData(
        id: RaidCategory.placeable,
        label: tr('raid.categories.placeable'),
        icon: LucideIcons.box,
      ),
      _TabItemData(
        id: RaidCategory.item,
        label: tr('raid.categories.item'),
        icon: LucideIcons.bomb,
      ),
    ];

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(
              child: _TabButton(
                data: items[i],
                isActive: activeCategory == items[i].id,
                onTap: () => onSelect(items[i].id),
              ),
            ),
            if (i != items.length - 1) ScreenUtilHelper.sizedBoxWidth(8.0),
          ],
        ],
      ),
    );
  }
}

class _TabItemData {
  const _TabItemData({
    required this.id,
    required this.label,
    required this.icon,
  });

  final RaidCategory id;
  final String label;
  final IconData icon;
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  final _TabItemData data;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _HoverableTabButton(
      data: data,
      isActive: isActive,
      onTap: onTap,
    );
  }
}

class _HoverableTabButton extends StatelessWidget {
  const _HoverableTabButton({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  final _TabItemData data;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // RN: 
    // Active: bg-zinc-800 (#27272A) border-zinc-600 (#52525B) text-white shadow-lg
    // Inactive: bg-zinc-900/50 (#18181B with opacity) border-transparent text-zinc-500 (#71717A) hover:bg-zinc-900 

    final bgColor = isActive
        ? const Color(0xFF27272A)
        : const Color(0xFF18181B).withOpacity(0.5);
    
    final borderColor = isActive 
        ? const Color(0xFF52525B) 
        : Colors.transparent;
        
    final textColor = isActive 
        ? Colors.white 
        : const Color(0xFF71717A);
        
    final iconColor = isActive 
        ? const Color(0xFFF97316) // orange-500
        : const Color(0xFF52525B); // zinc-600 - Matches RN logic (inactive icon is text-zinc-600)

    return InkWell(
      onTap: () {
        HapticHelper.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12.r),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0x33000000), // shadow-lg approx
                    blurRadius: 16.r,
                    offset: Offset(0, 8.h),
                    spreadRadius: -4,
                  ),
                ]
              : const [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(data.icon, size: 16.w, color: iconColor),
            ScreenUtilHelper.sizedBoxHeight(6.0),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                data.label.toUpperCase(),
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2, // tracking-wider
                  fontSize: 10.sp, // text-[10px]
                  fontFamily: 'Geist',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
