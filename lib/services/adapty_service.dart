import 'dart:async';
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:raidalarm/services/onesignal_service.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adaptyServiceProvider = Provider((ref) => AdaptyService());
final premiumStatusProvider = StreamProvider<bool>((ref) => AdaptyService.premiumStatusStream);

class AdaptyService {
  static bool _initialized = false;
  static List<AdaptyPaywallProduct>? _cachedProducts;
  static AdaptyProfile? _cachedProfile;

  // Premium status stream for real-time updates
  static final _premiumStatusController = StreamController<bool>.broadcast();
  static Stream<bool> get premiumStatusStream => _premiumStatusController.stream;

  /// Initialize Adapty SDK
  static Future<void> init() async {
    if (_initialized) return;

    try {
      await Adapty().activate(
        configuration: AdaptyConfiguration(apiKey: dotenv.env['ADAPTY_PUBLIC_SDK_KEY']!)
          ..withLogLevel(AdaptyLogLevel.verbose)
          ..withObserverMode(false),
      );
      
      // Listen for profile updates (purchases, restores, etc.)
      Adapty().didUpdateProfileStream.listen((profile) {
        _updateProfileCache(profile);
      });

      _initialized = true;

      // Prefetch data in parallel
      await Future.wait([
        prefetchProducts(),
        getProfile(), // Updates cache and stream
      ]);
      
    } catch (e) {
      // Handle initialization error silently
    }
  }

  /// Update local cache and notify listeners
  static void _updateProfileCache(AdaptyProfile profile) {
    _cachedProfile = profile;
    final isPremium = profile.accessLevels['lifetime_access']?.isActive ?? false;
    _premiumStatusController.add(isPremium);
    
    // OneSignal'ı otomatik senkronize et
    if (isPremium) {
      OneSignalService.markAsPremium();
    }
  }

  /// Prefetch products to cache for instant display
  static Future<void> prefetchProducts({String placementId = 'main_paywall'}) async {
    try {
      final products = await getProducts(placementId: placementId);
      _cachedProducts = products;
    } catch (e) {
      // Silently fail prefetch
    }
  }

  /// Get cached products if available
  static List<AdaptyPaywallProduct>? get getCachedProducts => _cachedProducts;

  /// Get paywall with products
  static Future<AdaptyPaywall> getPaywall({String placementId = 'main_paywall'}) async {
    return await Adapty().getPaywall(placementId: placementId);
  }

  /// Get products from paywall
  static Future<List<AdaptyPaywallProduct>> getProducts({String placementId = 'main_paywall'}) async {
    final paywall = await getPaywall(placementId: placementId);
    return await Adapty().getPaywallProducts(paywall: paywall);
  }

  /// Purchase a product
  static Future<AdaptyProfile> purchaseProduct(AdaptyPaywallProduct product) async {
    await Adapty().makePurchase(product: product);
    return await getProfile(forceRefresh: true);
  }

  /// Get current user profile (with caching strategy)
  static Future<AdaptyProfile> getProfile({bool forceRefresh = false}) async {
    // Return cache if valid and not forced
    if (!forceRefresh && _cachedProfile != null) {
      return _cachedProfile!;
    }

    try {
      final profile = await Adapty().getProfile();
      _updateProfileCache(profile);
      return profile;
    } catch (e) {
      // Return stale cache on error if available
      if (_cachedProfile != null) return _cachedProfile!;
      rethrow;
    }
  }

  /// Restore purchases
  static Future<AdaptyProfile> restorePurchases() async {
    final profile = await Adapty().restorePurchases();
    _updateProfileCache(profile);
    return profile;
  }

  /// Check if user has premium access (Optimized)
  /// Returns cached value immediately if available.
  static Future<bool> hasPremiumAccess() async {
    // 1. Fast path: Memory cache
    if (_cachedProfile != null) {
      return _cachedProfile!.accessLevels['lifetime_access']?.isActive ?? false;
    }

    // 2. Slow path: Network fetch
    try {
      final profile = await getProfile();
      return profile.accessLevels['lifetime_access']?.isActive ?? false;
    } catch (e) {
      // 3. Fallback: Local DB cache (supports offline / slow Adapty scenarios)
      try {
        return await AppDatabase().getBoolSetting('has_lifetime');
      } catch (_) {
        return false;
      }
    }
  }
  
  /// Get current cached status sync
  static bool get isPremiumCached {
    return _cachedProfile?.accessLevels['lifetime_access']?.isActive ?? false;
  }
}
