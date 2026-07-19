import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/routes.dart';

class LogoSection extends ConsumerWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // FIX: en vez de popUntil(isFirst) (que asume que CoreLayout ya es
            // la primera ruta), forzamos ir a Routes.core y eliminamos todo lo
            // demás del stack — así no importa si veníamos de Welcome, Login, etc.
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.core,
              (route) => false,
            );
            ref.read(selectedIndexProvider.notifier).state = 0;
            ref.read(bottomTabControllerProvider).jumpToPage(0);
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 1.w, right: 1.w, top: 1.h),
            child: Assets.pngs.logoMusicom.image(height: 65.h),
          ),
        ),
      ],
    );
  }
}