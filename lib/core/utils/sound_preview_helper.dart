import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';
import 'package:raidalarm/core/constants/alarm_sounds.dart';



/// Sound Preview Helper
/// 
/// Ayarlarda ses seçiminde önizleme için kullanılır
/// Raw resource'lardan ses çalar (%15 volume, 4 saniye)
class SoundPreviewHelper {
  // Singleton pattern
  SoundPreviewHelper._();
  static final SoundPreviewHelper _instance = SoundPreviewHelper._();
  static SoundPreviewHelper get instance => _instance;
  
  // AudioPlayer instance
  AudioPlayer? _player;
  // Dispose işleminin tamamlanmasını takip et
  bool _isDisposing = false;
  // Otomatik durdurma timer'ı
  Timer? _autoStopTimer;
  
  /// Ses önizlemesi çal
  /// @param soundId Ses ID'si (AlarmSounds constant'ından) veya null (sistem varsayılanı)
  Future<void> playPreview(String? soundId) async {
    try {
      // Önceki sesi durdur ve dispose işleminin tamamlanmasını bekle
      await stopPreview();
      
      // Sistem varsayılanı seçilmişse çalma (native tarafta çalacak)
      if (soundId == null || soundId == AlarmSounds.systemDefault) {
        return;
      }
      
      // Dispose işlemi devam ediyorsa bekle
      while (_isDisposing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      
      // Önceki timer'ı iptal et
      _autoStopTimer?.cancel();
      _autoStopTimer = null;
      
      // AudioPlayer oluştur
      _player = AudioPlayer();
      
      // Volume %10 (kısık ses)
      await _player!.setVolume(0.10);
      
      // Ses dosyasını çal (raw resource'dan)
      // Ses dosyasını çal
      // Eğer path ise DeviceFileSource, değilse AssetSource
      if (soundId != null && (soundId.contains('/') || soundId.contains('\\'))) {
        final file = File(soundId);
        if (await file.exists()) {
           await _player!.play(DeviceFileSource(soundId));
        } else {
           // Dosya bulunamadı, sessizce geç veya logla
           // Fallback to default maybe?
        }
      } else {
        // Android: android/app/src/main/res/raw/alarm_sound_1.mp3
        final source = AssetSource('audio/$soundId.mp3');
        await _player!.play(source);
      }
      
      // 2 saniye sonra otomatik durdur
      _autoStopTimer = Timer(const Duration(seconds: 2), () {
        stopPreview();
      });
      
    } catch (e) {
      await stopPreview();
    }
  }
  
  /// Ses önizlemesini durdur
  Future<void> stopPreview() async {
    // Zaten dispose işlemi devam ediyorsa bekle
    if (_isDisposing) {
      while (_isDisposing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }
    
    try {
      // Timer'ı iptal et
      _autoStopTimer?.cancel();
      _autoStopTimer = null;
      
      final player = _player;
      if (player != null) {
        _isDisposing = true;
        _player = null; // Önce null yap ki tekrar çağrılmasın
        
        try {
          await player.stop();
        } catch (e) {
          // Stop hatası ignore edilebilir
        }
        
        try {
          await player.dispose();
        } catch (e) {
          // Dispose hatası ignore edilebilir
        }
        
        _isDisposing = false;
      }
    } catch (e) {
      _isDisposing = false;
    }
  }
  
  /// Cleanup - uygulama kapanırken çağrılabilir
  Future<void> dispose() async {
    _autoStopTimer?.cancel();
    _autoStopTimer = null;
    await stopPreview();
  }
}

