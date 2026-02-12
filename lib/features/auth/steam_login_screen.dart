import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/fcm_service.dart';
import '../../core/services/database_service.dart';
import '../../data/models/fcm_credential.dart';
import '../../core/theme/rust_colors.dart';
import 'dart:async';

class SteamLoginScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  const SteamLoginScreen({super.key, this.onSuccess});

  @override
  State<SteamLoginScreen> createState() => _SteamLoginScreenState();
}

class _SteamLoginScreenState extends State<SteamLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasClickedButton = false; 
  final _dbService = DatabaseService(); 

  @override
  void initState() {
    super.initState();
    // Wake up backend to ensure smooth login
    FcmService.wakeUpBackend();
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36")
      ..setBackgroundColor(const Color(0xFF1B2838))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (progress > 30 && !_hasClickedButton) {
              _hasClickedButton = true;
              _controller.runJavaScript("""
                (function() {
                  const btn = document.querySelector('button.is-primary');
                  if (btn) btn.click();
                })();
              """);
            }
          },
          onPageStarted: (url) {
            if (!_isLoading) {
              setState(() => _isLoading = true);
            }
            if (url.contains('companion-rust.facepunch.com/login')) {
               _controller.runJavaScript("document.documentElement.style.display = 'none';");
            }
          },
          onPageFinished: (url) {
            if (url.contains('steamcommunity.com/openid/login') || !url.contains('facepunch.com')) {
              if (_isLoading) {
                setState(() => _isLoading = false);
              }
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'ReactNativeWebView',
        onMessageReceived: (JavaScriptMessage message) {
          _handleLoginSuccess(message.message);
        },
      )
      ..loadRequest(Uri.parse('https://companion-rust.facepunch.com/login'));
  }

  bool _isProcessingSuccess = false;

  void _handleLoginSuccess(String message) async {
    if (_isProcessingSuccess) return;
    _isProcessingSuccess = true;
    try {
      setState(() => _isLoading = true);
      
      final data = jsonDecode(message);
      final String token = data['Token'];
      final String steamId = data['SteamId'];
      
      final fcmService = FcmService();
      final isar = await _dbService.db;
      
      final cred = FcmCredential()
        ..steamId = steamId
        ..steamToken = token;

      // 1. Save Basic Credentials Locally
      await isar.writeTxn(() async {
          await isar.fcmCredentials.clear();
          await isar.fcmCredentials.put(cred);
      });

      // 2. Hand off full registration to Server
      await fcmService.syncWithServer(cred);
      
      if (mounted) {
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Steam login successful. Notifications are now managed by the server.")),
          );
          context.go('/');
        }
      }

    } catch (e) {
      _isProcessingSuccess = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Error: $e"), backgroundColor: RustColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171A21),
      body: SafeArea(
        child: Stack(
          children: [
              Visibility(
                visible: !_isLoading,
                maintainState: true,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: const Color(0xFF171A21),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline, size: 14, color: Colors.white54),
                          SizedBox(width: 8),
                          Text(
                            "Uses Official Rust+ Companion API",
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: WebViewWidget(controller: _controller)),
                  ],
                ),
              ),
            if (_isLoading)
              Container(
                color: RustColors.background,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: RustColors.primary),
                      SizedBox(height: 16),
                      Text(
                        "Redirecting to Steam...",
                        style: TextStyle(color: RustColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
