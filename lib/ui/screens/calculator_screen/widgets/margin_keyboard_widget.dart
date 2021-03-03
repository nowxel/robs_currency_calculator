import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/i18n/app_localization.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/actions/calculator_screen_actions.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/history_widget.dart';

//page for selection of margin calculations
import 'button_widget.dart';

class MarginKeyboardWidget extends StatelessWidget
    with CalculatorScreenActions {
  const MarginKeyboardWidget({Key key, this.buttonSize, this.historyKey})
      : super(key: key);
  final double buttonSize;
  static double buttonWidth;
  final GlobalKey<HistoryWidgetState> historyKey;


  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
    buttonWidth ??= MediaQuery
        .of(context)
        .size
        .width / 3.3;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonWidget(
          height: buttonSize,
          width: buttonWidth,
          label: translate('COST'),
          onTap: () {
            equalsButtonClickMargin(context, historyKey, '#COST');
            BlocProvider.of<CurrenciesButtonsBloc>(context).add(const SetButtonEvent());
          },
        ),
        ButtonWidget(
          height: buttonSize,
          width: buttonWidth,
          label: translate('SELL'),
          onTap: () {
            equalsButtonClickMargin(context, historyKey, '#SELL');
            BlocProvider.of<CurrenciesButtonsBloc>(context).add(const SetButtonEvent());
          },
        ),
        ButtonWidget(
          height: buttonSize,
          width: buttonWidth,
          label: translate('MARGIN'),
          onTap: () {
            equalsButtonClickMargin(context, historyKey, '#MARGIN');
            BlocProvider.of<CurrenciesButtonsBloc>(context).add(const SetButtonEvent());
          },
        ),
      ],
    );
  }
}
