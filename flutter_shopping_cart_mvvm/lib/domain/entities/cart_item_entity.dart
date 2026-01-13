import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';

class CartItemEntity {
  final ProductEntity productEntity;
  int quantity;

  CartItemEntity({required this.productEntity, this.quantity = 1});

  double get subtotal => productEntity.price * quantity;
}
