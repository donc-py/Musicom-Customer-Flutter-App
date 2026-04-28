import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/pos_controller.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/models/draft_model/draft.dart' as draft;

class DraftCard extends ConsumerWidget {
  const DraftCard({
    super.key,
    required this.index,
    this.onPressed,
    required this.draftModel,
  });
  final int index;
  final Function? onPressed;
  final draft.Draft? draftModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(appcurrencyNotifierProvider.notifier);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10).r,
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${DateFormat("dd MMM yyyy").format(DateFormat("dd/MM/yyyy").parse(draftModel?.createdAt ?? ''))} | ${draftModel?.time ?? ''}",
                      style: AppTextStyle.largeBody.copyWith(
                        fontSize: 14.sp,
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? Colors.white
                            : const Color(0xff6B7280),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          content:
                              deleteDialog(context, id: draftModel?.id ?? 0),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? AppColor.greyBackgroundColor.withOpacity(0.2)
                            : AppColor.greyBackgroundColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: SvgPicture.asset(Assets.svgs.trash),
                    ),
                  )
                ],
              ),
              Gap(5.h),
              draftModel?.customer?.id != null
                  ? Row(
                      children: [
                        SvgPicture.asset(Assets.svgs.profile),
                        Gap(8.w),
                        Expanded(
                          child: Text(
                            "${draftModel?.customer?.name ?? ''} [${draftModel?.customer?.phone ?? ''}]",
                            style: AppTextStyle.normalBody.copyWith(
                              color: AdaptiveTheme.of(context).mode.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
          const Divider(),
          Gap(5.h),
          Text(
            "Products",
            style: AppTextStyle.largeBody,
          ),
          Gap(10.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: draftModel?.products?.length ?? 0,
            itemBuilder: (context, index) {
              final product = draftModel?.products?[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xffF3F4F6),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
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
                      child: CachedNetworkImage(
                        imageUrl: product?.thumbnail ?? "",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Gap(10.w),
                    // expanded text
                    Expanded(
                      child: Text(
                        "${product?.name ?? ''} [${product?.code ?? ''}]",
                        style: AppTextStyle.normalBody.copyWith(
                          color: AdaptiveTheme.of(context).mode.isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    // price
                    Text(
                      currency.currencyValue(product?.price ?? 0),
                      style: AppTextStyle.normalBody.copyWith(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          Column(
            children: [
              Gap(8.h),
              summeryItem(
                title: "Payment Status",
                value: "Pending",
                context: context,
                isStatus: true,
              ),
              summeryItem(
                title: "Total Items",
                value: draftModel?.totalProduct?.toString() ?? "0",
                context: context,
              ),
              summeryItem(
                title: "Total Amounts",
                value: draftModel?.totalPrice?.toString() ?? "0",
                isAmount: true,
                context: context,
              ),
            ],
          ),
          Gap(8.h),
          TextButton(
            onPressed: () {
              onPressed?.call();
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColor.whiteColor,
              foregroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: const BorderSide(color: AppColor.primaryColor),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Go POS",
                  style: AppTextStyle.normalBody.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(12.w),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0),
                  child: SvgPicture.asset(
                    Assets.svgs.arrowLeft,
                    colorFilter: const ColorFilter.mode(
                      AppColor.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget deleteDialog(BuildContext context, {required int id}) {
    return Consumer(builder: (context, ref, child) {
      final deleteLoading = ref.watch(deleteDraftProvider);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 88.r,
            width: 88.r,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFFF1F1),
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 35,
            ),
          ),
          Gap(12.h),
          Text(
            "Are you sure you want to delete this draft?",
            style: AppTextStyle.largeBody.copyWith(
              color: AdaptiveTheme.of(context).mode.isDark
                  ? Colors.white
                  : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColor.greyBackgroundColor,
                    foregroundColor: AdaptiveTheme.of(context).mode.isDark
                        ? Colors.white
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 20.w,
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: AppTextStyle.normalBody.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: deleteLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextButton(
                        onPressed: () {
                          ref
                              .read(deleteDraftProvider.notifier)
                              .deleteDraft(id: id)
                              .then((value) {
                            if (value == true) {
                              Navigator.pop(context);
                              ref.invalidate(draftControllerProvider);
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: const Color.fromARGB(255, 9, 7, 7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 20.w,
                          ),
                        ),
                        child: Text(
                          "Delete",
                          style: AppTextStyle.normalBody.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget summeryItem({
    required BuildContext context,
    required String title,
    required String value,
    bool isAmount = false,
    bool isStatus = false,
  }) {
    return Consumer(builder: (context, ref, child) {
      final currency = ref.watch(appcurrencyNotifierProvider.notifier);
      return Container(
        padding: EdgeInsets.only(bottom: 11.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.normalBody.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            isStatus
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffFCE68B),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      value,
                      style: AppTextStyle.normalBody.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColor.darkBackgroundColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
                : isAmount
                    ? Text(
                        // "₹ $value",
                        currency.currencyValue(double.parse(value)),
                        style: AppTextStyle.normalBody.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      )
                    : Expanded(
                        child: Text(
                          value,
                          style: AppTextStyle.normalBody.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
          ],
        ),
      );
    });
  }
}
