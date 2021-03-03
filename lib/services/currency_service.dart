import 'dart:io';

import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/html/http_errors.dart';
import 'package:robs_currency_calculator/models/currencies.dart';
import 'package:robs_currency_calculator/repositories/database_repository.dart';
import 'package:intl/intl.dart';
import 'package:robs_currency_calculator/utils/resources.dart';

abstract class ICurrencyService {
  Future<dynamic> fetchCurrencies({String url});

  String getCurrencySign({String currencyCode});

  String getBaseCurrency();
}

class CurrencyService extends ICurrencyService {
  final DataBaseRepository _dataBaseRepository = DataBaseRepository();
  final HttpErrors _httpErrors = HttpErrors();

  @override
  String getBaseCurrency({BuildContext context}) {
    final NumberFormat format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencyName ?? 'USD';
  }

  @override
  Future<Currencies> fetchCurrencies({String url}) async {
    try {
      final dynamic response = await _dataBaseRepository.get(path: url);
      final Currencies result = Currencies.fromJson(response as Map<String, dynamic>);
      if (result?.error != null) {
        _httpErrors.checkError(result.error.code, result.error.info);
      }
      return Currencies.fromJson(response as Map<String, dynamic>);
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getCurrencySign({String currencyCode}) {
    String result = '';
    if (currencySigns.containsKey(currencyCode)) {
      result = currencySigns[currencyCode];
    } else {
      result = NumberFormat.simpleCurrency(name: currencyCode).currencySymbol;
      if (result == '\$' || result == '£' || result == '₴') {
        result = currencyCode;
      }
    }
    return (result == null || result.isEmpty) ? currencyCode : result;
  }
}
