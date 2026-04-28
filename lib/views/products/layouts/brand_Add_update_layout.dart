// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/components/custom_text_field.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/brand/brand_update.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/utils/global_function.dart';

class BrandAddUpdateLayout extends ConsumerStatefulWidget {
  final UpdateBrandModel? updateBrandModel;
  const BrandAddUpdateLayout({
    super.key,
    required this.updateBrandModel,
  });

  @override
  ConsumerState<BrandAddUpdateLayout> createState() =>
      _BrandAddUpdateLayoutState();
}

class _BrandAddUpdateLayoutState extends ConsumerState<BrandAddUpdateLayout> {
  static TextEditingController brandNameController = TextEditingController();
  @override
  void initState() {
    if (widget.updateBrandModel != null) {
      brandNameController.text = widget.updateBrandModel!.brandName;
    }
    super.initState();
  }

  @override
  void dispose() {
    brandNameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        toolbarHeight: 80.h,
        title: Text(
          S.of(context).newBrand,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                title: S.of(context).brandName,
                hint: S.of(context).enterBrandName,
                controller: brandNameController,
                validator: (value) => GlobalFunction.defaultValidator(
                  value: value!,
                  hintText: S.of(context).brandName,
                  context: context,
                ),
              ),
              Gap(24.h),
              _buildImageUploadField(title: S.of(context).brandImage),
              Gap(40.h),
              ref.watch(brandControllerProvider)
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        isEnabled: true,
                        onPressed: () {
                          if (widget.updateBrandModel != null) {
                            ref
                                .read(brandControllerProvider.notifier)
                                .updateBrand(
                                  brandId: widget.updateBrandModel!.brandId,
                                  brandName: brandNameController.text,
                                  brandImage: ref.read(pickedImageProvider) !=
                                          null
                                      ? File(
                                          ref.read(pickedImageProvider)!.path)
                                      : null,
                                )
                                .then((response) {
                              GlobalFunction.showCustomSnackbar(
                                  message: response.message,
                                  isSuccess: response.isSuccess);
                              if (response.isSuccess) {
                                context.nav.pop();
                                ref.refresh(pickedImageProvider);
                                ref
                                    .read(brandControllerProvider.notifier)
                                    .getBrands(
                                      page: 1,
                                      perPage: 20,
                                      search: null,
                                      pagination: false,
                                    );
                              }
                            });
                          } else {
                            ref
                                .read(brandControllerProvider.notifier)
                                .addBrand(
                                  brandName: brandNameController.text,
                                  brandImage: ref.read(pickedImageProvider) !=
                                          null
                                      ? File(
                                          ref.read(pickedImageProvider)!.path)
                                      : null,
                                )
                                .then((response) {
                              GlobalFunction.showCustomSnackbar(
                                  message: response.message,
                                  isSuccess: response.isSuccess);
                              if (response.isSuccess) {
                                context.nav.pop();
                                ref.refresh(pickedImageProvider);
                                ref
                                    .read(brandControllerProvider.notifier)
                                    .getBrands(
                                      page: 1,
                                      perPage: 20,
                                      search: null,
                                      pagination: false,
                                    );
                              }
                            });
                          }
                        },
                        text: S.of(context).save,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
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
