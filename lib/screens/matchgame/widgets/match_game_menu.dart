import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/match_game_models.dart';

class MatchGameMenu extends ConsumerWidget {
  final MatchDifficulty selectedDifficulty;
  final Function(MatchDifficulty) onDifficultyChanged;
  final VoidCallback onStartGame;

  const MatchGameMenu({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    required this.onStartGame,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          const _MenuHeader(),
          SizedBox(height: 40.h),
          ...MatchDifficulty.values.map((diff) => _DifficultyCard(
                diff: diff,
                isSelected: selectedDifficulty == diff,
                onTap: () => onDifficultyChanged(diff),
              )),
          SizedBox(height: 32.h),
          _PlayButton(
            selectedDifficulty: selectedDifficulty,
            onPressed: onStartGame,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        SizedBox(height: 32.h),
        Center(
          child: Text(
            tr('tools.match_game.menu_title'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontFamily: 'Rust',
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.5), offset: const Offset(0, 4), blurRadius: 10),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          tr('tools.match_game.menu_subtitle'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF71717A),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final MatchDifficulty diff;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.diff,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = DIFFICULTIES[diff]!;
    final zinc800 = const Color(0xFF27272A);
    final zinc900Half = const Color(0xFF18181B).withOpacity(0.5);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          HapticHelper.selection();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected ? zinc800 : zinc900Half,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? Colors.white.withOpacity(0.2) : zinc800,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diff.name.toUpperCase(),
                    style: TextStyle(
                      color: cfg.color,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    tr('tools.match_game.pairs_count', args: [cfg.pairs.toString()]) + ' • ${cfg.time}s',
                    style: TextStyle(
                      color: const Color(0xFF71717A),
                      fontSize: 11.sp,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tr('tools.match_game.entry'),
                    style: TextStyle(
                      color: const Color(0xFF52525B),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        '${cfg.bet}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(LucideIcons.coins, color: const Color(0xFFEAB308), size: 14.w),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final MatchDifficulty selectedDifficulty;
  final VoidCallback onPressed;

  const _PlayButton({
    required this.selectedDifficulty,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bet = DIFFICULTIES[selectedDifficulty]!.bet;

    return Container(
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticHelper.lightImpact();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('tools.match_game.play_action', args: [bet.toString()]),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ),
        ),
      ),
    );
  }
}
