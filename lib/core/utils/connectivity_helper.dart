import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ConnectivityHelper {
  static Future<bool> hasInternet() async {
    // Try up to 2 times with a small delay to avoid false negatives
    try {
      bool connected = await InternetConnectionChecker.instance.hasConnection;
      if (connected) return true;
      
      await Future.delayed(const Duration(milliseconds: 1000));
      return await InternetConnectionChecker.instance.hasConnection;
    } catch (_) {
      return false;
    }
  }

  static void showNoInternetSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tr('common.errors.no_internet'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
