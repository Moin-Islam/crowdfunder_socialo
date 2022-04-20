import 'package:flutter/cupertino.dart';

class ResponsiveButton extends StatelessWidget {
  bool? isResponsive;
  double? width;

  ResponsiveButton({Key? key, this.width, this.isResponsive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff800080),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset("img/iconArrow.png"),
      ]),
    );
  }
}
