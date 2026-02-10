import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/fcm_service.dart';
import '../../core/services/database_service.dart';
import '../../data/models/fcm_credential.dart';
import '../../core/theme/rust_colors.dart';

class SteamLoginScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  const SteamLoginScreen({super.key, this.onSuccess});

  @override
  State<SteamLoginScreen> createState() => _SteamLoginScreenState();
}

class _SteamLoginScreenState extends State<SteamLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasClickedButton = false; // Track button click to avoid repeated JS execution
  final _dbService = DatabaseService(); // Reuse instance

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36")
      ..setBackgroundColor(const Color(0xFF1B2838)) // Steam dark color for seamless loading
      ..enableZoom(false) // Disable zoom for better UX
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            // Only execute once when progress reaches threshold
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
            // Only update state if needed to avoid unnecessary rebuilds
            if (!_isLoading) {
              setState(() => _isLoading = true);
            }
            
            // Inject CSS to hide the Facepunch page content immediately
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
      
      // Perform Registration
      final fcmService = FcmService();
      
      // Check if we already have valid credentials
      final existingCred = await fcmService.getExistingCredentials();
      
      String fcmToken;
      String expoToken;
      
      if (existingCred != null && existingCred.fcmToken != null && existingCred.expoPushToken != null) {
        // Reuse existing credentials
        fcmToken = existingCred.fcmToken!;
        expoToken = existingCred.expoPushToken!;
      } else {
        // Generate new credentials
        
        // 1. Get FCM Token
        fcmToken = await fcmService.getFcmToken() ?? '';
        if (fcmToken.isEmpty) {
          throw "Connection Error";
        }
        
        // 2. Get Expo Push Token
        expoToken = await fcmService.getExpoPushToken(fcmToken) ?? '';
        if (expoToken.isEmpty) {
          throw "Connection Error";
        }
      }
      
      // 3. Register with API (always register with latest Steam token)
      bool registered = await fcmService.registerWithRustPlus(token, expoToken);
      
      if (registered) {
        if (mounted) {
          // Save Credentials to Isar (using reused instance)
          final isar = await _dbService.db;
          await isar.writeTxn(() async {
             // Clear old
             await isar.fcmCredentials.clear();
             
             final cred = FcmCredential()
               ..fcmToken = fcmToken
               ..expoPushToken = expoToken
               ..steamId = steamId
               ..steamToken = token;
             
             await isar.fcmCredentials.put(cred);
          });

          if (widget.onSuccess != null) {
            widget.onSuccess!();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Steam login successful. Go in-game and pair server now.")),
            );
            context.go('/');
          }
        }
      } else {
         throw "Connection Error";
      }


    } catch (e) {
      _isProcessingSuccess = false; // Allow retry
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
      backgroundColor: const Color(0xFF171A21), // Official Steam Header Color
      body: SafeArea(
        child: Stack(
          children: [
            // The WebView - use Visibility instead of Opacity for better performance
            Visibility(
              visible: !_isLoading,
              maintainState: true, // Keep WebView alive even when hidden
              child: WebViewWidget(controller: _controller),
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
