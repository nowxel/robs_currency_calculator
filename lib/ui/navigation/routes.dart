import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/ui/navigation/screens.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/calculator_screen.dart';
import 'package:robs_currency_calculator/ui/screens/currency_search_screen/currency_search_screen.dart';
import 'package:robs_currency_calculator/ui/screens/unlock_screen/unlock_screen.dart';
import 'package:robs_currency_calculator/ui/screens/welcome_screen/welcome_screen.dart';
import 'package:robs_currency_calculator/ui/screens/option_screen/option_screen.dart';

final Map<String, Widget Function(dynamic)> appRoutes = {
  Screens.calculator: (ctx) => CalculatorScreen(),
  Screens.searchCurrency: (ctx) => CurrencySearchScreen(),
  Screens.option: (ctx) => OptionScreen(),
  Screens.unlock: (ctx) => UnlockScreen(),
  Screens.welcomeScreen: (ctx) => WelcomeScreen(),
};