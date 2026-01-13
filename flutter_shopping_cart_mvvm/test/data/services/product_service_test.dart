import 'package:dio/dio.dart';
import 'package:flutter_shopping_cart_mvvm/data/models/product_model.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/product_service.dart';
import 'package:flutter_shopping_cart_mvvm/utils/app_error.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ProductServiceImpl productService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    productService = ProductServiceImpl(dio: mockDio);
  });
  const productsUrl = 'https://fakestoreapi.com/products';

  final productMap = {
    'id': 1,
    'title': 'Product 1',
    'price': 10.0,
    'description': 'Description 1',
    'category': 'Category 1',
    'image': 'Image 1',
    'rating': {'rate': 4.5, 'count': 100},
  };

  final productListMap = [productMap];

  group('ProductServiceImpl', () {
    test(
      'getProducts returns Success with a list of products on 200 response',
      () async {
        // Arrange
        when(() => mockDio.get(productsUrl)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: productsUrl),
            data: productListMap,
            statusCode: 200,
          ),
        );

        // Act
        final result = await productService.getProducts();

        // Assert
        expect(result, isA<Success>());
        final products = (result as Success<List<ProductModel>, AppError>).value;
        expect(products, isA<List<ProductModel>>());
        expect(products.length, 1);
        expect(products.first.id, 1);
      },
    );

    test(
      'getProducts returns Failure on 200 response with malformed data',
      () async {
        // Arrange
        when(() => mockDio.get(productsUrl)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: productsUrl),
            data: {'products': 'not a list'}, // Malformed data
            statusCode: 200,
          ),
        );

        // Act
        final result = await productService.getProducts();

        // Assert
        expect(result, isA<Failure>());
        final error = (result as Failure<List<ProductModel>, AppError>).error;
        expect(error.type, AppErrorType.local);
        expect(error.message, 'Error parsing products');
      },
    );

    test('getProducts returns Failure on non-200 response', () async {
      // Arrange
      when(() => mockDio.get(productsUrl)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: productsUrl),
          statusCode: 404,
        ),
      );

      // Act
      final result = await productService.getProducts();

      // Assert
      expect(result, isA<Failure>());
      final error = (result as Failure<List<ProductModel>, AppError>).error;
      expect(error.type, AppErrorType.server);
      expect(error.message, 'Unexpected status code: 404');
    });

    test('getProducts returns Failure on DioException', () async {
      // Arrange
      when(() => mockDio.get(productsUrl)).thenThrow(
        DioException(requestOptions: RequestOptions(path: productsUrl)),
      );

      // Act
      final result = await productService.getProducts();

      // Assert
      expect(result, isA<Failure>());
      final error = (result as Failure<List<ProductModel>, AppError>).error;
      expect(error.type, AppErrorType.server);
      expect(error.message, 'Error getting products');
    });

    test('getProducts returns Failure on unexpected exception', () async {
      // Arrange
      when(() => mockDio.get(productsUrl)).thenThrow(Exception('Unexpected'));

      // Act
      final result = await productService.getProducts();

      // Assert
      expect(result, isA<Failure>());
      final error = (result as Failure<List<ProductModel>, AppError>).error;
      expect(error.type, AppErrorType.unknown);
      expect(error.message, 'Unexpected error: Exception: Unexpected');
    });
  });
}
