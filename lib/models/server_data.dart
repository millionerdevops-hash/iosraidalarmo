import 'package:json_annotation/json_annotation.dart';

/// Centralized Server Data Model
/// Used across the app to represent a Rust server.
class ServerData {
  final String id;
  final String name;
  final String ip;
  final int port;
  final int players;
  final int maxPlayers;
  final String status; // 'online' or 'offline'
  final int? rank;

  final String? map;
  final String? mapSize;
  final String? seed;
  final String? lastWipe;
  final String? nextWipe;
  final String? description;
  final String? url;
  final bool official;
  final bool modded;
  final bool pve;
  final int? fps;
  final int? uptime;
  final String? headerImage;

  bool get community => !official && !modded;

  const ServerData({
    required this.id,
    required this.name,
    required this.ip,
    required this.port,
    required this.players,
    required this.maxPlayers,
    required this.status,
    this.rank,

    this.map,
    this.mapSize,
    this.seed,
    this.lastWipe,
    this.nextWipe,
    this.description,
    this.url,
    this.official = false,
    this.modded = false,
    this.pve = false,
    this.fps,
    this.uptime,
    this.headerImage,
  });

  factory ServerData.fromJson(Map<String, dynamic> json) {
    // Check if the JSON is from BattleMetrics API structure (attributes/details)
    // or a flat structure (from database/sharedprefs)
    
    if (json.containsKey('attributes')) {
      // BattleMetrics API Structure
      final attr = json['attributes'] ?? {};
      final details = attr['details'] ?? {};
      return ServerData(
        id: json['id']?.toString() ?? '',
        name: attr['name']?.toString() ?? 'Unknown Server',
        ip: attr['ip']?.toString() ?? '0.0.0.0',
        port: attr['port'] ?? 0,
        players: attr['players'] ?? 0,
        maxPlayers: attr['maxPlayers'] ?? 0,
        status: attr['status']?.toString().toLowerCase() ?? 'offline',
        rank: attr['rank'],

        map: details['map']?.toString(),
        mapSize: details['rust_world_size']?.toString(),
        seed: details['rust_world_seed']?.toString(),
        lastWipe: details['rust_last_wipe']?.toString(),
        nextWipe: details['rust_next_wipe']?.toString(),
        description: details['rust_description']?.toString(),
        url: details['rust_url']?.toString(),
        official: details['official'] == true || details['official'].toString() == 'true',
        modded: details['rust_modded'] == true || details['rust_modded'].toString() == 'true' || details['modded'] == true || details['modded'].toString() == 'true',
        pve: details['pve'] == true || details['pve'].toString() == 'true',
        fps: details['rust_fps'],
        uptime: details['rust_uptime'],
        headerImage: details['rust_headerimage']?.toString(),
      );
    } else {
      // Flat Structure (Saved Data)
      return ServerData(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? 'Unknown',
        ip: json['ip']?.toString() ?? '0.0.0.0',
        port: json['port'] ?? 0,
        players: json['players'] ?? 0,
        maxPlayers: json['maxPlayers'] ?? 0,
        status: json['status']?.toString().toLowerCase() ?? 'offline',
        rank: json['rank'],

        map: json['map'],
        mapSize: json['mapSize'],
        seed: json['seed'],
        lastWipe: json['lastWipe'],
        nextWipe: json['nextWipe'],
        description: json['description'],
        url: json['url'],
        official: json['official'] == true || json['official'].toString() == 'true',
        modded: json['modded'] == true || json['modded'].toString() == 'true',
        pve: json['pve'] == true || json['pve'].toString() == 'true',
        fps: json['fps'],
        uptime: json['uptime'],
        headerImage: json['headerImage'],
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ip': ip,
        'port': port,
        'players': players,
        'maxPlayers': maxPlayers,
        'status': status,
        'rank': rank,

        'map': map,
        'mapSize': mapSize,
        'seed': seed,
        'lastWipe': lastWipe,
        'nextWipe': nextWipe,
        'description': description,
        'url': url,
        'official': official,
        'modded': modded,
        'pve': pve,
        'fps': fps,
        'uptime': uptime,
        'headerImage': headerImage,
      };
}
