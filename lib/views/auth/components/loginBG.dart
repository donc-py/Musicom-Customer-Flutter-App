import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';

class LoginBG extends StatelessWidget {
  const LoginBG({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // ✅ Si el teclado está abierto, ocultamos/encogemos el logo para
    // dar más espacio real al formulario. Esto es lo que hacen apps
    // modernas: el branding de arriba no es prioritario cuando el
    // usuario está escribiendo.
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo + SVG: solo se muestran si el teclado está cerrado.
        // AnimatedSwitcher/AnimatedSize para que la transición no
        // sea brusca.
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: keyboardOpen
              ? const SizedBox(width: double.infinity, height: 0)
              : Column(
                  children: [
                    Gap(70.h),
                    SizedBox(
                      height: 50.h,
                      width: 250.w,
                      child: AdaptiveTheme.of(context).mode.isDark
                          ? Assets.pngs.logoMusicom.image()
                          : Assets.pngs.logoMusicom.image(),
                    ).animate(delay: 400.ms).slideY(
                          begin: 6.5,
                          end: 0.0,
                          duration: const Duration(milliseconds: 1000),
                        ),
                    Gap(28.h),
                    SizedBox(
                      height: 150.h,
                      width: 210.w,
                      child: SvgPicture.asset(Assets.svgs.loginBG),
                    ).animate().slideY(
                          begin: 6,
                          end: 0.0,
                          duration: const Duration(milliseconds: 1000),
                        ),
                  ],
                ),
        ),
        // ✅ Expanded: el formulario recibe TODO el espacio restante
        // de la pantalla, que ya viene correctamente reducido por el
        // teclado gracias a resizeToAvoidBottomInset: true en el
        // Scaffold padre.
        Expanded(
          child: child
              .animate()
              .fadeIn(
                begin: 0.4,
                duration: const Duration(milliseconds: 600),
              ),
        ),
      ],
    );
  }
}