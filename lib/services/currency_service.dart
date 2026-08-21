import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyRates {
  CurrencyRates({
    required this.base,
    required this.date,
    required this.rates,
    required this.fromCache,
  });

  final String base;
  final String date;
  final Map<String, double> rates;
  final bool fromCache;
}

class CurrencyService {
  CurrencyService._();
  static final CurrencyService instance = CurrencyService._();

  static const _cachePrefix = 'sc_fx_';

  /// Popular currencies for global English users (+ PKR for local).
  static const popular = <String>[
    'USD',
    'EUR',
    'GBP',
    'PKR',
    'INR',
    'AED',
    'SAR',
    'CAD',
    'AUD',
    'JPY',
    'CNY',
    'CHF',
    'TRY',
    'MYR',
    'SGD',
  ];

  Future<CurrencyRates> fetchRates(String base) async {
    final code = base.toUpperCase();
    try {
      final uri = Uri.parse('https://open.er-api.com/v6/latest/$code');
      final res = await http.get(uri).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['result'] != 'success') {
        throw Exception(json['error-type']?.toString() ?? 'API error');
      }
      final rawRates = json['rates'] as Map<String, dynamic>? ?? {};
      final rates = <String, double>{
        for (final e in rawRates.entries)
          e.key: (e.value as num).toDouble(),
      };
      rates[code] = 1.0;
      final date = json['time_last_update_utc']?.toString() ??
          DateTime.now().toUtc().toIso8601String();
      await _saveCache(code, date, rates);
      return CurrencyRates(
        base: code,
        date: date,
        rates: rates,
        fromCache: false,
      );
    } catch (_) {
      final cached = await _loadCache(code);
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<void> _saveCache(
    String base,
    String date,
    Map<String, double> rates,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_cachePrefix$base',
      jsonEncode({'date': date, 'rates': rates}),
    );
  }

  Future<CurrencyRates?> _loadCache(String base) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_cachePrefix$base');
    if (raw == null || raw.isEmpty) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final ratesRaw = json['rates'] as Map<String, dynamic>? ?? {};
    return CurrencyRates(
      base: base,
      date: json['date']?.toString() ?? 'cached',
      rates: {
        for (final e in ratesRaw.entries) e.key: (e.value as num).toDouble(),
      },
      fromCache: true,
    );
  }

  double convert({
    required double amount,
    required String from,
    required String to,
    required Map<String, double> ratesWithBase,
    required String base,
  }) {
    final f = from.toUpperCase();
    final t = to.toUpperCase();
    if (f == t) return amount;
    final fromRate = ratesWithBase[f];
    final toRate = ratesWithBase[t];
    if (fromRate == null || toRate == null || fromRate == 0) {
      throw Exception('Currency not available');
    }
    // rates are relative to `base`
    final inBase = amount / fromRate;
    return inBase * toRate;
  }
}
