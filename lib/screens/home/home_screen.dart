import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();

    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: StreamBuilder<List<Product>>(
        stream: productService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show shimmer while loading
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: ListTile(
                  leading: Container(width: 50, height: 50, color: Colors.white),
                  title: Container(height: 10, color: Colors.white),
                  subtitle: Container(height: 10, color: Colors.white),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

            return Card(
  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  child: ListTile(
    leading: product.imageUrl.isNotEmpty
        ? Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
        : Container(width: 50, height: 50, color: Colors.grey),
    title: Text(product.name),
    subtitle: Text('KES ${product.price.toStringAsFixed(2)}'),
    trailing: ElevatedButton(
      onPressed: () {
        final cart = Provider.of<CartProvider>(context, listen: false);
        cart.addToCart(product);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to cart')),
        );
      },
      child: const Text('Add to Cart'),
    ),
  ),
);
            },
          );
        },
      ),
    );
  }
}