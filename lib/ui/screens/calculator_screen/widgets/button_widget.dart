import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/theme/colors.dart';

//Universal button widget
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key key, this.label, this.width, this.height,
    this.onTap}) : super(key: key);

  final String label;
  final double width;
  final double height;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: accentGray,
            borderRadius: BorderRadius.circular(5),
            border: label != 'opt' ? Border.all(color: accentBlack) :null,
          ),
          child: label != 'opt'
          ? Container(
            alignment: Alignment.center,
            height: height * 0.7,
            child: AutoSizeText(
                label,
                style: Theme.of(context).primaryTextTheme.headline1,
                minFontSize: 10.0,
                maxFontSize: 26.0,
                maxLines: 1,
              ),
          )
          : Image.asset('assets/images/options.png', height: 20,),
        ),
    );
  }
}
