import 'dart:html' as html;
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  // 🔗 YOUR Stripe Payment Link
  static const String stripePaymentLink =
      'https://buy.stripe.com/test_cNi8wQdj3fDDffIb22gIo02';

  void _openStripe() {
    html.window.open(stripePaymentLink, '_blank');
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Successful 🎉'),
        content: const Text(
          'Thank you for your order.\n\n'
          'If you completed payment on Stripe, your order is being processed.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // go back to cart
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: Colors.green),
            const SizedBox(height: 20),

            const Text(
              'Secure Payment',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Text(
              'You will be redirected to Stripe to complete payment.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openStripe,
                child: const Text('Pay with Card'),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showSuccess(context),
                child: const Text('Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}