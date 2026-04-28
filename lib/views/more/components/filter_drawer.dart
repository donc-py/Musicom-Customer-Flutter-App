import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/config/theme.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/expense_controller.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/more_providers.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/purchase_controller.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/sales_controller.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/warehouse_controller.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:intl/intl.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/warehouse_model.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class FilterDrawer extends ConsumerStatefulWidget {
  FilterDrawer({
    super.key,
    required this.flag,
    this.onApply,
    this.onReset,
  });
  final String flag;
  Function? onApply;
  Function? onReset;

  @override
  ConsumerState<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends ConsumerState<FilterDrawer> {
  final _formKey = GlobalKey<FormBuilderState>();

  void startSelectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: ref.read(startDateProvider(widget.flag)) != ''
          ? DateFormat("dd-MM-yyyy")
              .parse(ref.read(startDateProvider(widget.flag))!)
          : DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final formatedDate = DateFormat("dd-MM-yyyy").format(date);
      setState(() {
        ref.read(startDateProvider(widget.flag).notifier).state = formatedDate;
        _formKey.currentState?.patchValue(
          {"startDate": formatedDate},
        );
      });
    }
  }

  void endSelectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: ref.read(endDateProvider(widget.flag)) != ''
          ? DateFormat("dd-MM-yyyy")
              .parse(ref.read(endDateProvider(widget.flag))!)
          : DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final formatedDate = DateFormat("dd-MM-yyyy").format(date);
      setState(() {
        ref.read(endDateProvider(widget.flag).notifier).state = formatedDate;
        _formKey.currentState?.patchValue(
          {"endDate": formatedDate},
        );
      });
    }
  }

  Row textFieldHeader({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTextStyle.normalBody,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Container(
      color: AppColor.whiteColor,
      width: 322.w,
      height: 1.sh,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: FormBuilder(
        key: _formKey,
        initialValue: {
          "startDate": ref.read(startDateProvider(widget.flag)),
          "endDate": ref.read(endDateProvider(widget.flag)),
        },
        child: Column(
          children: [
            Gap(48.h),
            Row(
              children: [
                Text(S.of(context).filter, style: AppTextStyle.title),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Gap(28.h),
            textFieldHeader(text: S.of(context).start),
            Gap(10.h),
            FormBuilderTextField(
              name: "startDate",
              readOnly: true,
              onTap: () {
                startSelectDate();
              },
              style: isLargeScreen
                  ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                  : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
              decoration: AppTheme.inputDecoration.copyWith(
                hintText: "DD/MM/YYYY",
                hintStyle: AppTextStyle.normalBody.copyWith(
                  color: const Color(0xffD1D5DB),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                isDense: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    Assets.svgs.calendar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Gap(16.h),
            textFieldHeader(text: S.of(context).end),
            Gap(10.h),
            FormBuilderTextField(
              name: "endDate",
              readOnly: true,
              onTap: () {
                endSelectDate();
              },
              style: isLargeScreen
                  ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                  : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
              decoration: AppTheme.inputDecoration.copyWith(
                hintText: "DD/MM/YYYY",
                hintStyle: AppTextStyle.normalBody.copyWith(
                  color: const Color(0xffD1D5DB),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                isDense: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    Assets.svgs.calendar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Gap(16.h),
            textFieldHeader(text: S.of(context).warehouse),
            Gap(10.h),
            Consumer(builder: (context, ref, _) {
              final loading = ref.watch(warehouseControllerProvider);
              final warehouseList =
                  ref.watch(warehouseControllerProvider.notifier).warehouseList;
              final warehouseId = ref.watch(warehouseIdProvider(widget.flag));
              return loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : FormBuilderDropdown<WarehouseModel>(
                      name: "warehouse",
                      isDense: isLargeScreen ? false : true,
                      initialValue: warehouseId != null
                          ? warehouseList.firstWhere(
                              (element) => element.id == warehouseId)
                          : null,
                      items: warehouseList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.name ?? '',
                                style: AppTextStyle.normalBody.copyWith(
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      icon: SvgPicture.asset(
                        Assets.svgs.arrowDown2,
                      ),
                      decoration: AppTheme.inputDecoration.copyWith(
                        hintText: "Select",
                        hintStyle: AppTextStyle.normalBody.copyWith(
                          color: const Color(0xffD1D5DB),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                      ),
                      onChanged: (value) {
                        ref
                            .read(warehouseIdProvider(widget.flag).notifier)
                            .state = value?.id ?? 0;
                      },
                    );
            }),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      clearFileds(widget.flag);
                      context.nav.pop();
                    },
                    height: 48.h,
                    color: AppColor.greyBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      S.of(context).reset,
                      style: AppTextStyle.normalBody.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      filterData(widget.flag);
                      context.nav.pop();
                    },
                    height: 48.h,
                    color: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      S.of(context).apply,
                      style: AppTextStyle.normalBody.copyWith(
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(30.h),
          ],
        ),
      ),
    );
  }

  void filterData(String flag) {
    switch (flag) {
      case "purchase":
        ref.read(purchaseControllerProvider.notifier).filterPurchase(query: {
          "start_date": ref.read(startDateProvider(flag)),
          "end_date": ref.read(endDateProvider(flag)),
          "warehouse_id": ref.read(warehouseIdProvider(flag)),
        }).then((value) => widget.onApply?.call());
        break;

      case "sales":
        ref.read(salesControllerProvider.notifier).filterSales(query: {
          "start_date": ref.read(startDateProvider(flag)),
          "end_date": ref.read(endDateProvider(flag)),
          "warehouse_id": ref.read(warehouseIdProvider(flag)),
        }).then((value) => widget.onApply?.call());
        break;

      case "expenses":
        ref.read(expenseControllerProvider.notifier).filterSales(query: {
          "start_date": ref.read(startDateProvider(flag)),
          "end_date": ref.read(endDateProvider(flag)),
          "warehouse_id": ref.read(warehouseIdProvider(flag)),
        }).then((value) => widget.onApply?.call());
        break;
    }
  }

  void clearFileds(String flag) {
    switch (flag) {
      case "purchase":
        ref.invalidate(startDateProvider(flag));
        ref.invalidate(endDateProvider(flag));
        ref.invalidate(warehouseIdProvider(flag));
        widget.onReset?.call();
        break;

      case "sales":
        ref.invalidate(startDateProvider(flag));
        ref.invalidate(endDateProvider(flag));
        ref.invalidate(warehouseIdProvider(flag));
        widget.onReset?.call();
        break;

      case "expenses":
        ref.invalidate(startDateProvider(flag));
        ref.invalidate(endDateProvider(flag));
        ref.invalidate(warehouseIdProvider(flag));
        widget.onReset?.call();
        break;
    }
    // Refresh again
    ref.read(purchaseControllerProvider.notifier).getPurchase();
  }
}
