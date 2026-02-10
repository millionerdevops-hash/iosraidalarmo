import 'package:sqflite/sqflite.dart';
import 'package:raidalarm/data/database/app_database.dart';
import 'package:raidalarm/data/models/notification_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepoProvider = Provider((ref) => NotificationRepository(ref.read(appDatabaseProvider)));

class NotificationRepository {
  final AppDatabase _db;

  NotificationRepository(this._db);

  static const String _tableNotifications = 'notifications';
  static const String _keyTimestamp = 'timestamp';
  static const String _keyPackageName = 'package_name';
  static const String _keyChannelId = 'channel_id';
  static const String _keyTitle = 'title';
  static const String _keyBody = 'body';
  static const String _keySubtitle = 'subtitle';
  static const String _whereTimestampPackageChannel = 'timestamp = ? AND package_name = ? AND channel_id = ?';
  static const String _whereChannelPackage = 'channel_id = ? AND package_name = ?';
  static const String _whereId = 'id = ?';
  static const String _orderByTimestampDesc = 'timestamp DESC';
  static const String _packageRustCompanion = 'com.facepunch.rust.companion';
  static const String _channelAlarm = 'alarm';
  static const String _queryCountNotifications = 'SELECT COUNT(*) as count FROM notifications';

  /// Bildirimi kaydet (duplicate kontrolü ile)
  /// 
  /// UNIQUE constraint sayesinde duplicate bildirimler otomatik olarak engellenir.
  /// ConflictAlgorithm.ignore kullanıldığı için duplicate durumunda INSERT başarısız olur (rowId = -1).
  /// SELECT gereksizdir çünkü UNIQUE constraint zaten duplicate'leri engelliyor.
  /// Transaction kullanarak race condition önlenir.
  Future<bool> saveNotification(NotificationData notification) async {
    try {
      final db = await _db.database;

      return await db.transaction<bool>((txn) async {
        final data = {
          _keyTimestamp: notification.timestamp,
          _keyPackageName: notification.packageName,
          _keyChannelId: notification.channelId,
          _keyTitle: notification.title,
          _keyBody: notification.body,
          _keySubtitle: notification.subtitle,
        };

        // UNIQUE constraint sayesinde duplicate kontrolü otomatik yapılır
        // ConflictAlgorithm.ignore kullanıldığı için duplicate durumunda rowId = -1 döner
        final rowId = await txn.insert(
          _tableNotifications,
          data,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        // rowId != -1 ise INSERT başarılı (yeni kayıt eklendi)
        // rowId == -1 ise INSERT başarısız (duplicate kayıt, ignore edildi)
        return rowId != -1;
      });
    } catch (e) {
      return false;
    }
  }

  Future<List<NotificationData>> getNotifications({int limit = 100}) async {
    try {
      final db = await _db.database;

      final results = await db.query(
        _tableNotifications,
        orderBy: _orderByTimestampDesc,
        limit: limit,
      );

      final notifications = results.map((row) => _rowToNotification(row)).toList();
      return notifications;
    } catch (e) {
      return [];
    }
  }

  Future<List<NotificationData>> getAttackNotifications({int limit = 100}) async {
    try {
      final db = await _db.database;

      final results = await db.query(
        _tableNotifications,
        where: _whereChannelPackage,
        whereArgs: [_channelAlarm, _packageRustCompanion],
        orderBy: _orderByTimestampDesc,
        limit: limit,
      );

      final notifications = results.map((row) => _rowToNotification(row)).toList();
      return notifications;
    } catch (e) {
      return [];
    }
  }

  Future<NotificationData?> getLastNotification() async {
    try {
      final db = await _db.database;

      final results = await db.query(
        _tableNotifications,
        orderBy: _orderByTimestampDesc,
        limit: 1,
      );

      if (results.isEmpty) return null;
      final notification = _rowToNotification(results.first);
      return notification;
    } catch (e) {
      return null;
    }
  }

  Future<int> getNotificationCount() async {
    try {
      final db = await _db.database;
      final result = await db.rawQuery(_queryCountNotifications);
      final count = Sqflite.firstIntValue(result) ?? 0;
      return count;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> deleteNotification(int id) async {
    try {
      final db = await _db.database;
      final deleted = await db.delete(
        _tableNotifications,
        where: _whereId,
        whereArgs: [id],
      );
      final success = deleted > 0;
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteNotificationByKey(int timestamp, String packageName, String? channelId) async {
    try {
      final db = await _db.database;
      final deleted = await db.delete(
        _tableNotifications,
        where: _whereTimestampPackageChannel,
        whereArgs: [timestamp, packageName, channelId ?? ''],
      );
      final success = deleted > 0;
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearHistory() async {
    try {
      final db = await _db.database;
      await db.delete(_tableNotifications);
    } catch (e) {
      // Error clearing history
    }
  }

  NotificationData _rowToNotification(Map<String, dynamic> row) {
    return NotificationData(
      title: row[_keyTitle] as String?,
      body: row[_keyBody] as String?,
      subtitle: row[_keySubtitle] as String?,
      packageName: row[_keyPackageName] as String,
      timestamp: row[_keyTimestamp] as int,
      channelId: row[_keyChannelId] as String?,
    );
  }
}
