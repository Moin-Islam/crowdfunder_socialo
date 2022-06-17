import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/app_button.dart';
import 'package:flutter_demo/widgets/app_large_text.dart';
import 'package:flutter_demo/widgets/app_text.dart';
import 'package:flutter_demo/widgets/responsive_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
      viewportFraction: 1,
    );
  }

  var indexing;
  List images = [
    "image1.png",
    "image2.png",
  ];
  List texts = [
    AppLargeText(text: "Welcome to the team"),
    AppText(
        text:
            "You are now in the CrowdFunder team where raising money for any cause is quick and easy!"),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (_, index) {
          return Container(
            width: 239.49,
            height: 283,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("img/" + images[index]),
            )),
            child: Container(
              margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        texts[index],
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300,
                          child: AppText(
                            text:
                                "You are now in the CrowdFunder team where raising money for any cause is quick and easy!",
                            color: Color(0xff707070),
                            size: 14,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        ResponsiveButton(
                          width: 120,
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(2, (indexDots) {
                        indexing = indexDots;
                        print(indexing);
                        return Container(
                          margin: const EdgeInsets.only(right: 2),
                          height: 5,
                          width: indexDots == index ? 5 : 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: indexDots == index
                                  ? Color(0xff800080)
                                  : Color(0xff800080).withOpacity(0.3)),
                        );
                      }),
                    ),
                    Column(
                      children: [
                        indexing == 1
                            ? AppButtons(
                                color: Color(0xff800080),
                                backgroundColor: Color(0xff800080),
                                borderColor: Color(0xff800080),
                                size: 20)
                            : AppText(text: "HELLO")
                      ],
                    )
                  ]),
            ),
          );
        },
      ),
    );
  }
}
