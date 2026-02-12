import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/widgets/common/rust_button.dart';
import 'package:raidalarm/features/auth/steam_login_screen.dart';
import 'package:raidalarm/features/home/server_list_view_model.dart';
import 'package:raidalarm/data/models/server_info.dart';
import 'package:go_router/go_router.dart';
import 'package:raidalarm/core/services/api_service.dart';
import 'package:raidalarm/features/dashboard/server_dashboard_view_model.dart';
import 'package:raidalarm/features/dashboard/connection_provider.dart';
import 'package:raidalarm/data/models/smart_device.dart';
import 'package:raidalarm/core/services/database_service.dart';
import 'package:raidalarm/data/models/steam_credential.dart';
import 'package:isar/isar.dart';
import 'package:raidalarm/core/proto/rustplus.pb.dart' hide Color;
import 'package:raidalarm/core/proto/rustplus.pbenum.dart';
import 'package:raidalarm/core/theme/rust_colors.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';


class PairDevicesScreen extends ConsumerStatefulWidget {
  const PairDevicesScreen({super.key});

  @override
  ConsumerState<PairDevicesScreen> createState() => _PairDevicesScreenState();
}

class _PairDevicesScreenState extends ConsumerState<PairDevicesScreen> with WidgetsBindingObserver {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Wake up backend to ensure smooth pairing
    ApiService.wakeUpBackend();
    
    WidgetsBinding.instance.addObserver(this);
    _checkLoginStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serverListViewModelProvider.notifier).scanForServers(); // Check on init
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh list when app comes to foreground (e.g. after pairing in browser/game)
      ref.read(serverListViewModelProvider.notifier).scanForServers();
    }
  }

  Future<void> _checkLoginStatus() async {
    final dbService = DatabaseService();
    final isar = await dbService.db;
    final creds = await isar.collection<SteamCredential>().get(1);
    if (mounted) {
      setState(() {
        _isLoggedIn = creds != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverListAsync = ref.watch(serverListViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0E),
      body: RustScreenLayout(
        child: SafeArea(
          bottom: false,
          child: serverListAsync.when(
            data: (servers) {
              int? serverId;
              if (servers.isNotEmpty) {
                 serverId = servers.first.id;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildHeader(context, serverId),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (servers.isNotEmpty) {
                           final serverInfo = servers.first;
                           final currentServerId = serverInfo.id;
                           final devicesAsync = ref.watch(serverDashboardViewModelProvider(currentServerId));

                           return Column(
                             children: [
                               Padding(
                                 padding: EdgeInsets.symmetric(horizontal: 16.w),
                                 child: Column(
                                   children: [
                                     SizedBox(height: 16.h),
                                     // Simplified Server Card
                                     Container(
                                       width: double.infinity,
                                       padding: EdgeInsets.all(16.w),
                                       decoration: BoxDecoration(
                                         color: const Color(0xFF171717), // RustColors.cardBackground
                                         borderRadius: BorderRadius.circular(12.r),
                                         border: Border.all(
                                           color: Colors.white.withOpacity(0.05),
                                           width: 1.h,
                                         ),
                                       ),
                                       child: Row(
                                         children: [
                                           // Online Indicator
                                           Container(
                                             width: 8.w,
                                             height: 8.w,
                                             decoration: const BoxDecoration(
                                               color: Color(0xFF4ADE80), // Green for Online
                                               shape: BoxShape.circle,
                                             ),
                                           ),
                                           SizedBox(width: 12.w),
                                           // Server Name
                                           Expanded(
                                             child: Text(
                                               serverInfo.name ?? "Unknown Server",
                                               style: RustTypography.titleMedium.copyWith(
                                                 color: Colors.white,
                                                 fontWeight: FontWeight.w600,
                                               ),
                                               maxLines: 1,
                                               overflow: TextOverflow.ellipsis,
                                             ),
                                           ),
                                           // Delete Button
                                           IconButton(
                                             icon: const Icon(LucideIcons.trash2, color: RustColors.textMuted),
                                             onPressed: () => _showServerDeleteConfirmation(context, ref, serverInfo),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                               
                               // Device List from Dashboard Body
                               Expanded(
                                 child: devicesAsync.when(
                                  data: (devices) {
                                    if (devices.isEmpty) {
                                      // Show Connect Devices Placeholder if no devices
                                      return _buildConnectUI(context, isServerPaired: true);
                                    }
                                    return ListView.separated(
                                      padding: EdgeInsets.all(16.w),
                                      itemCount: devices.length,
                                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                                      itemBuilder: (context, index) {
                                        final device = devices[index];
                                        return _buildDeviceCard(context, ref, device, currentServerId);
                                      },
                                    );
                                  },
                                  loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFCE422B))),
                                  error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: RustColors.error))),
                                ),
                               ),
                             ],
                           );
                        } else {
                          // Case 1 & 2: No Server
                          return _buildConnectUI(context, isServerPaired: false);
                        }
                      }
                    ),
                  ),
                ],
              );
            },
            loading: () => Column(
              children: [
                _buildHeader(context, null),
                const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFFCE422B)))),
              ],
            ),
            error: (err, stack) => Column(
               children: [
                 _buildHeader(context, null),
                 Expanded(child: _buildConnectUI(context, isServerPaired: false)),
               ],
             ),
          ),
        ),
      ),
    );
  }

  // --- Dashboard Logic Methods ---

  Widget _buildDeviceCard(BuildContext context, WidgetRef ref, SmartDevice device, int serverId) {
    Color statusColor = RustColors.textMuted;
    String statusText = "OFF";
    bool isActive = device.isActive;

    if (isActive) {
      statusColor = RustColors.accent; // Orange-ish for ON
      statusText = "ON";
    }

    if (device.type == AppEntityType.Alarm) {
       statusText = isActive ? "ALARMING" : "INACTIVE";
       statusColor = isActive ? RustColors.error : RustColors.textMuted;
    }

    return GestureDetector(
      onLongPress: () => _showDeleteConfirmation(context, ref, device),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: RustColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: isActive ? Border(left: BorderSide(color: statusColor, width: 4.w)) : Border.all(color: RustColors.divider),
        ),
        child: Row(
          children: [
            // Icon
            Container(
               padding: EdgeInsets.all(8.w),
               child: _getImageForType(device.type),
            ),
            SizedBox(width: 16.w),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      device.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: RustColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            
            // Action (Switch)
            if (device.type == AppEntityType.Switch)
              Switch(
                value: isActive,
                activeTrackColor: RustColors.primaryDark,
                activeColor: RustColors.primary,
                onChanged: (val) async {
                   final managerAsync = ref.read(connectionManagerProvider(serverId));
                   if (managerAsync.hasValue) {
                     try {
                       await managerAsync.value!.setEntityValue(device.entityId, val);
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${device.name} ${val ? 'ON' : 'OFF'}")));
                     } catch (e) {
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
                     }
                   }
                },
              ),
            if (device.type == AppEntityType.StorageMonitor)
              const Icon(Icons.chevron_right, color: RustColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _getImageForType(AppEntityType type) {
    String assetName = 'smart-switch.png';
    switch (type) {
      case AppEntityType.Switch: assetName = 'smart-switch.png'; break;
      case AppEntityType.Alarm: assetName = 'smart-alarm.png'; break;
      default: assetName = 'smart-switch.png';
    }
    return Image.asset('assets/png/ingame/pairing/$assetName', width: 48.w, height: 48.w, errorBuilder: (c,e,s) => const Icon(LucideIcons.zap, size: 32, color: Colors.white));
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, SmartDevice device) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RustColors.surface,
        title: const Text("Delete Device", style: TextStyle(color: RustColors.textPrimary)),
        content: Text("Are you sure you want to delete '${device.name}'?", style: const TextStyle(color: RustColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL", style: TextStyle(color: RustColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final dbService = DatabaseService();
              final isar = await dbService.db;
              await isar.writeTxn(() async {
                await isar.smartDevices.delete(device.id);
              });
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Deleted ${device.name}"), backgroundColor: RustColors.surface),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: RustColors.error),
            child: const Text("DELETE"),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectUI(BuildContext context, {required bool isServerPaired}) {
    // Determine Text and Button state
    String title;
    String subtitle;
    bool showButton;

    if (isServerPaired) {
      title = "Connect Devices";
      subtitle = "Connect your smart devices to start monitoring your servers.";
      showButton = false; 
    } else if (_isLoggedIn) {
      title = "Connect Server";
      subtitle = "Go in-game and pair your server. Connection will be established automatically.";
      showButton = false;
    } else {
      title = "Connect Devices"; 
      subtitle = "Login with Steam to connect devices and monitor servers.";
      showButton = true;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.bluetooth,
            size: 48.w,
            color: const Color(0xFF52525B),
          ),
          SizedBox(height: 24.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: RustTypography.titleLarge.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: RustTypography.bodyMedium.copyWith(
                fontSize: 14.sp,
                color: const Color(0xFF71717A),
              ),
            ),
          ),
          
          if (showButton) ...[
            SizedBox(height: 32.h),

            // Steam Login Button
            RustButton.primary(
              width: 200.w,
              onPressed: () {
                // Navigate to Steam Login (Full Screen)
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => SteamLoginScreen(
                      onSuccess: () {
                        Navigator.of(context).pop();
                        _checkLoginStatus(); // Re-check login status
                        ref.read(serverListViewModelProvider.notifier).scanForServers();
                      },
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.gamepad2, size: 20.w, color: Colors.white),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('STEAM LOGIN', style: TextStyle(fontSize: 14.sp)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int? serverId) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0E), // RustColors.background
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1.h,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered Logo
          Center(
            child: Image.asset(
              'assets/logo/raidalarm-logo2.png',
              height: 80.w,
              fit: BoxFit.contain,
              cacheWidth: 160,
            ),
          ),
          
          // Action Buttons (Right)
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                
                // Settings Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticHelper.mediumImpact();
                      context.push('/settings');
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.settings,
                        size: 20.w,
                        color: const Color(0xFFA1A1AA),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showServerDeleteConfirmation(BuildContext context, WidgetRef ref, ServerInfo server) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RustColors.surface,
        title: const Text("Delete Server", style: TextStyle(color: RustColors.textPrimary)),
        content: Text("Are you sure you want to disconnect '${server.name}'? You will need to pair it again to reconnect.", style: const TextStyle(color: RustColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL", style: TextStyle(color: RustColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(serverListViewModelProvider.notifier).deleteServer(server.id);
            },
            style: TextButton.styleFrom(foregroundColor: RustColors.error),
            child: const Text("DISCONNECT"),
          ),
        ],
      ),
    );
  }
}
