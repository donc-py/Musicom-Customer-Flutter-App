import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/components/text_field_header.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/config/theme.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/more_controller.dart/more_providers.dart';
import 'package:readypos_flutter/controllers/product_controller/product_controller.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/add_product_info_model/add_product_info_model.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
// import 'package:rich_editor/rich_editor.dart';

class AddProductsView extends ConsumerStatefulWidget {
  const AddProductsView({super.key});

  @override
  ConsumerState<AddProductsView> createState() => _AddProductsViewState();
}

class _AddProductsViewState extends ConsumerState<AddProductsView> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey2 = GlobalKey<FormBuilderState>();
  final _formKey3 = GlobalKey<FormBuilderState>();
  // final GlobalKey<RichEditorState> _keyEditor = GlobalKey<RichEditorState>();

  void resetAllFields() {
    _formKey.currentState?.patchValue(
      {
        'name': '',
        "type": null,
        'code': '',
        'barcode_symbology': '',
        'brand_id': null,
        'category_id': null,
        'unit_id': null,
        'sale_unit_id': null,
        'purchase_unit_id': null,
        'cost': '',
        'price': '',
        'alert_quantity': '',
      },
    );
    // reset image
    ref.read(pickedImageProvider.notifier).state = null;
    // reset extra info
    _formKey2.currentState?.patchValue(
      {
        'tax_id': null,
        'tax_method': null,
      },
    );

    // reset extra info
    _formKey3.currentState?.patchValue(
      {
        'variant': false,
        'promotion': false,
        'is_batch': false,
        'starting_date': '',
        'last_date': '',
        'promotion_price': '',
      },
    );

    // reset editor
    // _keyEditor.currentState?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            Text(
              S.of(context).addProducts,
              style: AppTextStyle.title,
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                resetAllFields();
              },
              child: Text(
                S.of(context).reset,
                style: AppTextStyle.normalBody.copyWith(
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
      body: ref.watch(addProductInfoProvider).when(
            data: (info) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Gap(12.r),
                    // section 1
                    _ProductInfoSection(formKey: _formKey, info: info),
                    Gap(12.r),
                    _ProductImageInfoSection(formKey: _formKey2, info: info),
                    Gap(12.r),
                    _ProductExtraInfoSection(formKey: _formKey3),
                    Gap(12.r),
                    // _ProductDetailsSection(keyEditor: _keyEditor),
                    Gap(12.r),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16.r, right: 16.r, bottom: 20.r),
                      width: double.infinity,
                      child: ref.watch(addProductProvider)
                          ? SizedBox(
                              width: 40.r,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : CustomButton(
                              onPressed: () async {
                                // if (_formKey.currentState!.saveAndValidate() &&
                                //     _formKey2.currentState!.saveAndValidate() &&
                                //     _formKey3.currentState!.saveAndValidate() &&
                                //     _keyEditor.currentState?.getHtml() !=
                                //         null) {
                                //   final data = {
                                //     ..._formKey.currentState!.value,
                                //     ..._formKey2.currentState!.value,
                                //     ..._formKey3.currentState!.value,
                                //     "product_details": await _keyEditor
                                //         .currentState
                                //         ?.getHtml(),
                                //     "image": await MultipartFile.fromFile(
                                //       File(ref.watch(pickedImageProvider)!.path)
                                //           .path,
                                //     ),
                                //   };
                                //   data['brand_id'] = data['brand_id'].id;
                                //   data['category_id'] = data['category_id'].id;
                                //   data['unit_id'] = data['unit_id'].id;
                                //   data['sale_unit_id'] = data['unit_id'];
                                //   data['purchase_unit_id'] = data['unit_id'];
                                //   data['tax_id'] = data['tax_id'].id;
                                //   data['variant'] =
                                //       data['variant'] == true ? "1" : null;
                                //   data['promotion'] =
                                //       data['promotion'] == true ? "1" : null;
                                //   data['is_batch'] =
                                //       data['is_batch'] == true ? "1" : null;
                                //   data['featured'] =
                                //       data['featured'] == true ? "1" : null;

                                //   print(data);

                                //   // api call
                                //   ref
                                //       .read(addProductProvider.notifier)
                                //       .addProduct(data: data)
                                //       .then((value) {
                                //     if (value == true) {
                                //       resetAllFields();
                                //       ref.invalidate(productControllerProvider);
                                //       context.nav.pop();
                                //       ScaffoldMessenger.of(context)
                                //         ..hideCurrentSnackBar()
                                //         ..showSnackBar(
                                //           const SnackBar(
                                //             behavior: SnackBarBehavior.floating,
                                //             backgroundColor: Colors.green,
                                //             content: Text("Product added"),
                                //           ),
                                //         );
                                //     }
                                //   });
                                // } else {
                                //   ScaffoldMessenger.of(context)
                                //     ..hideCurrentSnackBar()
                                //     ..showSnackBar(
                                //       const SnackBar(
                                //         backgroundColor: Colors.red,
                                //         content: Text(
                                //             "Please fill all required fields"),
                                //       ),
                                //     );
                                // }
                              },
                              text: S.of(context).submit,
                            ),
                    )
                  ],
                ),
              );
            },
            error: ((error, stackTrace) {
              return Center(
                child: Text(error.toString()),
              );
            }),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}

class _ProductDetailsSection extends StatefulWidget {
  // const _ProductDetailsSection({required this.keyEditor});
  // final GlobalKey<RichEditorState> keyEditor;

  @override
  State<_ProductDetailsSection> createState() => _ProductDetailsSectionState();
}

class _ProductDetailsSectionState extends State<_ProductDetailsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          TextFieldHeader(
              text: S.of(context).productDetails, isRequired: false),
          Gap(8.h),
          // SizedBox(
          //   height: 300.h,
          //   child: RichEditor(
          //     key: widget.keyEditor,
          //     editorOptions: RichEditorOptions(
          //       placeholder: 'Start typing',
          //       padding: const EdgeInsets.symmetric(horizontal: 5.0),
          //       baseFontFamily: 'sans-serif',
          //       barPosition: BarPosition.TOP,
          //       backgroundColor: Colors.grey[100],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _ProductExtraInfoSection extends ConsumerStatefulWidget {
  const _ProductExtraInfoSection({required this.formKey});
  final GlobalKey<FormBuilderState> formKey;

  @override
  ConsumerState<_ProductExtraInfoSection> createState() =>
      _ProductExtraInfoSectionState();
}

class _ProductExtraInfoSectionState
    extends ConsumerState<_ProductExtraInfoSection> {
  void startSelectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: ref.read(startDateProvider("starting_date")) != ''
          ? DateFormat("yyyy-MM-dd")
              .parse(ref.read(startDateProvider("starting_date"))!)
          : DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final formatedDate = DateFormat("yyyy-MM-dd").format(date);
      setState(() {
        ref.read(startDateProvider("starting_date").notifier).state =
            formatedDate;
        widget.formKey.currentState?.patchValue(
          {"starting_date": formatedDate},
        );
      });
    }
  }

  void endSelectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: ref.read(endDateProvider("last_date")) != ''
          ? DateFormat("yyyy-MM-dd")
              .parse(ref.read(endDateProvider("last_date"))!)
          : DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final formatedDate = DateFormat("yyyy-MM-dd").format(date);
      setState(() {
        ref.read(endDateProvider("last_date").notifier).state = formatedDate;
        widget.formKey.currentState?.patchValue(
          {"last_date": formatedDate},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: [
          FormBuilderCheckbox(
            name: "featured",
            title: Text(S.of(context).featureProductWillbe),
            activeColor: AppColor.primaryColor,
            side: BorderSide(
                color: AppColor.darkBackgroundColor.withOpacity(0.8)),
            decoration:
                const InputDecoration(border: InputBorder.none, isDense: true),
          ),
          FormBuilderCheckbox(
            name: "is_batch",
            title: Text(S.of(context).thisProducthasbatches),
            activeColor: AppColor.primaryColor,
            side: BorderSide(
                color: AppColor.darkBackgroundColor.withOpacity(0.8)),
            decoration:
                const InputDecoration(border: InputBorder.none, isDense: true),
          ),
          FormBuilderCheckbox(
            name: "variant",
            title: Text(S.of(context).thisProducthasVariants),
            activeColor: AppColor.primaryColor,
            side: BorderSide(
                color: AppColor.darkBackgroundColor.withOpacity(0.8)),
            decoration:
                const InputDecoration(border: InputBorder.none, isDense: true),
            onChanged: (value) {
              setState(() {});
            },
          ),
          Visibility(
            visible:
                widget.formKey.currentState?.fields["variant"]?.value == true,
            child: variantView(),
          ),
          FormBuilderCheckbox(
            name: "promotion",
            title: Text(S.of(context).addPromotion),
            activeColor: AppColor.primaryColor,
            side: BorderSide(
                color: AppColor.darkBackgroundColor.withOpacity(0.8)),
            decoration:
                const InputDecoration(border: InputBorder.none, isDense: true),
            onChanged: (value) {
              setState(() {});
            },
          ),
          Visibility(
            visible:
                widget.formKey.currentState?.fields["promotion"]?.value == true,
            child: promotionalView(),
          ),
        ]),
      ),
    );
  }

  Widget promotionalView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColor.borderColor,
          ),
        ),
      ),
      child: Column(
        children: [
          const TextFieldHeader(text: "Promotional Price", isRequired: false),
          Gap(8.h),
          FormBuilderTextField(
            name: "promotion_price",
            style: AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
            decoration: AppTheme.inputDecoration.copyWith(
              hintText: "Enter variant names",
              hintStyle: AppTextStyle.normalBody.copyWith(
                fontSize: 14.sp,
                color: AppColor.borderColor,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
            ),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: "This field is required"),
            ]),
          ),
          Gap(10.r),
          Row(children: [
            Flexible(
              child: Column(
                children: [
                  const TextFieldHeader(
                    text: "Start Date",
                    isRequired: false,
                  ),
                  Gap(8.h),
                  FormBuilderTextField(
                    name: "starting_date",
                    readOnly: true,
                    onTap: () {
                      startSelectDate();
                    },
                    style: AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
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
                ],
              ),
            ),
            Gap(8.r),
            Flexible(
              child: Column(
                children: [
                  const TextFieldHeader(
                    text: "End Date",
                    isRequired: false,
                  ),
                  Gap(8.h),
                  FormBuilderTextField(
                    name: "last_date",
                    readOnly: true,
                    onTap: () {
                      endSelectDate();
                    },
                    style: AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
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
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget variantView() {
    return Consumer(builder: (context, ref, _) {
      final addProduct = ref.watch(addProductVarientControllerProvider);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppColor.borderColor,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: "Nvariant",
                    style: AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                    decoration: AppTheme.inputDecoration.copyWith(
                      hintText: "Enter variant names",
                      hintStyle: AppTextStyle.normalBody.copyWith(
                        fontSize: 14.sp,
                        color: AppColor.borderColor,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                    ),
                  ),
                ),
                Gap(10.r),
                InkWell(
                  onTap: () {
                    String? variantValue =
                        widget.formKey.currentState?.fields["Nvariant"]?.value;

                    if (variantValue != null && variantValue.isNotEmpty) {
                      ref
                          .read(addProductVarientControllerProvider.notifier)
                          .setProductName(
                            name: variantValue,
                            code: ref.watch(productCodeProvider) ?? '',
                          );

                      // clear variant field
                      widget.formKey.currentState?.patchValue(
                        {"Nvariant": ''},
                      );
                    } else {
                      // show snackbar
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Please enter variant name"),
                          ),
                        );
                    }
                  },
                  child: const Icon(
                    Icons.add,
                    color: AppColor.primaryColor,
                  ),
                )
              ],
            ),
            Gap(10.r),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
              decoration: const BoxDecoration(color: Color(0xFFF3F4F6)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.28,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Code',
                      style: TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.28,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    child: Text(
                      'Special Price',
                      style: TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(10.r),
            SizedBox(
              // width: 334.r,
              child: Builder(builder: (context) {
                Future.delayed(const Duration(milliseconds: 10), () {});
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addProduct.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ref.watch(
                                varientTextEditingProvider('vName_$index'))
                              ?..text = addProduct[index].name ?? '',
                            style: AppTextStyle.normalBody
                                .copyWith(fontSize: 14.sp),
                            decoration: AppTheme.inputDecoration.copyWith(
                              hintText: "Name",
                              hintStyle: AppTextStyle.normalBody.copyWith(
                                fontSize: 14.sp,
                                color: AppColor.borderColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 8.h,
                              ),
                            ),
                          ),
                        ),
                        Gap(5.r),
                        Expanded(
                          child: TextField(
                            controller: ref.watch(
                                varientTextEditingProvider('vCode_$index'))
                              ?..text = addProduct[index].code ?? '',
                            style: AppTextStyle.normalBody
                                .copyWith(fontSize: 14.sp),
                            decoration: AppTheme.inputDecoration.copyWith(
                              hintText: "Code",
                              hintStyle: AppTextStyle.normalBody.copyWith(
                                fontSize: 14.sp,
                                color: AppColor.borderColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 8.h,
                              ),
                            ),
                          ),
                        ),
                        Gap(5.r),
                        Expanded(
                          child: TextField(
                            controller: ref.watch(varientTextEditingProvider(
                                'vSpecialPrice_$index'))
                              ?..text = addProduct[index].price ?? '0',
                            style: AppTextStyle.normalBody
                                .copyWith(fontSize: 14.sp),
                            decoration: AppTheme.inputDecoration.copyWith(
                              hintText: "Price",
                              hintStyle: AppTextStyle.normalBody.copyWith(
                                fontSize: 14.sp,
                                color: AppColor.borderColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 8.h,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              ref
                                  .read(addProductVarientControllerProvider
                                      .notifier)
                                  .updatePrice(
                                    price: value,
                                    index: index,
                                  );
                            },
                          ),
                        ),
                        // Expanded(
                        //   child: FormBuilderTextField(
                        //     name: "vSpecialPrice_$index",
                        //     initialValue: addProduct[index].price,
                        //     style: AppTextStyle.normalBody
                        //         .copyWith(fontSize: 14.sp),
                        //     keyboardType: TextInputType.number,
                        //     decoration: AppTheme.inputDecoration.copyWith(
                        //       hintText: "Price",
                        //       hintStyle: AppTextStyle.normalBody.copyWith(
                        //         fontSize: 14.sp,
                        //         color: AppColor.borderColor,
                        //       ),
                        //       contentPadding: EdgeInsets.symmetric(
                        //         horizontal: 10.w,
                        //         vertical: 8.h,
                        //       ),
                        //     ),
                        //     validator: FormBuilderValidators.compose([
                        //       FormBuilderValidators.required(
                        //           errorText: "This field is required"),
                        //     ]),
                        //     onChanged: (value) {
                        //       // update form value
                        //       // widget.formKey.currentState?.patchValue(
                        //       //   {
                        //       //     "vSpecialPrice_$index": value,
                        //       //   },
                        //       // );
                        //       ref
                        //           .read(addProductVarientControllerProvider
                        //               .notifier)
                        //           .updatePrice(
                        //             price: value!,
                        //             index: index,
                        //           );
                        //     },
                        //   ),
                        // ),
                        Gap(5.w),
                        InkWell(
                          onTap: () {
                            ref
                                .read(addProductVarientControllerProvider
                                    .notifier)
                                .removeProduct(index: index);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Gap(10.r);
                  },
                );
              }),
            )
          ],
        ),
      );
    });
  }
}

class _ProductImageInfoSection extends ConsumerStatefulWidget {
  const _ProductImageInfoSection({required this.formKey, required this.info});
  final GlobalKey<FormBuilderState> formKey;
  final AddProductInfoModel info;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __ProductImageInfoSectionState();
}

class __ProductImageInfoSectionState
    extends ConsumerState<_ProductImageInfoSection> {
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(pickedImageProvider.notifier).state = pickedFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: [
          TextFieldHeader(text: S.of(context).productImage),
          Gap(8.h),
          ref.watch(pickedImageProvider) != null
              ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 100.r,
                      height: 100.r,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        image: DecorationImage(
                          image: FileImage(
                              File(ref.watch(pickedImageProvider)!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      top: -10,
                      child: IconButton(
                        onPressed: () {
                          ref.read(pickedImageProvider.notifier).state = null;
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                )
              : DottedBorder(
                  radius: Radius.circular(10.r),
                  borderType: BorderType.RRect,
                  dashPattern: const [5, 3],
                  color: AppColor.borderColor,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await pickImage();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.r, vertical: 15.r),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF3F4F6),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFE5E7EB)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Choose File',
                              style: TextStyle(
                                color: Color(0xFF334155),
                                fontSize: 14,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                height: 0.10,
                                letterSpacing: 0.28,
                              ),
                            ),
                          ),
                        ),
                        Gap(10.r),
                        const Expanded(
                          child: Text(
                            'No file choosen',
                            style: TextStyle(
                              color: Color(0xFFD1D5DB),
                              fontSize: 16,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              height: 0.09,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          Gap(24.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFieldHeader(text: S.of(context).tax),
                    Gap(8.h),
                    FormBuilderDropdown<Tax>(
                      name: "tax_id",
                      isDense: true,
                      items: widget.info.data!.taxs!
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
                      onReset: () {
                        widget.formKey.currentState?.fields["tax_id"]?.reset();
                      },
                      decoration: AppTheme.inputDecoration.copyWith(
                        hintText: S.of(context).select,
                        hintStyle: AppTextStyle.normalBody.copyWith(
                          color: const Color(0xffD1D5DB),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                      ),
                      onChanged: (value) {},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "This field is required"),
                      ]),
                    ),
                  ],
                ),
              ),
              Gap(10.r),
              Expanded(
                child: Column(
                  children: [
                    TextFieldHeader(text: S.of(context).taxMethod),
                    Gap(8.h),
                    FormBuilderDropdown<String>(
                      name: "tax_method",
                      isDense: true,
                      items: widget.info.data!.taxMethods!
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
                      onReset: () {
                        widget.formKey.currentState?.fields["tax_method"]
                            ?.reset();
                      },
                      decoration: AppTheme.inputDecoration.copyWith(
                        hintText: S.of(context).select,
                        hintStyle: AppTextStyle.normalBody.copyWith(
                          color: const Color(0xffD1D5DB),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                      ),
                      onChanged: (value) {},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "This field is required"),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class _ProductInfoSection extends ConsumerStatefulWidget {
  const _ProductInfoSection({required this.formKey, required this.info});
  final GlobalKey<FormBuilderState> formKey;
  final AddProductInfoModel info;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __ProductInfoSectionState();
}

class __ProductInfoSectionState extends ConsumerState<_ProductInfoSection> {
  Unit? selectedUnit;
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            TextFieldHeader(text: S.of(context).name),
            Gap(8.h),
            FormBuilderTextField(
              name: "name",
              style: AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
              decoration: AppTheme.inputDecoration.copyWith(
                hintText: S.of(context).entrName,
                hintStyle: AppTextStyle.normalBody.copyWith(
                  fontSize: 14.sp,
                  color: AppColor.borderColor,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "This field is required"),
              ]),
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(text: S.of(context).type),
                      Gap(8.h),
                      FormBuilderDropdown(
                        name: "type",
                        isDense: true,
                        items: widget.info.data!.productTypes!
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
                          hintText: S.of(context).select,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            color: const Color(0xffD1D5DB),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        onChanged: (value) {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "This field is required"),
                        ]),
                      ),
                    ],
                  ),
                ),
                Gap(10.r),
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(text: S.of(context).code),
                      Gap(8.h),
                      FormBuilderTextField(
                        name: "code",
                        style:
                            AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                        keyboardType: TextInputType.number,
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: S.of(context).enterCode,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.borderColor,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        onChanged: (value) {
                          ref.watch(productCodeProvider.notifier).state = value;
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "This field is required"),
                          FormBuilderValidators.minLength(8,
                              errorText: "Code must be 8 digit"),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(24.h),
            TextFieldHeader(text: S.of(context).barCodeSymbology),
            Gap(8.h),
            FormBuilderDropdown<String>(
              name: "barcode_symbology",
              isDense: true,
              items: widget.info.data!.barcodeSymbologyes!
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
                hintText: S.of(context).selectSymbology,
                hintStyle: AppTextStyle.normalBody.copyWith(
                  color: const Color(0xffD1D5DB),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
              ),
              onChanged: (value) {},
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "This field is required"),
              ]),
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(text: S.of(context).brand),
                      Gap(8.h),
                      FormBuilderDropdown<Brand>(
                        name: "brand_id",
                        isDense: true,
                        items: widget.info.data!.brands!
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
                          hintText: S.of(context).select,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            color: const Color(0xffD1D5DB),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        onChanged: (value) {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "This field is required"),
                        ]),
                      ),
                    ],
                  ),
                ),
                Gap(10.r),
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(text: S.of(context).categories),
                      Gap(8.h),
                      FormBuilderDropdown<Category>(
                        name: "category_id",
                        isDense: true,
                        items: widget.info.data!.categories!
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
                          hintText: S.of(context).select,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            color: const Color(0xffD1D5DB),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        onChanged: (value) {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "This field is required"),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(text: S.of(context).productUnit),
                      Gap(8.h),
                      FormBuilderDropdown<Unit>(
                        name: "unit_id",
                        isDense: true,
                        items: widget.info.data!.units!
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
                          hintText: S.of(context).select,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            color: const Color(0xffD1D5DB),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedUnit = value;
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "This field is required"),
                        ]),
                      ),
                    ],
                  ),
                ),
                Gap(10.r),
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(
                          text: S.of(context).saleUnit, isRequired: false),
                      Gap(8.h),
                      FormBuilderDropdown<String>(
                        name: "sale_unit_id",
                        isDense: true,
                        items: selectedUnit == null
                            ? [
                                DropdownMenuItem(
                                  value: '',
                                  child: Text(
                                    '',
                                    style: AppTextStyle.normalBody.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ]
                            : [
                                DropdownMenuItem(
                                  value: selectedUnit!.name,
                                  child: Text(
                                    selectedUnit!.name ?? '',
                                    style: AppTextStyle.normalBody.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ],
                        icon: SvgPicture.asset(
                          Assets.svgs.arrowDown2,
                        ),
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: S.of(context).select,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            color: const Color(0xffD1D5DB),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(
                          text: S.of(context).purchaseUnit, isRequired: false),
                      Gap(8.h),
                      FormBuilderDropdown<String>(
                        name: "purchase_unit_id",
                        isDense: true,
                        items: selectedUnit == null
                            ? [
                                DropdownMenuItem(
                                  value: '',
                                  child: Text(
                                    '',
                                    style: AppTextStyle.normalBody.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ]
                            : [
                                DropdownMenuItem(
                                  value: selectedUnit!.name,
                                  child: Text(
                                    selectedUnit?.name ?? '',
                                    style: AppTextStyle.normalBody.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ],
                        icon: SvgPicture.asset(
                          Assets.svgs.arrowDown2,
                        ),
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: S.of(context).select,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            color: const Color(0xffD1D5DB),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                Gap(10.r),
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(
                        text: S.of(context).productCode,
                        isRequired: false,
                      ),
                      Gap(8.h),
                      FormBuilderTextField(
                        name: "cost",
                        style:
                            AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                        keyboardType: TextInputType.number,
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: S.of(context).select,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.borderColor,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(
                        text: S.of(context).sellingPrice,
                      ),
                      Gap(8.h),
                      FormBuilderTextField(
                        name: "price",
                        style:
                            AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                        keyboardType: TextInputType.number,
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: S.of(context).sellingPrice,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.borderColor,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "This field is required"),
                        ]),
                      ),
                    ],
                  ),
                ),
                Gap(10.r),
                Expanded(
                  child: Column(
                    children: [
                      TextFieldHeader(
                        text: S.of(context).alertQuantity,
                        isRequired: false,
                      ),
                      Gap(8.h),
                      FormBuilderTextField(
                        name: "alert_quantity",
                        style:
                            AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
                        keyboardType: TextInputType.number,
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: S.of(context).entrQty,
                          hintStyle: AppTextStyle.normalBody.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.borderColor,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
