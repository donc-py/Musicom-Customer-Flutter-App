import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/news_controller/news_controller.dart';
import 'package:readypos_flutter/models/news/news.dart';
import 'package:readypos_flutter/routes.dart';

class NewsListView extends ConsumerStatefulWidget {
  const NewsListView({super.key});

  @override
  ConsumerState<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends ConsumerState<NewsListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(newsControllerProvider.notifier)
          .getNews(page: 1, perPage: 20, search: null, pagination: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(newsControllerProvider);
    final items = ref.watch(newsControllerProvider.notifier).news ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Novità dal MUCICOM', style: AppTextStyle.title),
        surfaceTintColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Text('Nessuna notizia disponibile',
                      style:
                          AppTextStyle.smallBody.copyWith(color: Colors.grey)))
              : RefreshIndicator(
                  onRefresh: () async {
                    ref.read(newsControllerProvider.notifier).getNews(
                        page: 1, perPage: 20, search: null, pagination: false);
                  },
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Divider(
                        height: 0,
                        indent: 16.w,
                        endIndent: 16.w,
                        color: AppColor.borderColor),
                    itemBuilder: (_, i) => _NewsListTile(news: items[i]),
                  ),
                ),
    );
  }
}

class _NewsListTile extends StatelessWidget {
  final News news;
  const _NewsListTile({required this.news});

  @override
  Widget build(BuildContext context) {
    final dateStr = news.publishedAt != null
        ? DateFormat('d MMM yyyy').format(news.publishedAt!)
        : '';

    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, Routes.newsDetail, arguments: news),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.category != null)
                    Text(news.category!,
                        style: AppTextStyle.smallBody
                            .copyWith(color: Colors.grey, fontSize: 10.sp)),
                  Gap(2.h),
                  Text(news.title,
                      style: AppTextStyle.normalBody
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  if (news.excerpt != null) ...[
                    Gap(4.h),
                    Text(news.excerpt!,
                        style:
                            AppTextStyle.smallBody.copyWith(color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                  Gap(6.h),
                  Text(dateStr,
                      style: AppTextStyle.smallBody
                          .copyWith(color: Colors.grey, fontSize: 10.sp)),
                ],
              ),
            ),
            Gap(12.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: news.thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: news.thumbnail!,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
      width: 80.w,
      height: 80.w,
      color: Colors.grey[200],
      child: Icon(Icons.article, color: Colors.grey[400]));
}
