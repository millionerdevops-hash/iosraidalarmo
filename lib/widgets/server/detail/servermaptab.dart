import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/core/utils/connectivity_helper.dart';

class ServerMapTab extends StatefulWidget {
  final ServerData server;

  const ServerMapTab({
    super.key,
    required this.server,
  });

  @override
  State<ServerMapTab> createState() => _ServerMapTabState();
}

class _ServerMapTabState extends State<ServerMapTab> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    if (widget.server.mapSize != null && widget.server.seed != null) {
      // Check connectivity
      final hasInternet = await ConnectivityHelper.hasInternet();
      if (!hasInternet) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
          ConnectivityHelper.showNoInternetSnackBar(context);
        }
        return;
      }

      final url = 'https://rustmaps.com/map/${widget.server.mapSize}_${widget.server.seed}';
      
      _controller
        // Performance: Enable JavaScript
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        
        // Performance: Set background color to avoid flash
        ..setBackgroundColor(const Color(0xFF121214))
        
        // Performance: Enable caching
        ..enableZoom(true)
        
        // Navigation delegate for security and performance
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
              }
            },
            onPageFinished: (String url) async {
              // Attempt to click fullscreen button to hide UI chrome
              try {
                await Future.delayed(const Duration(milliseconds: 500));
                await _controller.runJavaScript('''
                  const btn = document.querySelector('.fullscreen-button');
                  if (btn) btn.click();
                ''');
              } catch (_) {
                // Ignore JS errors
              }

              if (mounted) {
                setState(() => _isLoading = false);
              }
            },
            onWebResourceError: (WebResourceError error) {
              // Only block UI for main frame errors
              if (error.isForMainFrame ?? false) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _hasError = true;
                  });
                }
              } else {
                debugPrint('Non-fatal map resource error: ${error.description}');
              }
            },
            // Security: Only allow rustmaps.com
            onNavigationRequest: (NavigationRequest request) {
              if (!request.url.startsWith('https://rustmaps.com')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    }
  }

  Future<void> _openRustMaps() async {
    if (widget.server.mapSize != null && widget.server.seed != null) {
      if (!mounted) return;
      final url = Uri.parse('https://rustmaps.com/map/${widget.server.mapSize}_${widget.server.seed}');
      try {
        if (await canLaunchUrl(url)) {
          if (!mounted) return;
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMapData = widget.server.mapSize != null && widget.server.seed != null;

    if (!hasMapData) {
      return const _NoMapDataDisplay();
    }

    return Container(
      color: const Color(0xFF121214),
      child: Stack(
        children: [
          // WebView
          if (!_hasError)
            WebViewWidget(controller: _controller),

          // Error Display
          if (_hasError)
            _ErrorDisplay(
              onRetry: () async {
                final hasInternet = await ConnectivityHelper.hasInternet();
                if (!hasInternet) {
                  ConnectivityHelper.showNoInternetSnackBar(context);
                  return;
                }
                
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _controller.reload();
              },
            ),

          // Loading Indicator
          if (_isLoading && !_hasError)
            const _LoadingOverlay(),

          // Open in Browser Button
          Positioned(
            bottom: 24.h + MediaQuery.of(context).padding.bottom,
            right: 24.w,
            child: _OpenBrowserButton(onTap: _openRustMaps),
          ),
        ],
      ),
    );
  }
}

// Extracted no map data display
class _NoMapDataDisplay extends StatelessWidget {
  const _NoMapDataDisplay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121214),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.map,
              size: 48.w,
              color: const Color(0x3371717A),
            ),
            ScreenUtilHelper.sizedBoxHeight(8.0),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('server.map.info_unavailable'),
                style: TextStyle(
                  color: const Color(0xFF71717A),
                  fontSize: 12.sp,
                  fontFamily: 'Geist',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted error display
class _ErrorDisplay extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorDisplay({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121214),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.triangleAlert,
              size: 48.w,
              color: const Color(0xFFEF4444),
            ),
            ScreenUtilHelper.sizedBoxHeight(12.0),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('server.map.failed_load'),
                style: TextStyle(
                  color: const Color(0xFFEF4444),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Geist',
                ),
              ),
            ),
            ScreenUtilHelper.sizedBoxHeight(4.0),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('server.map.check_connection'),
                style: TextStyle(
                  color: const Color(0xFF71717A),
                  fontSize: 12.sp,
                  fontFamily: 'Geist',
                ),
              ),
            ),
            ScreenUtilHelper.sizedBoxHeight(16.0),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticHelper.mediumImpact();
                  onRetry();
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF27272A)),
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xFF18181B),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.refreshCcw,
                        size: 14.w,
                        color: Colors.white,
                      ),
                      ScreenUtilHelper.sizedBoxWidth(8.0),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tr('server.map.retry'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Geist',
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
    );
  }
}

// Extracted loading overlay
class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121214),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: CircularProgressIndicator(
                color: const Color(0xFFF97316),
                strokeWidth: 3.w,
              ),
            ),
            ScreenUtilHelper.sizedBoxHeight(16.0),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tr('server.map.loading'),
                style: TextStyle(
                  color: const Color(0xFF71717A),
                  fontSize: 12.sp,
                  fontFamily: 'Geist',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted open browser button with optimizations
class _OpenBrowserButton extends StatelessWidget {
  final VoidCallback onTap;

  const _OpenBrowserButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticHelper.mediumImpact();
                onTap();
              },
              borderRadius: BorderRadius.circular(999.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.externalLink,
                      size: 12.w,
                      color: Colors.white,
                    ),
                    ScreenUtilHelper.sizedBoxWidth(8.0),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        tr('server.map.open_browser'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Geist',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
