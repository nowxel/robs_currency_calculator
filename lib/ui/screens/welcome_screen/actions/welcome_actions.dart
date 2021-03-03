import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/ui/navigation/screens.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';

mixin WelcomeActions{

  void navigateCalculatorScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, Screens.calculator);
  }

  void navigateUnlockScreen(BuildContext context) {
    Navigator.pushNamed(context, Screens.unlock);
  }
}