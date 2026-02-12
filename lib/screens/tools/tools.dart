import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/widgets/tools/tools_grid_card.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';

/// Tools Screen - Araçlar sekmesi
/// React Native: ToolsTab.tsx
class ToolsScreen extends ConsumerStatefulWidget {
  const ToolsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends ConsumerState<ToolsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: RustScreenLayout(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 16.w,
                          top: 24.h,
                          bottom: 12.h,
                        ),
                        child: Text(
                          tr('tools.section_utilities'),
                          style: RustTypography.monoStyle(
                            fontSize: 12.sp,
                            weight: FontWeight.w700,
                            color: const Color(0xFF71717A),
                            letterSpacing: 2.4.w,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 24.h),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 1.4,
                        children: [
                          ToolsGridCard(
                            title: tr('tools.raid_cost.title'),
                            subtitle: tr('tools.raid_cost.subtitle'),
                            imageUrl: 'assets/images/png/raidcalculator.png',
                            onClick: () {
                              context.push('/raid-calculator');
                            },
                          ),
                          ToolsGridCard(
                            title: tr('recoil_trainer.title'),
                            subtitle: tr('recoil_trainer.subtitle'),
                            imageUrl: 'assets/images/png/recoiltrainer.png',
                            onClick: () {
                              context.push('/recoil-trainer');
                            },
                          ),
                          ToolsGridCard(
                            title: tr('tools.cctv_codes.title'),
                            subtitle: tr('tools.cctv_codes.subtitle'),
                            imageUrl: 'assets/images/png/cctvcodes.png',
                            onClick: () {
                              context.push('/cctv-codes');
                            },
                          ),
                          ToolsGridCard(
                            title: tr('tools.tea_guide.title'),
                            subtitle: tr('tools.tea_guide.subtitle'),
                            imageUrl: 'assets/images/png/tearecipes.png',
                            onClick: () {
                              context.push('/tea-calculator');
                            },
                          ),
                          ToolsGridCard(
                            title: tr('tools.diesel_calc.title'),
                            subtitle: tr('tools.diesel_calc.subtitle'),
                            imageUrl: 'assets/images/png/dieselcalculator.png',
                            onClick: () {
                              context.push('/diesel-calculator');
                            },
                          ),
                          ToolsGridCard(
                            title: tr('tools.match_game.title'),
                            subtitle: tr('tools.match_game.subtitle'),
                            imageUrl: 'assets/images/png/minigame.png',
                            onClick: () {
                              context.push('/match-game');
                            },
                          ),
                          ToolsGridCard(
                            title: tr('tools.code_raider.title'),
                            subtitle: tr('tools.code_raider.subtitle'),
                            imageUrl: 'assets/images/png/codelock.png',
                            onClick: () {
                              context.push('/code-raider');
                            },
                          ),
                          ToolsGridCard(
                            title: tr('tools.blackjack.title'),
                            subtitle: tr('tools.blackjack.subtitle'),
                            imageUrl: 'assets/images/png/blackjack.png',
                            onClick: () {
                              context.push('/blackjack');
                            },
                          ),
                          

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w), // Match Dashboard padding (16)
      decoration: BoxDecoration(
        color: const Color(0xFF09090B), // Match Dashboard color
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1.h,
          ),
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/logo/raidalarm-logo2.png',
          height: 80.w,
          fit: BoxFit.contain,
          cacheWidth: 160,
        ),
      ),
    );
  }
}
