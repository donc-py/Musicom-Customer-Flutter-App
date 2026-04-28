// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onPressed;
  const DeleteConfirmationDialog({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: ShapeDecoration(
          color: AdaptiveTheme.of(context).mode.isDark
              ? Colors.black
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Assets.svgs.delete),
            Gap(10.h),
            Text(
              S.of(context).deleteDialogDes,
              textAlign: TextAlign.center,
              style: AppTextStyle.title,
            ),
            Gap(16.h),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: CustomButton(
                    onPressed: () {
                      context.nav.pop();
                    },
                    text: S.of(context).cancel,
                    isBackgrounColor: false,
                  ),
                ),
                Gap(16.w),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: CustomButton(
                    onPressed: onPressed,
                    text: S.of(context).delete,
                    buttonColor: AppColor.redColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
