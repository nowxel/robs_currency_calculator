import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/models/currencies.dart';
import 'package:robs_currency_calculator/services/currency_service.dart';
import 'package:robs_currency_calculator/utils/api_url.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';

part 'currencies_bloc_event.dart';

part 'currencies_bloc_state.dart';

class CurrenciesBloc extends Bloc<CurrenciesEvent, CurrenciesState> {
  CurrenciesBloc() : super(null);

  final CurrencyService _currencyService = CurrencyService();
  final LocalStorage _localStorage = LocalStorage();
  DateTime lastAccess;
  Currencies allRates;
  Currencies selectedRates;
  Currencies descriptions;

  bool checkLastAccess(){
    if (lastAccess == null) {
      _localStorage.getLastUpdateDate().then((value){
        lastAccess = value;
      });
      lastAccess ??= DateTime.now();
      _localStorage.setLastUpdateDate(lastAccess);
    }
    if (DateTime.now().difference(lastAccess).inMinutes > updateInterval){
      return true;
    } return false;
  }

  @override
  Stream<CurrenciesState> mapEventToState(CurrenciesEvent event) async* {
    if (event is FetchCurrenciesRatesEvent) {
      if (checkLastAccess() || allRates == null) {
        allRates = await _currencyService?.fetchCurrencies(url: event.url);
      }
      yield FetchCurrenciesRatesState(currencies: allRates, lastRatesUpdate: lastAccess);
    } else if (event is FetchCurrenciesDescriptionEvent) {
      if (checkLastAccess() || descriptions == null) {
        descriptions = await _currencyService?.fetchCurrencies(url: event.url);
      }
      yield FetchCurrenciesDescriptionState(currencies: descriptions);
    } else if (event is SearchCurrenciesEvent) {
      yield SearchCurrenciesState(
          currencies: event.currencies, searchPattern: event.searchPattern);
    } else if (event is SelectCurrencyEvent) {
      yield SelectCurrencyState(
          currencyCode: event.currencyCode, buttonNumber: event.buttonNumber, lastRatesUpdate: lastAccess);
    } else if (event is AutoLoadCurrencyEvent) {
      yield AutoLoadCurrencyState(autoLoad: event.autoLoad);
    } else if (event is FetchAllCurrenciesRatesEvent) {
      if (checkLastAccess() || allRates == null) {
        allRates = await _currencyService?.fetchCurrencies(url: event.url);
      }
      yield FetchAllCurrenciesRatesState(
          currencies: allRates, lastRatesUpdate: lastAccess);
    }
  }
}
