import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../data/repos/cart_repo.dart';
import '../../../../catalog/ui/cubits/cart_items_count_cubit/cart_items_count_cubit.dart';

part 'remove_cart_item_state.dart';
part 'remove_cart_item_cubit.freezed.dart';

class RemoveCartItemCubit extends Cubit<RemoveCartItemState> {
  final CartRepo _cartRepo;

  RemoveCartItemCubit(
    this._cartRepo,
  ) : super(const RemoveCartItemState.initial());

  void removeCartItem(int index) {
    emit(const RemoveCartItemState.loading());
    _cartRepo.removeCartItem(index).run().then(
      (either) {
        either.fold(
          (l) => emit(RemoveCartItemState.error(exception: l)),
          (_) {
            sl<CartItemsCountCubit>().decrement();
            emit(const RemoveCartItemState.success());
          },
        );
      },
    );
  }
}
