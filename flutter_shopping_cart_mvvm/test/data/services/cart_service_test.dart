import 'package:flutter_shopping_cart_mvvm/data/services/cart_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CartServiceImpl cartService;

  setUp(() {
    cartService = CartServiceImpl();
  });

  final productEntity = ProductEntity(
    id: 1,
    title: 'Product 1',
    price: 10.0,
    description: 'Description 1',
    category: 'Category 1',
    image: 'Image 1',
    rate: 4.5,
    count: 100,
  );

  group('CartServiceImpl', () {
    test('remove always returns a Failure', () async {
      // Act
      final result = await cartService.remove(productEntity: productEntity);

      // Assert
      expect(result, isA<Failure>());
      final error = (result as Failure<ProductEntity, AppError>).error;
      expect(error.message, 'Could not remove item from cart (Simulated error)');
      expect(error.type, AppErrorType.server);
    });
  });
}
