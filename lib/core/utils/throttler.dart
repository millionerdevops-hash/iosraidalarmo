import 'dart:async';

/// A utility class to prevent multiple rapid executions of an action.
/// Useful for preventing double-taps on buttons.
class Throttler {
  final Duration delay;
  DateTime? _lastRun;

  Throttler({this.delay = const Duration(milliseconds: 500)});

  /// Runs the [action] only if the [delay] has passed since the last execution.
  void run(void Function() action) {
    final now = DateTime.now();
    if (_lastRun == null || now.difference(_lastRun!) > delay) {
      _lastRun = now;
      action();
    }
  }

  /// Resets the throttler, allowing the next action to run immediately.
  void reset() {
    _lastRun = null;
  }
}


