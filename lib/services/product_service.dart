import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final _db = FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Product product) async {
    await _db.add(product.toMap());
  }

  Stream<List<Product>> getProducts() {
    return _db.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> seedProducts() async {
    final products = [
      Product(name: 'Nike Air Max', description: 'Comfortable running shoes', price: 12000, imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff', id: '1'),
      Product(name: 'iPhone 15', description: 'Latest Apple smartphone', price: 150000, imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569', id: '2'),
      Product(name: 'Samsung Watch', description: 'Fitness tracking smartwatch', price: 25000, imageUrl: 'https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b', id: '3'),
      Product(name: 'MacBook Pro', description: 'High-performance laptop', price: 280000, imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8', id: '4'),
      Product(name: 'Sony Headphones', description: 'Noise cancelling headphones', price: 45000, imageUrl: 'https://images.unsplash.com/photo-1580894894515-1c4b3b8b0c1d', id: '5'),
      Product(name: 'Canon Camera', description: 'Professional mirrorless camera', price: 320000, imageUrl: 'https://images.unsplash.com/photo-1519183071298-a2962be96c79', id: '6'),
      Product(name: 'Adidas Jacket', description: 'Stylish sports jacket', price: 8000, imageUrl: 'https://images.unsplash.com/photo-1528701800489-20be1c9c2d85', id: '7'),
      Product(name: 'Gaming Chair', description: 'Ergonomic gaming chair', price: 22000, imageUrl: 'https://images.unsplash.com/photo-1616628188130-6cfbe2e115fc', id: '8'),
      Product(name: 'Bluetooth Speaker', description: 'Portable speaker', price: 6000, imageUrl: 'https://images.unsplash.com/photo-1606813908942-5c3a218a1e2a', id: '9'),
      Product(name: 'Smart TV 55"', description: 'Ultra HD Smart TV', price: 70000, imageUrl: 'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04', id: '10'),
    ];

    for (final product in products) {
      await _db.add(product.toMap());
    }
  }
}