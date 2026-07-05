import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';

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
            // 1. cierra cualquier pantalla apilada encima de CoreLayout
            Navigator.of(context).popUntil((route) => route.isFirst);
            // 2. resetea el índice del bottom nav a Dashboard (0)
            ref.read(selectedIndexProvider.notifier).state = 0;
            // 3. mueve el PageView a la página 0
            ref.read(bottomTabControllerProvider).jumpToPage(0);
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 1.w, right: 1.w, top: 1.h),
            child: Assets.pngs.logoMusicom.image(height: 50.h),
          ),
        ),
      ],
    );
  }
}