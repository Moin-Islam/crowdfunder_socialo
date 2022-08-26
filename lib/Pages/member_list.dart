import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/payment_info.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:flutter_demo/Pages/stripe_module.dart';
import 'package:flutter_layouts/flutter_layouts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_demo/utils/token_preference.dart';
import 'package:flutter_demo/Pages/set_up.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;

import '../utils/Member.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key key}) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  Future<List<Member>> memberList;
  String userid;
  String _username;
  List<bool> pressAttention = List.filled(10, false);
  Map productSelect = {};
  int totalPrice = 0;
  int totalProduct = 0;
  var _image;

  @override
  void initState() {
    super.initState();

    getUserName().then((res) {
      setState(() {
        _username = res;
      });
    });

    fetchUser();

    // userid = getUserId();

    fetchTeamList().then((res) {
      // print("NEXXXXT");
      // setState(() {
      //   pressAttention = List.filled(res.length, false);
      // });
      // print(res.length);
    });
  }

  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  fetchUser() async {
    String token = await getToken();
    print("NAX TOKEn");
    print(token);
    final response = await http.get(
      Uri.parse(
          'https://demo.socialo.agency/crowdfunder-api-application/dashboard/userInfo'),
      headers: {
        'Authorization': '$token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      print("NAXXXXXXXX");
      print(data);

      var image1 = data["USER_DATA"][0]["profile_image"];

      setState(() {
        _image = base64Decode(image1);
      });
    }
  }

  Future<List<Member>> fetchTeamList() async {
    String token = await getToken();

    var jsonResponse = null;
    var response = await http.get(
      Uri.parse(
          "https://demo.socialo.agency/crowdfunder-api-application/purchase/fetchTeamList"),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      var body = jsonResponse["list_data"];

      return body.map<Member>(Member.fromJson).toList();

      // if (jsonResponse != null) {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (BuildContext context) => SetUp()),
      //       (Route<dynamic> route) => false);
      // }
    } else {
      throw Exception('Failed to load User');
    }
  }

  Widget selectButton(
      int index, String saleId, String productPrice, String publishableKey) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            pressAttention[index] = !pressAttention[index];
          });

          if (productSelect[saleId] == null) {
            setState(() {
              productSelect[saleId] = {
                "productPrice": productPrice,
                "publishableKey": publishableKey
              };
            });

            setState(() {
              totalPrice += int.parse(productPrice);
            });
            setState(() {
              totalProduct += 1;
            });
          } else {
            setState(() {
              productSelect[saleId] = null;
            });

            setState(() {
              totalPrice -= int.parse(productPrice);
            });
            setState(() {
              totalProduct -= 1;
            });
          }

          print(productSelect);
        },
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(
              color: Color(0xff800080), width: 1.0, style: BorderStyle.solid)),
          backgroundColor: pressAttention[index]
              ? MaterialStateProperty.all(Color(0xff800080))
              : MaterialStateProperty.all(Color(0xffF4F6F8)),
        ),
        child: Text(
          "Select",
          style: GoogleFonts.rubik(
              color: pressAttention[index]
                  ? Color(
                      0xffF4F8F8,
                    )
                  : Color(
                      0xff800080,
                    )),
        ));
  }

  Widget singleUserList(String id, String name, String img, String saleId,
      String publishableKey, String productPrice, int index) {
    var image = base64Decode(img);
    return Container(
        height: 150,
        color: Color(0xffF4F6F8),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 17),
          child: Column(children: [
            Column(
              children: [
                Row(
                  children: [
                    (image == null || image == '')
                        ? CircularProgressIndicator()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.memory(
                              image,
                              gaplessPlayback: true,
                              width: 60,
                              height: 60,
                            )),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.roboto(
                              fontSize: 13, color: Colors.black),
                        ),
                        Text(
                          "User ID: " + id,
                          style: GoogleFonts.roboto(
                              fontSize: 12, color: Color(0xff707070)),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          "Price: \$$productPrice",
                          style: GoogleFonts.rubik(
                              color: Color(0xffffffff), fontSize: 13),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff800080)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    height: 34,
                    width: 130,
                    child: selectButton(
                        index, saleId, productPrice, publishableKey)),
              ],
            )
          ]),
        ));
  }

  Widget buildLogOutbtn() {
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
              },
            );

            TokenPreference.saveAddress("token", "");
            TokenPreference.saveAddress("remember_token", "");

            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => SignIn()),
              (_) => false,
            );
          },
          padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Icon(
            Icons.logout,
            color: Color(0xff800080),
          )),
    );
  }

  Widget title() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLogOutbtn(),

          GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) => StripeModuleX()),
                  (_) => false,
                );
              }, // Image tapped
              child: (_image == null || _image == '')
                  ? CircularProgressIndicator()
                  : CircleAvatar(
                      radius: 30.0,
                      backgroundImage: MemoryImage(_image), //here
                    )),

          SizedBox(
            height: 15,
          ),
          // ignore: prefer_const_constructors
          Text(
            'Hello',
            style: GoogleFonts.rubik(
              color: Color(0xff800080),
              fontSize: 25,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            (_username == "") ? "Fetching value..." : '$_username',
            // "Hello",
            style: GoogleFonts.rubik(
              color: Color(0xff800080),
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Help your team by making a purchase',
            style: GoogleFonts.roboto(
              color: Colors.black38,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 40),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Color(0xffDCDCDC),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Member List and Products',
            style: GoogleFonts.rubik(
              color: Color(0xff800080),
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget hero() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder<List<Member>>(
          future: fetchTeamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final members = snapshot.data;
              // for (var i = 0; i < members.length; i++) {
              //   // TO DO
              //   var currentElement = li[i];
              // }

              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      Member member = members[index];

                      print("NEXT");
                      print(member.productPrice);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Widget to display the list of project
                          singleUserList(
                              member.id,
                              member.name,
                              member.userImage,
                              member.saleId,
                              member.publishableKey,
                              member.productPrice,
                              index),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget fotterButton() {
    return Container(
        height: 108,
        padding: EdgeInsets.only(
          top: 30,
          bottom: 30,
          right: 20,
        ),
        decoration: BoxDecoration(
            color: Color(0xffFFF6FF),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total: \$$totalPrice",
                    style: GoogleFonts.rubik(
                        color: Color(0xff800080), fontSize: 9),
                  ),
                  Text(
                    "Selected: $totalProduct\\10",
                    style: GoogleFonts.rubik(
                      color: Color(0xff800080),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "Select at least 10 products",
                    style: GoogleFonts.roboto(
                        color: Color(0xff800080), fontSize: 11),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      print("BUY NOW CLICKED");

                      if (totalProduct != 0) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => PaymentInfo(
                                      data: productSelect,
                                      price: totalPrice.toString(),
                                    )),
                            (Route<dynamic> route) => false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff800080),
                    ),
                    child: Text(
                      "Buy Now",
                      style:
                          GoogleFonts.rubik(color: Colors.white, fontSize: 15),
                    ))
              ],
            )
          ],
        ));
  }

// width: double.infinity,
//                 padding: EdgeInsets.only(top: 30, left: 20),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            title(),
            hero(),
          ],
        ),
      ),
      bottomNavigationBar: fotterButton(),
    );
  }
}
