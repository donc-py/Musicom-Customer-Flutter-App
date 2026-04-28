import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/collection_controller/collection.dart';

class CollectionsListView extends ConsumerStatefulWidget {
  const CollectionsListView({super.key});

  @override
  ConsumerState<CollectionsListView> createState() =>
      _CollectionsListViewState();
}

class _CollectionsListViewState extends ConsumerState<CollectionsListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(collectionControllerProvider.notifier).getCollections(
          page: 1, perPage: 20, search: null, pagination: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(collectionControllerProvider);
    final items =
        ref.watch(collectionControllerProvider.notifier).collections ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Le nostre Collezioni', style: AppTextStyle.title),
        surfaceTintColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Text('Nessuna collezione disponibile',
                      style:
                          AppTextStyle.smallBody.copyWith(color: Colors.grey)))
              : RefreshIndicator(
                  onRefresh: () async {
                    ref
                        .read(collectionControllerProvider.notifier)
                        .getCollections(
                            page: 1,
                            perPage: 20,
                            search: null,
                            pagination: false);
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.r),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Gap(12.h),
                    itemBuilder: (_, i) {
                      final c = items[i];
                      return InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        onTap: () {
                          // navegar a masterpieces filtrado por colección
                          // Navigator.pushNamed(context, Routes.masterpiecesListView,
                          //   arguments: c.id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(10.r)),
                                child: c.thumbnail.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: c.thumbnail,
                                        width: 90.w,
                                        height: 90.w,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) =>
                                            _placeholder(),
                                      )
                                    : _placeholder(),
                              ),
                              Gap(12.w),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.h, horizontal: 4.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(c.name,
                                          style: AppTextStyle.normalBody
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right,
                                  color: Colors.grey[400]),
                              Gap(8.w),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _placeholder() => Container(
      width: 90.w,
      height: 90.w,
      color: Colors.grey[200],
      child: Icon(Icons.collections, color: Colors.grey[400]));
}
