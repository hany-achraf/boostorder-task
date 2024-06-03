import 'package:freezed_annotation/freezed_annotation.dart';

import 'attribute.dart';
import 'variation.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  final int id;

  final String name;

  @JsonKey(readValue: getSku)
  final String? sku;

  @JsonKey(name: 'image_url', readValue: getImageUrl)
  final String? imageUrl;

  @JsonKey(name: 'regular_price', readValue: getRegularPrice)
  final double? regularPrice;

  @JsonKey(name: 'sale_price', readValue: getSalePrice)
  final double? salePrice;

  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;

  final List<Attribute> attributes;

  final List<Variation> variations;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.imageUrl,
    required this.regularPrice,
    required this.salePrice,
    required this.stockQuantity,
    required this.attributes,
    required this.variations,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  static String? getSku(Map<dynamic, dynamic> json, String key) =>
      json['sku'] == '' ? null : json['sku'];

  static String? getImageUrl(Map<dynamic, dynamic> json, String key) =>
      json['image_url'] ?? json['images']?[0]['src'];

  static double? getRegularPrice(Map<dynamic, dynamic> json, String key) {
    if (json['regular_price'] == null || json['regular_price'] == '') {
      return null;
    }
    if (json['regular_price'] is num) {
      return json['regular_price'].toDouble();
    }
    return double.tryParse(json['regular_price']);
  }

  static double? getSalePrice(Map<dynamic, dynamic> json, String key) =>
      json['sale_price'] == null ? null : double.tryParse(json['sale_price']);
}
