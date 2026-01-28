import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductScreen extends StatefulWidget {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  const EditProductScreen({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
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
    nameController = TextEditingController(text: widget.name);
    priceController =
        TextEditingController(text: widget.price.toString());
    imageController =
        TextEditingController(text: widget.imageUrl);
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
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.id)
                    .update({
                  'name': nameController.text,
                  'price': double.parse(priceController.text),
                  'imageUrl': imageController.text,
                });

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}