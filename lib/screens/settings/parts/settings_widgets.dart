part of '../settings_screen.dart';

class _SettingsBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _SettingsBackButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticHelper.mediumImpact();
        if (onTap != null) {
          onTap!();
        } else {
          context.pop();
        }
      },
      child: Container(
        width: 40.w,
        height: 40.w,
        transform: Matrix4.translationValues(-8.w, 0, 0), // -ml-2
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: Icon(
          LucideIcons.arrowLeft,
          size: 20.w,
          color: RustColors.textMuted,
        ),
      ),
    );
  }
}

class _LegalLinkItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String path;
  final bool isLast;

  const _LegalLinkItem({
    required this.icon,
    required this.text,
    required this.path,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticHelper.mediumImpact();
          context.push(path);
        },
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: isLast 
              ? null 
              : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: RustColors.divider,
                      width: 1.w,
                    ),
                  ),
                ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 20.w,
                    color: RustColors.textSecondary,
                  ),
                  SizedBox(width: 16.w),
                  FittedBox(
                    child: Text(
                      text,
                      style: RustTypography.bodyMedium
                          .copyWith(
                        color: RustColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 16.w,
                color: const Color(0xFF52525B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
