import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLargeText extends StatelessWidget {
  int size;
  final String text;
  final Color color;

  AppLargeText(
      {Key? key,
      this.size = 25,
      required this.text,
      this.color = const Color(0xff800080)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }
}
