import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/upload_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/token_preference.dart';
import 'custom_intro.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _isVisible = false;
  bool _isVisibleRecheck = false;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpasswordController =
      new TextEditingController();
  final TextEditingController purposeController = new TextEditingController();
  final TextEditingController invitationController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();

    updateController();
  }

  updateController() async {
    nameController.text = await getStorageValue("profile_name");
    emailController.text = await getStorageValue("profile_email");
    purposeController.text = await getStorageValue("profile_purpose");
    invitationController.text =
        await getStorageValue("profile_invitation_code");
  }

  getStorageValue(parameter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(parameter)) {
      print(parameter);
      print(prefs.containsKey(parameter));
      return prefs.getString(parameter);
    } else {
      print(parameter);
      print(prefs.containsKey(parameter));
      return "";
    }
  }

  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void updateStatuRecheck() {
    setState(() {
      _isVisibleRecheck = !_isVisibleRecheck;
    });
  }

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
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter email';
              } else if (value != null && !value.contains('@')) {
                return 'Please enter valid email';
              }
              return null;
            },
            style: GoogleFonts.roboto(color: Colors.black, fontSize: 13),
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xffF4F6F8),
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.only(top: 14, bottom: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.lock,
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
          child: TextFormField(
            controller: passwordController,
            obscureText: _isVisible ? false : true,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
            ],
            style: TextStyle(color: Colors.black),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter password';
              } else if (value.length < 8) {
                print("HELO");
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xffF4F6F8),
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.only(top: 14, bottom: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                suffixIcon: IconButton (  
                  onPressed: () => updateStatus(),
                  icon: Icon(
                    _isVisible ? Icons.visibility : Icons.visibility_off
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Password',
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
          child: TextFormField(
            controller: confirmpasswordController,
            obscureText: _isVisibleRecheck ? false : true ,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
            ],
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter password';
              } else if (value.length < 8) {
                print("HELO");
                return 'Password must be at least 8 characters long';
              } else if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xffF4F6F8),
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.only(top: 14, bottom: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                suffixIcon: IconButton(  
                  onPressed: () => updateStatuRecheck(),
                  icon:  Icon(
                    _isVisibleRecheck ? Icons.visibility : Icons.visibility_off
                  ),
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
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: 'Sign In',
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
    setState(() {
      _isLoading = true;
    });
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

    TokenPreference.saveAddress("profile_name", name);
    TokenPreference.saveAddress("profile_email", email);
    TokenPreference.saveAddress("profile_purpose", purpose);
    TokenPreference.saveAddress("profile_invitation_code", invitation);
    print(data);

    if (data != null) {
      setState(() {
        _isLoading = true;
      });

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
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                if (_formKey.currentState != null &&
                    _formKey.currentState.validate()) {
                  signUp(
                      nameController.text,
                      emailController.text,
                      purposeController.text,
                      passwordController.text,
                      confirmpasswordController.text,
                      invitationController.text);
                }
              },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          primary: Color(0xff800080),

        ),
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
                    Form(
                        key: _formKey,
                        child: Column(children: [
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
                        ])),
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
