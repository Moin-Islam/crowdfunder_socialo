import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/forget_password.dart';
import 'package:flutter_demo/Pages/member_list.dart';
import 'package:flutter_demo/Pages/payment_info.dart';
import 'package:flutter_demo/Pages/set_up.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:flutter_demo/Pages/stripe_module.dart';
import './Pages/custom_intro.dart';
import 'package:flutter_demo/Pages/sign_up.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/forget_password.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  //This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    const MaterialColor kPrimaryColor = const MaterialColor(
      0xff800080,
      const <int, Color>{
        50: const Color(0xff800080),
        100: const Color(0xff800080),
        200: const Color(0xff800080),
        300: const Color(0xff800080),
        400: const Color(0xff800080),
        500: const Color(0xff800080),
        600: const Color(0xff800080),
        700: const Color(0xff800080),
        800: const Color(0xff800080),
        900: const Color(0xff800080),
      },
    );

    return MaterialApp(
        title: 'Crowd Funder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: kPrimaryColor,
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: kPrimaryColor),
        ),
        home: IntroScreen());
  }
}






/*Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUp()))*/