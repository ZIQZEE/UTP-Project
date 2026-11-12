import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AlertRecord {
  final String type; // e.g. 'high_risk' — used to look up translated text at display time
  final DateTime timestamp;

  AlertRecord({
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'timestamp': timestamp.toIso8601String(),
      };

  factory AlertRecord.fromJson(Map<String, dynamic> json) => AlertRecord(
        // Backward-compatible: older saved records (before this change)
        // didn't have a 'type' field, only 'title'/'message'. Since the
        // app currently only ever generates High-risk alerts, default to
        // that so old test data still displays instead of breaking.
        type: json['type'] ?? 'high_risk',
        timestamp: DateTime.parse(json['timestamp']),
      );
}

/// Stores a local history of alerts the user has received on this
/// device. Only a type + timestamp is stored — the actual title/body
/// text is looked up via tr() at display time, in whatever language is
/// currently active, not the language that was active when the alert
/// originally fired.
class AlertHistoryService {
  static const _key = 'alert_history';

  static Future<void> addAlert(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAlerts();

    final updated = [
      AlertRecord(type: type, timestamp: DateTime.now()),
      ...existing,
    ];

    // Keep only the most recent 50 to avoid unbounded growth.
    final trimmed = updated.take(50).toList();

    final jsonList = trimmed.map((a) => a.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<AlertRecord>> getAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => AlertRecord.fromJson(e)).toList();
  }

  static Future<void> clearAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}