import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';



/// Settings Dropdown
class SettingsDropdown extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ValueChanged<String> onChange;
  final List<String> options;

  const SettingsDropdown({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChange,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Icon + Label
        Row(
          children: [
            Icon(
              icon,
              size: 20.0.w, // w-5 h-5
              color: RustColors.textMuted, // text-zinc-500
            ),
            SizedBox(width: 16.0.w), // gap-4
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.0.sp, // text-sm
                  fontWeight: FontWeight.w500, // font-medium
                  color: const Color(0xFFD4D4D8), // zinc-300
                ),
              ),
            ),
          ],
        ),
        // Right: Dropdown
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 90.w), // min-w-[90px]
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 12.0.w, // pl-3
                  right: 32.0.w, // pr-8
                  top: 8.0.h,
                  bottom: 8.0.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E), // bg-[#1c1c1e]
                  border: Border.all(
                    color: const Color(0xFF27272A), // zinc-800
                    width: 1.0.w,
                  ),
                  borderRadius: BorderRadius.circular(8.0.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        HapticHelper.mediumImpact();
                        onChange(newValue);
                      }
                    },
                    items: options.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFD4D4D8),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    isDense: true,
                    icon: const SizedBox.shrink(),
                    dropdownColor: const Color(0xFF1C1C1E),
                  ),
                ),
              ),
              Positioned(
                right: 12.0.w,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 12.0.w,
                  color: const Color(0xFF71717A), // zinc-500
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Settings Toggle
class SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool checked;
  final ValueChanged<bool> onChange;

  const SettingsToggle({
    Key? key,
    required this.icon,
    required this.label,
    required this.checked,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Icon + Label
        Row(
          children: [
            Icon(
              icon,
              size: 20.0.w, // w-5 h-5
              color: RustColors.textMuted, // text-zinc-500
            ),
            SizedBox(width: 16.0.w), // gap-4
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFD4D4D8),
                ),
              ),
            ),
          ],
        ),
        // Right: Toggle
        GestureDetector(
          onTap: () {
          HapticHelper.mediumImpact();
          onChange(!checked);
        },
          child: Container(
            width: 40.0.w, // w-10
            height: 24.0.h, // h-6
            padding: EdgeInsets.all(4.0.w), // p-1
            decoration: BoxDecoration(
              color: checked
                  ? RustColors.primary // red-600
                  : const Color(0xFF3F3F46), // zinc-700
              borderRadius: BorderRadius.circular(12.0.r), // rounded-full
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment:
                  checked ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 16.0.w, // w-4
                height: 16.0.w, // h-4
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4.0.r,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
