class NotificationData {
  static const String _keyTitle = 'title';
  static const String _keyBody = 'body';
  static const String _keySubtitle = 'subtitle';
  static const String _keyPackageName = 'packageName';
  static const String _keyTimestamp = 'timestamp';
  static const String _keyChannelId = 'channelId';

  final String? title;
  final String? body;
  final String? subtitle;
  final String packageName;
  final int timestamp;
  final String? channelId;

  NotificationData({
    required this.packageName,
    required this.timestamp,
    this.title,
    this.body,
    this.subtitle,
    this.channelId,
  });

  factory NotificationData.fromMap(Map<dynamic, dynamic> map) {
    try {
      return NotificationData(
        title: map[_keyTitle]?.toString(),
        body: map[_keyBody]?.toString(),
        subtitle: map[_keySubtitle]?.toString(),
        packageName: map[_keyPackageName]?.toString() ?? '',
        timestamp: map[_keyTimestamp] is int 
            ? map[_keyTimestamp] as int
            : (map[_keyTimestamp] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
        channelId: map[_keyChannelId]?.toString(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      _keyTitle: title,
      _keyBody: body,
      _keySubtitle: subtitle,
      _keyPackageName: packageName,
      _keyTimestamp: timestamp,
      _keyChannelId: channelId,
    };
  }

  @override
  String toString() {
    return 'NotificationData('
        'title: $title, '
        'body: $body, '
        'subtitle: $subtitle, '
        'packageName: $packageName, '
        'timestamp: $timestamp, '
        'channelId: $channelId'
        ')';
  }
}

