import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:raidalarm/app.dart';
import 'package:raidalarm/core/theme/rust_colors.dart'; // Fixed path
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/services/onesignal_service.dart';
import 'package:raidalarm/services/adapty_service.dart';
import 'package:raidalarm/core/services/notification_handler.dart';
import 'package:raidalarm/core/services/database_service.dart';
import 'package:raidalarm/core/services/quick_actions_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/core/services/api_service.dart';

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
  
  await NotificationHandler.initialize();
  
  // Wake up backend early
  ApiService.wakeUpBackend();

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
  
  // Initialize Adapty
  final adaptyService = AdaptyService();
  await adaptyService.init();
  
  await _initializeDatabase();
  
  final app = EasyLocalization(
    supportedLocales: _supportedLocales,
    path: _translationsPath,
    fallbackLocale: _fallbackLocale,
    child: const RaidAlarmApp(),
  );
  
  runApp(
    ProviderScope(
      overrides: [
        adaptyServiceProvider.overrideWithValue(adaptyService),
      ],
      child: app,
    ),
  );
  
  // Initialize Quick Actions (Non-blocking)
  final container = ProviderContainer();
  container.read(quickActionsServiceProvider).initialize();
}

Future<void> _initializeDatabase() async {
  try {
    await AppDatabase().database;
  } catch (_) {
  }
}


