// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/dashboard/dashboard.dart';

class FinancialSection extends ConsumerWidget {
  final DashboardInfo dashboardInfo;
  FinancialSection({
    super.key,
    required this.dashboardInfo,
  });

  static List<FinancialModel> getFinancials(BuildContext context) {
    return [
      FinancialModel(
        title: S.of(context).profit,
        amount: "৳ 0.00",
        icon: Assets.svgs.cup,
      ),
      FinancialModel(
        title: S.of(context).sale,
        amount: "৳ 0.00",
        icon: Assets.svgs.import,
      ),
      FinancialModel(
        title: S.of(context).purchase,
        amount: "৳ 0.00",
        icon: Assets.svgs.export,
      ),
      FinancialModel(
        title: S.of(context).purchaseDue,
        amount: "৳ 0.00",
        icon: Assets.svgs.emptyWalletTime,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
    final currency = ref.watch(appcurrencyNotifierProvider.notifier);
    addGridValue();
    return Container(
      padding: EdgeInsets.all(15.r),
      color: AdaptiveTheme.of(context).mode.isDark
          ? Colors.grey.withOpacity(0.15)
          : AppColor.blueBackgroundColor,
      // height: 220.h,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          mainAxisExtent: isLargeScreen
              ? context.isTabletLandsCape
                  ? 160.h
                  : 100.h
              : 90.h,
        ),
        itemCount: gridValue.length,
        itemBuilder: (context, index) {
          return Container(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.all(context.isTabletLandsCape ? 15.r : 12.r),
            decoration: BoxDecoration(
              color: AdaptiveTheme.of(context).mode.isDark
                  ? AppColor.darkBackgroundColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: AdaptiveTheme.of(context).mode.isDark
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      getFinancials(context)[index].title,
                      style: AppTextStyle.normalBody.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      getFinancials(context)[index].icon,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ],
                ),
                Gap(5.r),
                Text(
                  // gridValue[index].toStringAsFixed(2),
                  currency.currencyValue(gridValue[index]),
                  style: AppTextStyle.title,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  final List<double> gridValue = [];

  void addGridValue() {
    if (gridValue.length < 4) {
      gridValue.add(dashboardInfo.sale);
      gridValue.add(dashboardInfo.purchase);
      gridValue.add(dashboardInfo.profit);
      gridValue.add(dashboardInfo.purchaseDue);
    }
  }
}

class FinancialModel {
  final String title;
  final String amount;
  final String icon;

  FinancialModel({
    required this.title,
    required this.amount,
    required this.icon,
  });
}
