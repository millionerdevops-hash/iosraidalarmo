import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/notification_provider.dart';
import 'package:raidalarm/services/ad_service.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    // Defer loading until after build to check provider, or load immediately if we assume no premium initially.
    // Better: Check provider in build or didChangeDependencies.
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final hasLifetime = ref.read(notificationProvider).hasLifetime;
    if (!hasLifetime && _bannerAd == null) {
      _loadAd();
    }
  }

  void _loadAd() {
    _bannerAd = AdService().createBannerAd((ad) {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to provider
    final hasLifetime = ref.watch(notificationProvider).hasLifetime;

    if (hasLifetime) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
