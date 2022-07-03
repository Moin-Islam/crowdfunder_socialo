import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/sign_up.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:flutter_demo/Pages/stripe_module.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_demo/utils/token_preference.dart';

class SetUp extends StatefulWidget {
  @override
  State<SetUp> createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {
  String _public_key;
  String _private_key;
  TextEditingController publickeyController = TextEditingController();
  TextEditingController privatekeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStripe();
  }
  /*final abc = FlutterSecureStorage();

  Future<String?> getToken(String token) async {
    return await abc.read(key: "token");
  }*/

  Widget buildVideoLinkBtn() {
    return GestureDetector(
      onTap: () {},
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'See the details in the video',
            style: GoogleFonts.roboto(
                color: Colors.black38,
                fontSize: 13,
                fontWeight: FontWeight.normal)),
        TextSpan(
            text: 'https://bit.ly/CFpromo1',
            style: GoogleFonts.roboto(
                color: Color(0xff800080),
                fontSize: 13,
                fontWeight: FontWeight.normal))
      ])),
    );
  }

  bool _isLoading = false;

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  fetchStripe() async {
    String token = await getToken();
    var jsonResponse = null;
    var response = await http.get(
      Uri.parse(
          "https://demo.socialo.agency/crowdfunder-api-application/profile/stripeInfo"),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data["STRIPE_DATA"][0]["public_key"] != "" &&
          data["STRIPE_DATA"][0]["secret_key"] != "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => StripeModuleX()),
            (Route<dynamic> route) => false);
        return;
      }

      setState(() {
        _public_key = data["STRIPE_DATA"][0]["public_key"];
      });

      setState(() {
        _private_key = data["STRIPE_DATA"][0]["secret_key"];
      });
      publickeyController.text =
          (_public_key == "") ? "Public Key" : '$_public_key';
      privatekeyController.text =
          (_private_key == "") ? "Private Key" : '$_private_key';

      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  paymentSetup() async {
    Map data = {
      'public_key': publickeyController.text,
      'secret_key': privatekeyController.text
    };
    String token = await getToken();
    print(token);
    print(data);
    var jsonResponse = null;
    var response = await http.put(
        Uri.parse(
            "https://demo.socialo.agency/crowdfunder-api-application/profile/stripeInfo"),
        headers: {
          'Authorization': '$token',
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => StripeAccount()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }

    print(response.body);
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
          ),
          height: 48,
          child: TextFormField(
            controller: publickeyController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Public Key",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 14),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff800080), width: 2.0),
              ),
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
            ),
            height: 48,
            child: TextFormField(
              controller: privatekeyController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Secret Key",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 14),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xff800080), width: 2.0),
                  )),
            )),
      ],
    );
  }

  Widget buildLogOutbtn() {
    return Align(
      alignment: Alignment.topRight,
      child: FlatButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => SignIn()),
              (_) => false,
            );
          },
          padding: EdgeInsets.only(left: 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Icon(
            Icons.logout,
            color: Color(0xff800080),
          )),
    );
  }

  Widget buildSetUpAccountbtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          paymentSetup();
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(0xff800080),
        child: Text(
          'Set Up Account',
          style: GoogleFonts.roboto(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
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
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLogOutbtn(),
                    Text(
                      'Set Up Your Account',
                      style: TextStyle(
                        color: Color(0xff800080),
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 20),
                    buildVideoLinkBtn(),
                    SizedBox(height: 20),
                    Text(
                      'Input the Public Key \*',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 20),
                    buildPublicKey(),
                    SizedBox(height: 20),
                    Text(
                      'Input the Private Key \*',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 13,
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
