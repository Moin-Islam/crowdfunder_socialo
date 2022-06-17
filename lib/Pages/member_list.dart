import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final datalist = <Item>[
    Item("Rakibul", "1644"),
    Item("Kabir", "1233"),
    Item("Towhid", "2654"),
  ];

  Widget singleUserList() {
    return Container(
        width: double.infinity,
        color: Color(0xffF4F6F8),
        child: Column(children: [
          Column(
            children: [
              Row(
                children: [
                  Image.asset('img/person.png', height: 48, width: 48),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text("Jordan Hemsworth"),
                      Text("User ID: 2345"),
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: null,
                child: Text(
                  "Product Link",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff800080)),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    signIn();
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
                    style: TextStyle(color: Color(0xff800080)),
                  )),
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

  bool _isLoading = false;

  signIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {};
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(
            "https://demo.socialo.agency/crowdfunder-api-application/purchase/fetchTeamList"),
        body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        print(jsonResponse);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => AccountSetting()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
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
            Image.asset('img/person.png'),
            // ignore: prefer_const_constructors
            Text(
              'Hello',
              style: TextStyle(
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
              style: TextStyle(
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
              style: TextStyle(
                color: Colors.black38,
                fontSize: 11,
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
              style: TextStyle(
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
