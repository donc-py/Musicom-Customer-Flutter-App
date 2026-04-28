// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/category_controller/category.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/category/category.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/utils/global_function.dart';
import 'package:readypos_flutter/views/products/components/item_delete_dialog.dart';
import 'package:readypos_flutter/views/products/layouts/category_add_update_layout.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final void Function()? onTap;
  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
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
                  children: [
                    _buildCategoryImage(context),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: AppTextStyle.normalBody.copyWith(
                              fontSize: 14.sp, fontWeight: FontWeight.w700),
                        ),
                        Gap(5.h),
                        Text(
                          category.name ?? '',
                          style: AppTextStyle.smallBody.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AdaptiveTheme.of(context).mode.isDark
                                ? Colors.white
                                : AppColor.darkBackgroundColor.withOpacity(0.6),
                          ),
                        ),
                        Gap(5.h),
                        Row(
                          children: [
                            // Text(
                            //   category.totalProducts.toString(),
                            //   style: AppTextStyle.smallBody.copyWith(
                            //     fontSize: 12.sp,
                            //     fontWeight: FontWeight.w400,
                            //     color: AdaptiveTheme.of(context).mode.isDark
                            //         ? Colors.white
                            //         : AppColor.darkBackgroundColor,
                            //   ),
                            // ),
                            Gap(8.w),
                            Text(
                              S.of(context).products,
                              style: AppTextStyle.smallBody.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AdaptiveTheme.of(context).mode.isDark
                                    ? Colors.white
                                    : AppColor.darkBackgroundColor
                                        .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.nav.pushNamed(
                              Routes.categoryAddUpdateView,
                              arguments: CategoryAddUpdateArguament(
                                categoryId: category.id,
                                categoryName: category.name,
                                parentCategoryName: category.name,
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            Assets.svgs.edit,
                            width: 18.w,
                          ),
                        ),
                        Gap(14.h),
                        Consumer(builder: (context, ref, _) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor:
                                    AdaptiveTheme.of(context).mode.isDark
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.black.withOpacity(0.5),
                                builder: (context) => DeleteConfirmationDialog(
                                  onPressed: () {
                                    ref
                                        .read(
                                            categoryControllerProvider.notifier)
                                        .deleteCategory(id: category.id)
                                        .then((response) {
                                      GlobalFunction.showCustomSnackbar(
                                        message: response.message,
                                        isSuccess: response.isSuccess,
                                      );
                                      if (response.isSuccess) {
                                        ref
                                            .read(categoryControllerProvider
                                                .notifier)
                                            .getCategories(
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
                              width: 18.w,
                            ),
                          );
                        })
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryImage(BuildContext context) {
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
          imageUrl: category.thumbnail,
          width: context.isTabletLandsCape ? 75.w : 64.w,
          height: context.isTabletLandsCape ? 60.w : 64.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
