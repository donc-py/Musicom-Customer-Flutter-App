import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/models/news/news.dart';

class NewsDetailView extends StatelessWidget {
  final News news;
  const NewsDetailView({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final dateStr = news.publishedAt != null
        ? DateFormat('d MMMM yyyy').format(news.publishedAt!)
        : '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260.h,
            pinned: true,
            surfaceTintColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: news.thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: news.thumbnail!,
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
                  // categoría y fecha
                  Row(
                    children: [
                      if (news.category != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(news.category!,
                              style: AppTextStyle.smallBody.copyWith(
                                  color: AppColor.primaryColor,
                                  fontSize: 11.sp)),
                        ),
                        Gap(8.w),
                      ],
                      Text(dateStr,
                          style: AppTextStyle.smallBody
                              .copyWith(color: Colors.grey)),
                    ],
                  ),
                  Gap(12.h),
                  Text(news.title, style: AppTextStyle.title),
                  if (news.excerpt != null) ...[
                    Gap(10.h),
                    Text(news.excerpt!,
                        style: AppTextStyle.normalBody.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic)),
                  ],
                  if (news.body != null) ...[
                    Gap(16.h),
                    Divider(color: AppColor.borderColor),
                    Gap(12.h),
                    Text(news.body!,
                        style: AppTextStyle.normalBody
                            .copyWith(color: Colors.grey[800], height: 1.6)),
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
}
