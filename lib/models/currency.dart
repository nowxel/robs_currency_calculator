import 'package:robs_currency_calculator/utils/resources.dart';

class Currency {
  Currency(
      {this.currencyCode,
      this.currencySign,
      this.currencyRate,
      this.currencyDescription});
  String currencyCode = '';
  String currencySign = defaultCurrencySymbol;
  dynamic currencyRate = 1.0;
  String currencyDescription = '';
}
