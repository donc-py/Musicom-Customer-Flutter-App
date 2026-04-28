import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/dashboard_controller/dashoard.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/generated/l10n.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  List<Map<String, dynamic>> getPeriodic(BuildContext context) {
    return [
      {
        "key": S.of(context).daily,
        "value": 'daily',
      },
      {
        "key": S.of(context).weekly,
        "value": 'weekly',
      },
      {
        "key": S.of(context).monthly,
        "value": 'monthly',
      },
      {
        "key": S.of(context).yearly,
        "value": 'yearly',
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppConstants.authBox).listenable(),
        builder: (context, authBox, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${authBox.get(AppConstants.userData)['name']}",
                    style: AppTextStyle.title,
                  ),
                  Gap(4.h),
                  Text(
                    S.of(context).welcomeToReadyPos,
                    style: AppTextStyle.smallBody.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Gap(15.h),
              Consumer(builder: (context, ref, _) {
                final periodicItem = ref.watch(dashboardPeriodicProvider);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      getPeriodic(context).length,
                      (index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 5.h),
                          margin: EdgeInsets.only(right: 10.w),
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            color: periodicItem ==
                                    getPeriodic(context)[index]['value']
                                ? AppColor.primaryColor
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.r,
                                color: periodicItem ==
                                        getPeriodic(context)[index]['value']
                                    ? AppColor.primaryColor
                                    : AppColor.borderColor,
                              ),
                              borderRadius: BorderRadius.circular(48.r),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(dashboardPeriodicProvider.notifier)
                                  .state = getPeriodic(context)[index]['value'];
                              ref.refresh(dashboardInfoControllerProvider);
                            },
                            child: Text(
                              getPeriodic(context)[index]['key'],
                              textAlign: TextAlign.center,
                              style: AppTextStyle.normalBody.copyWith(
                                fontSize: 14.sp,
                                color: periodicItem ==
                                        getPeriodic(context)[index]['value']
                                    ? AppColor.whiteColor
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ],
          );
        });
  }
}
