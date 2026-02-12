import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/screens/blackjack/models/blackjack_models.dart';

class BlackjackCard extends StatelessWidget {
  final CardModel card;
  final int index;
  final int totalCards;
  final bool isDealer;

  const BlackjackCard({
    required this.card, required this.index, required this.totalCards, super.key,
    this.isDealer = false,
  });

  double _calculateXOffset() {
    if (totalCards <= 1) return 0;
    
    // Base card width is 85.w
    // overlap is the negative space between cards
    double overlap = -45.w;
    if (totalCards > 4) {
      // Squeeze logic
      final double availableWidth = 240.w; // Space to spread across
      overlap = (availableWidth / (totalCards - 1)) - 85.w;
      overlap = overlap.clamp(-70.w, -45.w);
    }
    
    final double step = 85.w + overlap;
    final double startX = -(totalCards - 1) * step / 2;
    return startX + index * step;
  }

  @override
  Widget build(BuildContext context) {
    final double xOffset = _calculateXOffset();
    final double rotation = (index - (totalCards - 1) / 2) * 2;
    final double translateY = (index - (totalCards - 1) / 2).abs() * 2;

    return Transform.translate(
      offset: Offset(xOffset, translateY.h),
      child: Transform.rotate(
        angle: rotation * 3.14159 / 180,
        child: Container(
          width: 85.w,
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: card.isHidden ? _buildBack() : _buildFront(),
        ),
      ),
    );
  }

  Widget _buildFront() {
    final bool isRed = card.suit.isRed;
    final IconData icon = _getSuitIcon(card.suit);
    final Color color = isRed ? const Color(0xFFDC2626) : Colors.black;

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Stack(
        children: [
          // Top Left
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    card.rank.label,
                    style: TextStyle(
                      color: color,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
                Icon(icon, color: color, size: 12.w),
              ],
            ),
          ),
          // Center Icon
          Align(
            child: Opacity(
              opacity: 0.1,
              child: Icon(icon, color: color, size: 40.w),
            ),
          ),
          // Bottom Right
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              angle: 3.14159,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      card.rank.label,
                      style: TextStyle(
                        color: color,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                  Icon(icon, color: color, size: 12.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF450A0A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF7F1D1D), width: 4.w),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.2,
          child: Icon(
            LucideIcons.spade,
            color: Colors.white,
            size: 48.w,
          ),
        ),
      ),
    );
  }

  IconData _getSuitIcon(Suit suit) {
    switch (suit) {
      case Suit.hearts:
        return LucideIcons.heart;
      case Suit.diamonds:
        return LucideIcons.diamond;
      case Suit.clubs:
        return LucideIcons.club;
      case Suit.spades:
        return LucideIcons.spade;
    }
  }
}
