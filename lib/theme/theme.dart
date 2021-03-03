import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/theme/text_style.dart';

// ignore: avoid_classes_with_only_static_members
class ThemeStyle {
  static ThemeData robsCalculatorThemeData = ThemeData(
    primaryTextTheme: const TextTheme(
        headline1: bigWhiteNormalBody,
        headline2: normalWhiteNormalBody,
        headline3: bigWhiteBoldBody,
        headline4: mediumWhiteNormalBody,
        headline5: smallWhiteNormalBody,
        headline6: normalBlackNormalBody,
        bodyText1: boldWhiteButton,
        bodyText2: normalBlueBody),
    textTheme: const TextTheme(
      headline1: bigBlueBody,
    ),
  );
}
