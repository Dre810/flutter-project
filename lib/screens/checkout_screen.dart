import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterwave_standard/flutterwave.dart';

import '../providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void _payWithFlutterwave(BuildContext context, double amount) async {
    final customer = Customer(
      name: "Customer",
      phoneNumber: "0700000000",
      email: "customer@example.com",
    );

    final flutterwave = Flutterwave(
      context: context,
      publicKey: "FLWPUBK_TEST-c00b1d7a00353423a575ef61dfc47442-X", // 🔴 replace later
      currency: "KES",
      redirectUrl: "https://google.com",
      txRef: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount.toString(),
      customer: customer,
      paymentOptions: "card",
      customization: Customization(
        title: "E-Commerce App",
        description: "Payment for your order",
      ),
      isTestMode: true,
    );

    final response = await flutterwave.charge();

    if (response != null && response.status == "successful") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful")),
      );

      Provider.of<CartProvider>(context, listen: false).clearCart();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment cancelled or failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item =
                          cart.items.values.toList()[index];

                      return ListTile(
                        leading: Image.network(
                          item.imageUrl.isNotEmpty
                              ? item.imageUrl
                              : 'https://via.placeholder.com/150',
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        title: Text(item.name),
                        subtitle: Text(
                          'KES ${item.price} x ${item.quantity}',
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'KES ${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _payWithFlutterwave(
                              context,
                              cart.totalAmount,
                            );
                          },
                          child: const Text('Pay with Card'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}