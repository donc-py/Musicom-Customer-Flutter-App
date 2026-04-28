// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/dashboard/dashboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PurchaseAndSaleGraph extends StatelessWidget {
  final DashboardInfo dashboardInfo;
  PurchaseAndSaleGraph({
    super.key,
    required this.dashboardInfo,
  });

  final List<String> monthList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AdaptiveTheme.of(context).mode.isDark
          ? AppColor.darkBackgroundColor
          : Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).purchaseAndSale,
                  style: AppTextStyle.title.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF8C86F3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Gap(4.w),
                        Text(S.of(context).purchase,
                            style: AppTextStyle.normalBody)
                      ],
                    ),
                    Gap(12.w),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: ShapeDecoration(
                            color: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Gap(4.w),
                        Text(S.of(context).sale, style: AppTextStyle.normalBody)
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(),
          SfCartesianChart(
            borderWidth: 0,
            borderColor: Colors.transparent,
            plotAreaBorderWidth: 0,
            primaryXAxis: const CategoryAxis(
              majorGridLines: MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              labelFormat:
                  '{value}${getNumberType(dashboardInfo.maxChartAmount.toDouble())}',
              maximum: 100,
              minimum: 0,
              majorGridLines:
                  const MajorGridLines(width: 1, dashArray: <double>[4, 4]),
              interval: 25,
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: '',
              canShowMarker: false,
              format: 'point.x : point.y',
            ),
            series: <CartesianSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                spacing: 0.1,
                enableTooltip: true,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.r),
                  topRight: Radius.circular(3.r),
                ),
                color: AppColor.primaryColor,
                dataSource: dashboardInfo.purchaseAndSaleChart
                    .asMap()
                    .map((index, e) => MapEntry(
                          index,
                          ChartData(
                            monthList[index],
                            formatNumber(e.sale),
                            formatNumber(
                              e.purchase,
                            ),
                          ),
                        ))
                    .values
                    .toList(),
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
              ),
              ColumnSeries<ChartData, String>(
                spacing: 0.1,
                enableTooltip: true,
                dataSource: dashboardInfo.purchaseAndSaleChart
                    .asMap()
                    .map((index, e) => MapEntry(
                          index,
                          ChartData(
                            monthList[index],
                            formatNumber(e.sale),
                            formatNumber(
                              e.purchase,
                            ),
                          ),
                        ))
                    .values
                    .toList(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.r),
                  topRight: Radius.circular(3.r),
                ),
                color: const Color(0xFF8C86F3),
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getNumberType(double value) {
    if (value >= 1000 && value < 1000000) {
      double result = value / 1000.0;
      return 'K';
    } else if (value >= 1000000) {
      double result = value / 1000000.0;
      return 'M';
    } else {
      return '';
    }
  }

  double formatNumber(double value) {
    if (value >= 1000 && value < 1000000) {
      double result = value / 1000.0;
      return result;
    } else if (value >= 1000000) {
      double result = value / 1000000.0;
      return result;
    } else {
      return value;
    }
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final double y;
  final double y1;
}
