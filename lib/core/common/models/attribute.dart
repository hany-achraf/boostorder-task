import 'package:freezed_annotation/freezed_annotation.dart';

part 'attribute.g.dart';

@JsonSerializable(explicitToJson: true)
class Attribute {
  final int id;
  final String name;
  final int position;
  final bool visible;
  final bool variation;
  final List<String> options;

  Attribute({
    required this.id,
    required this.name,
    required this.position,
    required this.visible,
    required this.variation,
    required this.options,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => _$AttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeToJson(this);
}