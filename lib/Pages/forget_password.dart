import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/member_list.dart';
import 'package:flutter_demo/Pages/set_up.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/sign_up.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:flutter_demo/utils/Member.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_demo/utils/token_storage.dart';
import 'package:flutter_demo/utils/token_preference.dart';

import 'custom_intro.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isRememberMe = false;
  bool _isLoading = false;
  

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Widget buildBackBtn() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => SignIn()),
              (_) => false,
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(15),
            shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Icon(
            Icons.arrow_back,
            color: Color(0xff800080),
          )),
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xffF4F6F8),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildLoginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        
        onPressed: _isLoading ? null : () {
           setState(() {
            _isLoading = true;
           });
          signIn(emailController.text, context);
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          primary: Color(0xff800080),
        ),
        child: Text(
          'Recover Your Password',
          style: GoogleFonts.rubik(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  fetchToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    print(token);

    /*if (token != "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AccountSetting()));
    }*/
  }

  signIn(
    String email,
    BuildContext context
  ) async {
    Map data = {'email': email};
    print("NAX");
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(
            "https://crowdfunderteam.com/api/authentication/requestResetPassword"),
             headers: {
          'Private-key': "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
        },
        body: data);
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(jsonResponse["message"]),
                duration: Duration(milliseconds: 3000),
              ));
            
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn()),
          (Route<dynamic> route) => false);
      
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(jsonResponse["message"]),
                duration: Duration(milliseconds: 3000),
              ));
      
    }
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
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Column(
                  children: [
                    buildBackBtn(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: GoogleFonts.rubik(
                            color: Color(0xff800080),
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Forgot Your Password?',
                          style: GoogleFonts.rubik(
                            color: Color(0xff800080),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: new TextSpan(
                            text:
                                "To Recover Your Password Please Input Your Recovery Email",
                            style: GoogleFonts.rubik(
                              color: Color(0xff800080),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildEmail(),
                    SizedBox(height: 20),
                    buildLoginBtn(context),
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
