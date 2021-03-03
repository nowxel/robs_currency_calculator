import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/models/calculation_model.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/actions/calculator_screen_actions.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/button_widget.dart';
import 'package:robs_currency_calculator/utils/ShowToastComponent.dart';

import 'history_widget.dart';

//main keyboard with buttons
class CalculatorKeyboardWidget extends StatelessWidget with CalculatorScreenActions, RobsCalculatorActions{
  CalculatorKeyboardWidget({Key key, this.buttonHeight, this.height,
    this.historyKey}): super(key: key);

  final double buttonHeight;
  final double height;
  final GlobalKey<HistoryWidgetState> historyKey;

  static double buttonWidth;
  static double equalsButtonWidth;
  static CalculationModel calcModel = CalculationModel();

  @override
  Widget build(BuildContext context) {
    buttonWidth ??= MediaQuery.of(context).size.width/4.5;
    equalsButtonWidth = MediaQuery.of(context).size.width/2.15;

    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '7',
                onTap: (){numberButtonClick(context, 7);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '8',
                onTap: (){numberButtonClick(context, 8);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '9',
                onTap: (){numberButtonClick(context, 9);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '/',
                onTap: (){
                  BlocProvider.of<CurrenciesButtonsBloc>(context).add(const SetButtonEvent());
                  functionButtonClick(context, '#/');},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '4',
                onTap: (){numberButtonClick(context, 4);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '5',
                onTap: (){numberButtonClick(context, 5);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '6',
                onTap: (){numberButtonClick(context, 6);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '*',
                onTap: (){
                  BlocProvider.of<CurrenciesButtonsBloc>(context).add(const SetButtonEvent());
                  functionButtonClick(context, '#*');},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '1',
                onTap: (){numberButtonClick(context, 1);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '2',
                onTap: (){numberButtonClick(context, 2);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '3',
                onTap: (){numberButtonClick(context, 3);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '-',
                onTap: (){
                  BlocProvider.of<CurrenciesButtonsBloc>(context).add(const SetButtonEvent());
                  functionButtonClick(context, '#-');},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '.',
                onTap: (){functionButtonClick(context, '.');},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '0',
                onTap: (){numberButtonClick(context, 0);},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '%',
                onTap: (){functionButtonClick(context, '#%');},
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: '+',
                onTap: (){
                  BlocProvider.of<CurrenciesButtonsBloc>(context).add(const SetButtonEvent());
                  functionButtonClick(context, '#+');},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: 'C',
                onTap: (){clearButtonClick(context, '#c'); activateButton(context: context);},
              ),
              BlocListener<CalculationBloc, CalculationState>(
                listener: (context, state){
                  if(state is Calculation){
                    calcModel = state.model;
                  }
                },
                child: ButtonWidget(
                  height: buttonHeight,
                  width: equalsButtonWidth,
                  label: '=',
                  onTap: (){
                    if(BlocProvider.of<CalculationBloc>(context).currentModel.firstSign != '') {
                      final List<String> keys = BlocProvider.of<CalculationBloc>(context).currentModel.signRate.keys.toList();
                      for(int i = 0; i < keys.length; i ++) {
                        if(keys[i] == BlocProvider.of<CalculationBloc>(context).currentModel.firstSign){
                          BlocProvider.of<CurrenciesButtonsBloc>(context).add(SetButtonEvent(index: i));
                          break;
                        }
                      }
                    }
                    debugPrint(calcModel.toString());
                    equalsButtonClick(context, calcModel, historyKey);},
                ),
              ),
              ButtonWidget(
                height: buttonHeight,
                width: buttonWidth,
                label: 'opt',
                onTap: (){navigateToSetting(context: context);},
              ),
            ],
          )
        ],
      ),
    );
  }
}
