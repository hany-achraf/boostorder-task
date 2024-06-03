import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/models/product.dart';

part 'cart_item.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItem {
  final Product product;
  final int? variationId;
  int quantity;

  CartItem({
    required this.product,
    this.variationId,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
