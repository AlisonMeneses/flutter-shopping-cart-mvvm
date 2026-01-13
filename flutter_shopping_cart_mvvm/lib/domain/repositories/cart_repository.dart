import '../../domain/entities/product_entity.dart';
import '../../utils/app_error.dart';
import '../../utils/result.dart';

abstract class ICartRepository {
  AsyncResult<ProductEntity, AppError> remove({required ProductEntity productEntity});
}

