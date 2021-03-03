import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/action_select_widget.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/history_widget.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/screen_widget.dart';

//Widget Fore pageVie and screen background
class CalculationScreenWidget extends StatelessWidget {
  const CalculationScreenWidget({Key key, this.height, this.buttonSize,
    this.calcScreenSize, this.historyKey}) : super(key: key);

  final double height;
  final double buttonSize;
  final double calcScreenSize;
  final GlobalKey<HistoryWidgetState> historyKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentBlack,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ScreenWidget(height: height,screenSize:  calcScreenSize,),
          ActionSelectWidget(
              height: height,
              buttonSize: buttonSize,
              calcScreenSize: calcScreenSize,
              historyKey: historyKey,
          )
        ],
      ),
    );
  }
}
