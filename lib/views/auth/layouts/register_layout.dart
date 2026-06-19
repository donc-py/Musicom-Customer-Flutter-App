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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  final _nameKey = GlobalKey();
  final _emailKey = GlobalKey();
  final _phoneKey = GlobalKey();
  final _passwordKey = GlobalKey();
  final _confirmKey = GlobalKey();

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

    _nameFocus.addListener(() => _onFocus(_nameKey));
    _emailFocus.addListener(() => _onFocus(_emailKey));
    _phoneFocus.addListener(() => _onFocus(_phoneKey));
    _passwordFocus.addListener(() => _onFocus(_passwordKey));
    _confirmFocus.addListener(() => _onFocus(_confirmKey));
  }

  void _rebuild() => setState(() {});

  void _onFocus(GlobalKey key) {
    if (!(key == _nameKey && _nameFocus.hasFocus ||
        key == _emailKey && _emailFocus.hasFocus ||
        key == _phoneKey && _phoneFocus.hasFocus ||
        key == _passwordKey && _passwordFocus.hasFocus ||
        key == _confirmKey && _confirmFocus.hasFocus)) {
      return;
    }
    // Reintentamos varias veces durante la animación del teclado y
    // del AnimatedSize del logo, porque el layout sigue cambiando
    // por varios frames (no es instantáneo). Un solo
    // addPostFrameCallback no alcanza cuando hay animaciones de por
    // medio.
    _ensureVisibleRetrying(key, attemptsLeft: 6);
  }

  void _ensureVisibleRetrying(GlobalKey key, {required int attemptsLeft}) {
    if (attemptsLeft <= 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctx = key.currentContext;
      if (ctx == null) return;
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        alignment: 0.3,
      );
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 60), () {
        if (mounted) {
          _ensureVisibleRetrying(key, attemptsLeft: attemptsLeft - 1);
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
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
        .then((ok) {
      if (ok) context.nav.pushNamed(Routes.core);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      // ✅ TRUE. Esto es obligatorio para que el espacio disponible
      // se recalcule cuando el teclado aparece. Sin esto, nada de lo
      // demás funciona, sin importar cuánto código de scroll manual
      // se agregue.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LoginBG(
          child: Container(
            width: double.infinity,
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
                ),
              ],
            ),
            // ✅ El SingleChildScrollView ahora vive dentro de un
            // Expanded (definido en LoginBG), así que tiene una
            // altura máxima REAL y finita para hacer sus cálculos de
            // scroll. Antes, dentro del Positioned, esa altura era
            // ambigua.
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Registrati', style: AppTextStyle.extraLargeBody),
                    Gap(24.h),

                    _label('Nome'),
                    Gap(8.h),
                    CustomTextField(
                      key: _nameKey,
                      controller: _nameController,
                      hint: 'Inserisci il tuo nome',
                      focusNode: _nameFocus,
                    ),
                    Gap(16.h),

                    _label('Email'),
                    Gap(8.h),
                    CustomTextField(
                      key: _emailKey,
                      controller: _emailController,
                      hint: 'Inserisci la tua email',
                      focusNode: _emailFocus,
                    ),
                    Gap(16.h),

                    _label('Telefono'),
                    Gap(8.h),
                    CustomTextField(
                      key: _phoneKey,
                      controller: _phoneController,
                      hint: '+39 000 000 0000',
                      focusNode: _phoneFocus,
                    ),
                    Gap(16.h),

                    _label('Password'),
                    Gap(8.h),
                    CustomTextField(
                      key: _passwordKey,
                      controller: _passwordController,
                      isPassword: true,
                      obscureText: true,
                      hint: 'Crea una password',
                      focusNode: _passwordFocus,
                    ),
                    Gap(16.h),

                    _label('Conferma Password'),
                    Gap(8.h),
                    CustomTextField(
                      key: _confirmKey,
                      controller: _confirmPasswordController,
                      isPassword: true,
                      obscureText: true,
                      hint: 'Ripeti la password',
                      focusNode: _confirmFocus,
                    ),
                    Gap(32.h),

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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Hai già un account?',
                            style: AppTextStyle.normalBody),
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
      ),
    );
  }

  Widget _label(String text) {
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