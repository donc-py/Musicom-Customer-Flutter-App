import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(8.r),
        splashColor: AppColor.primaryColor.withOpacity(0.2),
        child: Container(
          height: context.isTabletLandsCape ? 90.h : 56.h,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              context.isTabletLandsCape
                  ? SizedBox(
                      child: SvgPicture.asset(icon),
                    )
                  : SizedBox(
                      height: 26.r,
                      width: 26.r,
                      child: SvgPicture.asset(icon),
                    ),
              Gap(15.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.normalBody.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Gap(15.w),
              SizedBox(
                height: 20.r,
                width: 20.r,
                child: SvgPicture.asset(Assets.svgs.arrowRight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
