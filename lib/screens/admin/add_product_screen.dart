import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
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
                    .add({
                  'name': nameController.text,
                  'price': double.parse(priceController.text),
                  'imageUrl': imageController.text,
                });

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}