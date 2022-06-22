import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/payment_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_demo/utils/token_preference.dart';
import 'package:flutter_demo/Pages/set_up.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key key}) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class Item {
  Item(this.name, this.Id);
  String name;
  String Id;
  bool selected = false;
}

class _MemberListState extends State<MemberList> {
  @override
  void initState() {
    super.initState();
    fetchTeamList();
  }

  final datalist = <Item>[
    Item("Rakibul", "1644"),
    Item("Kabir", "1233"),
    Item("Towhid", "2654"),
  ];

  bool _isLoading = false;

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  fetchTeamList() async {
    String token = await getToken();
    print(token);
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

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => SetUp()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    print(response.body);
  }

  Widget singleUserList() {
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
                        "Jordan Hemsworth",
                        style: GoogleFonts.roboto(
                            fontSize: 13, color: Colors.black),
                      ),
                      Text(
                        "User ID: 2345",
                        style: GoogleFonts.roboto(
                            fontSize: 12, color: Color(0xff707070)),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                height: 34,
                width: 130,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentInfo())),
                  child: Text(
                    "Product Link",
                    style: GoogleFonts.rubik(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff800080)),
                  ),
                ),
              ),
              SizedBox(
                height: 34,
                width: 130,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                          color: Color(0xff800080),
                          width: 1.0,
                          style: BorderStyle.solid)),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xffF4F6F8)),
                    ),
                    child: Text(
                      "Select",
                      style: GoogleFonts.rubik(
                          color: Color(
                        0xff800080,
                      )),
                    )),
              ),
            ],
          )
        ]));
  }

  List<Widget> generateItems() {
    final result = <Widget>[];
    for (int i = 0; i < datalist.length; i++) {
      result.add(CheckboxListTile(
          value: datalist[i].selected,
          onChanged: (v) {
            datalist[i].selected = v ?? false;
          }));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'img/person.png',
              height: 73,
              width: 74,
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
              height: 10,
            ),
            Text(
              'Hasibul Haque Prottoy',
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
            singleUserList(),
            SizedBox(
              height: 15,
            ),
            singleUserList(),
            SizedBox(
              height: 15,
            ),
            singleUserList(),
            SizedBox(
              height: 15,
            ),
            singleUserList(),
            SizedBox(
              height: 15,
            ),
            singleUserList(),
            // Container(child: Column(children: generateItems()))
          ],
        ),
      ),
    );
  }
}
