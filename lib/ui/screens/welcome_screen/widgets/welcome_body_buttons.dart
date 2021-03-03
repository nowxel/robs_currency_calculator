import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/welcome_screen/actions/welcome_actions.dart';

class WelcomeBodyButtons extends StatelessWidget with WelcomeActions{

  RobsCalculatorActions widget;

  WelcomeBodyButtons(RobsCalculatorActions widget) {
    this.widget = widget;
  }

  @override
  Widget build(BuildContext context) {
    final double displayHeight = MediaQuery.of(context).size.height;
    final double displayWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: displayHeight / 3 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: displayHeight / 15,
            width: displayWidth - 38,
            child: RaisedButton(
                color: accentBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onPressed: () {
                  widget.purchaseMonthly(context: context);
                  },
                child: Text('SUBSCRIBE MONTHLY\n £0.99',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                    maxLines: 2)),
          ),
          SizedBox(
            height: displayHeight / 15,
            width: displayWidth - 38,
            child: RaisedButton(
                color: accentBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onPressed: () {
                  widget.purchaseAnnual(context: context);
                },
                child: AutoSizeText('SUBSCRIBE ANNUALLY (SAVE 58%)\n £4.99',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                    maxLines: 2)),
          ),
          SizedBox(
            height: displayHeight / 19,
            width: displayWidth - 138,
            child: RaisedButton(
                color: accentBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onPressed: () {
                  widget.restorePurchases(context: context);
                },
                child: Text('RESTORE',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.bodyText1)),
          ),
          SizedBox(
            height: displayHeight / 19,
            width: displayWidth - 138,
            child: RaisedButton(
                color: accentBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onPressed: () {
                  navigateCalculatorScreen(context);
                },
                child: Text('TRY IT FIRST',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.bodyText1)),
          ),
        ],
      ),
    );
  }
}
