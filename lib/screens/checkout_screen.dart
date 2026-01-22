import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../services/payment_service.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

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
                'No items to checkout',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                // CART ITEMS
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
                              : 'https://via.placeholder.com/100',
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        title: Text(item.name),
                        subtitle: Text(
                          'KES ${item.price} × ${item.quantity}',
                        ),
                        trailing: Text(
                          'KES ${(item.price * item.quantity).toStringAsFixed(2)}',
                        ),
                      );
                    },
                  ),
                ),

                // TOTAL + PAY BUTTON
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'KES ${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await PaymentService.payWithCard();
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Payment failed to start',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Pay with Card',
                            style: TextStyle(fontSize: 16),
                          ),
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