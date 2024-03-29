import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  var _image;
  String name;
  String invitation_code;
  String short_invitation_code;
  int startIndex = 0;
  int endIndex = 5;

  String _earning;

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchProduct();
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future fetchUser() async {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(
          'https://crowdfunderteam.com/api/profile/userInfo'),
      headers: {
        'Authorization': '$token',
        'Private-key':
              "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        name = data["USER_DATA"][0]["name"];
      });

      setState(() {
        _earning = data["USER_DATA"][0]["total_earning"];
      });
      setState(() {
        invitation_code = data["USER_DATA"][0]["invitation_code"];
        short_invitation_code=invitation_code.substring(startIndex,endIndex);
      });

      var image1 = data["USER_DATA"][0]["profile_image"];
      setState(() {
        _image = base64Decode(image1);
      });

      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future<List<Product>> fetchProduct() async {
    String token = await getToken();

    var response = await http.get(
      Uri.parse(
          'https://crowdfunderteam.com/api/products/fetchProductSales'),
      headers: {
        'Authorization': '$token',
        'Private-key':
              "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
      },
    );

  Map data = jsonDecode(response.body);
    if (data["http_response_code"] == 200) {
      
      print(data);
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

  Clipbooard(BuildContext context) {
     Clipboard.setData(ClipboardData(text : invitation_code)).then((_){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied to Clipbaord")));
});;
  }



  Widget buildUserProfile(BuildContext context) {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: new BorderSide(color: Color(0xff800080), width: 1.0)),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(20),
              child: (_image == null || _image == '')
                  ? CircularProgressIndicator()
                  : CircleAvatar(
                      radius: 30.0,
                      backgroundImage: MemoryImage(_image), //here
                    )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (name == null) ? "Fetching value..." : '$name',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Text(
                (invitation_code == null)
                    ? "Fetching value..."
                    : 'Invitation code: $short_invitation_code' + ".....",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.normal), 
              ),
              TextButton(onPressed:(() async {
                
    Clipboard.setData(ClipboardData(text : invitation_code)).then((_){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied to Clipbaord")));
});;
              }),child: const Icon(Icons.copy),)
                ],
              )
            ],
          )
        ],
      ),
    ));
  }

  Widget buildProductList(String productID, String productName,
      String productURL, String productPrice, String saleCount, String productDescription) {
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
                 productName,
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
            productDescription,
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
                onPressed: () async {
                  if (await canLaunch(productURL))
                    await launch(productURL);
                  else
                    // can't launch url, there is some error
                    throw "Could not launch $productURL";
                },
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
                  backgroundColor: MaterialStateProperty.all(Color(0xff800080)),
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
      child: TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => StripeModuleX()),
              (_) => false,
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          
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
                    (_earning == null)
                        ? "Fetching value..."
                        : 'Total Earning : \$$_earning',
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
              buildUserProfile(context),
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
                        physics: NeverScrollableScrollPhysics(),
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
                                  member.saleCount,
                                  member.productDescription),

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
