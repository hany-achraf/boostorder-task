import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repos/catalog_repo.dart';

class CartItemsCountCubit extends Cubit<int> {
  final CatalogRepo _catalogRepo;

  CartItemsCountCubit(
    this._catalogRepo,
  ) : super(0) {
    _getCartItemsCount();
  }

  void _getCartItemsCount() {
    _catalogRepo.getCartItemsCount().run().then(
          (value) => value.fold(
            (l) => emit(0),
            (r) => emit(r),
          ),
        );
  }

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);
}
