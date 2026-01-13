import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/product_repository.dart';
import 'package:flutter_shopping_cart_mvvm/sessions/cart_session.dart';
import 'package:flutter_shopping_cart_mvvm/ui/catalog/products_view_model.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepository extends Mock implements IProductsRepository {}
class MockCartSession extends Mock implements CartSession {}
class MockProductEntity extends Mock implements ProductEntity {}

void main() {
  group('ProductsViewModel', () {
    late ProductsViewModel productsViewModel;
    late MockProductsRepository mockProductsRepository;
    late MockCartSession mockCartSession;

    setUp(() {
      mockProductsRepository = MockProductsRepository();
      mockCartSession = MockCartSession();

      productsViewModel = ProductsViewModel(
        productRepository: mockProductsRepository,
        cartSession: mockCartSession,
      );
    });

    tearDown(() {
      productsViewModel.dispose();
    });

    test('fetchProductsCmd calls productRepository.getProducts and propagates result', () async {
      // Arrange
      final productList = <ProductEntity>[MockProductEntity()];
      when(() => mockProductsRepository.getProducts()).thenAnswer((_) async => Success(productList));

      // Act
      await productsViewModel.fetchProductsCmd.execute();

      // Assert
      verify(() => mockProductsRepository.getProducts()).called(1);
      expect(productsViewModel.fetchProductsCmd.state.value, isA<SuccessCommand<List<ProductEntity>, AppError>>());
      expect((productsViewModel.fetchProductsCmd.state.value as SuccessCommand<List<ProductEntity>, AppError>).value, productList);
    });

    test('fetchProductsCmd propagates failures from productRepository.getProducts', () async {
      // Arrange
      final failure = Failure<List<ProductEntity>, AppError>(AppError(message: 'Error', type: AppErrorType.server));
      when(() => mockProductsRepository.getProducts()).thenAnswer((_) async => failure);

      // Act
      await productsViewModel.fetchProductsCmd.execute();

      // Assert
      verify(() => mockProductsRepository.getProducts()).called(1);
      expect(productsViewModel.fetchProductsCmd.state.value, isA<FailureCommand<List<ProductEntity>, AppError>>());
      expect((productsViewModel.fetchProductsCmd.state.value as FailureCommand<List<ProductEntity>, AppError>).error.message, 'Error');
    });

  });
}