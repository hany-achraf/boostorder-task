import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'interceptors/auth_token_interceptor.dart';
import 'interceptors/header_paginated_response_interceptor.dart';

class DioBuilder {
  final BaseOptions _baseOptions;
  final List<Interceptor> _interceptors = [];
  Duration _connectTimeout = const Duration(seconds: 60);
  Duration _receiveTimeout = const Duration(seconds: 60);

  DioBuilder()
      : _baseOptions = BaseOptions(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        );

  DioBuilder addPrettyDioLoggerInterceptor() {
    _interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
    return this;
  }

  DioBuilder addAuthTokenInterceptor() {
    _interceptors.add(AuthTokenInterceptor());
    return this;
  }

  DioBuilder addHeaderPaginatedResponseInterceptor() {
    _interceptors.add(HeaderPaginatedResponseInterceptor());
    return this;
  }

  DioBuilder withConnectTimeout(int milliseconds) {
    _connectTimeout = Duration(seconds: milliseconds);
    return this;
  }

  DioBuilder withReceiveTimeout(int milliseconds) {
    _receiveTimeout = Duration(seconds: milliseconds);
    return this;
  }

  Dio build() {
    Dio dio = Dio(_baseOptions)
      ..options.connectTimeout = _connectTimeout
      ..options.receiveTimeout = _receiveTimeout;

    for (Interceptor interceptor in _interceptors) {
      dio.interceptors.add(interceptor);
    }

    return dio;
  }
}
