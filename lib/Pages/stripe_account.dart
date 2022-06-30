import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter_demo/Pages/member_list.dart';
import 'package:google_fonts/google_fonts.dart';

class StripeAccount extends StatefulWidget {
  const StripeAccount({Key key}) : super(key: key);

  @override
  State<StripeAccount> createState() => _StripeAccountState();
}

class _StripeAccountState extends State<StripeAccount> {
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

  Widget buildBonusProduct() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      color: Color(0xff800080),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This is Bonus Product',
                style: GoogleFonts.roboto(fontSize: 13, color: Colors.white),
              ),
              Icon(
                Icons.turn_right,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text('this is bonus product',
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.white)),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Sale : 6',
                  style: GoogleFonts.rubik(fontSize: 13, color: Colors.white)),
              Text('Total Earnings : \$6',
                  style: GoogleFonts.rubik(fontSize: 13, color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }

  Widget buildProductList() {
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
                'Product 1',
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 13),
              ),
              Icon(
                Icons.turn_right,
                color: Color(0xff800080),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Lorem Ipsum',
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
                'Total Sale : 6',
                style:
                    GoogleFonts.rubik(fontSize: 13, color: Color(0xff800080)),
              ),
              Text('Total Earnings : \$6',
                  style: GoogleFonts.rubik(
                      fontSize: 13, color: Color(0xff800080))),
            ],
          )
        ],
      ),
    );
  }

  Widget buildBackBtn() {
    return Container(
      child: IconButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MemberList())),
        icon: Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
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
                    'Bonus Product',
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
              buildBonusProduct(),
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
              buildProductList(),
              SizedBox(
                height: 20,
              ),
              buildProductList(),
              SizedBox(
                height: 20,
              ),
              buildProductList(),
            ],
          ),
        ),
      ),
    );
  }
}
