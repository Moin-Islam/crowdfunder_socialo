import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/member_list.dart';
import 'package:flutter_demo/Pages/set_up.dart';
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

  Widget buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          // setState(() {
          //   _isLoading = true;
          // });
          signIn(emailController.text, passwordController.text).then((res) {
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

  signIn(String email, pass) async {
    Map data = {'email': email, 'password': pass};
    print("NAX");
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(
            "https://demo.socialo.agency/crowdfunder-api-application/authentication/processUserAccess"),
        body: data);
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        TokenPreference.saveAddress("token", jsonResponse['token']);

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");

        print("NAX");
        print(token);

        final user_response = await http.get(
          Uri.parse(
              'https://demo.socialo.agency/crowdfunder-api-application/dashboard/userInfo'),
          headers: {
            'Authorization': '$token',
          },
        );

        if (user_response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(user_response.body);
          TokenPreference.saveAddress("name", data["USER_DATA"][0]["name"]);
          TokenPreference.saveAddress("id", data["USER_DATA"][0]["id"]);
          TokenPreference.saveAddress("status", data["USER_DATA"][0]["status"]);
          if (data["USER_DATA"][0]["status"] == "0") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => MemberList()),
                (Route<dynamic> route) => false);
          } else {
            final stripe_response = await http.get(
              Uri.parse(
                  'https://demo.socialo.agency/crowdfunder-api-application/profile/stripeInfo'),
              headers: {
                'Authorization': '$token',
              },
            );

            Map<String, dynamic> stripe_data = jsonDecode(stripe_response.body);

            if (stripe_data["status"] == "1") {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => StripeAccount()),
                  (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => SetUp()),
                  (Route<dynamic> route) => false);
            }
          }
        }

        return {'status': 200};
      }
    } else {
      print(response.body);

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
                    buildLoginBtn(),
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
