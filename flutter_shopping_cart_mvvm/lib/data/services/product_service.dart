import 'package:dio/dio.dart';

import '../../utils/app_error.dart';
import '../../utils/result.dart';
import '../models/product_model.dart';

abstract class IProductService {
  AsyncResult<List<ProductModel>, AppError> getProducts();
}

class ProductServiceImpl extends IProductService {
  final Dio dio;

  ProductServiceImpl({required this.dio});

  @override
  Future<Result<List<ProductModel>, AppError>> getProducts() async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products');

      if (response.statusCode == 200) {
        try {
          final products = (response.data as List)
              .map((product) => ProductModel.fromMap(product))
              .toList();

          return Success(products);
        } catch (e) {
          return Failure(
            AppError(
              message: 'Error parsing products',
              type: AppErrorType.local,
            ),
          );
        }
      } else {
        return Failure(
          AppError(
            message: 'Unexpected status code: ${response.statusCode}',
            type: AppErrorType.server,
          ),
        );
      }
    } on DioException catch (e) {
      return Failure(
        AppError(
          message: 'Error getting products',
          type: AppErrorType.server,
        ),
      );
    } catch (e) {
      return Failure(
        AppError(message: 'Unexpected error: $e', type: AppErrorType.unknown),
      );
    }
  }
}
