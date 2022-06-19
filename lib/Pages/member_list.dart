import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_demo/utils/token_preference.dart';
import 'package:flutter_demo/Pages/set_up.dart';

import '../utils/Member.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key key}) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  var memberList;
  @override
  void initState() {
    super.initState();

    memberList = fetchTeamList();
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
        'Authorization':
            'rmcz8m3zR77PhpGfM9x479e0mbXkUHsx5rCib3ndKNkUEJM0djfBWHLfMzGZ2wIU2svNieDo2lSVgHQyEdlEFDTXCZBYwc3vPgKy8WgRTQsJZX4ST6Ynaet6tLO6Pbaj',
      },
    );

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
    }

    var body = jsonDecode(response.body);
    body = body["list_data"];

    print(body);
    return body.map<Member>(Member.fromJson).toList();
  }

  Widget buildMemberList(List<Member> members) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        print(member.name);
        print(member.id);
        print("NAXXXXXXX");

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
                          Text(member.name),
                          Text("User ID: " + member.id),
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
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff800080)),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {},
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
      });

  // Widget singleUserList(String name, String id) {
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Member>>(
          future: fetchTeamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final members = snapshot.data;

              return Container(
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
                    buildMemberList(members),

                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
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
}
