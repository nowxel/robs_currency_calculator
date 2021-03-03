import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class ShowToastComponent {
  static showDialog(String msg, BuildContext context) {
    Toast.show(
      msg,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
  }
}