import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/controllers/pos_product_controller/product_controller.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/cart/components/search_appBar.dart';
import 'package:readypos_flutter/views/pos/components/product_cart.dart';

class CartLayout extends ConsumerStatefulWidget {
  const CartLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartLayoutState();
}

class _CartLayoutState extends ConsumerState<CartLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if (ref.read(posProductsControllerProvider.notifier).productList ==
      //     null) {
      ref.read(posProductsControllerProvider.notifier).getProducts();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productList =
        ref.watch(posProductsControllerProvider.notifier).productList;
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;

    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(
      //     context.isTabletLandsCape
      //         ? 185.h
      //         : 180.h - MediaQuery.of(context).padding.top,
      //   ),
      //   child: ,
      // ),
      body: Column(
        children: [
          const SearchAppBar(),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  margin: EdgeInsets.only(top: 10.h),
                  color: AdaptiveTheme.of(context).mode.isDark
                      ? AppColor.darkBackgroundColor
                      : Colors.white,
                  width: double.infinity,
                  child: ref.watch(posProductsControllerProvider)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : productList != null && productList.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.only(top: 10.h),
                              physics: const BouncingScrollPhysics(),
                              itemCount: productList.length,
                              itemBuilder: (context, index) {
                                return ProductCart(
                                  productModel: productList[index],
                                  isBottomPadding:
                                      productList.length - 1 == index,
                                  isPriceEditAble: false,
                                );
                              })
                          : Center(
                              child: Text(
                                "No Data",
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 15.sp : 14.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                ),
                Positioned(
                  bottom: 15.h,
                  child: Hero(
                    tag: "btn",
                    child: SizedBox(
                      width: 0.9.sw,
                      child: CustomButton(
                        onPressed: () {
                          context.nav.pop();
                        },
                        text: "Done",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
