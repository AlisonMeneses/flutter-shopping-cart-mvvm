
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../utils/app_error.dart';
import '../../utils/result.dart';
import '../services/product_service.dart';

class ProductRepositoryImpl implements IProductsRepository {
  final IProductService productService;

  ProductRepositoryImpl({required this.productService});

  @override
  AsyncResult<List<ProductEntity>, AppError> getProducts() {
    return productService.getProducts();
  }
}
