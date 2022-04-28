import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  State<IntroSliderPage> createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<Slide> slides = [];

  late Function goToTab;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    slides.add(
      new Slide(
          title: "aaa",
          styleTitle: TextStyle(
            color: Colors.amberAccent,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          pathImage: 'img/images1.png'),
    );
    slides.add(
      new Slide(
          title: "aaa",
          styleTitle: TextStyle(
            color: Colors.amberAccent,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          pathImage: 'img/images2.png'),
    );
    slides.add(
      new Slide(
          title: "aaa",
          styleTitle: TextStyle(
            color: Colors.amberAccent,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          pathImage: 'img/images3.png'),
    );
  }

  void onDonePress() {
    this.goToTab(0);
  }

  void onTabChangeCompleted(index) {}

  Widget renderNextbtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.blue.shade400,
      size: 35,
    );
  }

  Widget renderDonebtn() {
    return Icon(
      Icons.done,
      color: Colors.blue.shade400,
    );
  }

  Widget renderSkipbtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.blue.shade400,
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide? currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60, top: 60),
          child: ListView(
            children: [
              GestureDetector(
                child: Image.asset(
                  currentSlide.pathImage.toString(),
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Text(
                  currentSlide.title.toString(),
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20),
              ),
              Container(
                child: Text(
                  currentSlide.description.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20),
              )
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  BuildDisclaimer() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Disclaimer',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
            content: Text(
              '',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Color(0xff800080),
                  onPressed: (() {}),
                  child: Text('Next'))
            ],
          );
        });
  }

  Widget BuildDisclaimerBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => BuildDisclaimer())),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'Read Our ',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
            TextSpan(
              text: 'Disclaimer',
              style: TextStyle(
                color: Color(0xff800080),
                fontSize: 13,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: 'and ',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: Color(0xff800080),
                fontSize: 13,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.underline,
              ),
            )
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SLider app'),
        ),
        body: IntroSlider(
          slides: this.slides,
          renderSkipBtn: this.renderSkipbtn(),
          renderDoneBtn: this.renderDonebtn(),
          renderNextBtn: this.renderNextbtn(),
          colorDot: Colors.blue.shade900,
          sizeDot: 13.0,
          listCustomTabs: this.renderListCustomTabs(),
          backgroundColorAllSlides: Colors.white,
          refFuncGoToTab: (reffunc) {
            this.goToTab = reffunc;
          },
          onTabChangeCompleted: this.onTabChangeCompleted,
        ),
      ),
    );
  }
}
