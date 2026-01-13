import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/ui/catalog/products_view_model.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/product_entity.dart';
import '../../routing/routes.dart';
import '../../sessions/cart_session.dart';
import '../../utils/app_error.dart';
import '../../utils/command.dart';

class ProductCatalogScreen extends StatefulWidget {
  final ProductsViewModel productsViewModel;

  const ProductCatalogScreen({
    required this.productsViewModel,
    super.key,
  });

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.productsViewModel.fetchProductsCmd.execute();
    });
    super.initState();
  }

  void _productLimitToast (){
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text('You have reached the maximum number of items in your cart.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.productsViewModel.fetchProductsCmd.state,
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Catalog'),
            actions: [
              _buildCartIcon(context),
            ],
          ),
          body: switch (state) {
            IdleCommand() => const SizedBox.shrink(),
            RunningCommand() => const Center(child: CircularProgressIndicator()),
            SuccessCommand<List<ProductEntity>, AppError> successCommand => _buildProductList(successCommand.value),
            FailureCommand<List<ProductEntity>, AppError>() => Center(child: Text(state.error.message)),
          },
        );
      },
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return Consumer<CartSession>(
      builder: (context, cartSession, _) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
            ),
            if (cartSession.totalItems > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${cartSession.totalItems}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProductList(List<ProductEntity> products) {
    return Consumer<CartSession>(builder: (context, cartSession, _) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final quantity = cartSession.getQuantity(product);

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (quantity == 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        cartSession.add(
                          product,
                          onLimitItemsReached: _productLimitToast,
                        );
                      },
                      child: const Text('Add to Cart'),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            widget.productsViewModel.cartSession.decreaseQuantity(product);
                          },
                        ),
                        Text('$quantity'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cartSession.add(
                              product,
                              onLimitItemsReached: _productLimitToast,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }
}
