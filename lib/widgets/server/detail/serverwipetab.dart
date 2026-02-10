import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/widgets/settings/settings_shared.dart';

class ServerWipeTab extends StatelessWidget {
  final String? nextWipe;
  final bool wipeAlertEnabled;
  final Function(bool) onToggleWipeAlert;
  final String Function(String?) formatCountdown;

  const ServerWipeTab({
    super.key,
    required this.nextWipe,
    required this.wipeAlertEnabled,
    required this.onToggleWipeAlert,
    required this.formatCountdown,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Countdown Card
            _CountdownCard(
              nextWipe: nextWipe,
              formatCountdown: formatCountdown,
            ),
            ScreenUtilHelper.sizedBoxHeight(24.0),

            // Wipe Alert Card
            Consumer(
              builder: (context, ref, _) {
                 final isPremium = ref.watch(notificationProvider).hasLifetime;
                 
                  return _WipeAlertCard(
                    nextWipe: nextWipe,
                    wipeAlertEnabled: wipeAlertEnabled,
                    onToggleWipeAlert: onToggleWipeAlert,
                    isPremium: isPremium, // For logic
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted countdown card to prevent rebuilds
class _CountdownCard extends StatelessWidget {
  final String? nextWipe;
  final String Function(String?) formatCountdown;

  const _CountdownCard({
    required this.nextWipe,
    required this.formatCountdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Column(
        children: [
          // Header
          const _CountdownHeader(),
          ScreenUtilHelper.sizedBoxHeight(8.0),
          
          // Countdown Text
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formatCountdown(nextWipe),
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'RobotoMono',
                letterSpacing: -1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted countdown header (const optimization)
class _CountdownHeader extends StatelessWidget {
  const _CountdownHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          LucideIcons.timer,
          size: 12.w,
          color: const Color(0xFF71717A),
        ),
        ScreenUtilHelper.sizedBoxWidth(8.0),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            tr('server.wipe.next_wipe_in'),
            style: TextStyle(
              color: const Color(0xFF71717A),
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
              fontFamily: 'Geist',
            ),
          ),
        ),
      ],
    );
  }
}

// Extracted wipe alert card to prevent rebuilds
class _WipeAlertCard extends StatelessWidget {
  final String? nextWipe;
  final bool wipeAlertEnabled;
  final Function(bool) onToggleWipeAlert;

  final bool isPremium;
 
  const _WipeAlertCard({
    required this.nextWipe,
    required this.wipeAlertEnabled,
    required this.onToggleWipeAlert,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: wipeAlertEnabled
              ? const Color(0xFFF97316)
              : const Color(0xFF27272A),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // Icon
            _AlertIcon(enabled: wipeAlertEnabled, isPremium: isPremium),
            ScreenUtilHelper.sizedBoxWidth(12.0),
 
            // Text Info
            Expanded(
              child: _AlertInfo(enabled: wipeAlertEnabled, isPremium: isPremium),
            ),
 
            // Toggle Switch
            _AlertToggle(
              nextWipe: nextWipe,
              enabled: wipeAlertEnabled,
              onToggle: onToggleWipeAlert,
              isPremium: isPremium,
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted alert icon to prevent rebuilds
class _AlertIcon extends StatelessWidget {
  final bool enabled;
  final bool isPremium;
 
  const _AlertIcon({required this.enabled, this.isPremium = false});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: !isPremium 
            ? const Color(0xFF27272A)
            : (enabled ? const Color(0xFFF97316) : const Color(0xFF27272A)),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Icon(
        !isPremium ? LucideIcons.lock : LucideIcons.bell,
        size: 20.w,
        color: (enabled && isPremium) ? Colors.black : const Color(0xFF71717A),
      ),
    );
  }
}

// Extracted alert info to prevent rebuilds
class _AlertInfo extends StatelessWidget {
  final bool enabled;
  final bool isPremium;
 
  const _AlertInfo({required this.enabled, this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            tr('server.wipe.wipe_alarm'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Geist',
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            enabled ? tr('server.overview.active') : tr('server.overview.disabled'),
            style: TextStyle(
              color: const Color(0xFF71717A),
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Geist',
            ),
          ),
        ),
      ],
    );
  }
}

// Extracted toggle switch to prevent rebuilds
class _AlertToggle extends StatelessWidget {
  final String? nextWipe;
  final bool enabled;
  final Function(bool) onToggle;
  final bool isPremium;
 
  const _AlertToggle({
    required this.nextWipe,
    required this.enabled,
    required this.onToggle,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    // If locked logic was here, it's now handled by tap behavior + premium check
    
    return GestureDetector(
      onTap: nextWipe != null ? () {
        HapticHelper.mediumImpact();
        if (!isPremium) {
          context.pushNamed('paywall');
          return;
        }
        onToggle(!enabled);
      } : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 48.w,
        height: 28.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFFF97316)
              : const Color(0xFF3F3F46),
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: enabled
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
