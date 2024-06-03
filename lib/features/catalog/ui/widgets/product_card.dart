import 'package:app/core/theming/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/models/product.dart';
import '../../../../core/common/widgets/no_image_or_error_loading.dart';
import 'add_to_cart_popup.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String? _sku;
  double? _regularPrice;
  double? _salePrice;
  late int _stockQuantity;

  @override
  void initState() {
    super.initState();

    _sku = widget.product.sku;
    _regularPrice = widget.product.regularPrice;
    _salePrice = widget.product.salePrice;

    if (widget.product.variations.isNotEmpty) {
      _sku = _sku ?? widget.product.variations[0].sku;
      _regularPrice =
          _regularPrice ?? widget.product.variations[0].regularPrice;
    }

    if (widget.product.variations.isNotEmpty) {
      _salePrice = _salePrice ?? widget.product.variations[0].salePrice;
    }

    if (widget.product.variations.isNotEmpty) {
      _stockQuantity = widget.product.variations
          .map((variation) => variation.totalInventoryStock)
          .reduce((value, element) => value + element);
    } else {
      _stockQuantity = widget.product.stockQuantity ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Product details page navigation logic here
      },
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Wrap(
                          children: [
                            if (_sku != null) ...[
                              Text(
                                'SKU_$_sku',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 4.w)
                            ],
                            Text(
                              _stockQuantity > 0
                                  ? '$_stockQuantity In stock'
                                  : 'Out of stock',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: _stockQuantity > 0
                                    ? const Color.fromARGB(255, 136, 219, 139)
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      if (_regularPrice != null && _regularPrice! > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'RM ${_regularPrice?.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  decoration: _salePrice != null
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_salePrice != null) ...[
                                SizedBox(width: 8.w),
                                Text(
                                  'RM ${_salePrice?.toStringAsFixed(2)}',
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: widget.product.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: widget.product.imageUrl!,
                          width: 100.w,
                          height: 100.w,
                          fit: BoxFit.fill,
                          errorWidget: (_, __, ___) =>
                              const NoImageOrErrorLoading(),
                        )
                      : const NoImageOrErrorLoading(),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ElevatedButton(
              onPressed: _stockQuantity > 0
                  ? () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                        ),
                        builder: (context) =>
                            AddToCartPopup(product: widget.product),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Divider(
                color: Colors.grey.shade400,
                thickness: 1.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
