import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/payment_info.dart';
import 'package:flutter_demo/Pages/sign_up.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountSettings extends StatefulWidget {
  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  File image;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemporary = File(image.path);
    this.image = imageTemporary;
  }

  Widget buildName() {
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
          child: TextField(
            keyboardType: TextInputType.name,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildEmail() {
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
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildPuropose() {
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
          child: TextField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.clean_hands_sharp,
                  color: Colors.black,
                ),
                hintText: 'Purpose for raising money',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildCurrentPassword() {
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
          child: TextField(
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Current password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildNewPassword() {
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
          child: TextField(
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'New password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildConfirmPassword() {
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
          child: TextField(
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Confirm password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildSaveChangesBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RaisedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PaymentInfo())),
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color(0xff800080),
            child: Text(
              'Save Changes',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
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
          child: TextField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
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
          child: TextField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
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

  Widget buildSetUpAccountbtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => AccountSettings())),
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(0xff800080),
        child: Text(
          'Set Up Account',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget buildUserProfile() {
    return Container(
        child: Card(
      child: Row(
        children: [
          Material(
            color: Color(0xff800080),
            elevation: 2,
            shape: CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              splashColor: Color(0xff800080),
              onTap: () {
                child:
                Ink.image(
                  image: AssetImage("img/person.png"),
                  width: 200,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Column(
            children: [
              Text(
                'Ilias Kanchon',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                'User ID : 12314',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
            child: Column(
          children: [
            Container(
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
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                child: Column(
                  children: [
                    buildUserProfile(),
                    SizedBox(height: 20),
                    buildName(),
                    SizedBox(height: 20),
                    buildEmail(),
                    SizedBox(height: 20),
                    buildPuropose(),
                    SizedBox(height: 20),
                    buildCurrentPassword(),
                    SizedBox(height: 20),
                    buildNewPassword(),
                    SizedBox(height: 20),
                    buildConfirmPassword(),
                    buildSaveChangesBtn(),
                    SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stripe Account Info',
                          style: TextStyle(
                            color: Color(0xff800080),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Input the public key \*',
                          style: TextStyle(
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
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 20),
                        buildPrivateKey(),
                        SizedBox(
                          height: 20,
                        ),
                        buildSetUpAccountbtn()
                      ],
                    ),
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
