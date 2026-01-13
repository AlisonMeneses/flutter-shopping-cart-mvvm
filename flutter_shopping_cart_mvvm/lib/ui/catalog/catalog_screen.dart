import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/ui/catalog/products_view_model.dart';

import '../../domain/entities/product_entity.dart';
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.productsViewModel.fetchProductsCmd.state,
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Catalog'),
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

  Widget _buildProductList(List<ProductEntity> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

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
            ],
          ),
        );
      },
    );
  }
}
