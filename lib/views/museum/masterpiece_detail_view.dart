import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';

class MasterpieceDetailView extends StatelessWidget {
  final Masterpiece masterpiece;
  const MasterpieceDetailView({super.key, required this.masterpiece});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // imagen hero en el appbar
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            surfaceTintColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: masterpiece.thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: masterpiece.thumbnail!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(color: Colors.grey[200]),
                    )
                  : Container(color: Colors.grey[200]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // título y artista
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child:
                            Text(masterpiece.title, style: AppTextStyle.title),
                      ),
                      if (masterpiece.brandName != null)
                        GestureDetector(
                          onTap: () {},
                          child: Text(masterpiece.brandName!,
                              style: AppTextStyle.normalBody.copyWith(
                                  color: AppColor.primaryColor,
                                  decoration: TextDecoration.underline)),
                        ),
                    ],
                  ),
                  Gap(8.h),
                  // colección y año
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.borderColor),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (masterpiece.collectionName != null)
                          GestureDetector(
                            onTap: () {},
                            child: Text(masterpiece.collectionName!,
                                style: AppTextStyle.normalBody.copyWith(
                                    color: AppColor.primaryColor,
                                    decoration: TextDecoration.underline)),
                          ),
                        if (masterpiece.year != null)
                          Text(masterpiece.year.toString(),
                              style: AppTextStyle.normalBody
                                  .copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Gap(16.h),
                  // In breve
                  if (masterpiece.shortDescription != null) ...[
                    _sectionTitle('In breve'),
                    Gap(8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.borderColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(masterpiece.shortDescription!,
                          style: AppTextStyle.normalBody
                              .copyWith(color: Colors.grey[700])),
                    ),
                    Gap(16.h),
                  ],
                  // Approfondisci
                  if (masterpiece.longDescription != null) ...[
                    _sectionTitle('Approfondisci'),
                    Gap(8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.borderColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(masterpiece.longDescription!,
                          style: AppTextStyle.normalBody
                              .copyWith(color: Colors.grey[700])),
                    ),
                  ],
                  Gap(32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(text,
      style: AppTextStyle.normalBody.copyWith(fontWeight: FontWeight.bold));
}
