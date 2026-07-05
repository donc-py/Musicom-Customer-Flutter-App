import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/enums.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/pos_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/pos/components/custom_payment_button.dart';

class PaymentTypeSection extends ConsumerWidget {
  const PaymentTypeSection({super.key});
  String getPaymentMethod(BuildContext context, PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return S.of(context).cash;
      case PaymentMethod.paypal:
        return S.of(context).Paypal;
      // case PaymentMethod.draft:
      //   return "Draft";
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // height: context.isTabletLandsCape ? 110.h : 72.h,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      color: AdaptiveTheme.of(context).mode.isDark
          ? AppColor.darkBackgroundColor
          : Colors.white,
      child: InkWell(
        onTap: () async {
          await _paymentTypeBottomSheet(context);
        },
        child: Container(
          // height: 48.h,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.borderColor,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(children: [
            context.isTabletLandsCape
                ? SvgPicture.asset(
                    Assets.svgs.money,
                    height: 50.r,
                  )
                : SvgPicture.asset(Assets.svgs.money,
                    height: 24.h, width: 24.w),
            Gap(12.w),
            Expanded(
              child: Text(
                getPaymentMethod(
                    context, ref.watch(selectedPaymentMethodProvider)),
                style: AppTextStyle.normalBody,
              ),
            ),
            Gap(12.w),
            SvgPicture.asset(Assets.svgs.arrowDown2)
          ]),
        ),
      ),
    );
  }

  Future<dynamic> _paymentTypeBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(15.0.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).paymentMethod,
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
              Consumer(builder: (context, ref, _) {
                final selectedPaymentMethod =
                    ref.watch(selectedPaymentMethodProvider);
                return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 20.h,
                      mainAxisExtent: context.isTabletLandsCape ? 95.h : 55.0.h,
                    ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return CustomPaymentButton(
                        buttonText: getPaymentMethod(
                            context, PaymentMethod.values[index]),
                        isSelected: selectedPaymentMethod ==
                            PaymentMethod.values[index],
                        onTap: () {
                          ref
                              .read(selectedPaymentMethodProvider.notifier)
                              .state = PaymentMethod.values[index];
                          context.nav.pop();

                          // if (index == 0) {
                          //   ref
                          //       .read(selectedPaymentMethodProvider.notifier)
                          //       .state = PaymentMethod.values[index];
                          //   context.nav.pop();
                          // } else {
                          //   ScaffoldMessenger.of(context)
                          //     ..hideCurrentSnackBar()
                          //     ..showSnackBar(
                          //       const SnackBar(
                          //         content: Text("Currently not available"),
                          //         backgroundColor: Colors.red,
                          //         duration: Duration(milliseconds: 600),
                          //       ),
                          //     );
                          //   context.nav.pop();
                          // }
                        },
                      );
                    });
              }),
            ],
          ),
        );
      },
    );
  }
}
