import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) => Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CartScreen(),
                      ),
                    );
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final products = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, index) {
              final product = products[index];
              final data = product.data() as Map<String, dynamic>;

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          data['imageUrl'],
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // NAME
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Text(
                        data['name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // PRICE
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'KES ${data['price']}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // ADD TO CART
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Provider.of<CartProvider>(
                              context,
                              listen: false,
                            ).addToCart(
                              product.id,
                              data['name'],
                              (data['price'] as num).toDouble(),
                              data['imageUrl'],
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to cart'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}