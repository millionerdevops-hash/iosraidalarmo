import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/fcm_service.dart';
import '../../core/services/database_service.dart';
import '../../data/models/fcm_credential.dart';
import '../../config/rust_colors.dart';

class SteamLoginScreen extends StatefulWidget {
  const SteamLoginScreen({super.key});

  @override
  State<SteamLoginScreen> createState() => _SteamLoginScreenState();
}

class _SteamLoginScreenState extends State<SteamLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36")
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            // As soon as progress is above 30-40%, try to click the button.
            // We don't need to wait for the whole page (images/etc) to finish.
            if (progress > 30) {
              _controller.runJavaScript("""
                (function() {
                  const btn = document.querySelector('button.is-primary');
                  if (btn && !window._clicked) {
                    window._clicked = true;
                    btn.click();
                  }
                })();
              """);
            }
          },
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            debugPrint("[Auth] Loading: $url");
            
            // Inject CSS to hide the Facepunch page content immediately
            // This prevents "flashes" and makes it feel faster.
            if (url.contains('companion-rust.facepunch.com/login')) {
               _controller.runJavaScript("document.documentElement.style.display = 'none';");
            }
          },
          onPageFinished: (url) {
            if (url.contains('steamcommunity.com/openid/login')) {
              debugPrint("[Auth] On Steam Login page. Revealing WebView.");
              setState(() => _isLoading = false);
            } else if (!url.contains('facepunch.com')) {
              // Any other non-facepunch page, reveal it
              setState(() => _isLoading = false);
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

  void _handleLoginSuccess(String message) async {
    try {
      setState(() => _isLoading = true);
      
      final data = jsonDecode(message);
      final String token = data['Token'];
      final String steamId = data['SteamId'];
      
      debugPrint("[Auth] Login Successful. SteamID: $steamId");
      
      // Perform Registration
      final fcmService = FcmService();
      
      // Check if we already have valid credentials
      debugPrint("[Auth] Checking for existing FCM credentials...");
      final existingCred = await fcmService.getExistingCredentials();
      
      String fcmToken;
      String expoToken;
      
      if (existingCred != null && existingCred.fcmToken != null && existingCred.expoPushToken != null) {
        // Reuse existing credentials
        debugPrint("[Auth] ✅ Reusing existing credentials");
        fcmToken = existingCred.fcmToken!;
        expoToken = existingCred.expoPushToken!;
      } else {
        // Generate new credentials
        debugPrint("[Auth] ⚠️ Generating NEW credentials (first time)");
        
        // 1. Get FCM Token
        fcmToken = await fcmService.getFcmToken() ?? '';
        if (fcmToken.isEmpty) {
          throw "Failed to get FCM Token. Is Firebase configured?";
        }
        debugPrint("[Auth] Got FCM Token: $fcmToken");
        
        // 2. Get Expo Push Token
        expoToken = await fcmService.getExpoPushToken(fcmToken) ?? '';
        if (expoToken.isEmpty) {
          throw "Failed to get Expo Token.";
        }
        debugPrint("[Auth] Got Expo Token: $expoToken");
      }
      
      // 3. Register with Rust+ (always register with latest Steam token)
      debugPrint("[Auth] Registering with Rust+ API...");
      bool registered = await fcmService.registerWithRustPlus(token, expoToken);
      
      if (registered) {
        debugPrint("[Auth] ✅ Successfully registered with Rust Companion API!");
        if (mounted) {
          // Save Credentials to Isar
          final dbService = DatabaseService();
          final isar = await dbService.db;
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

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pairing Registered! Go in-game and pair server now.")),
          );
          context.go('/');
        }
      } else {
         throw "Failed to register with Rust Companion API.";
      }

    } catch (e) {
      debugPrint("[Auth] Error during pairing: $e");
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
      backgroundColor: RustColors.background, // Match Steam/Rust dark theme
      appBar: AppBar(
        title: const Text("Steam Login"),
        elevation: 0,
        backgroundColor: RustColors.surface,
      ),
      body: Stack(
        children: [
          // The WebView remains in the background while loading the splash
          Opacity(
            opacity: _isLoading ? 0.0 : 1.0,
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
    );
  }
}
