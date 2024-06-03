import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../data/models/cart_item.dart';
import '../../../../core/common/models/variation.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../catalog/ui/widgets/quantity_button.dart';
import '../cubits/remove_cart_item_cubit/remove_cart_item_cubit.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onChangeQuantity,
  });

  final CartItem item;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback onChangeQuantity;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late Variation? _variation;

  late String? _sku;
  late double? _regularPrice;
  late double? _salePrice;
  late int _stockQuantity;

  final _removeCartItemCubit = sl<RemoveCartItemCubit>();
  bool _removingItem = false;

  void _handleRemove() {
    if (_removingItem) return;
    _removeCartItemCubit.removeCartItem(widget.index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Most probably this is bad for performance, consider fidning a better way
    _variation = (widget.item.product.variations).firstWhereOrNull(
      (v) => v.id == widget.item.variationId,
    );
    _sku = _variation?.sku ?? widget.item.product.sku;
    _regularPrice =
        _variation?.regularPrice ?? widget.item.product.regularPrice;
    _salePrice = _variation?.salePrice ?? widget.item.product.salePrice;
    _stockQuantity = _variation?.totalInventoryStock ??
        widget.item.product.stockQuantity ??
        0;

    return BlocListener<RemoveCartItemCubit, RemoveCartItemState>(
      bloc: _removeCartItemCubit,
      listener: (_, state) {
        state.maybeWhen(
          loading: () {
            _removingItem = true;
          },
          success: () {
            widget.onRemove();
            setState(() {
              _removingItem = false;
            });
          },
          orElse: () {},
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 8.h,
        ),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 8.h,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.item.product.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: widget.item.product.imageUrl!,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80.w,
                        height: 80.w,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 4.w),
                                      child: Text(
                                        'SKU_$_sku',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _stockQuantity > 0
                                          ? '$_stockQuantity In stock'
                                          : 'Out of stock',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: _stockQuantity > 0
                                            ? const Color.fromARGB(
                                                255, 136, 219, 139)
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                widget.item.product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_variation != null)
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 4.h),
                                  child: Text(
                                    'Variation: ${_variation?.attributes?.map((attr) => attr.option).join(', ')}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              Row(
                                children: [
                                  if (_regularPrice != null)
                                    Text(
                                      'RM ${_regularPrice?.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.secondary,
                                        decoration: _salePrice != null
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                  if (_salePrice != null) ...[
                                    SizedBox(width: 8.w),
                                    Text(
                                      'RM ${_salePrice?.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _handleRemove,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            QuantityButton(
                              icon: Icons.remove,
                              onPressed: widget.item.quantity > 1
                                  ? () {
                                      widget.item.quantity--;
                                      widget.onChangeQuantity();
                                    }
                                  : null,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Text(
                                '${widget.item.quantity}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            QuantityButton(
                              icon: Icons.add,
                              onPressed: widget.item.quantity < _stockQuantity
                                  ? () {
                                      widget.item.quantity++;
                                      widget.onChangeQuantity();
                                    }
                                  : null,
                            ),
                          ],
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 2.w,
                                color: AppColors.secondary,
                              ),
                              SizedBox(width: 4.w),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 0.25.sw,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'RM ${((_salePrice ?? _regularPrice)! * widget.item.quantity).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
