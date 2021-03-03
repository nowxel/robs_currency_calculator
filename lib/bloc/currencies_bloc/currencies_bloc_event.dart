part of 'currencies_bloc.dart';

abstract class CurrenciesEvent extends Equatable {
  const CurrenciesEvent();
}

class FetchCurrenciesRatesEvent extends CurrenciesEvent {
  const FetchCurrenciesRatesEvent({this.currencies, this.url});

  final Currencies currencies;
  final String url;

  @override
  List<Object> get props => [currencies];
}

class FetchAllCurrenciesRatesEvent extends CurrenciesEvent {
  const FetchAllCurrenciesRatesEvent({this.currencies, this.url});

  final Currencies currencies;
  final String url;

  @override
  List<Object> get props => [currencies];
}

class FetchCurrenciesDescriptionEvent extends CurrenciesEvent {
  const FetchCurrenciesDescriptionEvent({this.currencies, this.url});

  final Currencies currencies;
  final String url;

  @override
  List<Object> get props => [currencies];
}

class SearchCurrenciesEvent extends CurrenciesEvent {
  const SearchCurrenciesEvent({this.currencies, this.searchPattern});

  final Currencies currencies;
  final String searchPattern;

  @override
  List<Object> get props => [currencies];
}

class SelectCurrencyEvent extends CurrenciesEvent {
  const SelectCurrencyEvent({this.currencyCode, this.buttonNumber});

  final String currencyCode;
  final int buttonNumber;

  @override
  List<Object> get props => [currencyCode, buttonNumber];
}

class AutoLoadCurrencyEvent extends CurrenciesEvent {
  const AutoLoadCurrencyEvent({this.autoLoad});

  final bool autoLoad;

  @override
  List<Object> get props => [autoLoad];
}
