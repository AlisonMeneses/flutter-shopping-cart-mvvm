import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../sessions/cart_session.dart';
import '../../utils/app_error.dart';
import '../../utils/command.dart';
import '../../utils/result.dart';

class ProductsViewModel {
  final CartSession cartSession;
  final IProductsRepository productRepository;

  late final Command0<List<ProductEntity>, AppError> fetchProductsCmd;

  ProductsViewModel({
    required  this.productRepository,
    required this.cartSession,
  }) {
    fetchProductsCmd = Command0<List<ProductEntity>, AppError>(_getProducts);
  }

  AsyncResult<List<ProductEntity>, AppError> _getProducts() async {
    return productRepository.getProducts();
  }

  void dispose() {
    fetchProductsCmd.dispose();
  }
}
