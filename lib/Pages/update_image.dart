import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/account_setting.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/sign_up.dart';
import 'package:flutter_demo/Pages/set_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateImage extends StatefulWidget {
  UpdateImage({Key key}) : super(key: key);

  @override
  State<UpdateImage> createState() => _UpdateImageState();
}

class _UpdateImageState extends State<UpdateImage> {
  File image;
  Uint8List bytes;

  bool _isLoading = false;

  var convertedImage;

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

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

  singUp() async {
    String token = await getToken();

    print(convertedImage);
    Map data = {"profile_image": convertedImage};

    print(data);
    var response = await http.post(
        Uri.parse(
            "https://demo.socialo.agency/crowdfunder-api-application/profile/updateProfileImage"),
        headers: {
          'Authorization': '$token',
        },
        body: data);
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isLoading = true;
                          });
                          print("BUTTON");

                          singUp().then((res) {
                            print("resy");
                            setState(() {
                              _isLoading = false;
                            });
                            if (res["http_response_code"] != 200) {
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
                                          AccountSetting()),
                                  (Route<dynamic> route) => false);
                            }

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
                    'Update Image',
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
                      'Update Your Image',
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
