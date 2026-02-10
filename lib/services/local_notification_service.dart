import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localNotificationServiceProvider = Provider((ref) => LocalNotificationService());

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin = fln.FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const fln.AndroidInitializationSettings initializationSettingsAndroid =
        fln.AndroidInitializationSettings('@mipmap/ic_launcher');

    const fln.DarwinInitializationSettings initializationSettingsDarwin =
        fln.DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const fln.InitializationSettings initializationSettings = fln.InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification clicked: ${details.payload}');
      },
    );

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    bool? granted = false;
    
    // Android
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<fln.AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      granted = await androidImplementation.requestNotificationsPermission();
    }

    // iOS/macOS
    final iosImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<fln.IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    
    return granted ?? false;
  }

  Future<void> scheduleWipeAlert({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Ensure initialized
    await initialize();

    // ID should be a unique 32-bit integer.
    // We'll trust the caller to provide a unique ID (e.g. server ID hash).
    
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const fln.NotificationDetails(
          android: fln.AndroidNotificationDetails(
            'wipe_alerts',
            'Wipe Alerts',
            channelDescription: 'Notifications for upcoming server wipes',
            importance: fln.Importance.high,
            priority: fln.Priority.high,
          ),
          iOS: fln.DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('Scheduled wipe alert for $scheduledDate (ID: $id)');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    debugPrint('Cancelled notification ID: $id');
  }
}

