import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/routes.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.core,
            (_) => false,
          ),
          child: Container(
            padding: EdgeInsets.only(bottom: 1.w, right: 1.w, top: 1.h),
            child: Assets.pngs.logoMusicom.image(height: 50.h),
          ),
        ),
      ],
    );
  }
}
