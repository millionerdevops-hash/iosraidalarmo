import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raidalarm/app.dart';
import 'package:raidalarm/core/theme/rust_colors.dart'; // Fixed path
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/services/onesignal_service.dart';
import 'package:raidalarm/services/adapty_service.dart';
import 'package:raidalarm/services/local_notification_service.dart';
import 'package:raidalarm/services/ad_service.dart';
import 'package:raidalarm/core/services/notification_handler.dart';
import 'package:raidalarm/core/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _translationsPath = 'assets/translations';
const Locale _fallbackLocale = Locale('en');

const List<Locale> _supportedLocales = [
  Locale('en'),
  Locale('tr'),
  Locale('ru'),
  Locale('uk'),
  Locale('de'),
  Locale('fr'),
  Locale('es'),
  Locale('it'),
  Locale('fi'),
  Locale('sv'),
  Locale('pl'),
  Locale('nl'),
  Locale('pt'),
  Locale('ja'),
  Locale('ko'),
  Locale('da'),
  Locale('el'),
  Locale('hu'),
  Locale('id'),
  Locale('zh', 'CN'),
  Locale('zh', 'HK'),
  Locale('zh', 'TW'),
  Locale('th'),
  Locale('vi'),
  Locale('ar'),
];

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with FACEPUNCH credentials (to receive Rust+ pairing notifications)
  // This is critical - we MUST use Facepunch's Firebase project to receive notifications
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyB5y2y-Tzqb4-I4Qnlsh_9naYv_TD8pCvY',
        appId: '1:976529667804:android:d6f1ddeb4403b338fea619',
        messagingSenderId: '976529667804',
        projectId: 'rust-companion-app',
      ),
    );
    debugPrint("[Main] ✅ Firebase initialized successfully");
  } catch (e) {
    // If app already exists (hot reload), that's OK - continue
    if (e.toString().contains('duplicate-app')) {
      debugPrint("[Main] ℹ️ Firebase app already exists (hot reload) - continuing...");
    } else {
      debugPrint("[Main] ❌ Firebase Init Error: $e");
      rethrow;
    }
  }
  
  // ALWAYS initialize notification handler, even if Firebase was already initialized
  try {
    await NotificationHandler.initialize();
  } catch (e) {
    debugPrint("[Main] ❌ Notification Handler Init Error: $e");
  }

  // Initialize Database
  final dbService = DatabaseService();
  await dbService.db;
  
  try {
    await dotenv.load();
  } catch (e) {
    debugPrint('Dotenv load failed: $e');
  }
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  await EasyLocalization.ensureInitialized();
  await OneSignalService.init();
  await AdaptyService.init();
  final adService = AdService();
  unawaited(adService.initialize());
  await _initializeDatabase();
  unawaited(
    _initializeNotificationService(),
  );
  
  final app = EasyLocalization(
    supportedLocales: _supportedLocales,
    path: _translationsPath,
    fallbackLocale: _fallbackLocale,
    child: const RaidAlarmApp(),
  );
  
  runApp(
    ProviderScope(
      child: app,
    ),
  );
}

Future<void> _initializeDatabase() async {
  try {
    await AppDatabase().database;
  } catch (_) {
  }
}

Future<void> _initializeNotificationService() async {
  try {
    // await NotificationListenerService().initialize(); // Removed as service is deleted
    await LocalNotificationService().initialize();
  } catch (_) {
  }
}


