import 'package:flutter/material.dart';

class StripeAccount extends StatefulWidget {
  const StripeAccount({Key? key}) : super(key: key);

  @override
  State<StripeAccount> createState() => _StripeAccountState();
}

class _StripeAccountState extends State<StripeAccount> {
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
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset('img/image1.jpg'),
                Column(
                  children: [
                    Text(
                      ' Hasibul Haque Prottoy',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      ' User ID : 2345',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Text(
            'Bonus Product',
            style: TextStyle(
                color: Color(0xff800080),
                fontSize: 20,
                fontWeight: FontWeight.normal),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    ' This is Bonus Product',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' Lorem Ipsum',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 50,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' Total Sale : 6',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        ' Total Earnings :  *\$14.50',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
