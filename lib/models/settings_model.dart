import 'package:robs_currency_calculator/utils/resources.dart';

class SettingsModel {
  SettingsModel(
      {this.salesTaxRate = '20',
      this.currency1 = 'USD',
      this.currency2 = 'EUR',
      this.currency3 = 'GBP',
      this.currency4 = 'CHF',
      this.rate1 = '',
      this.rate2 = '',
      this.rate3 = '',
      this.rate4 = '',
      this.sharedValue = 0,
      this.forceDecimalPlacesEnabled = true,
      this.separatorEnabled = true,
      this.soundsEnabled = true,
      this.isSwitched4 = true,
      this.decimalPlaces = 5});

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        salesTaxRate: json['salesTaxRate'] as String,
        currency1: json['currency1'] as String,
        currency2: json['currency2'] as String,
        currency3: json['currency3'] as String,
        currency4: json['currency4'] as String,
        rate1: json['rate1'] as String,
        rate2: json['rate2'] as String,
        rate3: json['rate3'] as String,
        rate4: json['rate4'] as String,
        sharedValue: json['sharedValue'] as int,
        forceDecimalPlacesEnabled: json['isSwitched1'] as bool,
        separatorEnabled: json['isSwitched2'] as bool,
        soundsEnabled: json['isSwitched3'] as bool,
        isSwitched4: json['isSwitched4'] as bool,
        decimalPlaces: json['decimalPlaces'] as int
      );

  String salesTaxRate = '20';
  String currency1 = defaultSelectedCurrencies[0];
  String currency2 = defaultSelectedCurrencies[1];
  String currency3 = defaultSelectedCurrencies[2];
  String currency4 = defaultSelectedCurrencies[3];
  String rate1 = '';
  String rate2 = '';
  String rate3 = '';
  String rate4 = '';
  int sharedValue = 0;
  bool forceDecimalPlacesEnabled = true;
  bool separatorEnabled = true;
  bool soundsEnabled = true;
  bool isSwitched4 = false;
  int decimalPlaces = 5;

  Map<String, dynamic> toJson() => {
        'salesTaxRate': salesTaxRate,
        'currency1': currency1,
        'currency2': currency2,
        'currency3': currency3,
        'currency4': currency4,
        'rate1': rate1,
        'rate2': rate2,
        'rate3': rate3,
        'rate4': rate4,
        'sharedValue': sharedValue,
        'isSwitched1': forceDecimalPlacesEnabled,
        'isSwitched2': separatorEnabled,
        'isSwitched3': soundsEnabled,
        'isSwitched4': isSwitched4,
        'decimalPlaces': decimalPlaces
      };
}
