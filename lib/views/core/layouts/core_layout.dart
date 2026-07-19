import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/utils/barCode_scanner.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/dashboard/dashboard_view.dart';
import 'package:readypos_flutter/views/museum/explore_view.dart';
import 'package:readypos_flutter/views/museum/news_list_view.dart';
import 'package:readypos_flutter/views/pos/pos_view.dart';

class CoreLayout extends ConsumerStatefulWidget {
  const CoreLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoreLayoutState();
}

class _CoreLayoutState extends ConsumerState<CoreLayout> {
  bool _isBackPressed = false;

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(bottomTabControllerProvider);
    final bool keyboardIsOpened =
        MediaQuery.of(context).viewInsets.bottom != 0.0;

    return PopScope(
      canPop: _isBackPressed,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Premi di nuovo per uscire'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
          setState(() => _isBackPressed = true);
          await Future.delayed(const Duration(seconds: 2));
          setState(() => _isBackPressed = false);
        }
      },
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (index) {
            ref.watch(selectedIndexProvider.notifier).state = index;
          },
          children: [
            const DashBoardViewScreen(), // 0 – Dashboard
            const ExploreView(), // 1 – Esplora il MUCICOM
            const NewsListView(), // 2 – Novità / News
            const POSView(), // 3 – Cart / POS
          ],
        ),

        // ── Bottom Navigation Bar (scanner como item normal) ─────────────
        bottomNavigationBar: Container(
          height: context.isTabletLandsCape ? 110.h : 84.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AdaptiveTheme.of(context).mode.isDark
                    ? Colors.white.withOpacity(0.3)
                    : AppColor.shadowColor,
                blurRadius: 5.0,
                spreadRadius: 0.5,
                offset: const Offset(0.0, 0.0),
              )
            ],
            color: AdaptiveTheme.of(context).mode.isDark
                ? Colors.black
                : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _BottomNavItem(
                index: 0,
                isActive: ref.watch(selectedIndexProvider) == 0,
                onTap: () => pageController.jumpToPage(0),
              ),
              _BottomNavItem(
                index: 1,
                isActive: ref.watch(selectedIndexProvider) == 1,
                onTap: () => pageController.jumpToPage(1),
              ),
              // ── Scanner como item normal de la barra ──────────────────
              _ScannerNavItem(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ScannerScreen()),
                ),
              ),
              _BottomNavItem(
                index: 2,
                isActive: ref.watch(selectedIndexProvider) == 2,
                onTap: () => pageController.jumpToPage(2),
              ),
              _BottomNavItem(
                index: 3,
                isActive: ref.watch(selectedIndexProvider) == 3,
                onTap: () => pageController.jumpToPage(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Nav Item ────────────────────────────────────────────────────────

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  final int index;
  final bool isActive;
  final VoidCallback onTap;

  static const List<IconData> _icons = [
    Icons.dashboard_outlined,
    Icons.info_outline,
    Icons.article_outlined,
    Icons.shopping_cart_outlined,
  ];

  List<String> _labels(BuildContext context) => [
        S.of(context).dashboard,
        'Info',
        'Novità',
        'Carrello',
      ];

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColor.primaryColor : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: context.isTabletLandsCape ? 75.h : 68.h,
        width: 75.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icons[index],
                size: context.isTabletLandsCape ? 30.h : 24.h, color: color),
            Gap(4.h),
            Text(
              _labels(context)[index],
              style: TextStyle(
                fontSize: context.isTabletLandsCape ? 10.sp : 12.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Scanner Nav Item (icono del logo, sin estado activo) ──────────────────

// class _ScannerNavItem extends StatelessWidget {
//   const _ScannerNavItem({required this.onTap});

//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: SizedBox(
//         height: context.isTabletLandsCape ? 75.h : 68.h,
//         width: 75.w,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: context.isTabletLandsCape ? 34.h : 28.h,
//               width: context.isTabletLandsCape ? 34.h : 28.h,
//               child: Assets.pngs.icon.image(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _ScannerNavItem extends StatelessWidget {
  const _ScannerNavItem({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: context.isTabletLandsCape ? 75.h : 68.h,
        width: 75.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, -12.h), // ← sube el ícono 8 puntos
              child: SizedBox(
                height: context.isTabletLandsCape ? 34.h : 28.h,
                width: context.isTabletLandsCape ? 34.h : 28.h,
                child: Assets.pngs.icon.image(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}