import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const String stripeCheckoutUrl =
      'https://buy.stripe.com/test_cNi7sM2tKeTg87veJe7Zu00';

  Future<void> _payWithCard(BuildContext context) async {
    final uri = Uri.parse(stripeCheckoutUrl);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open payment page')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...cart.items.values.map((item) {
              return ListTile(
                title: Text(item.name),
                trailing: Text(
                  'KES ${(item.price * item.quantity).toStringAsFixed(2)}',
                ),
              );
            }),

            const Divider(),
            const SizedBox(height: 10),

            Text(
              'Total: KES ${cart.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _payWithCard(context),
                child: const Text('Pay with Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}