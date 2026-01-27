import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.productData,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.productData['name']);
    priceController =
        TextEditingController(text: widget.productData['price'].toString());
    imageController =
        TextEditingController(text: widget.productData['imageUrl']);
  }

  Future<void> _updateProduct() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .update({
      'name': nameController.text.trim(),
      'price': double.parse(priceController.text),
      'imageUrl': imageController.text.trim(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProduct,
              child: const Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}