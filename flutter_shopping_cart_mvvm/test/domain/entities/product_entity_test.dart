import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductEntity', () {
    test('ProductEntity can be instantiated with valid data', () {
      final product = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 9.99,
        description: 'This is a test product',
        category: 'Electronics',
        image: 'http://example.com/image.jpg',
        rate: 4.5,
        count: 100,
      );

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 9.99);
      expect(product.description, 'This is a test product');
      expect(product.category, 'Electronics');
      expect(product.image, 'http://example.com/image.jpg');
      expect(product.rate, 4.5);
      expect(product.count, 100);
    });

    test('All properties are correctly assigned via constructor', () {
      final product = ProductEntity(
        id: 2,
        title: 'Another Product',
        price: 19.99,
        description: 'Another test product description',
        category: 'Books',
        image: 'http://example.com/another_image.png',
        rate: 3.8,
        count: 50,
      );

      expect(product.id, 2);
      expect(product.title, 'Another Product');
      expect(product.price, 19.99);
      expect(product.description, 'Another test product description');
      expect(product.category, 'Books');
      expect(product.image, 'http://example.com/another_image.png');
      expect(product.rate, 3.8);
      expect(product.count, 50);
    });
  });
}
