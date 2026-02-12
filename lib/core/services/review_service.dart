import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/foundation.dart';

class ReviewService {
  final InAppReview _inAppReview = InAppReview.instance;

  /// Checks if the in-app review feature is available on the current device.
  Future<bool> isAvailable() async {
    return await _inAppReview.isAvailable();
  }

  /// Requests the in-app review dialog.
  Future<void> requestReview() async {
    if (await isAvailable()) {
      try {
        await _inAppReview.requestReview();
      } catch (e) {
        debugPrint('Review request failed: $e');
      }
    }
  }

  /// Opens the store listing for the app.
  Future<void> openStoreListing() async {
    try {
      // For iOS, appStoreId is required to open the store listing directly.
      // For Android, it usually opens via package name automatically.
      // Replace with your actual App Store ID when available.
      await _inAppReview.openStoreListing(
        appStoreId: '1234567890', // TODO: REPLACE THIS WITH REAL APP ID
      );
    } catch (e) {
      debugPrint('Open store listing failed: $e');
    }
  }
}

final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService();
});
