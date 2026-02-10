import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/match_game_models.dart';

class MatchCardWidget extends ConsumerWidget {
  final MatchCard card;
  final VoidCallback onTap;

  const MatchCardWidget({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRevealed = card.isFlipped || card.isMatched;

    return GestureDetector(
      onTap: onTap,
      child: RepaintBoundary(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: isRevealed ? pi : 0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          builder: (context, angle, child) {
            final isBack = angle < pi / 2;
            
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002) // Perspective
                ..rotateY(angle),
              alignment: Alignment.center,
              child: isBack
                ? _buildCardSide(isFront: false)
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildCardSide(isFront: true),
                  ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardSide({required bool isFront}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: card.isMatched 
            ? const Color(0xFF22C55E) 
            : isFront 
              ? _getRarityColor(card.item.rarity) 
              : const Color(0xFF3F3F46),
          width: 2.w,
        ),
        boxShadow: card.isMatched ? [BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.3), blurRadius: 10)] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            if (!isFront) _buildCardBack() else _buildCardFront(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      color: const Color(0xFF27272A),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: const StripePainter(),
            ),
          ),
          _CornerBolts(),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Icon(LucideIcons.box, color: const Color(0xFF71717A), size: 30.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getRarityColor(card.item.rarity).withOpacity(0.4),
            Colors.black,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    _getRarityColor(card.item.rarity).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Image.asset(
                card.item.imageUrl, 
                fit: BoxFit.contain,
                cacheWidth: 120.w.toInt(),
                cacheHeight: 120.w.toInt(),
                errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.imageOff, color: Colors.white24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'yellow': return const Color(0xFFEAB308);
      case 'blue': return const Color(0xFF3B82F6);
      case 'red': return const Color(0xFFEF4444);
      default: return const Color(0xFF71717A);
    }
  }
}

class _CornerBolts extends StatelessWidget {
  const _CornerBolts();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 4.h, left: 4.w, child: const _Bolt()),
        Positioned(top: 4.h, right: 4.w, child: const _Bolt()),
        Positioned(bottom: 4.h, left: 4.w, child: const _Bolt()),
        Positioned(bottom: 4.h, right: 4.w, child: const _Bolt()),
      ],
    );
  }
}

class _Bolt extends StatelessWidget {
  const _Bolt();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.w, 
      height: 2.w, 
      decoration: const BoxDecoration(
        color: Color(0xFF3F3F46), 
        shape: BoxShape.circle,
      ),
    );
  }
}

class StripePainter extends CustomPainter {
  const StripePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 2.0;

    const double gap = 8.0;
    for (double i = -size.height; i < size.width; i += gap) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StripePainter oldDelegate) => false;
}
