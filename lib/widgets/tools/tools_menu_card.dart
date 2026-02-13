import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';

/// ToolsMenuCard - Araç menü kartı
/// React Native: ToolsMenuCard.tsx
class ToolsMenuCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? imageUrl;
  final VoidCallback onClick;
  final Color color;
  final double? height;

  const ToolsMenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.imageUrl,
    required this.onClick,
    required this.color,
    this.height,
  });

  @override
  State<ToolsMenuCard> createState() => _ToolsMenuCardState();
}

class _ToolsMenuCardState extends State<ToolsMenuCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticHelper.lightImpact();
        widget.onClick();
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 80),
        scale: _isPressed ? 0.98 : 1.0,
        child: Container(
          height: widget.height ?? 72.h, 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r), 
            border: Border.all(
              color: const Color(0xFF27272A), 
              width: 1.0.w,
            ),
            color: const Color(0xFF000000), 
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background Image (static)
              Positioned.fill(
                child: widget.imageUrl != null
                    ? Opacity(
                        opacity: 0.6,
                        child: Image.asset(
                          widget.imageUrl!,
                          fit: BoxFit.cover,
                          cacheWidth: (1080.w * ScreenUtil().pixelRatio!).toInt(),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF18181B),
                            );
                          },
                        ),
                      )
                    : Container(
                        color: const Color(0xFF18181B),
                      ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black, 
                        Colors.black.withOpacity(0.9), 
                        Colors.transparent, 
                      ],
                      stops: const [0.0, 0.45, 1.0], 
                    ),
                  ),
                ),
              ),

              // Content
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Icon + Text
                      Expanded(
                        child: Row(
                          children: [
                            // Icon Container
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), 
                                child: Container(
                                  width: 48.w, 
                                  height: 48.w, // Using w for square
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF18181B).withOpacity(0.8), 
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.05), 
                                      width: 1.0.w,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    widget.icon,
                                    size: 24.w,
                                    color: widget.color,
                                  ),
                                ),
                              ),
                            ),
                            
                            ScreenUtilHelper.sizedBoxWidth(16), 

                            // Text
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: RustTypography.rustStyle(
                                        fontSize: 17.sp,
                                        weight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0,
                                      ).copyWith(height: 1.1),
                                    ),
                                  ),
                                  ScreenUtilHelper.sizedBoxHeight(2), 
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle( 
                                        fontSize: 11.sp, 
                                        color: const Color(0xFFA1A1AA), 
                                        fontWeight: FontWeight.w500, 
                                        letterSpacing: 0.4.w, 
                                        fontFamily: 'Geist',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right: Chevron
                      Container(
                        width: 32.w, 
                        height: 32.w, 
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05), 
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05), 
                            width: 1.0.w,
                          ),
                          borderRadius: BorderRadius.circular(16.r), 
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_right,
                          size: 20.w, 
                          color: Colors.white.withOpacity(0.5), 
                        ),
                      ),
                    ],
                   ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
