import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/models/currencies.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/currency_search_screen/actions/currency_search_actions.dart';

class CurrencyContainer extends StatelessWidget with RobsCalculatorActions, CurrencySearchActions{
  CurrencyContainer({this.margin, this.height, this.index, this.descriptions, this.buttonNumber});

  final double height;
  final int index;
  final Currencies descriptions;
  final EdgeInsets margin;
  final int buttonNumber;

  @override
  Widget build(BuildContext context) {
    final double displayWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: () {
          fetchCurrency(context: context, index: buttonNumber, currencyCode: descriptions.symbols.keys.toList()[index]);
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              alignment: Alignment.center,
              height: height,
              width: height,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: darkGrey,
              ),
              child: AutoSizeText(getCurrencySign(descriptions.symbols.keys.toList()[index]),
                style: Theme.of(context).primaryTextTheme.headline5,
                maxLines: 1,
                minFontSize: 10.0,
              ),
            ),
            const Spacer(),
            Container(
              alignment: Alignment.centerRight,
              width: displayWidth * 0.75,
              child: AutoSizeText(descriptions.symbols.values.toList()[index],
              style: Theme.of(context).primaryTextTheme.headline4,
                maxLines: 1,
                minFontSize: 10.0,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
