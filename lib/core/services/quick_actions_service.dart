import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';
import '../../core/router/app_router.dart';

class QuickActionsService {
  final QuickActions _quickActions = const QuickActions();

  static const String _actionOffer = 'action_offer';

  Future<void> initialize() async {
    _quickActions.initialize((shortcutType) {
      if (shortcutType == _actionOffer) {
        // Navigate to Paywall with discount flag
        AppRouter.router.push('/paywall?isOffer=true');
      }
    });

    _quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: _actionOffer,
        localizedTitle: 'Claim Your Offer 🎁',
        icon: 'gift', // Using Vending Machine as Gift/Offer icon
      ),
    ]);
  }
}

final quickActionsServiceProvider = Provider<QuickActionsService>((ref) {
  return QuickActionsService();
});
