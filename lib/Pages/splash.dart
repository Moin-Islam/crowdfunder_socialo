import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  final int amount;
  final String url;

  PaymentService({
    this.amount = 10,
    this.url = '',
  });

  static init() {
    Stripe.publishableKey =
        "pk_live_51LFJ1nGvX3w5S0IIi6fqxJQDTwAhnKQ2ank17Au5Qkm9ERB5Jdhbur1iD3fdJUKWYWFywg0OpJ4xtaV8XJpmOsnI00YghMSj4M";
  }

  Future createPaymentMethod(String public_key, secret_key) async {
    Map data = {'public_key': public_key, 'secret_key': secret_key};
    var jsonResponse = null;
    var response = await http.get(
      Uri.parse(
          "https://demo.socialo.agency/crowdfunder-api-application/profile/stripeInfo"),
          headers: {
          'Private-key':
              "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
        },
    );
  }

/*
  Future createPaymentIntent(String amount,currency) async {
    try {
      Map<String,dynamic> body = {
        'amount' : calculateAmount(amount),
        'currency' : currency,
        'payment_method_types[]': 'card'
      };
    }

    print(body);
    var response = await http.post(
      Uri.parse('https://api.')
    );

    catch(err) {

    };
  }

  Future ProcessPayment() async {
    Map paymentIntent = {'amount': 10, 'currency': USD};
    var jsonResponse = null;
    var response = await http.put(
        Uri.parse(
            "https://demo.socialo.agency/crowdfunder-api-application/profile/userInfo"),
        body: jsonEncode(paymentIntent));

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            applePay: true,
            googlePay: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'US',
            merchantDisplayName: 'Dede'));

    displayPlaymentSheet();
  }
*/
  Future<void> displayPlaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  Future<void> processPayment(PaymentMethod paymentMethod) async {
    final http.Response response = await http.post(
        Uri.parse('$url?amount=$amount&currency=USD&paym=${paymentMethod.id}'));

    if (response.body != 'error') {
      final PaymentIntent = jsonDecode(response.body);
      final status = PaymentIntent['paymentIntent']['status'];

      if (status == 'succeeded') {
        print(PaymentIntent.toString());
        print('successfull');
      } else {
        print('Fail');
      }
    }
  }
}
