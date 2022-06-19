import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';
import 'package:modals/modals.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() => new IntroScreenState();
}

// ------------------ Custom config ------------------
class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(new Slide(
      widgetDescription: Column(children: [
        Text("Welcome To The Team",
            style: TextStyle(color: Color(0xff800080), fontSize: 18)),
        Text(
            "You are now in the CrowdFunder team where raising money for any cause is quick and easy! Vacation, car repairs, college anything.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff707070), fontSize: 13)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Read Our ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff707070), fontSize: 13)),
            FlatButton(
              onPressed: () {
                showModal(ModalEntry.positioned(context,
                    tag: 'Disclaimer',
                    top: 300,
                    child: Container(
                      color: Colors.white,
                      width: 300,
                      height: 300,
                      child: Column(
                        children: [
                          Text(
                            "Privacy",
                            style: TextStyle(fontSize: 13),
                          ),
                          FlatButton(
                            onPressed: () => removeAllModals(),
                            child: Text(
                                "The CROWDFUNDER TEAM app never shares or retains any information about it's users and only uses any information to confirm payments were made, and any information needed to make sure the app works as advertised"),
                          )
                        ],
                      ),
                    )));
              },
              child: const Text('Privacy',
                  style: TextStyle(color: Color(0xff707070), fontSize: 13)),
            ),
            Text(" and ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff707070), fontSize: 13)),
            FlatButton(
              onPressed: () {
                showModal(ModalEntry.positioned(context,
                    tag: 'Terms and Policy',
                    top: 300,
                    child: Container(
                      color: Colors.white,
                      width: 300,
                      height: 300,
                      child: Column(
                        children: [
                          Text(
                            "Terms and Policy",
                            style: TextStyle(fontSize: 13),
                          ),
                          FlatButton(
                            onPressed: () => removeAllModals(),
                            child: Text("close"),
                          )
                        ],
                      ),
                    )));
              },
              child: const Text('Terms and Policy',
                  style: TextStyle(color: Color(0xff707070), fontSize: 13)),
            ),
          ],
        ),
      ]),
      pathImage: "img/image1.png",
      backgroundColor: Colors.white,
    ));

    slides.add(new Slide(
      widgetDescription: Column(children: [
        Text("Get Started",
            style: TextStyle(color: Color(0xff800080), fontSize: 18)),
        Text(
            "You are now in the CrowdFunder team where raising money for any cause is quick and easy! Vacation, car repairs, college anything.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff707070), fontSize: 13)),
        Text("Read Our Disclaimer and Privacy Policy.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff707070), fontSize: 13))
      ]),
      pathImage: "img/image2.png",
      backgroundColor: Colors.white,
    ));
  }

  void onDonePress() {
    // Do what you want
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeScreen()),
    // );
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  void onNextPress() {
    print("onNextPress caught");
  }

  Widget renderNextBtn() {
    return Container(
      height: 48,
      color: Color(0xff800080),
      alignment: Alignment(0.0, 0.0),
      child: Text(
        "Next >",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xff800080),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xff800080),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(Color(0x33FFA8B0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: this.renderNextBtn(),
      onNextPress: this.onNextPress,

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: Color(0xffDCDCDC),
      colorActiveDot: Color(0xff800080),
      sizeDot: 13.0,

      // Show or hide status bar
      hideStatusBar: true,
      backgroundColorAllSlides: Colors.grey,

      // Scrollbar
      verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,
    );
  }
}
