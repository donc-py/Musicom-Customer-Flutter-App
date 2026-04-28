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
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/dashboard/dashboard_view.dart';
import 'package:readypos_flutter/views/museum/news_list_view.dart';
import 'package:readypos_flutter/views/more/more_view.dart';
import 'package:readypos_flutter/views/products/products_hub_view.dart';
import 'package:readypos_flutter/views/reports/reports_view.dart';
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
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
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
          setState(() {
            _isBackPressed = true;
          });
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            _isBackPressed = false;
          });
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
            DashBoardViewScreen(),
            ProductsHubView(),
            NewsListView(),
            POSView(),
          ],
        ),
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
                offset: const Offset(
                  0.0,
                  0.0,
                ),
              )
            ],
            color: AdaptiveTheme.of(context).mode.isDark
                ? Colors.black
                : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List<Widget>.generate(
              5,
              (index) {
                if (index == 2) {
                  return SizedBox(width: 30.w);
                } else {
                  int itemIndex = index < 2 ? index : index - 1;
                  return BottomNavigationBar(
                    index: itemIndex,
                    isActive: ref.watch(selectedIndexProvider) == itemIndex,
                    onTap: () {
                      pageController.jumpToPage(itemIndex);
                    },
                  );
                }
              },
            ),
          ),
        ),
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
                    context.nav.pushNamed(Routes.pos);
                  },
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(255, 195, 228, 192),
                  // backgroundColor: AppColor.primaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    // child: SvgPicture.asset(
                    //   Assets.svgs.pos,
                    // ),
                    child: Assets.pngs.icon.image(),
                  ),
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

// ignore: must_be_immutable
class BottomNavigationBar extends StatelessWidget {
  BottomNavigationBar({
    super.key,
    required this.index,
    required this.onTap,
    required this.isActive,
  });

  final int index;
  Function onTap;
  final bool isActive;

  List<String> images = [
    Assets.svgs.dashboard,
    Assets.svgs.products,
    Assets.svgs.reports,
    Assets.svgs.more,
  ];

  List<String> text(context) => [
        S.of(context).dashboard,
        S.of(context).products,
        S.of(context).reports,
        S.of(context).More,
      ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: SizedBox(
        height: context.isTabletLandsCape ? 75.h : 68.h,
        width: 90.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              images[index],
              height: context.isTabletLandsCape ? 35.h : 24.h,
              width: 24.w,
              colorFilter: ColorFilter.mode(
                isActive ? AppColor.primaryColor : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            Gap(4.h),
            Text(
              text(context)[index],
              style: TextStyle(
                fontSize: context.isTabletLandsCape ? 10.sp : 12.sp,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColor.primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
