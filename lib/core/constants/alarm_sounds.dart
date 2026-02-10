import 'package:easy_localization/easy_localization.dart';

/// Alarm ve Fake Call ses seçenekleri
class AlarmSounds {
  /// Sistem varsayılan sesi (null değeri)
  static const String systemDefault = 'system_default';
  
  /// Ses dosyası ID'leri (raw resource isimleri)
  static const String sound1 = 'alarm_sound_1';
  static const String sound2 = 'alarm_sound_2';
  static const String sound3 = 'alarm_sound_3';
  static const String sound4 = 'alarm_sound_4';
  static const String sound5 = 'alarm_sound_5';
  static const String sound6 = 'alarm_sound_6';
  
  /// Tüm ses seçenekleri listesi
  static List<String> get allSounds => [
    systemDefault,
    sound1,
    sound2,
    sound3,
    sound4,
    sound5,
    sound6,
  ];
  
  /// Ses ID'sinden görünen isme çevir
  /// null veya systemDefault ise "None" döner
  static String getDisplayName(String? soundId) {
    if (soundId == null || soundId == systemDefault) {
      return tr('settings.alarm.sounds.none');
    }
    
    switch (soundId) {
      case sound1:
        return tr('settings.alarm.sounds.alarm_1');
      case sound2:
        return tr('settings.alarm.sounds.alarm_2');
      case sound3:
        return tr('settings.alarm.sounds.alarm_3');
      case sound4:
        return tr('settings.alarm.sounds.alarm_4');
      case sound5:
        return tr('settings.alarm.sounds.alarm_5');
      case sound6:
        return tr('settings.alarm.sounds.alarm_6');
      default:
        // Eğer dosya yolu ise sadece ismini göster
        if (soundId.contains('/') || soundId.contains('\\')) {
          try {
            // Return generic name to avoid overflow in dropdown
            return tr('settings.alarm.sounds.custom_label');
          } catch (e) {
            return soundId;
          }
        }
        return soundId;
    }
  }
  
  /// Görünen isimden ses ID'sine çevir
  static String? getSoundIdFromDisplayName(String displayName) {
    if (displayName == tr('settings.alarm.sounds.none')) {
      return null;
    } else if (displayName == tr('settings.alarm.sounds.alarm_1')) {
      return sound1;
    } else if (displayName == tr('settings.alarm.sounds.alarm_2')) {
      return sound2;
    } else if (displayName == tr('settings.alarm.sounds.alarm_3')) {
      return sound3;
    } else if (displayName == tr('settings.alarm.sounds.alarm_4')) {
      return sound4;
    } else if (displayName == tr('settings.alarm.sounds.alarm_5')) {
      return sound5;
    } else if (displayName == tr('settings.alarm.sounds.alarm_6')) {
      return sound6;
    }
    return null;
  }
}

