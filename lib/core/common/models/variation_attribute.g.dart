// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variation_attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VariationAttribute _$VariationAttributeFromJson(Map<String, dynamic> json) =>
    VariationAttribute(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      option: json['option'] as String,
    );

Map<String, dynamic> _$VariationAttributeToJson(VariationAttribute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'option': instance.option,
    };
