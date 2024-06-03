import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/catalog/ui/cubits/cart_items_count_cubit/cart_items_count_cubit.dart';
import '../../features/catalog/data/repos/catalog_repo.dart';
import '../../features/catalog/ui/cubits/add_to_cart_cubit/add_to_cart_cubit.dart';
import '../../features/cart/data/repos/cart_repo.dart';
import '../../features/cart/ui/cubits/remove_cart_item_cubit/remove_cart_item_cubit.dart';
import '../networking/api.dart';
import '../networking/dio_builder.dart';
import '../networking/interceptors/no_cache_interceptor.dart';
import '../routing/app_router.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Routing
  sl.registerSingleton(AppRouter());

  // Network / Dio
  sl.registerSingletonAsync<Dio>(() async {
    DioBuilder builder = DioBuilder();
    Dio instance = builder
        .addAuthTokenInterceptor()
        .addPrettyDioLoggerInterceptor()
        .addHeaderPaginatedResponseInterceptor()
        .withConnectTimeout(5000)
        .withReceiveTimeout(5000)
        .build();

    final dir = await getTemporaryDirectory();

    final cacheOptions = CacheOptions(
      store: HiveCacheStore(dir.path),
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // maxStale: const Duration(days: 7),
      hitCacheOnErrorExcept: [401, 403], // for offline behaviour
    );

    instance.options.extra.addAll(cacheOptions.toExtra());

    instance.interceptors.addAll([
      DioCacheInterceptor(options: cacheOptions),
      NoCacheInterceptor(),
    ]);

    return instance;
  });

  // Register the API Service
  sl.registerSingletonWithDependencies(() => Api(sl()), dependsOn: [Dio]);

  // Hive
  sl.registerLazySingleton<HiveInterface>(() => Hive);

  // Repos
  sl.registerFactory(() => CatalogRepo(sl(), sl()));
  sl.registerFactory(() => CartRepo(sl()));

  // Cubits
  sl.registerLazySingleton(() => CartItemsCountCubit(sl()));
  sl.registerFactory(() => AddToCartCubit(sl()));
  sl.registerFactory(() => RemoveCartItemCubit(sl()));

  await sl.allReady();
}
