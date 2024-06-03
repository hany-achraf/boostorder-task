part of 'add_to_cart_cubit.dart';

@freezed
class AddToCartState with _$AddToCartState {
  const factory AddToCartState.initial() = _Initial;
  const factory AddToCartState.loading() = _Loading;
  const factory AddToCartState.success() = _Success;
  const factory AddToCartState.error(Exception e) = _Error;
}
