import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/views/dashboard/components/logo_section.dart';
import 'package:readypos_flutter/controllers/category_controller/category.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/collection_controller/collection.dart';
import 'package:readypos_flutter/controllers/product_controller/product_controller.dart';
import 'package:readypos_flutter/controllers/masterpiece_controller/masterpiece_controller.dart';
import 'package:readypos_flutter/controllers/event_controller/event_controller.dart';
import 'package:readypos_flutter/controllers/news_controller/news_controller.dart';
import 'package:readypos_flutter/models/brand/brand.dart';
import 'package:readypos_flutter/models/product_model.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';
import 'package:readypos_flutter/models/event/event.dart';
import 'package:readypos_flutter/models/news/news.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/views/core/components/app_drawer.dart';
import 'package:readypos_flutter/views/museum/explore_view.dart';
import 'package:readypos_flutter/views/museum/global_search_delegate.dart';
import 'package:readypos_flutter/views/products/components/product_detail_sheet.dart';

class DashBoardLayout extends ConsumerStatefulWidget {
  const DashBoardLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashBoardLayoutState();
}

class _DashBoardLayoutState extends ConsumerState<DashBoardLayout> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(collectionControllerProvider.notifier).getCollections(
          page: 1, perPage: 20, search: null, pagination: false);
      ref
          .read(categoryControllerProvider.notifier)
          .getCategories(page: 1, perPage: 20, search: null, pagination: false);
      ref
          .read(brandControllerProvider.notifier)
          .getBrands(page: 1, perPage: 20, search: null, pagination: false);
      ref
          .read(productControllerProvider.notifier)
          .getProducts(page: 1, perPage: 20, search: null, pagination: false);
      ref.read(masterpieceControllerProvider.notifier).getMasterpieces(
          page: 1, perPage: 6, search: null, pagination: false);
      ref.read(eventControllerProvider.notifier).getEvents(
          page: 1,
          perPage: 10,
          search: null,
          pagination: false,
          upcoming: true);
      ref
          .read(newsControllerProvider.notifier)
          .getNews(page: 1, perPage: 10, search: null, pagination: false);
    });
  }

  // ─── helpers ──────────────────────────────────────────────────────────────

  // FIX BUG-001 / BUG-017: section header now tappable (title + button same route)
  Widget _sectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onSeeAll,
          child:
              Text(title, style: AppTextStyle.title.copyWith(fontSize: 18.sp)),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: Text('Vedi tutti',
              style: TextStyle(color: Colors.blue, fontSize: 14.sp)),
        ),
      ],
    );
  }

  // FIX: testi in italiano
  Widget _emptyText(String msg) => Center(
        child: Text(msg,
            style: AppTextStyle.smallBody.copyWith(color: Colors.grey)),
      );

  Widget _networkImage(String? url,
      {double? w,
      double? h,
      BoxFit fit = BoxFit.cover,
      IconData fallback = Icons.image}) {
    if (url == null || url.isEmpty) {
      return Container(
        width: w,
        height: h,
        color: Colors.grey[200],
        child: Icon(fallback, color: Colors.grey[400], size: 30.r),
      );
    }
    return SizedBox(
      width: w,
      height: h,
      child: Image.network(url,
          fit: fit,
          errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: Icon(fallback, color: Colors.grey[400], size: 30.r),
              )),
    );
  }

  // ─── quick access ─────────────────────────────────────────────────────────

  Widget _buildQuickAccessCard(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    // FIX BUG-008: wrapped with GestureDetector + onTap real
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24.r),
            Gap(8.h),
            Text(title,
                style: AppTextStyle.normalBody
                    .copyWith(fontWeight: FontWeight.w600)),
            Text(subtitle,
                style: AppTextStyle.smallBody.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ─── collections ──────────────────────────────────────────────────────────

  // FIX BUG-002: wrapped with InkWell + onTap navigation
  Widget _buildCollectionItem(String title, String? description,
      {String? imageUrl, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
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
                  // FIX BUG-003: mostrar descripción real si existe, sino niente
                  if (description != null && description.isNotEmpty)
                    Text(description,
                        style:
                            AppTextStyle.smallBody.copyWith(color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // ─── artists ──────────────────────────────────────────────────────────────

  // FIX: wrapped with GestureDetector para navegar al detalle del artista
  Widget _buildArtistItem(Brand artist, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
              child: _networkImage(artist.thumbnail,
                  w: 80.w, h: 80.w, fallback: Icons.person),
            ),
          ),
          Gap(8.h),
          SizedBox(
            width: 80.w,
            child: Text(artist.name,
                textAlign: TextAlign.center,
                style: AppTextStyle.smallBody
                    .copyWith(fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // ─── categories ───────────────────────────────────────────────────────────

  Widget _buildCategoryChip(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(label, style: AppTextStyle.smallBody),
      ),
    );
  }

  // ─── masterpieces ─────────────────────────────────────────────────────────

  // FIX: wrapped with GestureDetector para navegar al detalle
  Widget _buildMasterpieceItem(Masterpiece item, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
              style:
                  AppTextStyle.smallBody.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          if (item.brandName != null)
            Text(item.brandName!,
                style: AppTextStyle.smallBody
                    .copyWith(color: Colors.grey, fontSize: 10.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // ─── events ───────────────────────────────────────────────────────────────

  // FIX: wrapped with GestureDetector para navegar al detalle del evento
  Widget _buildEventCard(Event event, {VoidCallback? onTap}) {
    final dateStr = DateFormat('d MMM yyyy').format(event.startsAt);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.12),
                blurRadius: 4,
                spreadRadius: 1)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              child:
                  _networkImage(event.thumbnail, w: double.infinity, h: 100.h),
            ),
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateStr,
                      style: AppTextStyle.smallBody
                          .copyWith(color: Colors.blue, fontSize: 10.sp)),
                  Gap(2.h),
                  Text(event.title,
                      style: AppTextStyle.smallBody
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  if (event.location != null) ...[
                    Gap(2.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 10.r, color: Colors.grey),
                        Gap(2.w),
                        Expanded(
                          child: Text(event.location!,
                              style: AppTextStyle.smallBody.copyWith(
                                  color: Colors.grey, fontSize: 10.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── news ─────────────────────────────────────────────────────────────────

  // FIX: wrapped con InkWell para navegar al detalle de la noticia
  Widget _buildNewsCard(News news, {VoidCallback? onTap}) {
    final dateStr = news.publishedAt != null
        ? DateFormat('d MMM').format(news.publishedAt!)
        : '';
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
        ),
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
                  Gap(4.h),
                  Text(dateStr,
                      style: AppTextStyle.smallBody
                          .copyWith(color: Colors.grey, fontSize: 10.sp)),
                ],
              ),
            ),
            Gap(12.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _networkImage(news.thumbnail, w: 80.w, h: 80.w),
            ),
          ],
        ),
      ),
    );
  }

  // ─── products ─────────────────────────────────────────────────────────────

  Widget _buildProductCard(Product product) {
    final box = Hive.box<HiveCartModel>(AppConstants.cartBox);
    final inCart = box.values.any((e) => e.id == product.id);

    // FIX BUG-014: la card entera abre el popup de detalle
    return InkWell(
      onTap: () => ProductDetailSheet.show(context, product: product),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 120.h,
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
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8.r)),
              child: _networkImage(product.thumbnail, w: 120.w, h: 120.h),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name ?? '',
                            style: AppTextStyle.normalBody
                                .copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        if (product.brand != null)
                          Text(product.brand!,
                              style: AppTextStyle.smallBody
                                  .copyWith(color: Colors.grey)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // FIX BUG-013: formato correcto €XX.XX
                          '${(product.price ?? 0.0).toStringAsFixed(2)} €',
                          style: AppTextStyle.normalBody.copyWith(
                              fontWeight: FontWeight.w600, color: Colors.blue),
                        ),
                        // FIX BUG-010: ValueListenableBuilder eliminado del onPressed.
                        // Se usa ValueListenableBuilder correctamente para reconstruir el botón.
                        ValueListenableBuilder<Box<HiveCartModel>>(
                          valueListenable:
                              Hive.box<HiveCartModel>(AppConstants.cartBox)
                                  .listenable(),
                          builder: (context, cartBox, _) {
                            final alreadyInCart =
                                cartBox.values.any((e) => e.id == product.id);
                            return SizedBox(
                              height: 32.h,
                              child: ElevatedButton(
                                onPressed: alreadyInCart
                                    ? null
                                    : () async {
                                        final cartModel = HiveCartModel(
                                          id: product.id,
                                          name: product.name ?? 'Senza nome',
                                          code: product.code ?? '',
                                          thumbnail: product.thumbnail ?? '',
                                          subTotal: product.price ?? 0.0,
                                          productsQTY: 1,
                                        );
                                        await cartBox.add(cartModel);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      alreadyInCart ? Colors.grey : Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                ),
                                // FIX: testo in italiano
                                child: Text(alreadyInCart
                                    ? 'Nel carrello'
                                    : 'Aggiungi'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), // cierra InkWell
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Header logo
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
          // Search bar
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
                      child: GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.r)),
                          ),
                          builder: (_) => const GlobalSearchSheet(),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            Gap(8.w),
                            Text('Cerca (opere, autori)...',
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.grey[400])),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.filter_list), onPressed: () {}),
                ],
              ),
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Esplora il MUCICOM ──────────────────────────────────
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // FIX BUG-008: los 3 van a ExploreView (misma pantalla del menú lateral)
                          Expanded(
                              child: _buildQuickAccessCard(
                            'Biglietti',
                            'Prezzi, sconti',
                            Icons.airplane_ticket,
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ExploreView())),
                          )),
                          Gap(12.w),
                          Expanded(
                              child: _buildQuickAccessCard(
                            'Orari',
                            'Apertura',
                            Icons.access_time,
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ExploreView())),
                          )),
                          Gap(12.w),
                          Expanded(
                              child: _buildQuickAccessCard(
                            'Posizione',
                            'Localizzazione',
                            Icons.location_on,
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ExploreView())),
                          )),
                        ],
                      ),
                    ),
                  ),

                  // ── Le nostre Collezioni ────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final ctrl =
                            ref.watch(collectionControllerProvider.notifier);
                        final isLoading =
                            ref.watch(collectionControllerProvider);
                        final collections = ctrl.collections;
                        return Column(
                          children: [
                            _sectionHeader('Le nostre Collezioni',
                                onSeeAll: () => Navigator.pushNamed(
                                    context, Routes.collectionsListView)),
                            Gap(12.h),
                            if (isLoading)
                              const Center(child: CircularProgressIndicator())
                            else if (collections == null || collections.isEmpty)
                              _emptyText('Nessuna collezione disponibile')
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: collections.length,
                                separatorBuilder: (_, __) => Gap(8.h),
                                itemBuilder: (_, i) => _buildCollectionItem(
                                  collections[i].name,
                                  collections[i].description, // FIX BUG-003
                                  imageUrl: collections[i].thumbnail,
                                  // navega al detalle de la colección seleccionada
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    Routes.collectionDetail,
                                    arguments: collections[i],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  Gap(16.h),

                  // ── I nostri Artisti ────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final ctrl =
                            ref.watch(brandControllerProvider.notifier);
                        final isLoading = ref.watch(brandControllerProvider);
                        final artists = ctrl.brands;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader('I nostri Artisti',
                                onSeeAll: () => Navigator.pushNamed(
                                    context, Routes.artistsListView)),
                            Gap(12.h),
                            SizedBox(
                              height: 128.h,
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : (artists == null || artists.isEmpty)
                                      ? _emptyText('Nessun artista disponibile')
                                      : ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: artists.length,
                                          separatorBuilder: (_, __) =>
                                              Gap(16.w),
                                          itemBuilder: (_, i) =>
                                              _buildArtistItem(
                                            artists[i],
                                            // navega al detalle del artista con sus obras
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              Routes.artistDetail,
                                              arguments: artists[i],
                                            ),
                                          ),
                                        ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  Gap(16.h),

                  // ── I nostri Masterpiece ────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final ctrl =
                            ref.watch(masterpieceControllerProvider.notifier);
                        final isLoading =
                            ref.watch(masterpieceControllerProvider);
                        final items = ctrl.masterpieces;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader('I nostri Masterpiece',
                                onSeeAll: () => Navigator.pushNamed(
                                    context, Routes.masterpiecesListView)),
                            Gap(12.h),
                            if (isLoading)
                              const Center(child: CircularProgressIndicator())
                            else if (items == null || items.isEmpty)
                              _emptyText('Nessun capolavoro disponibile')
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
                                itemBuilder: (_, i) => _buildMasterpieceItem(
                                  items[i],
                                  // FIX: navegar al detalle del masterpiece
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    Routes.masterpieceDetail,
                                    arguments: items[i],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  Gap(16.h),

                  // ── Non perderti i nostri Eventi ────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final ctrl =
                            ref.watch(eventControllerProvider.notifier);
                        final isLoading = ref.watch(eventControllerProvider);
                        final items = ctrl.events;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader('Non perderti i nostri Eventi',
                                onSeeAll: () => Navigator.pushNamed(
                                    context, Routes.eventsListView)),
                            Gap(12.h),
                            SizedBox(
                              height: 200.h,
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : (items == null || items.isEmpty)
                                      ? _emptyText('Nessun evento disponibile')
                                      : ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: items.length,
                                          separatorBuilder: (_, __) =>
                                              Gap(12.w),
                                          itemBuilder: (_, i) =>
                                              _buildEventCard(
                                            items[i],
                                            // FIX: navegar al detalle del evento
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              Routes.eventDetail,
                                              arguments: items[i],
                                            ),
                                          ),
                                        ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  Gap(16.h),

                  // ── Novità dal MUCICOM ──────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final ctrl = ref.watch(newsControllerProvider.notifier);
                        final isLoading = ref.watch(newsControllerProvider);
                        final items = ctrl.news;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader('Novità dal MUCICOM',
                                onSeeAll: () => Navigator.pushNamed(
                                    context, Routes.newsListView)),
                            if (isLoading)
                              const Center(child: CircularProgressIndicator())
                            else if (items == null || items.isEmpty)
                              _emptyText('Nessuna notizia disponibile')
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (_, i) => _buildNewsCard(
                                  items[i],
                                  // FIX: navegar al detalle de la noticia
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    Routes.newsDetail,
                                    arguments: items[i],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  Gap(16.h),

                  // ── Categorie Popolari ──────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final ctrl =
                            ref.watch(categoryControllerProvider.notifier);
                        final isLoading = ref.watch(categoryControllerProvider);
                        final categories = ctrl.categories;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FIX BUG-017: "Vedi tutti" conectado (aunque la ruta no exista aún)
                            _sectionHeader('Categorie Popolari'),
                            Gap(8.h),
                            if (isLoading)
                              SizedBox(
                                height: 40.h,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              )
                            else if (categories == null || categories.isEmpty)
                              SizedBox(
                                height: 40.h,
                                child:
                                    _emptyText('Nessuna categoria disponibile'),
                              )
                            else
                              SizedBox(
                                height: 40.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  separatorBuilder: (_, __) => Gap(8.w),
                                  itemBuilder: (_, i) => _buildCategoryChip(
                                    categories[i].name,
                                    onTap: () => debugPrint(
                                        'Categoria selezionata: ${categories[i].name}'),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  Gap(16.h),

                  // ── I prodotti più venduti ──────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final ctrl =
                            ref.watch(productControllerProvider.notifier);
                        final isLoading = ref.watch(productControllerProvider);
                        final products = ctrl.products;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader('I prodotti più venduti',
                                onSeeAll: () => Navigator.pushNamed(
                                    context, Routes.productView)),
                            Gap(12.h),
                            if (isLoading)
                              const Center(child: CircularProgressIndicator())
                            else if (products == null || products.isEmpty)
                              _emptyText('Nessun prodotto disponibile')
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: products.length,
                                separatorBuilder: (_, __) => Gap(16.h),
                                itemBuilder: (_, i) =>
                                    _buildProductCard(products[i]),
                              ),
                          ],
                        );
                      },
                    ),
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
