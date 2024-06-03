// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
        Map<String, dynamic> json) =>
    PaginatedResponse<T>(
      total: (json['total'] as num).toInt(),
      currentPage: (json['current_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => ModelConverter<T>().fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$PaginatedResponseToJson<T>(
        PaginatedResponse<T> instance) =>
    <String, dynamic>{
      'total': instance.total,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.data.map(ModelConverter<T>().toJson).toList(),
    };
