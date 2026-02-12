import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/services/alarm_service.dart' show AlarmSettings, AlarmMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
final settingsRepoProvider = Provider((ref) => SettingsRepository(ref.read(appDatabaseProvider)));

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);
  
  // Cache'lenmiş değerler - her çağrıldığında oluşturulmasın
  static const String _tableAppSettings = 'app_settings';
  static const String _keyKey = 'key';
  static const String _keyValue = 'value';
  static const String _keyUpdatedAt = 'updated_at';
  static const String _querySelectValue = 'SELECT value FROM app_settings WHERE key = ?';
  static const String _whereKey = 'key = ?';
  static const String _trueString = 'true';
  static const String _keyPermissionStates = 'permissionStates';
  static const String _keyAlarmSettings = 'alarmSettings';



  
  // Stream controller for alarm settings changes
  final _alarmSettingsController = StreamController<AlarmSettings>.broadcast();
  
  // Cache for alarm settings (hızlı erişim için)
  AlarmSettings? _cachedAlarmSettings;
  bool _isLoadingAlarmSettings = false;
  
  // Cache for permission states (hızlı erişim için)
  Map<String, bool>? _cachedPermissionStates;
  
  /// Alarm settings stream - değişiklikleri dinle
  Stream<AlarmSettings> get alarmSettingsStream => _alarmSettingsController.stream;
  
  /// Cached alarm settings - hızlı erişim için (ilk yükleme için)
  AlarmSettings? get cachedAlarmSettings => _cachedAlarmSettings;
  
  /// Cached permission states - hızlı erişim için (ilk yükleme için)
  Map<String, bool>? get cachedPermissionStates => _cachedPermissionStates;
  
  /// İzin durumlarını cache'le
  void cachePermissionStates(Map<String, bool> states) {
    _cachedPermissionStates = Map<String, bool>.from(states);
  }
  
  /// İzin durumlarını SQLite'dan yükle (cache için)
  Future<Map<String, bool>> loadPermissionStates() async {
    try {
      final db = await _db.database;
      final result = await db.rawQuery(
        _querySelectValue,
        [_keyPermissionStates],
      );
      
      if (result.isEmpty) {
        return {};
      }
      
      final jsonString = result.first[_keyValue] as String;
      final states = Map<String, bool>.from(jsonDecode(jsonString));
      _cachedPermissionStates = states;
      return states;
    } catch (e) {
      return _cachedPermissionStates ?? {};
    }
  }
  
  /// İzin durumlarını SQLite'a kaydet
  Future<void> savePermissionStates(Map<String, bool> states) async {
    try {
      final db = await _db.database;
      final jsonString = jsonEncode(states);
      
      await db.insert(
        _tableAppSettings,
        {
          _keyKey: _keyPermissionStates,
          _keyValue: jsonString,
          _keyUpdatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _cachedPermissionStates = Map<String, bool>.from(states);
    } catch (e) {
      // Error saving permission states
    }
  }
  
  Future<void> saveAlarmSettings(AlarmSettings settings) async {
    try {
      final db = await _db.database;
      
      // Map oluştur
      final settingsMap = {
        'alarmEnabled': settings.alarmEnabled,
        'mode': settings.mode.toString().split('.').last, // Enum'u string'e çevir
        'durationSeconds': settings.durationSeconds,
        'loop': settings.loop,
        'vibrationEnabled': true, // Always true
        'vibrationIntensity': 1.0,
        'vibrationPattern': settings.vibrationPattern,
        'fakeCallEnabled': settings.fakeCallEnabled,
        'fakeCallDuration': settings.fakeCallDuration,
        'fakeCallLoop': settings.fakeCallLoop,
        'alarmSound': settings.alarmSound,
        'fakeCallSound': settings.fakeCallSound,
        'fakeCallerName': settings.fakeCallerName,
        'fakeCallShowNumber': settings.fakeCallShowNumber,
        'fakeCallBackground': settings.fakeCallBackground,
      };
      
      // SQLite'a JSON string olarak kaydet
      final jsonString = jsonEncode(settingsMap);
      await db.insert(
        _tableAppSettings,
        {
          _keyKey: _keyAlarmSettings,
          _keyValue: jsonString,
          _keyUpdatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _cachedAlarmSettings = settings;
      
      if (!_alarmSettingsController.isClosed) {
        _alarmSettingsController.add(settings);
      }
      
      try {
        // NotificationService removed
        // await notificationService.notifyAlarmSettingsChanged(settingsMap);
      } catch (e) {
        // Error notifying alarm settings changed
      }
    } catch (e) {
      // Error saving alarm settings
    }
  }

  Future<AlarmSettings> loadAlarmSettings({bool forceReload = false}) async {
    try {
      if (!forceReload && _cachedAlarmSettings != null) {
        _loadAlarmSettingsFromDb().then((settings) {
          if (settings != null && _cachedAlarmSettings != settings) {
            _cachedAlarmSettings = settings;
            if (!_alarmSettingsController.isClosed) {
              _alarmSettingsController.add(settings);
      }
          }
        });
        return _cachedAlarmSettings!;
      }
      
      return await _loadAlarmSettingsFromDb() ?? AlarmSettings();
    } catch (e) {
      return _cachedAlarmSettings ?? AlarmSettings();
    }
  }
  
  Future<AlarmSettings?> _loadAlarmSettingsFromDb() async {
    if (_isLoadingAlarmSettings) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (_cachedAlarmSettings != null) {
        return _cachedAlarmSettings;
      }
    }
    
    _isLoadingAlarmSettings = true;
    try {
      final db = await _db.database;
      
      final result = await db.query(
        _tableAppSettings,
        where: _whereKey,
        whereArgs: [_keyAlarmSettings],
        limit: 1,
      );
      
      if (result.isEmpty) {
        final defaultSettings = AlarmSettings();
        await saveAlarmSettings(defaultSettings);
        _cachedAlarmSettings = defaultSettings;
        return defaultSettings;
      }

      final jsonString = result.first['value'] as String;
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final settings = AlarmSettings();
      
      settings.alarmEnabled = data['alarmEnabled'] as bool? ?? true;
      
      final modeString = data['mode'] as String? ?? 'sound';
      settings.mode = AlarmMode.values.firstWhere(
        (e) => e.toString().split('.').last == modeString,
        orElse: () => AlarmMode.sound,
      );
      
      settings.durationSeconds = (data['durationSeconds'] as num?)?.toInt() ?? 30;
      settings.loop = data['loop'] as bool? ?? false;
      settings.vibrationEnabled = true; // Always true
      settings.vibrationIntensity = 1.0;
      settings.vibrationPattern = data['vibrationPattern'] as String? ?? 'strong';
      settings.fakeCallEnabled = data['fakeCallEnabled'] as bool? ?? false;
      settings.fakeCallDuration = (data['fakeCallDuration'] as num?)?.toInt() ?? 30;
      settings.fakeCallLoop = data['fakeCallLoop'] as bool? ?? false;
      settings.alarmSound = data['alarmSound'] as String?;
      settings.fakeCallSound = data['fakeCallSound'] as String?;
      
      settings.fakeCallerName = data['fakeCallerName'] as String? ?? 'Raid Alarm';
      settings.fakeCallShowNumber = data['fakeCallShowNumber'] as bool? ?? false;
      settings.fakeCallBackground = data['fakeCallBackground'] as String? ?? 'Default Dark';
      
      _cachedAlarmSettings = settings;
      
      return settings;
    } catch (e) {
      return null;
    } finally {
      _isLoadingAlarmSettings = false;
    }
  }
  
  void dispose() {
    _alarmSettingsController.close();
  }














}
