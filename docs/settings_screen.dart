
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/settings/alarm_mode_widget.dart';
import 'package:raidalarm/widgets/settings/fake_call_widget.dart';
import 'package:raidalarm/widgets/settings/subscription_widget.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/services/adapty_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'parts/settings_widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  @override
  void initState() {
    super.initState();
  }

  void _handlePaywall() {
    if (!mounted) return;
    context.push('/paywall');
  }

  void _handleBack() {
    if (!mounted) return;
    final hasLifetime = ref.read(notificationProvider).hasLifetime;
    if (mounted) context.pop();
  }

  Future<void> _handleRestore() async {
    HapticHelper.mediumImpact();
    
    // Show processing snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr('common.processing')),
        duration: const Duration(seconds: 1),
      ),
    );

    try {
      await ref.read(adaptyServiceProvider).restorePurchases();
      final hasPremium = await ref.read(adaptyServiceProvider).hasPremiumAccess();
      
      await ref.read(notificationProvider.notifier).updateLifetimeStatus(hasPremium);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('subscription.restore_success')),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('subscription.restore_failed')),
            backgroundColor: RustColors.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    final adaptyService = ref.watch(adaptyServiceProvider);
    final profile = adaptyService.cachedProfile;

    return Scaffold(
      backgroundColor: RustColors.background,
      body: RustScreenLayout(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            if (didPop) return;
            _handleBack();
          },
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header
                    Container(
                      height: 64.h, // h-16
                      padding: EdgeInsets.symmetric(horizontal: 16.w), // px-4
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.05), // border-white/5
                            width: 1.h,
                          ),
                        ),
                        color: RustColors.background,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _SettingsBackButton(onTap: _handleBack),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              tr('settings.ui.title'),
                              style: RustTypography.titleLarge.copyWith(
                                color: RustColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            16.h,
                            16.w,
                            24.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Subscription Widget
                               SubscriptionWidget(
                                profile: profile,
                                onPaywall: _handlePaywall,
                                onRestore: _handleRestore,
                              ),
                              ScreenUtilHelper.sizedBoxHeight(20.0), // mb-3

                              /* Moved Guides & Setup here */
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.w), // pl-2
                                    child: FittedBox(
                                      child: Text(
                                        tr('settings.ui.guides_setup'),
                                        style: RustTypography.monoStyle(
                                          fontSize: 12.sp, // text-xs
                                          weight: FontWeight.w700,
                                          color: const Color(0xFF71717A), // zinc-500
                                          letterSpacing: 2.w, // tracking-widest
                                        ),
                                      ),
                                    ),
                                  ),
                                  ScreenUtilHelper.sizedBoxHeight(12.0), // mb-3

                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF121214),
                                      border: Border.all(
                                        color: RustColors.divider,
                                        width: 1.w,
                                      ),
                                      borderRadius: BorderRadius.circular(16.r), // rounded-2xl
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      children: [
                                        // How It Works
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              HapticHelper.mediumImpact();
                                              // Analytics call removed
                                              context.push(Uri(path: '/how-it-works', queryParameters: {'fromSettings': 'true'}).toString());
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(20.w),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.white.withOpacity(0.05),
                                                    width: 1.h,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        LucideIcons.bookOpen,
                                                        size: 20.w,
                                                        color: const Color(0xFF3B82F6), // blue-500
                                                      ),
                                                      ScreenUtilHelper.sizedBoxWidth(16.0),
                                                      FittedBox(
                                                        child: Text(
                                                          tr('settings.ui.how_it_works'),
                                                          style: RustTypography.bodyMedium.copyWith(
                                                            color: RustColors.textPrimary,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    LucideIcons.chevronRight,
                                                    size: 16.w,
                                                    color: const Color(0xFF52525B),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Bug Report
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              HapticHelper.mediumImpact();
                                              context.push('/bug-report');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(20.w),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        LucideIcons.bug,
                                                        size: 20.w,
                                                        color: const Color(0xFFEF4444), // red-500
                                                      ),
                                                      ScreenUtilHelper.sizedBoxWidth(16.0),
                                                      FittedBox(
                                                        child: Text(
                                                          tr('settings.ui.bug_report'),
                                                          style: RustTypography.bodyMedium.copyWith(
                                                            color: RustColors.textPrimary,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    LucideIcons.chevronRight,
                                                    size: 16.w,
                                                    color: const Color(0xFF52525B),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ScreenUtilHelper.sizedBoxHeight(20.0),
                              /* End Moved Guides & Setup */

                              // Alarm Mode Widget
                              const AlarmModeWidget(),
                              ScreenUtilHelper.sizedBoxHeight(20.0), // space-y-6

                              // Fake Call Widget
                              const FakeCallWidget(),
                              ScreenUtilHelper.sizedBoxHeight(20.0), // space-y-6



                              // Legal Section
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.w), // pl-2
                                    child: FittedBox(
                                      child: Text(
                                        tr('settings.ui.legal'),
                                        style: RustTypography.monoStyle(
                                          fontSize: 12.sp, // text-xs
                                          weight: FontWeight.w700,
                                          color: const Color(0xFF71717A), // zinc-500
                                          letterSpacing: 2.w, // tracking-widest
                                        ),
                                      ),
                                    ),
                                  ),
                                  ScreenUtilHelper.sizedBoxHeight(12.0), // mb-3

                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF121214),
                                      border: Border.all(
                                        color: RustColors.divider,
                                        width: 1.w,
                                      ),
                                      borderRadius: BorderRadius.circular(16.r), // rounded-2xl
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      children: [
                                        // Terms of Service
                                        _LegalLinkItem(
                                          icon: LucideIcons.fileText,
                                          text: tr('settings.ui.tos'),
                                          path: '/terms-of-service',
                                          isLast: false,
                                        ),

                                        // Privacy Policy
                                        _LegalLinkItem(
                                          icon: LucideIcons.shield,
                                          text: tr('settings.ui.privacy'),
                                          path: '/privacy-policy',
                                          isLast: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Footer
                                ScreenUtilHelper.sizedBoxHeight(24.0),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 0.h), // pb-4
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        tr('settings.ui.version', args: ['2.1.0']),
                                        style: RustTypography.monoStyle(
                                          fontSize: 10.sp, // text-[10px]
                                          color: const Color(0xFF3F3F46), // text-zinc-700
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // BannerAdWidget removed
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension _IterableFirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? firstOrNullWhere(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
