import 'package:flutter/cupertino.dart';

class AppButtons extends StatelessWidget {
  String text;
  IconData icon;
  final Color color;
  final Color backgroundColor;
  double size;
  final Color borderColor;
  bool isIcon;

  AppButtons(
      {Key key,
      this.isIcon = false,
      this.text,
      this.icon,
      this.color,
      this.backgroundColor,
      this.borderColor,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
    );
  }
}
