import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/sessions/cart_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock ProductEntity for testing purposes
class MockProductEntity extends Mock implements ProductEntity {}

void main() {
  group('CartSession', () {
    late CartSession cartSession;
    late ProductEntity product1;
    late ProductEntity product2;
    late ProductEntity product3;

    setUp(() {
      cartSession = CartSession();
      product1 = ProductEntity(
        id: 1,
        title: 'Product 1',
        price: 10.0,
        description: 'Desc 1',
        category: 'Cat 1',
        image: 'img1.jpg',
        rate: 4.0,
        count: 10,
      );
      product2 = ProductEntity(
        id: 2,
        title: 'Product 2',
        price: 20.0,
        description: 'Desc 2',
        category: 'Cat 2',
        image: 'img2.jpg',
        rate: 3.5,
        count: 5,
      );
      product3 = ProductEntity(
        id: 3,
        title: 'Product 3',
        price: 5.0,
        description: 'Desc 3',
        category: 'Cat 3',
        image: 'img3.jpg',
        rate: 4.8,
        count: 20,
      );
    });

    test('initial state has empty items list and zero totals', () {
      expect(cartSession.items, isEmpty);
      expect(cartSession.totalItems, 0);
      expect(cartSession.subtotal, 0.0);
    });

    group('add', () {
      test('adds a new product with quantity 1 if not present', () {
        cartSession.add(product1);
        expect(cartSession.items.length, 1);
        expect(cartSession.items.first.productEntity.id, product1.id);
        expect(cartSession.items.first.quantity, 1);
        expect(cartSession.totalItems, 1);
        expect(cartSession.subtotal, 10.0);
      });

      test('increments quantity if product is already present', () {
        cartSession.add(product1);
        cartSession.add(product1);
        expect(cartSession.items.length, 1);
        expect(cartSession.items.first.productEntity.id, product1.id);
        expect(cartSession.items.first.quantity, 2);
        expect(cartSession.totalItems, 2);
        expect(cartSession.subtotal, 20.0);
      });

      test('adds multiple unique products', () {
        cartSession.add(product1);
        cartSession.add(product2);
        expect(cartSession.items.length, 2);
        expect(cartSession.totalItems, 2);
        expect(cartSession.subtotal, 30.0); // 10.0 + 20.0
      });

      test('notifies listeners when adding a product', () {
        var listenerCalled = false;
        cartSession.addListener(() => listenerCalled = true);
        cartSession.add(product1);
        expect(listenerCalled, isTrue);
      });

      test('calls onLimitItemsReached when adding beyond 10 unique items', () {
        for (int i = 0; i < 10; i++) {
          cartSession.add(ProductEntity(
            id: i + 100, // Ensure unique IDs not overlapping with product1, product2, etc.
            title: 'P$i',
            price: 1.0,
            description: '',
            category: '',
            image: '',
            rate: 0,
            count: 0,
          ));
        }

        var limitReached = false;
        final product11 = ProductEntity(
          id: 111, // A truly unique product
          title: 'Product 11',
          price: 1.0,
          description: '',
          category: '',
          image: '',
          rate: 0,
          count: 0,
        );
        cartSession.add(product11, onLimitItemsReached: () => limitReached = true);
        expect(limitReached, isTrue);
        expect(cartSession.items.length, 10); // Still 10 unique items in the cart
      });

      test('does not add more than 10 unique items', () {
        for (int i = 0; i < 10; i++) {
          cartSession.add(ProductEntity(
            id: i + 200, // Ensure unique IDs
            title: 'P$i',
            price: 1.0,
            description: '',
            category: '',
            image: '',
            rate: 0,
            count: 0,
          ));
        }
        // Try to add an 11th unique item
        final product11 = ProductEntity(
          id: 211, // A truly unique product
          title: 'Product 11',
          price: 1.0,
          description: '',
          category: '',
          image: '',
          rate: 0,
          count: 0,
        );
        cartSession.add(product11);
        expect(cartSession.items.length, 10);
        // Also check if the 11th product was added to the _items list or not
        expect(cartSession.items.any((item) => item.productEntity.id == product11.id), isFalse);
      });
    });

    group('decreaseQuantity', () {
      test('decrements quantity of an existing product', () {
        cartSession.add(product1); // quantity = 1
        cartSession.add(product1); // quantity = 2
        cartSession.decreaseQuantity(product1);
        expect(cartSession.items.length, 1);
        expect(cartSession.items.first.quantity, 1);
        expect(cartSession.totalItems, 1);
        expect(cartSession.subtotal, 10.0);
      });

      test('removes product from cart if quantity becomes 0', () {
        cartSession.add(product1); // quantity = 1
        cartSession.decreaseQuantity(product1);
        expect(cartSession.items, isEmpty);
        expect(cartSession.totalItems, 0);
        expect(cartSession.subtotal, 0.0);
      });

      test('notifies listeners when decreasing quantity', () {
        cartSession.add(product1);
        var listenerCalled = false;
        cartSession.addListener(() => listenerCalled = true);
        cartSession.decreaseQuantity(product1);
        expect(listenerCalled, isTrue);
      });
    });

    group('removeProducts', () {
      test('removes a product completely from the cart', () {
        cartSession.add(product1);
        cartSession.add(product2);
        cartSession.removeProducts(product1);
        expect(cartSession.items.length, 1);
        expect(cartSession.items.first.productEntity.id, product2.id);
        expect(cartSession.totalItems, 1);
        expect(cartSession.subtotal, 20.0);
      });

      test('notifies listeners when removing a product', () {
        cartSession.add(product1);
        var listenerCalled = false;
        cartSession.addListener(() => listenerCalled = true);
        cartSession.removeProducts(product1);
        expect(listenerCalled, isTrue);
      });
    });

    group('clear', () {
      test('clears all items from the cart', () {
        cartSession.add(product1);
        cartSession.add(product2);
        cartSession.clear();
        expect(cartSession.items, isEmpty);
        expect(cartSession.totalItems, 0);
        expect(cartSession.subtotal, 0.0);
      });

      test('notifies listeners when clearing the cart', () {
        cartSession.add(product1);
        var listenerCalled = false;
        cartSession.addListener(() => listenerCalled = true);
        cartSession.clear();
        expect(listenerCalled, isTrue);
      });
    });

    group('getQuantity', () {
      test('returns correct quantity for existing product', () {
        cartSession.add(product1);
        cartSession.add(product1);
        expect(cartSession.getQuantity(product1), 2);
      });

      test('returns 0 for non-existing product', () {
        expect(cartSession.getQuantity(product1), 0);
      });
    });

    group('totalItems getter', () {
      test('calculates total items correctly with multiple products and quantities', () {
        cartSession.add(product1); // Qty 1
        cartSession.add(product1); // Qty 2
        cartSession.add(product2); // Qty 1
        cartSession.add(product3); // Qty 1
        expect(cartSession.totalItems, 4);
      });
    });

    group('subtotal getter', () {
      test('calculates subtotal correctly with multiple products and quantities', () {
        cartSession.add(product1); // Price 10, Qty 1 = 10
        cartSession.add(product1); // Price 10, Qty 2 = 20
        cartSession.add(product2); // Price 20, Qty 1 = 20
        cartSession.add(product3); // Price 5, Qty 1 = 5
        expect(cartSession.subtotal, 45.0); // 20 + 20 + 5
      });
    });
  });
}
