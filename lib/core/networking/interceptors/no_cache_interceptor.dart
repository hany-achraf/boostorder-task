import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class NoCacheInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (options.extra.containsKey('no-cache') &&
        options.extra['no-cache'] == true) {
      final cacheOptions = CacheOptions.fromExtra(options);
      options.extra.addAll(
        cacheOptions!.copyWith(policy: CachePolicy.noCache).toExtra(),
      );
    }
    return handler.next(options);
  }
}
