import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/config/theme.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/pos_controller.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/models/customers_model/customer_group_model.dart';

class AddNewCustomer extends ConsumerStatefulWidget {
  const AddNewCustomer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewCustomerState();
}

class _AddNewCustomerState extends ConsumerState<AddNewCustomer> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final loadingCustomerGroup = ref.watch(customerGroupControllerProvider);
    final loadingAddCustomer = ref.watch(addCustomerControllerProvider);
    final customerGroupList =
        ref.watch(customerGroupControllerProvider.notifier).customerGroupList;
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Customer",
          style: AppTextStyle.title,
        ),
        backgroundColor: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : AppColor.whiteColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AdaptiveTheme.of(context).mode.isDark
              ? AppColor.darkBackgroundColor
              : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          margin: EdgeInsets.only(top: 16.h),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                textFieldHeader(text: "Customer Group"),
                Gap(10.h),
                loadingCustomerGroup
                    ? Container(
                        height: 48.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: AppColor.shimmerColor,
                        ),
                      )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .shimmer(delay: 150.ms)
                    : customerGroupList != null
                        ? FormBuilderDropdown<CustomerGroupModel>(
                            name: "group",
                            items: customerGroupList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name ?? "",
                                      style: isLargeScreen
                                          ? AppTextStyle.normalBody
                                          : AppTextStyle.normalBody.copyWith(
                                              fontSize: 15.sp,
                                            ),
                                    ),
                                  ),
                                )
                                .toList(),
                            icon: SvgPicture.asset(
                              Assets.svgs.arrowDown2,
                              height: isLargeScreen
                                  ? context.isTabletLandsCape
                                      ? 18.r
                                      : 12.r
                                  : 10.r,
                            ),
                            decoration: AppTheme.inputDecoration.copyWith(
                              hintText: "Select",
                              hintStyle: isLargeScreen
                                  ? AppTextStyle.normalBody.copyWith(
                                      color: const Color(0xffD1D5DB),
                                      fontSize: 13.sp,
                                    )
                                  : AppTextStyle.normalBody.copyWith(
                                      color: const Color(0xffD1D5DB),
                                      fontSize: 15.sp,
                                    ),
                              isDense: true,
                              contentPadding: isLargeScreen
                                  ? null
                                  : EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 8.h,
                                    ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Customer Group is required";
                              }
                              return null;
                            },
                          )
                        : Text(
                            "No Customer Group Found",
                            style: AppTextStyle.normalBody,
                          ),
                Gap(20.h),
                textFieldHeader(text: "Name"),
                Gap(10.h),
                FormBuilderTextField(
                  name: "name",
                  decoration: AppTheme.inputDecoration.copyWith(
                    hintText: "Enter Name",
                    hintStyle: AppTextStyle.normalBody.copyWith(
                      color: const Color(0xffD1D5DB),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                Gap(20.h),
                textFieldHeader(text: "Phone Number"),
                Gap(10.h),
                FormBuilderTextField(
                  name: "phone",
                  keyboardType: TextInputType.number,
                  decoration: AppTheme.inputDecoration.copyWith(
                    hintText: "Enter Phone Number",
                    hintStyle: AppTextStyle.normalBody.copyWith(
                      color: const Color(0xffD1D5DB),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone Number is required";
                    }
                    return null;
                  },
                ),
                // for email
                Gap(20.h),
                textFieldHeader(text: "Email"),
                Gap(10.h),
                FormBuilderTextField(
                  name: "email",
                  keyboardType: TextInputType.emailAddress,
                  decoration: AppTheme.inputDecoration.copyWith(
                    hintText: "Enter Email",
                    hintStyle: AppTextStyle.normalBody.copyWith(
                      color: const Color(0xffD1D5DB),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                Gap(40.h),
                SizedBox(
                  width: double.infinity,
                  child: loadingAddCustomer
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              final groupId =
                                  _formKey.currentState!.value['group'];
                              final Map<String, dynamic> formData = {
                                "name": _formKey.currentState!.value['name'],
                                "phone_number":
                                    _formKey.currentState!.value['phone'],
                                "email": _formKey.currentState!.value['email'],
                                "customer_group_id": groupId.id,
                              };

                              ref
                                  .read(addCustomerControllerProvider.notifier)
                                  .addCustomer(data: formData)
                                  .then((value) {
                                if (value) {
                                  ref
                                      .refresh(
                                          customerControllerProvider.notifier)
                                      .getCustomers();
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          text: "Save",
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row textFieldHeader({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTextStyle.normalBody,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Icon(
            Icons.star,
            color: Colors.red,
            size: 8.w,
          ),
        )
      ],
    );
  }
}
