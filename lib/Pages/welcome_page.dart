import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  WelcomeScreenState createState() => new WelcomeScreenState();
}

// ------------------ Custom config ------------------
class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        SizedBox(
          height: 60,
        ),
        Image.asset("img/image1.png"),
        SizedBox(
          height: 20,
        ),
        Text("Welcome Back To The CrowdFunder Team App",
            style: GoogleFonts.rubik(
              color: Color(0xff800080),
              fontSize: 16,
            )),
        SizedBox(
          height: 15,
        ),
        Text(
            " your passport to raise all the money you need to make it through life!",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(color: Color(0xff707070), fontSize: 13)),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignIn()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Continue"))
      ]),
    ));
  }
}
