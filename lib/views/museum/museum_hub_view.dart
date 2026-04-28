import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/collection_controller/collection.dart';
import 'package:readypos_flutter/controllers/masterpiece_controller/masterpiece_controller.dart';
import 'package:readypos_flutter/models/brand/brand.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/views/dashboard/components/logo_section.dart';
import 'package:readypos_flutter/views/core/components/app_drawer.dart';

class MuseumHubView extends ConsumerWidget {
  const MuseumHubView({super.key});

  // ─── helpers ─────────────────────────────────────────────────────────────

  Widget _sectionHeader(BuildContext context, String title,
      {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.title.copyWith(fontSize: 18.sp)),
        TextButton(
          onPressed: onSeeAll ?? () {},
          child: Text('See all',
              style: TextStyle(color: Colors.blue, fontSize: 14.sp)),
        ),
      ],
    );
  }

  Widget _emptyText(String msg) => Center(
        child: Text(msg,
            style: AppTextStyle.smallBody.copyWith(color: Colors.grey)),
      );

  Widget _networkImage(String? url,
      {double? w, double? h, BoxFit fit = BoxFit.cover}) {
    if (url == null) {
      return Container(
          width: w,
          height: h,
          color: Colors.grey[200],
          child: Icon(Icons.image, color: Colors.grey[400], size: 28.r));
    }
    return SizedBox(
      width: w,
      height: h,
      child: Image.network(url,
          fit: fit,
          errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: Icon(Icons.image, color: Colors.grey[400], size: 28.r))),
    );
  }

  // ─── collezioni ──────────────────────────────────────────────────────────

  Widget _buildCollectionItem(
      BuildContext context, String title, String description,
      {String? imageUrl}) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3)
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: _networkImage(imageUrl, w: 60.w, h: 60.w),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyle.normalBody
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(description,
                    style: AppTextStyle.smallBody.copyWith(color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── artisti ─────────────────────────────────────────────────────────────

  Widget _buildArtistItem(Brand artist) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2))
            ],
          ),
          child: ClipOval(
            child: _networkImage(artist.thumbnail, w: 80.w, h: 80.w),
          ),
        ),
        Gap(8.h),
        SizedBox(
          width: 80.w,
          child: Text(artist.name,
              textAlign: TextAlign.center,
              style:
                  AppTextStyle.smallBody.copyWith(fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  // ─── masterpieces ────────────────────────────────────────────────────────

  Widget _buildMasterpieceItem(Masterpiece item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: _networkImage(item.thumbnail,
                w: double.infinity, fit: BoxFit.cover),
          ),
        ),
        Gap(4.h),
        Text(item.title,
            style: AppTextStyle.smallBody.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        if (item.brandName != null)
          Text(item.brandName!,
              style: AppTextStyle.smallBody
                  .copyWith(color: Colors.grey, fontSize: 10.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
      ],
    );
  }

  // ─── BUILD ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // header
          Container(
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : AppColor.whiteColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(68.h),
                const LogoSection(),
              ],
            ),
          ),
          // search bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3)
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          Gap(8.w),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search (opere, autori)...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.filter_list), onPressed: () {}),
                ],
              ),
            ),
          ),
          // scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Le nostre Collezioni ────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(builder: (context, ref, _) {
                      final ctrl =
                          ref.watch(collectionControllerProvider.notifier);
                      final isLoading = ref.watch(collectionControllerProvider);
                      final collections = ctrl.collections;
                      return Column(
                        children: [
                          _sectionHeader(context, 'Le nostre Collezioni',
                              onSeeAll: () => Navigator.pushNamed(
                                  context, Routes.collectionsListView)),
                          Gap(12.h),
                          if (isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (collections == null || collections.isEmpty)
                            _emptyText('No collections available')
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: collections.length,
                              separatorBuilder: (_, __) => Gap(8.h),
                              itemBuilder: (_, i) => _buildCollectionItem(
                                context,
                                collections[i].name,
                                'No description available',
                                imageUrl: collections[i].thumbnail,
                              ),
                            ),
                        ],
                      );
                    }),
                  ),

                  Gap(16.h),

                  // ── I nostri Masterpiece ────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(builder: (context, ref, _) {
                      final ctrl =
                          ref.watch(masterpieceControllerProvider.notifier);
                      final isLoading =
                          ref.watch(masterpieceControllerProvider);
                      final items = ctrl.masterpieces;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(context, 'I nostri Masterpiece',
                              onSeeAll: () => Navigator.pushNamed(
                                  context, Routes.masterpiecesListView)),
                          Gap(12.h),
                          if (isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (items == null || items.isEmpty)
                            _emptyText('No masterpieces available')
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.w,
                                mainAxisSpacing: 8.h,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: items.length,
                              itemBuilder: (_, i) =>
                                  _buildMasterpieceItem(items[i]),
                            ),
                        ],
                      );
                    }),
                  ),

                  Gap(16.h),

                  // ── I nostri Artisti ────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(builder: (context, ref, _) {
                      final ctrl = ref.watch(brandControllerProvider.notifier);
                      final isLoading = ref.watch(brandControllerProvider);
                      final artists = ctrl.brands;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(context, 'I nostri Artisti',
                              onSeeAll: () => Navigator.pushNamed(
                                  context, Routes.artistsListView)),
                          Gap(12.h),
                          SizedBox(
                            height: 128.h,
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : (artists == null || artists.isEmpty)
                                    ? _emptyText('No artists available')
                                    : ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: artists.length,
                                        separatorBuilder: (_, __) => Gap(16.w),
                                        itemBuilder: (_, i) =>
                                            _buildArtistItem(artists[i]),
                                      ),
                          ),
                        ],
                      );
                    }),
                  ),

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
