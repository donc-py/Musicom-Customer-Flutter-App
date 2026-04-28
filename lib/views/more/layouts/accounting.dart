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
import 'package:readypos_flutter/controllers/more_controller.dart/accounts_controller.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/more/account_model.dart';
import 'package:readypos_flutter/models/more/balance_sheet_model.dart';
import 'package:readypos_flutter/models/more/money_transfer_model.dart';
import 'package:readypos_flutter/views/more/components/filter_drawer.dart';
import 'package:readypos_flutter/views/more/components/moreAppBar.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AccountingScreen extends ConsumerStatefulWidget {
  const AccountingScreen({super.key});

  @override
  ConsumerState<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends ConsumerState<AccountingScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(accountingControllerProvider(currentIndex).notifier)
          .getAccounts();
    });
  }

  List<String> buttons(context) => [
        S.of(context).accounts,
        S.of(context).moneyTransfer,
        S.of(context).balanceSheet,
      ];

  List<GridColumn> getAccountColums() {
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
        columnName: 'accountNo',
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            S.of(context).accountNo,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      GridColumn(
          columnName: 'name',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).name,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'balance',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).balanceSheet,
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
                overflow: TextOverflow.ellipsis,
              ))),
    ];
  }

  List<GridColumn> getBalanceColums() {
    return <GridColumn>[
      GridColumn(
        columnName: 'name',
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            S.of(context).name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      GridColumn(
        columnName: 'accountNo',
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            S.of(context).accountNo,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      GridColumn(
          columnName: 'debit',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).debit,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'credit',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).credit,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'balance',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).balanceSheet,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ))),
    ];
  }

  List<GridColumn> getMoneyTransferColums() {
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
          columnName: 'from',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).from,
                style: const TextStyle(color: Colors.white),
              ))),
      GridColumn(
          columnName: 'to',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                S.of(context).to,
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
                overflow: TextOverflow.ellipsis,
              ))),
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
              : 168.h - MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: [
            MoreAppBar(
              title: S.of(context).accounting,
            ),
            _SearchBar(currentIndex: currentIndex),
          ],
        ),
      ),
      endDrawer: FilterDrawer(
        flag: 'accounting',
      ),
      body: Column(
        children: [
          Container(
            // height: context.isTabletLandsCape ? 120.h : 80.h,
            width: double.infinity,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AdaptiveTheme.of(context).mode.isDark
                  ? AppColor.darkBackgroundColor
                  : AppColor.whiteColor,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  buttons(context).length,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                      });
                      ref
                          .read(accountingControllerProvider(currentIndex)
                              .notifier)
                          .getAccounts();
                    },
                    child: Container(
                      // height: context.isTabletLandsCape ? 90.h : 48.h,
                      padding: EdgeInsets.all(10.r),
                      margin: EdgeInsets.only(right: 10.w),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? AppColor.darkBackgroundColor
                            : AppColor.whiteColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.r,
                            color: currentIndex == index
                                ? AppColor.primaryColor
                                : AppColor.borderColor,
                          ),
                          borderRadius: BorderRadius.circular(48.r),
                        ),
                      ),
                      child: Text(
                        buttons(context)[index],
                        textAlign: TextAlign.center,
                        style: AppTextStyle.normalBody.copyWith(
                          color: currentIndex == index
                              ? AppColor.primaryColor
                              : AdaptiveTheme.of(context).mode.isDark
                                  ? AppColor.whiteColor
                                  : AppColor.darkBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              children: [
                if (currentIndex == 0) ...[
                  Consumer(builder: (context, ref, _) {
                    final loading =
                        ref.watch(accountingControllerProvider(currentIndex));
                    final accountList = ref
                        .watch(
                            accountingControllerProvider(currentIndex).notifier)
                        .accountList;
                    final accountDataSource =
                        AccountDataSource(accountData: accountList);
                    return loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : accountList.isEmpty
                            ? Center(
                                child: Text("No data found",
                                    style: TextStyle(
                                        fontSize:
                                            isLargeScreen ? 12.sp : 14.sp)),
                              )
                            : SfDataGridTheme(
                                data: const SfDataGridThemeData(
                                    headerColor: AppColor.primaryColor),
                                child: SfDataGrid(
                                  controller: DataGridController(),
                                  source: accountDataSource,
                                  showSortNumbers: true,
                                  columnWidthMode: ColumnWidthMode.auto,
                                  columns: getAccountColums(),
                                ),
                              );
                  }),
                ],
                if (currentIndex == 1) ...[
                  Consumer(builder: (context, ref, _) {
                    final loading =
                        ref.watch(accountingControllerProvider(currentIndex));
                    final moneyList = ref
                        .watch(
                            accountingControllerProvider(currentIndex).notifier)
                        .moneyTransferList;
                    final moneyDataSource =
                        MoneyTransferDataSource(moneyData: moneyList);
                    return loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : moneyList.isEmpty
                            ? Center(
                                child: Text("No data found",
                                    style: TextStyle(
                                        fontSize:
                                            isLargeScreen ? 12.sp : 14.sp)),
                              )
                            : SfDataGridTheme(
                                data: const SfDataGridThemeData(
                                    headerColor: AppColor.primaryColor),
                                child: SfDataGrid(
                                  controller: DataGridController(),
                                  source: moneyDataSource,
                                  showSortNumbers: true,
                                  columnWidthMode: ColumnWidthMode.auto,
                                  columns: getMoneyTransferColums(),
                                ),
                              );
                  }),
                ],
                if (currentIndex == 2) ...[
                  Consumer(builder: (context, ref, _) {
                    final loading =
                        ref.watch(accountingControllerProvider(currentIndex));
                    final balanceList = ref
                        .watch(
                            accountingControllerProvider(currentIndex).notifier)
                        .balanceSheetList;
                    final balanceDataSource =
                        BalanceSource(balanceData: balanceList);
                    return loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : balanceList.isEmpty
                            ? Center(
                                child: Text(
                                  "No data found",
                                  style: TextStyle(
                                      fontSize: isLargeScreen ? 12.sp : 14.sp),
                                ),
                              )
                            : SfDataGridTheme(
                                data: const SfDataGridThemeData(
                                    headerColor: AppColor.primaryColor),
                                child: SfDataGrid(
                                  controller: DataGridController(),
                                  source: balanceDataSource,
                                  showSortNumbers: true,
                                  columnWidthMode: ColumnWidthMode.auto,
                                  columns: getBalanceColums(),
                                ),
                              );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountDataSource extends DataGridSource {
  AccountDataSource({required List<AccountModel> accountData}) {
    _accountData = accountData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'index',
                  value: "${accountData.indexOf(e) + 1}".padLeft(2, "0")),
              DataGridCell<String>(columnName: 'accountNo', value: e.accountNo),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'balance', value: e.totalBalance.toString()),
              DataGridCell<String>(columnName: 'note', value: e.note),
            ]))
        .toList();
  }

  List<DataGridRow> _accountData = [];

  @override
  List<DataGridRow> get rows => _accountData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getBackgroundColor(BuildContext context) {
      int index = _accountData.indexOf(row);
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
      return LayoutBuilder(
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

class BalanceSource extends DataGridSource {
  BalanceSource({required List<BalanceSheetModel> balanceData}) {
    _balanceData = balanceData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'accountNo', value: e.accountNo),
              DataGridCell<String>(
                  columnName: 'debit', value: e.debit.toString()),
              DataGridCell<String>(
                  columnName: 'credit', value: e.credit.toString()),
              DataGridCell<String>(
                  columnName: 'balance', value: e.balance.toString()),
            ]))
        .toList();
  }

  List<DataGridRow> _balanceData = [];

  @override
  List<DataGridRow> get rows => _balanceData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getBackgroundColor(BuildContext context) {
      int index = _balanceData.indexOf(row);
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
      return LayoutBuilder(
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

class MoneyTransferDataSource extends DataGridSource {
  MoneyTransferDataSource({required List<MoneyTransferModel> moneyData}) {
    _moneyData = moneyData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'index',
                  value: "${moneyData.indexOf(e) + 1}".padLeft(2, "0")),
              DataGridCell<String>(
                  columnName: 'date', value: e.date.toString()),
              DataGridCell<String>(
                  columnName: 'ref', value: e.referenceNo.toString()),
              DataGridCell<String>(
                  columnName: 'from', value: e.from.toString()),
              DataGridCell<String>(columnName: 'to', value: e.to.toString()),
              DataGridCell<String>(
                  columnName: 'amount', value: e.amount.toString()),
            ]))
        .toList();
  }

  List<DataGridRow> _moneyData = [];

  @override
  List<DataGridRow> get rows => _moneyData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getBackgroundColor(BuildContext context) {
      int index = _moneyData.indexOf(row);
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
      return LayoutBuilder(
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

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Container(
      // height: context.isTabletLandsCape ? 110.h : 70.h,
      color: AdaptiveTheme.of(context).mode.isDark
          ? AppColor.darkBackgroundColor
          : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
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
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                    timer = Timer(const Duration(milliseconds: 500), () {
                      ref
                          .read(accountingControllerProvider(currentIndex)
                              .notifier)
                          .getAccounts(searchQuery: value);
                    });
                  },
                  style: isLargeScreen
                      ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                      : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
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
    );
  }
}
