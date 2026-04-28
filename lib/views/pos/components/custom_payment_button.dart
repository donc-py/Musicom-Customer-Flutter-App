import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';

class CustomPaymentButton extends StatelessWidget {
  final String buttonText;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomPaymentButton({
    required this.buttonText,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AdaptiveTheme.of(context).mode.isDark
                  ? Colors.grey.withOpacity(0.5)
                  : const Color(0xffF0F8FF)
              : null,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : AppColor.borderColor,
            width: 2.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primaryColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColor.primaryColor : Colors.grey,
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16.r,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              buttonText,
              style: AppTextStyle.normalBody,
            ),
          ],
        ),
      ),
    );
  }
}
