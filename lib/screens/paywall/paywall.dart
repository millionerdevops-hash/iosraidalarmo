import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';

import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/common/rust_button.dart';

import 'package:raidalarm/services/adapty_service.dart';
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/core/utils/throttler.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added riverpod
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'dart:async';
import 'package:raidalarm/data/database/app_database.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onTerms;
  final VoidCallback? onPurchaseComplete;
  final bool isOffer;

  const PaywallScreen({
    super.key,
    this.onSkip,
    this.onPrivacyPolicy,
    this.onTerms,
    this.onPurchaseComplete,
    this.isOffer = false,
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

    
    final cached = ref.read(adaptyServiceProvider).getCachedProducts;
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
    _hasConnection = await InternetConnectionChecker.instance.hasConnection;
    if (mounted) setState(() {});

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
      // Find a lifetime product first as preferred default, otherwise just the first one
      final lifetime = products.where((p) => !p.vendorProductId.toLowerCase().contains('monthly')).firstOrNull;
      if (lifetime != null) {
        _selectedProductId = lifetime.vendorProductId;
      } else {
        _selectedProductId = products.first.vendorProductId;
      }
    }
  }

  Future<void> _loadProducts() async {
    try {
      if (_products.isEmpty) {
        setState(() => _loading = true);
      }

        final placementId = widget.isOffer ? 'offer_paywall' : 'main_paywall';
        final products = await ref.read(adaptyServiceProvider).getProducts(placementId: placementId);
      
      if (mounted) {
        setState(() {
          _products = products;
          _loading = false;
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
      
      final profile = await ref.read(adaptyServiceProvider).restorePurchases().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('paywall.errors.restore_timeout'.tr());
        },
      );
      
      final hasPremium = profile.accessLevels.values.any((level) => level.isActive);
      
      if (hasPremium) {
        if (mounted) {
          await ref.read(notificationProvider.notifier).updateLifetimeStatus(true);
        }
        
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
      
      await ref.read(adaptyServiceProvider).purchaseProduct(product);
      


      final profile = await ref.read(adaptyServiceProvider).getProfile(forceRefresh: true);
      final hasPremium = profile.accessLevels.values.any((level) => level.isActive);
      
      if (hasPremium) {
        // If it was a lifetime product (not containing 'monthly'), save it specifically
        final isLifetimePurchase = !product.vendorProductId.toLowerCase().contains('monthly');
        if (isLifetimePurchase) {
          await AppDatabase().saveAppSetting('has_lifetime', 'true');
        }

        if (mounted) {
          await ref.read(notificationProvider.notifier).updateLifetimeStatus(true);
        }

        widget.onPurchaseComplete?.call();
      }
      
    } on AdaptyError catch (e) {
      if (e.code == AdaptyErrorCode.paymentCancelled) {


        if (mounted) setState(() => _purchasing = false);
        return;
      }
      
      final String errorMessage = _getAdaptyErrorMessage(e);



      _showError(errorMessage);
    } catch (e) {
      _showError('paywall.errors.generic_failed'.tr(args: [e.toString()]));
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  String _getAdaptyErrorMessage(AdaptyError e) {
    final errorMessage = e.message.toLowerCase();
    
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: RustColors.surface,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC2626)),
          ),
        ),
      );
    }


    if (_products.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0c0c0e),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'paywall.errors.unavailable'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              RustButton(
                 onPressed: widget.onSkip ?? () => context.go('/dashboard'),
                 child: Text('Close'),
              ),
            ],
          ),
        ),
      );
    }

    final selectedProduct = _products.firstWhere(
      (p) => p.vendorProductId == _selectedProductId,
      orElse: () => _products.first,
    );
    final isLifetimeSelected = !selectedProduct.vendorProductId.toLowerCase().contains('monthly');

    return PopScope(
      child: Scaffold(
        backgroundColor: const Color(0xFF0c0c0e),
        body: Stack(
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
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7), // Much darker at top
                          const Color(0xFF09090B).withValues(alpha: 0.8),
                          const Color(0xFF0c0c0e),
                        ],
                        stops: const [0.0, 0.4, 1.0], // Adjusted stops for better coverage
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            SafeArea(
              minimum: EdgeInsets.only(bottom: 24.h),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 0.10.sh),
                    // Header
                    // Header
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          children: [
                            if (widget.isOffer) ...[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                margin: EdgeInsets.only(bottom: 12.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDC2626),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'SPECIAL LOCK-IN OFFER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.w,
                                  ),
                                ),
                              ),
                            ],
                            Text(
                              widget.isOffer ? 'ACTIVATE YOUR 60% DISCOUNT' : 'paywall.title'.tr(),
                              textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: RustTypography.rustStyle(
                                    fontSize: 19.sp,
                                    color: Colors.white,
                                  ).copyWith(height: 1.1),
                                ),
                              ],
                            ),
                          ),
                        ),

                    // Comparison table
                    _buildComparisonTable(),
                    
                    ScreenUtilHelper.sizedBoxHeight(32),
                    
                    // Plan selection
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _products.length,
                      separatorBuilder: (context, index) => ScreenUtilHelper.sizedBoxHeight(8),
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        final isSelected = _selectedProductId == product.vendorProductId;
                        
                        // Determine if it's a lifetime or monthly for the label
                        // AdaptyPaywallProduct usually has subscriptionPeriod. In 3.x, use vendorProductId check.
                        final isLifetime = !product.vendorProductId.toLowerCase().contains('monthly');
                        
                        return _buildPlanCard(
                          product: product,
                          title: isLifetime ? 'paywall.plan_lifetime'.tr() : 'paywall.plan_monthly'.tr(),
                          subtitle: isLifetime 
                              ? 'paywall.plan_lifetime_subtitle'.tr() 
                              : 'paywall.plan_trial'.tr(),
                          subtitleColor: isLifetime ? null : const Color(0xFFFB923C),
                          badge: isLifetime ? 'paywall.plan_best_value'.tr() : null,
                          badgeColor: isLifetime ? const LinearGradient(
                            colors: [Color(0xFFDC2626), Color(0xFFEA580C)],
                          ) : null,
                          isSelected: isSelected,
                          onTap: () {
                            HapticHelper.lightImpact();
                            setState(() => _selectedProductId = product.vendorProductId);
                          },
                        );
                      },
                    ),
                    ScreenUtilHelper.sizedBoxHeight(24),
                    
                    // Purchase button
                    RustButton(
                      onPressed: (_purchasing || !_hasConnection) ? null : () {
                        HapticHelper.lightImpact();
                        _throttler.run(() {

                          _handlePurchase(selectedProduct);
                        });
                      },
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                    isLifetimeSelected 
                                        ? 'paywall.button_unlock'.tr()
                                        : 'paywall.button_trial'.tr(),
                                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    
                    ScreenUtilHelper.sizedBoxHeight(24),
                    
                    // Footer links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFooterLink('paywall.privacy'.tr(), widget.onPrivacyPolicy ?? () => context.push('/privacy-policy')),
                        ScreenUtilHelper.sizedBoxWidth(24),
                        _buildFooterLink('paywall.restore'.tr(), _purchasing ? null : () => _throttler.run(_handleRestore)),
                        ScreenUtilHelper.sizedBoxWidth(24),
                        _buildFooterLink('paywall.terms'.tr(), widget.onTerms ?? () => context.push('/terms-of-service')),
                      ],
                    ),
                    
                  ],
                ),
              ),
              Positioned(
                top: 16.h,
                right: 24.w,
                child: GestureDetector(
                  onTap: () {
                    HapticHelper.lightImpact();
                    _throttler.run(() => widget.onSkip?.call());
                  },
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF18181B),
                      border: Border.all(color: const Color(0xFF27272A)),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18.w,
                      color: const Color(0xFF71717A),
                    ),
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

  Widget _buildComparisonTable() {
    final features = [
      {'name': 'paywall.features.alarm'.tr(), 'free': false, 'premium': true},
      {'name': 'paywall.features.fake_call'.tr(), 'free': false, 'premium': true},
      {'name': 'paywall.features.tracker'.tr(), 'free': true, 'premium': true},
      {'name': 'paywall.features.wipe'.tr(), 'free': true, 'premium': true},
      {'name': 'paywall.features.tools'.tr(), 'free': true, 'premium': true},
    ];

    return Column(
      children: [
        // Table header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h), // Reduced vertical padding
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'paywall.table_features'.tr(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF52525B),
                      letterSpacing: 1.5.w,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 56.w,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'paywall.table_free'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF71717A),
                      letterSpacing: 0.5.w,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 56.w,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'paywall.table_pro'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Container(
          height: 1.h,
          color: const Color(0xFF27272A),
        ),
        
        // Table rows
        Column(
          children: features.map((feature) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h), // Reduced row vertical padding
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF18181B).withOpacity(0.5),
                    width: 1.h,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        feature['name'] as String,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFD4D4D8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 56.w,
                    child: Center(
                      child: feature['free'] as bool
                          ? Icon(LucideIcons.check, size: 14.w, color: const Color(0xFF71717A))
                          : Icon(LucideIcons.minus, size: 10.w, color: const Color(0xFF27272A)),
                    ),
                  ),
                  SizedBox(
                    width: 56.w,
                    child: Center(
                      child: feature['premium'] as bool
                          ? Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDC2626),
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7C2D12).withOpacity(0.5),
                                    blurRadius: 6.r,
                                  ),
                                ],
                              ),
                              child: Icon(LucideIcons.check, size: 10.w, color: Colors.white),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required AdaptyPaywallProduct product,
    required String title,
    required String subtitle,
    required bool isSelected, required VoidCallback onTap, Color? subtitleColor,
    String? badge,
    LinearGradient? badgeColor,
  }) {
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF7C2D12).withValues(alpha: 0.1)
                  : const Color(0xFF18181B),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? const Color(0xFFDC2626) : const Color(0xFF27272A),
                width: 2.w,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFDC2626).withValues(alpha: 0.15),
                        blurRadius: 24.r,
                        spreadRadius: -4.r,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Checkbox
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFDC2626) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFDC2626) : const Color(0xFF52525B),
                      width: 2.w,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: isSelected
                      ? Icon(LucideIcons.check, size: 14.w, color: Colors.white)
                      : null,
                ),
                
                ScreenUtilHelper.sizedBoxWidth(16),
                
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5.w,
                          ),
                        ),
                      ),
                      ScreenUtilHelper.sizedBoxHeight(4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: subtitleColor ?? const Color(0xFF71717A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                ScreenUtilHelper.sizedBoxWidth(12),
                
                // Price
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: product.price.localizedString ?? '${product.price}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Badge
        if (badge != null && badgeColor != null)
          Positioned(
          top: -10.h,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              gradient: badgeColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF71717A),
        ),
      ),
    );
  }
}
