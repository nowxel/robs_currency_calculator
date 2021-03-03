import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/models/currencies.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/currency_search_screen/widgets/currency_container.dart';

class CurrenciesListWidget extends StatefulWidget with RobsCalculatorActions {
  CurrenciesListWidget({this.descriptions, this.buttonNumber});

  final Currencies descriptions;
  final int buttonNumber;

  @override
  _CurrenciesListWidgetState createState() => _CurrenciesListWidgetState();
}

class _CurrenciesListWidgetState extends State<CurrenciesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Scrollbar(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                itemCount: widget.descriptions?.symbols?.length,
                itemBuilder: (context, index) {
                  return CurrencyContainer(
                    buttonNumber: widget.buttonNumber,
                    height: 40,
                    index: index,
                    descriptions: widget.descriptions,
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                  );
                })
        ),
      ),
    );
  }
}
