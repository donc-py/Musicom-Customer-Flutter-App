import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/components/custom_text_field.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/controllers/auth_controller/auth_controller.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/auth/components/loginBG.dart';

class LoginLayout extends ConsumerStatefulWidget {
  const LoginLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends ConsumerState<LoginLayout> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isEnabled = true;
  @override
  void initState() {
    super.initState();
    // _emailController.addListener(_updateButtonState);
    // _passwordController.addListener(_updateButtonState);
    if (kDebugMode) {
      _emailController.text = "admin@example.com";
      _passwordController.text = "secret";
    }
    // _emailController.text = "admin@example.com";
    // _passwordController.text = "secret";
  }

  void _updateButtonState() {
    setState(() {
      isEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBG(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: AdaptiveTheme.of(context).mode.isDark
                ? Colors.black
                : AppColor.whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: AdaptiveTheme.of(context).mode.isDark
                    ? Colors.white
                    : AppColor.shadowColor,
                blurRadius: 5.0,
                spreadRadius: 0.5,
                offset: const Offset(
                  0.0,
                  0.0,
                ),
              )
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Text(
                  "Login",
                  style: AppTextStyle.extraLargeBody,
                ),
              ],
            ),
            Gap(24.h),
            textFieldHeader(text: "Email"),
            Gap(8.h),
            CustomTextField(
              controller: _emailController,
              hint: "Enter Email",
            ),
            Gap(24.h),
            textFieldHeader(text: "Password"),
            Gap(8.h),
            CustomTextField(
              controller: _passwordController,
              isPassword: true,
              obscureText: true,
              hint: "Enter Password",
            ),
            Gap(32.h),
            ref.watch(authControllerProvider)
                ? const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    // height: context.isTabletLandsCape ? 90.h : 48.h,
                    child: CustomButton(
                      text: "Login",
                      isEnabled: isEnabled,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (isEnabled) {
                          ref
                              .read(authControllerProvider.notifier)
                              .login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              )
                              .then((isSuccess) {
                            if (isSuccess) {
                              ref.read(appcurrencyNotifierProvider);
                              context.nav.pushNamed(Routes.core);
                            }
                          });
                        }
                      },
                    ),
                  ),
          ]),
        ),
      ),
      // bottomNavigationBar: Container(
      //   color: AdaptiveTheme.of(context).mode.isDark
      //       ? Colors.black
      //       : AppColor.blueBackgroundColor,
      //   height: 75.h,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           footerButton(text: "Admin"),
      //           footerButton(text: "Owner"),
      //           footerButton(text: "Go to POS"),
      //         ],
      //       ),
      //       Gap(1.h),
      //       Text(
      //         "Only for Demo",
      //         style: AppTextStyle.extraLargeBody
      //             .copyWith(fontSize: 8.sp, color: Colors.red),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  Container footerButton({required String text}) {
    return Container(
      width: 115.w,
      height: 45.h,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).mode.isDark
            ? Colors.black
            : AppColor.whiteColor,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: AdaptiveTheme.of(context).mode.isDark
                ? Colors.white
                : Colors.transparent,
            blurRadius: 5.0,
            spreadRadius: 0.5,
            offset: const Offset(
              0.0,
              0.0,
            ),
          )
        ],
      ),
      child: Text(
        text,
        style: AppTextStyle.normalBody.copyWith(
          fontSize: 14.sp,
          color: AppColor.primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Row textFieldHeader({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTextStyle.normalBody,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Icon(
            Icons.star,
            color: Colors.red,
            size: 8.w,
          ),
        )
      ],
    );
  }
}
