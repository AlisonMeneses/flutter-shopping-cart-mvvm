import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/product_entity.dart';
import '../../routing/routes.dart';
import '../../sessions/cart_session.dart';
import '../../utils/app_error.dart';
import '../../utils/command.dart';
import '../widgets/summary_widget.dart';
import 'cart_view_model.dart';

class CartScreen extends StatefulWidget {
  final CartViewModel cartViewModel;

  const CartScreen({required this.cartViewModel, super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    _setupCheckoutProductsCommandListeners();
    _setupRemoveProductsCommandListeners();
    super.initState();
  }

  void _setupCheckoutProductsCommandListeners() {
    widget.cartViewModel.checkoutProductsCmd.onSuccess((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.checkout, (route) => false);
      });
    });

    widget.cartViewModel.checkoutProductsCmd.onError((appError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(appError.message)));
      });
    });
  }

  void _setupRemoveProductsCommandListeners() {
    widget.cartViewModel.removeProductCmd.onError((appError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(appError.message)));
      });
    });

    widget.cartViewModel.removeProductCmd.onSuccess((productEntity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        widget.cartViewModel.cartSession.removeProducts(productEntity);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${productEntity.title} removed from cart')),
        );
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<CartSession>(
      builder: (context, cartSession, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Cart')),
          body: _buildBody(context, widget.cartViewModel),
          bottomNavigationBar: _buildBottomBar(context, widget.cartViewModel),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CartViewModel viewModel) {
    if (viewModel.cartSession.items.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    return ListView.builder(
      itemCount: viewModel.cartSession.items.length,
      itemBuilder: (context, index) {
        final item = viewModel.cartSession.items[index];
        return ListTile(
          leading: Image.network(item.productEntity.image),
          title: Text(item.productEntity.title),
          subtitle: Text('\$${item.productEntity.price}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  viewModel.cartSession.decreaseQuantity(item.productEntity);
                },
              ),
              Text('${item.quantity}'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  viewModel.cartSession.add(item.productEntity);
                },
              ),

              ValueListenableBuilder(
                valueListenable: widget.cartViewModel.removeProductCmd.state,
                builder: (context, state, child) {
                  return switch (state) {
                    IdleCommand() => _removeButton(item.productEntity),
                    RunningCommand() => _removeLoading(
                      productEntity: item.productEntity,
                      productIdToRemove: viewModel.productToRemove?.id,
                    ),
                    SuccessCommand() => _removeButton(item.productEntity),
                    FailureCommand() => _removeButton(item.productEntity),
                  };
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _removeButton(ProductEntity productEntity) {
    return IconButton(
      icon: const Icon(Icons.delete, size: 20),
      onPressed: () {
        widget.cartViewModel.removeProductCmd.execute(productEntity);
      },
    );
  }

  Widget _removeLoading({
    required ProductEntity productEntity,
    int? productIdToRemove,
  }) {
    if (productEntity.id == productIdToRemove) {
      return Container(
        width: 45,
        height: 45,
        padding: EdgeInsets.all(10),
        child: const CircularProgressIndicator(),
      );
    }

    return _removeButton(productEntity);
  }

  Widget _buildBottomBar(BuildContext context, CartViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SummaryWidget(subtotal: viewModel.cartSession.subtotal),
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: widget.cartViewModel.checkoutProductsCmd.state,
            builder: (context, state, child) {
              return switch (state) {
                IdleCommand() => _checkoutButton(),
                RunningCommand() => const Center(child: CircularProgressIndicator()),
                SuccessCommand<Unit, AppError>() => _checkoutButton(),
                FailureCommand<Unit, AppError>() => _checkoutButton(),
              };
            },
          ),
        ],
      ),
    );
  }

  Widget _checkoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.cartViewModel.cartSession.items.isEmpty
            ? null
            : () => widget.cartViewModel.checkoutProductsCmd.execute(),
        child: const Text('Checkout'),
      ),
    );
  }

}
