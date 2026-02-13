import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import '../models/camera_code.dart';

class CCTVCardWidget extends ConsumerStatefulWidget {
  final CameraCode item;
  final VoidCallback onTap;

  const CCTVCardWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  ConsumerState<CCTVCardWidget> createState() => _CCTVCardWidgetState();
}

class _CCTVCardWidgetState extends ConsumerState<CCTVCardWidget>
    with SingleTickerProviderStateMixin {
  bool _copied = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.item.isRandom) {
      HapticHelper.lightImpact();
      widget.onTap();
      return;
    }

    HapticHelper.lightImpact();
    await Clipboard.setData(ClipboardData(text: widget.item.code));
    
    if (mounted) {
      setState(() => _copied = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() => _copied = false);
      }
    }

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        _handleTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C0E), // Match control panel color for overall card
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _copied
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF27272A),
              width: 1.w,
            ),
            boxShadow: _copied
                ? [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withOpacity(0.2),
                      blurRadius: 20.r,
                      spreadRadius: 0.r,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Monitor Screen Area (16:9 aspect ratio)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Container(
                    color: const Color(0xFF18181B),
                    child: Stack(
                      children: [
                        // Image
                        if (widget.item.img != null)
                          Positioned.fill(
                            child: Image.asset(
                              widget.item.img!,
                              fit: BoxFit.cover,
                              cacheWidth: (320.w * ScreenUtil().pixelRatio!).toInt(),
                              cacheHeight: (180.h * ScreenUtil().pixelRatio!).toInt(),
                              gaplessPlayback: true,
                              filterQuality: FilterQuality.low,
                              opacity: _copied ? const AlwaysStoppedAnimation(0.3) : null,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.radio,
                                    size: 32.w,
                                    color: const Color(0xFF3F3F46),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Center(
                            child: Icon(
                              Icons.radio,
                              size: 32.w,
                              color: const Color(0xFF3F3F46),
                            ),
                          ),

                        // REC Overlay
                        if (!_copied)
                          Positioned(
                            top: 8.h,
                            left: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(2.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1.w,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDC2626),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFDC2626),
                                          blurRadius: 5.r,
                                          spreadRadius: 0.r,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ScreenUtilHelper.sizedBoxWidth(6),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      tr('cctv_codes.ui.rec'),
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 1.5.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Copied Overlay
                        if (_copied)
                          Positioned.fill(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _copied ? 1.0 : 0.0,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40.w,
                                      height: 40.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22C55E),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF22C55E)
                                                .withOpacity(0.5),
                                            blurRadius: 20.r,
                                            spreadRadius: 0.r,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.black,
                                        size: 24.w,
                                      ),
                                    ),
                                    ScreenUtilHelper.sizedBoxHeight(8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          tr('cctv_codes.ui.copied'),
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF22C55E),
                                            letterSpacing: 1.5.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Control Panel (Bottom) - Removed MainAxisSize.min to fill vertical space
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C0C0E),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start, // Align to top of area
                    children: [
                      // Label
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          tr(widget.item.label),
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF71717A),
                            letterSpacing: 1.2.w,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ScreenUtilHelper.sizedBoxHeight(6),

                      // Code and Copy Icon Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.item.code,
                                style: TextStyle(
                                  fontSize: 13.sp, // Slightly larger
                                  fontWeight: FontWeight.w900,
                                  color: _copied
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFFD4D4D8),
                                  fontFamily: 'monospace',
                                  letterSpacing: 1.2.w,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          ScreenUtilHelper.sizedBoxWidth(8),
                          if (!_copied)
                            Icon(
                              Icons.content_copy,
                              size: 14.w,
                              color: const Color(0xFF3F3F46),
                            ),
                        ],
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


