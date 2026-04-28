import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/product_controller/product_controller.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class ProductDetailsDialog extends StatelessWidget {
  const ProductDetailsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Consumer(builder: (context, ref, _) {
        final asyncValue = ref.watch(productDetailsControllerProvider);
        return asyncValue.when(
          data: (data) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).productDetails,
                        style: AppTextStyle.title,
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context.nav.pop();
                        },
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                  CachedNetworkImage(
                    imageUrl: data.thumbnail ?? '',
                    width: double.infinity,
                    height: 200.h,
                  ),
                  Gap(30.h),
                  Text(
                    data.name ?? '',
                    style: AppTextStyle.normalBody,
                  ),
                  Gap(14.h),
                  const Divider(),
                  Gap(14.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProductInfoWidget(
                                key: S.of(context).productType,
                                value: data.productType ?? ''),
                            Gap(16.h),
                            _buildProductInfoWidget(
                                key: S.of(context).brand,
                                value: data.brand ?? ''),
                            Gap(16.h),
                            _buildProductInfoWidget(
                                key: S.of(context).unit,
                                value: data.unit ?? ''),
                            Gap(16.h),
                            _buildProductInfoWidget(
                                key: S.of(context).alertQuantity,
                                value: data.alertQty?.toString() ?? ''),
                            Gap(16.h),
                            _buildProductInfoWidget(
                                key: S.of(context).sellingPrice,
                                value: '\$${data.price ?? ''}'),
                          ],
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildProductInfoWidget(
                                key: S.of(context).productCode,
                                value: data.code ?? ''),
                            Gap(16.h),
                            _buildProductInfoWidget(
                                key: S.of(context).category,
                                value: data.category ?? ''),
                            Gap(16.h),
                            _buildProductInfoWidget(
                                key: S.of(context).quantity,
                                value: data.qty?.toString() ?? ''),
                            Gap(16.h),
                            _buildProductInfoWidget(
                                key: S.of(context).purchseCost,
                                value: '\$${data.purchaseCost ?? ''}'),
                          ],
                        ),
                      )
                    ],
                  ),
                  Gap(16.h)
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }

  Column _buildProductInfoWidget({required String key, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          style: AppTextStyle.normalBody.copyWith(
            fontSize: 14.sp,
            color: AppColor.darkBackgroundColor.withOpacity(0.7),
          ),
        ),
        Gap(8.h),
        Text(
          value,
          style: AppTextStyle.normalBody,
        ),
      ],
    );
  }

  static const String image =
      'https://c0.wallpaperflare.com/preview/739/93/119/computer-keyboard-connection-contemporary-desk.jpg';
  static const String details =
      'iPhone 12 64GB Blue (Singapore Unofficial) Super Retina XDR Display with OLED';
}
