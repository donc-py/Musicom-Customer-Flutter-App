import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/dashboard/dashboard_view.dart';
import 'package:readypos_flutter/views/museum/explore_view.dart';
import 'package:readypos_flutter/views/museum/museum_hub_view.dart';
import 'package:readypos_flutter/views/museum/news_list_view.dart';
import 'package:readypos_flutter/views/pos/pos_view.dart';

// ─── Tab index mapping ────────────────────────────────────────────────────
// 0 → Dashboard
// 1 → Explore (Esplora il MUCICOM)
// 2 → News (Novità)
// 3 → Cart / POS

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
                content: Text('Press back again to exit'),
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
          children: const [
            DashBoardViewScreen(), // 0 – Dashboard
            ExploreView(), // 1 – Esplora il MUCICOM
            NewsListView(), // 2 – Novità / News
            POSView(), // 3 – Cart / POS
          ],
        ),

        // ── Bottom Navigation Bar ──────────────────────────────────────────
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
            // 5 slots: [0]Dashboard  [1]Explore  [2]spacer  [3]News  [4]Cart
            children: List<Widget>.generate(5, (index) {
              if (index == 2) {
                return SizedBox(width: 30.w); // spacer for FAB
              }
              // Map slot index → tab index
              // slot 0 → tab 0 (Dashboard)
              // slot 1 → tab 1 (Explore)
              // slot 3 → tab 2 (News)
              // slot 4 → tab 3 (Cart)
              final int itemIndex = index < 2 ? index : index - 1;
              return _BottomNavItem(
                index: itemIndex,
                isActive: ref.watch(selectedIndexProvider) == itemIndex,
                onTap: () => pageController.jumpToPage(itemIndex),
              );
            }),
          ),
        ),

        // ── FAB → Museum Hub (Collezioni + Masterpiece + Artisti) ──────────
        floatingActionButton: keyboardIsOpened
            ? null
            : SizedBox(
                height: MediaQuery.sizeOf(context).shortestSide > 600
                    ? context.isTabletLandsCape
                        ? 90.h
                        : 70.h
                    : 55.h,
                width: MediaQuery.sizeOf(context).shortestSide > 600
                    ? context.isTabletLandsCape
                        ? 90.h
                        : 70.h
                    : 55.w,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MuseumHubView(),
                      ),
                    );
                  },
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(255, 195, 228, 192),
                  child: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Assets.pngs.icon.image(),
                  ),
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

// ─── Bottom Nav Item ──────────────────────────────────────────────────────

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  final int index;
  final bool isActive;
  final VoidCallback onTap;

  // Icons per tab index
  static const List<IconData> _icons = [
    Icons.dashboard_outlined, // 0 – Dashboard
    Icons.info_outline, // 1 – Esplora (Info)
    Icons.article_outlined, // 2 – News / Novità
    Icons.shopping_cart_outlined, // 3 – Cart
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
        width: 90.w,
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
