import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/more/components/language_dialog.dart';
import 'package:readypos_flutter/views/more/components/profileAppBar.dart';
import 'package:readypos_flutter/views/more/components/profile_button.dart';
import 'package:readypos_flutter/views/products/layouts/products_hub_layout.dart';

class MoreLayout extends ConsumerWidget {
  const MoreLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          context.isTabletLandsCape
              ? 190.h
              : 165.h - MediaQuery.of(context).padding.top,
        ),
        child: const ProfileAppBar(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        color: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : AppColor.whiteColor,
        child: ListView(
          children: [
            const Align(
                alignment: Alignment.centerRight, child: ThemeChangeButton()),
            // ThemeChangeButton(),
            Gap(16.h),
            ProfileButton(
              title: S.of(context).adminProfile,
              icon: Assets.svgs.profile,
              onTap: () {
                context.nav.pushNamed(Routes.adminProfile);
              },
            ),
            Gap(16.h),
            ProfileButton(
              title: S.of(context).products,
              icon: Assets.svgs.purchases,
              onTap: () {
                context.nav.push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductsHubLayout(),
                  ),
                );
              },
            ),
            Gap(16.h),
            ProfileButton(
              title: S.of(context).purchases,
              icon: Assets.svgs.purchases,
              onTap: () {
                context.nav.pushNamed(Routes.purchase);
              },
            ),
            Gap(16.h),
            ProfileButton(
              title: S.of(context).sales,
              icon: Assets.svgs.sales,
              onTap: () {
                context.nav.pushNamed(Routes.sales);
              },
            ),
            Gap(16.h),
            ProfileButton(
              title: S.of(context).expenses,
              icon: Assets.svgs.expenses,
              onTap: () {
                context.nav.pushNamed(Routes.expenses);
              },
            ),
            Gap(16.h),
            ProfileButton(
              title: S.of(context).accounting,
              icon: Assets.svgs.accounting,
              onTap: () {
                context.nav.pushNamed(Routes.accounting);
              },
            ),
            Gap(16.h),
            ProfileButton(
              title: S.of(context).language,
              icon: Assets.svgs.profile,
              onTap: () {
                showModalBottomSheet(
                  isDismissible: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return ShowLanguage();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeChangeButton extends StatefulWidget {
  const ThemeChangeButton({super.key});

  @override
  _ThemeChangeButtonState createState() => _ThemeChangeButtonState();
}

class _ThemeChangeButtonState extends State<ThemeChangeButton> {
  void _toggleTheme(BuildContext context) {
    if (AdaptiveTheme.of(context).mode.isDark) {
      AdaptiveTheme.of(context).setLight();
    } else {
      AdaptiveTheme.of(context).setDark();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(right: 10.r),
      width: 90.0,
      height: 40.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(30.0),
          onTap: () {
            _toggleTheme(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 10),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: AdaptiveTheme.of(context).mode.isLight
                    ? SvgPicture.asset(
                        Assets.svgs.switchDark,
                        key: UniqueKey(),
                        width: 80.0,
                        height: 40.0,
                      )
                    : SvgPicture.asset(
                        Assets.svgs.switchLight,
                        key: UniqueKey(),
                        width: 80.0,
                        height: 40.0,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
