
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../../sessions/cart_session.dart';
import '../../utils/app_error.dart';
import '../../utils/command.dart';
import '../../utils/result.dart';

class CartViewModel {
  final CartSession cartSession;
  final ICheckoutRepository checkoutRepository;
  final ICartRepository cartRepository;

  late final Command0<Unit, AppError> checkoutProductsCmd;
  late final Command1<ProductEntity, ProductEntity, AppError> removeProductCmd;

  ProductEntity? productToRemove;

  CartViewModel({
    required this.cartSession,
    required this.checkoutRepository,
    required this.cartRepository,
  }) {
    checkoutProductsCmd = Command0<Unit, AppError>(_checkoutProducts);
    removeProductCmd = Command1<ProductEntity, ProductEntity, AppError>(_removeProduct);
  }

  AsyncResult<Unit, AppError> _checkoutProducts() async {
    return await checkoutRepository.checkout();
  }

  AsyncResult<ProductEntity, AppError> _removeProduct(ProductEntity productEntity) async {
    productToRemove = productEntity;

    return  await cartRepository.remove(productEntity: productEntity);
  }

  void dispose() {
    checkoutProductsCmd.dispose();
    removeProductCmd.dispose();
  }
}
