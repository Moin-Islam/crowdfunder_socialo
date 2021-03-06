import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/upload_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'custom_intro.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpasswordController =
      new TextEditingController();
  final TextEditingController purposeController = new TextEditingController();
  final TextEditingController invitationController =
      new TextEditingController();

  Widget buildName() {
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
            controller: nameController,
            keyboardType: TextInputType.name,
            style: GoogleFonts.roboto(color: Colors.black, fontSize: 13),
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
                hintStyle:
                    GoogleFonts.roboto(color: Colors.black38, fontSize: 13)),
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
            color: Color(0xffF4F6F8),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.roboto(color: Colors.black, fontSize: 13),
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
                hintStyle:
                    GoogleFonts.roboto(color: Colors.black38, fontSize: 13)),
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
            color: Color(0xffF4F6F8),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: purposeController,
            keyboardType: TextInputType.text,
            style: GoogleFonts.roboto(color: Colors.black, fontSize: 13),
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
                hintStyle:
                    GoogleFonts.roboto(color: Colors.black38, fontSize: 13)),
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
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
            controller: passwordController,
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
                hintText: 'password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildRecheckPassword() {
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
            controller: confirmpasswordController,
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
                hintText: 'Confirm Password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildLoginBtn() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn()),
          (Route<dynamic> route) => false),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: 'Already have an account ? ',
                style: GoogleFonts.roboto(
                    color: Colors.black38,
                    fontSize: 13,
                    fontWeight: FontWeight.normal)),
            TextSpan(
                text: 'Login now',
                style: GoogleFonts.roboto(
                    color: Color(0xff800080),
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline))
          ])),
    );
  }

  signUp(String name, email, purpose, password, confirmpassword,
      invitation) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmpassword,
      'profile_image': "aaaa",
      'purpose': purpose,
      'invitation_code': invitation,
    };
    print(data);

    if (data != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => UploadImage(data: data)),
          (Route<dynamic> route) => false);
    }
  }

  Widget buildInvitation() {
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
            controller: invitationController,
            keyboardType: TextInputType.text,
            style: GoogleFonts.roboto(color: Colors.black, fontSize: 13),
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
                hintText: 'Invitation Code',
                hintStyle:
                    GoogleFonts.roboto(color: Colors.black38, fontSize: 13)),
          ),
        )
      ],
    );
  }

  Widget buildNextBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          print(nameController.text);

          signUp(
            nameController.text,
            emailController.text,
            purposeController.text,
            passwordController.text,
            confirmpasswordController.text,
            invitationController.text,
          );
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xff800080),
        child: Text(
          'Next',
          style: GoogleFonts.rubik(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
            child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Your Account',
                          style: GoogleFonts.rubik(
                            color: Color(0xff800080),
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    buildName(),
                    SizedBox(height: 20),
                    buildEmail(),
                    SizedBox(height: 20),
                    buildPuropose(),
                    SizedBox(height: 20),
                    buildInvitation(),
                    SizedBox(height: 20),
                    buildPassword(),
                    SizedBox(height: 20),
                    buildRecheckPassword(),
                    SizedBox(height: 20),
                    buildLoginBtn(),
                    SizedBox(height: 40),
                    buildNextBtn(),
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
