import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final scrapProvider = StateNotifierProvider<ScrapNotifier, int>((ref) {
  return ScrapNotifier();
});

class ScrapNotifier extends StateNotifier<int> {
  ScrapNotifier() : super(1000) {
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('raid_alarm_scrap') ?? 1000;
  }

  Future<void> addScrap(int amount) async {
    state += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('raid_alarm_scrap', state);
  }

  Future<void> removeScrap(int amount) async {
    state -= amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('raid_alarm_scrap', state);
  }

  Future<void> setScrap(int amount) async {
    state = amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('raid_alarm_scrap', state);
  }
}
