import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';

class ToolsGridCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback onClick;
  
  const ToolsGridCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.onClick,
  });

  @override
  State<ToolsGridCard> createState() => _ToolsGridCardState();
}

class _ToolsGridCardState extends State<ToolsGridCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticHelper.mediumImpact();
        widget.onClick();
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 80),
        scale: _isPressed ? 0.98 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFF27272A),
              width: 1.0.w,
            ),
            color: const Color(0xFF000000),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: widget.imageUrl != null
                    ? Opacity(
                        opacity: 0.7,
                        child: Image.asset(
                          widget.imageUrl!,
                          fit: BoxFit.cover,
                          cacheWidth: (400 * ScreenUtil().pixelRatio!).toInt(),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: const Color(0xFF18181B));
                          },
                        ),
                      )
                    : Container(color: const Color(0xFF18181B)),
              ),

              // Gradient Overlay (Bottom to Top for text readability)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: RustTypography.rustStyle(
                          fontSize: 14.sp,
                          weight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ).copyWith(height: 1.1),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFFA1A1AA),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Geist',
                          height: 1.2,
                        ),
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
