import 'package:dio/dio.dart';

class HeaderPaginatedResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final totalItems = int.parse(response.headers.map['X-WP-Total']!.first);
    final totalPages =
        int.parse(response.headers.map['X-WP-TotalPages']!.first);
    final data = response.data;
    final paginatedResponse = {
      "total": totalItems,
      "current_page": response.requestOptions.queryParameters['page'],
      "last_page": totalPages,
      "data": data,
    };
    response.data = paginatedResponse;
    handler.next(response);
  }
}
