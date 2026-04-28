// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class ProfileAppBar extends ConsumerWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppConstants.authBox).listenable(),
        builder: (context, authBox, _) {
          return Container(
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : AppColor.whiteColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              children: [
                Gap(50.h),
                Row(
                  children: [
                    Container(
                      height: 72.h,
                      width: 72.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: authBox.get(
                                  AppConstants.userData)?['profile_photo'] !=
                              null
                          ? CachedNetworkImage(
                              imageUrl: authBox
                                  .get(AppConstants.userData)['profile_photo'],
                            )
                          : const SizedBox(),
                    ),
                    Gap(20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authBox.get(AppConstants.userData)?['name'] ?? "",
                            style: AppTextStyle.largeBody,
                          ),
                          Gap(6.h),
                          Text(
                            authBox.get(AppConstants.userData)?['email'] ?? '',
                            style: AppTextStyle.smallBody.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: IconButton(
                        onPressed: () {
                          Box authBox = Hive.box(AppConstants.authBox);
                          authBox.clear().then(
                                (value) => context.nav.pushNamedAndRemoveUntil(
                                    Routes.login, (route) => false),
                              );
                        },
                        icon: SvgPicture.asset(
                          Assets.svgs.logout,
                          height: 32.h,
                          width: 32.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
