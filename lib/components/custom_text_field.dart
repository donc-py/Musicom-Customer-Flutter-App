import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    this.title,
    required this.hint,
    this.isPassword = false,
    required this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.onChanged,
    this.validator,
    this.minLine = 1,
    this.textInputAction = TextInputAction.next,
  });
  String? title;
  String hint;
  bool isPassword = false;
  bool obscureText;
  bool readOnly;
  Widget? prefixIcon;
  int minLine;
  TextInputAction textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;
    return Column(
      children: [
        if (widget.title != null) ...[
          Row(
            children: [
              Text(
                widget.title ?? '',
                style: AppTextStyle.normalBody,
              ),
              Text(
                '*',
                style:
                    AppTextStyle.normalBody.copyWith(color: AppColor.redColor),
              )
            ],
          ),
          Gap(10.h),
        ],
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          maxLines: widget.minLine != 1 ? 3 : 1,
          minLines: widget.minLine,
          textInputAction: widget.textInputAction,
          style: isLargeScreen
              ? AppTextStyle.normalBody.copyWith(fontSize: 12.sp)
              : AppTextStyle.normalBody.copyWith(fontSize: 14.sp),
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hint,
            hintStyle: isLargeScreen
                ? AppTextStyle.normalBody.copyWith(
                    fontSize: 13.sp,
                    color: const Color(0xffD1D5DB),
                  )
                : AppTextStyle.normalBody.copyWith(
                    fontSize: 15.sp,
                    color: const Color(0xffD1D5DB),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColor.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  const BorderSide(color: AppColor.borderColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: widget.readOnly
                    ? AppColor.borderColor
                    : AppColor.primaryColor,
                width: widget.readOnly ? 2 : 1,
              ),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        widget.obscureText = !widget.obscureText;
                      });
                    },
                    icon: Icon(
                      widget.obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                  )
                : null,
            prefixIcon: widget.prefixIcon,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
