part of 'currencies_bloc.dart';

abstract class CurrenciesState extends Equatable {
  const CurrenciesState();
}

class FetchCurrenciesRatesState extends CurrenciesState {
  const FetchCurrenciesRatesState({this.currencies, this.lastRatesUpdate});

  final Currencies currencies;
  final DateTime lastRatesUpdate;

  @override
  List<Object> get props => [currencies, lastRatesUpdate];
}

class FetchAllCurrenciesRatesState extends CurrenciesState {
  const FetchAllCurrenciesRatesState({this.currencies, this.lastRatesUpdate});

  final Currencies currencies;
  final DateTime lastRatesUpdate;

  @override
  List<Object> get props => [currencies, lastRatesUpdate];
}

class FetchCurrenciesDescriptionState extends CurrenciesState {
  const FetchCurrenciesDescriptionState({this.currencies});

  final Currencies currencies;

  @override
  List<Object> get props => [currencies];
}

class SearchCurrenciesState extends CurrenciesState {
  const SearchCurrenciesState({this.currencies, this.searchPattern});

  final Currencies currencies;
  final String searchPattern;

  @override
  List<Object> get props => [currencies, searchPattern];
}

class SelectCurrencyState extends CurrenciesState {
  const SelectCurrencyState({this.currencyCode, this.buttonNumber, this.lastRatesUpdate});

  final String currencyCode;
  final int buttonNumber;
  final DateTime lastRatesUpdate;

  @override
  List<Object> get props => [currencyCode, buttonNumber, lastRatesUpdate];
}

class AutoLoadCurrencyState extends CurrenciesState {
  const AutoLoadCurrencyState({this.autoLoad});

  final bool autoLoad;

  @override
  List<Object> get props => [autoLoad];
}
