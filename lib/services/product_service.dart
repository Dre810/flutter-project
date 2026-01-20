import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final _db = FirebaseFirestore.instance.collection('products');

  Stream<List<Product>> getProducts() {
    return _db.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    });
  }

 Future<void> seedProducts() async {
  final products = [
    Product(
      name: 'Nike Air Max',
      description: 'Comfortable running shoes',
      price: 12000,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
    ),
    Product(
      name: 'iPhone 15',
      description: 'Latest Apple smartphone',
      price: 150000,
      imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569',
    ),
    Product(
      name: 'Canon Camera',
      description: 'Professional mirrorless camera',
      price: 320000,
      imageUrl: 'https://images.unsplash.com/photo-1519183071298-a2962be96c0c',
    ),
    Product(
      name: 'Adidas Jacket',
      description: 'Stylish sports jacket',
      price: 8000,
      imageUrl: 'https://images.unsplash.com/photo-1520975916090-3105956dac38',
    ),
    Product(
      name: 'Gaming Chair',
      description: 'Ergonomic gaming chair',
      price: 22000,
      imageUrl: 'https://images.unsplash.com/photo-1598300053650-28a0bdf3a7d5',
    ),
    Product(
      name: 'Samsung Watch',
      description: 'Fitness tracking smartwatch',
      price: 25000,
      imageUrl: 'https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b',
    ),
    Product(
      name: 'Macbook Pro',
      description: 'Powerful laptop',
      price: 150000,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
    ),
    Product(
      name: 'Sony TV',
      description: 'Ultra HD smart TV',
      price: 120000,
      imageUrl: 'https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b',
    ),
    Product(
      name: 'Bose Headphones',
      description: 'Noise-cancelling headphones',
      price: 40000,
      imageUrl: 'https://images.unsplash.com/photo-1519183071298-a2962be96c0c',
    ),
    Product(
      name: 'Dell Monitor',
      description: '4K UHD monitor',
      price: 60000,
      imageUrl: 'https://images.unsplash.com/photo-1520975916090-3105956dac38',
    ),
  ];

  for (final product in products) {
    await _db.add(product.toMap());
  }
}
  Future<void> addProduct(Product product) async {}
}