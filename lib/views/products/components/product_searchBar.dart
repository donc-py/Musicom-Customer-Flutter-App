// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';

class ProductSearchBar extends ConsumerWidget {
  final TextEditingController controller;
  void Function(String)? onChanged;
  ProductSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Container(
      height: context.isTabletLandsCape ? 120.h : 80.h,
      color: AdaptiveTheme.of(context).mode.isDark
          ? AppColor.darkBackgroundColor
          : Colors.white,
      padding: EdgeInsets.all(15.r),
      child: Hero(
        tag: "searchBar",
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.r),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.borderColor,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                context.isTabletLandsCape
                    ? SizedBox(
                        child: SvgPicture.asset(
                          Assets.svgs.searchNormal,
                          fit: BoxFit.cover,
                        ),
                      )
                    : isLargeScreen
                        ? SizedBox(
                            child: SvgPicture.asset(
                              Assets.svgs.searchNormal,
                            ),
                          )
                        : SizedBox(
                            width: 24.r,
                            height: 24.r,
                            child: SvgPicture.asset(
                              Assets.svgs.searchNormal,
                              fit: BoxFit.cover,
                            ),
                          ),
                Gap(12.w),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
