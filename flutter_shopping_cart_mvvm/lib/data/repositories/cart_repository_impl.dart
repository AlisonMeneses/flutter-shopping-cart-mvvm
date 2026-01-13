import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../utils/app_error.dart';
import '../../utils/result.dart';
import '../services/cart_service.dart';

class CartRepositoryImpl implements ICartRepository {
  final ICartService cartService;

  CartRepositoryImpl({required this.cartService});

  @override
  AsyncResult<ProductEntity, AppError> remove({required ProductEntity productEntity}) async {
    return await cartService.remove(productEntity: productEntity);
  }
}
