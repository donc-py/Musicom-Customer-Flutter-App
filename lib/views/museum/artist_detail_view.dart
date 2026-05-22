import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/masterpiece_controller/masterpiece_controller.dart';
import 'package:readypos_flutter/models/brand/brand.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';
import 'package:readypos_flutter/routes.dart';

class ArtistDetailView extends ConsumerStatefulWidget {
  final Brand artist;
  const ArtistDetailView({super.key, required this.artist});

  @override
  ConsumerState<ArtistDetailView> createState() => _ArtistDetailViewState();
}

class _ArtistDetailViewState extends ConsumerState<ArtistDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(masterpieceControllerProvider.notifier).getMasterpieces(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
            brandId: widget.artist.id, // filtra por artista
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
          // ── Hero con foto circular del artista ──────────────────────────
          SliverAppBar(
            expandedHeight: 260.h,
            pinned: true,
            surfaceTintColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // fondo desenfocado con la misma imagen
                  widget.artist.thumbnail != null
                      ? CachedNetworkImage(
                          imageUrl: widget.artist.thumbnail!,
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.4),
                          colorBlendMode: BlendMode.darken,
                          errorWidget: (_, __, ___) =>
                              Container(color: Colors.grey[800]),
                        )
                      : Container(color: Colors.grey[800]),
                  // foto circular centrada
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Gap(40.h),
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3.w),
                          ),
                          child: ClipOval(
                            child: widget.artist.thumbnail != null
                                ? CachedNetworkImage(
                                    imageUrl: widget.artist.thumbnail!,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) =>
                                        Container(color: Colors.grey[300]),
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.person,
                                        size: 50.r, color: Colors.grey[500])),
                          ),
                        ),
                        Gap(12.h),
                        Text(widget.artist.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                shadows: const [
                                  Shadow(blurRadius: 4, color: Colors.black54)
                                ])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Text('Opere dell\'artista',
                  style: AppTextStyle.title.copyWith(fontSize: 18.sp)),
            ),
          ),

          // ── Grid di masterpieces filtrado por artista ───────────────────
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

// ─── Tile reutilizable ───────────────────────────────────────────────────────

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
