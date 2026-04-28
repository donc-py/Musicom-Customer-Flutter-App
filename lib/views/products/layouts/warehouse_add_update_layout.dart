// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/components/custom_text_field.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/warehouse_controller/warehouse.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/warehouse/add_update_warehouse.dart';
import 'package:readypos_flutter/models/warehouse/warehouse.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/utils/global_function.dart';

class WarehouseAddUpdateLayout extends StatefulWidget {
  final Warehouse? warehouse;
  const WarehouseAddUpdateLayout({
    super.key,
    this.warehouse,
  });

  @override
  State<WarehouseAddUpdateLayout> createState() =>
      _WarehouseAddUpdateLayoutState();
}

class _WarehouseAddUpdateLayoutState extends State<WarehouseAddUpdateLayout> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emalController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  void initState() {
    if (widget.warehouse != null) {
      nameController.text = widget.warehouse!.name ?? '';
      phoneController.text = widget.warehouse!.phone ?? '';
      emalController.text = widget.warehouse!.email ?? '';
      addressController.text = widget.warehouse!.address ?? '';
    }
    super.initState();
  }

  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        toolbarHeight: 80.h,
        title: Text(
          S.of(context).newWarehouse,
          style: AppTextStyle.title,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 14.h),
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              color: AdaptiveTheme.of(context).mode.isDark
                  ? AppColor.darkBackgroundColor
                  : Colors.white,
              child: FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      title: S.of(context).name,
                      hint: S.of(context).enterWarehouseName,
                      controller: nameController,
                      validator: (value) => GlobalFunction.defaultValidator(
                        value: value!,
                        hintText: S.of(context).name,
                        context: context,
                      ),
                    ),
                    Gap(24.h),
                    CustomTextField(
                      title: S.of(context).phoneNumber,
                      hint: S.of(context).enterPhoneNumber,
                      controller: phoneController,
                      validator: (value) => GlobalFunction.defaultValidator(
                        value: value!,
                        hintText: S.of(context).phoneNumber,
                        context: context,
                      ),
                    ),
                    Gap(24.h),
                    CustomTextField(
                      title: S.of(context).email,
                      hint: S.of(context).enterEmailAddress,
                      controller: emalController,
                      validator: (value) => GlobalFunction.defaultValidator(
                        value: value!,
                        hintText: S.of(context).email,
                        context: context,
                      ),
                    ),
                    Gap(24.h),
                    CustomTextField(
                      title: S.of(context).address,
                      hint: S.of(context).enterWarehouseAddress,
                      minLine: 3,
                      textInputAction: TextInputAction.done,
                      controller: addressController,
                      validator: (value) => GlobalFunction.defaultValidator(
                        value: value!,
                        hintText: S.of(context).address,
                        context: context,
                      ),
                    ),
                    Gap(32.h),
                    Consumer(builder: (context, ref, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: ref.watch(warehouseControllerProvider)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : CustomButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    final AddWarehouseModel warehouse =
                                        AddWarehouseModel(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emalController.text,
                                      address: addressController.text,
                                    );
                                    if (widget.warehouse != null) {
                                      ref
                                          .read(warehouseControllerProvider
                                              .notifier)
                                          .updateWarehouse(
                                            warehouse: warehouse,
                                            id: widget.warehouse!.id,
                                          )
                                          .then((response) {
                                        if (response.isSuccess) {
                                          context.nav.pop();
                                          ref
                                              .read(warehouseControllerProvider
                                                  .notifier)
                                              .getWarehouses(
                                                page: 1,
                                                perPage: 15,
                                                search: null,
                                                pagination: false,
                                              );
                                        }
                                        GlobalFunction.showCustomSnackbar(
                                            message: response.message,
                                            isSuccess: response.isSuccess);
                                      });
                                    } else {
                                      ref
                                          .read(warehouseControllerProvider
                                              .notifier)
                                          .addWarehouse(
                                            warehouse: warehouse,
                                          )
                                          .then((response) {
                                        if (response.isSuccess) {
                                          context.nav.pop();
                                          ref
                                              .read(warehouseControllerProvider
                                                  .notifier)
                                              .getWarehouses(
                                                page: 1,
                                                perPage: 15,
                                                search: null,
                                                pagination: false,
                                              );
                                        }
                                        GlobalFunction.showCustomSnackbar(
                                          message: response.message,
                                          isSuccess: response.isSuccess,
                                        );
                                      });
                                    }
                                  }
                                },
                                text: S.of(context).save,
                              ),
                      );
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
