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

  /// RUN THIS ONCE ONLY
  Future<void> seedProducts() async {
    final products = [
      Product(
        name: 'Denim Jeans',
        description: 'Classic blue denim jeans for everyday wear',
        price: 3500,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Jeans_for_men.jpg/640px-Jeans_for_men.jpg',
      ),
      Product(
        name: 'Nike Air Max',
        description: 'Comfortable running shoes',
        price: 12000,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/6/6e/Nike_Air_Max_90.jpg',
      ),
      Product(
        name: 'iPhone 15',
        description: 'Latest Apple smartphone',
        price: 150000,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/3/32/IPhone_15_Pro.jpg',
      ),
      Product(
        name: 'Samsung Watch',
        description: 'Fitness tracking smartwatch',
        price: 25000,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/8/8e/Samsung_Galaxy_Watch.jpg',
      ),
      Product(
        name: 'MacBook Pro',
        description: 'High-performance laptop',
        price: 280000,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/1/1e/MacBook_Pro_16-inch.jpg',
      ),
      Product(
        name: 'Sony Headphones',
        description: 'Noise cancelling headphones',
        price: 45000,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/2/2e/Sony_WH-1000XM4.jpg',
      ),
      Product(
        name: 'Canon Camera',
        description: 'Professional mirrorless camera',
        price: 320000,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/5/5e/Canon_EOS_R6.jpg',
      ),
      Product(
        name: 'Adidas Jacket',
        description: 'Stylish sports jacket',
        price: 8000,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/3/33/Adidas_jacket.jpg',
      ),
      Product(
        name: 'Gaming Chair',
        description: 'Ergonomic gaming chair',
        price: 22000,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/4/45/Gaming_chair.jpg',
      ),
      Product(
        name: 'Smart TV 55"',
        description: 'Ultra HD Smart TV',
        price: 70000,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/9/9b/Smart_TV.jpg',
      ),
    ];

    for (final product in products) {
      await _db.add(product.toMap());
    }
  }

  Future<void> addProduct(Product product) async {}
}