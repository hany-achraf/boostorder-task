import 'dart:convert';

import 'package:dio/dio.dart';

class AuthTokenInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['Authorization'] =
        'Basic ${base64Encode(utf8.encode('ck_2682b35c4d9a8b6b6effac126ac552e0bfb315a0:cs_cab8c9a729dfb49c50ce801a9ea41b577c00ad71'))}';
    handler.next(options);
  }
}
