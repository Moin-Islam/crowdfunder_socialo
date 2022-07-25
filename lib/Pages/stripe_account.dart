import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter_demo/Pages/member_list.dart';
import 'package:flutter_demo/Pages/stripe_module.dart';
import 'package:flutter_demo/utils/Product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StripeAccount extends StatefulWidget {
  const StripeAccount({Key key}) : super(key: key);

  @override
  State<StripeAccount> createState() => _StripeAccountState();
}

class _StripeAccountState extends State<StripeAccount> {
  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Product>> fetchProduct() async {
    String token = await getToken();

    var response = await http.get(
      Uri.parse(
          'https://demo.socialo.agency/crowdfunder-api-application/products/fetchProductSales'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      var body = jsonDecode(data["list_data"]);

      return body.map<Product>(Product.fromJson).toList();

      // if (jsonResponse != null) {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (BuildContext context) => SetUp()),
      //       (Route<dynamic> route) => false);
      // }
    } else {
      throw Exception('Failed to load User');
    }
  }

  Widget buildUserProfile() {
    return Container(
        child: Card(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: new Image.asset(
              'img/person.png',
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Text(
                'Ilias Kanchon',
                style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                'User ID : 12314',
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
              ),
            ],
          )
        ],
      ),
    ));
  }

  Widget buildProductList(String productID, String productName,
      String productURL, String productPrice, String saleCount) {
    return Container(
      width: double.infinity,
      color: Color(0xffF4F6F8),
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Product ' + productID,
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 13),
              ),
              IconButton(
                icon: Icon(Icons.turn_right),
                color: Color(0xff800080),
                onPressed: () async {
                  if (await canLaunch(productURL))
                    await launch(productURL);
                  else
                    // can't launch url, there is some error
                    throw "Could not launch $productURL";
                },
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            productName,
            style: GoogleFonts.roboto(fontSize: 12, color: Color(0xff707070)),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.black38,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Sale : $saleCount',
                style:
                    GoogleFonts.rubik(fontSize: 13, color: Color(0xff800080)),
              ),
              ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => StripeAccount())),
                    child: Row(
                      children: [
                        Text(
                          "Product links",
                          style: GoogleFonts.rubik(color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff800080)),
                    ),
                  ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildBackBtn() {
    return Align(
      alignment: Alignment.topRight,
      child: FlatButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => StripeModuleX()),
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
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              buildBackBtn(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Total Earning : \$128.50',
                    style: GoogleFonts.rubik(
                        color: Color(0xff800080),
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              buildUserProfile(),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'All Product List',
                    style: GoogleFonts.rubik(
                        color: Color(0xff800080),
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder<List<Product>>(
                  future: fetchProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final members = snapshot.data;
                      // for (var i = 0; i < members.length; i++) {
                      //   // TO DO
                      //   var currentElement = li[i];
                      // }

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          Product member = members[index];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Widget to display the list of project
                              // singleUserList(
                              //     member.id,
                              //     member.name,
                              //     member.saleId,
                              //     member.publishableKey,
                              //     member.productPrice,
                              //     index),

                              buildProductList(
                                  member.productID,
                                  member.productName,
                                  member.productURL,
                                  member.productPrice,
                                  member.saleCount),

                              SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
