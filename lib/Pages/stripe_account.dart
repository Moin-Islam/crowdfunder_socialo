import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';

class StripeAccount extends StatefulWidget {
  const StripeAccount({Key? key}) : super(key: key);

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
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                'User ID : 12314',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
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
      color: Color(0xff800080),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('This is Bonus Product'),
              Icon(
                Icons.turn_right,
                color: Color(0xff800080),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text('this is bonus product'),
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
              Text('Total Sale : 6'),
              Text('Total Earnings : *\$6'),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Product 1'),
              Icon(
                Icons.turn_right,
                color: Color(0xff800080),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text('Lorem Ipsum'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Sale : 6'),
              Text('Total Earnings : *\$6'),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Total Earning : *\$128.50',
            style: TextStyle(
                color: Color(0xff800080),
                fontSize: 20,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 15,
          ),
          buildUserProfile(),
          Text(
            'Bonus Product',
            style: TextStyle(
                color: Color(0xff800080),
                fontSize: 20,
                fontWeight: FontWeight.normal),
          ),
          buildBonusProduct(),
          SizedBox(
            height: 15,
          ),
          Text(
            'All Product List',
            style: TextStyle(
                color: Color(0xff800080),
                fontSize: 20,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 15,
          ),
          buildProductList(),
          SizedBox(
            height: 15,
          ),
          buildProductList(),
          SizedBox(
            height: 15,
          ),
          buildProductList(),
        ],
      ),
    );
  }
}
