import 'package:flutter/material.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/utils/token_preference.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';
import 'package:modals/modals.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() => new IntroScreenState();
}

// ------------------ Custom config ------------------
class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  fetchSeenScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("intro_screen");

    if (token != null) {
      if (token == "seen") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      }
    }
    /*if (token != "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AccountSetting()));
    }*/
  }

  @override
  void initState() {
    fetchSeenScreen();
    super.initState();
    slides.add(Slide(
      widgetDescription: Column(children: [
        Text("Welcome To The Team",
            style: GoogleFonts.rubik(
              color: Color(0xff800080),
              fontSize: 18,
            )),
        SizedBox(
          height: 15,
        ),
        Text(
            "You are now on the CROWDFUNDER TEAM where raising money for any cause is quick and easy! Vacations, car repairs, dental work, college or retirement.",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(color: Color(0xff707070), fontSize: 13)),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: new TextSpan(
                  text: 'Read Our',
                  style:
                      GoogleFonts.roboto(color: Colors.black38, fontSize: 12),
                  children: [
                    new TextSpan(
                      text: ' Disclaimer',
                      style: GoogleFonts.roboto(
                          color: Color(0xff800080), fontSize: 12),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => {
                              showModal(ModalEntry.aligned(context,
                                  tag: 'Disclaimer',
                                  alignment: Alignment.center,
                                  child: Container(
                                    color: Colors.white,
                                    width: 300,
                                    height: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        RichText(
                                          text: new TextSpan(
                                            text: "Disclaimer",
                                            style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        RichText(
                                          text: new TextSpan(
                                            text:
                                                "The CROWDFUNDER TEAM app never shares or retains any information about it's users and only uses any information to confirm payments were made, and any information needed to make sure the app works as advertised",
                                            style: GoogleFonts.roboto(
                                                color: Colors.black87,
                                                fontSize: 12),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            FlatButton(
                                              padding: EdgeInsets.all(15),
                                              color: Color(0xff800080),
                                              onPressed: () {
                                                removeAllModals();
                                                showModal(
                                                    ModalEntry.aligned(context,
                                                        tag: 'Disclaimer',
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          color: Colors.white,
                                                          width: 300,
                                                          height: 200,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              RichText(
                                                                text:
                                                                    new TextSpan(
                                                                  text:
                                                                      "Disclaimer",
                                                                  style: GoogleFonts.roboto(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              RichText(
                                                                text:
                                                                    new TextSpan(
                                                                  text:
                                                                      "The CROWDFUNDER app is not responsible for any funds lost and has 'No Refund' policy.",
                                                                  style: GoogleFonts.roboto(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(),
                                                                  FlatButton(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            15),
                                                                    color: Color(
                                                                        0xff800080),
                                                                    onPressed: () =>
                                                                        removeAllModals(),
                                                                    child: Text(
                                                                      "Done",
                                                                      style: GoogleFonts.roboto(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )));
                                              },
                                              child: Text(
                                                "Next",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )))
                            },
                    ),
                    new TextSpan(
                        text: ' and',
                        style: GoogleFonts.roboto(
                            color: Colors.black38, fontSize: 12)),
                    new TextSpan(
                      text: ' Privacy Policy',
                      style: GoogleFonts.roboto(
                          color: Color(0xff800080), fontSize: 12),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => {
                              showModal(ModalEntry.aligned(context,
                                  tag: 'Disclaimer',
                                  alignment: Alignment.center,
                                  child: Container(
                                    color: Colors.white,
                                    width: 300,
                                    height: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        RichText(
                                          text: new TextSpan(
                                            text: "Disclaimer",
                                            style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        RichText(
                                          text: new TextSpan(
                                            text:
                                                "The CROWDFUNDER app is not responsible for any funds lost and has 'No Refund' policy. ",
                                            style: GoogleFonts.roboto(
                                                color: Colors.black87,
                                                fontSize: 12),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            FlatButton(
                                              padding: EdgeInsets.all(15),
                                              color: Color(0xff800080),
                                              onPressed: () =>
                                                  removeAllModals(),
                                              child: Text(
                                                "Done",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )))
                            },
                    ),
                  ]),
            ),
          ],
        ),
      ]),
      pathImage: "img/image1.png",
      heightImage: 283,
      widthImage: 54,
      backgroundColor: Colors.white,
    ));

    slides.add(new Slide(
      widgetDescription: Column(children: [
        Text("Qualify and Start Earning Now",
            style: GoogleFonts.rubik(color: Color(0xff800080), fontSize: 18)),
        SizedBox(
          height: 15,
        ),
        Text(
            "To qualify and start earning, you need to join a team of fundraisers.  Whoever shared this link/app with you is asking you to join their team.",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(color: Color(0xff707070), fontSize: 13)),
        SizedBox(
          height: 15,
        ),
        RichText(
          text: new TextSpan(
              text: 'Read Our',
              style: GoogleFonts.roboto(color: Colors.black38, fontSize: 12),
              children: [
                new TextSpan(
                  text: ' Disclaimer',
                  style: GoogleFonts.roboto(
                      color: Color(0xff800080), fontSize: 12),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => {
                          showModal(ModalEntry.aligned(context,
                              tag: 'Disclaimer',
                              alignment: Alignment.center,
                              child: Container(
                                color: Colors.white,
                                width: 300,
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    RichText(
                                      text: new TextSpan(
                                        text: "Disclaimer",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    RichText(
                                      text: new TextSpan(
                                        text:
                                            "The CROWDFUNDER TEAM app never shares or retains any information about it's users and only uses any information to confirm payments were made, and any information needed to make sure the app works as advertised",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black87,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(),
                                        FlatButton(
                                          padding: EdgeInsets.all(15),
                                          color: Color(0xff800080),
                                          onPressed: () {
                                            removeAllModals();
                                            showModal(ModalEntry.aligned(
                                                context,
                                                tag: 'Disclaimer',
                                                alignment: Alignment.center,
                                                child: Container(
                                                  color: Colors.white,
                                                  width: 300,
                                                  height: 200,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      RichText(
                                                        text: new TextSpan(
                                                          text: "Disclaimer",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      RichText(
                                                        text: new TextSpan(
                                                          text:
                                                              "The CROWDFUNDER app is not responsible for any funds lost and has 'No Refund' policy.",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(),
                                                          FlatButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            color: Color(
                                                                0xff800080),
                                                            onPressed: () =>
                                                                removeAllModals(),
                                                            child: Text(
                                                              "Done",
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )));
                                          },
                                          child: Text(
                                            "Next",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )))
                        },
                ),
                new TextSpan(
                    text: ' and',
                    style: GoogleFonts.roboto(
                        color: Colors.black38, fontSize: 12)),
                new TextSpan(
                  text: ' Privacy Policy',
                  style: GoogleFonts.roboto(
                      color: Color(0xff800080), fontSize: 12),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => {
                          showModal(ModalEntry.aligned(context,
                              tag: 'Disclaimer',
                              alignment: Alignment.center,
                              child: Container(
                                color: Colors.white,
                                width: 300,
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    RichText(
                                      text: new TextSpan(
                                        text: "Disclaimer",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    RichText(
                                      text: new TextSpan(
                                        text:
                                            "The CROWDFUNDER app is not responsible for any funds lost and has 'No Refund' policy. ",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black87,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(),
                                        FlatButton(
                                          padding: EdgeInsets.all(15),
                                          color: Color(0xff800080),
                                          onPressed: () => removeAllModals(),
                                          child: Text(
                                            "Done",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )))
                        },
                ),
              ]),
        ),
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

    TokenPreference.saveAddress("intro_screen", "seen");

    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  void onNextPress() {
    print("onNextPress caught");
  }

  Widget renderNextBtn() {
    return Container(
      height: 48,
      width: 115,
      color: Color(0xff800080),
      alignment: Alignment(0.0, 0.0),
      child: Text(
        "Next >",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget renderDoneBtn() {
    return (Icon(
      Icons.done,
      color: Color(0xff800080),
    ));
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
