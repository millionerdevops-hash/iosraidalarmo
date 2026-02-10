import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AlarmMode {
  sound,
  vibration,
}

final alarmServiceProvider = ChangeNotifierProvider((ref) => AlarmService());

class AlarmService extends ChangeNotifier {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  
  AlarmService._internal() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static const MethodChannel _channel = MethodChannel('com.raidalarm/alarm_service');
  
  static const String _methodAlarmStatusChanged = 'alarmStatusChanged';
  static const String _methodStopAlarm = 'stopAlarm';
  static const String _methodDismissAlarmNotification = 'dismissAlarmNotification';
  
  bool _isPlaying = false;
  
  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == _methodAlarmStatusChanged) {
      final data = call.arguments as Map<dynamic, dynamic>;
      final isPlaying = data['isPlaying'] as bool? ?? false;
      if (isPlaying != _isPlaying) {
        _isPlaying = isPlaying;
        notifyListeners();
      }
    }
  }


  
  Future<void> stopAlarm() async {
    try {
      _isPlaying = false;
      notifyListeners();
      
      // Önce alarm durdurulmalı (ses/vibrasyon), sonra notification kapatılmalı
      // Native tarafta stopSystemAlarm zaten notification'ı da kapatıyor ama
      // sıralı yapmak daha güvenli (race condition önleme ve mantıksal sıralama)
      try {
        await _channel.invokeMethod(_methodStopAlarm);
      } catch (e) {
        // Error stopping alarm
      }
      
      // Notification kapatma (stopAlarm zaten kapatıyor ama ek güvenlik için)
      try {
        await _channel.invokeMethod(_methodDismissAlarmNotification);
      } catch (e) {
        // Error dismissing alarm notification
      }
    } catch (e) {
      _isPlaying = false;
      notifyListeners();
    }
  }

  bool get isPlaying => _isPlaying;

  Future<void> updateSettings(AlarmSettings settings) async {
    // Implement setting update logic here, possibly sending to native
    // For now, we will just notify listeners as a placeholder unless native integration is required
    notifyListeners();
  }
}

class AlarmSettings {
  bool alarmEnabled = true;
  AlarmMode mode = AlarmMode.sound;
  int durationSeconds = 30;
  bool loop = false;
  bool vibrationEnabled = true; // Always enabled by default
  double vibrationIntensity = 1.0;
  String vibrationPattern = 'strong';
  bool fakeCallEnabled = false;
  int fakeCallDuration = 30;
  bool fakeCallLoop = false;
  
  // Ses seçimleri (null = sistem varsayılanı)
  String? alarmSound; // Örnek: "alarm_sound_1" veya null
  String? fakeCallSound; // Örnek: "alarm_sound_1" veya null

  // New features for Fake Call
  String fakeCallerName = 'Raid Alarm';
  bool fakeCallShowNumber = false;
  String fakeCallBackground = 'Default Dark';
}
