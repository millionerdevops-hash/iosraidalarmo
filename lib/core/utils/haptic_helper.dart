import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';

class HapticHelper {
  // Private constructor to prevent instantiation
  HapticHelper._();
  
  // Cache the vibration capability check result
  static bool? _canVibrate;
  
  /// Check if device supports vibration
  /// Result is cached for performance
  static Future<bool> _checkVibration() async {
    if (_canVibrate != null) return _canVibrate!;
    
    try {
      _canVibrate = await Vibration.hasVibrator() ?? false;
      return _canVibrate!;
    } catch (e) {
      _canVibrate = false;
      return false;
    }
  }
  
  /// Execute vibration pattern
  /// Returns true if vibration was executed successfully
  static Future<bool> _vibrate({
    int duration = 50,
    List<int>? pattern,
    int amplitude = 128,
  }) async {
    try {
      final canVibrate = await _checkVibration();
      if (!canVibrate) {
        return false;
      }
      
      if (pattern != null) {
        // Use pattern for complex vibrations
        await Vibration.vibrate(pattern: pattern, intensities: List.filled(pattern.length, amplitude));
      } else {
        // Use simple vibration with amplitude
        await Vibration.vibrate(duration: duration, amplitude: amplitude);
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
    
  /// Medium impact feedback
  /// Used for: standard button presses, switches
  /// Duration: 50ms, Amplitude: 220 (86% intensity)
  static Future<bool> mediumImpact() async {
    return _vibrate(duration: 50, amplitude: 220);
  }
  
  /// Heavy impact feedback
  /// Used for: important actions, critical buttons
  /// Duration: 80ms, Amplitude: 240 (94% intensity)
  static Future<bool> heavyImpact() async {
    return _vibrate(duration: 80, amplitude: 240);
  }
  

  
  /// Success feedback
  /// Used for: successful operations, confirmations
  /// Pattern: Short-Pause-Short (60ms-40ms-60ms)
  static Future<bool> success() async {
    return _vibrate(
      pattern: [0, 60, 40, 60],
      amplitude: 230,
    );
  }
  

  
  /// Selection feedback
  /// Used for: selecting items, toggling options
  /// Duration: 30ms, Amplitude: 200 (78% intensity)
  static Future<bool> selection() async {
    return _vibrate(duration: 30, amplitude: 200);
  }
  

  
  /// Soft feedback
  /// Used for: gentle notifications, subtle alerts
  /// Duration: 40ms, Amplitude: 180 (71% intensity)
  static Future<bool> soft() async {
    return _vibrate(duration: 40, amplitude: 180);
  }
  

  /// Error feedback
  /// Used for: failed operations, validation errors
  /// Pattern: Medium-Pause-Medium (50ms-50ms-50ms)
  static Future<bool> error() async {
    return _vibrate(
      pattern: [0, 50, 50, 50],
      amplitude: 255,
    );
  }
}

