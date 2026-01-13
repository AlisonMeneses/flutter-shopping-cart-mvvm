
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../sessions/cart_session.dart';
import '../../utils/app_error.dart';
import '../../utils/command.dart';
import '../../utils/result.dart';

class CartViewModel {
  final CartSession cartSession;
  final ICartRepository cartRepository;

  late final Command1<ProductEntity, ProductEntity, AppError> removeProductCmd;

  ProductEntity? productToRemove;

  CartViewModel({
    required this.cartSession,
    required this.cartRepository,
  }) {
    removeProductCmd = Command1<ProductEntity, ProductEntity, AppError>(_removeProduct);
  }

  AsyncResult<ProductEntity, AppError> _removeProduct(ProductEntity productEntity) async {
    productToRemove = productEntity;

    return  await cartRepository.remove(productEntity: productEntity);
  }

  void dispose() {
    removeProductCmd.dispose();
  }
}
