import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class SplashLayout extends ConsumerStatefulWidget {
  const SplashLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashLayoutState();
}

class _SplashLayoutState extends ConsumerState<SplashLayout> {
  @override
  void initState() {
    super.initState();
    Box authBox = Hive.box(AppConstants.authBox);
    Future.delayed(const Duration(seconds: 3), () {
      if (authBox.get(AppConstants.authToken) != null) {
        ref.read(appcurrencyNotifierProvider);
        context.nav.pushNamedAndRemoveUntil(
          Routes.core,
          (route) => false,
        );
      } else {
        context.nav.pushNamedAndRemoveUntil(
          Routes.welcome,
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Follow this instruction
    // logo height 56
    // logo width 248

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.pngs.logoMusicom.image(
              height: 50.h,
              width: 250.w,
            )
            .animate(autoPlay: true)
            .slideY(
              begin: 10.0,
              end: 8.0,
              duration: const Duration(milliseconds: 1000),
            )
            .fadeIn(
              begin: 0.0,
              duration: const Duration(milliseconds: 800),
            ),
            SizedBox(height: 16.h),
            Text(
              'MUCICOM',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Museo Civico Comunale\nMulticulturale',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Biancavilla',
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
