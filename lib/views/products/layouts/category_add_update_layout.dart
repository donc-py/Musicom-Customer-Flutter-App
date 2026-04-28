// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/components/custom_text_field.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/config/theme.dart';
import 'package:readypos_flutter/controllers/category_controller/category.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/category/parent_category.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/utils/global_function.dart';

class CategoryAddUpdateLayout extends ConsumerStatefulWidget {
  final CategoryAddUpdateArguament? categoryAddUpdateArguament;
  const CategoryAddUpdateLayout({
    super.key,
    this.categoryAddUpdateArguament,
  });

  @override
  ConsumerState<CategoryAddUpdateLayout> createState() =>
      _CategoryAddUpdateLayoutState();
}

class _CategoryAddUpdateLayoutState
    extends ConsumerState<CategoryAddUpdateLayout> {
  static TextEditingController categoryNameController = TextEditingController();
  @override
  void initState() {
    if (widget.categoryAddUpdateArguament != null) {
      categoryNameController.text =
          widget.categoryAddUpdateArguament!.categoryName;
      intialValue = widget.categoryAddUpdateArguament!.parentCategoryName ?? '';
    }
    super.initState();
  }

  String intialValue = '';
  int? parentCategoryId;

  List<ParentCategory> parentCategory = [];

  @override
  void dispose() {
    intialValue = '';
    parentCategoryId = null;
    categoryNameController.clear();
    super.dispose();
  }

  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        toolbarHeight: 80.h,
        title: Text(
          S.of(context).categories,
          style: AppTextStyle.title,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 14.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        color: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  title: S.of(context).categoryName,
                  hint: S.of(context).enterCategoryName,
                  controller: categoryNameController,
                  validator: (value) => GlobalFunction.defaultValidator(
                    value: value!,
                    hintText: S.of(context).categories,
                    context: context,
                  ),
                ),
                Gap(24.h),
                _buildParentCategoryDropDown(
                  title: S.of(context).parentCategory,
                ),
                Gap(24.h),
                _buildImageUploadField(title: S.of(context).categoryImage),
                Gap(40.h),
                ref.watch(categoryControllerProvider)
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          isEnabled: true,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (widget.categoryAddUpdateArguament != null) {
                                ref
                                    .read(categoryControllerProvider.notifier)
                                    .updateCategory(
                                        categoryId: widget
                                            .categoryAddUpdateArguament!
                                            .categoryId,
                                        categoryName:
                                            categoryNameController.text,
                                        parentCategoryId: parentCategoryId,
                                        categoryImage:
                                            ref.read(pickedImageProvider) !=
                                                    null
                                                ? File(ref
                                                    .read(pickedImageProvider)!
                                                    .path)
                                                : null)
                                    .then((response) {
                                  GlobalFunction.showCustomSnackbar(
                                    message: response.message,
                                    isSuccess: response.isSuccess,
                                  );
                                  if (response.isSuccess) {
                                    context.nav.pop();
                                    ref.refresh(pickedImageProvider);
                                    ref
                                        .refresh(
                                            categoryControllerProvider.notifier)
                                        .getCategories(
                                          page: 1,
                                          perPage: 20,
                                          search: null,
                                          pagination: false,
                                        );
                                    ref
                                        .read(
                                            categoryControllerProvider.notifier)
                                        .getParentCategory();
                                  }
                                });
                              } else {
                                ref
                                    .read(categoryControllerProvider.notifier)
                                    .addCategory(
                                        categoryName:
                                            categoryNameController.text,
                                        parentCategoryId: parentCategoryId,
                                        categoryImage:
                                            ref.read(pickedImageProvider) !=
                                                    null
                                                ? File(ref
                                                    .read(pickedImageProvider)!
                                                    .path)
                                                : null)
                                    .then((response) {
                                  GlobalFunction.showCustomSnackbar(
                                    message: response.message,
                                    isSuccess: response.isSuccess,
                                  );
                                  if (response.isSuccess) {
                                    context.nav.pop();
                                    ref.refresh(pickedImageProvider);

                                    ref
                                        .refresh(
                                            categoryControllerProvider.notifier)
                                        .getCategories(
                                          page: 1,
                                          perPage: 20,
                                          search: null,
                                          pagination: false,
                                        );
                                    ref
                                        .read(
                                            categoryControllerProvider.notifier)
                                        .getParentCategory();
                                  }
                                });
                              }
                            }
                          },
                          text: S.of(context).save,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParentCategoryDropDown({required String title}) {
    return Builder(builder: (context) {
      final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
      return Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: AppTextStyle.normalBody,
              ),
              Text(
                '*',
                style:
                    AppTextStyle.normalBody.copyWith(color: AppColor.redColor),
              )
            ],
          ),
          Gap(10.h),
          ref.watch(categoryControllerProvider)
              ? const CircularProgressIndicator()
              : FormBuilderDropdown(
                  isDense: isLargeScreen ? false : true,
                  name: "group",
                  initialValue: intialValue,
                  items: ref
                      .watch(categoryControllerProvider.notifier)
                      .parentCategories
                      .map(
                        (parentCategory) => DropdownMenuItem(
                          onTap: () {
                            parentCategoryId = parentCategory.id;
                          },
                          value: parentCategory.name,
                          child: Text(
                            parentCategory.name,
                            style: AppTextStyle.normalBody.copyWith(
                              fontSize: isLargeScreen ? 12.sp : 14.sp,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  icon: SvgPicture.asset(
                    Assets.svgs.arrowDown2,
                  ),
                  decoration: AppTheme.inputDecoration.copyWith(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                          color: AppColor.borderColor, width: 2),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColor.borderColor,
                        width: 2,
                      ),
                    ),
                    hintText: S.of(context).select,

                    // contentPadding: isLargeScreen
                    //     ? null
                    //     : EdgeInsets.symmetric(
                    //         horizontal: 10.w,
                    //         vertical: 16.h,
                    //       ).copyWith(right: 20),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Customer Group is required";
                    }
                    return null;
                  },
                ),
        ],
      );
    });
  }

  Widget _buildImageUploadField({required String title}) {
    return Consumer(
      builder: (context, ref, _) {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTextStyle.normalBody,
                ),
                Text(
                  '*',
                  style: AppTextStyle.normalBody
                      .copyWith(color: AppColor.redColor),
                )
              ],
            ),
            Gap(10.h),
            ref.watch(pickedImageProvider) != null
                ? _buildFillFieldDecoration(ref: ref)
                : _buildEmptyFieldDecoration(ref: ref),
          ],
        );
      },
    );
  }

  Widget _buildEmptyFieldDecoration({required WidgetRef ref}) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: () {
          GlobalFunction.pickImageFromGallery(ref: ref);
        },
        child: Container(
          padding: EdgeInsets.all(5.r),
          child: DottedBorder(
            strokeWidth: 1.5,
            color: AppColor.primaryColor,
            dashPattern: const [4, 5],
            borderType: BorderType.Rect,
            radius: Radius.circular(10.r),
            child: SizedBox(
              height: 128.h,
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Assets.svgs.gallery),
                    Gap(10.h),
                    Text(
                      S.of(context).tapToUploadImage,
                      style: AppTextStyle.normalBody,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFillFieldDecoration({required WidgetRef ref}) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 128.h,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 2,
                color: AppColor.borderColor,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.r,
                height: 100.r,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: FileImage(
                      File(
                        ref.watch(pickedImageProvider.notifier).state!.path,
                      ),
                    ),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 10.w,
          top: 10.h,
          child: GestureDetector(
            onTap: () {
              ref.refresh(pickedImageProvider);
            },
            child: SvgPicture.asset(
              Assets.svgs.trash,
              width: 20.sp,
            ),
          ),
        )
      ],
    );
  }
}

class CategoryAddUpdateArguament {
  int categoryId;
  String categoryName;
  String? parentCategoryName;
  CategoryAddUpdateArguament({
    required this.categoryId,
    required this.categoryName,
    required this.parentCategoryName,
  });
}
