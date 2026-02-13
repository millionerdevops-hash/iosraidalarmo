import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/widgets/settings/settings_shared.dart';
import 'package:raidalarm/services/alarm_service.dart'; // AlarmSettings
import 'package:raidalarm/data/repositories/settings_repository.dart';
import 'package:raidalarm/core/constants/alarm_sounds.dart';
import 'package:raidalarm/core/utils/sound_preview_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart'; // import path_provider
import 'package:path/path.dart' as p; // import path
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/providers/notification_provider.dart';
class FakeCallWidget extends ConsumerStatefulWidget {
  const FakeCallWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<FakeCallWidget> createState() => _FakeCallWidgetState();
}

class _FakeCallWidgetState extends ConsumerState<FakeCallWidget> {
  // State variables
  bool _fakeCallEnabled = false;
  String? _fakeCallSoundId;
  int _fakeCallDurationSeconds = 30;
  bool _fakeCallLoop = false;
  String _fakeCallerName = 'Raid Alarm';
  bool _fakeCallShowNumber = false;
  String _fakeCallBackground = 'Default Dark';

  late final TextEditingController _callerController;
  late final FocusNode _callerFocus;

  // Repository
  SettingsRepository get _settingsRepo => ref.read(settingsRepoProvider);
  StreamSubscription<AlarmSettings>? _settingsSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    _callerController = TextEditingController(text: _fakeCallerName);
    _callerFocus = FocusNode();
    
    // Listen to text changes to save (debounced or on submit? classic save on change for now)
    _callerController.addListener(_onNameChanged);

    _loadSettings();
    _subscribeToSettings();
  }

  @override
  void dispose() {
    _callerController.removeListener(_onNameChanged);
    _callerController.dispose();
    _callerFocus.dispose();
    _settingsSubscription?.cancel();
    super.dispose();
  }

  void _onNameChanged() {
    if (_callerController.text != _fakeCallerName) {
       // Avoid recursive loop if setting from state
       // We'll handle save on submit or debounce, but for simplicity let's save when focus lost or explicitly?
       // Let's just update local state here, save in 'onChange' of TextField or save in dispose/focus lost could be better.
       // User experience: typing shouldn't lag.
       // We'll use onChanged in TextField for state update + save.
    }
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
      _fakeCallEnabled = settings.fakeCallEnabled;
      _fakeCallLoop = settings.fakeCallLoop;
      _fakeCallDurationSeconds = settings.fakeCallDuration;
      _fakeCallSoundId = settings.fakeCallSound;
      _fakeCallerName = settings.fakeCallerName;
      _fakeCallShowNumber = settings.fakeCallShowNumber;
      _fakeCallBackground = settings.fakeCallBackground;
      
      // Update text controller if different and not focused (to allow typing)
      if (_callerController.text != _fakeCallerName && !_callerFocus.hasFocus) {
        _callerController.text = _fakeCallerName;
      }
      
      _isLoading = false;
    });
  }

  Future<void> _saveSettings({
    bool? enabled,
    bool? loop,
    int? duration,
    String? soundId,
    String? callerName,
    bool? showNumber,
    String? background,
  }) async {
    final currentSettings = await _settingsRepo.loadAlarmSettings();

    // Mutual Exclusivity: Only one can be enabled at a time
    if (enabled == true) {
      currentSettings.fakeCallEnabled = true;
      currentSettings.alarmEnabled = false;
    } else if (enabled == false) {
      currentSettings.fakeCallEnabled = false;
      currentSettings.alarmEnabled = true; // Switch to alarm if fake call is disabled
    }

    if (loop != null) currentSettings.fakeCallLoop = loop;
    if (duration != null) currentSettings.fakeCallDuration = duration;
    
    // Explicitly handle null for "System Default"
    if (soundId != null) {
      currentSettings.fakeCallSound = (soundId == AlarmSounds.systemDefault) ? null : soundId;
    }
    
    if (callerName != null) currentSettings.fakeCallerName = callerName;
    if (showNumber != null) currentSettings.fakeCallShowNumber = showNumber;
    if (background != null) currentSettings.fakeCallBackground = background;

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
    return 30; // default
  }

  Future<void> _pickCustomSound() async {
    try {
      if (Platform.isIOS) {
        var status = await Permission.mediaLibrary.status;
        if (status.isDenied) {
          status = await Permission.mediaLibrary.request();
        }
        
        if (status.isPermanentlyDenied) {
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(tr('settings.common.permission_required')),
                action: SnackBarAction(
                  label: tr('settings.common.open_settings'),
                  onPressed: () => openAppSettings(),
                ),
              ),
            );
          }
           return;
        }

        if (!status.isGranted && !status.isLimited) {
            return;
        }
      } 

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null) {
        String? originalPath = result.files.single.path;
        if (originalPath != null) {
          final appDir = await getApplicationDocumentsDirectory();
          final String paramsPath = p.join(appDir.path, 'custom_fake_call_sounds');
          
          final Directory customSoundsDir = Directory(paramsPath);
          if (!await customSoundsDir.exists()) {
            await customSoundsDir.create(recursive: true);
          } else {
             // Cleanup old custom sounds
             try {
               final files = customSoundsDir.listSync();
               for (var file in files) {
                 if (file is File && p.basename(file.path).startsWith('custom_fc_sound_')) {
                   await file.delete();
                 }
               }
             } catch (e) {
               debugPrint('Error cleaning up old fake call sounds: $e');
             }
          }
          
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final extension = p.extension(originalPath);
          final safeName = p.basenameWithoutExtension(originalPath).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
          // custom_fc_sound_TIMESTAMP_OriginalName.mp3
          final String fileName = 'custom_fc_sound_${timestamp}_$safeName$extension';
          final String newPath = p.join(paramsPath, fileName);
          
          await File(originalPath).copy(newPath);
          
          await _saveSettings(soundId: newPath);
          
          // Play preview
          await SoundPreviewHelper.instance.playPreview(newPath);
        }
      }
    } catch (e) {
      debugPrint('Error picking custom fake call sound: $e');
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
                      width: 40.0.w,
                      height: 40.0.w,
                      decoration: BoxDecoration(
                        color: _fakeCallEnabled
                            ? const Color(0xFF16A34A) // green-600
                            : RustColors.divider, // zinc-800
                        borderRadius: BorderRadius.circular(20.0.r),
                        boxShadow: _fakeCallEnabled
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF22C55E)
                                      .withOpacity(0.4),
                                  blurRadius: 15.0.r,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        LucideIcons.smartphone,
                        size: 20.0.w,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16.0.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            tr('settings.fake_call.title'),
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
                            tr('settings.fake_call.subtitle'),
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
                    HapticHelper.mediumImpact();
                    final nextEnabled = !_fakeCallEnabled;
                    // if (nextEnabled) {
                    //   final hasLifetime =
                    //       ref.read(notificationProvider).hasLifetime;
                    //   if (!hasLifetime) {
                    //     AdService().showInterstitialAd();
                    //   }
                    // }
                    _saveSettings(enabled: nextEnabled);
                  },
                  child: Container(
                    width: 48.0.w,
                    height: 28.0.h,
                    padding: EdgeInsets.all(4.0.w),
                    decoration: BoxDecoration(
                      color: _fakeCallEnabled
                          ? const Color(0xFF22C55E) // green-500
                          : const Color(0xFF3F3F46), // zinc-700
                      borderRadius: BorderRadius.circular(14.0.r),
                    ),
                    child: Align(
                      alignment: _fakeCallEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: 20.0.w,
                        height: 20.0.w,
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
            child: (_fakeCallEnabled)
                ? Container(
                    key: const ValueKey('fake_call_enabled'),
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
                          // Caller Name Input
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.user,
                                    size: 20.0.w,
                                    color: RustColors.textMuted,
                                  ),
                                  SizedBox(width: 16.0.w),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      tr('settings.fake_call.caller_name'),
                                      style: RustTypography.bodyMedium
                                          .copyWith(
                                        color: RustColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 128.0.w,
                                child: TextField(
                                  controller: _callerController,
                                  focusNode: _callerFocus,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(25),
                                  ],
                                  onChanged: (value) {
                                    // Save on every change (or you could debounce this)
                                    _saveSettings(callerName: value);
                                  },
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: RustColors.textSecondary,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: const Color(0xFF1C1C1E),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.0.w,
                                      vertical: 8.0.h,
                                    ),
                                    hintText: tr('settings.fake_call.caller_name'),
                                    hintStyle: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: RustColors.textMuted,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0.r),
                                      borderSide: BorderSide(
                                        color: RustColors.divider,
                                        width: 1.0.w,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0.r),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF52525B),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.0.h),

                          // Show Number Toggle
                          SettingsToggle(
                            icon: LucideIcons.hash,
                            label: tr('settings.fake_call.show_number'),
                            checked: _fakeCallShowNumber,
                            onChange: (value) {
                              _saveSettings(showNumber: value);
                            },
                          ),
                          SizedBox(height: 24.0.h),

                          // Background Selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.image,
                                      size: 20.w,
                                      color: RustColors.textMuted,
                                    ),
                                    SizedBox(width: 16.w),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        tr('settings.fake_call.background'),
                                        style: RustTypography.bodyMedium.copyWith(
                                          color: RustColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Horizontal Background List
                              SizedBox(
                                height: 100.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    // Option 1: Default
                                    _BackgroundOptionCard(
                                      label: tr('settings.fake_call.background_options.default'),
                                      value: 'Default Dark',
                                      groupValue: _fakeCallBackground,
                                      color: const Color(0xFF121214),
                                      onTap: () => _saveSettings(background: 'Default Dark'),
                                    ),
                                    SizedBox(width: 12.w),

                                      // Option 2: Custom (Gallery)
                                    _BackgroundOptionCard(
                                      label: tr('settings.fake_call.background_options.gallery'),
                                      isCustom: true,
                                      backgroundImage: _fakeCallBackground != 'Default Dark' 
                                          ? File(_fakeCallBackground) 
                                          : null,
                                      groupValue: _fakeCallBackground, // Highlights if not default
                                      onTap: () async {
                                        if (Platform.isIOS) {
                                            var status = await Permission.photos.status;
                                            if (status.isDenied) {
                                              status = await Permission.photos.request();
                                            }
                                            
                                            if (status.isPermanentlyDenied) {
                                              if (mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(tr('settings.common.permission_required')),
                                                      action: SnackBarAction(
                                                      label: tr('settings.common.open_settings'),
                                                      onPressed: () => openAppSettings(),
                                                      ),
                                                  ),
                                                  );
                                              }
                                              return;
                                            }
                                            
                                             if (!status.isGranted && !status.isLimited) {
                                                return;
                                            }
                                        }

                                          final ImagePicker picker = ImagePicker();
                                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                          if (image != null) {
                                            try {
                                              // Copy to permanent storage
                                              final directory = await getApplicationDocumentsDirectory();
                                              
                                              // Delete old custom backgrounds to save space
                                              try {
                                                final files = directory.listSync();
                                                for (var file in files) {
                                                  if (file is File && p.basename(file.path).startsWith('custom_fake_call_bg_')) {
                                                    await file.delete();
                                                  }
                                                }
                                              } catch (e) {
                                                // Ignore cleanup errors
                                              }
  
                                              final timestamp = DateTime.now().millisecondsSinceEpoch;
                                              final fileName = 'custom_fake_call_bg_$timestamp${p.extension(image.path)}';
                                              final savedImage = await File(image.path).copy('${directory.path}/$fileName');
                                              
                                              // Clear image cache to ensure immediate update if needed (though new filename solves most caching)
                                              PaintingBinding.instance.imageCache.clear();
                                              PaintingBinding.instance.imageCache.clearLiveImages();
                                              
                                              _saveSettings(background: savedImage.path);
                                            } catch (e) {
                                              
                                              // Fallback to original path if copy fails (less reliable but works temporarily)
                                              _saveSettings(background: image.path);
                                            }
                                          }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.0.h),

                          // Divider
                          Container(
                            height: 1.0.h,
                            color: RustColors.divider.withOpacity(0.5),
                          ),
                          SizedBox(height: 24.0.h),

                           // Sound Dropdown
                            SettingsDropdown(
                              icon: LucideIcons.music,
                              label: tr('settings.fake_call.sound'),
                              value: AlarmSounds.getDisplayName(_fakeCallSoundId),
                              onChange: (value) async {
                                  if (value == tr('settings.alarm.sounds.pick_custom')) {
                                    await _pickCustomSound();
                                  } else if (value == tr('settings.alarm.sounds.custom_label')) {
                                     // Keep current custom sound if selected
                                     if (_fakeCallSoundId != null && 
                                        (_fakeCallSoundId!.contains('/') || _fakeCallSoundId!.contains('\\'))) {
                                       _saveSettings(soundId: _fakeCallSoundId);
                                     }
                                  } else {
                                    final soundId = AlarmSounds.getSoundIdFromDisplayName(value);
                                    _saveSettings(soundId: soundId ?? AlarmSounds.systemDefault); 
                          
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
                                if (_fakeCallSoundId != null && 
                                    !AlarmSounds.allSounds.contains(_fakeCallSoundId))
                                  AlarmSounds.getDisplayName(_fakeCallSoundId),
                                tr('settings.alarm.sounds.pick_custom'),
                              ].toSet().toList(),
                            ),
                          SizedBox(height: 24.0.h),

                          // Call Duration Dropdown
                          Opacity(
                            opacity: _fakeCallLoop ? 0.3 : 1.0,
                            child: IgnorePointer(
                              ignoring: _fakeCallLoop,
                              child: SettingsDropdown(
                                icon: LucideIcons.clock,
                                label: tr('settings.fake_call.duration'),
                                value: _getDurationString(_fakeCallDurationSeconds),
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
                          SizedBox(height: 24.0.h),

                          // Infinite Loop Toggle
                          SettingsToggle(
                            icon: LucideIcons.repeat,
                            label: tr('settings.fake_call.infinite_loop'),
                            checked: _fakeCallLoop,
                            onChange: (value) {
                              _saveSettings(loop: value);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(
                    key: ValueKey('fake_call_disabled'),
                  ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for Background Option Card
class _BackgroundOptionCard extends StatelessWidget {
  final String label;
  final String? value; // If null, it's custom
  final bool isCustom;
  final String groupValue;
  final Color? color;
  final File? backgroundImage;
  final VoidCallback onTap;

  const _BackgroundOptionCard({
    Key? key,
    required this.label,
    this.value,
    this.isCustom = false,
    required this.groupValue,
    this.color,
    this.backgroundImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Logic: Selected if values match OR if it's custom and the group value is NOT the default
    final isSelected = !isCustom 
        ? (value == groupValue)
        : (groupValue != 'Default Dark'); 

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140.w,
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? RustColors.primary : RustColors.divider,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: RustColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (backgroundImage != null)
                 Image.file(
                   backgroundImage!,
                   fit: BoxFit.cover,
                   errorBuilder: (context, error, stackTrace) {
                     return Container(
                       color: const Color(0xFF1C1C1E),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(LucideIcons.imageOff, color: RustColors.textMuted, size: 24.w),
                           SizedBox(height: 4.h),
                           FittedBox(
                             fit: BoxFit.scaleDown,
                             child: Text(
                               tr('settings.common.error'), // Can be localized if needed, usually technical
                               style: TextStyle(
                                 fontSize: 10.sp,
                                 color: RustColors.textMuted,
                               ),
                             ),
                           ),
                         ],
                       ),
                     );
                   },
                 ),
                 
              if (backgroundImage != null)
                 Container(color: Colors.black26), // Overlay for readability

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isCustom && backgroundImage == null) ...[
                       Icon(LucideIcons.plus, color: RustColors.textMuted, size: 24.w),
                       SizedBox(height: 8.h),
                    ],
                    if (backgroundImage == null)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : RustColors.textSecondary,
                            fontSize: 14.sp,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              if (isSelected)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: RustColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.check, size: 10.w, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
