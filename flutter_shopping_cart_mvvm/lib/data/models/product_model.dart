
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {

  ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rate,
    required super.count,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      rate: map['rating']?['rate']?.toDouble() ?? 0.0,
      count: map['rating']?['count']?.toInt() ?? 0,
    );
  }
}