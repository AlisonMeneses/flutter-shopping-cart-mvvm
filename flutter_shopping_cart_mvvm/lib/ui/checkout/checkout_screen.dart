import 'package:flutter/material.dart';

import '../../routing/routes.dart';
import '../widgets/summary_widget.dart';
import 'checkout_view_model.dart';

class CheckoutScreen extends StatelessWidget {
  final CheckoutViewModel checkoutViewModel;

  const CheckoutScreen({
    required this.checkoutViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Successful')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: checkoutViewModel.cartSession.items.length,
              itemBuilder: (context, index) {
                final item = checkoutViewModel.cartSession.items[index];
                return ListTile(
                  leading: Image.network(item.productEntity.image),
                  title: Text(item.productEntity.title),
                  subtitle: Text('\$${item.productEntity.price}'),
                  trailing: Text('x${item.quantity}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SummaryWidget(subtotal: checkoutViewModel.cartSession.subtotal),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          checkoutViewModel.cartSession.clear();
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.catalog, (route) => false);
        },
        child: const Text('New Order'),
      ),
    );
  }
}
