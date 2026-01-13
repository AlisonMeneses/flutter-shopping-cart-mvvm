import 'package:flutter_shopping_cart_mvvm/data/models/product_model.dart';
import 'package:flutter_shopping_cart_mvvm/data/repositories/product_repository_impl.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/product_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductService extends Mock implements IProductService {}

void main() {
  late ProductRepositoryImpl productRepository;
  late MockProductService mockProductService;

  setUp(() {
    mockProductService = MockProductService();
    productRepository = ProductRepositoryImpl(productService: mockProductService);
  });

  final productModel = ProductModel(
    id: 1,
    title: 'Product 1',
    price: 10.0,
    description: 'Description 1',
    category: 'Category 1',
    image: 'Image 1',
    rate: 4.5,
    count: 100,
  );

  final List<ProductModel> productList = [productModel];
  final successResult = Success<List<ProductModel>, AppError>(productList);

  group('ProductRepositoryImpl', () {
    test('getProducts calls product service and returns its result', () async {
      // Arrange
      when(() => mockProductService.getProducts()).thenAnswer((_) async => successResult);

      // Act
      final result = await productRepository.getProducts();

      // Assert
      expect(result, successResult);
      verify(() => mockProductService.getProducts()).called(1);
    });

    test('getProducts propagates failures from the service', () async {
      // Arrange
      final failure = Failure<List<ProductModel>, AppError>(AppError(message: 'Error', type: AppErrorType.server));
      when(() => mockProductService.getProducts()).thenAnswer((_) async => failure);

      // Act
      final result = await productRepository.getProducts();

      // Assert
      expect(result, isA<Failure>());
      expect((result as Failure<List<ProductEntity>, AppError>).error.message, 'Error');    });
  });
}
