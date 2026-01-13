
import 'package:flutter_shopping_cart_mvvm/data/models/product_model.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductModel', () {
    final productMap = {
      'id': 1,
      'title': 'Test Product',
      'price': 9.99,
      'description': 'This is a test product',
      'category': 'Electronics',
      'image': 'http://example.com/image.jpg',
      'rating': {'rate': 4.5, 'count': 100}
    };

    test('ProductModel.fromMap should return a valid ProductModel', () {
      final productModel = ProductModel.fromMap(productMap);

      expect(productModel, isA<ProductModel>());
      expect(productModel.id, 1);
      expect(productModel.title, 'Test Product');
      expect(productModel.price, 9.99);
      expect(productModel.description, 'This is a test product');
      expect(productModel.category, 'Electronics');
      expect(productModel.image, 'http://example.com/image.jpg');
      expect(productModel.rate, 4.5);
      expect(productModel.count, 100);
    });

    test('ProductModel.fromMap should handle missing/null values gracefully', () {
      final incompleteMap = {
        'id': 2,
        'title': null, // Missing title
        'price': 15.0,
        'description': 'Description',
        'category': 'Category',
        'image': 'image.jpg',
        'rating': {'rate': null, 'count': 50} // Missing rate
      };

      final productModel = ProductModel.fromMap(incompleteMap);

      expect(productModel.id, 2);
      expect(productModel.title, ''); // Default for missing string
      expect(productModel.price, 15.0);
      expect(productModel.rate, 0.0); // Default for missing double
      expect(productModel.count, 50);
    });

    test('ProductModel should extend ProductEntity', () {
      final productModel = ProductModel.fromMap(productMap);
      expect(productModel, isA<ProductEntity>());
    });
  });
}
