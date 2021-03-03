import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:robs_currency_calculator/models/calculation_model.dart';
import 'package:robs_currency_calculator/models/history_element_model.dart';
import 'package:robs_currency_calculator/utils/calculation_utils.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';

class CommonUtils {

  static const String dateFormatPattern = 'yyyy-MM-dd HH:mm:ss';
  static const String dateOnlyFormatPattern = 'dd MMMM yyyy';
  static const String timeOnlyFormatPattern = 'HH:mm';

  String dateToString({DateTime dateTime, String dateFormatPattern}) {
    final DateFormat dateFormat = DateFormat(dateFormatPattern);
    return dateFormat?.format(dateTime) ?? '';
  }

  DateTime stringToDate({String date, String dateFormatPattern}) {
    final DateFormat dateFormat = DateFormat(dateFormatPattern);
    return dateFormat?.parse(date);
  }

  String getCurrentDate() {
    return dateToString(
        dateTime: DateTime.now(), dateFormatPattern: dateFormatPattern);
  }

  int differenceBetweenNowAndDate(String date) {
    final DateFormat dateFormat = DateFormat(dateFormatPattern);
    final String currentDate = dateFormat.format(DateTime.now());

    return dateFormat
        .parse(currentDate)
        .difference(dateFormat.parse(date))
        .inDays;
  }

  String getSubscriptionEndDate(String transactionDate, String productId) {
    int gap = 0;
    if (productId.toLowerCase().contains('annual')) { // annual
      gap = 365;
    } else if (productId.toLowerCase().contains('month')) { // monthly
      gap = 30;
    }
    int timestamp = int.parse(transactionDate);
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return dateToString(
        dateTime: date.add(Duration(days: gap)), dateFormatPattern: dateFormatPattern);
  }

  HistoryElementModel getHistoryElement(CalculationModel model) {
    if(model.activeMode != 2) {
      return HistoryElementModel(
          model.upperStr,
          model.strForScreen,
          model.lowerStr.replaceAll('#', ''),
          DateTime
              .now()
              .day
              .toString(),
          getStrMonth(DateTime
              .now()
              .month));
    } else {
      //final String upper = model.upperStr.contains('VAT') ? '' : model.upperStr;
      return HistoryElementModel(
          model.upperCurrencyStr,
          model.strForScreen,
          model.lowerStr.replaceAll('#', ''),
          DateTime
              .now()
              .day
              .toString(),
          getStrMonth(DateTime
              .now()
              .month));
    }
  }

  HistoryElementModel getHistoryElementMargin(CalculationModel model) {
    if (model.cost != '' && model.sell != '') {
      return HistoryElementModel(
          model.upperMarginStr,
          model.strForScreen,
          '${model.sell} - ${model.cost} / ${model.sell}',
          DateTime.now().day.toString(),
          getStrMonth(DateTime.now().month));
    } else if (model.cost != '' && model.margin != '') {
      return HistoryElementModel(
          model.upperMarginStr,
          model.strForScreen,
          '${model.cost} / ( 1 - ${model.margin}% )',
          DateTime.now().day.toString(),
          getStrMonth(DateTime.now().month));
    } else {
      return HistoryElementModel(
          model.upperMarginStr,
          model.strForScreen,
          '${model.sell} * ( 1 - ${model.margin}% )',
          DateTime.now().day.toString(),
          getStrMonth(DateTime.now().month));
    }
  }

  String getStrMonth(int month) {
    switch (month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OKT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
    }
    return null;
  }

  String getLastUpdateTime(DateTime dateTime) {
    return '${dateToString(dateTime: dateTime, dateFormatPattern: dateOnlyFormatPattern)} at ${dateToString(dateTime: dateTime, dateFormatPattern: timeOnlyFormatPattern)}';
  }

  static String changeInputStringForUI(String str) {
    String result = str.replaceAll('#', ' ');
    if (result.length > 1) {
      for (int i = 1; i < result.length; i++) {
        if (CalculationUtils().isNumber(result[i]) &&
            !CalculationUtils().isNumber(result[i - 1])) {
          if (result[i - 1] != '.') {
            final String temp = result;
            result = '${temp.substring(0, i)} ${temp.substring(i)}';
            i++;
          }
        }
      }
    }
    return result;
  }

  //change result string for screen
  static String changeResultStringForUI(String str) {
    //split string for two parts by '.' and get preffics
    final List<String> parts = splitResult(str);

    parts[2] = removeExcessDecimalNumbers(parts[2]);
    parts[1] = addCommas(parts[1]);

    return '${parts[0]}${parts[1]}${parts[2]}';
  }

  static String removeExcessDecimalNumbers(String str) {
    bool hasPercents = false;
    if (str.contains('%')) {
      hasPercents = true;
    }
    if (str.length > globalSettings.decimalPlaces &&
        globalSettings.forceDecimalPlacesEnabled) {
      if (hasPercents) {
        return '${str.substring(0, globalSettings.decimalPlaces + 1)}%';
      }

      return str.substring(0, globalSettings.decimalPlaces + 1);
    } else {
      return str;
    }
  }

  static String addCommas(String str) {
    if (globalSettings.separatorEnabled) {
      final StringBuffer buffer = StringBuffer();
      int counter = 0;
      for (int i = str.length - 1; i >= 0; i--) {
        buffer.write(str[i]);
        counter++;
        if (counter == 3 && i != 0) {
          counter = 0;
          buffer.write(',');
        }
      }

      //reverse string from end to start
      final String temp = buffer.toString();
      buffer.clear();
      for (int i = temp.length - 1; i >= 0; i--) {
        buffer.write(temp[i]);
      }
      return buffer.toString();
    } else {
      return str;
    }
  }

  static List<String> splitResult(String inputString) {
    String str = inputString;
    final List<String> result = <String>['', '', ''];
    for (int i = 0; i < str.length; i++) {
      if (!CalculationUtils().isNumber(str[i])) {
        result[0] += str[i];
      } else {
        break;
      }
    }
    str = str.substring(result[0].length);

    for (int i = 0; i < str.length; i++) {
      if (CalculationUtils().isNumber(str[i])) {
        result[1] += str[i];
      } else {
        result[2] = str.substring(i, str.length);
        break;
      }
    }

    if (result[0].isNotEmpty) {
      result[0] += ' ';
    }

    return result;
  }
}
