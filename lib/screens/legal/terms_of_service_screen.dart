import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TermsOfServiceScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;

  const TermsOfServiceScreen({
    super.key,
    this.onBack,
  });

  @override
  ConsumerState<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends ConsumerState<TermsOfServiceScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        HapticHelper.mediumImpact();
        _handleBack();
      },
      child: RustScreenLayout(
        child: Scaffold(
          backgroundColor: RustColors.background, // Opaque background to prevent overlap
          body: SafeArea(
            bottom: true,
            child: Column(
              children: [
                // Header
                Container(
                  height: 60.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: RustColors.surface, // bg-zinc-950
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.05),
                        width: 1.w,
                      ),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            HapticHelper.mediumImpact();
                            _handleBack();
                          },
                          icon: Icon(Icons.arrow_back,
                              color: const Color(0xFFA1A1AA), size: 24.w),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),

                      // Title
                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48.w),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'legal.terms_of_service.title'.tr(),
                            style: RustTypography.rustStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: ListView.separated(
                    padding: ScreenUtilHelper.paddingAll(24),
                    itemCount: 18, // 1 header + 16 sections (1-16) + 1 bottom padding
                    separatorBuilder: (context, index) =>
                        ScreenUtilHelper.sizedBoxHeight(24),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Text(
                          'legal.terms_of_service.last_updated'.tr(namedArgs: {
                            'year': DateTime.now().year.toString()
                          }),
                          style: RustTypography.monoStyle(
                            fontSize: 13.sp,
                            color: RustColors.textSecondary,
                            weight: FontWeight.w400,
                          ),
                        );
                      }

                      if (index == 17) {
                        // Contact section at the bottom (header 0 + 16 sections = 16, so 17 is contact)
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                                'legal.terms_of_service.contact_title'.tr()),
                            ScreenUtilHelper.sizedBoxHeight(8),
                            _buildSectionContent(
                                'legal.terms_of_service.contact_email'.tr()),
                            ScreenUtilHelper.sizedBoxHeight(24),
                          ],
                        );
                      }

                      // Sections 1 to 15
                      final sectionNum = index;
                      return _buildSection(
                        'legal.terms_of_service.section${sectionNum}_title'.tr(),
                        'legal.terms_of_service.section${sectionNum}_content'.tr(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        ScreenUtilHelper.sizedBoxHeight(8), // mb-2 = 8px
        _buildSectionContent(content),
      ],
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
            title.toUpperCase(), // uppercase class in React Native
            style: RustTypography.monoStyle( // Using monoStyle but bold per React Native
               fontSize: 13.sp, // text-sm
               color: RustColors.textPrimary, // text-white
               weight: FontWeight.bold,
            ), 
          );
  }

  Widget _buildSectionContent(String content) {
    return Text(
        content,
        style: RustTypography.monoStyle(
          fontSize: 13.sp, // text-sm
          color: RustColors.textSecondary, // text-zinc-300
          weight: FontWeight.w400,
        ).copyWith(
          height: 1.625, // leading-relaxed
        ),
      );
  }
}
