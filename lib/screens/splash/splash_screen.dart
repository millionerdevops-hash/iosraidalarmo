import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raidalarm/services/adapty_service.dart';
import 'package:raidalarm/data/database/app_database.dart';


const Duration _splashDelay = Duration(milliseconds: 2500);
const String _logoAssetPath = 'assets/logo/raidalarm-logo2.png';
const double _logoSize = 160.0;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startNavigation();
      }
    });
  }

  Future<bool> _restorePurchases() async {
    try {
      final profile = await AdaptyService.restorePurchases().timeout(
        const Duration(seconds: 15),
        onTimeout: () {

          throw Exception('Timeout');
        },
      );
      
      final isActive = profile.accessLevels['lifetime_access']?.isActive == true;
      if (isActive) {
        await AppDatabase().saveAppSetting('has_lifetime', 'true');
      }
      return isActive;
    } catch (e) {

      return false;
    }
  }

  Future<void> _startNavigation() async {
    final minSplashTimer = Future.delayed(_splashDelay);
    
    // Uygulama ayarlarını paralel oku
    final initialChecks = await Future.wait([
      AppDatabase().getBoolSetting('has_lifetime'),
    ]);



    // --- ABONELİK KONTROL ZİNCİRİ (KESİN ÇÖZÜM) ---
    
    // 1. Deneme: Profil kontrolü
    bool hasPremium = await AdaptyService.hasPremiumAccess().timeout(
      const Duration(seconds: 5),
      onTimeout: () => false,
    );

    // 2. Deneme: Eğer premium değilse ve daha önce lifetime olduğu biliniyorsa ya da re-install ise RESTORE dene
    if (!hasPremium) {

      hasPremium = await _restorePurchases();
    }

    // 3. Deneme: Hala premium değilse, kısa bir bekleme sonrası son kez profil tazele (Retry)
    if (!hasPremium) {

      await Future.delayed(const Duration(seconds: 2));
      hasPremium = await AdaptyService.hasPremiumAccess().timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
    }

    // 4. Fallback: Eğer internet yoksa ve local DB'de varsa güven
    if (!hasPremium) {
      hasPremium = initialChecks[0] as bool;
    }

    // En azından splash logosunun görünmesi için bekle
    await minSplashTimer;

    if (!mounted) return;

    // Premium ise her şeyi atla ve doğrudan Dashboard'a git
    if (hasPremium) {
      // Cache locally so other screens can unlock immediately even if Adapty check lags/offline later
      await AppDatabase().saveAppSetting('has_lifetime', 'true');

      if (mounted) context.go('/stats');
      return;
    }

    // Premium değilse doğrudan Server Info'ya git
    const String nextRoute = '/info';
    
    if (mounted) context.go(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          _logoAssetPath,
          width: _logoSize,
          height: _logoSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}