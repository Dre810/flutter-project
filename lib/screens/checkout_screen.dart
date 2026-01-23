import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  Future<void> _pay() async {
    final Uri url = Uri.parse(
      'https://buy.stripe.com/test_cNi8wQdj3fDDffIb22gIo02',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Center(
        child: ElevatedButton(
          onPressed: _pay,
          child: const Text('Pay with Card'),
        ),
      ),
    );
  }
}