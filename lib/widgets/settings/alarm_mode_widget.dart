import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/settings/settings_shared.dart';
import 'package:raidalarm/services/alarm_service.dart'; // AlarmSettings, AlarmMode
import 'package:raidalarm/data/repositories/settings_repository.dart';
import 'package:raidalarm/core/constants/alarm_sounds.dart';
import 'package:raidalarm/core/utils/sound_preview_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/notification_provider.dart';
class AlarmModeWidget extends ConsumerStatefulWidget {
  const AlarmModeWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AlarmModeWidget> createState() => _AlarmModeWidgetState();
}

class _AlarmModeWidgetState extends ConsumerState<AlarmModeWidget> {
  // State variables initial values
  bool _alarmEnabled = true;
  int _alarmDurationSeconds = 30;
  String? _alarmSoundId;
  bool _alarmLoop = false;
  
  // Repository instance
  SettingsRepository get _settingsRepo => ref.read(settingsRepoProvider);
  StreamSubscription<AlarmSettings>? _settingsSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize with correct defaults
    _alarmDurationSeconds = 30;
    _alarmSoundId = null;
    _loadSettings();
    _subscribeToSettings();
  }
  
  @override
  void dispose() {
    _settingsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsRepo.loadAlarmSettings();
    _updateStateFromSettings(settings);
  }
  
  void _subscribeToSettings() {
    _settingsSubscription = _settingsRepo.alarmSettingsStream.listen((settings) {
      _updateStateFromSettings(settings);
    });
  }
  
  void _updateStateFromSettings(AlarmSettings settings) {
    if (!mounted) return;
    
    setState(() {
      _alarmEnabled = settings.alarmEnabled;
      _alarmLoop = settings.loop;
      
      // Map duration seconds
      _alarmDurationSeconds = settings.durationSeconds;
      
      // Map sound ID
      _alarmSoundId = settings.alarmSound;
      
      _isLoading = false;
    });
  }
  
  Future<void> _saveSettings({
    bool? enabled,
    bool? loop,
    int? duration,
    String? soundId,
  }) async {
    final currentSettings = await _settingsRepo.loadAlarmSettings();
    
    // Mutual Exclusivity: Only one can be enabled at a time
    if (enabled == true) {
      currentSettings.alarmEnabled = true;
      currentSettings.fakeCallEnabled = false;
    } else if (enabled == false) {
      currentSettings.alarmEnabled = false;
      currentSettings.fakeCallEnabled = true; // Switch to fake call if alarm is disabled
    }

    if (loop != null) currentSettings.loop = loop;
    if (duration != null) currentSettings.durationSeconds = duration;
    
    // Explicitly handle null for "System Default"
    if (soundId != null) {
       currentSettings.alarmSound = (soundId == AlarmSounds.systemDefault) ? null : soundId;
    }
    
    // Save to repo (this updates SQLite and notifies listeners)
    await _settingsRepo.saveAlarmSettings(currentSettings);
  }

  String _getDurationString(int seconds) {
    switch (seconds) {
      case 30: return tr('settings.common.durations.sec_30');
      case 60: return tr('settings.common.durations.min_1');
      case 180: return tr('settings.common.durations.min_3');
      case 300: return tr('settings.common.durations.min_5');
      default: return '$seconds sec';
    }
  }
  
  int _getDurationSecondsFromDisplay(String display) {
    if (display == tr('settings.common.durations.sec_30')) return 30;
    if (display == tr('settings.common.durations.min_1')) return 60;
    if (display == tr('settings.common.durations.min_3')) return 180;
    if (display == tr('settings.common.durations.min_5')) return 300;
    return 30;
  }

  Future<void> _pickCustomSound() async {
    try {
      // if (Platform.isIOS) { ... } removed to fix permission issue


      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null) {
        String? originalPath = result.files.single.path;
        if (originalPath != null) {
          final appDir = await getApplicationDocumentsDirectory();
          final String paramsPath = path.join(appDir.path, 'custom_alarms');
          
          final Directory customAlarmsDir = Directory(paramsPath);
          if (!await customAlarmsDir.exists()) {
            await customAlarmsDir.create(recursive: true);
          } else {
             // Cleanup old custom alarms to save space (keep only the latest)
             try {
               final files = customAlarmsDir.listSync();
               for (var file in files) {
                 if (file is File && path.basename(file.path).startsWith('custom_alarm_')) {
                   await file.delete();
                 }
               }
             } catch (e) {
               debugPrint('Error cleaning up old alarms: $e');
             }
          }
          
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final extension = path.extension(originalPath);
          final safeName = path.basenameWithoutExtension(originalPath).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
          // Use a format that preserves the original name for the user to see
          final String fileName = 'custom_alarm_${timestamp}_$safeName$extension';
          final String newPath = path.join(paramsPath, fileName);
          
          await File(originalPath).copy(newPath);
          
          await _saveSettings(soundId: newPath);
          
          // Play preview
          await SoundPreviewHelper.instance.playPreview(newPath);
        }
      }
    } catch (e) {
      debugPrint('Error picking custom sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: RustColors.surface, // bg-[#121214]
        border: Border.all(
          color: RustColors.divider, // border-zinc-800
          width: 1.0.w,
        ),
        borderRadius: BorderRadius.circular(16.0.r), // rounded-2xl
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header with Toggle
          Padding(
            padding: EdgeInsets.all(20.0.w), // p-5
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Icon + Text
                Row(
                  children: [
                    Container(
                      width: 40.0.w, // w-10
                      height: 40.0.w, // h-10
                      decoration: BoxDecoration(
                        color: _alarmEnabled
                            ? RustColors.primary // bg-red-600
                            : RustColors.divider, // bg-zinc-800
                        borderRadius:
                            BorderRadius.circular(20.0.r), // rounded-full
                        boxShadow: _alarmEnabled
                            ? [
                                BoxShadow(
                                  color:
                                      RustColors.primary.withOpacity(0.4),
                                  blurRadius: 15.0.r,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        LucideIcons.bell,
                        size: 20.0.w, // w-5 h-5
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16.0.w), // gap-4
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            tr('settings.alarm_mode.title'),
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.0.h),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            tr('settings.alarm_mode.subtitle'),
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: const Color(0xFF71717A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Right: Toggle
                GestureDetector(
                  onTap: () {
                    HapticHelper.lightImpact();
                    
                    final nextEnabled = !_alarmEnabled;
                    _saveSettings(enabled: nextEnabled);
                  },
                  child: Container(
                    width: 48.0.w, // w-12
                    height: 28.0.h, // h-7
                    padding: EdgeInsets.all(4.0.w), // p-1
                    decoration: BoxDecoration(
                      color: _alarmEnabled
                          ? RustColors.primary // bg-red-600
                          : const Color(0xFF3F3F46), // bg-zinc-700
                      borderRadius:
                          BorderRadius.circular(14.0.r), // rounded-full
                    ),
                    child: Align(
                      alignment: _alarmEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: 20.0.w, // w-5
                        height: 20.0.w, // h-5
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4.0.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Collapsible Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0, -0.05),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: (_alarmEnabled)
                ? Container(
                    key: const ValueKey('alarm_enabled'),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: RustColors.divider.withOpacity(0.5),
                          width: 1.0.w,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          20.0.w, 20.0.h, 20.0.w, 20.0.h),
                      child: Column(
                        children: [
                           // Alarm Sound Dropdown
                            SettingsDropdown(
                              icon: LucideIcons.music,
                              label: tr('settings.alarm_mode.sound'),
                              value: AlarmSounds.getDisplayName(_alarmSoundId),
                              onChange: (value) async {
                                if (value == tr('settings.alarm.sounds.pick_custom')) {
                                  await _pickCustomSound();
                                } else if (value == tr('settings.alarm.sounds.custom_label')) {
                                  // Keep current custom sound if selected
                                  if (_alarmSoundId != null && 
                                     (_alarmSoundId!.contains('/') || _alarmSoundId!.contains('\\'))) {
                                    await _saveSettings(soundId: _alarmSoundId);
                                  }
                                } else {
                                  final soundId = AlarmSounds.getSoundIdFromDisplayName(value);
                                  await _saveSettings(soundId: soundId ?? AlarmSounds.systemDefault);
                                  
                                  // Play sound preview
                                  if (soundId != null) {
                                    await SoundPreviewHelper.instance.playPreview(soundId);
                                  }
                                }
                              },
                              options: [
                                ...AlarmSounds.allSounds
                                    .map((id) => AlarmSounds.getDisplayName(id))
                                    .toSet(),
                                if (_alarmSoundId != null && 
                                    !AlarmSounds.allSounds.contains(_alarmSoundId))
                                  AlarmSounds.getDisplayName(_alarmSoundId),
                                tr('settings.alarm.sounds.pick_custom'),
                              ].toSet().toList(),
                            ),
                          SizedBox(height: 24.0.h),

                          // Infinite Loop Toggle
                          SettingsToggle(
                            icon: LucideIcons.repeat,
                            label: tr('settings.alarm_mode.infinite_loop'),
                            checked: _alarmLoop,
                            onChange: (value) {
                              _saveSettings(loop: value);
                            },
                          ),
                          SizedBox(height: 24.0.h),

                          // Alarm Duration Dropdown
                          Opacity(
                            opacity: _alarmLoop ? 0.3 : 1.0,
                            child: IgnorePointer(
                              ignoring: _alarmLoop,
                              child: SettingsDropdown(
                                icon: LucideIcons.clock,
                                label: tr('settings.alarm_mode.duration'),
                                value: _getDurationString(_alarmDurationSeconds),
                                onChange: (value) {
                                  _saveSettings(duration: _getDurationSecondsFromDisplay(value));
                                },
                                options: [
                                  tr('settings.common.durations.sec_30'),
                                  tr('settings.common.durations.min_1'),
                                  tr('settings.common.durations.min_3'),
                                  tr('settings.common.durations.min_5'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(
                    key: ValueKey('alarm_disabled'),
                  ),
          ),
        ],
      ),
    );
  }
}
