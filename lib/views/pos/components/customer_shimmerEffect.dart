import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readypos_flutter/config/app_color.dart';

class CustomerShimmer extends StatelessWidget {
  const CustomerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return Container(
                height: 56.h,
                width: double.infinity,
                padding: EdgeInsets.all(15.h),
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: AppColor.shimmerColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              );
            })
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .shimmer(delay: 150.ms);
  }
}
