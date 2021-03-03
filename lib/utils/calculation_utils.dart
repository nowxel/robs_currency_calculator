import 'package:decimal/decimal.dart';
import 'package:robs_currency_calculator/models/calculation_model.dart';
import 'package:robs_currency_calculator/models/numbers_calc_model.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';

class CalculationUtils {
  CalculationModel addCurrency(
      CalculationModel model, String sign, String rate) {
    if (model.firstSign == '') {
      model.firstSign = sign;
    }

    model.activeSign = sign;
    model.activeRate = rate;

    if (model.needToClear && model.firstSign != '') {
      model.strForScreen = cleanStringSign(str: model.strForScreen);
      model.strForScreen = (Decimal.parse(model.strForScreen) *
              Decimal.parse(model.signRate[sign]) /
              Decimal.parse(model.signRate[model.firstSign]))
          .toString();
      model.firstSign = sign;
      model.strForScreen = '${model.firstSign}${model.strForScreen}';
      model.lowerStr = model.strForScreen;

      model.currencyActive = true;
      return model;
    }

    if (sign != model.firstSign && !model.lowerStr.contains('#')) {
      model.upperCurrencyStr = '';
      model.upperCurrencyStr =
          '${model.firstSign} ${returnLastNumber(str: model.lowerStr)} to ${model.activeSign} ${(Decimal.parse(returnLastNumber(str: model.lowerStr)) * Decimal.parse(model.signRate[sign]) / Decimal.parse(model.signRate[model.firstSign])).toString()}';
    }

    if (model.lowerStr.contains('#')) {
      if (model.currencyActive) {
        model.lowerStr = addSignLowerStr(model.lowerStr, sign, model);
        model.currencyActive = false;
      } else {
        if (model.lastSign != sign) {
          model.lowerStr =
              changeLastSign(str: model.lowerStr, sign: sign, model: model);
        } else {
          model.lowerStr = returnLastSign(str: model.lowerStr, sign: sign);
          model.currencyActive = true;
        }
      }

      if (sign != model.firstSign) {
        model.upperCurrencyStr = '';
        model.upperCurrencyStr =
            '${model.activeSign} ${returnLastNumber(str: model.lowerStr)} to ${model.firstSign} ${(Decimal.parse(returnLastNumber(str: model.lowerStr)) * Decimal.parse(model.signRate[model.firstSign]) / Decimal.parse(model.signRate[sign])).toString()}';
      }

      model.lastSign = sign;
      return calculateCurrency(model);
    }

    if (model.activeSign == '') {
      model.strForScreen = '$sign${model.strForScreen}';
      model.lowerStr = '$sign${model.lowerStr}';
    } else {
      if (!model.currencyActive ||
          sign != returnStringSign(str: model.lowerStr)) {
        model.strForScreen = cleanStringSign(str: model.strForScreen);
        model.strForScreen = (Decimal.parse(model.strForScreen) *
                Decimal.parse(model.signRate[sign]) /
                Decimal.parse(model.signRate[model.firstSign]))
            .toString();
        model.firstSign = sign;
        model.strForScreen = '${model.firstSign}${model.strForScreen}';
        model.lowerStr = model.strForScreen;

        model.currencyActive = true;
      } else {
        model.firstSign = '';
        model.strForScreen =
            returnLastSign(str: model.strForScreen, sign: sign);
        model.lowerStr = model.strForScreen;
        model.currencyActive = false;
      }
    }
    model.lastSign = sign;
    return model;
  }

  //Add numeric symbol into model.loverString according to rules
  CalculationModel addNumber(CalculationModel model, int number) {
    //check for first symbol
    if (model.lastSetVatTax) {
      model.lastSetVatTax = false;
      model.clearModel();
    }

    if (model.needToClear) {
      model.clearModel();
    }

    if (checkMaxNumberInput(model.lowerStr).decimal >=
            globalSettings.decimalPlaces &&
        globalSettings.forceDecimalPlacesEnabled) {
      model.lowerStr = model.lowerStr.substring(0, model.lowerStr.length - 1);
    }

    if (model.lowerStr.length > 5) {
      if (model.lowerStr
          .substring(model.lowerStr.length - 5)
          .contains('#-VAT')) {
        model.clearModel();
      } else if (model.lowerStr
          .substring(model.lowerStr.length - 5)
          .contains('#+VAT')) {
        model.clearModel();
      } else if (model.lowerStr
          .substring(model.lowerStr.length - 5)
          .contains('#-TAX')) {
        model.clearModel();
      } else if (model.lowerStr
          .substring(model.lowerStr.length - 5)
          .contains('#+TAX')) {
        model.clearModel();
      }
    }

    if (model.lowerStr == '0') {
      if (number > 0) {
        model.lowerStr = number.toString();
      }
    } else {
      //if more than one symbol
      if (model.lowerStr[model.lowerStr.length - 1] == '0' &&
          !isNumber(model.lowerStr[model.lowerStr.length - 2]) &&
          model.lowerStr[model.lowerStr.length - 2] != '.') {
        model.lowerStr = model.lowerStr.substring(0, model.lowerStr.length - 1);
      }
      model.lowerStr += number.toString();
    }
    return calculate(model);
  }

  //adding calculation action to calculating string according to rules
  CalculationModel addAction(CalculationModel model, String action) {
    if (model.needToClear) {
      model.clearModel();
    }

    model.lastSetVatTax = false;

    model.currencyActive = true;

    if (action == '#COST') {
      return calculateCost(model);
    }

    if (action == '#SELL') {
      return calculateSell(model);
    }

    if (action == '#MARGIN') {
      return calculateMargin(model);
    }

    if (action == '#SET VAT') {
      String stringWithoutPercent =
          model.strForScreen.replaceAll(RegExp('%'), '');
      stringWithoutPercent = cleanStringSign(str: stringWithoutPercent);
      model.upperStr = 'VAT = $stringWithoutPercent%';
      model.lastSetVatTax = true;
      model.tax = (Decimal.parse(stringWithoutPercent) * Decimal.parse('0.01'))
          .toString();
      model.vat = (Decimal.parse(stringWithoutPercent) * Decimal.parse('0.01'))
          .toString();
      return model;
    }

    if (action == '#SET TAX') {
      String stringWithoutPercent =
          model.strForScreen.replaceAll(RegExp('%'), '');
      stringWithoutPercent = cleanStringSign(str: stringWithoutPercent);
      model.strForScreen.replaceAll('%', '');
      model.upperStr = 'TAX = $stringWithoutPercent%';
      model.lastSetVatTax = true;
      model.tax = (Decimal.parse(stringWithoutPercent) * Decimal.parse('0.01'))
          .toString();
      model.vat = (Decimal.parse(stringWithoutPercent) * Decimal.parse('0.01'))
          .toString();
      return model;
    }

    if (action == '.' && isNumber(model.lowerStr[model.lowerStr.length - 1])) {
      if (!checkForDecimal(model.lowerStr)) {
        model.lowerStr += action;
      }
      return calculate(model);
    }

    if (model.lowerStr.length > 5) {
      if (action == '#+VAT' &&
          (model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#-VAT') ||
              model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#-TAX'))) {
        model.lowerStr = model.lowerStr.substring(0, model.lowerStr.length - 5);
        return calculate(model);
      }

      if (action == '#-VAT' &&
          (model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#+VAT') ||
              model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#+TAX'))) {
        model.lowerStr = model.lowerStr.substring(0, model.lowerStr.length - 5);
        return calculate(model);
      }

      if (action == '#+TAX' &&
          (model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#-TAX') ||
              model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#-VAT'))) {
        model.lowerStr = model.lowerStr.substring(0, model.lowerStr.length - 5);
        return calculate(model);
      }

      if (action == '#-TAX' &&
          (model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#+TAX') ||
              model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#+VAT'))) {
        model.lowerStr = model.lowerStr.substring(0, model.lowerStr.length - 5);
        return calculate(model);
      }

      if (action == '#%' &&
          (model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#+VAT') ||
              model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#-VAT'))) {
        model.lowerStr = model.lowerStr.substring(0, model.lowerStr.length);
        return calculate(model);
      }

      if (action == '.' &&
          (model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#+VAT') ||
              model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#-VAT'))) {
        model.clearModel();
      }

      if (action == '#%' &&
          (model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#+TAX') ||
              model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#-TAX'))) {
        model.lowerStr = model.lowerStr.substring(0, model.lowerStr.length);
        return calculate(model);
      }

      if (action == '.' &&
          (model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#+TAX') ||
              model.lowerStr
                  .substring(model.lowerStr.length - 5)
                  .contains('#-TAX'))) {
        model.clearModel();
      }
    }

    if (action == '#c') {
      model.clearModel();
      return calculate(model);
    }

    if (model.lowerStr == '0') {
      model.lowerStr = '0$action';
      return calculate(model);
    } else {
      if (isNumber(model.lowerStr[model.lowerStr.length - 1])) {
        model.lowerStr += action;
        return calculate(model);
      }
      if (model.lowerStr[model.lowerStr.length - 1] == '.') {
        model.lowerStr = model.lowerStr.substring(0, model.lowerStr.length - 1);
        model.lowerStr += action;
        return calculate(model);
      }
      if (action != '.') {
        if (model.lowerStr.length > 5) {
          if (model.lowerStr
              .substring(model.lowerStr.length - 5)
              .contains('#-VAT')) {
            model.lowerStr += action;
            return calculate(model);
          } else if (model.lowerStr
              .substring(model.lowerStr.length - 5)
              .contains('#+VAT')) {
            model.lowerStr += action;
            return calculate(model);
          } else if (model.lowerStr
              .substring(model.lowerStr.length - 5)
              .contains('#-TAX')) {
            model.lowerStr += action;
            return calculate(model);
          } else if (model.lowerStr
              .substring(model.lowerStr.length - 5)
              .contains('#+TAX')) {
            model.lowerStr += action;
            return calculate(model);
          }
        }
        model.lowerStr = replaceLastAction(model.lowerStr, action);
        return calculate(model);
      }
    }
    return calculate(model);
  }

  // parse and calculate an expression in mode.loverString
  CalculationModel calculate(CalculationModel model) {
    String str = model.lowerStr;

    if (model.needToClear) {
      model.clearModel();
      return model;
    }

    if (checkMaxNumberInput(str).whole > 17) {
      model.strForScreen = '∞inf';
      model.needToClear = true;
      return model;
    }

    String result = extractFirstArgumentFromString(str, model);
    str = removeFirstArgumentFromString(str);

    while (str.lastIndexOf('#') != -1) {
      final String action = extractFirstActionFromString(str);
      str = removeFirstActionFromString(str, model);

      if (action == '#+VAT' || action == '#-VAT') {
        result = doAction(action, result, model.vat);
        model.strForScreen = result.toString();
      } else if (action == '#+TAX' || action == '#-TAX') {
        result = doAction(action, result, model.vat);
        model.strForScreen = result.toString();
      } else if (action == '#%') {
        result = (Decimal.parse(result) * Decimal.parse('0.01')).toString();
        model.strForScreen = result.toString();
      } else if (str.isNotEmpty) {
        final String secondArgument =
            extractFirstArgumentFromString(str, model);
        str = removeFirstArgumentFromString(str);
        if (extractFirstActionFromString(str) == '#%') {
          result = doAction(
              action,
              result,
              (Decimal.parse(result) *
                      Decimal.parse('0.01') *
                      Decimal.parse(secondArgument))
                  .toString());
          str = removeFirstActionFromString(str, model);
        } else {
          result = doAction(action, result, secondArgument);
        }

        if (result == null) {
          model.strForScreen = 'inf';
          return model;
        }
      }
    }
    model.strForScreen = result.toString();
    model.strForScreen = '${model.firstSign}${model.strForScreen}';
    return model;
  }

  CalculationModel calculateCurrency(CalculationModel model) {
    String str = model.lowerStr;

    if (model.needToClear) {
      model.clearModel();
      return model;
    }

    if (checkMaxNumberInput(str).whole > 17) {
      model.strForScreen = '∞inf';
      model.needToClear = true;
      return model;
    }

    String result = extractFirstArgumentFromString(str, model);
    str = removeFirstArgumentFromString(str);

    while (str.lastIndexOf('#') != -1) {
      final String action = extractFirstActionFromString(str);
      str = removeFirstActionFromString(str, model);

      if (action == '#%') {
        result = (Decimal.parse(result) * Decimal.parse('0.01')).toString();
        model.strForScreen = result.toString();
      } else if (str.isNotEmpty) {
        final String secondArgument =
            extractFirstArgumentFromString(str, model);
        str = removeFirstArgumentFromString(str);

        result = doAction(action, result, secondArgument);

        if (result == null) {
          model.strForScreen = 'inf';
          return model;
        }
      }
    }
    model.strForScreen = result.toString();
    model.strForScreen = '${model.firstSign}${model.strForScreen}';
    return model;
  }

  CalculationModel calculateCost(CalculationModel model) {
    String costWithCurrency;
    final String stringWithoutPercent =
        model.strForScreen.replaceAll(RegExp('%'), '');
    model.lastSetVatTax = true;
    model.cost = stringWithoutPercent;

    if (model.sell != '' && model.margin != '') {
      model.sell = '';
      model.margin = '';
      model.upperMarginStr = '';
    }
    if (model.sell != '') {
      if (!model.upperMarginStr.contains('COST')) {
        model.upperMarginStr = '${model.upperMarginStr}   COST ${model.cost}';
      } else {
        if (model.upperMarginStr[0] == 'S') {
          model.upperMarginStr = 'SELL ${model.sell}   COST ${model.cost}';
        } else {
          model.upperMarginStr = 'COST ${model.cost}   SELL ${model.sell}';
        }
      }
      model.costCurrency = returnStringSign(str: model.cost);
      if (model.costCurrency == '' || model.sellCurrency == '') {
        model.strForScreen = ((Decimal.parse(cleanStringSign(str: model.sell)) -
                    Decimal.parse(cleanStringSign(str: model.cost))) /
                Decimal.parse(cleanStringSign(str: model.sell)) *
                Decimal.parse('100'))
            .toString();
        model.strForScreen = '${model.strForScreen}%';
        model.lowerStr = model.strForScreen;
      } else {
        costWithCurrency = (Decimal.parse(cleanStringSign(str: model.cost)) *
                Decimal.parse(model.signRate[model.sellCurrency]) /
                Decimal.parse(model.signRate[model.costCurrency]))
            .toString();
        model.strForScreen = ((Decimal.parse(cleanStringSign(str: model.sell)) -
                    Decimal.parse(cleanStringSign(str: costWithCurrency))) /
                Decimal.parse(cleanStringSign(str: model.sell)) *
                Decimal.parse('100'))
            .toString();
        model.strForScreen = '${model.strForScreen}%';
        model.lowerStr = model.strForScreen;
      }
    } else if (model.margin != '') {
      if (!model.upperMarginStr.contains('COST')) {
        model.upperMarginStr = '${model.upperMarginStr}   COST ${model.cost}';
      } else {
        if (model.upperMarginStr[0] == 'M') {
          model.upperMarginStr = 'MARGIN ${model.margin}%   COST ${model.cost}';
        } else {
          model.upperMarginStr = 'COST ${model.cost}   MARGIN ${model.margin}%';
        }
      }
      model.strForScreen = (Decimal.parse(returnLastNumber(str: model.cost)) /
              (Decimal.parse('1') -
                  (Decimal.parse(returnLastNumber(str: model.margin)) /
                      Decimal.parse('100'))))
          .toString();
      model.lowerStr = model.strForScreen;
    } else {
      model.upperMarginStr = 'COST ${model.cost}';
      model.costCurrency = returnStringSign(str: model.cost);
    }
    return model;
  }

  CalculationModel calculateSell(CalculationModel model) {
    String costWithCurrency;
    final String stringWithoutPercent =
        model.strForScreen.replaceAll(RegExp('%'), '');
    model.lastSetVatTax = true;
    model.sell = stringWithoutPercent;
    if (model.cost != '' && model.margin != '') {
      model.cost = '';
      model.margin = '';
      model.upperMarginStr = '';
    }
    if (model.cost != '') {
      if (!model.upperMarginStr.contains('SELL')) {
        model.upperMarginStr = '${model.upperMarginStr}   SELL ${model.sell}';
      } else {
        if (model.upperMarginStr[0] == 'C') {
          model.upperMarginStr = 'COST ${model.cost}   SELL ${model.sell}';
        } else {
          model.upperMarginStr = 'SELL ${model.sell}   COST ${model.cost}';
        }
      }
      model.sellCurrency = returnStringSign(str: model.sell);
      if (model.costCurrency == '' || model.sellCurrency == '') {
        model.strForScreen =
            ((Decimal.parse(model.sell) - Decimal.parse(model.cost)) /
                    Decimal.parse(model.sell) *
                    Decimal.parse('100'))
                .toString();
        model.strForScreen = '${model.strForScreen}%';
        model.lowerStr = model.strForScreen;
      } else {
        costWithCurrency = (Decimal.parse(cleanStringSign(str: model.cost)) *
                Decimal.parse(model.signRate[model.sellCurrency]) /
                Decimal.parse(model.signRate[model.costCurrency]))
            .toString();
        model.strForScreen = ((Decimal.parse(cleanStringSign(str: model.sell)) -
                    Decimal.parse(cleanStringSign(str: costWithCurrency))) /
                Decimal.parse(cleanStringSign(str: model.sell)) *
                Decimal.parse('100'))
            .toString();
        model.strForScreen = '${model.strForScreen}%';
        model.lowerStr = model.strForScreen;
      }
    } else if (model.margin != '') {
      if (!model.upperMarginStr.contains('SELL')) {
        model.upperMarginStr = '${model.upperMarginStr}   SELL ${model.sell}';
      } else {
        if (model.upperMarginStr[0] == 'M') {
          model.upperMarginStr = 'MARGIN ${model.margin}%   SELL ${model.sell}';
        } else {
          model.upperMarginStr =
              'SELL ${model.sell}   MARGIN ${model.margin}% ';
        }
      }
      model.strForScreen = (Decimal.parse(returnLastNumber(str: model.sell)) *
              (Decimal.parse('1') -
                  (Decimal.parse(returnLastNumber(str: model.margin)) /
                      Decimal.parse('100'))))
          .toString();
      model.lowerStr = model.strForScreen;
    } else {
      model.upperMarginStr = 'SELL ${model.sell}';
      model.sellCurrency = returnStringSign(str: model.sell);
    }
    return model;
  }

  CalculationModel calculateMargin(CalculationModel model) {
    final String stringWithoutPercent =
        model.strForScreen.replaceAll(RegExp('%'), '');
    model.lastSetVatTax = true;
    model.margin = returnLastNumber(str: stringWithoutPercent);
    if (model.cost != '' && model.sell != '') {
      model.cost = '';
      model.sell = '';
      model.upperMarginStr = '';
    }
    if (model.cost != '') {
      if (!model.upperMarginStr.contains('MARGIN')) {
        model.upperMarginStr =
            '${model.upperMarginStr}   MARGIN ${model.margin}%';
      } else {
        if (model.upperMarginStr[0] == 'C') {
          model.upperMarginStr = 'COST ${model.cost}   MARGIN ${model.margin}%';
        } else {
          model.upperMarginStr = 'MARGIN ${model.margin}%   COST ${model.cost}';
        }
      }
      model.strForScreen = (Decimal.parse(returnLastNumber(str: model.cost)) /
              (Decimal.parse('1') -
                  (Decimal.parse(returnLastNumber(str: model.margin)) /
                      Decimal.parse('100'))))
          .toString();
      model.lowerStr = model.strForScreen;
    } else if (model.sell != '') {
      if (!model.upperMarginStr.contains('MARGIN')) {
        model.upperMarginStr =
            '${model.upperMarginStr}   MARGIN ${model.margin}%';
      } else {
        if (model.upperMarginStr[0] == 'S') {
          model.upperMarginStr = 'SELL ${model.sell}   MARGIN ${model.margin}%';
        } else {
          model.upperMarginStr = 'MARGIN ${model.margin}%   SELL ${model.sell}';
        }
      }
      model.strForScreen = (Decimal.parse(returnLastNumber(str: model.sell)) *
              (Decimal.parse('1') -
                  (Decimal.parse(returnLastNumber(str: model.margin)) /
                      Decimal.parse('100'))))
          .toString();
      model.lowerStr = model.strForScreen;
    } else {
      model.upperMarginStr = 'MARGIN ${model.margin}%';
    }
    return model;
  }

  String cleanStringSign({String str}) {
    if(str == null) {
      return '';
    }
    String result;
    for (int i = 0; i < str.length; i++) {
      if (isNumber(str[i])) {
        result = str.substring(i);
        break;
      }
    }
    return result;
  }

  String cleanAfterNumberSign({String str}) {
    if(str == null) {
      return '';
    }
    String result;
    for (int i = 0; i < str.length; i++) {
      if (i + 1 == str.length) {
        result = str.substring(0, i + 1);
        break;
      }

      if (str[i] == '.') {
        continue;
      } else if (!isNumber(str[i])) {
        result = str.substring(0, i);
        break;
      }
    }
    return result;
  }

  String returnLastNumber({String str}) {
    if(str == null) {
      return '';
    }
    String result = str;
    for (int i = str.length - 1; i >= 0; i--) {
      if (str[i] == '.') {
        continue;
      } else if (!isNumber(str[i])) {
        result = str.substring(i + 1);
        break;
      }
    }
    return result.trim();
  }

  String changeLastSign({String str, String sign, CalculationModel model}) {
    if(str == null) {
      return '';
    }
    final String result = str;
    String newNumber;
    for (int i = str.length - 1; i >= 0; i--) {
      if (str[i] == '.') {
        continue;
      } else if (!isNumber(str[i])) {
        for (int j = i; j >= 0; j--) {
          if (str[j] == '#') {
            newNumber =
                (Decimal.parse(returnLastNumber(str: result.substring(j + 2))) *
                        Decimal.parse(model.signRate[sign]) /
                        Decimal.parse(model.signRate[
                            returnStringSign(str: result.substring(j + 2))]))
                    .toString();
            return '${result.substring(0, j + 2)}$sign$newNumber';
          }
        }
      }
    }
    return result.trim();
  }

  String returnLastSign({String str, String sign}) {
    if(str == null) {
      return '';
    }
    final String result = str;
    for (int i = str.length - 1; i >= 0; i--) {
      if (str[i] == '.') {
        continue;
      } else if (!isNumber(str[i])) {
        for (int j = i; j >= 0; j--) {
          if (str[j] == '#') {
            if (str.substring(j + 2, i + 1) == sign) {
              return '${result.substring(0, j + 2)}${result.substring(i + 1)}';
            }
          } else if (j == 0) {
            return str.substring(i + 1);
          }
        }
      }
    }
    return result.trim();
  }

  String returnStringSign({String str}) {
    if(str == null) {
      return '';
    }
    String result;
    for (int i = 0; i < str.length; i++) {
      if (isNumber(str[i])) {
        result = str.substring(0, i);
        break;
      }
    }
    return result != null ? result.trim() : '';
  }

  String addSignLowerStr(String str, String sign, CalculationModel model) {
    if(str == null) {
      return '';
    }
    String result;
    String thisSign;
    String num;
    for (int i = str.length - 1; i >= 0; i--) {
      if (i == 0) {
        result = '$sign${str.substring(i)}';
      }
      if (str[i] == '#') {
        thisSign = returnStringSign(str: str.substring(i + 2));
        if (thisSign == '') {
          result = '${str.substring(0, i + 2)}$sign${str.substring(i + 2)}';
        } else {
          num = cleanStringSign(str: str.substring(i + 2));
          num = (Decimal.parse(num) *
                  Decimal.parse(model.signRate[sign]) /
                  Decimal.parse(model.signRate[thisSign]))
              .toString();
          result = '${str.substring(0, i + 2)}$sign$num';
        }
        break;
      }
    }
    return result;
  }

  //check for character is number
  bool isNumber(String character) {
    try {
      int.parse(character);
      return true;
    } catch (error) {
      return false;
    }
  }

  //use to avoid of put second decimal dot
  bool checkForDecimal(String str) {
    if(str == null) {
      return false;
    }
    for (int i = str.length - 1; i >= 0; i--) {
      if (!isNumber(str[i])) {
        if (str[i] == '.') {
          return true;
        }
        return false;
      }
    }
    return false;
  }

  //replace last action only of it is not '%'
  String replaceLastAction(String str, String action) {
    if(str == null) {
      return '';
    }
    if (str[str.length - 1] != '%') {
      return str.substring(0, str.lastIndexOf('#')) + action;
    } else {
      return str + action;
    }
  }

  // get action string between # and next numeric symbol
  String extractFirstActionFromString(String str) {
    if(str == null) {
      return '';
    }
    if (str.length >= 5) {
      if (str.substring(0, 5).contains('#+TAX') ||
          str.substring(0, 5).contains('#-TAX') ||
          str.substring(0, 5).contains('#+VAT') ||
          str.substring(0, 5).contains('#-VAT')) {
        return str.substring(0, 5);
      }
    }
    final result = StringBuffer();
    result.write('#');
    for (int i = 1; i < str.length; i++) {
      if (isNumber(str[i]) ||
          str[i] == '#' ||
          str[i] == '+' ||
          str[i] == '-' ||
          str[i] == '*' ||
          str[i] == '/' ||
          str[i] == '.' ||
          str[i] == '%') {
        result.write(str[i]);
        return result.toString();
      }
      result.write(str[i]);
    }
    return result.toString();
  }

  //get number from start of string to first # symbol
  String extractFirstArgumentFromString(String str, CalculationModel model) {
    if (str.isEmpty) {
      return null;
    }
    String s = cleanStringSign(str: str);
    s = cleanAfterNumberSign(str: s);
    String sig = returnStringSign(str: str);
    if (sig == '') {
      model.activeRate = model.signRate[model.firstSign];
      model.activeSign = model.firstSign;
      sig = model.firstSign;
    }
    if (sig != model.firstSign) {
      return (Decimal.parse(s) *
              Decimal.parse(model.signRate[model.firstSign]) /
              Decimal.parse(model.signRate[sig]))
          .toString();
    }
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (isNumber(s[i]) || s[i] == '.') {
        result.write(s[i]);
      } else {
        return result.toString();
      }
    }
    return result.toString();
  }

  //remove a part of string from start to first numeric symbol
  String removeFirstActionFromString(String str, CalculationModel model) {
    if(str == null) {
      return '';
    }
    if (str.length >= 5) {
      if (str.substring(0, 5).contains('#+TAX') ||
          str.substring(0, 5).contains('#-TAX') ||
          str.substring(0, 5).contains('#+VAT') ||
          str.substring(0, 5).contains('#-VAT')) {
        return str.substring(5);
      }
    }
    return str.substring(2);
  }

  //remove a part of string from start to first not numeric symbol
  String removeFirstArgumentFromString(String str) {
    if(str == null) {
      return '';
    }
    String result;
    if (str.lastIndexOf('#') != -1) {
      result = str.substring(str.indexOf('#'), str.length);
    } else {
      result = '';
    }
    return result;
  }

  //all calculations in this method
  String doAction(String action, String a, String b) {
    try {
      switch (action) {
        case '#+':
          return (Decimal.parse(a) + Decimal.parse(b)).toString();
        case '#-':
          return (Decimal.parse(a) - Decimal.parse(b)).toString();
        case '#*':
          return (Decimal.parse(a) * Decimal.parse(b)).toString();
        case '#/':
          return (Decimal.parse(a) / Decimal.parse(b)).toString();
        case '#+TAX':
          return (Decimal.parse(a) + Decimal.parse(a) * Decimal.parse(b))
              .toString();
          break;
        case '#-TAX':
          return (Decimal.parse(a) / (Decimal.parse('1') + Decimal.parse(b)))
              .toString();
          break;
        case '#+VAT':
          return (Decimal.parse(a) + Decimal.parse(a) * Decimal.parse(b))
              .toString();
          break;
        case '#-VAT':
          return (Decimal.parse(a) / (Decimal.parse('1') + Decimal.parse(b)))
              .toString();
          break;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  NumberCalcModel checkMaxNumberInput(String str) {

    int firstCounter = 0;
    int secondCounter = 0;

    if(str != null) {
      for (int i = str.length - 1; i >= 0; i--) {
        //calculating whole number part
        if (CalculationUtils().isNumber(str[i])) {
          firstCounter++;
        } else {
          //calculating decimal number part
          if (str[i] == '.') {
            secondCounter = firstCounter;
            firstCounter = 0;
            for (int j = i; j >= 0; j--) {
              if (CalculationUtils().isNumber(str[j])) {
                firstCounter++;
              } else {
                if (str[j] != '.') {
                  break;
                }
              }
            }
          }
          break;
        }
      }
    }
    return NumberCalcModel(firstCounter, secondCounter);
  }
}
