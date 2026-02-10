import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/data/models/notification_data.dart'; // import notification data to check package name
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attackStatsRepoProvider = Provider((ref) => AttackStatisticsRepository(ref.read(appDatabaseProvider)));

class AttackStatisticsRepository {
  final AppDatabase _db;

  AttackStatisticsRepository(this._db);

  static final DateFormat _dateFormatDay = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateFormatMonth = DateFormat('yyyy-MM');
  static const String _tableAppSettings = 'app_settings';
  static const String _tableAttackStatistics = 'attack_statistics';
  static const String _keyTotalAttackCount = 'totalAttackCount';
  static const String _keyLastAttackTime = 'lastAttackTime';
  static const String _keyValue = 'value';
  static const String _keyKey = 'key';
  static const String _keyUpdatedAt = 'updated_at';
  static const String _keyDate = 'date';
  static const String _keyDailyCount = 'daily_count';
  static const String _keyHourlyData = 'hourly_data';
  static const String _querySelectValue = 'SELECT value FROM app_settings WHERE key = ?';
  static const String _querySelectSumWeekly = 'SELECT SUM(weekly_count) as total FROM attack_statistics WHERE date LIKE ?';
  static const String _queryUpdateDailyCount = 'UPDATE attack_statistics SET daily_count = daily_count + 1, updated_at = ? WHERE date = ?';

  Future<int> getTotalAttackCount() async {
    try {
      final db = await _db.database;
      final result = await db.rawQuery(
        _querySelectValue,
        [_keyTotalAttackCount],
      );

      if (result.isEmpty) return 0;
      final count = int.tryParse(result.first['value'] as String) ?? 0;
      return count;
    } catch (e) {
      return 0;
    }
  }

  Future<void> updateTotalAttackCount(int count) async {
    try {
      final db = await _db.database;
      await db.insert(
        _tableAppSettings,
        {
          _keyKey: _keyTotalAttackCount,
          _keyValue: count.toString(),
          _keyUpdatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Error updating total attack count
    }
  }

  Future<DateTime?> getLastAttackTime() async {
    try {
      final db = await _db.database;
      final result = await db.rawQuery(
        _querySelectValue,
        [_keyLastAttackTime],
      );

      if (result.isEmpty) return null;
      final timestamp = int.tryParse(result.first['value'] as String);
      if (timestamp == null) return null;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return dateTime;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateLastAttackTime(int timestamp) async {
    try {
      final db = await _db.database;
      await db.insert(
        _tableAppSettings,
        {
          _keyKey: _keyLastAttackTime,
          _keyValue: timestamp.toString(),
          _keyUpdatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Error updating last attack time
    }
  }

  Future<void> recordAttack(int timestamp) async {
    try {
      final db = await _db.database;

      await db.transaction((txn) async {
        // DateTime.now()'u transaction başında bir kez al (CPU optimizasyonu)
        final nowTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        
        final currentCount = await _getTotalCount(txn);
        await _setTotalCount(txn, currentCount + 1, nowTimestamp);

        await _setLastAttackTime(txn, timestamp, nowTimestamp);

        final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final normalizedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
        final dateKey = _dateFormatDay.format(normalizedDate);
        final hour = dateTime.hour;

        // Tek SELECT ile hem daily_count hem hourly_data'yı güncelle (Disk I/O optimizasyonu)
        await _updateDailyAndHourlyCount(txn, dateKey, hour, nowTimestamp);
      });
    } catch (e) {
      // Error recording attack
    }
  }

  Future<Map<String, int>> getDailyAttackCounts({int days = 7}) async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);
      final Map<String, int> dailyCounts = {};

      // Son N günün date key'lerini oluştur
      final dateKeys = <String>[];
      for (int i = 0; i < days; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        final dateKey = _dateFormatDay.format(date);
        dateKeys.add(dateKey);
      }

      // Tek query ile tüm günleri çek (IN clause kullanarak)
      final placeholders = List.filled(dateKeys.length, '?').join(',');
      final result = await db.rawQuery(
        'SELECT $_keyDate, $_keyDailyCount FROM $_tableAttackStatistics WHERE $_keyDate IN ($placeholders)',
        dateKeys,
      );

      // Sonuçları map'e çevir (tüm date key'ler için 0 ile başlat)
      for (final dateKey in dateKeys) {
        dailyCounts[dateKey] = 0;
      }

      // Query sonuçlarını map'e ekle
      for (final row in result) {
        final dateKey = row[_keyDate] as String;
        final count = row[_keyDailyCount] as int? ?? 0;
        dailyCounts[dateKey] = count;
      }

      return dailyCounts;
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, int>> getWeeklyAttackCounts({int weeks = 4}) async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final Map<String, int> weeklyCounts = {};

      // Tüm query'leri paralel olarak hazırla
      final futures = <Future<MapEntry<String, int>>>[];
      for (int i = 0; i < weeks; i++) {
        final date = now.subtract(Duration(days: i * 7));
        final year = date.year;
        final weekNumber = _getWeekNumber(date);
        final weekKey = '$year-W$weekNumber';

        futures.add(
          db.rawQuery(
            _querySelectSumWeekly,
            ['$year-W$weekNumber%'],
          ).then((result) {
            int count = 0;
            if (result.isNotEmpty && result.first['total'] != null) {
              final totalValue = result.first['total'];
              if (totalValue is int) {
                count = totalValue;
              } else if (totalValue is num) {
                count = totalValue.toInt();
              }
            }
            return MapEntry(weekKey, count);
          }),
        );
      }

      // Tüm query'leri paralel olarak çalıştır
      final results = await Future.wait(futures);
      for (final entry in results) {
        weeklyCounts[entry.key] = entry.value;
      }

      return weeklyCounts;
    } catch (e) {
      return {};
    }
  }

  /// Tüm haftaların toplam saldırı sayısını döndürür (optimize edilmiş - tek query).
  /// 
  /// Bu metod, getWeeklyAttackCounts(weeks: 1000) yerine kullanılmalıdır
  /// çünkü çok daha performanslıdır (1000 query yerine 1 query).
  Future<int> getAllWeeklyAttackCountsTotal() async {
    try {
      final db = await _db.database;
      
      // Tek query ile tüm weekly_count'ları topla
      final result = await db.rawQuery(
        'SELECT SUM(weekly_count) as total FROM $_tableAttackStatistics',
      );
      
      if (result.isEmpty || result.first['total'] == null) {
        return 0;
      }
      
      final totalValue = result.first['total'];
      if (totalValue is int) {
        return totalValue;
      } else if (totalValue is num) {
        return totalValue.toInt();
      }
      
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<Map<String, int>> getMonthlyAttackCounts({int months = 6}) async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final Map<String, int> monthlyCounts = {};

      // Tüm query'leri paralel olarak hazırla
      final futures = <Future<MapEntry<String, int>>>[];
      for (int i = 0; i < months; i++) {
        final date = DateTime(now.year, now.month - i);
        final monthKey = _dateFormatMonth.format(date);
        
        // LIKE yerine BETWEEN kullan (index kullanımı optimize edilir)
        final startDate = DateTime(date.year, date.month, 1);
        final endDate = DateTime(date.year, date.month + 1, 0);
        final startDateKey = _dateFormatDay.format(startDate);
        final endDateKey = _dateFormatDay.format(endDate);

        futures.add(
          db.rawQuery(
            'SELECT SUM(daily_count) as total FROM attack_statistics WHERE date >= ? AND date <= ?',
            [startDateKey, endDateKey],
          ).then((result) {
            int count = 0;
            if (result.isNotEmpty && result.first['total'] != null) {
              final totalValue = result.first['total'];
              if (totalValue is int) {
                count = totalValue;
              } else if (totalValue is num) {
                count = totalValue.toInt();
              }
            }
            return MapEntry(monthKey, count);
          }),
        );
      }

      // Tüm query'leri paralel olarak çalıştır
      final results = await Future.wait(futures);
      for (final entry in results) {
        monthlyCounts[entry.key] = entry.value;
      }

      return monthlyCounts;
    } catch (e) {
      return {};
    }
  }

  Future<Map<int, int>> getTodayHourlyAttackCounts() async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final dateKey = _dateFormatDay.format(now);
      final Map<int, int> hourlyCounts = {};

      final result = await db.query(
        _tableAttackStatistics,
        where: '$_keyDate = ?',
        whereArgs: [dateKey],
        limit: 1,
      );

      if (result.isNotEmpty) {
        final hourlyData = result.first[_keyHourlyData] as String?;
        if (hourlyData != null && hourlyData.isNotEmpty) {
          final hourlyMap = Map<String, dynamic>.from(jsonDecode(hourlyData));
          
          hourlyMap.forEach((hourStr, count) {
            final hour = int.tryParse(hourStr) ?? -1;
            if (hour >= 0 && hour <= 23) {
              int rangeHour;
              if (hour >= 0 && hour < 4) {
                rangeHour = 0;
              } else if (hour >= 4 && hour < 8) {
                rangeHour = 4;
              } else if (hour >= 8 && hour < 12) {
                rangeHour = 8;
              } else if (hour >= 12 && hour < 16) {
                rangeHour = 12;
              } else if (hour >= 16 && hour < 20) {
                rangeHour = 16;
              } else {
                rangeHour = 20;
              }
              
              hourlyCounts[rangeHour] = (hourlyCounts[rangeHour] ?? 0) + (count as int? ?? 0);
            }
          });
        }
      }

      return hourlyCounts;
    } catch (e) {
      return {};
    }
  }

  Future<Map<int, int>> getHourlyAttackCounts() async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final Map<int, int> hourlyCounts = {};

      // Son 30 günün date key'lerini oluştur
      final dateKeys = <String>[];
      for (int i = 0; i < 30; i++) {
        final date = now.subtract(Duration(days: i));
        final dateKey = _dateFormatDay.format(date);
        dateKeys.add(dateKey);
      }

      // Tek query ile tüm günleri çek (IN clause kullanarak)
      final placeholders = List.filled(dateKeys.length, '?').join(',');
      final result = await db.rawQuery(
        'SELECT $_keyHourlyData FROM $_tableAttackStatistics WHERE $_keyDate IN ($placeholders)',
        dateKeys,
      );

      // Tüm JSON'ları decode et ve saatleri birleştir
      for (final row in result) {
        final hourlyData = row[_keyHourlyData] as String?;
        if (hourlyData != null && hourlyData.isNotEmpty) {
          try {
            final hourlyMap = jsonDecode(hourlyData) as Map<String, dynamic>;
            hourlyMap.forEach((hourStr, count) {
              final hour = int.tryParse(hourStr) ?? -1;
              if (hour >= 0 && hour <= 23) {
                final countValue = count is int ? count : (count as num).toInt();
                hourlyCounts[hour] = (hourlyCounts[hour] ?? 0) + countValue;
              }
            });
          } catch (e) {
            // JSON decode hatası - bu kaydı atla, diğerlerine devam et
            continue;
          }
        }
      }

      return hourlyCounts;
    } catch (e) {
      return {};
    }
  }

  // Private helper methods

  Future<int> _getTotalCount(Transaction txn) async {
    final result = await txn.rawQuery(
      _querySelectValue,
      [_keyTotalAttackCount],
    );
    if (result.isEmpty) return 0;
    return int.tryParse(result.first[_keyValue] as String) ?? 0;
  }

  Future<void> _setTotalCount(Transaction txn, int count, int nowTimestamp) async {
    await txn.insert(
      _tableAppSettings,
      {
        _keyKey: _keyTotalAttackCount,
        _keyValue: count.toString(),
        _keyUpdatedAt: nowTimestamp,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _setLastAttackTime(Transaction txn, int timestamp, int nowTimestamp) async {
    await txn.insert(
      _tableAppSettings,
      {
        _keyKey: _keyLastAttackTime,
        _keyValue: timestamp.toString(),
        _keyUpdatedAt: nowTimestamp,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Daily count ve hourly count'u tek bir SELECT ile günceller (Disk I/O optimizasyonu).
  /// 
  /// Önceki implementasyon: 2 ayrı SELECT (bir daily, bir hourly)
  /// Yeni implementasyon: 1 SELECT ile her ikisini de al
  Future<void> _updateDailyAndHourlyCount(Transaction txn, String dateKey, int hour, int nowTimestamp) async {
    // Tek SELECT ile hem daily_count hem hourly_data'yı al
    final result = await txn.query(
      _tableAttackStatistics,
      where: '$_keyDate = ?',
      whereArgs: [dateKey],
      limit: 1,
    );

    final existing = result.isNotEmpty;
    final currentDailyCount = existing 
        ? (result.first[_keyDailyCount] as int? ?? 0)
        : 0;

    // Hourly data'yı parse et
    Map<String, int> hourlyMap;
    if (existing) {
      final hourlyData = result.first[_keyHourlyData] as String?;
      if (hourlyData != null && hourlyData.isNotEmpty) {
        // JSON decode - optimize: direkt Map<String, int>'e çevir
        try {
          final decoded = jsonDecode(hourlyData) as Map<String, dynamic>;
          hourlyMap = Map<String, int>.from(
            decoded.map((k, v) => MapEntry(k, v is int ? v : (v as num).toInt())),
          );
        } catch (e) {
          // JSON decode hatası - boş map ile devam et
          hourlyMap = <String, int>{};
        }
      } else {
        hourlyMap = <String, int>{};
      }
    } else {
      hourlyMap = <String, int>{};
    }

    // Sadece değişen saati güncelle
    final hourKey = hour.toString();
    hourlyMap[hourKey] = (hourlyMap[hourKey] ?? 0) + 1;

    // Tek bir INSERT/UPDATE ile hem daily_count hem hourly_data'yı güncelle
    await txn.insert(
      _tableAttackStatistics,
      {
        _keyDate: dateKey,
        _keyDailyCount: currentDailyCount + 1,
        _keyHourlyData: jsonEncode(hourlyMap),
        _keyUpdatedAt: nowTimestamp,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  int _getWeekNumber(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year)).inDays + 1;
    final weekNumber = ((dayOfYear - date.weekday + 10) / 7).floor();
    return weekNumber;
  }
}
