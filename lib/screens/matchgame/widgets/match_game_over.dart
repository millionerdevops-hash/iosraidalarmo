import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/match_game_models.dart';

class MatchGameOver extends ConsumerWidget {
  final bool isWin;
  final MatchDifficulty difficulty;
  final VoidCallback onPlayAgain;
  final VoidCallback onReturnToMenu;

  const MatchGameOver({
    super.key,
    required this.isWin,
    required this.difficulty,
    required this.onPlayAgain,
    required this.onReturnToMenu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GameOverIcon(isWin: isWin),
              SizedBox(height: 24.h),
              _GameOverTitle(isWin: isWin),
              SizedBox(height: 24.h),
              _NetResultBox(isWin: isWin, reward: isWin ? DIFFICULTIES[difficulty]!.win : DIFFICULTIES[difficulty]!.bet),
              SizedBox(height: 32.h),
              _ActionButtons(onPlayAgain: onPlayAgain, onReturnToMenu: onReturnToMenu),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameOverIcon extends StatelessWidget {
  final bool isWin;
  const _GameOverIcon({required this.isWin});

  @override
  Widget build(BuildContext context) {
    final color = isWin ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
          ),
        ),
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            color: (isWin ? const Color(0xFF064E3B) : const Color(0xFF450A0A)).withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.w),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
            ],
          ),
          child: Icon(
            isWin ? LucideIcons.trophy : LucideIcons.skull,
            color: color,
            size: 35.w,
          ),
        ),
      ],
    );
  }
}

class _GameOverTitle extends StatelessWidget {
  final bool isWin;
  const _GameOverTitle({required this.isWin});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        isWin ? tr('tools.match_game.victory') : tr('tools.match_game.defeat'),
        style: TextStyle(
          color: isWin ? Colors.white : const Color(0xFFEF4444),
          fontSize: 40.sp,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          letterSpacing: -1,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.8), offset: const Offset(0, 4), blurRadius: 10),
          ],
        ),
      ),
    );
  }
}

class _NetResultBox extends StatelessWidget {
  final bool isWin;
  final int reward;
  const _NetResultBox({required this.isWin, required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF27272A)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('tools.match_game.net_result'),
              style: TextStyle(
                color: const Color(0xFF71717A),
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${isWin ? '+' : '-'}$reward',
                style: TextStyle(
                  color: isWin ? const Color(0xFF4ADE80) : const Color(0xFFEF4444),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                LucideIcons.coins,
                color: isWin ? const Color(0xFFEAB308) : const Color(0xFFEF4444),
                size: 24.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onPlayAgain;
  final VoidCallback onReturnToMenu;
  const _ActionButtons({required this.onPlayAgain, required this.onReturnToMenu});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54.h,
          child: ElevatedButton(
            onPressed: onPlayAgain,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      tr('tools.match_game.play_again'),
                      style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 54.h,
          child: OutlinedButton(
            onPressed: onReturnToMenu,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF27272A)),
              foregroundColor: const Color(0xFFA1A1AA),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('tools.match_game.return_to_menu'),
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
