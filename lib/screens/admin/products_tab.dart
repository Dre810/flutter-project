import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final productsRef = FirebaseFirestore.instance.collection('products');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddProductScreen(),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: productsRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No products'));
              }

              final products = snapshot.data!.docs;

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final doc = products[index];
                  final data = doc.data() as Map<String, dynamic>;

                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        data['imageUrl'],
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image),
                      ),
                      title: Text(data['name']),
                      subtitle: Text('KES ${data['price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditProductScreen(
                                    id: doc.id,
                                    name: data['name'],
                                    price: data['price'].toDouble(),
                                    imageUrl: data['imageUrl'],
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await productsRef.doc(doc.id).delete();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}