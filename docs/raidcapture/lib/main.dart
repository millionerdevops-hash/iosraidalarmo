import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/routes/app_router.dart';
import 'config/rust_colors.dart';
import 'core/services/database_service.dart';
import 'core/services/notification_handler.dart';

void main() async {
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

  runApp(
    const ProviderScope(
      child: RaidCaptureApp(),
    ),
  );
}

class RaidCaptureApp extends ConsumerWidget {
  const RaidCaptureApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RaidCapture',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: RustColors.primary,
        scaffoldBackgroundColor: RustColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RustColors.primary,
          brightness: Brightness.dark,
          surface: RustColors.surface,
          onSurface: RustColors.textPrimary,
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RustColors.background,
      appBar: AppBar(
        title: const Text("RaidCapture"),
        backgroundColor: RustColors.surface,
        foregroundColor: RustColors.textPrimary,
      ),
      body: Center(
        child: FilledButton.icon(
          onPressed: () => context.go('/login'),
          style: FilledButton.styleFrom(
            backgroundColor: RustColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          icon: const Icon(Icons.login),
          label: const Text("LOGIN WITH STEAM"),
        ),
      ),
    );
  }
}
