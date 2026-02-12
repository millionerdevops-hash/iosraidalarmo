import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart'; // Added intl
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/core/utils/screen_util_helper.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:raidalarm/widgets/common/rust_screen_layout.dart';

class DieselCalculatorScreen extends ConsumerStatefulWidget {
  const DieselCalculatorScreen({super.key});

  @override
  ConsumerState<DieselCalculatorScreen> createState() => _DieselCalculatorScreenState();
}

class _DieselCalculatorScreenState extends ConsumerState<DieselCalculatorScreen> {
  final TextEditingController _dieselController = TextEditingController(text: '1');
  String _selectedMachineId = 'excavator';
  String _selectedFuelType = 'Diesel'; // 'Diesel' | 'LowGrade'

  // Added _handleBack method
  void _handleBack() {
    if (!mounted) return;
    if (mounted) context.pop();
  }

  // Resource Images mapping (Local Assets)
  static const Map<String, String> _resourceImages = {
    'diesel': 'assets/images/png/ingame/diesel-calculator/diesel-barrel.png',
    'sulfur': 'assets/images/png/ingame/diesel-calculator/sulfur-ore.png',
    'hqm': 'assets/images/png/ingame/diesel-calculator/hq-metal-ore.png',
    'metal_frags': 'assets/images/png/ingame/diesel-calculator/metal-fragments.png',
    'stones': 'assets/images/png/ingame/diesel-calculator/stones.png',
    'metal_ore': 'assets/images/png/ingame/diesel-calculator/metal-ore.png',
    'crude_oil': 'assets/images/png/ingame/diesel-calculator/crude-oil.png', // Updated
    'low_grade': 'assets/images/png/ingame/diesel-calculator/lowgradefuel.png', // Updated
  };

  // Machine Data
  final List<Map<String, dynamic>> _machines = [
    // --- DIESEL MACHINES ---
    {
      'id': 'excavator',
      'label': 'diesel_calculator.machines.excavator',
      'fuelType': 'Diesel',
      'type': 'diesel_calculator.machines.types.monument',
      'color': const Color(0xFFF97316), // orange-500
      'bg': const Color(0x1AF97316), // orange-500/10
      'border': const Color(0x7FF97316), // orange-500/50
      'runtimeSeconds': 120, // 2 min
      'ratePerFuel': {
        'sulfur': 2000,
        'hqm': 100,
        'metal_frags': 5000,
        'stones': 10000
      }
    },
    {
      'id': 'hqm_quarry',
      'label': 'diesel_calculator.machines.hqm_quarry',
      'fuelType': 'Diesel',
      'type': 'diesel_calculator.machines.types.static',
      'color': const Color(0xFFD4D4D8), // zinc-300
      'bg': const Color(0x1A71717A), // zinc-500/10
      'border': const Color(0x7F71717A), // zinc-500/50
      'runtimeSeconds': 130, // 2 min 10 sec
      'ratePerFuel': {'hqm': 50}
    },
    {
      'id': 'sulfur_quarry',
      'label': 'diesel_calculator.machines.sulfur_quarry',
      'fuelType': 'Diesel',
      'type': 'diesel_calculator.machines.types.static',
      'color': const Color(0xFFFACC15), // yellow-400
      'bg': const Color(0x1AEAB308), // yellow-500/10
      'border': const Color(0x7FEAB308), // yellow-500/50
      'runtimeSeconds': 130, // 2 min 10 sec
      'ratePerFuel': {'sulfur': 1000}
    },
    {
      'id': 'stone_quarry',
      'label': 'diesel_calculator.machines.stone_quarry',
      'fuelType': 'Diesel',
      'type': 'diesel_calculator.machines.types.static',
      'color': const Color(0xFFA1A1AA), // zinc-400
      'bg': const Color(0x1A52525B), // zinc-600/10
      'border': const Color(0x7F52525B), // zinc-600/10
      'runtimeSeconds': 130, // 2 min 10 sec
      'ratePerFuel': {'stones': 5000, 'metal_ore': 1000}
    },
    {
      'id': 'pump_jack',
      'label': 'diesel_calculator.machines.pump_jack',
      'fuelType': 'Diesel',
      'type': 'diesel_calculator.machines.types.static',
      'color': const Color(0xFFEF4444), // red-500
      'bg': const Color(0x1AEF4444), // red-500/10
      'border': const Color(0x7FEF4444), // red-500/50
      'runtimeSeconds': 130, // 2 min 10 sec
      'ratePerFuel': {'crude_oil': 28} // Updated per React code in Step 422 analysis
    },
    
    // --- LOW GRADE MACHINES ---
    {
      'id': 'deploy_pump_jack',
      'label': 'diesel_calculator.machines.deploy_pump_jack',
      'fuelType': 'LowGrade',
      'type': 'diesel_calculator.machines.types.deployable',
      'color': const Color(0xFFEF4444), // red-500
      'bg': const Color(0x1AEF4444), // red-500/10
      'border': const Color(0x7FEF4444), // red-500/50
      'runtimeSeconds': 10, // 0.1666 min * 60 = 10 sec
      'ratePerFuel': {'crude_oil': 1}
    },
    {
      'id': 'deploy_quarry',
      'label': 'diesel_calculator.machines.deploy_quarry',
      'fuelType': 'LowGrade',
      'type': 'diesel_calculator.machines.types.deployable',
      'color': const Color(0xFFA1A1AA), // zinc-400
      'bg': const Color(0x1A52525B), // zinc-600/10
      'border': const Color(0x7F52525B), // zinc-600/10
      'runtimeSeconds': 10, // 10 sec
      'ratePerFuel': {'stones': 5, 'metal_ore': 1, 'sulfur': 0.5, 'hqm': 0.1}
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  void _changeFuelType(String type) {
    if (_selectedFuelType == type) return;
    
    HapticHelper.mediumImpact();
    
    setState(() {
      _selectedFuelType = type;
      // Select first machine of new type
      _selectedMachineId = _machines.firstWhere((m) => m['fuelType'] == type)['id'];
      
      // Reset input amount based on logical defaults (1 for Diesel, 100 for LGF)
      if (type == 'Diesel') {
        _dieselController.text = '1';
      } else {
        _dieselController.text = '100';
      }
    });
  }

  String _formatNumber(num number) {
    if (number > 10000) return '${(number/1000).toStringAsFixed(1)}k';
    return NumberFormat.decimalPattern().format(number);
  }

  String _formatTime(int seconds) {
    if (seconds < 60) return tr('settings.common.durations.sec_short', args: [seconds.toString()]);
    final h = (seconds / 3600).floor();
    final m = ((seconds % 3600) / 60).round(); // round to match React logic
    
    String result = '';
    if (h > 0) result += tr('settings.common.durations.hour_short', args: [h.toString()]) + ' ';
    if (m > 0) result += tr('settings.common.durations.min_short', args: [m.toString()]) + ' ';
    return result.trim().isEmpty ? tr('settings.common.durations.min_short', args: ['0']) : result.trim();
  }

  void _addAmount(int amount) {
    HapticHelper.mediumImpact();
    int current = int.tryParse(_dieselController.text) ?? 0;
    _dieselController.text = (current + amount).toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Filter machines by fuel type
    final activeMachines = _machines.where((m) => m['fuelType'] == _selectedFuelType).toList();
    
    // Ensure selected machine is valid
    Map<String, dynamic> activeMachine;
    try {
      activeMachine = activeMachines.firstWhere((m) => m['id'] == _selectedMachineId);
    } catch (_) {
      activeMachine = activeMachines.first;
      _selectedMachineId = activeMachine['id'];
    }

    final fuelCount = double.tryParse(_dieselController.text) ?? 0;
    final totalRuntimeSeconds = (fuelCount * (activeMachine['runtimeSeconds'] as int)).toInt();
    
    final isDiesel = _selectedFuelType == 'Diesel';
    final fuelColor = isDiesel ? const Color(0xFFEAB308) : const Color(0xFFEF4444); // Yellow vs Red
    final fuelBgColor = isDiesel ? const Color(0xFF422006) : const Color(0xFF450A0A); // Yellow-900/20 vs Red-900/20 approx
    final fuelBorderColor = isDiesel ? const Color(0xFFFAAF00) : const Color(0xFFF87171); // Yellow-500 approx vs Red-500

    return RustScreenLayout(
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0C0E),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                height: 64.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.05),
                      width: 1.w,
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(LucideIcons.arrowLeft, color: const Color(0xFFA1A1AA), size: 24.w),
                        onPressed: () {
                          HapticHelper.mediumImpact();
                          _handleBack();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48.w),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tr('diesel_calculator.title'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RustFont',
                              letterSpacing: 1.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fuel Type Toggle
                      Container(
                        margin: EdgeInsets.only(bottom: 24.h),
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF18181B),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFF27272A), width: 1.w),
                        ),
                        child: Row(
                          children: [
                             _buildFuelTypeBtn('Diesel', LucideIcons.fuel, const Color(0xFFEAB308)),
                            _buildFuelTypeBtn('LowGrade', LucideIcons.droplets, const Color(0xFFEF4444)),
                          ],
                        ),
                      ),

                      // Input Section
                      Container(
                        padding: EdgeInsets.all(16.w), // Reduced from 20.w
                        margin: EdgeInsets.only(bottom: 24.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121214),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: fuelBorderColor.withOpacity(0.3), width: 1.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            // Label & Runtime
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 FittedBox(
                                  child: Text(
                                    tr('diesel_calculator.input_amount'),
                                    style: TextStyle(
                                      color: const Color(0xFF71717A),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5.w,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: fuelBgColor,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: fuelBorderColor.withOpacity(0.3), width: 1.w),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(LucideIcons.clock, size: 12.w, color: fuelColor),
                                      ScreenUtilHelper.sizedBoxWidth(4),
                                      FittedBox(
                                        child: Text(
                                          tr('diesel_calculator.runtime', args: [_formatTime(totalRuntimeSeconds)]),
                                          style: TextStyle(
                                            color: fuelColor,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GeistMono',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ScreenUtilHelper.sizedBoxHeight(12),

                            // Input Field
                            Row(
                              children: [
                                Container(
                                  width: 56.w, // Proportionally reduced from 68.w
                                  height: 56.w,
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF18181B),
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(color: const Color(0xFF3F3F46), width: 1.w),
                                  ),
                                   child: Image.asset(
                                    _resourceImages[isDiesel ? 'diesel' : 'low_grade']!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                ScreenUtilHelper.sizedBoxWidth(16),
                                Expanded(
                                  child: TextField(
                                    controller: _dieselController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    onChanged: (_) => setState(() {}),
                                    style: TextStyle(
                                      fontSize: 24.sp, // Reduced from 30.sp
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontFamily: 'GeistMono',
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      filled: true,
                                      fillColor: const Color(0xFF18181B),
                                       hintText: tr('diesel_calculator.placeholder'),
                                      hintStyle: TextStyle(
                                        color: const Color(0xFF52525B),
                                        fontSize: 24.sp, // Reduced from 30.sp
                                        fontWeight: FontWeight.w900,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h), // Reduced from 12.h
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: BorderSide(color: const Color(0xFF3F3F46), width: 1.w),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: BorderSide(color: const Color(0xFF3F3F46), width: 1.w),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: BorderSide(color: fuelColor, width: 1.w),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            ScreenUtilHelper.sizedBoxHeight(16),

                            // Quick Add Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [1, 10, 50, 100].map((amount) {
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Material(
                                      color: const Color(0xFF27272A),
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: InkWell(
                                        onTap: () => _addAmount(amount),
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 8.h),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color(0xFF3F3F46), width: 1.w),
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          child: Center(
                                            child: FittedBox(
                                              child: Text(
                                                '+$amount',
                                                style: TextStyle(
                                                  color: const Color(0xFFD4D4D8),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      // Machine Selector
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              FittedBox(
                              child: Text(
                                tr('diesel_calculator.select_machine'),
                                style: TextStyle(
                                  color: const Color(0xFF71717A),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5.w,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 2.2,
                        ),
                        itemCount: activeMachines.length,
                        itemBuilder: (context, index) {
                          final machine = activeMachines[index];
                          final isSelected = _selectedMachineId == machine['id'];
                          // Use active colors if selected, otherwise muted
                          final Color mainColor = isSelected
                              ? (isDiesel ? const Color(0xFFEAB308) : const Color(0xFFEF4444))
                              : const Color(0xFF71717A);
                          final Color borderColor = isDiesel ? const Color(0xFFEAB308) : const Color(0xFFEF4444);

                          return GestureDetector(
                            onTap: () {
                              HapticHelper.mediumImpact();
                              setState(() => _selectedMachineId = machine['id']);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF18181B) : const Color(0x6618181B),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isSelected ? borderColor : const Color(0xFF27272A),
                                  width: 1.w,
                                ),
                                boxShadow: isSelected
                                    ? [BoxShadow(color: borderColor.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))]
                                    : null,
                              ),
                              child: Stack(
                                children: [
                                  if (isSelected)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: borderColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                      ),
                                    ),
                                  Center(
                                    child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                          FittedBox(
                                            child: Text(
                                              tr(machine['label']),
                                              style: TextStyle(
                                                color: isSelected ? Colors.white : const Color(0xFFA1A1AA),
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        if (machine.containsKey('type'))
                                          Padding(
                                            padding: EdgeInsets.only(top: 2.h),
                                            child: FittedBox(
                                              child: Text(
                                                tr(machine['type']),
                                                style: TextStyle(
                                                  color: isSelected ? mainColor : const Color(0xFF52525B),
                                                  fontSize: 9.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                       ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 6.h,
                                      right: 6.w,
                                      child: Container(
                                        padding: EdgeInsets.all(2.w),
                                        decoration: BoxDecoration(
                                          color: isDiesel ? const Color(0xFFEAB308) : const Color(0xFFEF4444),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(LucideIcons.check, size: 10.w, color: Colors.black),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      ScreenUtilHelper.sizedBoxHeight(32),

                      // Output Section
                      Row(
                        children: [
                          Icon(LucideIcons.trendingUp, size: 16.w, color: isDiesel ? const Color(0xFF22C55E) : const Color(0xFFF97316)),
                          ScreenUtilHelper.sizedBoxWidth(8),
                          FittedBox(
                            child: Text(
                              isDiesel ? tr('diesel_calculator.total_output') : tr('diesel_calculator.estimated_yield'),
                              style: TextStyle(
                                color: const Color(0xFFA1A1AA),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ScreenUtilHelper.sizedBoxHeight(12),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (activeMachine['ratePerFuel'] as Map<String, num>).length,
                        itemBuilder: (context, index) {
                          final entry = (activeMachine['ratePerFuel'] as Map<String, num>).entries.toList()[index];
                          final resource = entry.key;
                          final rate = entry.value;

                          if (rate == 0) return const SizedBox.shrink();

                          final total = rate * fuelCount;

                          // Style determiner based on resource
                          Color textColor = Colors.white;
                          Color borderColor = const Color(0xFF27272A);
                          Color? bgGlow;

                          if (resource.contains('Sulfur')) {
                            textColor = const Color(0xFFFACC15); // yellow-400
                            borderColor = const Color(0x4DEAB308); // yellow-500/30
                            bgGlow = const Color(0x0DEAB308); // yellow-500/5
                          } else if (resource.contains('HQM')) {
                            textColor = const Color(0xFFD4D4D8); // zinc-300
                            borderColor = const Color(0xFF52525B); // zinc-600
                          } else if (resource.contains('Metal Frags') || resource.contains('Metal Ore')) {
                            textColor = const Color(0xFF93C5FD); // blue-300
                            borderColor = const Color(0x4D3B82F6); // blue-500/30
                            bgGlow = const Color(0x0D3B82F6); // blue-500/5
                          } else if (resource.contains('Crude')) {
                            textColor = const Color(0xFFEF4444); // red-500
                            borderColor = const Color(0x4DEF4444);
                            bgGlow = const Color(0x0DEF4444);
                          }

                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF121214),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: borderColor, width: 1.w),
                              boxShadow: bgGlow != null ? [BoxShadow(color: bgGlow, blurRadius: 10)] : null,
                            ),
                            child: Stack(
                              children: [
                                if (bgGlow != null)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: bgGlow,
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 48.w,
                                            height: 48.w,
                                            padding: EdgeInsets.all(4.w),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.4),
                                              borderRadius: BorderRadius.circular(12.r),
                                              border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.w),
                                            ),
                                             child: Image.asset(
                                              _resourceImages[resource]!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          ScreenUtilHelper.sizedBoxWidth(16),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  tr('diesel_calculator.resources.$resource'),
                                                  style: TextStyle(
                                                    color: const Color(0xFF71717A),
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.0.w,
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  _formatNumber(total),
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily: 'GeistMono', // Monospace
                                                    letterSpacing: -0.5.w,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(6.r),
                                            border: Border.all(color: const Color(0xFF27272A), width: 1.w),
                                          ),
                                           child: FittedBox(
                                             child: Text(
                                               isDiesel
                                                   ? tr('diesel_calculator.per_barrel', args: [rate.toString()])
                                                   : tr('diesel_calculator.per_lgf', args: [rate.toString()]),
                                               style: TextStyle(
                                                 color: const Color(0xFFA1A1AA),
                                                 fontSize: 10.sp,
                                                 fontWeight: FontWeight.w600,
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
                        },
                      ),
                        ],
                      ),
                    ),
                  ),

            ],
          ),
        ),
      ),
    );
  }


  Widget _buildFuelTypeBtn(String type, IconData icon, Color color) {
    final isSelected = _selectedFuelType == type;
    final label = type == 'Diesel' ? tr('diesel_calculator.fuel_types.diesel') : tr('diesel_calculator.fuel_types.low_grade');

    return Expanded(
      child: GestureDetector(
        onTap: () => _changeFuelType(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          margin: EdgeInsets.symmetric(horizontal: isSelected ? 0 : 2.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF27272A) : Colors.transparent, // Highlight active
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.5) : Colors.transparent,
              width: 1.w,
            ),
            boxShadow: isSelected 
              ? [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8)] 
              : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.w, color: isSelected ? color : const Color(0xFF71717A)),
              ScreenUtilHelper.sizedBoxWidth(8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: isSelected ? color : const Color(0xFF71717A),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
