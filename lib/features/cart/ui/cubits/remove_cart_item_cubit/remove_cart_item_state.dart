part of 'remove_cart_item_cubit.dart';

@freezed
class RemoveCartItemState with _$RemoveCartItemState {
  const factory RemoveCartItemState.initial() = _Initial;
  const factory RemoveCartItemState.loading() = _Loading;
  const factory RemoveCartItemState.success() = _Success;
  const factory RemoveCartItemState.error({Exception? exception}) = _Error;
}
