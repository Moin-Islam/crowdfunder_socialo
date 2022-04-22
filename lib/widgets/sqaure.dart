import 'package:flutter/material.dart';

class Mysquare extends StatelessWidget {
  final child;

  Mysquare({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purple.shade300,
        ),
        child: Center(
          child: Text(
            child,
            style: TextStyle(color: Colors.black38, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
