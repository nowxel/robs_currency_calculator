import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';

import 'package:robs_currency_calculator/bloc/settings_bloc/settings_bloc.dart';
import 'package:robs_currency_calculator/i18n/app_localization.dart';
import 'package:robs_currency_calculator/models/settings_model.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/actions/calculator_screen_actions.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';
import 'button_widget.dart';

// First page include TAX calculations
class TaxKeyboardWidget extends StatelessWidget with CalculatorScreenActions {
  const TaxKeyboardWidget({Key key, this.buttonSize}) : super(key: key);
  final double buttonSize;
  static double buttonWidth;

  @override
  Widget build(BuildContext context) {
    buttonWidth ??= MediaQuery.of(context).size.width / 3.3;
    final translate = AppLocalizations.of(context).translate;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonWidget(
          height: buttonSize,
          width: buttonWidth,
          label: '+${translate('TAX')}',
          onTap: () {
            functionButtonClick(context, '#+TAX');
          },
        ),
        ButtonWidget(
          height: buttonSize,
          width: buttonWidth,
          label: '-${translate('TAX')}',
          onTap: () {
            functionButtonClick(context, '#-TAX');
          },
        ),
        BlocBuilder<CalculationBloc, CalculationState>(
            builder: (context, state) {
          if (state is Calculation) {
            return ButtonWidget(
              height: buttonSize,
              width: buttonWidth,
              label: translate('SET_TAX'),
              onTap: () async {
                functionButtonClick(context, '#SET TAX');
                final SettingsModel settingsModel =
                    await LocalStorage().getSettings();
                settingsModel.salesTaxRate =
                    state.model.strForScreen.replaceAll(RegExp('%'), '');
                for (int i = 0; i < settingsModel.salesTaxRate.length; i++) {
                  if (isNumber(settingsModel.salesTaxRate[i])) {
                    settingsModel.salesTaxRate =
                        settingsModel.salesTaxRate.substring(i);
                    break;
                  }
                }
                BlocProvider.of<SettingsBloc>(context)
                    .add(ChangeSettingsEvent(settingsModel));
              },
            );
          }
          return Container();
        })
      ],
    );
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
}
