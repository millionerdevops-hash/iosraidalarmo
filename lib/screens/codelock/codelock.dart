import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/widgets/ads/banner_ad_widget.dart';
import 'package:raidalarm/services/ad_service.dart';
import 'package:raidalarm/providers/scrap_provider.dart';

enum GameState { playing, won, lost }

class CodeBreakerScreen extends ConsumerStatefulWidget {
  const CodeBreakerScreen({super.key});

  @override
  ConsumerState<CodeBreakerScreen> createState() => _CodeBreakerScreenState();
}

class _CodeBreakerScreenState extends ConsumerState<CodeBreakerScreen> with SingleTickerProviderStateMixin {
  static const int maxAttempts = 8;
  static const int baseReward = 500;

  String _targetCode = '';
  String _currentGuess = '';
  int _attempts = 0;
  GameState _gameState = GameState.playing;
  List<Map<String, dynamic>> _history = [];
  bool _shocked = false;
  int _wonAmount = 0;
  
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _startNewGame();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _startNewGame() {
    setState(() {
      _targetCode = _generateCode();
      _currentGuess = '';
      _attempts = 0;
      _gameState = GameState.playing;
      _history = [];
      _shocked = false;
      _wonAmount = 0;
    });
  }

  String _generateCode() {
    return Random().nextInt(10000).toString().padLeft(4, '0');
  }

  void _handleInput(String num) {
    if (_gameState != GameState.playing) return;
    if (_currentGuess.length < 4) {
      HapticHelper.soft();
      setState(() {
        _currentGuess += num;
      });
    }
  }

  void _handleClear() {
    if (_gameState != GameState.playing) return;
    HapticHelper.selection();
    setState(() {
      _currentGuess = '';
    });
  }

  void _handleQuickCode(String code) {
    if (_gameState != GameState.playing) return;
    setState(() {
      _currentGuess = code;
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      _executeSubmit(code);
    });
  }

  void _executeSubmit(String guess) {
    if (guess.length != 4) return;
    HapticHelper.mediumImpact();

    setState(() {
      _attempts++;
      
      final result = List.filled(4, 'R'); // Red
      final targetArr = _targetCode.split('');
      final guessArr = guess.split('');
      final targetUsed = List.filled(4, false);
      final guessUsed = List.filled(4, false);

      // 1. Exact Matches (Green)
      for (int i = 0; i < 4; i++) {
        if (guessArr[i] == targetArr[i]) {
          result[i] = 'G';
          targetUsed[i] = true;
          guessUsed[i] = true;
        }
      }

      // 2. Wrong Position (Yellow)
      for (int i = 0; i < 4; i++) {
        if (!guessUsed[i]) {
          for (int j = 0; j < 4; j++) {
            if (!targetUsed[j] && guessArr[i] == targetArr[j]) {
              result[i] = 'Y';
              targetUsed[j] = true;
              break;
            }
          }
        }
      }

      _history.insert(0, {'guess': guess, 'result': result});

      if (guess == _targetCode) {
        HapticHelper.success();
        _gameState = GameState.won;
        _wonAmount = max(50, baseReward - ((_attempts - 1) * 50));
        ref.read(scrapProvider.notifier).addScrap(_wonAmount);
      } else {
        _currentGuess = '';
        _triggerShock();
        if (_attempts >= maxAttempts) {
          _gameState = GameState.lost;
        }
      }
    });
  }

  void _triggerShock() {
    HapticHelper.heavyImpact();
    setState(() => _shocked = true);
    _shakeController.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _shocked = false);
    });
  }

  void _watchAdForCoins() {
    HapticHelper.soft();
    AdService().showRewardedAd(
      onRewarded: (amount) {
        if (!mounted) return;
        ref.read(scrapProvider.notifier).addScrap(1000);
        HapticHelper.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tr('tools.match_game.earned_coins', args: ['1000']),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF10B981), // Green
            duration: const Duration(seconds: 2),
          ),
        );
      },
      onAdClosed: () {
        debugPrint('Rewarded ad closed');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrapBalance = ref.watch(scrapProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0E),
      body: RustScreenLayout(
        child: SafeArea(
          bottom: true,
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(scrapBalance),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                      child: Column(
                        children: [
                          _buildLockUnit(),
                          SizedBox(height: 32.h),
                          _buildHistoryTerminal(),
                        ],
                      ),
                    ),
                  ),
                  const BannerAdWidget(),
                ],
              ),
              if (_shocked)
                Container(
                  color: Colors.red.withOpacity(0.2),
                  width: double.infinity,
                  height: double.infinity,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int scrapBalance) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0E),
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
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                HapticHelper.mediumImpact();
                context.go('/tools');
              },
              icon: Icon(Icons.arrow_back, color: const Color(0xFFA1A1AA), size: 24.w),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      tr('tools.code_raider.title').toUpperCase(),
                      style: RustTypography.rustStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: scrapBalance < 25
                ? GestureDetector(
                    onTap: _watchAdForCoins,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.play, color: Colors.white, size: 14.w),
                          SizedBox(width: 4.w),
                          Text(
                            '+1000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFF27272A)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    scrapBalance.toString(),
                    style: TextStyle(
                      color: const Color(0xFFEAB308),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(LucideIcons.coins, color: const Color(0xFFCA8A04), size: 14.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockUnit() {
    final offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.02, 0),
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          return Transform.translate(
            offset: _shocked ? offsetAnimation.value * 100 : Offset.zero,
            child: child,
          );
        },
        child: Column(
          children: [
          // Top Housing
          Container(
            width: 280.w,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              border: Border.all(color: const Color(0xFF1A1A1A), width: 6.w),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              children: [
                // Status LED
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: _gameState == GameState.won 
                        ? Colors.green 
                        : (_gameState == GameState.lost ? Colors.red : const Color(0xFF450A0A)),
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (_gameState != GameState.playing)
                        BoxShadow(
                          color: _gameState == GameState.won ? Colors.green : Colors.red,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Screen
                Container(
                  height: 70.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF151515), width: 4.w),
                    boxShadow: [
                      BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 1, spreadRadius: 1),
                    ],
                  ),
                  child: Center(
                    child: _gameState == GameState.playing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (i) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Text(
                                _currentGuess.length > i ? _currentGuess[i] : '*',
                                style: TextStyle(
                                  color: const Color(0xFFDC2626),
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  shadows: [
                                    Shadow(color: const Color(0xFFDC2626).withOpacity(0.8), blurRadius: 10),
                                  ],
                                ),
                              ),
                            )),
                          )
                        : Text(
                            _gameState == GameState.won ? 'OPEN' : _targetCode,
                            style: TextStyle(
                              color: _gameState == GameState.won ? const Color(0xFF22C55E) : const Color(0xFFDC2626),
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              letterSpacing: 8.w,
                              shadows: [
                                Shadow(
                                  color: (_gameState == GameState.won ? const Color(0xFF22C55E) : const Color(0xFFDC2626)).withOpacity(0.8),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Power Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: Text(
                        tr('tools.code_raider.battery_level'),
                        style: TextStyle(color: const Color(0xFF52525B), fontSize: 8.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: List.generate(maxAttempts, (i) => Container(
                        width: 12.w,
                        height: 4.h,
                        margin: EdgeInsets.only(left: 3.w),
                        decoration: BoxDecoration(
                          color: i < (maxAttempts - _attempts) ? const Color(0xFF16A34A) : const Color(0xFF3F3F46),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _gameState == GameState.playing ? _buildKeypad() : _buildResultCard(),
        ],
      ),
    ));
  }

  Widget _buildKeypad() {
    return Container(
      width: 280.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        border: Border(
          left: BorderSide(color: const Color(0xFF1A1A1A), width: 6.w),
          right: BorderSide(color: const Color(0xFF1A1A1A), width: 6.w),
          bottom: BorderSide(color: const Color(0xFF1A1A1A), width: 6.w),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF27272A)),
        ),
        child: RepaintBoundary(
          child: GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            children: [
              ...List.generate(9, (index) => _buildKeyItem((index + 1).toString())),
              _buildActionKey(tr('tools.code_raider.clear'), const Color(0xFF7F1D1D), const Color(0xFF450A0A), _handleClear),
              _buildKeyItem('0'),
              _buildActionKey(tr('tools.code_raider.enter'), const Color(0xFF15803D), const Color(0xFF14532D), () => _executeSubmit(_currentGuess)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyItem(String val) {
    return GestureDetector(
      onTap: () => _handleInput(val),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF27272A),
          borderRadius: BorderRadius.circular(8.r),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
          boxShadow: const [BoxShadow(color: Color(0xFF18181B), offset: Offset(0, 4))],
        ),
        child: Center(
          child: Text(
            val,
            style: TextStyle(color: const Color(0xFFE4E4E7), fontSize: 22.sp, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey(String label, Color color, Color shadowColor, VoidCallback onTap) {
    bool disabled = label == 'ENTER' && _currentGuess.length != 4;
    return GestureDetector(
      onTap: disabled ? null : () {
        HapticHelper.mediumImpact();
        onTap();
      },
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.r),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            boxShadow: [BoxShadow(color: shadowColor, offset: const Offset(0, 4))],
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    bool won = _gameState == GameState.won;
    return Container(
      width: 280.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        border: Border(
          left: BorderSide(color: const Color(0xFF1A1A1A), width: 6.w),
          right: BorderSide(color: const Color(0xFF1A1A1A), width: 6.w),
          bottom: BorderSide(color: const Color(0xFF1A1A1A), width: 6.w),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: won ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: (won ? Colors.green : Colors.red).withOpacity(0.5), width: 2.w),
            ),
            child: Icon(won ? LucideIcons.lockOpen : LucideIcons.shieldAlert, color: won ? Colors.green : Colors.red, size: 32.w),
          ),
          SizedBox(height: 16.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              won ? tr('tools.code_raider.access_granted') : tr('tools.code_raider.system_lockout'),
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ),
          SizedBox(height: 4.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              won ? tr('tools.code_raider.reward_scrap', args: [_wonAmount.toString()]) : tr('tools.code_raider.code_changed'),
              style: TextStyle(color: won ? Colors.green : const Color(0xFF71717A), fontSize: 12.sp, fontFamily: 'monospace'),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startNewGame,
              icon: Icon(LucideIcons.refreshCw, size: 16.w),
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(won ? tr('tools.code_raider.hack_another') : tr('tools.code_raider.retry_hack')),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAB308),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTerminal() {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF27272A)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: RepaintBoundary(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.terminal, color: const Color(0xFF22C55E), size: 14.w),
                          SizedBox(width: 8.w),
                          Text(
                            'CODE_LOCK',
                            style: TextStyle(color: const Color(0xFF22C55E), fontSize: 9.sp, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF18181B)),
                  SizedBox(height: 8.h),
                  if (_history.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Text(
                        tr('tools.code_raider.waiting_input'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: const Color(0xFF3F3F46), fontSize: 11.sp, fontFamily: 'monospace', fontStyle: FontStyle.italic),
                      ),
                    )
                  else
                    ..._history.map((entry) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry['guess'],
                                style: TextStyle(color: const Color(0xFFD4D4D8), fontSize: 13.sp, fontWeight: FontWeight.bold, letterSpacing: 4.w, fontFamily: 'monospace'),
                              ),
                              Row(
                                children: (entry['result'] as List<String>).map((res) => Container(
                                       width: 10.w,
                                       height: 10.w,
                                       margin: EdgeInsets.only(left: 6.w),
                                       decoration: BoxDecoration(
                                         color: res == 'G' ? const Color(0xFF22C55E) : (res == 'Y' ? const Color(0xFFEAB308) : const Color(0xFF18181B)),
                                         shape: BoxShape.circle,
                                         border: Border.all(color: res == 'R' ? const Color(0xFF27272A) : Colors.transparent),
                                         boxShadow: [
                                           if (res != 'R') BoxShadow(color: (res == 'G' ? Colors.green : Colors.yellow).withOpacity(0.5), blurRadius: 4),
                                         ],
                                       ),
                                     )).toList(),
                              ),
                            ],
                          ),
                        )),
                  if (_history.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    const Divider(color: Color(0xFF18181B)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLegendItem(const Color(0xFF22C55E), tr('tools.code_raider.correct')),
                        _buildLegendItem(const Color(0xFFEAB308), tr('tools.code_raider.wrong_spot')),
                        _buildLegendItem(const Color(0xFF18181B), tr('tools.code_raider.invalid')),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 6.w, height: 6.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 4.w),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: TextStyle(color: const Color(0xFF52525B), fontSize: 9.sp, fontFamily: 'monospace')),
          ),
        ),
      ],
    );
  }

}
