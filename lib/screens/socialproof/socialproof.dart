import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/widgets/common/rust_button.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialProofScreen extends ConsumerWidget {
  const SocialProofScreen({super.key});

  static const List<_ReviewItem> _reviews = [
    _ReviewItem(
      id: 1,
      name: 'Toxic_Chad_99',
      role: '@clan_leader',
      text: 'The fake call feature woke me up at 4 AM and saved our loot. Best app ever!',
      avatarColor: Color(0xFFDC2626),
      imagePath: 'assets/images/jpg/avatar4.jpg',
    ),
    _ReviewItem(
      id: 2,
      name: 'SoloSurvivor',
      role: '@lone_wolf',
      text: 'Finally I can sleep without anxiety as a solo player. Highly recommended.',
      avatarColor: Color(0xFF2563EB),
      imagePath: 'assets/images/jpg/avatar5.jpg',
    ),
    _ReviewItem(
      id: 3,
      name: 'RustAcademy_Fan',
      role: '@builder_main',
      text: 'The alarm override actually works even when phone is on silent. 10/10.',
      avatarColor: Color(0xFF16A34A),
      imagePath: 'assets/images/jpg/avatar6.jpg',
    ),
    _ReviewItem(
      id: 4,
      name: 'Zerg_Hunter',
      role: '@pvp_god',
      text: 'Worth the subscription just for the peace of mind during off-hours.',
      avatarColor: Color(0xFFEA580C),
      imagePath: 'assets/images/jpg/avatar7.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const RustScreenLayout(
      child: Scaffold(
        backgroundColor: RustColors.background,
        body: Stack(
          children: [
            // 1. Main Scrollable Content
            SafeArea(
              bottom: false,
              child: _MainScrollableContent(reviews: _reviews),
            ),

            // 3. Sticky Footer
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _StickyFooter(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainScrollableContent extends StatelessWidget {
  final List<_ReviewItem> reviews;

  const _MainScrollableContent({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: 120.h, // Space for sticky footer
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 32.h), // Spacing above Top Rated Defense
            // HERO SECTION
            const _HeroSection(),
            SizedBox(height: 24.h), // Spacing below Hero

            // REVIEWS LIST
            ...reviews.map((review) => _ReviewCard(review: review)),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Give us a rating',
            style: RustTypography.rustStyle(fontSize: 24.sp),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 12.h),

        // Stars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Icon(
                Icons.star,
                size: 28.w,
                color: const Color(0xFFEAB308), // yellow-500
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        Text(
          'This tool was designed for survivors like you who value their sleep and their loot.',
          style: RustTypography.bodyMedium.copyWith(
            color: const Color(0xFFA1A1AA), // zinc-400
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),

        // Avatar Stack + Count
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100.w,
              height: 40.w,
              child: const Stack(
                children: [
                  _HeroAvatar(index: 0, bgColor: Color(0xFF27272A), iconColor: Color(0xFF71717A), imagePath: 'assets/images/jpg/avatar1.jpg'),
                  _HeroAvatar(index: 1, bgColor: Color(0xFF3F3F46), iconColor: Color(0xFFA1A1AA), imagePath: 'assets/images/jpg/avatar2.jpg'),
                  _HeroAvatar(index: 2, bgColor: Color(0xFF52525B), iconColor: Color(0xFFD4D4D8), imagePath: 'assets/images/jpg/avatar3.jpg'),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '3,000+',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'ACTIVE RAIDERS',
                    style: TextStyle(
                      color: const Color(0xFF71717A),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0.w,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroAvatar extends StatelessWidget {
  final int index;
  final Color bgColor;
  final Color iconColor;
  final String imagePath;

  const _HeroAvatar({
    required this.index,
    required this.bgColor,
    required this.iconColor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: index * 28.w,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF0C0C0E), width: 2.w),
        ),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            width: 40.w,
            height: 40.w,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(LucideIcons.user, size: 20.w, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final _ReviewItem review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFF27272A)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: review.avatarColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 2.r, offset: Offset(0, 1.h))
                      ],
                    ),
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: Image.asset(
                        review.imagePath,
                        width: 40.w,
                        height: 40.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Text(
                          review.name[0],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          review.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          review.role,
                          style: TextStyle(
                            color: const Color(0xFF71717A),
                            fontSize: 10.sp,
                            fontFamily: RustTypography.monoFontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // 5 Stars Small
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 12.w,
                    color: const Color(0xFFEAB308),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '"${review.text}"',
            style: TextStyle(
              color: const Color(0xFFD4D4D8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyFooter extends StatelessWidget {
  const _StickyFooter();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              RustColors.background,
              RustColors.background,
              Colors.transparent,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RustButton.primary(
              onPressed: () async {
                HapticHelper.mediumImpact();
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  await inAppReview.requestReview();
                }

                await AppDatabase().saveAppSetting('social_proof_completed', 'true');
                if (context.mounted) {
                  context.go('/paywall');
                }
              },
              child: Text(
                'JOIN THE SQUAD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewItem {
  final int id;
  final String name;
  final String role;
  final String text;
  final Color avatarColor;
  final String imagePath;

  const _ReviewItem({
    required this.id,
    required this.name,
    required this.role,
    required this.text,
    required this.avatarColor,
    required this.imagePath,
  });
}
