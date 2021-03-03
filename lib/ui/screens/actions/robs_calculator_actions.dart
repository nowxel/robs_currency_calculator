import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/models/currencies.dart';
import 'package:robs_currency_calculator/models/currency.dart';
import 'package:robs_currency_calculator/utils/api_url.dart';
import 'package:robs_currency_calculator/services/currency_service.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';
import 'package:robs_currency_calculator/utils/resources.dart';

mixin RobsCalculatorActions {

  //-------------------- Currencies -------------------------

  final CurrencyService _currencyService = CurrencyService();

  // fetch rates for selected currencies
  // results (instance of Currencies) gets into Bloc
  void fetchSelectedCurrenciesRates({BuildContext context, List<String> currencyCodes}) {
    final String baseCurrency = _currencyService.getBaseCurrency(context: context);
    final String codes = currencyCodes.toString().replaceAll(' ', '').replaceAll('[','').replaceAll(']', '');
    final String url = '$latestRatesUrl$accessKey$baseCurrencyUrl$baseCurrency$currencyCodesUrl$codes';
    BlocProvider.of<CurrenciesBloc>(context).add(FetchCurrenciesRatesEvent(url: url));
  }

  //returns all currencies rates
  void fetchAllCurrenciesRates({BuildContext context}) {
    final String baseCurrency = _currencyService.getBaseCurrency(context: context);
    final String url = '$latestRatesUrl$accessKey$baseCurrencyUrl$baseCurrency';
    BlocProvider.of<CurrenciesBloc>(context).add(FetchAllCurrenciesRatesEvent(url: url));
  }

  // returns selected currencies list by it's codes
  List<Currency> fetchSelectedCurrencies({Currencies currencies, List<String> selectedCurrenciesCodes}){
    final List<Currency> list = [];
    for (int i = 0; i < selectedCurrenciesCodes?.length; i++){
      for (final MapEntry<String, dynamic> data in currencies?.rates?.entries) {
        if (data.key.toUpperCase() == selectedCurrenciesCodes[i].toUpperCase()) {
          list.add(Currency(
            currencyCode: data.key,
            currencyRate: data.value,
            currencySign: _currencyService.getCurrencySign(currencyCode: data.key),
          ));
        }
      }
    }
    return list;
  }

  // returns one selected currency
  Currency fetchSelectedCurrency({String currencyCode, Currencies currencies}){
    final Currency currency = Currency();
    for (final MapEntry<String, dynamic> data in currencies?.rates?.entries) {
      if (data.key.toUpperCase() == currencyCode.toUpperCase()) {
        currency.currencyCode = data.key;
        currency.currencyRate = data.value;
        currency.currencySign =  _currencyService.getCurrencySign(currencyCode: data.key);
      }
    }
    return currency;
  }

  //returns list of currencies codes
  List<String> fetchSelectedCurrenciesCodes (List<Currency> currencies){
    final List<String> result = [];
    for(final Currency tmp in currencies){
      result.add(tmp.currencyCode);
    }
    return result;
  }

  //returns description for all the currencies
  void fetchCurrenciesDescriptions({BuildContext context}) {
    BlocProvider.of<CurrenciesBloc>(context).add(const FetchCurrenciesDescriptionEvent(url: '$currencyDescriptionUrl$accessKey'));
  }

  //returns one currency by index
  void fetchCurrency ({BuildContext context, int index, String currencyCode}){
    BlocProvider.of<CurrenciesBloc>(context).add(SelectCurrencyEvent(buttonNumber: index, currencyCode: currencyCode));
  }

  //returns currency sign by it's code
  String getCurrencySign (String currencyCode){
    return _currencyService.getCurrencySign(currencyCode: currencyCode);
  }


  void navigateToScreen({BuildContext context, String screenName, int arguments}) {
    Navigator.pushNamed(context, screenName, arguments:  [arguments]);
  }

  //changes currencies autoload status
  void autoLoadCurrencies({BuildContext context, bool autoLoad}){
    BlocProvider.of<CurrenciesBloc>(context).add(AutoLoadCurrencyEvent(autoLoad: autoLoad));
  }

  //returns currencies codes from local storage
  List<String> loadCurrenciesFromStorage () {
    final LocalStorage _localStorage = LocalStorage();
    List<String> selectedCurrenciesCodes = [];
    _localStorage.getCurrency().then((value) {
      selectedCurrenciesCodes = value;
    });
    return selectedCurrenciesCodes ?? defaultSelectedCurrencies;
  }

  //--------- Subscriptions / In-App Purchases ------------

  void fetchProducts({BuildContext context}) {
    BlocProvider.of<PurchasesBloc>(context).add(FetchProductsEvent());
  }

  void fetchPurchases({BuildContext context}) {
    BlocProvider.of<PurchasesBloc>(context).add(FetchPurchasesEvent());
  }

  void purchaseMonthly({BuildContext context}) {
    BlocProvider.of<PurchasesBloc>(context).add(PurchaseMonthlyEvent());
  }

  void purchaseAnnual({BuildContext context}) {
    BlocProvider.of<PurchasesBloc>(context).add(PurchaseAnnualEvent());
  }

  void restorePurchases({BuildContext context}) {
    BlocProvider.of<PurchasesBloc>(context).add(RestorePurchasesEvent());
  }
/*
  void navigateToScreen({BuildContext context, String screenName}) {
    Navigator.pushNamed(context, screenName);
  }
 */
}
