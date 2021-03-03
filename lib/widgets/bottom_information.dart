import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomInformation extends StatelessWidget {

  _launchPrivacyURL() async {
    const url = 'https://boluga.com/support';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: SizedBox(
              height: displayHeight / 6,
              child: AutoSizeText(
                'Your subscription purchase will be applied to your iTunes account on confirmation. Subscriptions will automatically renew unless canceled within 24-hours before the end of your current period. You can cancel anytime with your iTunes account settings. Any used portion of a free trial will be forfeited if you purchase a subscription.',
                style: Theme.of(context).primaryTextTheme.bodyText2,
                textAlign: TextAlign.center,
                minFontSize: 11,
                maxLines: 16,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: displayHeight / 30),
            child: SizedBox(
              height: displayHeight / 21,
              width: displayWidth - 38,
              child: RaisedButton(
                  color: accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onPressed: _launchPrivacyURL,
                  child: Text('Privacy Policy & Terms of Use',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.bodyText1)),
            ),
          ),
        ],
      ),
    );
  }
}
