import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/history_widget.dart';
import 'calculation_screen_widget.dart';
import 'calculator_keyboard_widget.dart';

//Widget with keyboard and calculations screen
class CalculatorWidget extends StatelessWidget {
  const CalculatorWidget({Key key, this.height, this.historyKey})
      : super(key: key);

  final double height;
  final GlobalKey<HistoryWidgetState> historyKey;
  static double buttonSize;

  @override
  Widget build(BuildContext context) {
    buttonSize ??= MediaQuery.of(context).size.height / 15;
    return Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        color: accentGray,
        child: Column(
          children: [
            CalculationScreenWidget(
              height: height / 2.5,
              buttonSize: buttonSize,
              calcScreenSize: height / 4.5,
                historyKey: historyKey
            ),
            CalculatorKeyboardWidget(
              buttonHeight: buttonSize,
              height: height - height / 2.5,
              historyKey: historyKey
            ),
          ],
        ));
  }
}
