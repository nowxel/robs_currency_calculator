import 'dart:convert';

import 'errors.dart';

class Currencies {
  Currencies({
    this.success,
    this.timestamp,
    this.base,
    this.date,
    this.rates,
    this.symbols,
    this.error,
  });

  factory Currencies.fromRawJson(String str) =>
      Currencies.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Currencies.fromJson(Map<String, dynamic> json) => Currencies(
        success: json['success'] as bool,
        timestamp: json['timestamp'] != null ? json['timestamp'] as int : null,
        base: json['base'] != null ? json['base'] as String : null,
        date: json['date'] != null ? json['date'] as String : null,
        rates: json['rates'] != null
            ? Map<String, dynamic>.from(json['rates'] as Map<String, dynamic>)
                .map((k, v) => MapEntry<String, dynamic>(k, v))
            : null,
        symbols: json['symbols'] != null
            ? Map<String, String>.from(json['symbols'] as Map<String, dynamic>)
                .map((k, v) => MapEntry<String, String>(k, v))
            : null,
        error: json['error'] != null
            ? RequestError.fromJson(json['error'] as Map<String, dynamic>)
            : null,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'success': success,
        'timestamp': timestamp,
        'base': base,
        'date': date,
        'rates': Map<String, dynamic>.from(rates)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        'symbols': Map<String, dynamic>.from(symbols)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        'error': error,
      };

  @override
  String toString() {
    return '{ "success": $success, "timestamp": $timestamp, "base": $base, "date": $date, "rates": ${rates.toString()}, "error": $error, "symbols": ${symbols.toString()}}';
  }

  final bool success;
  final int timestamp;
  final String base;
  final String date;
  final Map<String, dynamic> rates;
  final RequestError error;
  final Map<String, String> symbols;
}
