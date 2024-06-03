// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      sku: Product.getSku(json, 'sku') as String?,
      imageUrl: Product.getImageUrl(json, 'image_url') as String?,
      regularPrice:
          (Product.getRegularPrice(json, 'regular_price') as num?)?.toDouble(),
      salePrice: (Product.getSalePrice(json, 'sale_price') as num?)?.toDouble(),
      stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
      attributes: (json['attributes'] as List<dynamic>)
          .map((e) => Attribute.fromJson(e as Map<String, dynamic>))
          .toList(),
      variations: (json['variations'] as List<dynamic>)
          .map((e) => Variation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'image_url': instance.imageUrl,
      'regular_price': instance.regularPrice,
      'sale_price': instance.salePrice,
      'stock_quantity': instance.stockQuantity,
      'attributes': instance.attributes.map((e) => e.toJson()).toList(),
      'variations': instance.variations.map((e) => e.toJson()).toList(),
    };
