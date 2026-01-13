
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/product_repository_impl.dart';
import '../data/services/product_service.dart';
import '../domain/repositories/product_repository.dart';
import '../ui/catalog/products_view_model.dart';


class AppModule {
  static List<SingleChildWidget> providers = [

    Provider<IProductService>(
      create: (context) => ProductServiceImpl(),
    ),

    Provider<IProductsRepository>(
      create: (context) => ProductRepositoryImpl(
        productService: context.read(),
      ),
    ),


    Provider<ProductsViewModel>(
      create: (context) => ProductsViewModel(
        productRepository: context.read(),
      ),
      dispose: (context, value) => value.dispose(),
    ),
  ];
}
