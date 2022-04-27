import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key? key}) : super(key: key);

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
        padding: EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('img/image1.jpg'),
            // ignore: prefer_const_constructors
            Text(
              'Hello',
              style: TextStyle(
                color: Color(0xff800080),
                fontSize: 20,
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
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Divider(
                    color: Colors.black,
                    height: 50,
                  )),
            ),
            SizedBox(
              height: 15,
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
            Container(child: Column(children: generateItems()))
          ],
        ),
      ),
    );
  }
}
