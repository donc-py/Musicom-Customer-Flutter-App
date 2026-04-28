import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/config/theme.dart';
import 'package:readypos_flutter/controllers/deposit_controller/deposit_provider.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/deposit/account_model.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class DepositPOSScreen extends ConsumerStatefulWidget {
  const DepositPOSScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DepositPOSScreenState();
}

class _DepositPOSScreenState extends ConsumerState<DepositPOSScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  DateTime startDate = DateTime.now();
  void selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: startDate,
      currentDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        startDate = date;
        _formKey.currentState?.patchValue(
          {"date": DateFormat("yyyy/MM/dd").format(date)},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.h,
        title: Text(S.of(context).depositPOSCash),
        surfaceTintColor: AppColor.whiteColor,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        color: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                _amountCard(
                  context: context,
                  title: S.of(context).available,
                  amount: ref.watch(balanceControllerProvider).maybeWhen(
                        data: (data) => data.balance.toStringAsFixed(2),
                        orElse: () => "\$ 0.00",
                      ),
                ),
                Gap(12.w),
                _amountCard(
                  context: context,
                  title: S.of(context).todaysSale,
                  amount: ref.watch(balanceControllerProvider).maybeWhen(
                        data: (data) => data.todaySales.toStringAsFixed(2),
                        orElse: () => "\$ 0.00",
                      ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      Gap(20.h),
                      textFieldHeader(text: S.of(context).paymentMethod),
                      Gap(10.h),
                      FormBuilderDropdown<String>(
                        name: "payment_method",
                        isDense: isLargeScreen ? false : true,
                        items: ["Cash", "Bank"]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
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
                          hintStyle: isLargeScreen
                              ? AppTextStyle.normalBody.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColor.borderColor,
                                )
                              : AppTextStyle.normalBody.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColor.borderColor,
                                ),
                          isDense: false,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      Gap(20.h),
                      Visibility(
                        visible: _formKey.currentState?.fields["payment_method"]
                                ?.value ==
                            "Bank",
                        child: Column(
                          children: [
                            textFieldHeader(text: "Account"),
                            Gap(20.h),
                            Consumer(
                              builder: (context, ref, child) {
                                return ref
                                    .watch(accountsControllerProvider)
                                    .when(
                                      data: (listData) {
                                        return FormBuilderDropdown<
                                            AccountModel>(
                                          name: "account_id",
                                          isDense: isLargeScreen ? false : true,
                                          items: listData
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    "${e.name} (${e.accountNo})",
                                                    style: AppTextStyle
                                                        .normalBody
                                                        .copyWith(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          icon: SvgPicture.asset(
                                            Assets.svgs.arrowDown2,
                                          ),
                                          decoration:
                                              AppTheme.inputDecoration.copyWith(
                                            hintText: "Select",
                                            hintStyle: isLargeScreen
                                                ? AppTextStyle.normalBody
                                                    .copyWith(
                                                    fontSize: 12.sp,
                                                    color: AppColor.borderColor,
                                                  )
                                                : AppTextStyle.normalBody
                                                    .copyWith(
                                                    fontSize: 14.sp,
                                                    color: AppColor.borderColor,
                                                  ),
                                            isDense: false,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 8.h,
                                            ),
                                          ),
                                        );
                                      },
                                      error: (error, stackTrace) {
                                        return const Text("Error");
                                      },
                                      loading: () =>
                                          const CircularProgressIndicator(),
                                    );
                              },
                            ),
                            Gap(20.h),
                          ],
                        ),
                      ),
                      textFieldHeader(text: S.of(context).amount),
                      Gap(10.h),
                      FormBuilderTextField(
                        name: "amount",
                        style: isLargeScreen
                            ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                            : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: "Enter Amount",
                          hintStyle: isLargeScreen
                              ? AppTextStyle.normalBody.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColor.borderColor,
                                )
                              : AppTextStyle.normalBody.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColor.borderColor,
                                ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Amount is required";
                          }
                          return null;
                        },
                      ),
                      Gap(20.h),
                      textFieldHeader(
                          text: S.of(context).purpose, isRequired: false),
                      Gap(10.h),
                      FormBuilderTextField(
                        name: "purpose",
                        style: isLargeScreen
                            ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
                            : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: "Enter Purpose",
                          hintStyle: isLargeScreen
                              ? AppTextStyle.normalBody.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColor.borderColor,
                                )
                              : AppTextStyle.normalBody.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColor.borderColor,
                                ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                      Gap(20.h),
                      textFieldHeader(text: S.of(context).date),
                      Gap(10.h),
                      FormBuilderTextField(
                        name: "date",
                        readOnly: true,
                        onTap: () {
                          selectDate();
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Date is required";
                          }
                          return null;
                        },
                      ),
                      Gap(30.h),
                      SizedBox(
                        width: double.infinity,
                        child: Consumer(builder: (context, ref, child) {
                          final isLoading = ref.watch(balanceTransferProvider);
                          return isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : CustomButton(
                                  onPressed: () {
                                    if (_formKey.currentState
                                            ?.saveAndValidate() ??
                                        false) {
                                      final data = {
                                        ..._formKey.currentState!.value
                                      };
                                      data['account_id'] =
                                          data['account_id']?.id;

                                      ref
                                          .watch(
                                              balanceTransferProvider.notifier)
                                          .depositBalanceTransfer(data: data)
                                          .then((value) {
                                        if (value == true) {
                                          context.nav.pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text("Deposit Successful"),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text("Deposit Failed"),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      });
                                    }
                                  },
                                  text: S.of(context).save,
                                );
                        }),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row textFieldHeader({required String text, bool isRequired = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTextStyle.normalBody,
        ),
        isRequired
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Icon(
                  Icons.star,
                  color: Colors.red,
                  size: 8.w,
                ),
              )
            : const SizedBox()
      ],
    );
  }

  Widget _amountCard(
      {required BuildContext context,
      required String title,
      required String amount}) {
    return Expanded(
      child: Container(
        height: MediaQuery.sizeOf(context).shortestSide > 600
            ? context.isTabletLandsCape
                ? 140.h
                : 85.h
            : 76.h,
        width: double.infinity,
        padding: EdgeInsets.all(8.r),
        decoration: ShapeDecoration(
          color: AdaptiveTheme.of(context).mode.isDark
              ? AppColor.darkBackgroundColor
              : AppColor.greyBackgroundColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.normalBody,
              ),
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: Text(
                amount,
                textAlign: TextAlign.center,
                style: AppTextStyle.title.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
