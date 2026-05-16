import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pngs/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    Assets.pngs.logoMusicom.image(
                      height: 50.h,
                      width: 250.w,
                    ),
                    Text(
                      'MUSICOM',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    // ── Registrati con Email ──────────────────────────────
                    _SocialButton(
                      text: 'Registrati con Email',
                      icon: Icons.person_add_alt_1,
                      color: Colors.cyan,
                      onPressed: () =>
                          context.nav.pushNamed(Routes.register), // ← registro
                    ),
                    SizedBox(height: 8.h),
                    // ── Continua con Email (login) ────────────────────────
                    _SocialButton(
                      text: 'Continue with Email',
                      icon: Icons.email,
                      color: Colors.cyan.shade700,
                      onPressed: () => context.nav.pushNamed(Routes.login),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hai già un account? ',
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                        TextButton(
                          onPressed: () => context.nav.pushNamed(Routes.login),
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}
