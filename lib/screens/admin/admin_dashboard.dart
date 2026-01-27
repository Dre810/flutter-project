import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final productsRef = FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 SUMMARY CARDS
            Row(
              children: [
                _summaryCard(
                  title: 'Products',
                  icon: Icons.inventory,
                  stream: productsRef.snapshots(),
                ),
                const SizedBox(width: 12),
                _staticCard(
                  title: 'Orders',
                  icon: Icons.receipt_long,
                  value: '—',
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 QUICK ACTIONS
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                    onPressed: () {
                      // TODO: open add product screen
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: const Text('Manage Products'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 PRODUCT LIST
            const Text(
              'Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: productsRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No products found'));
                  }

                  final products = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final doc = products[index];
                      final data =
                          doc.data() as Map<String, dynamic>;

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
                          subtitle:
                              Text('KES ${data['price']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // TODO: edit product
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await productsRef
                                      .doc(doc.id)
                                      .delete();
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
        ),
      ),
    );
  }

  /// 🔹 DYNAMIC CARD (FROM FIRESTORE)
  Widget _summaryCard({
    required String title,
    required IconData icon,
    required Stream<QuerySnapshot> stream,
  }) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          final count =
              snapshot.hasData ? snapshot.data!.docs.length : 0;

          return _card(title, icon, count.toString());
        },
      ),
    );
  }

  /// 🔹 STATIC CARD
  Widget _staticCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Expanded(
      child: _card(title, icon, value),
    );
  }

  Widget _card(String title, IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue.shade50,
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }
}