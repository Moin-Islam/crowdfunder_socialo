import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/account_settings.dart';
import 'package:flutter_demo/Pages/demo1.dart';
import 'package:flutter_demo/Pages/member_list.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:flutter_demo/Pages/welcome_page.dart';
import './Pages/custom_intro.dart';
import 'package:flutter_demo/Pages/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  //This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: ' Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: SignIn());
  }
}






/*Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUp()))*/