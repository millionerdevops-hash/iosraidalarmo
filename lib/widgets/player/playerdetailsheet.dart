import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

class PlayerDetailSheet extends ConsumerStatefulWidget {
  final String playerName;
  final String? playerId;
  final String? serverId;
  final bool isOnline;
  final bool initialNotifyOnOnline;
  final bool initialNotifyOnOffline;
  final Function(bool notifyOnOnline, bool notifyOnOffline) onUpdate;

  const PlayerDetailSheet({
    super.key,
    required this.playerName,
    this.playerId,
    this.serverId,
    required this.isOnline,
    required this.initialNotifyOnOnline,
    required this.initialNotifyOnOffline,
    this.lastSeen,
    required this.onUpdate,
    required this.onClose,
  });

  final String? lastSeen;
  final VoidCallback onClose;

  @override
  ConsumerState<PlayerDetailSheet> createState() => _PlayerDetailSheetState();
}

class _PlayerDetailSheetState extends ConsumerState<PlayerDetailSheet> {
  late bool _notifyOnOnline;
  late bool _notifyOnOffline;

  @override
  void initState() {
    super.initState();
    // If player is OFFLINE, we want to be notified when they come ONLINE
    // If player is ONLINE, we want to be notified when they go OFFLINE
    if (widget.isOnline) {
      _notifyOnOnline = false;
      _notifyOnOffline = widget.initialNotifyOnOffline;
    } else {
      _notifyOnOnline = widget.initialNotifyOnOnline;
      _notifyOnOffline = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        border: const Border(top: BorderSide(color: Color(0xFF27272A))),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        minimum: EdgeInsets.only(bottom: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            _buildHandle(),
            
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Name, ID, Avatar
                  _buildHeader(),
                  
                  ScreenUtilHelper.sizedBoxHeight(16.0),
                  
                  // Current State & Last Seen (Side by Side)
                  Row(
                    children: [
                      Expanded(child: _buildCompactStateCard()),
                      ScreenUtilHelper.sizedBoxWidth(12.0),
                      Expanded(child: _buildCompactLastSeenCard()),
                    ],
                  ),
                  
                  ScreenUtilHelper.sizedBoxHeight(16.0),
                  
                  // Alert Triggers & Footer (Premium Locked Section)
                  Builder(
                    builder: (context) {
                      final hasLifetime = ref.watch(notificationProvider).hasLifetime;
                      
                      return Column(
                        children: [
                          _buildAlertTriggers(),
                          ScreenUtilHelper.sizedBoxHeight(16.0),
                          _buildFooter(hasLifetime),
                        ],
                      );
                    },
                  ),
                  ScreenUtilHelper.sizedBoxHeight(24.0), 
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      alignment: Alignment.center,
      child: Container(
        width: 48.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: const Color(0xFF27272A),
          borderRadius: BorderRadius.circular(999.r),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.playerName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Geist',
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
              ),
              ScreenUtilHelper.sizedBoxHeight(8.0),
              _buildIdChip(widget.playerId ?? tr('player_search.details.tracking_id')),
            ],
          ),
        ),
        _buildCloseButton(context),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticHelper.mediumImpact();
        widget.onClose();
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF27272A)),
        ),
        child: Icon(
          LucideIcons.x,
          size: 20.w,
          color: const Color(0xFF71717A),
        ),
      ),
    );
  }

  Widget _buildIdChip(String id) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fingerprint, size: 12.w, color: const Color(0xFF71717A)),
          ScreenUtilHelper.sizedBoxWidth(6.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              id,
              style: TextStyle(
                color: const Color(0xFF71717A),
                fontSize: 10.sp,
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxWidth(4.0),
          Icon(LucideIcons.copy, size: 10.w, color: const Color(0xFF71717A).withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildCompactStateCard() {
    final bool isOnline = widget.isOnline;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isOnline ? const Color(0xFF064E3B).withOpacity(0.1) : const Color(0xFF18181B).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isOnline ? const Color(0xFF10B981).withOpacity(0.3) : const Color(0xFF27272A),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              tr('player_search.details.current_state'),
              style: TextStyle(
                color: const Color(0xFF71717A),
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(4.0),
          Row(
            children: [
              if (isOnline)
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
              if (isOnline) ScreenUtilHelper.sizedBoxWidth(6.0),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  isOnline ? tr('player_search.details.online') : tr('player_search.details.offline'),
                  style: TextStyle(
                    color: isOnline ? const Color(0xFF10B981) : const Color(0xFF71717A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactLastSeenCard() {
    // Parse and format lastSeen to local time
    String displayLastSeen = widget.lastSeen ?? tr('player_search.details.unknown');
    
    if (widget.lastSeen != null && widget.lastSeen != tr('player_search.details.unknown')) {
      try {
        // Try parsing as ISO format first (from API)
        final parsedDate = DateTime.parse(widget.lastSeen!);
        displayLastSeen = DateFormat('MMM d, HH:mm', context.locale.toString()).format(parsedDate.toLocal());
      } catch (e) {
        // If parsing fails, check if it's already formatted (HH:mm from provider)
        if (widget.lastSeen!.contains(':') && widget.lastSeen!.length <= 5) {
          // Already in HH:mm format, keep as is
          displayLastSeen = widget.lastSeen!;
        } else {
          // Fallback to original
          displayLastSeen = widget.lastSeen!;
        }
      }
    }
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF121214),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              tr('player_search.details.last_seen'),
              style: TextStyle(
                color: const Color(0xFF71717A),
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ScreenUtilHelper.sizedBoxHeight(4.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              displayLastSeen,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAlertTriggers() {
    // If player is OFFLINE, only ONLINE trigger should be enabled
    // If player is ONLINE, only OFFLINE trigger should be enabled
    final bool canSelectOnline = !widget.isOnline;
    final bool canSelectOffline = widget.isOnline;
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF121214),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.bell, size: 12.w, color: const Color(0xFFF97316)),
              ScreenUtilHelper.sizedBoxWidth(6.0),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  tr('player_search.details.alert_triggers'),
                  style: TextStyle(
                    color: const Color(0xFF71717A),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          ScreenUtilHelper.sizedBoxHeight(10.0),
          Row(
            children: [
              Expanded(
                child: _buildTriggerButton(
                  label: tr('player_search.details.online'),
                  icon: LucideIcons.wifi,
                  isActive: _notifyOnOnline,
                  isEnabled: canSelectOnline,
                  onTap: canSelectOnline ? () {
                    HapticHelper.mediumImpact();
                    setState(() {
                      _notifyOnOnline = true;
                      _notifyOnOffline = false;
                    });
                  } : null,
                  activeColor: const Color(0xFF10B981),
                ),
              ),
              ScreenUtilHelper.sizedBoxWidth(10.0),
              Expanded(
                child: _buildTriggerButton(
                  label: tr('player_search.details.offline'),
                  icon: LucideIcons.wifiOff,
                  isActive: _notifyOnOffline,
                  isEnabled: canSelectOffline,
                  onTap: canSelectOffline ? () {
                    HapticHelper.mediumImpact();
                    setState(() {
                      _notifyOnOffline = true;
                      _notifyOnOnline = false;
                    });
                  } : null,
                  activeColor: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required bool isEnabled,
    required VoidCallback? onTap,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(10.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isActive 
             ? activeColor.withOpacity(0.1) 
             : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isActive 
               ? activeColor.withOpacity(0.5) 
               : const Color(0xFF27272A),
          ),
        ),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.3,
          child: Column(
            children: [
              Icon(
                icon,
                size: 18.w,
                color: isActive ? activeColor : const Color(0xFF52525B),
              ),
              ScreenUtilHelper.sizedBoxHeight(6.0),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? activeColor : const Color(0xFF52525B),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(bool isPremium) {
    return SizedBox(
      width: double.infinity,
      child: Opacity(
        opacity: 1.0,
        child: ElevatedButton(
          onPressed: () {
            HapticHelper.mediumImpact();
            if (!isPremium) {
              context.pushNamed('paywall');
              return;
            }
            widget.onUpdate(_notifyOnOnline, _notifyOnOffline);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF7F1D1D).withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('player_search.details.update_tracking'),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'Geist',
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
