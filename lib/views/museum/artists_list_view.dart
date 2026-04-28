import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';

class ArtistsListView extends ConsumerStatefulWidget {
  const ArtistsListView({super.key});

  @override
  ConsumerState<ArtistsListView> createState() => _ArtistsListViewState();
}

class _ArtistsListViewState extends ConsumerState<ArtistsListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(brandControllerProvider.notifier)
          .getBrands(page: 1, perPage: 20, search: null, pagination: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(brandControllerProvider);
    final items = ref.watch(brandControllerProvider.notifier).brands ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('I nostri Artisti', style: AppTextStyle.title),
        surfaceTintColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Text('Nessun artista disponibile',
                      style:
                          AppTextStyle.smallBody.copyWith(color: Colors.grey)))
              : RefreshIndicator(
                  onRefresh: () async {
                    ref.read(brandControllerProvider.notifier).getBrands(
                        page: 1, perPage: 20, search: null, pagination: false);
                  },
                  child: GridView.builder(
                    padding: EdgeInsets.all(16.r),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final a = items[i];
                      return GestureDetector(
                        onTap: () {
                          // navegar a masterpieces filtrado por artista
                        },
                        child: Column(
                          children: [
                            ClipOval(
                              child: a.thumbnail != null
                                  ? CachedNetworkImage(
                                      imageUrl: a.thumbnail!,
                                      width: 80.w,
                                      height: 80.w,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) =>
                                          _placeholder(),
                                    )
                                  : _placeholder(),
                            ),
                            Gap(8.h),
                            Text(a.name,
                                textAlign: TextAlign.center,
                                style: AppTextStyle.smallBody
                                    .copyWith(fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _placeholder() => Container(
      width: 80.w,
      height: 80.w,
      color: Colors.grey[200],
      child: Icon(Icons.person, color: Colors.grey[400]));
}
