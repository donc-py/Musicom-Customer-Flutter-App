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
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class POSAppBar extends ConsumerWidget {
  const POSAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        // give boder bottom with 1px
        border: Border(
          bottom: BorderSide(
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : AppColor.blueBackgroundColor,
            width: 1.5.h,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(55.h),
          Row(
            children: [
              InkWell(
                onTap: () {
                  //Navigator.pop(context);
                  ref.read(selectedIndexProvider.notifier).state = 0;
                  ref.read(bottomTabControllerProvider).jumpToPage(0);
                },
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  padding: EdgeInsets.all(7.w),
                  child: SvgPicture.asset(
                    Assets.svgs.arrowLeft,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Gap(20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).pos,
                      style: AppTextStyle.title,
                    ),
                    Consumer(builder: (context, ref, _) {
                      final realTimeClock = ref.watch(realTimeClockProvider);
                      return realTimeClock.when(
                        data: (data) {
                          return Text(
                            data,
                            style: AppTextStyle.smallBody,
                          );
                        },
                        loading: () => Text(
                          "Loading...",
                          style: AppTextStyle.smallBody,
                        ),
                        error: (e, s) => Text(
                          "Error",
                          style: AppTextStyle.smallBody,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  context.nav.pushNamed(Routes.draft);
                },
                child: Container(
                  // height: context.isTabletLandsCape ? 80.r : 48.h,
                  // width: context.isTabletLandsCape ? 80.r : 48.h,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AdaptiveTheme.of(context).mode.isDark
                        ? AppColor.greyBackgroundColor.withOpacity(0.2)
                        : AppColor.greyBackgroundColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SvgPicture.asset(
                    Assets.svgs.draftImg,
                    colorFilter: AdaptiveTheme.of(context).mode.isDark
                        ? const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          )
                        : ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.srcIn,
                          ),
                  ),
                ),
              ),
              Gap(15.w),
              InkWell(
                onTap: () {
                  context.nav.pushNamed(Routes.depositPOSScreen);
                },
                child: Container(
                  // height: context.isTabletLandsCape ? 80.r : 48.h,
                  // width: context.isTabletLandsCape ? 80.r : 48.h,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AdaptiveTheme.of(context).mode.isDark
                        ? AppColor.greyBackgroundColor.withOpacity(0.2)
                        : AppColor.greyBackgroundColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SvgPicture.asset(
                    Assets.svgs.walletAdd,
                    colorFilter: AdaptiveTheme.of(context).mode.isDark
                        ? const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          )
                        : ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.srcIn,
                          ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
