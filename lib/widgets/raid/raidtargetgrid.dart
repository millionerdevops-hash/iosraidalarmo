
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/data/raidData.dart';

class RaidTargetGrid extends StatelessWidget {
  const RaidTargetGrid({
    super.key,
    required this.targets,
    required this.selectedId,
    required this.onSelect,
  });

  final List<RaidTarget> targets;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h), // px-4 pb-6
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // grid-cols-4
          crossAxisSpacing: 8.w, // gap-2
          mainAxisSpacing: 8.h,
          childAspectRatio: 1, // aspect-square
        ),
        itemCount: targets.length,
        itemBuilder: (context, index) {
          final t = targets[index];
          final isSelected = selectedId == t.id;

          return _TargetTile(
            target: t,
            isSelected: isSelected,
            onTap: () => onSelect(t.id),
          );
        },
      ),
    );
  }
}

class _TargetTile extends StatelessWidget {
  const _TargetTile({
    required this.target,
    required this.isSelected,
    required this.onTap,
  });

  final RaidTarget target;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // RN Design:
    // button className={`aspect-square rounded-xl relative overflow-hidden transition-all duration-200 border-2 group
    //   ${selectedId === t.id 
    //     ? `bg-[#27272a] border-orange-500` 
    //     : `bg-[#18181b] border-zinc-800/60 hover:border-zinc-600`
    //   }
    // `}
    
    final bgColor = isSelected
        ? const Color(0xFF27272A)
        : const Color(0xFF18181B);
        
    final borderColor = isSelected
        ? const Color(0xFFF97316) // orange-500
        : const Color(0x9927272A); // border-zinc-800/60

    // RN Image:
    // transition-transform duration-300 ${selectedId === t.id ? 'scale-110' : 'group-hover:scale-105'}`
    
    final scale = isSelected ? 1.10 : 1.00; 

    return GestureDetector(
      onTap: () {
        HapticHelper.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: borderColor,
            width: 2.w,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(16.w), // p-4
                  child: Center( // flex items-center justify-center
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      scale: scale,
                      child: Image.asset( // CHANGED TO IMAGE.ASSET
                          target.img,
                          fit: BoxFit.contain,
                          // Performance optimization: Cache images
                          cacheWidth: (100.w * ScreenUtil().pixelRatio!).toInt(),
                        ),
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
