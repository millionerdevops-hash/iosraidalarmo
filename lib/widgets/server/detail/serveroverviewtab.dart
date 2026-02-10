import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/widgets/settings/settings_shared.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

class ServerOverviewTab extends StatelessWidget {
  final ServerData server;
  final VoidCallback onChangeServer;
  final bool wipeAlertEnabled;
  final Function(bool) onToggleWipeAlert;
  final int wipeAlertMinutes;
  final Function(int)? onSetWipeAlertMinutes;

  const ServerOverviewTab({
    super.key,
    required this.server,
    required this.onChangeServer,
    required this.wipeAlertEnabled,
    required this.onToggleWipeAlert,
    required this.wipeAlertMinutes,
    this.onSetWipeAlertMinutes,
  });

  String _formatCountdown(String? isoDate) {
    if (isoDate == null) return tr('server.overview.unknown');
    try {
      final target = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = target.difference(now);
      
      if (diff.isNegative) return tr('server.overview.overdue');
      
      final days = diff.inDays;
      final hours = diff.inHours % 24;
      final mins = diff.inMinutes % 60;
      
      return days > 0 ? '${days}d ${hours}h' : '${hours}h ${mins}m';
    } catch (e) {
      return tr('server.overview.unknown');
    }
  }

  String _formatTimeAgo(String? isoDate) {
    if (isoDate == null) return tr('server.overview.unknown');
    try {
      final wipe = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(wipe);
      
      final diffHours = diff.inHours;
      final diffDays = diff.inDays;
      
      if (diffDays > 0) return tr('server.overview.time_ago_days', args: ['$diffDays', '${diffHours % 24}']);
      return tr('server.overview.time_ago_hours', args: ['$diffHours']);
    } catch (e) {
      return tr('server.overview.unknown');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fillPercent = ((server.players / server.maxPlayers) * 100).clamp(0, 100);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
          child: Column(
            children: [
              // Stats Grid
              // Stats Row (Pop, FPS, Uptime)
              Row(
                children: [
                  // Pop Card
                  Expanded(
                    child: _PopulationCard(
                      players: server.players,
                      maxPlayers: server.maxPlayers,
                    ),
                  ),
                  ScreenUtilHelper.sizedBoxWidth(12.0),

                  // FPS Card
                  Expanded(
                    child: _StatCard(
                      label: tr('server.overview.fps'),
                      value: server.fps?.toString() ?? tr('server.overview.na'),
                    ),
                  ),
                  ScreenUtilHelper.sizedBoxWidth(12.0),

                  // Uptime Card
                  Expanded(
                    child: _StatCard(
                      label: tr('server.overview.uptime'),
                      value: server.uptime != null ? '${(server.uptime! / 3600).floor()}h' : tr('server.overview.na'),
                    ),
                  ),
                ],
              ),
              
              ScreenUtilHelper.sizedBoxHeight(12.0),

                  // Map Card (Full Width)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0x8018181B),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFF27272A)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          server.map ?? tr('server.map.procedural'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'RobotoMono',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ScreenUtilHelper.sizedBoxHeight(6.0),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${tr('server.overview.size_label')} ${server.mapSize ?? '?'} • ${tr('server.overview.seed_label')} ${server.seed ?? '?'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFA1A1AA),
                              fontSize: 12.sp,
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

              ScreenUtilHelper.sizedBoxHeight(12.0),

              // Wipe Cards Row
              SizedBox(
                height: 110.h, // Restored height for headers
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Next Wipe Card
                    Expanded(
                      child: _NextWipeCard(
                        nextWipe: server.nextWipe,
                        formatCountdown: _formatCountdown,
                      ),
                    ),
                    ScreenUtilHelper.sizedBoxWidth(12.0),
                    // Last Wipe Card
                    Expanded(
                      child: _LastWipeCard(
                        lastWipe: server.lastWipe,
                        formatTimeAgo: _formatTimeAgo,
                      ),
                    ),
                  ],
                ),
              ),
              ScreenUtilHelper.sizedBoxHeight(16.0),

              // Wipe Alert Settings
              if (server.nextWipe != null)
                Consumer(
                  builder: (context, ref, _) {
                    final hasLifetime = ref.watch(notificationProvider).hasLifetime;
                    
                    return Stack(
                      children: [
                        _WipeAlertSettings(
                          wipeAlertEnabled: wipeAlertEnabled,
                          onToggleWipeAlert: onToggleWipeAlert,
                          wipeAlertMinutes: wipeAlertMinutes,
                          onSetWipeAlertMinutes: onSetWipeAlertMinutes,
                          isPremium: true, // Force unlocked
                        ),
                      ],
                    );
                  },
                ),
              ScreenUtilHelper.sizedBoxHeight(16.0),
            ],
          ),
        ),

        // Fixed Footer Buttons
        _FooterButtons(
          onChangeServer: onChangeServer,
        ),
      ],
    );
  }
}

// Extracted Population Card
class _PopulationCard extends StatelessWidget {
  final int players;
  final int maxPlayers;

  const _PopulationCard({
    required this.players,
    required this.maxPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0x8018181B),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'POP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF71717A),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(8.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$players/$maxPlayers',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted Generic Stat Card (FPS/Uptime)
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0x8018181B),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF71717A),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(8.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted Next Wipe Card
class _NextWipeCard extends StatelessWidget {
  final String? nextWipe;
  final String Function(String?) formatCountdown;

  const _NextWipeCard({
    required this.nextWipe,
    required this.formatCountdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('server.overview.next_wipe').toUpperCase(),
              style: TextStyle(
                color: const Color(0xFF71717A),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
                letterSpacing: 1.0,
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(4.0),
          if (nextWipe != null) ...[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatCountdown(nextWipe),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'RobotoMono',
                  letterSpacing: -0.5,
                ),
              ),
            ),
            ScreenUtilHelper.sizedBoxHeight(4.0),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                DateFormat.MMMd(context.locale.toString()).add_jm().format(DateTime.parse(nextWipe!).toLocal()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF52525B),
                  fontSize: 11.sp, // Increased from 10
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Geist',
                ),
              ),
            ),
          ] else ...[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('server.overview.unknown'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF52525B),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'RobotoMono',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Extracted Last Wipe Card
class _LastWipeCard extends StatelessWidget {
  final String? lastWipe;
  final String Function(String?) formatTimeAgo;

  const _LastWipeCard({
    required this.lastWipe,
    required this.formatTimeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0x8018181B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('server.overview.last_wipe').toUpperCase(),
              style: TextStyle(
                color: const Color(0xFF71717A),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
                letterSpacing: 1.0,
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(6.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formatTimeAgo(lastWipe),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFD4D4D8),
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(6.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              lastWipe != null
                  ? DateFormat.yMMMd(context.locale.toString()).format(DateTime.parse(lastWipe!).toLocal())
                  : tr('server.overview.na'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF52525B),
                fontSize: 11.sp, // Increased from 10
                fontWeight: FontWeight.w500,
                fontFamily: 'Geist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted Wipe Alert Settings
class _WipeAlertSettings extends StatelessWidget {
  final bool wipeAlertEnabled;
  final Function(bool) onToggleWipeAlert;
  final int wipeAlertMinutes;
  final Function(int)? onSetWipeAlertMinutes;
  final bool isPremium;

  const _WipeAlertSettings({
    required this.wipeAlertEnabled,
    required this.onToggleWipeAlert,
    required this.wipeAlertMinutes,
    this.onSetWipeAlertMinutes,
    required this.isPremium,
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
        boxShadow: wipeAlertEnabled
            ? const [
                BoxShadow(
                  color: Color(0x1AF97316),
                  blurRadius: 20,
                )
              ]
            : null,
      ),
      child: Column(
        children: [
          // Toggle Header
          _WipeAlertToggle(
            enabled: wipeAlertEnabled,
            onToggle: onToggleWipeAlert,
            isLocked: !isPremium,
          ),

          // Duration Selector
          if (wipeAlertEnabled && onSetWipeAlertMinutes != null)
            _WipeAlertDurationSelector(
              wipeAlertMinutes: wipeAlertMinutes,
              onSetWipeAlertMinutes: onSetWipeAlertMinutes!,
              isLocked: !isPremium,
            ),
        ],
      ),
    );
  }
}

// Extracted Wipe Alert Toggle
class _WipeAlertToggle extends StatelessWidget {
  final bool enabled;
  final Function(bool) onToggle;
  final bool isLocked;

  const _WipeAlertToggle({
    required this.enabled,
    required this.onToggle,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(
        color: Color(0x33000000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: enabled ? const Color(0xFFFF923F).withOpacity(0.15) : const Color(0xFF27272A),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: enabled ? const Color(0xFFFF923F).withOpacity(0.3) : const Color(0xFF3F3F46),
                    width: 1,
                  ),
                ),
                child: Icon(
                  enabled ? LucideIcons.bell : LucideIcons.bellOff,
                  size: 20.w,
                  color: enabled ? Colors.black : const Color(0xFF71717A),
                ),
              ),
              ScreenUtilHelper.sizedBoxWidth(12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tr('server.overview.wipe_notification'),
                      style: TextStyle(
                        color: enabled ? Colors.white : const Color(0xFFA1A1AA),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
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
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        fontFamily: 'Geist',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Toggle Switch
          InkWell(
            onTap: () {
              HapticHelper.mediumImpact();
              onToggle(!enabled);
            },
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return child;
  }
}

// Extracted Duration Selector
class _WipeAlertDurationSelector extends StatelessWidget {
  final int wipeAlertMinutes;
  final Function(int) onSetWipeAlertMinutes;
  final bool isLocked;

  const _WipeAlertDurationSelector({
    required this.wipeAlertMinutes,
    required this.onSetWipeAlertMinutes,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tr('server.overview.alert_me_before'),
                  style: TextStyle(
                    color: const Color(0xFFA1A1AA),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Geist',
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$wipeAlertMinutes min',
                  style: TextStyle(
                    color: const Color(0xFFF97316),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
            ],
          ),
          ScreenUtilHelper.sizedBoxHeight(12.0),
          Row(
            children: [10, 30, 60, 120].map((mins) {
              final isSelected = wipeAlertMinutes == mins;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: mins == 120 ? 0 : 8.w,
                  ),
                  child: InkWell(
                    onTap: () {
                      HapticHelper.mediumImpact();
                      onSetWipeAlertMinutes(mins);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFF923F)
                            : const Color(0xFF131316),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFF923F)
                              : const Color(0xFF27272A),
                        ),
                      ),
                      child: Text(
                        mins >= 60 ? '${mins ~/ 60}h' : '${mins}m',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : const Color(0xFF71717A),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Geist',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );

    return child;
  }
}

// Extracted Footer Buttons
class _FooterButtons extends StatelessWidget {
  final VoidCallback onChangeServer;

  const _FooterButtons({
    required this.onChangeServer,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: const BoxDecoration(
            color: Color(0xFF0C0C0E),
            border: Border(top: BorderSide(color: Color(0xFF27272A))),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                HapticHelper.mediumImpact();
                onChangeServer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27272A),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: const BorderSide(color: Color(0xFF3F3F46)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.list, size: 16.w),
                  SizedBox(width: 8.w),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'CHANGE SERVER',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Geist',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
