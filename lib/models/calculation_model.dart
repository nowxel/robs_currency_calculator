//Model for current calculation data transition
class CalculationModel{
  Map <String, String> signRate = {'': ''};

  String activeSign = '';
  String activeRate = '';

  String firstSign = '';
  String lastSign = '';

  String tax = '';
  String vat = '';

  String upperStr = '';
  String upperMarginStr = '';
  String upperCurrencyStr = '';
  String currentNumber = '0';
  String lowerStr = '0';
  String strForScreen = '0';

  String cost = '';
  String sell = '';
  String margin = '';
  String costCurrency = '';
  String sellCurrency = '';

  bool lastSetVatTax = false;
  bool isDecimal = false;
  bool needToClear = false;
  bool currencyActive = false;

  int activeMode = 0;

  void clearModel(){
    needToClear = false;
    isDecimal = false;
    currencyActive = false;
    currentNumber = '0';
    strForScreen = '0';
    lowerStr = '0';

    firstSign = '';
    lastSign = '';

    activeSign = '';
    activeRate = '';
  }

  @override
  String toString() {
    return '{ "activeMode": $activeMode, "upperStr": $upperStr, "sell": $sell, "margin": $margin, "costCurrency": $costCurrency, "sellCurrency": $sellCurrency, "signRate": ${signRate.toString()}}';
  }

}