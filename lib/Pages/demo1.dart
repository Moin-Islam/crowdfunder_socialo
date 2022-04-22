import 'package:flutter_demo/widgets/sqaure.dart';
import 'package:flutter/material.dart';

class demo1 extends StatelessWidget {
  final List posts = ['Card', 'Stripe', 'Bkash'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: posts.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Mysquare(child: posts[index]);
            },
          ))
        ],
      ),
    );
  }
}
