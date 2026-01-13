import '../../domain/entities/product_entity.dart';
import '../../utils/app_error.dart';
import '../../utils/result.dart';

abstract class ICartService {
  AsyncResult<ProductEntity, AppError> remove({required ProductEntity productEntity});
}

class CartServiceImpl implements ICartService {
  @override
  AsyncResult<ProductEntity, AppError> remove({required ProductEntity productEntity}) async {
    await Future.delayed(const Duration(seconds: 1));

    //return Success(productEntity);

    // Simulate an error
    return Failure(
      AppError(
        message: 'Could not remove item from cart (Simulated error)',
        type: AppErrorType.server,
      ),
    );
  }
}
