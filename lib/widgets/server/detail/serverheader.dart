import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/widgets/server/status/serversearchmanager.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

class ServerHeader extends StatelessWidget {
  final ServerData server;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onNavigate;

  const ServerHeader({
    super.key,
    required this.server,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isOnline = server.status == 'online';

    return Container(
      constraints: BoxConstraints(minHeight: 185.h),
      decoration: const BoxDecoration(
        color: Color(0xFF121214),
        border: Border(bottom: BorderSide(color: Color(0xFF27272A))),
      ),
      child: Stack(
        children: [
          // Background
          if (server.headerImage != null)
            Positioned.fill(
              child: Stack(
                children: [
                  // Background Image with Blur
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.4,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Image.network(
                          server.headerImage!,
                          fit: BoxFit.cover,
                          // Performance optimizations
                          cacheWidth: (ScreenUtil().screenWidth * ScreenUtil().pixelRatio!).toInt(),
                          cacheHeight: (200.h * ScreenUtil().pixelRatio!).toInt(),
                          filterQuality: FilterQuality.medium,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x99000000),
                            Color(0xCC121214),
                            Color(0xFF121214),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x80000000),
                      Color(0xFF121214),
                    ],
                  ),
                ),
              ),
            ),

          // Main Layout Content
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nav & Favorite Buttons Row
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    _HeaderButton(
                      onTap: onNavigate,
                      icon: LucideIcons.arrowLeft,
                      backgroundColor: const Color(0x66000000),
                      borderColor: const Color(0x1AFFFFFF),
                    ),

                    // Favorite Button
                    _HeaderButton(
                      onTap: onToggleFavorite,
                      icon: isFavorite ? Icons.star : Icons.star_border,
                      iconColor: isFavorite
                          ? const Color(0xFFEAB308)
                          : const Color(0xFFA1A1AA),
                      backgroundColor: isFavorite
                          ? const Color(0x33EAB308)
                          : const Color(0x66000000),
                      borderColor: isFavorite
                          ? const Color(0xFFEAB308)
                          : const Color(0x1AFFFFFF),
                    ),
                  ],
                ),
              ),

              // Info Section - Takes remaining space and anchors to bottom
              Container(
                padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Server Name - will wrap to 2 lines if needed
                    Text(
                      server.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        fontFamily: 'Geist',
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    ScreenUtilHelper.sizedBoxHeight(8.0),

                    // IP:Port + Status Badges Row
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // IP:Port Badge
                        _IPBadge(server: server),

                        // Online/Offline Badge
                        _StatusBadge(isOnline: isOnline),

                        // Official / Modded / Community Badge
                        if (server.official)
                          const _OfficialBadge()
                        else if (server.modded)
                          const _ModdedBadge()
                        else
                          const _CommunityBadge(),

                        // PvE Badge
                        if (server.pve)
                          const _PveBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Extracted button widget to prevent rebuilds
class _HeaderButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color? iconColor;
  final Color backgroundColor;
  final Color borderColor;

  const _HeaderButton({
    required this.onTap,
    required this.icon,
    this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticHelper.mediumImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(999.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: borderColor),
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: iconColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted IP badge to prevent rebuilds
class _IPBadge extends StatelessWidget {
  final ServerData server;

  const _IPBadge({required this.server});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticHelper.mediumImpact();
        Clipboard.setData(
          ClipboardData(text: '${server.ip}:${server.port}'),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xCC18181B),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: const Color(0xFF3F3F46)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${server.ip}:${server.port}',
                    style: TextStyle(
                      color: const Color(0xFFD4D4D8),
                      fontSize: 11.sp,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted status badge to prevent rebuilds
class _StatusBadge extends StatelessWidget {
  final bool isOnline;

  const _StatusBadge({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0x99000000),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: const Color(0x1AFFFFFF)),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              isOnline ? tr('server.status.online') : tr('server.status.offline'),
              style: TextStyle(
                color: isOnline
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFEF4444),
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                fontFamily: 'Geist',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted official badge to prevent rebuilds
class _OfficialBadge extends StatelessWidget {
  const _OfficialBadge();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0x991E3A8A),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: const Color(0x4D3B82F6)),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('server.status.official'),
              style: TextStyle(
                color: const Color(0xFF60A5FA),
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted modded badge
class _ModdedBadge extends StatelessWidget {
  const _ModdedBadge();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0x997C3AED), // violet-700 with opacity
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: const Color(0x4D8B5CF6)), // violet-500
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('server.status.modded'),
              style: TextStyle(
                color: const Color(0xFFA78BFA), // violet-400
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted community badge
class _CommunityBadge extends StatelessWidget {
  const _CommunityBadge();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0x99166534), // green-800 with opacity
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: const Color(0x4D22C55E)), // green-500
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('server.status.community'),
              style: TextStyle(
                color: const Color(0xFF4ADE80), // green-400
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted PvE badge
class _PveBadge extends StatelessWidget {
  const _PveBadge();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0x9992400E), // amber-900 with opacity
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: const Color(0x4DF59E0B)), // amber-500
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'PvE',
              style: TextStyle(
                color: const Color(0xFFFCD34D), // amber-300
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
