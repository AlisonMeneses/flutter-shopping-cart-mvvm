import 'package:flutter_shopping_cart_mvvm/data/repositories/cart_repository_impl.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/cart_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartService extends Mock implements ICartService {}

void main() {
  late CartRepositoryImpl cartRepository;
  late MockCartService mockCartService;

  setUp(() {
    mockCartService = MockCartService();
    cartRepository = CartRepositoryImpl(cartService: mockCartService);
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

  group('CartRepositoryImpl', () {
    test('remove calls cart service and returns its result', () async {
      // Arrange
      final failureResult = Failure<ProductEntity, AppError>(
        AppError(message: 'Could not remove item from cart', type: AppErrorType.server),
      );
      when(() => mockCartService.remove(productEntity: productEntity)).thenAnswer((_) async => failureResult);

      // Act
      final result = await cartRepository.remove(productEntity: productEntity);

      // Assert
      expect(result, failureResult);
      verify(() => mockCartService.remove(productEntity: productEntity)).called(1);
    });

    test('remove propagates failures from the service', () async {
      // Arrange
      final failure = Failure<ProductEntity, AppError>(AppError(message: 'Error', type: AppErrorType.server));
      when(() => mockCartService.remove(productEntity: productEntity)).thenAnswer((_) async => failure);

      // Act
      final result = await cartRepository.remove(productEntity: productEntity);

      // Assert
      expect(result, isA<Failure>());
      expect((result as Failure<ProductEntity, AppError>).error.message, 'Error');
    });
  });
}
