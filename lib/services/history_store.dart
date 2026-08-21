import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HistoryItem {
  HistoryItem({
    required this.expression,
    required this.result,
    required this.timestamp,
    this.tag = 'calc',
  });

  final String expression;
  final String result;
  final DateTime timestamp;
  final String tag;

  Map<String, dynamic> toJson() => {
        'expression': expression,
        'result': result,
        'timestamp': timestamp.toIso8601String(),
        'tag': tag,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> j) => HistoryItem(
        expression: j['expression'] as String? ?? '',
        result: j['result'] as String? ?? '',
        timestamp:
            DateTime.tryParse(j['timestamp'] as String? ?? '') ?? DateTime.now(),
        tag: j['tag'] as String? ?? 'calc',
      );
}

class HistoryStore {
  HistoryStore._();
  static final HistoryStore instance = HistoryStore._();

  static const _key = 'sc_history_v1';
  final List<HistoryItem> items = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    items.clear();
    if (raw == null || raw.isEmpty) return;
    final list = jsonDecode(raw) as List<dynamic>;
    items.addAll(
      list.map((e) => HistoryItem.fromJson(e as Map<String, dynamic>)),
    );
  }

  Future<void> add(HistoryItem item) async {
    items.insert(0, item);
    if (items.length > 100) {
      items.removeRange(100, items.length);
    }
    await _save();
  }

  Future<void> clear() async {
    items.clear();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }
}
