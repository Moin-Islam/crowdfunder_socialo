import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/account_settings.dart';
import 'package:flutter_demo/Pages/sign_up.dart';

class SetUp extends StatefulWidget {
  @override
  State<SetUp> createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {
  Widget buildVideoLinkBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUp())),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'See the details in the video',
            style: TextStyle(
                color: Colors.black38,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        TextSpan(
            text: 'https://bit.ly/CFpromo1',
            style: TextStyle(
                color: Color(0xff800080),
                fontSize: 18,
                fontWeight: FontWeight.normal))
      ])),
    );
  }

  Widget buildPublicKey() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPrivateKey() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]),
            height: 60,
            child: TextField(
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
              ),
            )),
      ],
    );
  }

  Widget buildSetUpAccountbtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => AccountSettings())),
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xff800080),
        child: Text(
          'Set Up Account',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
            child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0x66f0f8ff),
                    Color(0x99f0f8ff),
                    Color(0xccf0f8ff),
                    Color(0xfff0f8ff),
                  ])),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Set Up Your Account',
                      style: TextStyle(
                        color: Color(0xff800080),
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 20),
                    buildVideoLinkBtn(),
                    SizedBox(height: 20),
                    Text(
                      'input the Public Key \*',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 20),
                    buildPublicKey(),
                    SizedBox(height: 20),
                    Text(
                      'input the Private Key \*',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 20),
                    buildPrivateKey(),
                    buildSetUpAccountbtn(),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
