import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../cart/data/models/cart_item.dart';
import '../cart_items_count_cubit/cart_items_count_cubit.dart';
import '../../../data/repos/catalog_repo.dart';

part 'add_to_cart_state.dart';
part 'add_to_cart_cubit.freezed.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  final CatalogRepo _catalogRepo;

  AddToCartCubit(
    this._catalogRepo,
  ) : super(const AddToCartState.initial());

  void addToCart({required CartItem item}) {
    emit(const AddToCartState.loading());
    _catalogRepo.addToCart(item).run().then(
          (either) => either.fold(
            (l) {
              emit(AddToCartState.error(l));
            },
            (_) {
              sl<CartItemsCountCubit>().increment();
              emit(const AddToCartState.success());
            },
          ),
        );
  }
}
