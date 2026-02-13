import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/theme/rust_typography.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';

import 'package:raidalarm/screens/blackjack/models/blackjack_models.dart';
import 'package:raidalarm/screens/blackjack/widgets/blackjack_card.dart';
import 'package:raidalarm/providers/scrap_provider.dart';

class BlackjackScreen extends ConsumerStatefulWidget {
  const BlackjackScreen({super.key});

  @override
  ConsumerState<BlackjackScreen> createState() => _BlackjackScreenState();
}

class _BlackjackScreenState extends ConsumerState<BlackjackScreen> {
  // late SharedPreferences _prefs; // Removed in favor of provider
  // int _scrap = 1000; // Removed in favor of provider
  int _bet = 10;
  List<CardModel> _deck = [];
  List<CardModel> _playerHand = [];
  List<CardModel> _dealerHand = [];
  BlackjackGamePhase _phase = BlackjackGamePhase.betting;
  
  Map<String, dynamic>? _resultMsg;

  @override
  void initState() {
    super.initState();
    // _loadScrap(); // Handled by provider
    _initDeck();
    
    // Check refill after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRefillScrap();
    });
  }

  // void _loadScrap() ... // Removed
  // void _saveScrap() ... // Removed

  void _checkAndRefillScrap() {
    final currentScrap = ref.read(scrapProvider);
    if (currentScrap < 20) {
      ref.read(scrapProvider.notifier).setScrap(1000);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'HQM Refilled to 1000 (Free Play Mode)',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF22C55E),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _initDeck() {
    _deck = _createDeck();
  }

  List<CardModel> _createDeck() {
    final List<CardModel> deck = [];
    for (int i = 0; i < 4; i++) {
      for (var suit in Suit.values) {
        for (var rank in Rank.values) {
          deck.add(CardModel(
            suit: suit,
            rank: rank,
            id: '${rank.label}${suit.acronym}-$i-${Random().nextDouble()}',
          ));
        }
      }
    }
    deck.shuffle();
    return deck;
  }

  int _calculateScore(List<CardModel> hand) {
    int score = 0;
    int aces = 0;

    for (var card in hand) {
      if (card.isHidden) continue;
      score += card.value;
      if (card.rank == Rank.ace) aces += 1;
    }

    while (score > 21 && aces > 0) {
      score -= 10;
      aces -= 1;
    }
    return score;
  }

  Future<void> _dealGame() async {
    final currentScrap = ref.read(scrapProvider);
    // Auto-refill check before dealing
    if (currentScrap < 20) {
      _checkAndRefillScrap();
      // Add a small delay so user sees the refill before bet check
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // specific check again after potential refill
    if (_bet > ref.read(scrapProvider)) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr('tools.match_game.not_enough_scrap'),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      return;
    }

    if (_deck.length < 15) _initDeck();

    ref.read(scrapProvider.notifier).removeScrap(_bet);
    
    setState(() {
      // _scrap -= _bet; // Handled by provider
      // _saveScrap(); // Handled by provider
      _playerHand = [];
      _dealerHand = [];
      _phase = BlackjackGamePhase.dealing;
      _resultMsg = null;
    });

    // Dealing Sequence
    await Future.delayed(const Duration(milliseconds: 300));
    _drawCard(isPlayer: true);
    await Future.delayed(const Duration(milliseconds: 300));
    _drawCard(isPlayer: false);
    await Future.delayed(const Duration(milliseconds: 300));
    _drawCard(isPlayer: true);
    await Future.delayed(const Duration(milliseconds: 300));
    _drawCard(isPlayer: false, isHidden: true);

    final int pScore = _calculateScore(_playerHand);
    if (pScore == 21) {
      _resolveGame();
    } else {
      setState(() => _phase = BlackjackGamePhase.playerTurn);
    }
  }

  void _drawCard({required bool isPlayer, bool isHidden = false}) {
    if (_deck.isEmpty) _initDeck();
    final CardModel card = _deck.removeLast();
    card.isHidden = isHidden;
    setState(() {
      if (isPlayer) {
        _playerHand.add(card);
      } else {
        _dealerHand.add(card);
      }
    });
  }

  Future<void> _hit() async {
    if (_phase != BlackjackGamePhase.playerTurn) return;
    HapticHelper.lightImpact();
    _drawCard(isPlayer: true);
    
    if (_calculateScore(_playerHand) > 21) {
      await Future.delayed(const Duration(milliseconds: 500));
      _resolveGame();
    }
  }

  void _stand() {
    HapticHelper.lightImpact();
    setState(() => _phase = BlackjackGamePhase.dealerTurn);
    _runDealerAI();
  }

  Future<void> _doubleDown() async {
    final currentScrap = ref.read(scrapProvider);
    if (currentScrap < _bet || _playerHand.length > 2) return;
    HapticHelper.lightImpact();
    
    ref.read(scrapProvider.notifier).removeScrap(_bet);
    
    setState(() {
      // _scrap -= _bet; // Handled by provider
      _bet *= 2;
      // _saveScrap(); // Handled by provider
    });
    
    _drawCard(isPlayer: true);
    if (_calculateScore(_playerHand) > 21) {
      await Future.delayed(const Duration(milliseconds: 500));
      _resolveGame();
    } else {
      _stand();
    }
  }

  Future<void> _runDealerAI() async {
    // Reveal hidden card
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _dealerHand[1].isHidden = false;
    });

    int dScore = _calculateScore(_dealerHand);
    while (dScore < 17) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _drawCard(isPlayer: false);
      dScore = _calculateScore(_dealerHand);
    }

    await Future.delayed(const Duration(milliseconds: 500));
    _resolveGame();
  }

  void _resolveGame() {
    setState(() => _phase = BlackjackGamePhase.resolving);
    
    // Reveal all dealer cards
    for (var card in _dealerHand) {
      card.isHidden = false;
    }

    final int pScore = _calculateScore(_playerHand);
    final int dScore = _calculateScore(_dealerHand);

    String msg = '';
    String sub = '';
    Color color = Colors.white;
    double winAmount = 0;

    if (pScore > 21) {
      msg = tr('tools.blackjack.results.busted');
      sub = tr('tools.blackjack.results.busted_sub');
      color = const Color(0xFFEF4444);
    } else {
      final bool pBJ = pScore == 21 && _playerHand.length == 2;
      final bool dBJ = dScore == 21 && _dealerHand.length == 2;

      if (pBJ && !dBJ) {
        msg = tr('tools.blackjack.results.blackjack');
        sub = tr('tools.blackjack.results.blackjack_sub');
        color = const Color(0xFFFACC15);
        winAmount = _bet * 2.5;
      } else if (dScore > 21) {
        msg = tr('tools.blackjack.results.you_win');
        sub = tr('tools.blackjack.results.dealer_busted');
        color = const Color(0xFF22C55E);
        winAmount = _bet * 2;
      } else if (pScore > dScore) {
        msg = tr('tools.blackjack.results.you_win');
        sub = tr('tools.blackjack.results.score_vs_score', args: [pScore.toString(), dScore.toString()]);
        color = const Color(0xFF22C55E);
        winAmount = _bet * 2;
      } else if (dScore > pScore) {
        msg = tr('tools.blackjack.results.dealer_wins');
        sub = tr('tools.blackjack.results.score_vs_score', args: [dScore.toString(), pScore.toString()]);
        color = const Color(0xFFEF4444);
      } else {
        msg = tr('tools.blackjack.results.push');
        sub = tr('tools.blackjack.results.scrap_returned');
        color = const Color(0xFF60A5FA);
        winAmount = _bet.toDouble();
      }
    }

    setState(() {
      _resultMsg = {
        'text': msg,
        'subtext': sub,
        'color': color,
        'amount': (winAmount - _bet).toInt(),
      };
      
      if (winAmount > 0) {
        ref.read(scrapProvider.notifier).addScrap(winAmount.toInt());
      }
      // _scrap += winAmount.toInt(); // Handled by provider
      // _saveScrap(); // Handled by provider
      _phase = BlackjackGamePhase.gameOver;
    });

    if (winAmount > _bet) {
      HapticHelper.lightImpact();
      // Future.delayed(const Duration(milliseconds: 100), () => HapticHelper.success());
    } else if (winAmount == 0) {
      HapticHelper.lightImpact();
    }

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _resultMsg = null;
          _playerHand = [];
          _dealerHand = [];
          _phase = BlackjackGamePhase.betting;
          _bet = 10; // Reset bet
          _checkAndRefillScrap(); // Check refill after game
        });
      }
    });
  }

  void _placeBet(int amount) {
    final currentScrap = ref.read(scrapProvider);
    if (currentScrap >= amount) {
      setState(() {
        _bet += amount;
      });
      HapticHelper.lightImpact();
    } else {
        // If they can't afford, check if they need a refill
        _checkAndRefillScrap();
    }
  }

  void _handleBack() {
    if (_phase != BlackjackGamePhase.betting && _phase != BlackjackGamePhase.gameOver) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF18181B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: const BorderSide(color: Color(0xFF27272A)),
          ),
          title: Text(
            tr('tools.match_game.exit_warning_title'),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Rust',
              fontSize: 20.sp,
            ),
          ),
          content: Text(
            tr('tools.match_game.exit_warning_message'),
            style: TextStyle(
              color: const Color(0xFFA1A1AA),
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                tr('tools.match_game.no'),
                style: const TextStyle(color: Color(0xFFA1A1AA)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                context.go('/tools');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text(
                tr('tools.match_game.yes'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else {
      context.go('/tools');
    }
  }

  // Ad logic removed completely


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0C0E),
        body: RustScreenLayout(
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(ref.watch(scrapProvider)), // Pass scrap value
                Expanded(
                  child: Stack(
                    children: [
                      _buildTable(),
                      if (_resultMsg != null) _buildResultOverlay(),
                    ],
                  ),
                ),
                _buildControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int scrap) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF152e22),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: _handleBack,
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tr('tools.blackjack.title'),
              style: RustTypography.rustStyle(
                fontSize: 20.sp,
                color: Colors.white,
                weight: FontWeight.bold,
              ),
            ),
          ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 80.w),
                              child: FittedBox(
                                alignment: Alignment.centerRight,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  scrap.toString(),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Image.asset('assets/images/png/ingame/diesel-calculator/hqm.png', width: 24.w),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
  }

  Widget _buildTable() {
    return Container(
      color: const Color(0xFF1E4635),
      width: double.infinity,
      child: Stack(
        children: [
          // Texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/grid-noise.png',
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          // Center Logo
          Align(
            child: Opacity(
              opacity: 0.04,
              child: Icon(LucideIcons.spade, size: 180.w, color: Colors.black),
            ),
          ),
          // Dealer Area
          _buildHandArea(isDealer: true),
          // Player Area
          _buildHandArea(isDealer: false),
        ],
      ),
    );
  }

  Widget _buildHandArea({required bool isDealer}) {
    final hand = isDealer ? _dealerHand : _playerHand;
    final score = _calculateScore(hand);
    final isBetting = _phase == BlackjackGamePhase.betting;

    return Positioned(
      top: isDealer ? 40.h : null,
      bottom: isDealer ? null : 40.h,
      left: 0,
      right: 0,
      child: Column(
        children: [
          if (!isDealer && hand.isNotEmpty) _buildScoreBadge(tr('tools.blackjack.score_you', args: [score.toString()])),
          SizedBox(
            height: 140.h,
            child: hand.isEmpty && isBetting
                ? _buildEmptyHandPlaceholder(isDealer ? tr('tools.blackjack.dealer') : tr('tools.blackjack.player'))
                : Stack(
                    alignment: Alignment.center,
                    children: hand.asMap().entries.map((e) {
                      return BlackjackCard(
                        card: e.value,
                        index: e.key,
                        totalCards: hand.length,
                        isDealer: isDealer,
                      );
                    }).toList(),
                  ),
          ),
          if (isDealer && hand.isNotEmpty) _buildScoreBadge(
            _phase == BlackjackGamePhase.playerTurn ? tr('tools.blackjack.dealer') : tr('tools.blackjack.score_dealer', args: [score.toString()])
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHandPlaceholder(String label) {
    return Container(
      width: 85.w,
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10, width: 2),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label.toUpperCase(), style: TextStyle(color: Colors.white24, fontSize: 10.sp, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBadge(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, style: TextStyle(color: Colors.white70, fontSize: 11.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildResultOverlay() {
    final msg = _resultMsg!;
    final int amount = msg['amount'];
    final bool hasChange = amount != 0;
    
    return Center(
      child: Container(
        width: 210.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white10),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 30)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                msg['text'],
                style: TextStyle(
                  color: msg['color'], 
                  fontSize: 24.sp, 
                  fontWeight: FontWeight.w900, 
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                msg['subtext'].toUpperCase(),
                style: TextStyle(color: Colors.white70, fontSize: 9.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
            if (hasChange) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: (amount > 0 ? Colors.green : Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: (amount > 0 ? Colors.green : Colors.red).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${amount > 0 ? "+" : ""}$amount', 
                        style: TextStyle(
                          color: amount > 0 ? Colors.greenAccent : const Color(0xFFF87171), 
                          fontSize: 16.sp, 
                          fontWeight: FontWeight.w900
                        )
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Image.asset('assets/images/png/ingame/diesel-calculator/hqm.png', width: 20.w),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      decoration: const BoxDecoration(
        color: Color(0xFF151516),
        border: Border(top: BorderSide(color: Color(0xFF27272A))),
      ),
      child: Column(
        children: [
          if (_phase == BlackjackGamePhase.betting) _buildBettingControls(),
          if (_phase == BlackjackGamePhase.playerTurn) _buildActionControls(),
          if (_phase == BlackjackGamePhase.dealing || 
              _phase == BlackjackGamePhase.dealerTurn || 
              _phase == BlackjackGamePhase.resolving) _buildWaitingIndicator(),
        ],
      ),
    );
  }

  Widget _buildBettingControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 80.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(tr('tools.blackjack.place_bet'), style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
            Row(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(_bet.toString(), style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w900)),
                ),
                SizedBox(width: 4.w),
                Image.asset('assets/images/png/ingame/diesel-calculator/hqm.png', width: 24.w),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [10, 50, 100, 500].map((amt) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: _buildChipButton(amt),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            SizedBox(
              width: 60.w,
              child: _buildActionButton(
                onPressed: () {
                  HapticHelper.lightImpact();
                  setState(() => _bet = 10);
                },
                icon: LucideIcons.circleX,
                color: const Color(0xFF27272A),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  HapticHelper.lightImpact();
                  _dealGame();
                },
                label: tr('tools.blackjack.deal_cards'),
                icon: LucideIcons.play,
                color: const Color(0xFF16A34A),
                disabled: ref.watch(scrapProvider) < _bet,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionControls() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            onPressed: _hit,
            label: tr('tools.blackjack.hit'),
            icon: LucideIcons.plus,
            color: const Color(0xFF16A34A),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildActionButton(
            onPressed: _stand,
            label: tr('tools.blackjack.stand'),
            icon: LucideIcons.hand,
            color: const Color(0xFFDC2626),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildActionButton(
            onPressed: _doubleDown,
            label: tr('tools.blackjack.double'),
            color: const Color(0xFF2563EB),
            showHqm: true,
            disabled: ref.watch(scrapProvider) < _bet || _playerHand.length > 2,
          ),
        ),
      ],
    );
  }

  Widget _buildChipButton(int amount) {
    final bool canAfford = ref.watch(scrapProvider) >= amount;
    return ElevatedButton(
      onPressed: canAfford ? () => _placeBet(amount) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF27272A),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        elevation: 4,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text('+$amount', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required Color color, String? label,
    IconData? icon,
    bool disabled = false,
    bool showHqm = false,
  }) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: 18.w),
            if (showHqm) Image.asset('assets/images/png/ingame/diesel-calculator/hqm.png', width: 24.w),
            if (label != null) ...[
              SizedBox(width: 8.w),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 14.w,
            height: 14.w,
            child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white30),
          ),
          SizedBox(width: 12.w),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _phase == BlackjackGamePhase.dealing ? tr('tools.blackjack.dealing') : tr('tools.blackjack.dealer_turn'),
              style: TextStyle(color: Colors.white30, fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
        ],
      ),
    );
  }
}
