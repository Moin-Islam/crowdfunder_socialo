import 'dart:convert';

import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  final int amount;
  final String url;

  PaymentService({
    this.amount = 10,
    this.url = '',
  });

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            'pk_test_51LFJ1nGvX3w5S0IIs8BGxaw9LV0i8zclsaT0wfbYom1h2eso9kwLMjjCErhCeRxaTkaEZYxX70kWrDNTEEWrTcRm008DVCZfql',
        androidPayMode: 'test',
        merchantId: ''));
  }

  Future<PaymentMethod> createPaymentMethod() async {
    print('object');

    PaymentMethod paymentMethod =
        await StripePayment.paymentRequestWithCardForm(
            CardFormPaymentRequest());
    return paymentMethod;
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
