import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raidalarm/widgets/common/rust_screen_layout.dart';
import 'package:raidalarm/core/utils/haptic_helper.dart';
import 'package:raidalarm/providers/scrap_provider.dart';
import 'models/match_game_models.dart';
import 'widgets/match_card_widget.dart';
import 'widgets/match_game_menu.dart';
import 'widgets/match_game_over.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum GameState { menu, preview, playing, won, lost }

class MatchGameScreen extends ConsumerStatefulWidget {
  const MatchGameScreen({super.key});

  @override
  ConsumerState<MatchGameScreen> createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends ConsumerState<MatchGameScreen> {
  GameState _gameState = GameState.menu;
  MatchDifficulty _difficulty = MatchDifficulty.grub;
  int _timeLeft = 0;
  Timer? _timer;
  
  List<MatchCard> _cards = [];
  final List<int> _flippedIndices = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    
    // Check refill after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRefillScrap();
    });
  }

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    final config = DIFFICULTIES[_difficulty]!;
    
    final scrapBalance = ref.read(scrapProvider);
    
    // Auto-refill check before starting
    if (scrapBalance < 20) {
       _checkAndRefillScrap();
       // Return early to let user see refill, they can click start again or we could auto-retry
       // For better UX, let's just return and let them click again now that they have scraps
       return;
    }

    if (scrapBalance < config.bet) {
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

    setState(() {
      ref.read(scrapProvider.notifier).removeScrap(config.bet);
      _gameState = GameState.preview;
      _timeLeft = config.time;
      
      // Select items for pairs
      final items = List<MatchItem>.from(GAME_ITEMS)..shuffle();
      final selectedItems = items.take(config.pairs).toList();
      
      // Create deck
      final deck = <MatchCard>[];
      final pool = [...selectedItems, ...selectedItems]..shuffle();
      
      for (int i = 0; i < pool.length; i++) {
        deck.add(MatchCard(id: i, item: pool[i], isFlipped: true));
      }
      
      _cards = deck;
      _flippedIndices.clear();
    });

    // Preview for 2 seconds then start playing
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        for (var card in _cards) {
          card.isFlipped = false;
        }
        _gameState = GameState.playing;
        _startTimer();
      });
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_gameState != GameState.playing) {
        timer.cancel();
        return;
      }
      
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _gameState = GameState.lost;
          timer.cancel();
          // Close any open dialogs (like exit confirmation)
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      });
    });
  }

  void _handleCardTap(int index) {
    if (_gameState != GameState.playing || _isProcessing) return;
    if (_cards[index].isFlipped || _cards[index].isMatched) return;
    if (_flippedIndices.length >= 2) return;

    HapticHelper.lightImpact();
    setState(() {
      _cards[index].isFlipped = true;
      _flippedIndices.add(index);
    });

    if (_flippedIndices.length == 2) {
      _isProcessing = true;
      final firstIdx = _flippedIndices[0];
      final secondIdx = _flippedIndices[1];
      
      if (_cards[firstIdx].item.id == _cards[secondIdx].item.id) {
        // Match!
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          HapticHelper.lightImpact();
          setState(() {
            _cards[firstIdx].isMatched = true;
            _cards[secondIdx].isMatched = true;
            _flippedIndices.clear();
            _isProcessing = false;
            
            if (_cards.every((c) => c.isMatched)) {
              _gameState = GameState.won;
              int winAmount = DIFFICULTIES[_difficulty]!.win;
              ref.read(scrapProvider.notifier).addScrap(winAmount);
              _timer?.cancel();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    tr('tools.match_game.earned_coins', args: [winAmount.toString()]),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: const Color(0xFF10B981),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          });
        });
      } else {
        // No match
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            _cards[firstIdx].isFlipped = false;
            _cards[secondIdx].isFlipped = false;
            _flippedIndices.clear();
            _isProcessing = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrapBalance = ref.watch(scrapProvider);
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleBack();
      },
      child: RustScreenLayout(
        child: Scaffold(
          backgroundColor: const Color(0xFF0C0C0E),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(scrapBalance),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleBack() {
    if (_gameState == GameState.preview || _gameState == GameState.playing) {
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
                Navigator.pop(context);
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

  Widget _buildHeader(int scrapBalance) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0E),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1.w)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left: Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: _handleBack,
              icon: Icon(LucideIcons.arrowLeft, color: const Color(0xFFA1A1AA), size: 22.w),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          
          // Center: Title
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 160.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tr('tools.match_game.title'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rust',
                  ),
                ),
              ),
            ),
          ),

          // Right: Scrap Balance
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color(0xFF27272A),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 60.w),
                      child: FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$scrapBalance',
                          style: TextStyle(
                            color: const Color(0xFFEAB308),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(LucideIcons.coins, color: const Color(0xFFCA8A04), size: 16.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_gameState) {
      case GameState.menu:
        return MatchGameMenu(
          selectedDifficulty: _difficulty,
          onDifficultyChanged: (diff) => setState(() => _difficulty = diff),
          onStartGame: _startGame,
        );
      case GameState.preview:
      case GameState.playing:
        return _buildGame();
      case GameState.won:
      case GameState.lost:
        return MatchGameOver(
          isWin: _gameState == GameState.won,
          difficulty: _difficulty,
          onPlayAgain: _startGame,
          onReturnToMenu: () => setState(() => _gameState = GameState.menu),
        );
    }
  }

  Widget _buildGame() {
    final cfg = DIFFICULTIES[_difficulty]!;
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF111114).withOpacity(0.9),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFF27272A)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60.w,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tr('tools.match_game.timer'),
                          style: TextStyle(
                            color: const Color(0xFF71717A),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${_timeLeft}s',
                      style: TextStyle(
                        color: _timeLeft < 10 ? const Color(0xFFEF4444) : Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                Container(width: 1.w, height: 32.h, color: const Color(0xFF27272A)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tr('tools.match_game.potential'),
                          style: TextStyle(
                            color: const Color(0xFF71717A),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '+${cfg.win}',
                          style: TextStyle(color: const Color(0xFF4ADE80), fontSize: 20.sp, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                        ),
                        SizedBox(width: 6.w),
                        Icon(LucideIcons.coins, color: const Color(0xFF22C55E), size: 16.w),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Stack(
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cfg.gridCols,
                    mainAxisSpacing: 8.w,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 0.88,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    return MatchCardWidget(
                      card: _cards[index],
                      onTap: () => _handleCardTap(index),
                    );
                  },
                ),
                if (_gameState == GameState.preview)
                  RepaintBoundary(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFF3F3F46)),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15)],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.eye, color: Colors.white, size: 24.w),
                            SizedBox(height: 8.h),
                            Text(
                              tr('tools.match_game.memorize'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Rust',
                                letterSpacing: 2,
                              ),
                            ),
                          ],
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
}
