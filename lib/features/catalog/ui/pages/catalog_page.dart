import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/common/models/product.dart';
import '../../../../core/routing/routes.dart';
import '../cubits/cart_items_count_cubit/cart_items_count_cubit.dart';
import '../../data/repos/catalog_repo.dart';
import '../widgets/product_card.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);

  String? _query;
  final _queryController = TextEditingController();
  final _queryFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      sl<CatalogRepo>()
          .getProducts(page: pageKey)
          .getOrElse((l) {
            throw _pagingController.error = l;
          })
          .run()
          .then(
            (res) {
              if (res.lastPage == res.currentPage) {
                _pagingController.appendLastPage(res.data);
              } else {
                _pagingController.appendPage(
                  res.data,
                  res.currentPage + 1,
                );
              }
            },
          );
    });

    _queryController.addListener(() {
      if (_query == _queryController.text) return;
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _query = _queryController.text;
          setState(() {});
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _queryFocusNode.unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const CustomAppBar(title: 'Catalog'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 8.h,
                  ),
                  child: Container(
                    width: 300.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _queryController,
                      focusNode: _queryFocusNode,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed(Routes.cart),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 8.h,
                        ),
                        child: const Icon(Icons.shopping_cart),
                      ),
                      BlocBuilder<CartItemsCountCubit, int>(
                        bloc: sl<CartItemsCountCubit>(),
                        builder: (_, state) {
                          if (state == 0) return const SizedBox();
                          return Positioned.directional(
                            textDirection: TextDirection.ltr,
                            top: 1.h,
                            end: 0,
                            child: Container(
                              height: 14.sp,
                              width: 14.sp,
                              padding: EdgeInsets.all(1.sp),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    state.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'robot',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: PagedListView<int, Product>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Product>(
                  itemBuilder: (_, product, __) => Visibility(
                    visible: product.name.toLowerCase().contains(
                          _queryController.text.toLowerCase(),
                        ),
                    child: ProductCard(product: product),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
