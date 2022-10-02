import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/services/clipboard.dart';

import '../utils/token_preference.dart';

class StripeModuleX extends StatefulWidget {
  const StripeModuleX({Key key}) : super(key: key);

  @override
  State<StripeModuleX> createState() => _StripeModuleXState();
}

class _StripeModuleXState extends State<StripeModuleX> {
  var _image;
  String _id;
  String _earning;
  String name;
  String invitation_code;
  var phonenumber;
  String message;
  String short_invitation_code;
  int startIndex = 0;
  int endIndex = 4;
  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchMessage();
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  /*Widget BuildProfileIDSection() {
    return Container(
      height: 97,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'img/person.png',
            height: 73,
            width: 74,
          ),
          Container(
            child: Column(
              children: [
                Text(
                  "Hasibul Haque Prottoy",
                  style: GoogleFonts.rubik(color: Colors.black, fontSize: 15),
                ),
                SizedBox(height: 2),
                Text(
                  "User ID : 2349",
                  style: GoogleFonts.roboto(
                      color: Color(0xff707070), fontSize: 13),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }*/

  Future fetchUser() async {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(
          'https://demo.socialo.agency/crowdfunder-api-application/profile/userInfo'),
      headers: {
        'Authorization': '$token',
        'Private-key':
            "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      setState(() {
        name = data["USER_DATA"][0]["name"];
      });

      setState(() {
        invitation_code = data["USER_DATA"][0]["invitation_code"];
        short_invitation_code = invitation_code.substring(startIndex, endIndex);
      });

      setState(() {
        _id = data["USER_DATA"][0]["id"];
      });

      setState(() {
        _earning = data["USER_DATA"][0]["total_earning"];
      });

      var image1 = data["USER_DATA"][0]["profile_image"];
      setState(() {
        _image = base64Decode(image1);
      });

      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future fetchMessage() async {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(
          'https://demo.socialo.agency/crowdfunder-api-application/profile/fetchInvitationMessage'),
      headers: {
        'Authorization': '$token',
        'Private-key':
            "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(response);
      setState(() {
        message = data["invitation_message"];
      });

      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Widget BuildMiddleBtn() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              print("CLICKED");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => StripeAccount()),
                  (Route<dynamic> route) => false);
            },
            child: Card(
              color: Color(0xff800080),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 60.0, left: 15, right: 5, bottom: 15),
                    child: SizedBox(
                      width: 90,
                      child: Text(
                        'Product List and Sale',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.add_chart,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {
              print("CLICKED");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSetting()),
              );
            },
            child: Card(
              color: Color(0xff800080),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 60.0, left: 15, right: 5, bottom: 15),
                    child: SizedBox(
                      width: 90,
                      child: Text(
                        'My Account Settings',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  final TextEditingController phonenumberController =
      new TextEditingController();

  Widget BuildEnterPhoneNo() {
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
            controller: phonenumberController,
            keyboardType: TextInputType.phone,
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
                  Icons.phone,
                  color: Colors.black,
                ),
                hintText: 'Enter your phone number',
                hintStyle:
                    GoogleFonts.roboto(color: Color(0xffBEBEBE), fontSize: 13)),
          ),
        )
      ],
    );
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  pickContact() async {
    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    phonenumber = contact.phoneNumber.number;

    setState(() {
      phonenumberController.text = contact.phoneNumber.number;
    });
    print(contact.phoneNumber.number);
  }

  Widget BuildSelectFromPhoneBookBtn() {
    return Container(
      width: double.infinity,
      height: 48,
      child: RaisedButton(
          onPressed: () {
            pickContact();
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Color(0xff800080),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Select from phone book',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              Icon(
                Icons.contact_page_sharp,
                color: Colors.white,
              )
            ],
          )),
    );
  }

  Widget BuildInviteNowBtn() {
    return Container(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          /*String message =
              "Hi, this is $name I just discovered an App that will generate all the money you need. Check it out! You'll be glad you did. Use my Invitation Code when you Sign Up. So here's how it works: Watch this video: https://bit.ly/CFpromo1 \n Download the App: (Download link) \n Sign-up using my invitation code : $invitation_code \n Qualify to raise money by helping your team with \n a one-time purchase Set-up your payment processor so you can Get paid. Share with 3 close contacts. This is the \"side-hustle\" everyone's been looking for!";*/
          List<String> recipents;
          if (phonenumberController.text == null ||
              phonenumberController.text == "") {
            recipents = [phonenumber];
          } else {
            recipents = [phonenumberController.text];
          }

          print(message);

          _sendSMS(message, recipents);
        },
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(
              color: Color(0xff800080), width: 1.0, style: BorderStyle.solid)),
          backgroundColor: MaterialStateProperty.all(Color(0xffF4F6F8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Invite Now",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xff800080)),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.share,
              color: Color(0xff800080),
            ),
          ],
        ),
      ),
    );
  }

  Clipbooard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: invitation_code)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Copied to Clipbaord")));
    });
    ;
  }

  Widget BuildProfileIDSection(BuildContext context) {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: new BorderSide(color: Color(0xff800080), width: 1.0)),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(20),
              child: (_image == null || _image == '')
                  ? CircularProgressIndicator()
                  : CircleAvatar(
                      radius: 30.0,
                      backgroundImage: MemoryImage(_image), //here
                    )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (name == null) ? "Fetching value..." : '$name',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Text(
                    (invitation_code == null)
                        ? "Fetching value..."
                        : 'Invitation code: $short_invitation_code' + ".....",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.normal),
                  ),
                  TextButton(
                    onPressed: (() async {
                      Clipboard.setData(ClipboardData(text: invitation_code))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Copied to Clipbaord")));
                      });
                      ;
                    }),
                    child: const Icon(Icons.copy),
                  )
                ],
              )
            ],
          )
        ],
      ),
    ));
  }

  Widget buildLogOutBtn() {
    return Align(
      alignment: Alignment.topRight,
      child: FlatButton(
          onPressed: () async {
            String token = await getToken();

            await http.delete(
              Uri.parse(
                  'https://demo.socialo.agency/crowdfunder-api-application/authentication/processUserAccess'),
              headers: {
                'Authorization': '$token',
                'Private-key':
                    "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
              },
            );

            TokenPreference.saveAddress("token", "");
            TokenPreference.saveAddress("remember_token", "");

            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => SignIn()),
              (_) => false,
            );
          },
          padding: EdgeInsets.only(top: 55, left: 25),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Icon(
            Icons.logout,
            color: Color(0xff800080),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (_earning == null)
                          ? "Fetching value..."
                          : 'Total Earning : \$$_earning',
                      style: GoogleFonts.rubik(
                          color: Color(0xff800080),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    buildLogOutBtn(),
                  ],
                ),
                SizedBox(height: 15),
                BuildProfileIDSection(context),
                SizedBox(
                  height: 20,
                ),
                BuildMiddleBtn(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Set Up Your Account",

                  style: GoogleFonts.rubik(
                    fontSize: 25,
                    color: Color(0xff800080),
                  ), // Container(child: Column(children: generateItems()))
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Enter a phone number below and hit the invite button or hit Select from Contract and Choose a contract from your contract list",
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: Color(0xff707070),
                  ), // Container(child: Column(children: generateItems()))
                ),
                SizedBox(
                  height: 20,
                ),
                BuildEnterPhoneNo(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Divider(
                            color: Colors.black,
                            height: 50,
                          )),
                    ),
                  ],
                ),
                BuildSelectFromPhoneBookBtn(),
                SizedBox(
                  height: 20,
                ),
                BuildInviteNowBtn(),
              ]),
        ),
      )),
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
    );
  }
}
