import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDatabaseProvider = Provider((ref) => AppDatabase());

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _database;
  static String? _databasePath;
  static const String _databaseName = 'raidalarm.db';
  static const int _databaseVersion = 10;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (_databasePath == null) {
      final databasesPath = await getDatabasesPath();
      _databasePath = join(databasesPath, _databaseName);
    }

    return await openDatabase(
      _databasePath!,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp INTEGER NOT NULL,
        package_name TEXT NOT NULL,
        channel_id TEXT,
        title TEXT,
        body TEXT,
        subtitle TEXT,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
        UNIQUE(timestamp, package_name, channel_id)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_notifications_timestamp ON notifications(timestamp DESC)
    ''');

    await db.execute('''
      CREATE INDEX idx_notifications_package_channel ON notifications(package_name, channel_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_notifications_package_channel_timestamp 
      ON notifications(package_name, channel_id, timestamp DESC)
    ''');

    await db.execute('''
      CREATE TABLE attack_statistics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        daily_count INTEGER DEFAULT 0,
        hourly_data TEXT,
        weekly_count INTEGER DEFAULT 0,
        monthly_count INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_attack_statistics_date ON attack_statistics(date DESC)
    ''');

    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
      )
    ''');

    await db.insert('app_settings', {
      'key': 'totalAttackCount',
      'value': '0',
    });

    await db.execute('''
      CREATE TABLE permission_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        permission_type TEXT UNIQUE NOT NULL,
        is_granted INTEGER NOT NULL,
        last_checked INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_permission_cache_type ON permission_cache(permission_type)
    ''');

    // Favorites table
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL
      )
    ''');

    // Tracked players table
    await db.execute('''
      CREATE TABLE tracked_players (
        server_id TEXT NOT NULL,
        name TEXT NOT NULL,
        player_id TEXT,
        is_online INTEGER NOT NULL DEFAULT 0,
        last_seen TEXT NOT NULL,
        notify_on_online INTEGER NOT NULL DEFAULT 1,
        notify_on_offline INTEGER NOT NULL DEFAULT 0,
        notification_sent INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (server_id, name)
      )
    ''');

    // Wipe Alerts table (New in v10)
    await db.execute('''
      CREATE TABLE wipe_alerts (
        server_id TEXT PRIMARY KEY,
        server_name TEXT,
        wipe_time TEXT NOT NULL,
        alert_minutes INTEGER NOT NULL DEFAULT 30,
        is_enabled INTEGER NOT NULL DEFAULT 0,
        notification_id INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Ensure the optimized composite index exists for all users
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_notifications_package_channel_timestamp 
      ON notifications(package_name, channel_id, timestamp DESC)
    ''');

    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS permission_cache (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          permission_type TEXT UNIQUE NOT NULL,
          is_granted INTEGER NOT NULL,
          last_checked INTEGER NOT NULL
        )
      ''');
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_permission_cache_type ON permission_cache(permission_type)
      ''');
    }
    
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS favorites (
          id TEXT PRIMARY KEY,
          data TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS tracked_players (
            server_id TEXT NOT NULL,
            name TEXT NOT NULL,
            player_id TEXT, 
            is_online INTEGER NOT NULL DEFAULT 0,
            last_seen TEXT NOT NULL,
            notify_on_online INTEGER NOT NULL DEFAULT 1,
            notify_on_offline INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY (server_id, name)
          )
        ''');
    }

    if (oldVersion < 6) {
      if (!await _columnExists(db, 'tracked_players', 'notify_on_online')) {
        await db.execute('ALTER TABLE tracked_players ADD COLUMN notify_on_online INTEGER NOT NULL DEFAULT 1');
      }
      if (!await _columnExists(db, 'tracked_players', 'notify_on_offline')) {
        await db.execute('ALTER TABLE tracked_players ADD COLUMN notify_on_offline INTEGER NOT NULL DEFAULT 0');
      }
    }
    
    if (oldVersion < 7) {
      if (!await _columnExists(db, 'tracked_players', 'player_id')) {
        await db.execute('ALTER TABLE tracked_players ADD COLUMN player_id TEXT');
      }
    }

    if (oldVersion < 8) {
      if (!await _columnExists(db, 'tracked_players', 'player_id')) {
        await db.execute('ALTER TABLE tracked_players ADD COLUMN player_id TEXT');
      }
    }
    
    if (oldVersion < 9) {
      if (!await _columnExists(db, 'tracked_players', 'notification_sent')) {
        await db.execute('ALTER TABLE tracked_players ADD COLUMN notification_sent INTEGER NOT NULL DEFAULT 0');
      }
    }

    if (oldVersion < 10) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS wipe_alerts (
          server_id TEXT PRIMARY KEY,
          server_name TEXT,
          wipe_time TEXT NOT NULL,
          alert_minutes INTEGER NOT NULL DEFAULT 30,
          is_enabled INTEGER NOT NULL DEFAULT 0,
          notification_id INTEGER NOT NULL
        )
      ''');
    }
  }

  // Wipe Alerts Methods
  Future<void> saveWipeAlert({
    required String serverId,
    required String serverName,
    required String wipeTime,
    required int alertMinutes,
    required bool isEnabled,
  }) async {
    final db = await database;
    // Generate a stable notification ID based on server ID hash to ensure consistency
    final notificationId = serverId.hashCode.abs(); 
    
    await db.insert(
      'wipe_alerts',
      {
        'server_id': serverId,
        'server_name': serverName,
        'wipe_time': wipeTime,
        'alert_minutes': alertMinutes,
        'is_enabled': isEnabled ? 1 : 0,
        'notification_id': notificationId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getWipeAlert(String serverId) async {
    final db = await database;
    final results = await db.query(
      'wipe_alerts',
      where: 'server_id = ?',
      whereArgs: [serverId],
    );
    if (results.isNotEmpty) return results.first;
    return null;
  }

  Future<void> deleteWipeAlert(String serverId) async {
    final db = await database;
    await db.delete(
      'wipe_alerts',
      where: 'server_id = ?',
      whereArgs: [serverId],
    );
  }

  // Permssion cache metodları
  Future<void> saveFavorite(Map<String, dynamic> serverJson) async {
    final db = await database;
    final id = serverJson['id']?.toString() ?? '';
    if (id.isEmpty) return;
    
    await db.insert(
      'favorites',
      {'id': id, 'data': jsonEncode(serverJson)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps.map((e) => jsonDecode(e['data'] as String) as Map<String, dynamic>).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  // Tracked Players Methods
  Future<void> saveTrackedPlayer({
    required String serverId,
    required String name,
    String? playerId,
    required bool isOnline,
    required String lastSeen,
    bool notifyOnOnline = true,
    bool notifyOnOffline = false,
  }) async {
    final db = await database;
    await db.insert(
      'tracked_players',
      {
        'server_id': serverId,
        'name': name,
        'player_id': playerId,
        'is_online': isOnline ? 1 : 0,
        'last_seen': lastSeen,
        'notify_on_online': notifyOnOnline ? 1 : 0,
        'notify_on_offline': notifyOnOffline ? 1 : 0,
        'notification_sent': 0, // Reset when user updates tracking
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeTrackedPlayer(String serverId, String name) async {
    final db = await database;
    await db.delete(
      'tracked_players',
      where: 'server_id = ? AND name = ?',
      whereArgs: [serverId, name],
    );
  }

  Future<List<Map<String, dynamic>>> getTrackedPlayers(String serverId) async {
    final db = await database;
    return await db.query(
      'tracked_players',
      where: 'server_id = ?',
      whereArgs: [serverId],
    );
  }

  Future<void> updateTrackedPlayerStatus({
    required String serverId,
    required String playerId,
    required bool isOnline,
    required String lastSeen,
    bool notificationSent = false,
  }) async {
    final db = await database;
    await db.update(
      'tracked_players',
      {
        'is_online': isOnline ? 1 : 0,
        'last_seen': lastSeen,
        'notification_sent': notificationSent ? 1 : 0,
      },
      where: 'server_id = ? AND player_id = ?',
      whereArgs: [serverId, playerId],
    );
  }

  // Permission cache metodları
  Future<void> savePermissionState(String permissionType, bool isGranted) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    await db.insert(
      'permission_cache',
      {
        'permission_type': permissionType,
        'is_granted': isGranted ? 1 : 0,
        'last_checked': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<bool?> getPermissionState(String permissionType) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'permission_cache',
      where: 'permission_type = ?',
      whereArgs: [permissionType],
    );
    
    if (maps.isNotEmpty) {
      return maps.first['is_granted'] == 1;
    }
    
    return null; // Cache'de yok
  }
  
  Future<Map<String, bool>> getAllPermissionStates() async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query('permission_cache');
    
    final Map<String, bool> permissions = {};
    for (final map in maps) {
      permissions[map['permission_type']] = map['is_granted'] == 1;
    }
    
    return permissions;
  }
  
  Future<void> clearPermissionCache() async {
    final db = await database;
    await db.delete('permission_cache');
  }
  
  Future<bool> isPermissionCacheValid(String permissionType) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'permission_cache',
      where: 'permission_type = ?',
      whereArgs: [permissionType],
    );
    
    if (maps.isEmpty) return false;
    
    final lastChecked = maps.first['last_checked'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    const cacheValidityDuration = 5 * 60 * 1000; // 5 dakika
    
    return (now - lastChecked) < cacheValidityDuration;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<bool> _columnExists(Database db, String table, String column) async {
    try {
      final results = await db.rawQuery('PRAGMA table_info($table)');
      for (final row in results) {
        if (row['name'] == column) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // App Settings metodları
  Future<void> saveAppSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value, 'updated_at': DateTime.now().millisecondsSinceEpoch ~/ 1000},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getAppSetting(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) return maps.first['value'] as String;
    return null;
  }

  Future<bool> getBoolSetting(String key) async {
    final val = await getAppSetting(key);
    return val == 'true' || val == '1';
  }

  // Active Server Helper Methods
  Future<void> saveActiveServer(Map<String, dynamic> serverJson) async {
    await saveAppSetting('active_server', jsonEncode(serverJson));
  }

  Future<Map<String, dynamic>?> getActiveServer() async {
    final jsonStr = await getAppSetting('active_server');
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        return jsonDecode(jsonStr) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearActiveServer() async {
    await saveAppSetting('active_server', '');
  }

  Future<String> getDatabasePath() async {
    if (_databasePath == null) {
      final databasesPath = await getDatabasesPath();
      _databasePath = join(databasesPath, _databaseName);
    }
    return _databasePath!;
  }
}
