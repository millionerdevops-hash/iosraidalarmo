import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';

/// SubscriptionWidget - Abonelik ve takım yönetimi
/// React Native: SubscriptionWidget.tsx
class SubscriptionWidget extends StatelessWidget {
  final String plan;
  final VoidCallback onPaywall;

  const SubscriptionWidget({
    Key? key,
    required this.plan,
    required this.onPaywall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFree = plan == 'FREE';
    final isPro = plan == 'LIFETIME';

    return Container(
      decoration: BoxDecoration(
        color: RustColors.surface, // bg-[#121214]
        border: Border.all(
          color: RustColors.divider, // border-zinc-800
          width: 1.0.w,
        ),
        borderRadius: BorderRadius.circular(16.0.r), // rounded-2xl
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0.w), // p-5
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PART 1: Subscription Info
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 48.0.w, // w-12
                      height: 48.0.w, // h-12
                      decoration: BoxDecoration(
                        color: isFree ? RustColors.divider : null,
                        gradient: isFree
                            ? null
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFDC2626), // red-600
                                  Color(0xFF7F1D1D), // red-900
                                ],
                              ),
                        borderRadius: BorderRadius.circular(24.0.r), // rounded-full
                        border: Border.all(
                          color: isFree
                              ? const Color(0xFF3F3F46) // border-zinc-700
                              : const Color(0xFFEF4444), // border-red-500
                          width: 1.0.w,
                        ),
                        boxShadow: !isFree
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFDC2626)
                                      .withOpacity(0.3),
                                  blurRadius: 15.0.r,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        LucideIcons.creditCard,
                        size: 24.0.w, // w-6 h-6
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16.0.w), // gap-4
                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              (plan.isNotEmpty ? plan : tr('subscription.free_tier')).toUpperCase(),
                              style: RustTypography.rustStyle(
                                fontSize: 16.0.sp,
                                weight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.0.h), // mt-1
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              isFree ? tr('subscription.limited_features') : tr('subscription.lifetime_license'),
                              style: RustTypography.bodySmall.copyWith(
                                color: const Color(0xFF71717A), // zinc-500
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0.h), // mt-1

                // Stats Row
                Row(
                  children: [
                    // Team Slots (Duration)
                    Container(
                      padding: EdgeInsets.all(12.0.w), // p-3
                      decoration: BoxDecoration(
                        color: RustColors.cardBackground.withOpacity(0.5), // bg-zinc-900/50
                        border: Border.all(
                          color: RustColors.divider, // border-zinc-800
                          width: 1.0.w,
                        ),
                        borderRadius: BorderRadius.circular(12.0.r), // rounded-xl
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                LucideIcons.infinity,
                                size: 12.0.w, // w-3 h-3
                                color: RustColors.textMuted,
                              ),
                              SizedBox(width: 8.0.w), // gap-2
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  tr('subscription.duration'),
                                  style: RustTypography.labelSmall.copyWith(
                                    color: RustColors.textMuted,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0.h), // mb-1
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              isFree ? tr('subscription.forever_free') : tr('subscription.lifetime'),
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'RobotoMono',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.0.w), // gap-3

                    // Status
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.0.w), // p-3
                        decoration: BoxDecoration(
                          color: RustColors.cardBackground.withOpacity(0.5), // bg-zinc-900/50
                          border: Border.all(
                            color: RustColors.divider, // border-zinc-800
                            width: 1.0.w,
                          ),
                          borderRadius: BorderRadius.circular(12.0.r), // rounded-xl
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.shield,
                                  size: 12.0.w, // w-3 h-3
                                  color: RustColors.textMuted,
                                ),
                                SizedBox(width: 8.0.w), // gap-2
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    tr('subscription.status'),
                                    style: RustTypography.labelSmall.copyWith(
                                      color: RustColors.textMuted,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.0.h), // mb-1
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                isFree ? tr('subscription.locked') : tr('subscription.active'),
                                style: TextStyle(
                                  fontSize: 16.0.sp, // text-lg
                                  fontWeight: FontWeight.w700,
                                  color: isFree
                                      ? const Color(0xFF71717A)
                                      : const Color(0xFF22C55E), // text-green-500
                                  fontFamily: 'RobotoMono',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0.h), // mt-2

                // Upgrade Button
                if (isFree)
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                     child: _UpgradeToUnlockButton(onTap: onPaywall),
                  ),

              ],
            ),
          ),


        ],
      ),
    );
  }
}

class _UpgradeToUnlockButton extends StatefulWidget {
  final VoidCallback onTap;

  const _UpgradeToUnlockButton({required this.onTap});

  @override
  State<_UpgradeToUnlockButton> createState() => _UpgradeToUnlockButtonState();
}

class _UpgradeToUnlockButtonState extends State<_UpgradeToUnlockButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticHelper.mediumImpact();
        widget.onTap();
      },
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 80),
        scale: _pressed ? 0.98 : 1.0,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.0.h), // py-3
          decoration: BoxDecoration(
            color: const Color(0xFF7F1D1D)
                .withOpacity(0.2), // red-900/20
            border: Border.all(
              color: const Color(0xFFEF4444)
                  .withOpacity(0.3), // red-500/30
              width: 1.0.w,
            ),
            borderRadius: BorderRadius.circular(8.0.r), // rounded-lg
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('subscription.upgrade_button'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0.sp, // text-xs
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEF4444), // red-500
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


