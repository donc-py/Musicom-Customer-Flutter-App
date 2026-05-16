import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/components/custom_text_field.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/auth_controller/auth_controller.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/auth/components/loginBG.dart';

class RegisterLayout extends ConsumerStatefulWidget {
  const RegisterLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterLayoutState();
}

class _RegisterLayoutState extends ConsumerState<RegisterLayout> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Simple check: all required fields filled
  bool get _isEnabled =>
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_rebuild);
    _emailController.addListener(_rebuild);
    _phoneController.addListener(_rebuild);
    _passwordController.addListener(_rebuild);
    _confirmPasswordController.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_isEnabled) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    ref
        .read(authControllerProvider.notifier)
        .register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        )
        .then((isSuccess) {
      if (isSuccess) {
        context.nav.pushNamed(Routes.core);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

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
                offset: const Offset(0.0, 0.0),
              )
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registrati',
                    style: AppTextStyle.extraLargeBody,
                  ),
                  Gap(24.h),

                  // Name
                  _fieldLabel(text: 'Nome'),
                  Gap(8.h),
                  CustomTextField(
                    controller: _nameController,
                    hint: 'Inserisci il tuo nome',
                  ),
                  Gap(16.h),

                  // Email
                  _fieldLabel(text: 'Email'),
                  Gap(8.h),
                  CustomTextField(
                    controller: _emailController,
                    hint: 'Inserisci la tua email',
                  ),
                  Gap(16.h),

                  // Phone
                  _fieldLabel(text: 'Telefono'),
                  Gap(8.h),
                  CustomTextField(
                    controller: _phoneController,
                    hint: '+39 000 000 0000',
                  ),
                  Gap(16.h),

                  // Password
                  _fieldLabel(text: 'Password'),
                  Gap(8.h),
                  CustomTextField(
                    controller: _passwordController,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    hint: 'Crea una password',
                  ),
                  Gap(16.h),

                  // Confirm password
                  _fieldLabel(text: 'Conferma Password'),
                  Gap(8.h),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    isPassword: true,
                    obscureText: _obscureConfirm,
                    hint: 'Ripeti la password',
                  ),
                  Gap(32.h),

                  // Submit button
                  isLoading
                      ? const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Registrati',
                            isEnabled: _isEnabled,
                            onPressed: _submit,
                          ),
                        ),

                  Gap(16.h),

                  // Back to login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hai già un account? ',
                        style: AppTextStyle.normalBody,
                      ),
                      TextButton(
                        onPressed: () => context.nav.pop(),
                        child: Text(
                          'Accedi',
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(8.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _fieldLabel({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: AppTextStyle.normalBody),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Icon(Icons.star, color: Colors.red, size: 8.w),
        ),
      ],
    );
  }
}
