import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/payment_info.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
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

  @override
  void initState() {
    super.initState();

    getUserName().then((res) {
      setState(() {
        _username = res;
      });
    });
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

  Widget singleUserList(String id, String name, String saleId,
      String publishableKey, String productPrice, int index) {
    return Container(
        height: 133,
        width: 334,
        color: Color(0xffF4F6F8),
        child: Column(children: [
          Column(
            children: [
              Row(
                children: [
                  Image.asset('img/person.png', height: 46, width: 45),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
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
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentInfo())),
                  child: Row(
                    children: [
                      Text(
                        "Product links",
                        style: GoogleFonts.rubik(color: Colors.white),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.white,
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
        ]));
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
          padding: EdgeInsets.all(15),
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
        body: Column(children: [
      Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 30, left: 20),
          child: new SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLogOutbtn(),
              Image.asset(
                'img/person.png',
                height: 73,
                width: 74,
              ),
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
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.black,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<List<Member>>(
                      future: fetchTeamList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final members = snapshot.data;
                          // for (var i = 0; i < members.length; i++) {
                          //   // TO DO
                          //   var currentElement = li[i];
                          // }

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              Member member = members[index];

                              print("NEXT");
                              print(member.name);
                              print(member.name);
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Widget to display the list of project
                                  singleUserList(
                                      member.id,
                                      member.name,
                                      member.saleId,
                                      member.publishableKey,
                                      member.productPrice,
                                      index),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        // By default, show a loading spinner.
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      })
                ],
              ),
            ],
          ))),
      Spacer(),
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Card(
                color: Color(0xffFFF6FF),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
<<<<<<< HEAD
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
=======
                          Text("Total: \$$totalPrice"),
                          Text("Selected: $totalProduct\\10"),
                          Text("Select at least 10 products")
>>>>>>> origin/dev
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              print("BUY NOW CLICKED");

                              Stripe.publishableKey =
                                  "pk_test_51LGRPpDFaRhQ7wqHWzL4PjnEEqE02FvQAt6FIDfdytcvNtpIX400PMpbPVFGMYOpaM8m66j22yXIfI3Cnua3BceZ00zIZf6aTB";
                              Stripe.merchantIdentifier = "test";
                              final billingDetails = BillingDetails(
                                email: 'email@stripe.com',
                                phone: '+48888000888',
                                address: Address(
                                  city: 'Houston',
                                  country: 'US',
                                  line1: '1459  Circle Drive',
                                  line2: '',
                                  state: 'Texas',
                                  postalCode: '77063',
                                ),
                              );

                              Stripe.instance
                                  .dangerouslyUpdateCardDetails(CardDetails(
                                number: "4242424242424242",
                                expirationMonth: 6,
                                expirationYear: 2023,
                                cvc: "314",
                              ));

                              final paymentMethod = await Stripe.instance
                                  .createToken(
                                      CreateTokenParams(type: TokenType.Card));

                              print(paymentMethod);
                            },
<<<<<<< HEAD
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff800080),
                            ),
                            child: Text(
                              "Buy Now",
                              style: GoogleFonts.rubik(
                                  color: Colors.white, fontSize: 15),
                            ))
=======
                            child: Text("Buy Now"))
>>>>>>> origin/dev
                      ],
                    )
                  ],
                ),
              ),
            ],
          ), // << Put your content here
        ),
      )
    ]));
  }
}
