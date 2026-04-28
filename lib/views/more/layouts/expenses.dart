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
import 'package:readypos_flutter/controllers/more_controller.dart/expense_controller.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/more_providers.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/purchase_controller.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/sales_controller.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/more/expense_model.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/more/components/filter_drawer.dart';
import 'package:readypos_flutter/views/more/components/moreAppBar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String? searchStr;
  int page = 1;
  List<ExpenseModel> listData = [];
  final showIndicatorProvider = StateProvider<bool>((ref) {
    return false;
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(expenseControllerProvider.notifier)
          .getExpense(page: page)
          .then((value) {
        listData = ref.read(expenseControllerProvider.notifier).expenseList;
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
          columnName: 'warehouse',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).warehouse,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'category',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).category,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'amount',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).amount,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'note',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).note,
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
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
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
              title: S.of(context).expenses,
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
                      .read(expenseControllerProvider.notifier)
                      .getExpense(searchQuery: str)
                      .then((value) {
                    listData.addAll(ref
                        .watch(expenseControllerProvider.notifier)
                        .expenseList);
                    setState(() {
                      searchStr = str;
                    });
                  });
                } else {
                  ref
                      .read(expenseControllerProvider.notifier)
                      .getExpense(page: page, perPage: 20)
                      .then((value) {
                    listData.addAll(ref
                        .watch(expenseControllerProvider.notifier)
                        .expenseList);
                    setState(() {
                      searchStr = null;
                    });
                  });
                }
              },
              onPrint: () {
                if (listData.isNotEmpty) {
                  ref.read(salesPDFProvider.notifier).getSalesPDF(data: {
                    "start_date": ref.read(startDateProvider('expenses')),
                    "end_date": ref.read(endDateProvider('expenses')),
                    "warehouse_id": ref.read(warehouseIdProvider('expenses')),
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
        flag: 'expenses',
        onApply: () {
          listData.clear();
          listData.addAll(
              ref.watch(expenseControllerProvider.notifier).expenseList);
          setState(() {});
        },
        onReset: () {
          listData.clear();
          page = 1;
          ref
              .read(expenseControllerProvider.notifier)
              .getExpense(page: page, perPage: 20)
              .then((value) {
            listData.addAll(
                ref.watch(expenseControllerProvider.notifier).expenseList);
            setState(() {});
          });
        },
      ),
      body: Consumer(builder: (context, ref, _) {
        final loading = ref.watch(expenseControllerProvider);

        final double totalExpense =
            ref.watch(expenseControllerProvider.notifier).totalExpense;
        final expenseDataSource =
            ExpenseDataSource(expenseData: listData, ref: ref);
        final startDate = ref.watch(startDateProvider("expenses"));
        final endDate = ref.watch(endDateProvider("expenses"));
        return Column(
          children: [
            Container(
              height: 52.h,
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AdaptiveTheme.of(context).mode.isDark
                    ? AppColor.darkBackgroundColor
                    : AppColor.whiteColor,
                border: const Border(
                  left: BorderSide(color: Color(0xFFDFF0FF)),
                  top: BorderSide(width: 1, color: Color(0xFFDFF0FF)),
                  right: BorderSide(color: Color(0xFFDFF0FF)),
                  bottom: BorderSide(color: Color(0xFFDFF0FF)),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (startDate != '' || endDate != '')
                      ? Row(
                          children: [
                            Text('$startDate - $endDate',
                                style: AppTextStyle.smallBody),
                            SizedBox(width: 8.w),
                            Container(
                              width: 6.h,
                              height: 6.h,
                              decoration: const ShapeDecoration(
                                color: AppColor.borderColor,
                                shape: OvalBorder(),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  SizedBox(width: 8.w),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).totalExpense,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 0.10,
                          letterSpacing: 0.28,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        totalExpense.toString(),
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          height: 0.10,
                          letterSpacing: 0.28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: loading && page == 1
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : listData.isEmpty
                      ? Center(
                          child: Text("No data found",
                              style: TextStyle(
                                  fontSize: isLargeScreen ? 12.sp : 14.sp)),
                        )
                      : SfDataGridTheme(
                          data: const SfDataGridThemeData(
                              headerColor: AppColor.primaryColor),
                          child: SfDataGrid(
                            source: expenseDataSource,
                            showSortNumbers: true,
                            columnWidthMode: ColumnWidthMode.auto,
                            columns: getColumns(),
                            loadMoreViewBuilder: (BuildContext context,
                                LoadMoreRows loadMoreRows) {
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
                                              .watch(expenseControllerProvider
                                                  .notifier)
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
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.26),
                                              ),
                                            ),
                                          ),
                                          child: SizedBox(
                                            height: 36.0,
                                            width: 142.0,
                                            child: MaterialButton(
                                              color: Colors.blue,
                                              child: const Text('LOAD MORE',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                if (context
                                                        is StatefulElement &&
                                                    context.state.mounted) {
                                                  page++;
                                                }
                                                ref
                                                    .read(showIndicatorProvider
                                                        .notifier)
                                                    .state = true;

                                                await ref
                                                    .read(
                                                        expenseControllerProvider
                                                            .notifier)
                                                    .getExpense(page: page)
                                                    .then((value) {
                                                  listData.addAll(ref
                                                      .read(
                                                          expenseControllerProvider
                                                              .notifier)
                                                      .expenseList);
                                                  ref
                                                      .read(
                                                          showIndicatorProvider
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
                        ),
            ),
          ],
        );
      }),
    );
  }
}

class ExpenseDataSource extends DataGridSource {
  final WidgetRef ref;

  /// Creates the employee data source class with required details.
  ExpenseDataSource(
      {required List<ExpenseModel> expenseData, required this.ref}) {
    _expenseData = expenseData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'index',
                  value: "${expenseData.indexOf(e) + 1}".padLeft(2, "0")),
              DataGridCell<String>(
                  columnName: "date", value: e.date.toString()),
              DataGridCell<String>(
                  columnName: "ref", value: e.referenceNo.toString()),
              DataGridCell<String>(
                  columnName: "warehouse", value: e.wearehouse.toString()),
              DataGridCell<String>(
                  columnName: "category", value: e.category.toString()),
              DataGridCell<String>(
                  columnName: "amount", value: e.amount.toString()),
              DataGridCell<String?>(columnName: "note", value: e.note ?? ''),
            ]))
        .toList();
  }

  List<DataGridRow> _expenseData = [];

  @override
  List<DataGridRow> get rows => _expenseData;

  void _addMoreRows() {
    final list = ref.watch(expenseControllerProvider.notifier).expenseList;
    _expenseData.addAll(list.map<DataGridRow>((e) => DataGridRow(cells: [
          DataGridCell<String>(
              columnName: 'index',
              value: "${_expenseData.length + 1}".padLeft(2, "0")),
          DataGridCell<String>(columnName: 'date', value: e.date ?? ""),
          DataGridCell<String>(columnName: 'ref', value: e.referenceNo ?? ""),
          DataGridCell<String>(
              columnName: 'warehouse', value: e.wearehouse ?? ""),
          DataGridCell<String>(columnName: 'category', value: e.category ?? ""),
          DataGridCell<String>(
              columnName: 'amount', value: e.amount.toString()),
          DataGridCell<String?>(columnName: 'note', value: e.note ?? ""),
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
      int index = _expenseData.indexOf(row);
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
                //  height: context.isTabletLandsCape ? 80.h : 48.h,
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
                          Timer? timer;
                          return TextField(
                            onChanged: (value) {
                              timer?.cancel();
                              timer = Timer(const Duration(seconds: 1), () {
                                onChange(value);
                              });
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
