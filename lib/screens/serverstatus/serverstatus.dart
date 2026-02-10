import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raidalarm/models/server_data.dart';
import 'package:raidalarm/widgets/server/status/serversearchmanager.dart';
import 'package:raidalarm/widgets/server/status/serverdetailmanager.dart';
import 'dart:convert';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';

class ServerStatusScreen extends ConsumerStatefulWidget {
  const ServerStatusScreen({super.key});

  @override
  ConsumerState<ServerStatusScreen> createState() => _ServerStatusScreenState();
}

class _ServerStatusScreenState extends ConsumerState<ServerStatusScreen> {
  ServerData? _savedServer;
  bool _wipeAlertEnabled = false;
  int _wipeAlertMinutes = 30;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedServer();
    _loadWipeAlertSettings();
  }

  Future<void> _loadSavedServer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('raid_alarm_server');
      if (!mounted) return;
      if (saved != null) {
        final decoded = jsonDecode(saved);
        setState(() {
          _savedServer = ServerData.fromJson(decoded);
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadWipeAlertSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _wipeAlertEnabled = prefs.getBool('wipe_alert_enabled') ?? false;
        _wipeAlertMinutes = prefs.getInt('wipe_alert_minutes') ?? 30;
      });
    } catch (e) {

    }
  }

  Future<void> _saveServer(ServerData? server) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (server == null) {
        await prefs.remove('raid_alarm_server');
      } else {
        final encoded = jsonEncode(server.toJson());
        await prefs.setString('raid_alarm_server', encoded);
      }
      if (!mounted) return;
      setState(() => _savedServer = server);
    } catch (e) {

    }
  }

  Future<void> _toggleWipeAlert(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('wipe_alert_enabled', enabled);
      if (!mounted) return;
      setState(() => _wipeAlertEnabled = enabled);
    } catch (e) {

    }
  }

  Future<void> _setWipeAlertMinutes(int minutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('wipe_alert_minutes', minutes);
      if (!mounted) return;
      setState(() => _wipeAlertMinutes = minutes);
    } catch (e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_loading) {
      content = const Scaffold(
        backgroundColor: Color(0xFF0C0C0E),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xFFF97316)),
          ),
        ),
      );
    } else if (_savedServer != null) {
      content = Scaffold(
        backgroundColor: Color(0xFF0C0C0E),
        body: SafeArea(
          bottom: false,
          child: ServerDetailManager(
            server: _savedServer!,
            onBack: () => _saveServer(null),
            onSaveServer: _saveServer,
            wipeAlertEnabled: _wipeAlertEnabled,
            onToggleWipeAlert: _toggleWipeAlert,
            wipeAlertMinutes: _wipeAlertMinutes,
          ),
        ),
      );
    } else {
      content = Scaffold(
        backgroundColor: const Color(0xFF0C0C0E),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C0C0E),
                  border: Border(
                    bottom: BorderSide(color: const Color(0x0DFFFFFF), width: 1.h),
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        HapticHelper.mediumImpact();
                        context.go('/stats');
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF18181B),
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(color: const Color(0xFF27272A), width: 1.w),
                        ),
                        child: Icon(
                          LucideIcons.arrowLeft,
                          size: 20.w,
                          color: const Color(0xFF71717A),
                        ),
                      ),
                    ),
                    ScreenUtilHelper.sizedBoxWidth(16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            tr('server.monitor.title'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Geist',
                            ),
                          ),
                        ),
                        ScreenUtilHelper.sizedBoxHeight(2.0),
                        FittedBox(
                          child: Text(
                            tr('server.monitor.select_server'),
                            style: TextStyle(
                              color: const Color(0xFF71717A),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.2.w,
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: ServerSearchManager(
                    onSelectServer: _saveServer,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RustScreenLayout(child: content);
  }
}
