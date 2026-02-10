import 'dart:ui' as ui;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
// import 'package:raidalarm/core/theme/rust_effects.dart';
import 'package:raidalarm/widgets/common/rust_button.dart';
import 'package:raidalarm/services/adapty_service.dart';
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/screens/legal/privacy_policy_screen.dart';
import 'package:raidalarm/screens/legal/terms_of_service_screen.dart';
import 'package:raidalarm/services/onesignal_service.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/throttler.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'dart:async';

class PaywallScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onTerms;
  final VoidCallback? onPurchaseComplete;

  const PaywallScreen({
    super.key,
    this.onSkip,
    this.onPrivacyPolicy,
    this.onTerms,
    this.onPurchaseComplete,
  });

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  final Throttler _throttler = Throttler(delay: const Duration(milliseconds: 1000));
  List<AdaptyPaywallProduct> _products = [];
  bool _loading = true;
  String? _selectedProductId;
  bool _purchasing = false;
  bool _hasConnection = true;
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    // OneSignal paywall tag is now set on close to trigger Drop-Off segment
    
    // Attempt to use cached products first for instant UI
    final cached = AdaptyService.getCachedProducts;
    if (cached != null && cached.isNotEmpty) {
      _products = cached;
      _loading = false;
      _setInitialSelection(cached);
    }
    
    
    _loadProducts();
    _initConnectivity();
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    // Initial check
    _hasConnection = await InternetConnectionChecker.instance.hasConnection;
    if (mounted) setState(() {});

    // Listen for changes
    _connectionSubscription = InternetConnectionChecker.instance.onStatusChange.listen((status) {
      if (mounted) {
        setState(() {
          _hasConnection = status == InternetConnectionStatus.connected;
        });
      }
    });
  }

  void _setInitialSelection(List<AdaptyPaywallProduct> products) {
    if (products.isNotEmpty) {
      _selectedProductId = products[0].vendorProductId;
    }
  }

  Future<void> _loadProducts() async {
    try {
      // If we don't have products yet, show loading
      if (_products.isEmpty) {
        setState(() => _loading = true);
      }

      final products = await AdaptyService.getProducts(placementId: 'main_paywall');
      
      if (mounted) {
        setState(() {
          _products = products;
          _loading = false;
          // Only set selection if not already set (don't overwrite user selection if they somehow selected it during background load)
          if (_selectedProductId == null) {
            _setInitialSelection(products);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        if (_products.isEmpty) {
          _showError('Failed to load products: $e');
        }
      }
    }
  }

  Future<void> _handleRestore() async {
    if (!_hasConnection) {
      _showError('paywall.errors.restore_no_internet'.tr());
      return;
    }

    try {
      setState(() => _purchasing = true);
      
      // Add timeout similar to splash screen
      final profile = await AdaptyService.restorePurchases().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('paywall.errors.restore_timeout'.tr());
        },
      );
      
      // Check if user has lifetime access
      final hasLifetime = profile.accessLevels['lifetime_access']?.isActive ?? false;
      
      if (hasLifetime) {
      // Save local
      await AppDatabase().saveAppSetting('has_lifetime', 'true');
      
      if (mounted) {
        ref.read(notificationProvider).updateLifetimeStatus(true);
      }
      
      // Navigate immediately
      widget.onPurchaseComplete?.call();
      } else {
        _showError('paywall.errors.no_lifetime_found'.tr());
      }
    } on AdaptyError catch (e) {
      _showError('paywall.errors.restore_failed'.tr(args: [e.message]));
    } on TimeoutException catch (e) {
      _showError(e.message ?? 'paywall.errors.restore_timeout'.tr());
    } catch (e) {
      _showError('paywall.errors.restore_failed'.tr(args: [e.toString()]));
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _handlePurchase(AdaptyPaywallProduct product) async {
    if (!_hasConnection) {
      _showError('paywall.errors.restore_no_internet'.tr());
      return;
    }
    
    try {
      setState(() => _purchasing = true);
      
      // Make purchase - this will throw AdaptyError if cancelled or failed
      await AdaptyService.purchaseProduct(product);
      
      // CRITICAL: Verify purchase using hasPremiumAccess as single source of truth
      // This method handles cache, network, and fallback logic properly
      final hasLifetime = await AdaptyService.hasPremiumAccess();
      
      if (hasLifetime) {
        // Payment was successful and verified - grant access
        OneSignalService.markAsPremium();
        
        // Save local - payment verified, user gets access
        await AppDatabase().saveAppSetting('has_lifetime', 'true');

        if (mounted) {
          ref.read(notificationProvider).updateLifetimeStatus(true);
        }

        // Navigate immediately
        widget.onPurchaseComplete?.call();
      } else {
        // Purchase completed but verification failed
        // This could happen if Adapty backend hasn't synced yet
        _showError('paywall.errors.purchase_verification_failed'.tr());
      }
      
    } on AdaptyError catch (e) {
      // Handle specific Adapty error codes
      if (e.code == AdaptyErrorCode.paymentCancelled) {
        // User cancelled - do NOT grant access, just close loading state
        if (mounted) setState(() => _purchasing = false);
        return;
      }
      
      String errorMessage = _getAdaptyErrorMessage(e);
      _showError(errorMessage);
    } catch (e) {
      _showError('paywall.errors.generic_failed'.tr(args: [e.toString()]));
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }


  /// This doesn't block the UI - user can continue using the app


  String _getAdaptyErrorMessage(AdaptyError e) {
    // Adapty Flutter SDK error message'ı kullanıcı dostu mesaja çevir
    final errorMessage = e.message.toLowerCase();
    
    // Error message içeriğine göre özel mesajlar
    if (errorMessage.contains('network') || errorMessage.contains('connection')) {
      return 'paywall.errors.network'.tr();
    }
    
    if (errorMessage.contains('pending')) {
      return 'paywall.errors.pending'.tr();
    }
    
    if (errorMessage.contains('invalid') || errorMessage.contains('failed')) {
      return 'paywall.errors.invalid'.tr();
    }
    
    if (errorMessage.contains('not available') || errorMessage.contains('unavailable')) {
      return 'paywall.errors.unavailable'.tr();
    }
    
    if (errorMessage.contains('store') || errorMessage.contains('billing')) {
      return 'paywall.errors.store'.tr();
    }
    
    if (errorMessage.contains('already purchased') || errorMessage.contains('already active')) {
      return 'paywall.errors.already_purchased'.tr();
    }
    
    // Adapty'nin kendi mesajını göster, yoksa generic mesaj
    return e.message.isNotEmpty ? 'paywall.errors.generic_failed'.tr(args: [e.message]) : 'paywall.errors.purchase_failed_default'.tr();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: RustColors.surface,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC2626)),
          ),
        ),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          // No-op: If system back was pressed, we just let it pop.
          // onSkip should not be triggered here as it might cause double navigation/pop.
        }
      },
      child: Scaffold(
        backgroundColor: RustColors.surface,
        body: RustScreenLayout(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image with Gradient Fade
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 0.55.sh, // responsive height
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.matrix(<double>[
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0,      0,      0,      1, 0,
                        ]),
                        child: Image.asset(
                          'assets/getstarted.jpg',
                          fit: BoxFit.cover,
                          cacheWidth: 1080,
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black26,
                            Color(0x99090B0B),
                            RustColors.surface,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content Layer (SafeArea + Column)
              SafeArea(
                bottom: false, // Handle bottom padding manually for full control
                child: Column(
                  children: [
                    // Header (Close Button)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                HapticHelper.mediumImpact();
                                OneSignalService.paywallClosed();
                                _throttler.run(() => widget.onSkip?.call());
                              },
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                width: 32.w,
                                height: 32.w, // Ensure circular aspect ratio
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.4),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                child: ClipOval(
                                  child: BackdropFilter(
                                    filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                    child: Icon(
                                      Icons.close,
                                      size: 16.w,
                                      color: const Color(0xFFD4D4D8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Spacer to push Title down initially (simulating top padding)
                    ScreenUtilHelper.sizedBoxHeight(64), 

                    // Flexible Content Area
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Title Area
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: RustTypography.rustStyle(
                                          fontSize: 40.sp, 
                                          color: Colors.white,
                                          weight: FontWeight.w900,
                                        ).copyWith(
                                          height: 1.1,
                                          shadows: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.5),
                                              blurRadius: 20.r,
                                              offset: Offset(0, 10.h),
                                            )
                                          ],
                                        ),
                                        children: [
                                          TextSpan(text: 'paywall.title_line1'.tr() + '\n'),
                                          TextSpan(
                                            text: 'paywall.title_line2'.tr(),
                                            style: TextStyle(color: const Color(0xFFDC2626)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ScreenUtilHelper.sizedBoxHeight(12),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'paywall.subtitle'.tr(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0xFFD4D4D8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  ScreenUtilHelper.sizedBoxHeight(4),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'paywall.no_subscriptions'.tr(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF71717A),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const Spacer(flex: 3),

                            // 2. Product/Plan Card
                            if (_products.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticHelper.mediumImpact();
                                    setState(() => _selectedProductId = _products.first.vendorProductId);
                                  },
                                  child: PlanCard(
                                    name: 'paywall.plan_card.name'.tr(),
                                    price: _products.first.price.localizedString ?? '${_products.first.price}',
                                    popular: true, 
                                    selected: true,
                                  ),
                                ),
                              ),

                            const Spacer(flex: 4),

                            // 3. Footer Area
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: SafeArea( // Bottom safe area
                                top: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 20.r,
                                            offset: Offset(0, 10.h),
                                          ),
                                        ],
                                      ),
                                      child: RustButton(
                                          onPressed: (_purchasing || !_hasConnection) ? null : () {
                                            HapticHelper.mediumImpact();
                                            _throttler.run(() {
                                              if (_products.isNotEmpty) {
                                                  final selectedProduct = _products.first;
                                                  _handlePurchase(selectedProduct);
                                              }
                                            });
                                          },
                                        variant: RustButtonVariant.primary, // Check if this needs .w/.h inside
                                        child: _purchasing
                                            ? SizedBox(
                                                height: 20.w,
                                                width: 20.w,
                                                child: const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              )
                                            : FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'paywall.secure_access'.tr(),
                                                  style: TextStyle(fontSize: 13.sp),
                                                ),
                                              ),
                                      ),
                                    ),
                                    
                                    ScreenUtilHelper.sizedBoxHeight(16),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: _buildFooterLink(
                                            'paywall.privacy'.tr(),
                                            widget.onPrivacyPolicy ?? () => Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                                            ),
                                          ),
                                        ),
                                        ScreenUtilHelper.sizedBoxWidth(5),
                                        Container(
                                          width: 4.w,
                                          height: 4.w,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF27272A),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        ScreenUtilHelper.sizedBoxWidth(5),
                                        Flexible(
                                          child: _buildFooterLink(
                                            'paywall.terms'.tr(),
                                            widget.onTerms ?? () => Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
                                            ),
                                          ),
                                        ),
                                        ScreenUtilHelper.sizedBoxWidth(5),
                                        Container(
                                          width: 4.w,
                                          height: 4.w,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF27272A),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        ScreenUtilHelper.sizedBoxWidth(5),
                                        Flexible(
                                          child: _buildFooterLink(
                                            'paywall.restore'.tr(),
                                            _purchasing ? null : () => _throttler.run(_handleRestore),
                                          ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 10.sp, // Responsive font size
            fontWeight: FontWeight.bold,
            color: const Color(0xFF71717A),
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final bool popular;
  final bool selected;

  const PlanCard({
    super.key,
    required this.name,
    required this.price,
    this.popular = false,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Defines the precise "Benefits" list for the UI
    final benefits = [
      {'icon': LucideIcons.shieldCheck, 'text': "paywall.benefits.critical_alarms".tr()},
      {'icon': LucideIcons.smartphone, 'text': "paywall.benefits.fake_call".tr()},
      {'icon': LucideIcons.crosshair, 'text': "paywall.benefits.enemy_notifications".tr()},
      {'icon': LucideIcons.timer, 'text': "paywall.benefits.wipe_notifications".tr()},
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(32.r),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF09090B).withOpacity(0.85), // Very dark background
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: const Color(0xFFDC2626).withOpacity(0.5), // Red border
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 40.r,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
               // Glow Effect removed as requested
               
               // 2. Subtle Red Gradient Overlay from top
               Positioned.fill(
                 child: Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(32.r),
                     gradient: LinearGradient(
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                       colors: [
                         const Color(0xFFDC2626).withOpacity(0.1),
                         Colors.transparent,
                         Colors.transparent,
                       ],
                     ),
                   ),
                 ),
               ),

              // 3. Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content height
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Price Header
                    Column(
                      children: [
                        ScreenUtilHelper.sizedBoxHeight(8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            price,
                            style: TextStyle(
                                fontFamily: RustTypography.fontFamily,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -1.w,
                                height: 1.0,
                            ),
                          ),
                        ),
                        ScreenUtilHelper.sizedBoxHeight(8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'paywall.plan_card.one_time'.tr(),
                            style: TextStyle(
                              fontFamily: 'GeistMono', // Monospace for technical look
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF71717A), // zinc-500
                              letterSpacing: 4.w, // Wide tracking
                            ),
                          ),
                        ),
                      ],
                    ),

                    ScreenUtilHelper.sizedBoxHeight(12),
                    
                    // Divider
                    Container(
                      height: 1.h, 
                      color: const Color(0xFF27272A), // Subtle separator
                    ),
                    
                    ScreenUtilHelper.sizedBoxHeight(12),

                    // Benefits List
                    ...benefits.map((b) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon Box
                          Container(
                            width: 32.w,
                            height: 32.w,
                            padding: EdgeInsets.all(7.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF27272A).withOpacity(0.5), // zinc-800/50
                              borderRadius: BorderRadius.circular(10.r), // squircle
                              border: Border.all(
                                color: const Color(0xFF3F3F46), // zinc-700
                                width: 1.w,
                              ),
                            ),
                            child: FittedBox(
                              child: Icon(
                                b['icon'] as IconData,
                                color: const Color(0xFFD4D4D8), // lighter icon
                              ),
                            ),
                          ),
                          ScreenUtilHelper.sizedBoxWidth(12),
                          // Text
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                b['text'] as String,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFFE4E4E7), // zinc-200
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
