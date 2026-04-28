import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/components/add_to_cart_button.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/controllers/cart_controller/cart_repo.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/models/pos_product_model.dart';
import 'package:readypos_flutter/utils/global_function.dart';

class ProductCart extends ConsumerWidget {
  final bool isBorderActive;
  final PosProductModel productModel;
  final bool isBottomPadding;
  final bool isPriceEditAble;
  const ProductCart({
    super.key,
    this.isBorderActive = false,
    required this.productModel,
    this.isBottomPadding = false,
    required this.isPriceEditAble,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(appcurrencyNotifierProvider.notifier);
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<HiveCartModel>(AppConstants.cartBox).listenable(),
        builder: (context, box, _) {
          bool inCart = false;
          late int productQuantity;
          late int index;
          double price = 0.0;
          final cartItems = box.values.toList();
          for (int i = 0; i < cartItems.length; i++) {
            final cartProduct = cartItems[i];
            if (cartProduct.id == productModel.id) {
              inCart = true;
              productQuantity = cartProduct.productsQTY;
              price = cartProduct.subTotal;
              index = i;
              break;
            }
          }
          final myController = TextEditingController()..text = price.toString();

          myController.selection = TextSelection.fromPosition(
            TextPosition(offset: myController.text.length),
          );
          return Padding(
            padding: EdgeInsets.only(
              bottom: isBottomPadding
                  ? 60.h
                  : isBorderActive
                      ? 0.h
                      : 12.h,
            ),
            child: Column(
              children: [
                Container(
                  // height: 60.h,
                  padding: EdgeInsets.all(isBorderActive ? 0.r : 8.r),
                  decoration: BoxDecoration(
                    color: isBorderActive
                        ? AdaptiveTheme.of(context).mode.isDark
                            ? AppColor.darkBackgroundColor.withOpacity(0.5)
                            : AppColor.whiteColor
                        : null,
                    // border: isBorderActive
                    //     ? Border.all(
                    //         color: AppColor.borderColor.withOpacity(0.5),
                    //       )
                    //     : null,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 44.h,
                        width: 44.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColor.blueBackgroundColor,
                        ),
                        child: Image.network(
                          productModel.thumbnail ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              productModel.name ?? "",
                              style: AppTextStyle.normalBody,
                              overflow: TextOverflow.ellipsis,
                            ),
                            isPriceEditAble
                                ? Row(
                                    children: [
                                      !ref.watch(isEditPriceProvider(index))
                                          ? Text(
                                              currency.currencyValue(price),
                                              style: AppTextStyle.normalBody
                                                  .copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xff6A4CDF),
                                              ),
                                            )
                                          : IntrinsicWidth(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.r),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  color: AppColor
                                                      .blueBackgroundColor,
                                                ),
                                                child: TextField(
                                                  //enable focus
                                                  focusNode: FocusNode(),
                                                  controller: myController,
                                                  decoration:
                                                      const InputDecoration(
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                  ),
                                                  style: AppTextStyle.normalBody
                                                      .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        const Color(0xff6A4CDF),
                                                  ),
                                                  onSubmitted: (value) {
                                                    ref
                                                        .read(cartRepo)
                                                        .updateCartItemSubTotal(
                                                          productId:
                                                              productModel.id!,
                                                          subTotal:
                                                              double.parse(
                                                                  myController
                                                                      .text),
                                                          index: index,
                                                          cartBox: box,
                                                        );
                                                  },
                                                ),
                                              ),
                                            ),
                                      Gap(10.w),
                                      InkWell(
                                        onTap: () {
                                          if (ref.watch(
                                                  isEditPriceProvider(index)) ==
                                              true) {
                                            if (myController.text.isNotEmpty) {
                                              ref
                                                  .read(cartRepo)
                                                  .updateCartItemSubTotal(
                                                    productId: productModel.id!,
                                                    subTotal: double.parse(
                                                        myController.text),
                                                    index: index,
                                                    cartBox: box,
                                                  );
                                              // make it false
                                              ref
                                                  .read(
                                                      isEditPriceProvider(index)
                                                          .notifier)
                                                  .state = false;
                                            } else {
                                              GlobalFunction.showCustomSnackbar(
                                                message: "Price can't be empty",
                                                isSuccess: false,
                                              );
                                            }
                                          } else {
                                            // make it true
                                            ref
                                                .read(isEditPriceProvider(index)
                                                    .notifier)
                                                .state = true;
                                          }
                                        },
                                        child: ref.watch(
                                                isEditPriceProvider(index))
                                            ? SvgPicture.asset(
                                                Assets.svgs.checkCircle,
                                                height: 18.r,
                                                width: 18.r,
                                              )
                                            : SvgPicture.asset(
                                                Assets.svgs.penLine,
                                                height: 15.r,
                                                width: 15.r,
                                              ),
                                      )
                                    ],
                                  )
                                : Text(
                                    currency.currencyValue(
                                        productModel.subtotal ?? 0),
                                    style: AppTextStyle.normalBody.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff6A4CDF),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Gap(15.w),
                      inCart
                          ? Row(
                              children: [
                                AddToCartButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    ref.read(cartRepo).decrementProductQuantity(
                                          productId: productModel.id!,
                                          cartBox: box,
                                          index: index,
                                        );
                                  },
                                ),
                                Gap(10.w),
                                Text(
                                  productQuantity.toString(),
                                  style: AppTextStyle.normalBody.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Gap(10.w),
                                AddToCartButton(
                                  icon: Icons.add,
                                  onTap: () {
                                    ref.read(cartRepo).incrementProductQuantity(
                                          productId: productModel.id!,
                                          box: box,
                                          index: index,
                                        );
                                  },
                                ),
                              ],
                            )
                          : AddToCartButton(
                              onTap: () async {
                                final cartBox = Hive.box<HiveCartModel>(
                                    AppConstants.cartBox);

                                HiveCartModel cartModel = HiveCartModel(
                                  id: productModel.id!,
                                  name: productModel.name!,
                                  code: productModel.code!,
                                  thumbnail: productModel.thumbnail!,
                                  subTotal: productModel.subtotal!,
                                  productsQTY: 1,
                                );

                                await cartBox.add(cartModel);
                              },
                              icon: Icons.add,
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
