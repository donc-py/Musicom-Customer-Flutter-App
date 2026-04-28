import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/barCode_scanner.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class MySearchBar extends ConsumerWidget {
  const MySearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // height: context.isTabletLandsCape ? 120.h : 80.h,
      color: AdaptiveTheme.of(context).mode.isDark
          ? AppColor.darkBackgroundColor
          : Colors.white,
      padding: EdgeInsets.all(15.r),
      child: Hero(
        tag: "searchBar",
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            // height: 48.h,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.borderColor,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: InkWell(
              onTap: () {
                // ref.read(bottomTabControllerProvider).jumpToPage(1);
                // ref.read(selectedIndexProvider.notifier).state = 1;
                // context.nav.pop(context);
                context.nav.pushNamed(Routes.cart);
              },
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                context.isTabletLandsCape
                    ? SizedBox(
                        child: SvgPicture.asset(
                          Assets.svgs.searchNormal,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SizedBox(
                        width: 24.r,
                        height: 24.r,
                        child: SvgPicture.asset(
                          Assets.svgs.searchNormal,
                          fit: BoxFit.cover,
                        ),
                      ),
                Gap(12.w),
                Expanded(
                  child: IgnorePointer(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: S.of(context).search,
                        hintStyle: AppTextStyle.normalBody.copyWith(
                          color: AppColor.borderColor,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 24.h,
                  color: AppColor.borderColor,
                ),
                Gap(12.w),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScannerScreen(),
                      ),
                    );
                  },
                  child: context.isTabletLandsCape
                      ? SvgPicture.asset(
                          Assets.svgs.scan,
                          fit: BoxFit.cover,
                          height: 50.h,
                        )
                      : SvgPicture.asset(
                          Assets.svgs.scan,
                          fit: BoxFit.cover,
                          width: 24.w,
                          height: 24.h,
                        ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
