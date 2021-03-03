import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/i18n/app_localization.dart';
import 'package:robs_currency_calculator/models/currency.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/actions/calculator_screen_actions.dart';

import 'button_widget.dart';
import 'history_widget.dart';

//Page for currency operations
class CurrencyExchangeKeyboard extends StatelessWidget
    with CalculatorScreenActions, RobsCalculatorActions {
  CurrencyExchangeKeyboard(
      {Key key,
      this.buttonSize,
      this.selectedCurrenciesRates,
      this.buttonStatesList,
      this.historyKey})
      : super(key: key);
  final double buttonSize;
  static double buttonWidth;
  final List<Currency> selectedCurrenciesRates;
  final List<bool> buttonStatesList;
  final GlobalKey<HistoryWidgetState> historyKey;
  static bool flagSign1 = false;
  static bool flagSign2 = false;
  static bool flagSign3 = false;
  static bool flagSign4 = false;

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
    buttonWidth ??= MediaQuery.of(context).size.width / 4.5;
    return (selectedCurrenciesRates != null &&
            selectedCurrenciesRates.isNotEmpty)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonWidget(
                height: buttonSize,
                width: buttonWidth,
                label: !checkStateList(buttonStatesList)
                    ? selectedCurrenciesRates[0].currencySign
                    : buttonStatesList[0]
                        ? '-'
                        : '${translate('TO')} ${selectedCurrenciesRates[0].currencySign}',
                onTap: () {
                  if (!flagSign1) {
                    activateButton(context: context, index: 0);
                    flagSign1 = true;
                    flagSign2 = false;
                    flagSign3 = false;
                    flagSign4 = false;
                  } else {
                    activateButton(context: context);
                    flagSign1 = false;
                  }
                  currencyButtonClick(
                      context,
                      selectedCurrenciesRates[0].currencySign,
                      selectedCurrenciesRates[0].currencyRate.toString());
                },
              ),
              ButtonWidget(
                height: buttonSize,
                width: buttonWidth,
                label: !checkStateList(buttonStatesList)
                    ? selectedCurrenciesRates[1].currencySign
                    : buttonStatesList[1]
                        ? '-'
                        : '${translate('TO')} ${selectedCurrenciesRates[1].currencySign}',
                onTap: () {
                  if (!flagSign2) {
                    activateButton(context: context, index: 1);
                    flagSign2 = true;
                    flagSign1 = false;
                    flagSign3 = false;
                    flagSign4 = false;
                  } else {
                    activateButton(context: context);
                    flagSign2 = false;
                  }
                  currencyButtonClick(
                      context,
                      selectedCurrenciesRates[1].currencySign,
                      selectedCurrenciesRates[1].currencyRate.toString());
                },
              ),
              ButtonWidget(
                height: buttonSize,
                width: buttonWidth,
                label: !checkStateList(buttonStatesList)
                    ? selectedCurrenciesRates[2].currencySign
                    : buttonStatesList[2]
                        ? '-'
                        : '${translate('TO')} ${selectedCurrenciesRates[2].currencySign}',
                onTap: () {
                  if (!flagSign3) {
                    activateButton(context: context, index: 2);
                    flagSign3 = true;
                    flagSign1 = false;
                    flagSign2 = false;
                    flagSign4 = false;
                  } else {
                    activateButton(context: context);
                    flagSign3 = false;
                  }
                  currencyButtonClick(
                      context,
                      selectedCurrenciesRates[2].currencySign,
                      selectedCurrenciesRates[2].currencyRate.toString());
                },
              ),
              ButtonWidget(
                height: buttonSize,
                width: buttonWidth,
                label: !checkStateList(buttonStatesList)
                    ? selectedCurrenciesRates[3].currencySign
                    : buttonStatesList[3]
                        ? '-'
                        : '${translate('TO')} ${selectedCurrenciesRates[3].currencySign}',
                onTap: () {
                  if (!flagSign4) {
                    activateButton(context: context, index: 3);
                    flagSign4 = true;
                    flagSign1 = false;
                    flagSign2 = false;
                    flagSign3 = false;
                  } else {
                    activateButton(context: context);
                    flagSign4 = false;
                  }
                  currencyButtonClick(
                      context,
                      selectedCurrenciesRates[3].currencySign,
                      selectedCurrenciesRates[3].currencyRate.toString());
                },
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
