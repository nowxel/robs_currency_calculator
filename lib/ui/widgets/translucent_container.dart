import 'package:flutter/material.dart';

class TranslucentContainer extends StatelessWidget {
  const TranslucentContainer({Key key, @ required this.color}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                color.withOpacity(0.0),
                color.withOpacity(0.3),
              ],
              stops: const [0.0, 1.0])
      ),
    );
  }
}
