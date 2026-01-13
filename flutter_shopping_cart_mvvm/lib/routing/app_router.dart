import 'package:flutter/material.dart';

import 'package:flutter_shopping_cart_mvvm/routing/routes.dart';
import 'package:provider/provider.dart';

import '../ui/cart/cart_screen.dart';
import '../ui/cart/cart_view_model.dart';
import '../ui/catalog/catalog_screen.dart';
import '../ui/catalog/products_view_model.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.catalog:
        return MaterialPageRoute(
          builder: (context) => ProductCatalogScreen(
            productsViewModel: context.read<ProductsViewModel>(),
          ),
          settings: settings,
        );

      case AppRoutes.cart:
        return MaterialPageRoute(
          builder: (context) => CartScreen(
            cartViewModel: context.read<CartViewModel>(),
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
