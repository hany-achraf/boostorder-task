import 'package:freezed_annotation/freezed_annotation.dart';

import 'variation_attribute.dart';

part 'variation.g.dart';

@JsonSerializable(explicitToJson: true)
class Variation {
  final int id;

  final String sku;

  @JsonKey(name: 'regular_price', readValue: getRegularPriceAsDouble)
  final double regularPrice;

  @JsonKey(name: 'sale_price', readValue: getSalePriceAsDouble)
  final double? salePrice;

  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;

  @JsonKey(name: 'total_inventory_stock', readValue: getTotalInventoryStock)
  final int totalInventoryStock;

  final List<VariationAttribute>? attributes;

  Variation({
    required this.id,
    required this.sku,
    required this.regularPrice,
    required this.salePrice,
    required this.stockQuantity,
    required this.totalInventoryStock,
    required this.attributes,
  });

  factory Variation.fromJson(Map<String, dynamic> json) =>
      _$VariationFromJson(json);

  Map<String, dynamic> toJson() => _$VariationToJson(this);

  static double getRegularPriceAsDouble(
          Map<dynamic, dynamic> json, String key) =>
      json['regular_price'] is num
          ? json['regular_price']
          : double.tryParse(json['regular_price']) ?? 0;

  static double? getSalePriceAsDouble(Map<dynamic, dynamic> json, String key) =>
      json['sale_price'] == null || json['sale_price'] is num
          ? json['sale_price']
          : double.tryParse(json['sale_price']);

  static int getTotalInventoryStock(Map<dynamic, dynamic> json, String key) {
    if (json['total_inventory_stock'] != null) {
      return json['total_inventory_stock'];
    }
    int total = 0;
    if (json['inventory'].isNotEmpty) {
      total = json['inventory']
          .map((branch) => branch['stock_quantity'])
          .reduce((value, element) => value + element);
    }
    return total;
  }
}
