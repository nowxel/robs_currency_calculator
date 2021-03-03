import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/theme/colors.dart';

//returning indicator of current operation page
class PageIndicatorWidget extends StatelessWidget {
  const PageIndicatorWidget({Key key, this.currentPageNumber,
    @required this.height, this.margin})  : super(key: key);

  final double height;
  final EdgeInsets margin;
  final int currentPageNumber;
  static double elementSize;


  @override
  Widget build(BuildContext context) {
    elementSize = height ;

    return Container(
      margin: margin,
      alignment: Alignment.center,
      height: height,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getPageIndicator(selected: currentPageNumber == 0),
          getPageIndicator(selected: currentPageNumber == 1),
          getPageIndicator(selected: currentPageNumber == 2),
        ],
      )
    );
  }

  //returning single indicator
  Widget getPageIndicator({bool selected}){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: height,
      height: height,
      decoration: BoxDecoration(
        color: !selected
            ? accentBlack
            : accentWhite,
        borderRadius: BorderRadius.all(Radius.circular(height/2)),
      ),
    );
  }
}
