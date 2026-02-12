import 'dart:async';
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/services/onesignal_service.dart';

class AdaptyService {
  bool _initialized = false;
  List<AdaptyPaywallProduct>? _cachedProducts;
  AdaptyProfile? _cachedProfile;

  // Premium status stream for real-time updates
  final _premiumStatusController = StreamController<bool>.broadcast();
  Stream<bool> get premiumStatusStream => _premiumStatusController.stream;

  /// Initialize Adapty SDK
  Future<void> init() async {
    if (_initialized) return;

    try {
      final apiKey = dotenv.env['ADAPTY_PUBLIC_SDK_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint("[Adapty] ❌ API Key is missing! Skipping activation.");
        return;
      }
      
      await Adapty().activate(
        configuration: AdaptyConfiguration(apiKey: apiKey)
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
      debugPrint('Adapty init error: $e');
      // Handle initialization error silently
    }
  }

  void _updateProfileCache(AdaptyProfile profile) {
    _cachedProfile = profile;
    // Check ANY active access level (lifetime, monthly, etc.)
    final isPremium = profile.accessLevels.values.any((level) => level.isActive);
    _premiumStatusController.add(isPremium);

    // Sync OneSignal
    if (isPremium) {
      OneSignalService.markAsPremium();
    }
  }

  /// Prefetch products to cache for instant display
  Future<void> prefetchProducts({String placementId = 'main_paywall'}) async {
    try {
      final products = await getProducts(placementId: placementId);
      _cachedProducts = products;
    } catch (e) {
      debugPrint('Adapty prefetch error ($placementId): $e');
      // Silently fail prefetch
    }
  }

  /// Get cached products if available
  List<AdaptyPaywallProduct>? get getCachedProducts => _cachedProducts;

  /// Get paywall with products
  Future<AdaptyPaywall> getPaywall({String placementId = 'main_paywall'}) async {
    return await Adapty().getPaywall(placementId: placementId);
  }

  /// Get products from paywall
  Future<List<AdaptyPaywallProduct>> getProducts({String placementId = 'main_paywall'}) async {
    final paywall = await getPaywall(placementId: placementId);
    return await Adapty().getPaywallProducts(paywall: paywall);
  }

  /// Purchase a product
  Future<AdaptyProfile> purchaseProduct(AdaptyPaywallProduct product) async {
    await Adapty().makePurchase(product: product);
    return await getProfile(forceRefresh: true);
  }

  /// Get current user profile (with caching strategy)
  Future<AdaptyProfile> getProfile({bool forceRefresh = false}) async {
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
  Future<AdaptyProfile> restorePurchases() async {
    final profile = await Adapty().restorePurchases();
    _updateProfileCache(profile);
    return profile;
  }

  /// Check if user has premium access (Optimized)
  /// Returns check for ANY active access level.
  Future<bool> hasPremiumAccess() async {
    // 1. Fast path: Memory cache
    if (_cachedProfile != null) {
      return _cachedProfile!.accessLevels.values.any((level) => level.isActive);
    }

    // 2. Slow path: Network fetch
    try {
      final profile = await getProfile();
      return profile.accessLevels.values.any((level) => level.isActive);
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
  bool get isPremiumCached {
    return _cachedProfile?.accessLevels.values.any((level) => level.isActive) ?? false;
  }
  
  /// Get cached profile
  AdaptyProfile? get cachedProfile => _cachedProfile;
}

final adaptyServiceProvider = Provider<AdaptyService>((ref) {
  return AdaptyService();
});

final premiumStatusProvider = StreamProvider<bool>((ref) {
  return ref.watch(adaptyServiceProvider).premiumStatusStream;
});
