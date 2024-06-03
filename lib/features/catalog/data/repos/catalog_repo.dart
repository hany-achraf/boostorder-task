import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../cart/data/models/cart_item.dart';
import '../../../../core/common/models/product.dart';
import '../../../../core/networking/api.dart';
import '../../../../core/networking/paginated_response.dart';

class CatalogRepo {
  final Api _api;
  final HiveInterface _hive;

  const CatalogRepo(
    this._api,
    this._hive,
  );

  TaskEither<Exception, PaginatedResponse<Product>> getProducts({
    required int page,
  }) {
    TaskEither<Exception, PaginatedResponse<Product>> task =
        TaskEither.tryCatch(
      () {
        return _api.getProducts(page: page);
      },
      (e, stackTrace) {
        log(
          '*ERROR* => CatalogRepo => getProducts()',
          error: e,
          stackTrace: stackTrace,
        );
        if (e is DioException) {
          return e;
        }
        return Exception(e);
      },
    );
    return task;
  }

  TaskEither<Exception, Unit> addToCart(CartItem item) {
    TaskEither<Exception, Unit> task = TaskEither.tryCatch(
      () async {
        final box = await _hive.openBox('cart');
        await box.add(jsonEncode(item));
        return unit;
      },
      (e, stackTrace) {
        log(
          '*ERROR* => CatalogRepo => addToCart()',
          error: e,
          stackTrace: stackTrace,
        );
        if (e is DioException) {
          return e;
        }
        return Exception(e);
      },
    );
    return task;
  }

  TaskEither<Exception, int> getCartItemsCount() {
    TaskEither<Exception, int> task = TaskEither.tryCatch(
      () async {
        final box = await _hive.openBox('cart');
        return box.length;
      },
      (e, stackTrace) {
        log(
          '*ERROR* => CartRepo => getCartItemsCount()',
          error: e,
          stackTrace: stackTrace,
        );
        if (e is DioException) {
          return e;
        }
        return Exception(e);
      },
    );
    return task;
  }
}
