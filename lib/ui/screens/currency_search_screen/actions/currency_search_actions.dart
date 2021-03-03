import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/models/currencies.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';

mixin CurrencySearchActions {
  Currencies searchCurrenciesByDescription({Currencies currencies, String searchStr}) {
    final Currencies result = Currencies(success: true, symbols: {});
    if (searchStr != null && searchStr.isNotEmpty) {
      for (final MapEntry<String, String> data in currencies.symbols.entries) {
        if (data.value.toLowerCase().contains(searchStr.toLowerCase()) ||
            data.key.toLowerCase().contains(searchStr.toLowerCase())) {
          result.symbols[data.key] = data.value;
        }
      }
    }
    return result;
  }

  void searchCurrencies({BuildContext context, Currencies currencies, String searchPattern}) {
    BlocProvider.of<CurrenciesBloc>(context).add(
      SearchCurrenciesEvent(
          currencies: searchCurrenciesByDescription(currencies: currencies, searchStr: searchPattern),
          searchPattern: searchPattern),
    );
  }

}
