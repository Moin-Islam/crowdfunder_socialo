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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StripeModuleX extends StatefulWidget {
  const StripeModuleX({Key key}) : super(key: key);

  @override
  State<StripeModuleX> createState() => _StripeModuleXState();
}

class _StripeModuleXState extends State<StripeModuleX> {
  var _image;
  String _id;
  String name;
  var phonenumber;

  @override
  void initState() {
    super.initState();
    fetchUser();
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
          'https://demo.socialo.agency/crowdfunder-api-application/dashboard/userInfo'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        name = data["USER_DATA"][0]["name"];
      });

      var image1 = data["USER_DATA"][0]["profile_image"];
      setState(() {
        _image = base64Decode(image1);
      });

      setState(() {
        _id = data["USER_DATA"][0]["id"];
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 50),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) => StripeAccount()),
                  (_) => false,
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Color(0xff800080),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Product List and Sales',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.add_chart,
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              )),
          SizedBox(
            width: 15,
          ),
          RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 50),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) => AccountSetting()),
                  (_) => false,
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Color(0xff800080),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Account Settings',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                  )
                ],
              ))
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
    print(contact.phoneNumber.number);
  }

  Widget BuildSelectFromPhoneBookBtn() {
    return Container(
      height: 97,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RaisedButton(
              onPressed: () {
                pickContact();
              },
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Color(0xff800080),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ],
      ),
    );
  }

  Widget BuildInviteNowBtn() {
    return Container(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          String message = "This is a test message!";
          List<String> recipents;
          if (phonenumberController.text == null ||
              phonenumberController.text == "") {
            recipents = [phonenumber];
          } else {
            recipents = [phonenumberController.text];
          }

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

  Widget BuildProfileIDSection() {
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
                  : new Image.memory(
                      _image,
                      height: 50,
                      fit: BoxFit.cover,
                    )),
          Column(
            children: [
              Text(
                (name == null) ? "Fetching value..." : '$name',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                (_id == null) ? "Fetching value..." : 'User ID : $_id',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
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
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => SignIn()),
              (_) => false,
            );
          },
          padding: EdgeInsets.only(top: 55),
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
    return Scaffold(
        body: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLogOutBtn(),
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Total Earning : \$128.50',
                    style: GoogleFonts.rubik(
                        color: Color(0xff800080),
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(height: 15),
              BuildProfileIDSection(),
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
                        margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                        child: Divider(
                          color: Colors.black,
                          height: 50,
                        )),
                  ),
                ],
              ),
              BuildSelectFromPhoneBookBtn(),
              BuildInviteNowBtn(),
            ]),
      ),
    ));
  }
}
