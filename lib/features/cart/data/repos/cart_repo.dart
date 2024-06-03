import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../models/cart_item.dart';

class CartRepo {
  final HiveInterface _hive;

  const CartRepo(this._hive);

  TaskEither<Exception, List<CartItem>> getCartItems() {
    TaskEither<Exception, List<CartItem>> task = TaskEither.tryCatch(
      () async {
        // await Future.delayed(const Duration(seconds: 2));
        // throw UnimplementedError();
        final box = await _hive.openBox('cart');
        final List<CartItem> items = [];
        for (var i = 0; i < box.length; i++) {
          final item = CartItem.fromJson(jsonDecode(box.getAt(i)));
          items.add(item);
        }
        return items;
      },
      (e, stackTrace) {
        log(
          '*ERROR* => CartRepo => getCartItems()',
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

  TaskEither<Exception, Unit> removeCartItem(int index) {
    TaskEither<Exception, Unit> task = TaskEither.tryCatch(
      () async {
        final box = await _hive.openBox('cart');
        await box.deleteAt(index);
        return unit;
      },
      (e, stackTrace) {
        log(
          '*ERROR* => CartRepo => deleteCartItem()',
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
