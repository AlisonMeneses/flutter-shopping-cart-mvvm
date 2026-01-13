import 'package:flutter_shopping_cart_mvvm/domain/entities/cart_item_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartItemEntity', () {
    late ProductEntity mockProduct;

    setUp(() {
      mockProduct = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 10.0,
        description: 'Description',
        category: 'Category',
        image: 'image.jpg',
        rate: 4.0,
        count: 10,
      );
    });

    test('CartItemEntity can be instantiated with valid data and default quantity', () {
      final cartItem = CartItemEntity(productEntity: mockProduct);

      expect(cartItem.productEntity, mockProduct);
      expect(cartItem.quantity, 1);
      expect(cartItem.subtotal, 10.0);
    });

    test('CartItemEntity can be instantiated with custom quantity', () {
      final cartItem = CartItemEntity(productEntity: mockProduct, quantity: 3);

      expect(cartItem.productEntity, mockProduct);
      expect(cartItem.quantity, 3);
      expect(cartItem.subtotal, 30.0);
    });

    test('subtotal getter calculates correctly with quantity changes', () {
      final cartItem = CartItemEntity(productEntity: mockProduct, quantity: 2);
      expect(cartItem.subtotal, 20.0);

      cartItem.quantity = 5;
      expect(cartItem.subtotal, 50.0);
    });

    test('subtotal getter calculates correctly for zero quantity', () {
      final cartItem = CartItemEntity(productEntity: mockProduct, quantity: 0);
      expect(cartItem.subtotal, 0.0);
    });

    test('subtotal getter calculates correctly for different product prices', () {
      final product2 = ProductEntity(
        id: 2,
        title: 'Another Product',
        price: 25.50,
        description: 'Description',
        category: 'Category',
        image: 'image2.jpg',
        rate: 3.5,
        count: 5,
      );
      final cartItem = CartItemEntity(productEntity: product2, quantity: 2);
      expect(cartItem.subtotal, 51.0);
    });
  });
}
