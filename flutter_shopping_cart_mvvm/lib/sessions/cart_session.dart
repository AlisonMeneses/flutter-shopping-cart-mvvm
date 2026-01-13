import 'package:flutter/widgets.dart';

import '../domain/entities/cart_item_entity.dart';
import '../domain/entities/product_entity.dart';


class CartSession extends ChangeNotifier {
  final List<CartItemEntity> _items = [];

  List<CartItemEntity> get items => _items;

  int get totalItems => _items.fold(0, (total, item) => total + item.quantity);

  double get subtotal => _items.fold(0, (total, item) => total + item.subtotal);

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int getQuantity(ProductEntity productEntity) {
    return _items
        .firstWhere(
          (item) => item.productEntity.id == productEntity.id,
      orElse: () => CartItemEntity(productEntity: productEntity, quantity: 0),
    )
        .quantity;
  }

  void decreaseQuantity(ProductEntity product) {
    final existingItem = _items.firstWhere(
          (item) => item.productEntity.id == product.id,
    );

    existingItem.quantity--;

    if (existingItem.quantity == 0) {
      _items.remove(existingItem);
    }

    notifyListeners();
  }

  void add(ProductEntity productEntity, {VoidCallback? onLimitItemsReached}) {
    final existingItem = _items.firstWhere(
          (item) => item.productEntity.id == productEntity.id,
      orElse: () => CartItemEntity(productEntity: productEntity, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      if (_items.length < 10) {
        _items.add(existingItem);
      } else {
        onLimitItemsReached?.call();

        return;
      }
    }

    existingItem.quantity++;

    notifyListeners();
  }

  void removeProducts (ProductEntity product){
    final existingItem = _items.firstWhere(
          (item) => item.productEntity.id == product.id,
    );

    _items.remove(existingItem);

    notifyListeners();
  }
}