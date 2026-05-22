import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/masterpiece_controller/masterpiece_controller.dart';
import 'package:readypos_flutter/models/collection/collection.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';
import 'package:readypos_flutter/routes.dart';

// ─── Argumentos para la ruta ──────────────────────────────────────────────
class CollectionDetailArgs {
  final Collection collection;
  const CollectionDetailArgs({required this.collection});
}

class CollectionDetailView extends ConsumerStatefulWidget {
  final Collection collection;
  const CollectionDetailView({super.key, required this.collection});

  @override
  ConsumerState<CollectionDetailView> createState() =>
      _CollectionDetailViewState();
}

class _CollectionDetailViewState extends ConsumerState<CollectionDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(masterpieceControllerProvider.notifier).getMasterpieces(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
            collectionId: widget.collection.id,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(masterpieceControllerProvider);
    final items =
        ref.watch(masterpieceControllerProvider.notifier).masterpieces ?? [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero imagen de la colección ─────────────────────────────────
          SliverAppBar(
            expandedHeight: 220.h,
            pinned: true,
            surfaceTintColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.collection.name,
                  style: const TextStyle(
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black54)])),
              background: widget.collection.thumbnail.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.collection.thumbnail,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(color: Colors.grey[300]),
                    )
                  : Container(color: Colors.grey[300]),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // descripción si existe
                  if (widget.collection.description != null &&
                      widget.collection.description!.isNotEmpty) ...[
                    Text(widget.collection.description!,
                        style: AppTextStyle.normalBody
                            .copyWith(color: Colors.grey[700])),
                    Gap(16.h),
                  ],
                  Text('Opere della collezione',
                      style: AppTextStyle.title.copyWith(fontSize: 18.sp)),
                  Gap(8.h),
                ],
              ),
            ),
          ),

          // ── Grid di masterpieces ────────────────────────────────────────
          isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()))
              : items.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                          child: Text('Nessuna opera disponibile',
                              style: AppTextStyle.smallBody
                                  .copyWith(color: Colors.grey))))
                  : SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.masterpieceDetail,
                              arguments: items[i],
                            ),
                            child: _MasterpieceTile(item: items[i]),
                          ),
                          childCount: items.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.75,
                        ),
                      ),
                    ),

          SliverToBoxAdapter(child: Gap(32.h)),
        ],
      ),
    );
  }
}

class _MasterpieceTile extends StatelessWidget {
  final Masterpiece item;
  const _MasterpieceTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: item.thumbnail != null
                ? CachedNetworkImage(
                    imageUrl: item.thumbnail!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (_, __, ___) =>
                        Container(color: Colors.grey[200]),
                  )
                : Container(color: Colors.grey[200]),
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
                  .copyWith(color: AppColor.primaryColor, fontSize: 10.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
