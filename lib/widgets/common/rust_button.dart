import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

/// RAID ALARM Button Component
/// React Native Button.tsx'ten Flutter'a taşınmıştır
/// 
/// Variants:
/// - primary: Red gradient button with shadow
/// - secondary: Dark zinc button
/// - outline: Transparent with border
/// - danger: Red pulsing alert button
/// - ghost: Transparent text-only button
class RustButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final RustButtonVariant variant;
  final bool disabled;
  final double? width;

  const RustButton({
    required this.child,
    super.key,
    this.onPressed,
    this.variant = RustButtonVariant.primary,
    this.disabled = false,
    this.width,
  });

  /// Primary button constructor (red gradient)
  factory RustButton.primary({
    required Widget child,
    VoidCallback? onPressed,
    bool disabled = false,
    double? width,
    Key? key,
  }) {
    return RustButton(
      onPressed: onPressed,
      variant: RustButtonVariant.primary,
      disabled: disabled,
      width: width,
      key: key,
      child: child,
    );
  }

  /// Secondary button constructor (dark zinc)
  factory RustButton.secondary({
    required Widget child,
    VoidCallback? onPressed,
    bool disabled = false,
    double? width,
    Key? key,
  }) {
    return RustButton(
      onPressed: onPressed,
      variant: RustButtonVariant.secondary,
      disabled: disabled,
      width: width,
      key: key,
      child: child,
    );
  }

  /// Outline button constructor
  factory RustButton.outline({
    required Widget child,
    VoidCallback? onPressed,
    bool disabled = false,
    double? width,
    Key? key,
  }) {
    return RustButton(
      onPressed: onPressed,
      variant: RustButtonVariant.outline,
      disabled: disabled,
      width: width,
      key: key,
      child: child,
    );
  }

  /// Danger button constructor (pulsing red)
  factory RustButton.danger({
    required Widget child,
    VoidCallback? onPressed,
    bool disabled = false,
    double? width,
    Key? key,
  }) {
    return RustButton(
      onPressed: onPressed,
      variant: RustButtonVariant.danger,
      disabled: disabled,
      width: width,
      key: key,
      child: child,
    );
  }

  /// Ghost button constructor (transparent)
  factory RustButton.ghost({
    required Widget child,
    VoidCallback? onPressed,
    bool disabled = false,
    double? width,
    Key? key,
  }) {
    return RustButton(
      onPressed: onPressed,
      variant: RustButtonVariant.ghost,
      disabled: disabled,
      width: width,
      key: key,
      child: child,
    );
  }

  /// Success button constructor (green gradient)
  factory RustButton.success({
    required Widget child,
    VoidCallback? onPressed,
    bool disabled = false,
    double? width,
    Key? key,
  }) {
    return RustButton(
      onPressed: onPressed,
      variant: RustButtonVariant.success,
      disabled: disabled,
      width: width,
      key: key,
      child: child,
    );
  }

  @override
  State<RustButton> createState() => _RustButtonState();
}

class _RustButtonState extends State<RustButton> with SingleTickerProviderStateMixin {
  // Lazy animation controller - only created for danger variant
  AnimationController? _pulseController;
  bool _isPressed = false;

  // Static style cache - styles created once and reused
  static final Map<RustButtonVariant, _ButtonStyle> _styleCache = {};

  @override
  void initState() {
    super.initState();
    
    // Only create animation controller for danger variant (lazy initialization)
    if (widget.variant == RustButtonVariant.danger) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getCachedButtonStyle();
    
    return SizedBox(
      width: widget.width ?? double.infinity,
      child: GestureDetector(
        onTapDown: widget.disabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: widget.disabled ? null : (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: widget.disabled ? null : () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedOpacity(
            opacity: widget.disabled ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              constraints: BoxConstraints(minHeight: ScreenUtilHelper.buttonHeightStandard),
              alignment: Alignment.center,
              decoration: buttonStyle.decoration,
              child: DefaultTextStyle(
                style: buttonStyle.textStyle,
                textAlign: TextAlign.center,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Get cached style or create and cache it
  _ButtonStyle _getCachedButtonStyle() {
    return _styleCache.putIfAbsent(
      widget.variant,
      () => _createButtonStyle(widget.variant),
    );
  }

  // Create button style (called once per variant, then cached)
  static _ButtonStyle _createButtonStyle(RustButtonVariant variant) {
    switch (variant) {
      case RustButtonVariant.primary:
        return _ButtonStyle(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFB91C1C), Color(0xFFDC2626)], // from-red-700 to-red-600
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(2.r), // rounded-sm
            border: Border.all(
              color: RustColors.primary.withOpacity(0.5), // border-red-500/50
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7F1D1D).withOpacity(0.4), // shadow-red-900/40
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          textStyle: RustTypography.rustStyle(
            fontSize: 14.sp,
            weight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.2.w, // tracking-wider
          ),
        );

      case RustButtonVariant.secondary:
        return _ButtonStyle(
          decoration: BoxDecoration(
            color: const Color(0xFF27272A), // bg-zinc-800
            borderRadius: BorderRadius.circular(2.r),
            border: Border.all(
              color: const Color(0xFF52525B), // border-zinc-600
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          textStyle: RustTypography.rustStyle(
            fontSize: 14.sp,
            weight: FontWeight.w900,
            color: const Color(0xFFF4F4F5), // text-zinc-100
            letterSpacing: 1.2.w,
          ),
        );

      case RustButtonVariant.outline:
        return _ButtonStyle(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(2.r),
            border: Border.all(
              color: const Color(0xFF3F3F46), // border-zinc-700
              width: 2,
            ),
          ),
          textStyle: RustTypography.rustStyle(
            fontSize: 14.sp,
            weight: FontWeight.w900,
            color: const Color(0xFF9CA3AF), // text-zinc-400
            letterSpacing: 1.5,
          ),
        );

      case RustButtonVariant.danger:
        return _ButtonStyle(
          decoration: BoxDecoration(
            color: const Color(0xFF450A0A).withOpacity(0.4), // bg-red-950/40
            borderRadius: BorderRadius.circular(2.r),
            border: Border.all(
              color: RustColors.primary.withOpacity(0.5), // border-red-500/50
              width: 1,
            ),
          ),
          textStyle: RustTypography.rustStyle(
            fontSize: 14.sp,
            weight: FontWeight.w900,
            color: RustColors.primary, // text-red-500
            letterSpacing: 1.5,
          ),
        );

      case RustButtonVariant.ghost:
        return _ButtonStyle(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(2.r),
          ),
          textStyle: RustTypography.rustStyle(
            fontSize: 14.sp,
            weight: FontWeight.w900,
            color: const Color(0xFF71717A), // text-zinc-500
            letterSpacing: 1.5,
          ),
        );

      case RustButtonVariant.success:
        return _ButtonStyle(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF16A34A), Color(0xFF22C55E)], // from-green-600 to-green-500
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(2.r),
            border: Border.all(
              color: RustColors.success.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF14532D).withOpacity(0.4), // shadow-green-900/40
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          textStyle: RustTypography.rustStyle(
            fontSize: 14.sp,
            weight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        );
    }
  }
}

/// Button variants matching React Native
enum RustButtonVariant {
  primary,
  secondary,
  outline,
  danger,
  ghost,
  success,
}

/// Internal class to hold button styling
class _ButtonStyle {
  final BoxDecoration decoration;
  final TextStyle textStyle;

  _ButtonStyle({
    required this.decoration,
    required this.textStyle,
  });
}
