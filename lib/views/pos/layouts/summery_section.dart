import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/components/custom_text_field.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/controllers/cart_controller/cart_controller.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/pos_controller.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/pos_provider.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/utils/global_function.dart';

class SummerySection extends ConsumerWidget {
  const SummerySection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(appcurrencyNotifierProvider.notifier);
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<HiveCartModel>(AppConstants.cartBox).listenable(),
      builder: (context, box, _) {
        ref
            .watch(cartController.notifier)
            .calculateSubTotal(box.values.toList());
        return Container(
          color: AdaptiveTheme.of(context).mode.isDark
              ? AppColor.darkBackgroundColor
              : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
          child: Consumer(builder: (context, ref, _) {
            final cartData = ref.watch(cartController);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).billSummary,
                  style: AppTextStyle.largeBody,
                ),
                Gap(12.h),
                summeryItem(
                  context: context,
                  title: "${S.of(context).totalItems}:",
                  value: box.length.toString(),
                ),
                summeryItem(
                  context: context,
                  title: "${S.of(context).totalAmount}:",
                  value: currency.currencyValue(cartData.totalAmount),
                ),
                summeryItem(
                  context: context,
                  title: "${S.of(context).discount}:",
                  value: currency.currencyValue(cartData.discountedAmount),
                ),
                summeryItem(
                    context: context,
                    title: S.of(context).coupon,
                    isCupon: ref.watch(cartController.notifier).totalAmount > 0
                        ? true
                        : false,
                    value:
                        currency.currencyValue(cartData.cuponDiscountedAmount),
                    isCuponApplied:
                        cartData.cuponDiscountedAmount > 0 ? true : false,
                    onTap: () {
                      if (cartData.cuponDiscountedAmount > 0) {
                        ref
                            .read(cartController.notifier)
                            .setCuponDiscount(null);
                        ref
                            .read(cartController.notifier)
                            .calculateSubTotal(box.values.toList());
                        return;
                      }
                      showCouponBottomSheet(context);
                    }),
                Container(height: 1.h, color: AppColor.borderColor),
                Gap(8.h),
                summeryItem(
                  context: context,
                  title: S.of(context).grandTotal,
                  isBottomPadding: false,
                  isTotal: true,
                  value: currency.currencyValue(cartData.subTotalAmount),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Future<dynamic> showCouponBottomSheet(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return Consumer(builder: (context, ref, _) {
          final cuponLoading = ref.watch(cuponControllerProvider);
          return Padding(
            padding: EdgeInsets.only(
              top: 15.0.r,
              left: 15.r,
              right: 15.r,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Enter Coupon",
                        style: AppTextStyle.title,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? Colors.white
                            : AppColor.darkBackgroundColor,
                      ),
                    )
                  ],
                ),
                Gap(28.h),
                SizedBox(
                  // height: 56.h,
                  child: CustomTextField(
                    hint: "Enter coupon code",
                    controller: ref.watch(cuponTextEditingController),
                  ),
                ),
                Gap(25.h),
                SizedBox(
                  width: double.infinity,
                  child: cuponLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          onPressed: () {
                            if (ref
                                .read(cuponTextEditingController)
                                .text
                                .isNotEmpty) {
                              final Box<HiveCartModel> cartBox =
                                  Hive.box<HiveCartModel>(AppConstants.cartBox);
                              ref
                                  .read(cuponControllerProvider.notifier)
                                  .applyCupon(
                                    code: ref
                                        .read(cuponTextEditingController)
                                        .text
                                        .toString(),
                                    price: ref
                                        .read(cartController.notifier)
                                        .totalAmount
                                        .toString(),
                                  )
                                  .then((value) {
                                if (value) {
                                  ref
                                      .read(cartController.notifier)
                                      .calculateSubTotal(
                                          cartBox.values.toList());

                                  ref
                                      .read(cartController.notifier)
                                      .setCuponDiscount(ref
                                          .read(
                                              cuponControllerProvider.notifier)
                                          .discount);
                                  GlobalFunction.showCustomSnackbar(
                                    message: "Coupon succesfully applied",
                                    isSuccess: true,
                                  );
                                  Navigator.pop(context);
                                } else {
                                  GlobalFunction.showCustomSnackbar(
                                    message: "Invalid Cupon Code",
                                    isSuccess: false,
                                  );
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          text: "Apply",
                        ),
                ),
                Gap(30.h),
              ],
            ),
          );
        });
      },
    );
  }

  Container summeryItem({
    required String title,
    required String value,
    bool isCupon = false,
    bool isCuponApplied = false,
    bool isTotal = false,
    Function? onTap,
    bool isBottomPadding = true,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: isBottomPadding ? 11.h : 0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: isCupon
                ? Row(
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.normalBody,
                      ),
                      Gap(12.w),
                      InkWell(
                        onTap: () {
                          onTap!();
                        },
                        child: Container(
                          height: context.isTabletLandsCape ? 35.r : 25.r,
                          width: context.isTabletLandsCape ? 35.r : 25.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isCuponApplied
                                ? AppColor.redColor
                                : AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            isCuponApplied ? Icons.remove : Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    title,
                    style: AppTextStyle.normalBody.copyWith(
                      fontWeight: isTotal ? FontWeight.w700 : null,
                    ),
                  ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.normalBody.copyWith(
                fontWeight: isTotal ? FontWeight.w700 : null,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
