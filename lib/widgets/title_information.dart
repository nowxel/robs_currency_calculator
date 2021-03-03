import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TitleInformation extends StatelessWidget {
  const TitleInformation({this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    final double displayHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(top: displayHeight * 0.05),
      height: displayHeight / 3 - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.headline1),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, displayHeight / 13),
            child: SizedBox(
              height: 80,
              child: AutoSizeText(
                'Thank you for using Wedge. Unlimited use of the full features such as automatic downloading of exchange rates requires an Auto-Renewing Subscription',
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.bodyText2,
                minFontSize: 11,
                maxLines: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
