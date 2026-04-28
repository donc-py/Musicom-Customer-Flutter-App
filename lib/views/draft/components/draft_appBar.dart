import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';

class DraftAppBar extends StatelessWidget {
  const DraftAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        // give boder bottom with 1px
        border: Border(
          bottom: BorderSide(
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : AppColor.blueBackgroundColor,
            width: 1.5.h,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(45.h),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 35.w,
                  height: 35.h,
                  padding: EdgeInsets.all(7.w),
                  child: SvgPicture.asset(
                    Assets.svgs.arrowLeft,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Gap(20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Draft",
                      style: AppTextStyle.title,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
