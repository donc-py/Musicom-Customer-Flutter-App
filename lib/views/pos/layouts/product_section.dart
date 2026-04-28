import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/models/pos_product_model.dart';
import 'package:readypos_flutter/views/pos/components/product_cart.dart';
import 'package:rive/rive.dart';

class ProductSection extends StatelessWidget {
  ProductSection({
    super.key,
  });

  final scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  List<PosProductModel> getProducts(List<HiveCartModel> cartItems) {
    List<PosProductModel> products = [];
    for (var item in cartItems) {
      PosProductModel product = PosProductModel(
        id: item.id,
        thumbnail: item.thumbnail,
        name: item.name,
        subtotal: item.subTotal,
      );
      products.add(product);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<HiveCartModel>(AppConstants.cartBox).listenable(),
        builder: (context, box, _) {
          final products = getProducts(box.values.toList());
          return Container(
            height: context.isTabletLandsCape ? 320.h : 285.h,
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : Colors.white,
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, top: 10.h, bottom: 0.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      S.of(context).products,
                      style: AppTextStyle.largeBody,
                    ),
                    Gap(12.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: AppColor.redColor,
                      ),
                      child: Text(
                        box.values.length.toString(),
                        style: AppTextStyle.smallBody.copyWith(
                          color: AppColor.whiteColor,
                        ),
                      ),
                    )
                  ],
                ),
                Gap(12.h),
                Expanded(
                  child: products.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(30.h),
                          child: const RiveAnimation.asset(
                            "assets/animations/empty.riv",
                          ),
                        )
                      : Scrollbar(
                          controller: scrollController,
                          thumbVisibility: products.length > 4 ? true : false,
                          trackVisibility: products.length > 4 ? true : false,
                          radius: Radius.circular(10.r),
                          child: ListView.builder(
                              itemCount: products.length,
                              shrinkWrap: true,
                              controller: scrollController,
                              padding: EdgeInsets.only(right: 10.w),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Hero(
                                      tag: products[index].id.toString(),
                                      child: ProductCart(
                                        isBorderActive: true,
                                        productModel: products[index],
                                        isPriceEditAble: true,
                                      ),
                                    ),
                                    products.length - 1 == index
                                        ? const SizedBox()
                                        : const Divider()
                                  ],
                                );
                              }),
                        ),
                ),
              ],
            ),
          );
        });
  }
}
