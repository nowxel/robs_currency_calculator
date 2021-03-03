import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/bloc/calculation_bloc/calculation_bloc.dart';
import 'package:robs_currency_calculator/models/calculation_model.dart';
import 'package:robs_currency_calculator/ui/navigation/screens.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/history_widget.dart';
import 'package:robs_currency_calculator/utils/common_utils.dart';

mixin CalculatorScreenActions{
  void setPortraitOrientation(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
  void numberButtonClick(BuildContext context, int number){
    BlocProvider.of<CalculationBloc>(context).add(PutNumber(number));
    BlocProvider.of<SoundsBloc>(context).add(PlayClickDouble());
  }

  void functionButtonClick(BuildContext context, String function){
    BlocProvider.of<CalculationBloc>(context).add(PutFunction(function));
    BlocProvider.of<SoundsBloc>(context).add(PlayClickInOut());
  }

  void currencyButtonClick(BuildContext context, String sign, String rate){
    BlocProvider.of<CalculationBloc>(context).add(PutCurrency(sign, rate));
    BlocProvider.of<SoundsBloc>(context).add(PlayClickInOut());
  }

  void clearButtonClick(BuildContext context, String function){
    BlocProvider.of<CalculationBloc>(context).add(PutFunction(function));
    BlocProvider.of<SoundsBloc>(context).add(PlayClickDouble());
  }

  void equalsButtonClick(
      BuildContext context,
      CalculationModel model,
      GlobalKey<HistoryWidgetState> historyKey
    ){
    BlocProvider.of<SoundsBloc>(context).add(PlayPolaroid());
    historyKey.currentState.addHistoryItem(CommonUtils().getHistoryElement(model));
    BlocProvider.of<CalculationBloc>(context).add(const PutFunction('='));
  }

  void equalsButtonClickMargin(
      BuildContext context,
      GlobalKey<HistoryWidgetState> historyKey,
      String action
      ){
    BlocProvider.of<SoundsBloc>(context).add(PlayPolaroid());
    BlocProvider.of<CalculationBloc>(context).add(CalculateMargin(onCalculate: (calculatedModel){
      historyKey.currentState.addHistoryItem(CommonUtils().getHistoryElementMargin(calculatedModel), );
    }, action: action ));
  }

  void navigateToSetting({BuildContext context}) {
    BlocProvider.of<SoundsBloc>(context).add(PlayClickDouble());
    Navigator.pushReplacementNamed(context, Screens.option);
  }

  void navigateToUnlock(BuildContext context) {
    Navigator.pushNamed(context, Screens.unlock);
  }

  void navigateToWelcome(BuildContext context) {
    Navigator.pushReplacementNamed(context, Screens.welcomeScreen);
  }

  bool checkStateList(List<bool> stateList){
    bool result = false;
    for(final bool tmp in stateList){
      if (tmp) {
        result = true;
      }
    }
    return result;
  }

  void activateButton({BuildContext context, int index}){
    BlocProvider.of<CurrenciesButtonsBloc>(context).add(SetButtonEvent(index: index));
  }

}
