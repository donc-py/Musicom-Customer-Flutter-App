import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 1.w, right: 1.w, top: 1.h),
          // child: SvgPicture.asset(
          //   AdaptiveTheme.of(context).mode.isDark
          //       ? Assets.svgs.logowhite
          //       : Assets.svgs.logoblack,
          //   fit: BoxFit.fill,
          // ),
          child: AdaptiveTheme.of(context).mode.isDark
              ? Assets.pngs.logoMusicom.image(
                  // width: 250.w,
                  height: 50.h,
                )
              : Assets.pngs.logoMusicom.image(
                  // width: 250.w,
                  height: 50.h,
                ),
        ),
      ],
    );
  }
}
