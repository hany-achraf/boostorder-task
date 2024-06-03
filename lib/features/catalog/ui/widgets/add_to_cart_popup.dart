import 'package:app/features/cart/data/models/cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/common/models/product.dart';
import '../../../../core/common/models/variation.dart';
import '../../../../core/theming/app_colors.dart';
import '../cubits/add_to_cart_cubit/add_to_cart_cubit.dart';
import 'quantity_button.dart';
import 'selectable_card.dart';

class AddToCartPopup extends StatefulWidget {
  const AddToCartPopup({super.key, required this.product});

  final Product product;

  @override
  State<AddToCartPopup> createState() => _AddToCartPopupState();
}

class _AddToCartPopupState extends State<AddToCartPopup> {
  final AddToCartCubit _addToCartCubit = sl<AddToCartCubit>();

  final Map<int, String> _selectedOptions = {};
  int _quantity = 1;
  Variation? _selectedVariation;

  @override
  void initState() {
    super.initState();
    if (widget.product.variations.isNotEmpty) {
      _selectedVariation = widget.product.variations[0];
      for (var attribute in widget.product.attributes) {
        _selectedOptions[attribute.id] =
            widget.product.variations[0].attributes!.firstWhere(
          (variationAttribute) {
            return variationAttribute.name == attribute.name;
          },
        ).option;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double? regularPrice = widget.product.regularPrice;
    double? salePrice = widget.product.salePrice;
    int stockQuantity = widget.product.stockQuantity ?? 0;

    if (_selectedVariation != null) {
      regularPrice = _selectedVariation?.regularPrice;
      salePrice = _selectedVariation?.salePrice;
      stockQuantity = _selectedVariation!.totalInventoryStock;
    }

    return BlocListener<AddToCartCubit, AddToCartState>(
      bloc: _addToCartCubit,
      listener: (context, state) {
        state.whenOrNull(
          success: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product added to cart'),
                backgroundColor: Colors.green,
              ),
            );
          },
          error: (l) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to add product to cart!'),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: widget.product.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.product.imageUrl!,
                            width: 70.w,
                            height: 70.w,
                            fit: BoxFit.fill,
                          )
                        : Container(
                            width: 70.w,
                            height: 70.w,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48.sp,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Wrap(
                            children: [
                              if (widget.product.sku != null) ...[
                                Text(
                                  'SKU_${widget.product.sku}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 4.w)
                              ],
                              Text(
                                stockQuantity > 0
                                    ? '$stockQuantity In stock'
                                    : 'Out of stock',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: stockQuantity > 0
                                      ? const Color.fromARGB(255, 136, 219, 139)
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          widget.product.name * 2,
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        if (regularPrice != null && regularPrice > 0)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'RM ${regularPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    decoration: salePrice != null
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (salePrice != null) ...[
                                  SizedBox(width: 8.w),
                                  Text(
                                    'RM ${salePrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ...widget.product.attributes.map((attribute) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attribute.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: attribute.options.map((option) {
                          return SelectableCard(
                            label: option,
                            isSelected:
                                _selectedOptions[attribute.id] == option,
                            onTap: () {
                              setState(() {
                                _quantity = 1;
                                _selectedOptions[attribute.id] = option;
                                _selectedVariation = widget.product.variations
                                    .firstWhere((variation) {
                                  return variation.attributes!
                                      .every((variationAttribute) {
                                    return _selectedOptions[
                                            variationAttribute.id] ==
                                        variationAttribute.option;
                                  });
                                });
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QuantityButton(
                    icon: Icons.remove,
                    onPressed: _quantity > 1
                        ? () {
                            setState(() {
                              _quantity--;
                            });
                          }
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      '$_quantity',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  QuantityButton(
                    icon: Icons.add,
                    onPressed: _quantity < stockQuantity
                        ? () {
                            setState(() {
                              _quantity++;
                            });
                          }
                        : null,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: stockQuantity > 0
                      ? () {
                          _addToCartCubit.addToCart(
                            item: CartItem(
                              product: widget.product,
                              variationId: _selectedVariation?.id,
                              quantity: _quantity,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add to cart',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.add_shopping_cart,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
