import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/more_providers.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/purchase_controller.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/sales_controller.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/more/sales_model.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/more/components/filter_drawer.dart';
import 'package:readypos_flutter/views/more/components/moreAppBar.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int page = 1;
  List<SalesModel> listData = [];
  String? searchStr;
  final showIndicatorProvider = StateProvider<bool>((ref) {
    return false;
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(salesControllerProvider.notifier)
          .getSales(page: page)
          .then((value) {
        listData = ref.read(salesControllerProvider.notifier).salesList;
        setState(() {});
      });
    });
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'index',
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            S.of(context).sl,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      GridColumn(
        columnName: 'date',
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            S.of(context).date,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      GridColumn(
          columnName: 'ref',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).reference,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'biller',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).biller,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'QTY',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).qty,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'discount',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).discount,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'tax',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).tax,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'totalPrice',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).totalAmount,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'grandTotal',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).grandTotal,
                style: const TextStyle(color: Colors.white),
              ))),
      // GridColumn(
      //     columnName: 'action',
      //     label: Container(
      //         padding: const EdgeInsets.all(8.0),
      //         alignment: Alignment.center,
      //         child: const Text(
      //           'Action',
      //           style: TextStyle(color: Colors.white),
      //         ))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          context.isTabletLandsCape
              ? 200.h
              : 185.h - MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: [
            MoreAppBar(
              title: S.of(context).sales,
              isTrailing: true,
              onTap: () {
                // open end drawer
                _key.currentState!.openEndDrawer();
              },
            ),
            _SearchAndPrint(
              onChange: (str) {
                listData.clear();
                if (str.isNotEmpty) {
                  ref
                      .read(salesControllerProvider.notifier)
                      .getSales(searchQuery: str)
                      .then((value) {
                    listData.addAll(
                        ref.watch(salesControllerProvider.notifier).salesList);
                    setState(() {
                      searchStr = str;
                    });
                  });
                } else {
                  ref
                      .read(salesControllerProvider.notifier)
                      .getSales(page: page, perPage: 20)
                      .then((value) {
                    listData.addAll(
                        ref.watch(salesControllerProvider.notifier).salesList);
                    setState(() {
                      searchStr = null;
                    });
                  });
                }
              },
              onPrint: () {
                if (listData.isNotEmpty) {
                  ref.read(salesPDFProvider.notifier).getSalesPDF(data: {
                    "start_date": ref.read(startDateProvider('sales')),
                    "end_date": ref.read(endDateProvider('sales')),
                    "warehouse_id": ref.read(warehouseIdProvider('sales')),
                    "search": searchStr,
                    "limit": listData.length,
                  }).then((value) {
                    if (value != null) {
                      context.nav.pushNamed(Routes.pdfView, arguments: value);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Something went wrong!"),
                      ));
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
      endDrawer: FilterDrawer(
        flag: "sales",
        onApply: () {
          listData.clear();
          listData
              .addAll(ref.watch(salesControllerProvider.notifier).salesList);
          setState(() {});
        },
        onReset: () {
          listData.clear();
          page = 1;
          ref
              .read(salesControllerProvider.notifier)
              .getSales(page: page, perPage: 20)
              .then((value) {
            listData
                .addAll(ref.watch(salesControllerProvider.notifier).salesList);
            setState(() {});
          });
        },
      ),
      body: Consumer(builder: (context, ref, _) {
        final loading = ref.watch(salesControllerProvider);
        final purchaseDataSource = SalesData(data: listData, ref: ref);
        return loading && page == 1
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : listData.isEmpty
                ? const Center(
                    child: Text("No data found"),
                  )
                : SfDataGridTheme(
                    data: const SfDataGridThemeData(
                        headerColor: AppColor.primaryColor),
                    child: SfDataGrid(
                      source: purchaseDataSource,
                      showSortNumbers: true,
                      columnWidthMode: ColumnWidthMode.auto,
                      columns: getColumns(),
                      loadMoreViewBuilder:
                          (BuildContext context, LoadMoreRows loadMoreRows) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          if (ref.watch(showIndicatorProvider)) {
                            return Container(
                                height: 60.0,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: BorderDirectional(
                                        top: BorderSide(
                                            width: 1.0,
                                            color: Color.fromRGBO(
                                                0, 0, 0, 0.26)))),
                                child: const CircularProgressIndicator());
                          } else {
                            return ref
                                        .watch(salesControllerProvider.notifier)
                                        .totalData ==
                                    listData.length
                                ? const SizedBox()
                                : Container(
                                    height: 60.0,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: BorderDirectional(
                                        top: BorderSide(
                                          width: 1.0,
                                          color: Color.fromRGBO(0, 0, 0, 0.26),
                                        ),
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: 36.0,
                                      width: 142.0,
                                      child: MaterialButton(
                                        color: Colors.blue,
                                        child: const Text('LOAD MORE',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () async {
                                          if (context is StatefulElement &&
                                              context.state.mounted) {
                                            page++;
                                          }
                                          ref
                                              .read(showIndicatorProvider
                                                  .notifier)
                                              .state = true;

                                          await ref
                                              .read(salesControllerProvider
                                                  .notifier)
                                              .getSales(page: page)
                                              .then((value) {
                                            listData.addAll(ref
                                                .read(salesControllerProvider
                                                    .notifier)
                                                .salesList);
                                            ref
                                                .read(showIndicatorProvider
                                                    .notifier)
                                                .state = false;
                                          });
                                          await loadMoreRows();
                                          // if (context is StatefulElement &&
                                          //     context.state.mounted) {
                                          //   setState(() {
                                          //     showIndicator = false;
                                          //   });
                                          // }
                                        },
                                      ),
                                    ),
                                  );
                          }
                        });
                      },
                    ),
                  );
      }),
    );
  }
}

class SalesData extends DataGridSource {
  final WidgetRef ref;

  /// Creates the employee data source class with required details.
  SalesData({required List<SalesModel> data, required this.ref}) {
    _salesData = data
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'index',
                  value: "${data.indexOf(e) + 1}".padLeft(2, "0")),
              DataGridCell<String>(
                  columnName: 'date', value: e.date.toString()),
              DataGridCell<String>(
                  columnName: 'ref', value: e.referenceNo.toString()),
              DataGridCell<String>(
                  columnName: 'biller', value: e.biller.toString()),
              DataGridCell<String>(columnName: 'QTY', value: e.qty.toString()),
              DataGridCell<String>(
                  columnName: 'discount', value: e.discount.toString()),
              DataGridCell<String>(columnName: 'tax', value: e.tax.toString()),
              DataGridCell<String>(
                  columnName: 'totalPrice', value: e.totalPrice.toString()),
              DataGridCell<String>(
                  columnName: 'grandTotal', value: e.grandTotal.toString()),
              // DataGridCell<String>(columnName: 'button', value: e.button.toString()),
            ]))
        .toList();
  }

  List<DataGridRow> _salesData = [];

  @override
  List<DataGridRow> get rows => _salesData;

  void _addMoreRows() {
    final list = ref.watch(salesControllerProvider.notifier).salesList;
    _salesData.addAll(list.map<DataGridRow>((e) => DataGridRow(cells: [
          DataGridCell<String>(
              columnName: 'index',
              value: "${_salesData.length + 1}".padLeft(2, "0")),
          DataGridCell<String>(columnName: 'date', value: e.date ?? ""),
          DataGridCell<String>(columnName: 'ref', value: e.referenceNo ?? ""),
          DataGridCell<String>(columnName: 'biller', value: e.biller ?? ""),
          DataGridCell<String>(columnName: 'QTY', value: e.qty.toString()),
          DataGridCell<String>(
              columnName: 'discount', value: e.discount.toString()),
          DataGridCell<String>(columnName: 'tax', value: e.tax.toString()),
          DataGridCell<String>(
              columnName: 'totalPrice', value: e.totalPrice.toString()),
          DataGridCell<String>(
              columnName: 'grandTotal', value: e.grandTotal.toString()),

          // const DataGridCell<Widget>(columnName: 'action', value: null),
        ])));
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(const Duration(seconds: 1));
    _addMoreRows();
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getBackgroundColor(BuildContext context) {
      int index = _salesData.indexOf(row);
      if (index % 2 == 0) {
        return AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : AppColor.whiteColor;
      } else {
        return AdaptiveTheme.of(context).mode.isDark
            ? AppColor.whiteColor.withOpacity(0.2)
            : Colors.grey[200]!;
      }
    }

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return e.columnName == 'button'
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
              return TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            content: SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Employee ID: ${row.getCells()[0].value.toString()}'),
                                    Text(
                                        'Employee Name: ${row.getCells()[1].value.toString()}'),
                                    Text(
                                        'Employee Designation: ${row.getCells()[2].value.toString()}'),
                                  ],
                                ))));
                  },
                  child: const Text("View"));
            })
          : LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                color: getBackgroundColor(context),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  e.value.toString(),
                ),
              );
            });
    }).toList());
  }
}

class _SearchAndPrint extends StatelessWidget {
  _SearchAndPrint({required this.onChange, required this.onPrint});

  Function(String) onChange;
  Function onPrint;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Container(
      // height: context.isTabletLandsCape ? 110.h : 70.h,
      color: AdaptiveTheme.of(context).mode.isDark
          ? AppColor.darkBackgroundColor
          : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.r),
              child: Container(
                // height: context.isTabletLandsCape ? 80.h : 48.h,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.borderColor,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isLargeScreen
                          ? SizedBox(
                              child: SvgPicture.asset(
                                Assets.svgs.searchNormal,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: SvgPicture.asset(
                                Assets.svgs.searchNormal,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Gap(12.w),
                      Expanded(
                        child: Consumer(builder: (context, ref, _) {
                          Timer? searchTimer;
                          return TextField(
                            onChanged: (value) {
                              searchTimer?.cancel();
                              searchTimer = Timer(
                                const Duration(seconds: 1),
                                () {
                                  onChange(value);
                                },
                              );
                            },
                            style: isLargeScreen
                                ? AppTextStyle.normalBody
                                    .copyWith(fontSize: 12.sp)
                                : AppTextStyle.normalBody
                                    .copyWith(fontSize: 14.sp),
                            decoration: InputDecoration(
                              hintText: S.of(context).search,
                              hintStyle: isLargeScreen
                                  ? AppTextStyle.normalBody.copyWith(
                                      fontSize: 12.sp,
                                      color: AppColor.borderColor,
                                    )
                                  : AppTextStyle.normalBody.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColor.borderColor,
                                    ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          );
                        }),
                      ),
                    ]),
              ),
            ),
          ),
          Gap(16.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.borderColor,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Consumer(builder: (context, ref, _) {
              return ref.watch(purchasePDFProvider)
                  ? SizedBox(
                      height: 25.r,
                      width: 25.r,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : InkWell(
                      onTap: () => onPrint(),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: SvgPicture.asset(
                              Assets.svgs.printer,
                            ),
                          ),
                          Gap(8.w),
                          Text(
                            S.of(context).print,
                            style: AppTextStyle.normalBody.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
