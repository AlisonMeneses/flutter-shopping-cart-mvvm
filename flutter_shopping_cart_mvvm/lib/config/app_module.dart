
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/cart_repository_impl.dart';
import '../data/repositories/checkout_repository_impl.dart';
import '../data/repositories/product_repository_impl.dart';
import '../data/services/cart_service.dart';
import '../data/services/checkout_service.dart';
import '../data/services/product_service.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/repositories/checkout_repository.dart';
import '../domain/repositories/product_repository.dart';
import '../sessions/cart_session.dart';
import '../ui/cart/cart_view_model.dart';
import '../ui/catalog/products_view_model.dart';
import '../ui/checkout/checkout_view_model.dart';


class AppModule {
  static List<SingleChildWidget> providers = [

    ChangeNotifierProvider(
      create: (context) => CartSession(),
    ),



    Provider<IProductService>(
      create: (context) => ProductServiceImpl(),
    ),

    Provider<ICartService>(
      create: (_) => CartServiceImpl(),
    ),

    Provider<ICheckoutService>(
      create: (_) => CheckoutServiceImpl(),
    ),



    Provider<IProductsRepository>(
      create: (context) => ProductRepositoryImpl(
        productService: context.read(),
      ),
    ),

    Provider<ICartRepository>(
      create: (context) =>
          CartRepositoryImpl(cartService: context.read()),
    ),

    Provider<ICheckoutRepository>(
      create: (context) =>
          CheckoutRepositoryImpl(checkoutService: context.read()),
    ),



    Provider<ProductsViewModel>(
      create: (context) => ProductsViewModel(
        productRepository: context.read(),
        cartSession: context.read<CartSession>(),
      ),
      dispose: (context, value) => value.dispose(),
    ),

    Provider<CartViewModel>(
      create: (context) => CartViewModel(
        cartSession: context.read<CartSession>(),
        checkoutRepository: context.read<ICheckoutRepository>(),
        cartRepository: context.read<ICartRepository>(),
      ),
      dispose: (context, value) => value.dispose(),
    ),

    Provider<CheckoutViewModel>(
      create: (context) => CheckoutViewModel(
        cartSession: context.read<CartSession>(),
      ),
    ),
  ];
}
