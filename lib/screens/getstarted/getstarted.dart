import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/common/rust_button.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';

import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/throttler.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

import 'package:raidalarm/data/database/app_database.dart';
import 'package:easy_localization/easy_localization.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({
    super.key,
  });

  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> {
  final Throttler _throttler = Throttler(delay: const Duration(milliseconds: 1000));

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RustColors.surface,
      body: RustScreenLayout(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image Container
            const _BackgroundImage(),

            // Content
            SafeArea(
              child: Padding(
                padding: ScreenUtilHelper.paddingSymmetric(
                  horizontal: 24.0, 
                  vertical: 32.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Section - Centered Vertically
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // H1 Title
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                style: RustTypography.rustStyle(
                                  fontSize: ScreenUtilHelper.isSmallDevice ? 38.sp : 48.sp,
                                  color: Colors.white,
                                ).copyWith(
                                  height: 1.1,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(0, 4.h),
                                      blurRadius: 4.r,
                                    ),
                                  ],
                                ),
                                children: _buildTitleSpans(tr('get_started.title')),
                              ),
                            ),
                          ),
                          
                          // Red Bar
                          Container(
                            margin: EdgeInsets.only(top: 24.h),
                            width: 64.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFDC2626).withOpacity(0.5),
                                  blurRadius: 15.r,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Actions
                    Column(
                      children: [
                        // INITIATE SETUP Button
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDC2626).withOpacity(0.5),
                                blurRadius: 20.r,
                                spreadRadius: -2.r,
                              ),
                            ],
                          ),
                          child: RustButton(
                            onPressed: () => _throttler.run(() async {
                              HapticHelper.mediumImpact();

                              
                              // Save progress to database
                              await AppDatabase().saveAppSetting('getstarted_completed', 'true');
                              
                              if (context.mounted) {
                                context.go('/how-it-works');
                              }
                            }),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(tr('get_started.button_text')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
      ),
    ));
  }

  List<TextSpan> _buildTitleSpans(String text) {
    final List<TextSpan> spans = [];
    final RegExp regExp = RegExp(r'<([^>]+)>|([^<]+)');
    final Iterable<RegExpMatch> matches = regExp.allMatches(text);

    for (final match in matches) {
      if (match.group(1) != null) {
        // Tagged text (e.g., <DETECT>)
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(color: Color(0xFFDC2626)),
        ));
      } else if (match.group(2) != null) {
        // Normal text
        spans.add(TextSpan(text: match.group(2)));
      }
    }
    return spans;
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image with filters
          Opacity(
            opacity: 0.6,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                // Grayscale matrix
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0,      0,      0,      1, 0,
              ]),
              child: Image.asset(
                'assets/getstarted.jpg',
                fit: BoxFit.cover,
                cacheWidth: 1080, // Optimization: Resize to sane width
              ),
            ),
          ),
          
          // Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.black26,
                  Colors.black45,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

