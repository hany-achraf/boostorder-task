import 'package:freezed_annotation/freezed_annotation.dart';

part 'variation_attribute.g.dart';

@JsonSerializable(explicitToJson: true)
class VariationAttribute {
  final int id;
  final String name;
  final String option;

  VariationAttribute({
    required this.id,
    required this.name,
    required this.option,
  });

  factory VariationAttribute.fromJson(Map<String, dynamic> json) =>
      _$VariationAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$VariationAttributeToJson(this);
}