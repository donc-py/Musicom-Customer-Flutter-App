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
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/more/purchase_model.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/more/components/filter_drawer.dart';
import 'package:readypos_flutter/views/more/components/moreAppBar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

class PurchasesScreen extends ConsumerStatefulWidget {
  const PurchasesScreen({super.key});

  @override
  ConsumerState<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends ConsumerState<PurchasesScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String? searchStr;
  int page = 1;
  List<PurchaseModel> listData = [];
  final showIndicatorProvider = StateProvider<bool>((ref) {
    return false;
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(purchaseControllerProvider.notifier)
          .getPurchase(page: page)
          .then((value) {
        listData = ref.read(purchaseControllerProvider.notifier).purchaseList;
        setState(() {});
      });
    });
  }

  List<GridColumn> getColumns(BuildContext context) {
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
          columnName: 'supplier',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).supplier,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
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
      GridColumn(
          columnName: 'paid',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).paid,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'status',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).status,
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
              title: S.of(context).purchase,
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
                      .read(purchaseControllerProvider.notifier)
                      .getPurchase(searchQuery: str)
                      .then((value) {
                    listData.addAll(ref
                        .watch(purchaseControllerProvider.notifier)
                        .purchaseList);
                    setState(() {
                      searchStr = str;
                    });
                  });
                } else {
                  ref
                      .read(purchaseControllerProvider.notifier)
                      .getPurchase(page: page, perPage: 20)
                      .then((value) {
                    listData.addAll(ref
                        .watch(purchaseControllerProvider.notifier)
                        .purchaseList);
                    setState(() {
                      searchStr = null;
                    });
                  });
                }
              },
              onPrint: () {
                if (listData.isNotEmpty) {
                  ref.read(purchasePDFProvider.notifier).getPurchasePDF(data: {
                    "start_date": ref.read(startDateProvider('purchase')),
                    "end_date": ref.read(endDateProvider('purchase')),
                    "warehouse_id": ref.read(warehouseIdProvider('purchase')),
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
        flag: "purchase",
        onApply: () {
          listData.clear();
          listData.addAll(
              ref.watch(purchaseControllerProvider.notifier).purchaseList);
          setState(() {});
        },
        onReset: () {
          listData.clear();
          page = 1;
          ref
              .read(purchaseControllerProvider.notifier)
              .getPurchase(page: page, perPage: 20)
              .then((value) {
            listData.addAll(
                ref.watch(purchaseControllerProvider.notifier).purchaseList);
            setState(() {});
          });
        },
      ),
      body: Consumer(builder: (context, ref, _) {
        final loading = ref.watch(purchaseControllerProvider);
        final purchaseDataSource = PurchaseDataSource(data: listData, ref: ref);
        return loading && page == 1
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : listData.isEmpty
                ? Center(
                    child: Text(
                      "No data found",
                      style: TextStyle(
                        fontSize: isLargeScreen ? 12.sp : 14.sp,
                      ),
                    ),
                  )
                : SfDataGridTheme(
                    data: const SfDataGridThemeData(
                        headerColor: AppColor.primaryColor),
                    child: SfDataGrid(
                      source: purchaseDataSource,
                      showSortNumbers: true,
                      columnWidthMode: ColumnWidthMode.auto,
                      columns: getColumns(context),
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
                                        .watch(
                                            purchaseControllerProvider.notifier)
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
                                              .read(purchaseControllerProvider
                                                  .notifier)
                                              .getPurchase(page: page)
                                              .then((value) {
                                            listData.addAll(ref
                                                .read(purchaseControllerProvider
                                                    .notifier)
                                                .purchaseList);
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

class PurchaseDataSource extends DataGridSource {
  final WidgetRef ref;

  /// Creates the employee data source class with required details.
  PurchaseDataSource({required List<PurchaseModel> data, required this.ref}) {
    _purchaseData = data
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'index',
                  value: "${data.indexOf(e) + 1}".padLeft(2, "0")),
              DataGridCell<String>(columnName: 'date', value: e.date ?? ""),
              DataGridCell<String>(
                  columnName: 'ref', value: e.referenceNo ?? ""),
              DataGridCell<String>(
                  columnName: 'supplier', value: e.supplier ?? ""),
              DataGridCell<double>(
                  columnName: 'grandTotal', value: e.grandTotal ?? 0),
              DataGridCell<double>(
                  columnName: 'paid', value: e.paidAmount ?? 0),
              DataGridCell<String>(columnName: 'status', value: e.status ?? ""),
              // const DataGridCell<Widget>(columnName: 'action', value: null),
            ]))
        .toList();
  }

  List<DataGridRow> _purchaseData = [];

  @override
  List<DataGridRow> get rows => _purchaseData;

  void _addMoreRows() {
    final list = ref.watch(purchaseControllerProvider.notifier).purchaseList;
    _purchaseData.addAll(list.map<DataGridRow>((e) => DataGridRow(cells: [
          DataGridCell<String>(
              columnName: 'index',
              value: "${_purchaseData.length + 1}".padLeft(2, "0")),
          DataGridCell<String>(columnName: 'date', value: e.date ?? ""),
          DataGridCell<String>(columnName: 'ref', value: e.referenceNo ?? ""),
          DataGridCell<String>(columnName: 'supplier', value: e.supplier ?? ""),
          DataGridCell<double>(
              columnName: 'grandTotal', value: e.grandTotal ?? 0),
          DataGridCell<double>(columnName: 'paid', value: e.paidAmount ?? 0),
          DataGridCell<String>(columnName: 'status', value: e.status ?? ""),
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
      int index = _purchaseData.indexOf(row);
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
      return e.columnName == 'action'
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
              return IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                            content: SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [Text("Nothing is Here")],
                                ))));
                  },
                  icon: const Icon(Icons.more_horiz));
            })
          : e.columnName == 'status'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      color: e.value == "Paid" ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    // padding: MediaQuery.sizeOf(context).shortestSide > 600
                    //     ? EdgeInsets.all(8.r)
                    //     : null,
                    margin: MediaQuery.sizeOf(context).shortestSide > 600
                        ? context.isTabletLandsCape
                            ? EdgeInsets.all(12.r)
                            : EdgeInsets.all(8.r)
                        : EdgeInsets.all(12.r),
                    alignment: Alignment.center,
                    child: Text(
                      e.value.toString(),
                      style: AppTextStyle.normalBody.copyWith(
                        color: Colors.white,
                        fontSize: MediaQuery.sizeOf(context).shortestSide > 600
                            ? 8.sp
                            : 12.sp,
                      ),
                    ),
                  );
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
  // onchange call back function
  Function(String) onChange;
  Function onPrint;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
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
