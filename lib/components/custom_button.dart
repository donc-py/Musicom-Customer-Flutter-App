import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
    this.isArrowRight = false,
    required this.text,
    this.isBackgrounColor = true,
    this.buttonColor = AppColor.primaryColor,
  });
  Function onPressed;
  final bool isEnabled;
  final String text;
  final bool isArrowRight;
  final bool isBackgrounColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => isEnabled ? onPressed() : null,
      style: TextButton.styleFrom(
        backgroundColor: isEnabled
            ? isBackgrounColor
                ? buttonColor
                : const Color(0xffF3F4F6)
            : AppColor.primaryColor.withOpacity(0.3),
        foregroundColor: AppColor.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h),
      ),
      child: isArrowRight
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: AppTextStyle.normalBody.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(12.w),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0),
                  child: SvgPicture.asset(
                    Assets.svgs.arrowLeft,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              ],
            )
          : Text(
              text,
              style: AppTextStyle.normalBody.copyWith(
                fontWeight: FontWeight.w700,
                color: isBackgrounColor ? Colors.white : Colors.black,
              ),
            ),
    );
  }
}
