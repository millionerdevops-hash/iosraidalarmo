import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/rust_colors.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _declined = false;
  bool _isChecked = false;

  Future<void> _handleAccept() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('disclaimer_accepted', true);
    if (mounted) {
      context.go('/get-started');
    }
  }

  void _handleDecline() {
    setState(() {
      _declined = true;
    });
  }

  void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_declined) {
      return Scaffold(
        backgroundColor: const Color(0xFF0c0c0e),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.red.shade900.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red.shade500.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cancel,
                      size: 48,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Access Denied',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'To ensure transparency and compliance with Facepunch Studios\' guidelines, you must accept the disclaimer to use this application.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFd4d4d8),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _declined = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RustColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Read Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _exitApp,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Exit App',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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

    return Scaffold(
      backgroundColor: const Color(0xFF0c0c0e),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
              decoration: const BoxDecoration(
                color: Color(0xFF0c0c0e),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF27272a)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade900.withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'IMPORTANT DISCLAIMER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Warning Box
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF18181b),
                        border: Border.all(
                          color: Colors.red.shade500.withOpacity(0.4),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(text: 'This application is '),
                                  TextSpan(
                                    text: 'UNOFFICIAL',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'NOT AFFILIATED',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextSpan(
                                      text:
                                          ' with Facepunch Studios or Rust.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Key Information
                    _buildSection(
                      title: 'Key Information',
                      borderColor: const Color(0xFF3f3f46),
                      children: [
                        _buildBulletPoint(
                            'This is a third-party application developed independently.'),
                        _buildBulletPoint(
                            'NOT created, endorsed, or supported by Facepunch Studios Ltd.',
                            bold: true),
                        _buildBulletPoint(
                            'Uses the publicly available Rust+ Companion API within permitted guidelines.'),
                        _buildBulletPoint(
                            '"Rust" and "Rust+" are registered trademarks of Facepunch Studios Ltd.'),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Risks & Responsibilities
                    _buildSection(
                      title: 'Risks & Responsibilities',
                      borderColor: const Color(0xFFc2410c),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF27272a).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF3f3f46),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildWarningPoint(
                                  'You use this app entirely at your own risk.'),
                              const SizedBox(height: 16),
                              _buildWarningPoint(
                                  'Facepunch Studios Ltd. has NO LIABILITY for this application or its usage.',
                                  bold: true),
                              const SizedBox(height: 16),
                              _buildWarningPoint(
                                  'The developer is NOT responsible for account actions, bans, or in-game consequences.',
                                  bold: true),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Discontinuation Risk
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF450a0a).withOpacity(0.2),
                        border: Border.all(
                          color: Colors.red.shade500.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                size: 20,
                                color: Colors.red.shade500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'SERVICE AVAILABILITY',
                                style: TextStyle(
                                  color: Colors.red.shade500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'This app may be discontinued at any time if:',
                            style: TextStyle(
                              color: Colors.red.shade200.withOpacity(0.8),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...[ 
                            'Facepunch Studios requests feature removal or app takedown.',
                            'The Rust+ API is modified, restricted, or shut down.',
                            'Legal or technical circumstances change.',
                          ].map((text) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: TextStyle(
                                        color: Colors.red.shade100
                                            .withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          color: Colors.red.shade100
                                              .withOpacity(0.7),
                                          fontSize: 11,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 12),
                          Text(
                            'No refunds are guaranteed if the app is discontinued due to external factors.',
                            style: TextStyle(
                              color: Colors.red.shade200,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF121214),
                border: Border(
                  top: BorderSide(color: Color(0xFF3f3f46)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Checkbox
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isChecked = !_isChecked;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _isChecked
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: _isChecked
                              ? Colors.green.shade500
                              : const Color(0xFF52525b),
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'I have read, understood, and accept the disclaimer above and agree to the Terms of Service.',
                            style: TextStyle(
                              color: _isChecked
                                  ? Colors.white
                                  : const Color(0xFF9ca3af),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Accept Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isChecked ? _handleAccept : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isChecked
                            ? Colors.red.shade600
                            : const Color(0xFF27272a),
                        foregroundColor: _isChecked
                            ? Colors.white
                            : const Color(0xFF6b7280),
                        disabledBackgroundColor: const Color(0xFF27272a),
                        disabledForegroundColor: const Color(0xFF6b7280),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: _isChecked ? 8 : 0,
                        shadowColor: _isChecked
                            ? Colors.red.shade900.withOpacity(0.4)
                            : null,
                      ),
                      child: const Text(
                        'I Accept & Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Decline Button
                  TextButton(
                    onPressed: _handleDecline,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6b7280),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'DECLINE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color borderColor,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: borderColor, width: 2),
            ),
          ),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF6b7280),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildBulletPoint(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF6b7280),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: bold
                ? RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Color(0xFFd4d4d8),
                        fontSize: 13,
                      ),
                      children: _parseBoldText(text),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFFd4d4d8),
                      fontSize: 13,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningPoint(String text, {bool bold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.warning_amber,
          size: 20,
          color: Color(0xFFf97316),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: bold
              ? RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFFd4d4d8),
                      fontSize: 13,
                    ),
                    children: _parseBoldText(text),
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFFd4d4d8),
                    fontSize: 13,
                  ),
                ),
        ),
      ],
    );
  }

  List<TextSpan> _parseBoldText(String text) {
    final parts = text.split(RegExp(r'(\*\*.*?\*\*)'));
    return parts.map((part) {
      if (part.startsWith('**') && part.endsWith('**')) {
        return TextSpan(
          text: part.substring(2, part.length - 2),
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      }
      // Handle text like "NOT" or "NO LIABILITY" without ** markers
      if (part.contains('NOT') || part.contains('NO LIABILITY')) {
        return TextSpan(
          text: part,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      }
      return TextSpan(text: part);
    }).toList();
  }
}
