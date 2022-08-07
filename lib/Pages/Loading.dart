import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/member_list.dart';
import 'package:flutter_demo/Pages/set_up.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:flutter_demo/Pages/stripe_module.dart';
import 'package:flutter_demo/utils/Member.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/services/clipboard.dart';

import '../utils/token_preference.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  var token = "";

  @override
  void initState() {
    super.initState();

    fetchUserLoggedIn();
  }

  fetchUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null) {
      final response = await http.get(
        Uri.parse(
            'https://demo.socialo.agency/crowdfunder-api-application/authentication/auth'),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        checkUserStatus(token);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => SignIn()),
            (Route<dynamic> route) => false);
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn()),
          (Route<dynamic> route) => false);
    }
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
            MaterialPageRoute(builder: (BuildContext context) => MemberList()),
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
        print("NAX");

        if (stripe_data["message"] == "Data not found") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => StripeModuleX()),
              (Route<dynamic> route) => false);
        } else if (stripe_data["STRIPE_DATA"][0]["public_key"] != "") {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset("img/logo.png"),
    ));
  }
}
