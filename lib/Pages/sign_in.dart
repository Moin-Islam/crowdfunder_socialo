import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/forget_password.dart';
import 'package:flutter_demo/Pages/member_list.dart';
import 'package:flutter_demo/Pages/set_up.dart';
import 'package:flutter_demo/Pages/sign_up.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:flutter_demo/Pages/stripe_module.dart';
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

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isRememberMe = false;
  bool _isLoading = false;
  var token = "";

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

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

  Widget buildPassword() {
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
            controller: passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget RememberPasswordRow() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 20,
            child: Row(
              children: [
                Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.black38),
                    child: Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          isRememberMe = value;
                        });
                      },
                      value: isRememberMe,
                      checkColor: Colors.white,
                      activeColor: Color(0xff800080),
                    )),
                Text(
                  'Remember me',
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
          Container(
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => ForgetPassword()),
                    (Route<dynamic> route) => false);
              },
              padding: EdgeInsets.only(right: 0),
              child: Text(
                'Forgot your Password?',
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: RaisedButton(
        elevation: 5,
        onPressed: _isLoading
            ? null
            : () {
                // setState(() {
                //   _isLoading = true;
                // });
                signIn(emailController.text, passwordController.text)
                    .then((res) {
                  if (res["status"] == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(res["message"]),
                      duration: Duration(milliseconds: 3000),
                    ));
                  }

                  // if (res.status == 0) {
                  //
                  // }
                });
              },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xff800080),
        child: _isLoading
            ? Text(
                'Loading...',
                style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              )
            : Text(
                'Sign In',
                style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
      ),
    );
  }

  Widget BuildSignUpBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUp())),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'Don\'t have any Account? ',
              style: GoogleFonts.roboto(
                  color: Colors.black38,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
            TextSpan(
              text: 'Sign Up Now',
              style: GoogleFonts.roboto(
                color: Color(0xff800080),
                fontSize: 13,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.underline,
              ),
            )
          ])),
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

  checkUserStatus(String token) async {
    final user_response = await http.get(
      Uri.parse(
          'https://demo.socialo.agency/crowdfunder-api-application/dashboard/userInfo'),
      headers: {
        'Authorization': '$token',
      },
    );

    print(user_response);

    if (user_response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(user_response.body);
      TokenPreference.saveAddress("name", data["USER_DATA"][0]["name"]);
      TokenPreference.saveAddress("id", data["USER_DATA"][0]["id"]);
      TokenPreference.saveAddress("status", data["USER_DATA"][0]["status"]);
      TokenPreference.saveAddress(
          "profile_image", data["USER_DATA"][0]["profile_image"]);

      print(data["USER_DATA"][0]["status"]);
      if (data["USER_DATA"][0]["status"] == "0") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => MemberList()),
              (Route<dynamic> route) => false);
        } else {
          print("NAX");
          print(data["USER_DATA"][0]["stripe_status"]);

          if (data["USER_DATA"][0]["stripe_status"] == "1") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => StripeModuleX()),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => SetUp()),
                (Route<dynamic> route) => false);
          }
        }
    }

    setState(() {
      _isLoading = false;
    });
  }

  signIn(String email, pass) async {
    setState(() {
      _isLoading = true;
    });

    Map data = {'email': email, 'password': pass};
    print("NAX");
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(
            "https://demo.socialo.agency/crowdfunder-api-application/authentication/processUserAccess"),
        body: data);
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      if (jsonResponse != null) {
        print(response.body);

        TokenPreference.saveAddress("token", jsonResponse['token']);

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");

        print("NAX");
        print(token);

        checkUserStatus(token);

        return {'status': 200};
      }
    } else {
      print(response.body);

      setState(() {
        _isLoading = false;
      });

      return jsonResponse;
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
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                child: Column(
                  children: [
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
                          'Sign in to your account',
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
                                "Share the CROWDFUNDER TEAM App with the people you know, like and trust and help them do the same.",
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
                    buildPassword(),
                    RememberPasswordRow(),
                    buildLoginBtn(),
                    BuildSignUpBtn(),
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
