import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adServiceProvider = Provider((ref) => AdService());

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // Real IDs (ACTIVE)
  final String _androidBannerId = 'ca-app-pub-7292000971794028/2219263675'; 
  final String _androidInterstitialId = 'ca-app-pub-7292000971794028/4350602993';
  final String _androidRewardedId = 'ca-app-pub-7292000971794028/6809670400'; // MatchPoint - Reward: 2500

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  /// Initialize the Google Mobile Ads SDK with UMP Consent Flow
  Future<void> initialize() async {
    final params = ConsentRequestParameters();

    // Request an update for the consent information.
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        // Check if a consent form is available and show it if required.
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          _loadAndShowConsentForm();
        } else {
          // No form required (e.g., Turkey/Global non-EEA users)
          await _initializeMobileAds();
        }
      },
      (FormError error) async {
        // Handle error in requesting consent info - proceed anyway
        debugPrint('ConsentInfoUpdate Error: ${error.message}');
        await _initializeMobileAds();
      },
    );
  }

  /// Helper to load and show the consent form
  void _loadAndShowConsentForm() {
    ConsentForm.loadAndShowConsentFormIfRequired((FormError? formError) async {
      if (formError != null) {
        debugPrint('ConsentForm Error: ${formError.message}');
      }
      // Always initialize AdMob after the form is dismissed or if it fails
      await _initializeMobileAds();
    });
  }

  /// Internal method to initialize Mobile Ads SDK
  Future<void> _initializeMobileAds() async {
    try {
      // Check if we can show ads according to consent status
      final status = await ConsentInformation.instance.getConsentStatus();
      debugPrint('Consent Status: $status');

      await MobileAds.instance.initialize();
      _loadInterstitialAd();
      _loadRewardedAd();
      debugPrint('Mobile Ads SDK Initialized.');
    } catch (e) {
      debugPrint('Mobile Ads Initialization Failed: $e');
    }
  }

  /// Get the appropriate Banner Ad Unit ID
  String get bannerAdUnitId {
    return _androidBannerId;
  }

  /// Load an Interstitial Ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _androidInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          debugPrint('Interstitial ad loaded.');
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  /// Show Interstitial Ad if ready
  void showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('Ad dismissed.');
          ad.dispose();
          _loadInterstitialAd(); // Load the next one
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          debugPrint('Failed to show full screen content: $err');
          ad.dispose();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
    } else {
      debugPrint('Interstitial ad not ready yet.');
    }
  }

  /// Create a Banner Ad widget
  BannerAd createBannerAd(Function(Ad) onAdLoaded) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }

  /// Load a Rewarded Ad
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _androidRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          debugPrint('Rewarded ad loaded.');
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load a rewarded ad: ${err.message}');
          _isRewardedAdReady = false;
        },
      ),
    );
  }

  /// Show Rewarded Ad if ready
  /// [onRewarded] callback is called when user earns the reward
  /// [onAdClosed] callback is called when ad is dismissed (whether rewarded or not)
  void showRewardedAd({
    required Function(int amount) onRewarded,
    Function()? onAdClosed,
  }) {
    if (_isRewardedAdReady && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('Rewarded ad dismissed.');
          ad.dispose();
          _loadRewardedAd(); // Load the next one
          onAdClosed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          debugPrint('Failed to show rewarded ad: $err');
          ad.dispose();
          _loadRewardedAd();
          onAdClosed?.call();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('User earned reward: ${reward.amount} ${reward.type}');
          onRewarded(reward.amount.toInt());
        },
      );

      _rewardedAd = null;
      _isRewardedAdReady = false;
    } else {
      debugPrint('Rewarded ad not ready yet.');
      onAdClosed?.call();
    }
  }

  /// Check if rewarded ad is ready
  bool get isRewardedAdReady => _isRewardedAdReady;
}

