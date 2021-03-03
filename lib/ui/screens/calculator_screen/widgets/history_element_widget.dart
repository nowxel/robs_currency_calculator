import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/models/history_element_model.dart';
import 'package:robs_currency_calculator/theme/colors.dart';

//One element of calculation history
class HistoryElementWidget extends StatelessWidget {
  const HistoryElementWidget({Key key, this.height, this.model}) : super(key: key);

  final HistoryElementModel model;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 30),
      height: height,
      color: accentGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Date
          Column(children: [
            Container(
              width: 40,
              height: height /4,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accentBlack,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: accentBlack),
              ),
              child: Text(
                model.month,
                style: Theme.of(context).primaryTextTheme.headline5,
              )
            ),
            Container(
              width: 40,
              height: height /2.5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: accentBlack),
              ),
              child: Text(
                  model.day,
                  style: Theme.of(context).primaryTextTheme.headline4
              )
            ),
          ],),
          //Calculations
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: height/4,
                width: MediaQuery.of(context).size.width - 100,
                child: AutoSizeText(
                  model.upperString,
                  style: Theme.of(context).primaryTextTheme.headline4,
                  minFontSize: 8.0,
                  maxFontSize: 20.0,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                height: height/3,
                width: MediaQuery.of(context).size.width - 100,
                child: AutoSizeText(
                  model.calculationsString,
                  style: Theme.of(context).primaryTextTheme.headline3,
                  minFontSize: 10,
                  maxFontSize: 32.0,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                height: height/4,
                width: MediaQuery.of(context).size.width - 100,
                child: AutoSizeText(
                  model.loverString,
                  style: Theme.of(context).primaryTextTheme.headline4,
                  minFontSize: 8.0,
                  maxFontSize: 20.0,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                ),
              ),
           ],)
      ],),
    );
  }
}

