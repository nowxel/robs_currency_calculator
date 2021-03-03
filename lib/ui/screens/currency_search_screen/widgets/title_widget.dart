import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).primaryTextTheme.headline1,);
  }
}
