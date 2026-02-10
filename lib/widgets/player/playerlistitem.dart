import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

enum PlayerStatus {
  online,
  offline,
}

class PlayerSearchResultItem {
  const PlayerSearchResultItem({
    required this.id,
    required this.name,
    required this.status,
    this.currentServer,
  });

  final String id;
  final String name;
  final PlayerStatus status;
  final String? currentServer;
}

class PlayerListItem extends StatefulWidget {
  const PlayerListItem({
    super.key,
    required this.player,
    required this.onClick,
  });

  final PlayerSearchResultItem player;
  final ValueChanged<PlayerSearchResultItem> onClick;

  @override
  State<PlayerListItem> createState() => _PlayerListItemState();
}

class _PlayerListItemState extends State<PlayerListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isOnline = widget.player.status == PlayerStatus.online;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        HapticHelper.mediumImpact();
        setState(() => _pressed = false);
        widget.onClick(widget.player);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _pressed ? 0.98 : 1.0, 
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF121214), 
            borderRadius: BorderRadius.circular(12.r), 
            border: Border.all(color: const Color(0xFF27272A)),
          ),
          child: Row(
            children: [
              // Avatar / Icon
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline
                      ? const Color(0x1A16A34A) 
                      : const Color(0xFF27272A), 
                  border: Border.all(
                    color: isOnline
                        ? const Color(0x4D22C55E) 
                        : const Color(0xFF3F3F46), 
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: Icon(
                        LucideIcons.user,
                        size: 20.w, 
                        color: const Color(0xFFA1A1AA), 
                      ),
                    ),
                    Positioned(
                      right: -2.w,
                      bottom: -2.w,
                      child: Container(
                        width: 12.w, 
                        height: 12.w, 
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOnline
                              ? const Color(0xFF22C55E) 
                              : const Color(0xFF52525B), 
                          border: Border.all(
                            color: const Color(0xFF121214), 
                            width: 2.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ScreenUtilHelper.sizedBoxWidth(16.0), 

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.player.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 14.sp, 
                          fontWeight: FontWeight.w800, 
                          fontFamily: 'Geist',
                        ),
                      ),
                    ),
                    ScreenUtilHelper.sizedBoxHeight(4.0), 
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'player_search.list_item.playing_on'.tr(),
                        style: TextStyle(
                          color: const Color(0xFF71717A), 
                          fontSize: 10.sp, 
                          fontWeight: FontWeight.w800, 
                          letterSpacing: 1.5, 
                          fontFamily: 'Geist',
                        ),
                      ),
                    ),
                    ScreenUtilHelper.sizedBoxHeight(2.0),
                    Text(
                      widget.player.currentServer ?? tr('player_search.list_item.not_in_server'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.player.currentServer != null
                            ? const Color(0xFFE4E4E7) 
                            : const Color(0xFF52525B), 
                        fontSize: 12.sp, 
                        fontStyle: widget.player.currentServer != null
                            ? FontStyle.normal
                            : FontStyle.italic,
                        fontFamily: 'RobotoMono', 
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
}
