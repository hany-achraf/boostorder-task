// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Variation _$VariationFromJson(Map<String, dynamic> json) => Variation(
      id: (json['id'] as num).toInt(),
      sku: json['sku'] as String,
      regularPrice:
          (Variation.getRegularPriceAsDouble(json, 'regular_price') as num)
              .toDouble(),
      salePrice: (Variation.getSalePriceAsDouble(json, 'sale_price') as num?)
          ?.toDouble(),
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      totalInventoryStock:
          (Variation.getTotalInventoryStock(json, 'total_inventory_stock')
                  as num)
              .toInt(),
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((e) => VariationAttribute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VariationToJson(Variation instance) => <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'regular_price': instance.regularPrice,
      'sale_price': instance.salePrice,
      'stock_quantity': instance.stockQuantity,
      'total_inventory_stock': instance.totalInventoryStock,
      'attributes': instance.attributes?.map((e) => e.toJson()).toList(),
    };
