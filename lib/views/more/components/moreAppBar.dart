import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';

class MoreAppBar extends StatelessWidget {
  const MoreAppBar({
    super.key,
    required this.title,
    this.isTrailing = false,
    this.onTap,
  });

  final String title;
  final bool isTrailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        // give boder bottom with 1px
        // border: Border(
        //   bottom: BorderSide(
        //     color: AdaptiveTheme.of(context).mode.isDark
        //         ? AppColor.darkBackgroundColor
        //         : AppColor.blueBackgroundColor,
        //     width: 1.5.h,
        //   ),
        // ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(55.h),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  padding: EdgeInsets.all(7.w),
                  child: SvgPicture.asset(
                    Assets.svgs.arrowLeft,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Gap(20.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.title,
                ),
              ),
              isTrailing
                  ? InkWell(
                      onTap: () {
                        onTap?.call();
                      },
                      child: Container(
                        height: 48.r,
                        width: 48.r,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AdaptiveTheme.of(context).mode.isDark
                              ? AppColor.greyBackgroundColor.withOpacity(0.2)
                              : AppColor.greyBackgroundColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: SvgPicture.asset(
                          Assets.svgs.filter,
                          colorFilter: AdaptiveTheme.of(context).mode.isDark
                              ? const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                )
                              : ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.srcIn,
                                ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
