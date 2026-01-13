import '../../utils/app_error.dart';
import '../../utils/result.dart';
import '../entities/product_entity.dart';

abstract class IProductsRepository {
  AsyncResult<List<ProductEntity>, AppError> getProducts();
}
