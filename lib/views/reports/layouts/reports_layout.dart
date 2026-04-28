import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/reports/reports_controller.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';

class ReportsLayout extends ConsumerWidget {
  const ReportsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(appcurrencyNotifierProvider.notifier);
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        toolbarHeight: context.isTabletLandsCape ? 150.h : 100.h,
        backgroundColor: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).reports,
              style: AppTextStyle.title,
            ),
            Gap(5.h),
            Consumer(builder: (context, ref, _) {
              return ref.watch(realTimeClockProvider).when(
                    data: (data) {
                      return Text(
                        data,
                        style: AppTextStyle.normalBody.copyWith(
                          fontSize: 12.sp,
                        ),
                      );
                    },
                    error: (e, stackTrace) => const Text("Error"),
                    loading: () => const Text("Loading..."),
                  );
            })
          ],
        ),
      ),
      body: Consumer(builder: (context, ref, _) {
        final asyncValue = ref.watch(reportControllerProvider);
        return asyncValue.when(
          data: (report) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.refresh(reportControllerProvider);
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 16.h),
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: ShapeDecoration(
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? AppColor.darkBackgroundColor
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        shadows: AdaptiveTheme.of(context).mode.isDark
                            ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, -2),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          _buildTitleRowWidget(
                            context: context,
                            title: S.of(context).purchases,
                            icon: Assets.svgs.purchasesReport,
                          ),
                          Gap(20.h),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).totalAmount,
                                      value: currency.currencyValue(
                                          report.purchases.total.toDouble()),
                                    ),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).tax,
                                      value: currency.currencyValue(
                                          report.purchases.tax.toDouble()),
                                    ),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).due,
                                      value: currency.currencyValue(
                                          report.purchases.due.toDouble()),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoWidget(
                                        context: context,
                                        key: S.of(context).paid,
                                        value: currency.currencyValue(
                                            report.purchases.paid.toDouble())),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                        context: context,
                                        key: S.of(context).discount,
                                        value: currency.currencyValue(report
                                            .purchases.discount
                                            .toDouble())),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                        context: context,
                                        key: S.of(context).products,
                                        value: report.purchases.products
                                            .toString()),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Gap(14.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 16.h),
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: ShapeDecoration(
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? AppColor.darkBackgroundColor
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        shadows: AdaptiveTheme.of(context).mode.isDark
                            ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, -2),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          _buildTitleRowWidget(
                            context: context,
                            title: S.of(context).sales,
                            icon: Assets.svgs.saleReport,
                          ),
                          Gap(20.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).totalAmount,
                                      value: currency.currencyValue(
                                          report.sales.total.toDouble()),
                                    ),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).discount,
                                      value: currency.currencyValue(
                                          report.sales.discount.toDouble()),
                                    ),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).availableProducts,
                                      value: report.sales.availableProduct
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoWidget(
                                        context: context,
                                        key: S.of(context).tax,
                                        value: currency.currencyValue(
                                            report.sales.tax.toDouble())),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).sellingProducts,
                                      value: report.sales.sellingProduct
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Gap(14.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: ShapeDecoration(
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? AppColor.darkBackgroundColor
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        shadows: AdaptiveTheme.of(context).mode.isDark
                            ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, -2),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          _buildTitleRowWidget(
                            context: context,
                            title: S.of(context).paymentReceived,
                            icon: Assets.svgs.paymentReport,
                          ),
                          Gap(20.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).totalAmount,
                                      value: currency.currencyValue(report
                                          .paymentReceived.total
                                          .toDouble()),
                                    ),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).bank,
                                      value: currency.currencyValue(report
                                          .paymentReceived.bank
                                          .toDouble()),
                                    ),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).totalReceviedInBank,
                                      value: report.paymentReceived.bankCount
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoWidget(
                                        context: context,
                                        key: S.of(context).cash,
                                        value: currency.currencyValue(report
                                            .paymentReceived.cash
                                            .toDouble())),
                                    Gap(14.h),
                                    _buildInfoWidget(
                                      context: context,
                                      key: S.of(context).totalCashReceived,
                                      value: report.paymentReceived.cashCount
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Gap(14.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: ShapeDecoration(
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? AppColor.darkBackgroundColor
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        shadows: AdaptiveTheme.of(context).mode.isDark
                            ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.15),
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
                          _buildTitleRowWidget(
                            context: context,
                            title: S.of(context).profit,
                            icon: Assets.svgs.profitReport,
                          ),
                          Gap(20.h),
                          _buildInfoWidget(
                            context: context,
                            key: S.of(context).totalAmount,
                            value: currency
                                .currencyValue(report.profit.toDouble()),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      }),
    );
  }

  Widget _buildTitleRowWidget(
      {required BuildContext context,
      required String title,
      required String icon}) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.largeBody,
        ),
        SvgPicture.asset(
          icon,
          height: isLargeScreen ? 40.r : null,
          width: isLargeScreen ? 40.r : null,
        )
      ],
    );
  }

  Widget _buildInfoWidget(
      {required BuildContext context,
      required String key,
      required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          style: AppTextStyle.normalBody.copyWith(
            fontSize: 14.sp,
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.whiteColor
                : AppColor.darkBackgroundColor.withOpacity(0.7),
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
}
