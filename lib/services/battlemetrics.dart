import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final battleMetricsApiProvider = Provider((ref) => BattleMetricsApi());

/// BattleMetrics API service that calls our Vercel Edge Function proxy.
///
/// **Architecture:**
/// - This client calls Vercel proxy at: https://raidalarm.vercel.app/api/battlemetrics
/// - Vercel proxy handles: auth token, cache control, rate limiting
/// - Vercel proxy calls: https://api.battlemetrics.com
///
/// **Cache Strategy (handled by Vercel):**
/// - Players endpoint: 30s cache
/// - Server search: 120s cache
/// - Server details: 60s cache
/// - Uses stale-while-revalidate for better UX
///
/// **Error Handling:**
/// - Network errors: Throws exception
/// - API errors: Throws exception with error details
class BattleMetricsApi {
  static String get defaultProxyUrl =>
      dotenv.env['BATTLEMETRICS_PROXY_URL']!;

  final http.Client _client;
  final String proxyUrl;

  BattleMetricsApi({http.Client? client, String? proxyUrl})
      : _client = client ?? http.Client(),
        proxyUrl = proxyUrl ?? defaultProxyUrl;

  /// Fetches data from BattleMetrics API via Vercel proxy.
  ///
  /// **Parameters:**
  /// - [endpoint]: BattleMetrics API path (e.g., '/servers', '/games/2')
  /// - [queryParams]: Query string (e.g., '?filter[search]=rust')
  ///
  /// **Example:**
  /// ```dart
  /// final data = await api.fetchBattleMetrics(
  ///   '/servers',
  ///   queryParams: '?filter[search]=rustoria&filter[game]=rust',
  /// );
  /// ```
  ///
  /// **Returns:** JSON response from BattleMetrics API
  /// **Throws:** Exception if API returns error (after parsing)
  Future<Map<String, dynamic>> fetchBattleMetrics(
    String endpoint, {
    String queryParams = '',
  }) async {
    try {
      final uri = Uri.parse(proxyUrl).replace(
        queryParameters: <String, String>{
          'path': endpoint,
          'params': queryParams,
        },
      );

      debugPrint('[BattleMetrics] Fetching: $uri');

      final response = await _client.get(uri);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'HTTP ${response.statusCode} ${response.reasonPhrase ?? ''}',
        );
      }

      final decoded = json.decode(response.body);
      debugPrint('[BattleMetrics] Response: ${response.statusCode}');
      if (decoded is Map<String, dynamic>) {
        if (decoded['error'] != null) {
          throw Exception(decoded['error']);
        }
        return decoded;
      }

      return <String, dynamic>{'data': decoded};
    } catch (e) {
      debugPrint('[BattleMetrics] ERROR for $endpoint: $e');
      rethrow;
    }
  }

}
