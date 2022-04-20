import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadImage extends StatefulWidget {
  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? image;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemporary = File(image.path);
    this.image = imageTemporary;
  }

  Future captureImage() async {
    await ImagePicker().pickImage(source: ImageSource.camera);
  }

  Widget buildUseCameraBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5,
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
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              Icon(
                Icons.camera_alt_outlined,
                color: Color(0xff800080),
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
                  style: TextStyle(
                      color: Color(0xff800080),
                      fontSize: 18,
                      fontWeight: FontWeight.normal))
            ])),
          ],
        ));
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Upload Your Image',
                      style: TextStyle(
                        color: Color(0xff800080),
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 25),
                    buildUseCameraBtn(),
                    SizedBox(height: 25),
                    buildGalleryBtn(),
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
