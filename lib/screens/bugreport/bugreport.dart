import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/widgets/common/rust_button.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

class BugReportScreen extends ConsumerStatefulWidget {
  const BugReportScreen({super.key});

  @override
  ConsumerState<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends ConsumerState<BugReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      HapticHelper.error();
      return;
    }

    setState(() => _isSending = true);
    HapticHelper.mediumImpact();

    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();
    
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'alcstackdev@gmail.com',
      query: encodeQueryParameters({
        'subject': '[BUG REPORT] $subject',
        'body': description,
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(tr('bug_report.ui.success')),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw 'Could not launch $emailLaunchUri';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(tr('bug_report.ui.error_mail')),
            ),
            backgroundColor: RustColors.primary,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return RustScreenLayout(
      child: Scaffold(
        backgroundColor: RustColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: ScreenUtilHelper.paddingAll(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(tr('bug_report.ui.subject')),
                        ScreenUtilHelper.sizedBoxHeight(8),
                        _buildTextField(
                          controller: _subjectController,
                          hint: tr('bug_report.ui.subject_hint'),
                          maxLines: 1,
                        ),
                        ScreenUtilHelper.sizedBoxHeight(24),
                        _buildLabel(tr('bug_report.ui.description')),
                        ScreenUtilHelper.sizedBoxHeight(8),
                        _buildTextField(
                          controller: _descriptionController,
                          hint: tr('bug_report.ui.description'),
                          maxLines: 10,
                        ),
                        ScreenUtilHelper.sizedBoxHeight(24),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: _buildSendButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1.h,
          ),
        ),
        color: RustColors.background,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(LucideIcons.chevronLeft, color: RustColors.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('bug_report.ui.title'),
              style: RustTypography.titleLarge.copyWith(
                color: RustColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        label.toUpperCase(),
        style: RustTypography.monoStyle(
          fontSize: 12.sp,
          weight: FontWeight.w700,
          color: const Color(0xFF71717A),
          letterSpacing: 2.w,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return tr('bug_report.ui.error_empty');
        }
        return null;
      },
      style: RustTypography.bodyMedium.copyWith(color: RustColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xFF3F3F46), fontSize: 14.sp),
        filled: true,
        fillColor: const Color(0xFF121214),
        contentPadding: EdgeInsets.all(16.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: RustColors.divider, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFF52525B), width: 1.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: RustColors.primary.withOpacity(0.5), width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: RustColors.primary, width: 1.w),
        ),
        errorStyle: const TextStyle(color: RustColors.primary),
      ),
    );
  }

  Widget _buildSendButton() {
    return RustButton.primary(
      onPressed: _isSending ? null : _handleSend,
      child: _isSending
          ? SizedBox(
              height: 20.h,
              width: 20.h,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          : Text(
              tr('bug_report.ui.send'),
            ),
    );
  }
}
