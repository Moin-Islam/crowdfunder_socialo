import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/sign_up.dart';
import 'package:flutter_demo/Pages/set_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImage extends StatefulWidget {
  final Map data;
  UploadImage({Key key, @required this.data}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File image;
  Uint8List bytes;
  String convertedImage;
  var _isLoading = false;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    bytes = File(image.path).readAsBytesSync();
    String img64 = base64Encode(bytes);

    setState(() {
      convertedImage = img64;
    });
  }

  Future captureImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    print(image);

    bytes = File(image.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    setState(() {
      convertedImage = img64;
    });
  }

  Widget buildUseCameraBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RaisedButton(
          onPressed: () => captureImage(),
          padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Color(0xff800080),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Use Camera',
                style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              )
            ],
          )),
    );
  }

  Widget buildGalleryBtn() {
    return GestureDetector(
        onTap: () => pickImage(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.image_outlined,
              color: Color(0xff800080),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Select the documents from Gallery',
                    style: GoogleFonts.rubik(
                        color: Color(0xff800080),
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
                TextSpan(
                    text: '\n.png or .jpeg file',
                    style: TextStyle(
                        color: Color(0xffBEBEBE),
                        fontSize: 12,
                        fontWeight: FontWeight.normal))
              ]),
            ),
          ],
        ));
  }

  Widget buildSignUpBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp()));
      },
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'Don\'t have any Account?',
            style: GoogleFonts.roboto(
                color: Colors.black38,
                fontSize: 13,
                fontWeight: FontWeight.normal)),
        TextSpan(
            text: ' Sign Up',
            style: GoogleFonts.roboto(
              color: Color(0xff800080),
              fontSize: 13,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline,
            ))
      ])),
    );
  }

  singUp() async {
    if (convertedImage != null) {
      widget.data["profile_image"] = convertedImage;
    }
    print(widget.data);
    var jsonResponse = null;

    var response = await http.post(
        Uri.parse(
            "https://demo.socialo.agency/crowdfunder-api-application/authentication/processSignUp"),
        body: widget.data);

    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
    }

    return jsonResponse;
  }

  Widget displayImage() {
    return Container(
        padding: EdgeInsets.all(20),
        child: (bytes == null)
            ? SizedBox(height: 1)
            : CircleAvatar(
                radius: 30.0,
                backgroundImage: MemoryImage(bytes), //here
              ));
  }

  Widget buildBottomButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp())),
                  padding: EdgeInsets.all(13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color(0xff800080),
                  child: Text(
                    'Previous',
                    style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                RaisedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Signing Up please wait"),
                            duration: Duration(milliseconds: 3000),
                          ));

                          setState(() {
                            _isLoading = true;
                          });

                          print("BUTTON");

                          singUp().then((res) {
                            print(res);
                            if (res["status"] == 0) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(res["message"]),
                                duration: Duration(milliseconds: 3000),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(res["message"]),
                                duration: Duration(milliseconds: 3000),
                              ));

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignIn()),
                                  (Route<dynamic> route) => false);
                            }

                            setState(() {
                              _isLoading = false;
                            });

                            // if (res.status == 0) {
                            //
                            // }
                          });
                          // print(response.statusCode);
                          // if (response.statusCode != 200) {
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     content: Text("Your Text"),
                          //     duration: Duration(milliseconds: 300),
                          //   ));
                          // }
                        },
                  padding: EdgeInsets.all(13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color(0xff800080),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
          ),
        ],
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
                    Text(
                      'Upload Your Image',
                      style: TextStyle(
                        color: Color(0xff800080),
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 25),
                    displayImage(),
                    SizedBox(height: 25),
                    buildUseCameraBtn(),
                    SizedBox(height: 25),
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                      Text(
                        "or",
                        style: TextStyle(fontSize: 13),
                      ),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                    ]),
                    SizedBox(height: 25),
                    buildGalleryBtn(),
                    SizedBox(height: 55),
                    buildSignUpBtn(),
                    SizedBox(height: 25),
                    buildBottomButtons(),
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
