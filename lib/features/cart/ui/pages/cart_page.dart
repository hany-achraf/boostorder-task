import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/models/cart_item.dart';
import '../../../../core/theming/app_colors.dart';
import '../../data/repos/cart_repo.dart';
import '../widgets/cart_item_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with AutomaticKeepAliveClientMixin {
  List<CartItem>? _items;
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    sl<CartRepo>().getCartItems().run().then(
          (either) => either.fold(
            (exception) {},
            (items) {
              setState(() {
                _items = items;
              });
            },
          ),
        );
  }

  void _removeItem(int index) {
    setState(() {
      _items!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _totalPrice = _items == null
        ? 0
        : _items!.fold(0, (previousValue, item) {
            if (item.variationId == null) {
              return previousValue +
                  ((item.product.salePrice ?? item.product.regularPrice ?? 0) *
                      item.quantity);
            }
            final variation = item.product.variations
                .firstWhere((v) => v.id == item.variationId);
            return previousValue +
                (variation.salePrice ?? variation.regularPrice) * item.quantity;
          });

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(title: 'Cart'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: _items == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _items!.length,
              itemBuilder: (_, index) {
                final item = _items![index];
                return CartItemCard(
                  item: item,
                  index: index,
                  onChangeQuantity: () => setState(() {}),
                  onRemove: () => _removeItem(index),
                );
              },
            ),
      bottomNavigationBar: _items == null
          ? null
          : Container(
              height: 0.1.sh,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2.h,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total (${_items!.length})',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'RM ${_totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to payment page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.primary,
                          width: 2.sp,
                        ),
                        borderRadius: BorderRadius.circular(48.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 12.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
