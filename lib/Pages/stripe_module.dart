import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class StripeModuleX extends StatefulWidget {
  const StripeModuleX({Key key}) : super(key: key);

  @override
  State<StripeModuleX> createState() => _StripeModuleXState();
}

class _StripeModuleXState extends State<StripeModuleX> {
  Widget BuildProfileIDSection() {
    return Scaffold(
      body: Container(
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
      ),
    );
  }

  Widget BuildMiddleBtn() {
    return Scaffold(
      body: Container(
        height: 97,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RaisedButton(
                onPressed: () => "",
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Color(0xff800080),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product List and Sales',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    Icon(
                      Icons.add_chart,
                      color: Colors.white,
                    )
                  ],
                )),
            RaisedButton(
                onPressed: () => "",
                padding: EdgeInsets.all(20),
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

  Widget BuildSelectFromPhoneBookBtn() {
    return Scaffold(
      body: Container(
        height: 97,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RaisedButton(
                onPressed: () => "",
                padding: EdgeInsets.all(15),
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
      ),
    );
  }

  Widget BuildInviteNowBtn() {
    return Scaffold(
      body: Container(
        height: 48,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(
                color: Color(0xff800080),
                width: 1.0,
                style: BorderStyle.solid)),
            backgroundColor: MaterialStateProperty.all(Color(0xffF4F6F8)),
          ),
          child: Row(
            children: [
              Text(
                "Invite Now",
                style: TextStyle(color: Color(0xff800080)),
              ),
              Icon(
                Icons.share,
                color: Color(0xff800080),
              ),
            ],
          ),
        ),
      ),
    );
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
            Text(
              "Total Earning : 182.50",
              style: GoogleFonts.rubik(color: Color(0xff800080), fontSize: 15),
            ),
            SizedBox(height: 15),
            BuildProfileIDSection(),
            SizedBox(
              height: 15,
            ),
            BuildMiddleBtn(),
            SizedBox(
              height: 15,
            ),
            Text(
              "Set Up Your Account",

              style: GoogleFonts.rubik(
                fontSize: 25,
                color: Color(0xff800080),
              ), // Container(child: Column(children: generateItems()))
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Enter a phone number below and hit the invite button or hit Select from Contract and Choose a contract from your contract list",
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: Color(0xff707070),
              ), // Container(child: Column(children: generateItems()))
            ),
            SizedBox(
              height: 15,
            ),
            BuildEnterPhoneNo(),
            SizedBox(
              height: 15,
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
    ));
  }
}
