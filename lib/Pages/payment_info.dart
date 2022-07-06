import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/set_up.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "./member_list.dart";
import 'package:flutter_demo/Pages/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:flutter_demo/Pages/sign_in.dart';

class PaymentInfo extends StatefulWidget {
  final Map data;
  final String price;

  PaymentInfo({Key key, @required this.data, @required this.price})
      : super(key: key);

  @override
  State<PaymentInfo> createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {
  var _log;

  var maskFormatter =
      MaskTextInputFormatter(mask: '##/####', filter: {"#": RegExp(r'[0-9]')});

  var cardFormatter = MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});

  TextEditingController cardnumberController = TextEditingController();
  TextEditingController cardholdernameController = TextEditingController();
  TextEditingController expirydateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  Map receiveData = {'team_data': []};
  var temp = [];
  @override
  void initState() {
    super.initState();
    PaymentService.init();
  }

  Widget buildCardNumber() {
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
            child: TextFormField(
              inputFormatters: [cardFormatter],
              controller: cardnumberController,
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
            )),
      ],
    );
  }

  Widget buildCardHolderName() {
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
            child: TextFormField(
              controller: cardholdernameController,
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
            ))
      ],
    );
  }

  Widget buildExpiryDate() {
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
            child: TextFormField(
              inputFormatters: [maskFormatter],
              controller: expirydateController,
              keyboardType: TextInputType.datetime,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 14),
                hintText: 'Month / Year',
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
              ),
            ))
      ],
    );
  }

  Widget buildCVV() {
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
            child: TextFormField(
              controller: cvvController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
              ),
            ))
      ],
    );
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  StripePayment() async {
    var a = await Stripe.instance
        .createToken(CreateTokenParams(type: TokenType.Card));
    return a;
  }

  Widget buildSetUpAccountbtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () async {
          String token = await getToken();

          widget.data.keys.forEach((k) {
            Stripe.publishableKey = widget.data[k]['publishableKey'];
            print(widget.data[k]['publishableKey']);
            Stripe.merchantIdentifier = "test";

            Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
              number: cardFormatter.getUnmaskedText(),
              expirationMonth:
                  int.parse(expirydateController.text.split('/')[0]),
              expirationYear:
                  int.parse(expirydateController.text.split('/')[1]),
              cvc: cvvController.text,
            ));

            StripePayment().then((res) {
              TokenData tokenData = res;

              if (widget.data[k] != null || widget.data[k] != {}) {
                /*receiveData['team_data'][k]
                    .add();*/
                temp.add({'saleId': k, 'stripeToken': tokenData.id});
              }
            });
          });

          receiveData['team_data'] = temp;
          print(receiveData);
          var response = await http.post(
              Uri.parse(
                  "https://demo.socialo.agency/crowdfunder-api-application/purchase/purchaseProcess"),
              headers: {
                'Authorization': '$token',
              },
              body: json.encode(receiveData));

          print("response");
          print(response.body);

          setState(() {
            _log = response.body;
          });

          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => StripeAccount()),
          //     (Route<dynamic> route) => false);
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(0xff800080),
        child: Text(
          'Pay Now     \$' + widget.price,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget buildLogOutBtn() {
    return Align(
      alignment: Alignment.topRight,
      child: FlatButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => MemberList()),
              (_) => false,
            );
          },
          padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Icon(
            Icons.arrow_back,
            color: Color(0xff800080),
          )),
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
              width: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLogOutBtn(),
                    Text(
                      'Payment Info',
                      style: GoogleFonts.rubik(
                        color: Color(0xff800080),
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment(0.0, 0.0),
                          width: 130,
                          height: 133,
                          decoration: BoxDecoration(
                              color: Color(0xff800080),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            'Visa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(width: 50),
                        Container(
                          alignment: Alignment(0.0, 0.0),
                          width: 130,
                          height: 133,
                          decoration: BoxDecoration(
                              color: Color(0xffF4F6F8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            'Stripe',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Card Number \*',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    buildCardNumber(),
                    SizedBox(height: 20),
                    Text(
                      'Card Holder Name \*',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    buildCardHolderName(),
                    SizedBox(height: 20),
                    Text(
                      'Expiry Date \*',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    buildExpiryDate(),
                    SizedBox(height: 20),
                    Text(
                      'CVV \*',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    buildCVV(),
                    buildSetUpAccountbtn(),
                    Text((_log == null) ? "Logs" : '$_log')
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
