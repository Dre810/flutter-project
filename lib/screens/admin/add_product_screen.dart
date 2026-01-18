import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final product = Product(
                      id: '',
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                      price: double.tryParse(priceController.text.trim()) ?? 0,
                      imageUrl: imageUrlController.text.trim(),
                    );
                    await _productService.addProduct(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added successfully')),
                    );

                    // Clear fields
                    nameController.clear();
                    descriptionController.clear();
                    priceController.clear();
                    imageUrlController.clear();
                  } catch (e) {
                    setState(() {
                      error = 'Failed to add product';
                    });
                  }
                },
                child: const Text('Add Product'),
              ),
              const SizedBox(height: 10),
              Text(error, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}