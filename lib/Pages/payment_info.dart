import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter_demo/Pages/set_up.dart';
import 'package:flutter_demo/Pages/stripe_account.dart';
import 'package:flutter_demo/Pages/stripe_module.dart';
import 'package:flutter_demo/utils/token_preference.dart';
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
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
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
            child: TextFormField(
              inputFormatters: [cardFormatter],
              controller: cardnumberController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your card number';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.only(left: 14, top: 14, bottom: 14),
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
            child: TextFormField(
              controller: cardholdernameController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your card holder name';
                }
                return null;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.only(left: 14, top: 14, bottom: 14),
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
            child: TextFormField(
              inputFormatters: [maskFormatter],
              controller: expirydateController,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your expiry date';
                }
                return null;
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                isDense: true,
                filled: true,
                hintText: "MM/YY",
                contentPadding: EdgeInsets.only(left: 14, top: 14, bottom: 14),
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
            child: TextFormField(
              controller: cvvController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your cvv';
                }
                return null;
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.only(left: 14, top: 14, bottom: 14),
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

  StripePayment(id, BuildContext context) async {
    Stripe.publishableKey = widget.data[id]['publishableKey'];
    print(widget.data[id]['publishableKey']);
    Stripe.merchantIdentifier = "test";
    TokenData tokenData;

    var res = await Stripe.instance
        .createToken(CreateTokenParams(type: TokenType.Card))
        .then((res) {
      print(res);
      print("NAXY");
      tokenData = res;
      print("NAXY");
      print(tokenData.id);
    }).onError((error, stackTrace) {
      print("onError sent message: $error");
      if (error is StripeException) {
        print("Error from Stripe: ${error.error.localizedMessage}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.error.localizedMessage),
          duration: Duration(milliseconds: 3000),
        ));

        setState(() {
          _isLoading = false;
        });
      }
    });

    if (widget.data[id] != null || widget.data[id] != {}) {
      /*receiveData['team_data'][k]
                    .add();*/
      temp.add({'saleId': id, 'stripeToken': tokenData.id});
    }
  }

  checkUserStatus(String token) async {
    final user_response = await http.get(
      Uri.parse(
          'https://crowdfunderteam.com/api/dashboard/userInfo'),
      headers: {
        'Authorization': '$token',
        'Private-key': "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
      },
    );

    if (user_response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(user_response.body);
      TokenPreference.saveAddress("name", data["USER_DATA"][0]["name"]);
      TokenPreference.saveAddress("id", data["USER_DATA"][0]["id"]);
      TokenPreference.saveAddress("status", data["USER_DATA"][0]["status"]);
      TokenPreference.saveAddress(
          "profile_image", data["USER_DATA"][0]["profile_image"]);

      print(data["USER_DATA"][0]["status"]);

      if (data["USER_DATA"][0]["status"] == "0") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MemberList()),
            (Route<dynamic> route) => false);
      } else {
        print("NAX");
        print(data["USER_DATA"][0]["stripe_status"]);

        if (data["USER_DATA"][0]["stripe_status"] == "1") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => StripeModuleX()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => SetUp()),
              (Route<dynamic> route) => false);
        }
      }
    }
  }

  Widget buildSetUpAccountbtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: RaisedButton(
        onPressed: _isLoading
            ? null
            : () async {
                if (_formKey.currentState != null &&
                    _formKey.currentState.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  String token = await getToken();
                  await Stripe.instance
                      .dangerouslyUpdateCardDetails(CardDetails(
                    number: cardFormatter.getUnmaskedText(),
                    expirationMonth:
                        int.parse(expirydateController.text.split('/')[0]),
                    expirationYear:
                        int.parse(expirydateController.text.split('/')[1]),
                    cvc: cvvController.text,
                  ));
                  for (var id in widget.data.keys) {
                    await StripePayment(id, context);
                  }

                  // widget.data.keys.forEach(await (id) {
                  //     StripePayment(id);
                  // });

                  // StripePayment().then((res) {}
                  //   );

                  receiveData['team_data'] = temp;

                  print("NAXXX");
                  print(receiveData);
                  var response = await http.post(
                      Uri.parse(
                          "https://crowdfunderteam.com/api/purchase/purchaseProcess"),
                      headers: {
                        'Authorization': '$token',
                        'Private-key': "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
                      },
                      body: json.encode(receiveData));

                  print("response");
                  print(response.body);

                  Map<String, dynamic> data = jsonDecode(response.body);

                  setState(() {
                    _log = json.encode(receiveData) + response.body;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(data['message']),
                    duration: Duration(milliseconds: 3000),
                  ));

                  setState(() {
                    _isLoading = false;
                  });

                  if (data["status"] == 1) {
                    checkUserStatus(token);
                  }
                }
              },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(0xff800080),
        child: _isLoading
            ? Text(
                'Processing payment please wait',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              )
            : Text(
                'Pay Now     \$' + widget.price,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
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
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                    Text(
                      'Payment Info',
                      style: GoogleFonts.rubik(
                        color: Color(0xff800080),
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    buildLogOutBtn(),
                      ],),
                    SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       alignment: Alignment(0.0, 0.0),
                    //       width: 130,
                    //       height: 133,
                    //       decoration: BoxDecoration(
                    //           color: Color(0xff800080),
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(10))),
                    //       child: Text(
                    //         'Visa',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.normal,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(width: 50),
                    //     Container(
                    //       alignment: Alignment(0.0, 0.0),
                    //       width: 130,
                    //       height: 133,
                    //       decoration: BoxDecoration(
                    //           color: Color(0xffF4F6F8),
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(10))),
                    //       child: Text(
                    //         'Stripe',
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.normal,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    SizedBox(height: 20),
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          ],
                        )),

                    buildSetUpAccountbtn(context),
                    //Text((_log == null) ? "Logs" : '$_log')
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
