// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/brand/brand.dart';
import 'package:readypos_flutter/models/brand/brand_update.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/utils/global_function.dart';
import 'package:readypos_flutter/views/products/components/item_delete_dialog.dart';

class BrandCard extends StatefulWidget {
  final Brand brand;
  final void Function()? onTap;
  const BrandCard({
    super.key,
    required this.brand,
    this.onTap,
  });
  @override
  State<BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<BrandCard> {
  PopupMenu? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Stack(
      children: [
        Material(
          child: InkWell(
            onTap: widget.onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              _buildCategoryImage(),
                              Gap(10.w),
                              Padding(
                                padding: EdgeInsets.only(right: 40.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.brand.name,
                                      style: AppTextStyle.normalBody.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Gap(5.h),
                                    Row(
                                      children: [
                                        Text(
                                          0.toString(),
                                          style:
                                              AppTextStyle.smallBody.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AdaptiveTheme.of(context)
                                                    .mode
                                                    .isDark
                                                ? Colors.white
                                                : AppColor.darkBackgroundColor,
                                          ),
                                        ),
                                        Gap(5.w),
                                        Text(
                                          S.of(context).products,
                                          style:
                                              AppTextStyle.smallBody.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AdaptiveTheme.of(context)
                                                    .mode
                                                    .isDark
                                                ? Colors.white
                                                : AppColor.darkBackgroundColor
                                                    .withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.nav
                                      .pushNamed(Routes.brandAddUpdateView,
                                          arguments: UpdateBrandModel(
                                            brandId: widget.brand.id,
                                            brandName: widget.brand.name,
                                            brandImage: widget.brand.thumbnail,
                                          ));
                                },
                                child: SvgPicture.asset(
                                  Assets.svgs.edit,
                                  height: isLargeScreen ? 25.r : null,
                                  width: isLargeScreen ? 25.r : null,
                                ),
                              ),
                              Gap(20.w),
                              Consumer(builder: (context, ref, _) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      barrierColor:
                                          AdaptiveTheme.of(context).mode.isDark
                                              ? Colors.white.withOpacity(0.5)
                                              : Colors.black.withOpacity(0.5),
                                      context: context,
                                      builder: (context) =>
                                          DeleteConfirmationDialog(
                                        onPressed: () {
                                          ref
                                              .read(brandControllerProvider
                                                  .notifier)
                                              .deleteBrand(id: widget.brand.id)
                                              .then((response) {
                                            GlobalFunction.showCustomSnackbar(
                                              message: response.message,
                                              isSuccess: response.isSuccess,
                                            );
                                            if (response.isSuccess) {
                                              ref
                                                  .read(brandControllerProvider
                                                      .notifier)
                                                  .getBrands(
                                                    page: 1,
                                                    perPage: 15,
                                                    search: null,
                                                    pagination: false,
                                                  );
                                            }
                                            context.nav.pop();
                                          });
                                        },
                                      ),
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    Assets.svgs.trash,
                                    height: isLargeScreen ? 25.r : null,
                                    width: isLargeScreen ? 25.r : null,
                                  ),
                                );
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryImage() {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: const BorderSide(color: AppColor.borderColor, width: 1.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          width: context.isTabletLandsCape ? 75.w : 64.w,
          height: context.isTabletLandsCape ? 60.w : 64.h,
          imageUrl: widget.brand.thumbnail,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

enum PopupMenu { view, delete }
