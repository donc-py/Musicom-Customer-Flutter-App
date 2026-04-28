import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/dashboard_controller/dashoard.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/views/dashboard/components/financial_section.dart';
import 'package:readypos_flutter/views/dashboard/components/logo_section.dart';
import 'package:readypos_flutter/views/dashboard/components/purchase_sale_graph.dart';
import 'package:readypos_flutter/views/dashboard/components/user_info_section.dart';
import 'package:readypos_flutter/controllers/category_controller/category.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/collection_controller/collection.dart';
import 'package:readypos_flutter/models/brand/brand.dart';
import 'package:readypos_flutter/controllers/product_controller/product_controller.dart';
import 'package:readypos_flutter/models/product_model.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';
import 'package:readypos_flutter/controllers/masterpiece_controller/masterpiece_controller.dart';
import 'package:readypos_flutter/controllers/event_controller/event_controller.dart';
import 'package:readypos_flutter/controllers/news_controller/news_controller.dart';

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
      ref.read(newsControllerProvider.notifier).getNews(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
          );
      ref.read(eventControllerProvider.notifier).getEvents(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
            upcoming: true,
          );
      ref.read(masterpieceControllerProvider.notifier).getMasterpieces(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
          );
      // Load collections
      ref.read(collectionControllerProvider.notifier).getCollections(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
          );
      //load categories
      ref.read(categoryControllerProvider.notifier).getCategories(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
          );
      // Load artists
      ref.read(brandControllerProvider.notifier).getBrands(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
          );
      // Load products
      ref.read(productControllerProvider.notifier).getProducts(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: isLargeScreen
      //       ? context.isTabletLandsCape
      //           ? 340.h
      //           : 240.h
      //       : 230.h,
      //   automaticallyImplyLeading: false,
      //   surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
      //       ? AppColor.darkBackgroundColor
      //       : Colors.white,
      //   flexibleSpace: Container(
      //     width: double.infinity,
      //     padding: EdgeInsets.symmetric(horizontal: 16.w),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Gap(68.h),
      //         const LogoSection(),
      //         Gap(12.h),
      //         const UserInfo(),
      //       ],
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
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
                // Gap(12.h),
                // const UserInfo(),
                // Gap(12.h),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
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
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de accesos rápidos
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      children: [
                        _buildQuickAccessCard(
                          'Biglietti',
                          'Prezzi, sconti',
                          Icons.airplane_ticket,
                        ),
                        Gap(12.w),
                        _buildQuickAccessCard(
                          'Orari',
                          'Apertura',
                          Icons.access_time,
                        ),
                        Gap(12.w),
                        _buildQuickAccessCard(
                          'Posizione',
                          'Localizzazione',
                          Icons.location_on,
                        ),
                      ].map((widget) => Expanded(child: widget)).toList(),
                    ),
                  ),

                  // Sección de colecciones
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final collectionController = ref
                                .watch(collectionControllerProvider.notifier);
                            final isLoading =
                                ref.watch(collectionControllerProvider);
                            final collections =
                                collectionController.collections;

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Le nostre Collezioni',
                                      style: AppTextStyle.title.copyWith(
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text('See all'),
                                    ),
                                  ],
                                ),
                                Gap(12.h),
                                if (isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if (collections == null ||
                                    collections.isEmpty)
                                  Center(
                                    child: Text(
                                      'No collections available',
                                      style: AppTextStyle.smallBody
                                          .copyWith(color: Colors.grey),
                                    ),
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: collections.length,
                                    separatorBuilder: (context, index) =>
                                        Gap(8.h),
                                    itemBuilder: (context, index) {
                                      final collection = collections[index];
                                      return _buildCollectionItem(
                                        collection.name,
                                        'No description available',
                                        imageUrl: collection.thumbnail,
                                      );
                                    },
                                  ),
                              ],
                            );
                          },
                        ),
                        Gap(12.h),
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'I nostri Artisti',
                                    style: AppTextStyle.title.copyWith(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'See all',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(12.h),
                              SizedBox(
                                height: 128.h,
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    final brandController = ref.watch(
                                        brandControllerProvider.notifier);
                                    final isLoading =
                                        ref.watch(brandControllerProvider);
                                    final artists = brandController.brands;

                                    if (isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (artists == null || artists.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No artists available',
                                          style: AppTextStyle.smallBody
                                              .copyWith(color: Colors.grey),
                                        ),
                                      );
                                    }

                                    return ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: artists.length,
                                      separatorBuilder: (context, index) =>
                                          Gap(16.w),
                                      itemBuilder: (context, index) {
                                        final artist = artists[index];
                                        return _buildArtistItem(artist);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // I nostri Masterpiece
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('I nostri Masterpiece',
                                style: AppTextStyle.title
                                    .copyWith(fontSize: 18.sp)),
                            TextButton(
                                onPressed: () {}, child: const Text('See all')),
                          ],
                        ),
                        Gap(12.h),
                        Consumer(
                          builder: (context, ref, child) {
                            final ctrl = ref
                                .watch(masterpieceControllerProvider.notifier);
                            final isLoading =
                                ref.watch(masterpieceControllerProvider);
                            final items = ctrl.masterpieces;

                            if (isLoading)
                              return const Center(
                                  child: CircularProgressIndicator());
                            if (items == null || items.isEmpty)
                              return Center(
                                  child: Text('No masterpieces available',
                                      style: AppTextStyle.smallBody
                                          .copyWith(color: Colors.grey)));

                            return GridView.builder(
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
                              itemBuilder: (context, index) =>
                                  _buildMasterpieceItem(items[index]),
                            );
                          },
                        ),
                        Gap(12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Popular Categories',
                              style: AppTextStyle.title.copyWith(
                                fontSize: 18.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('See all'),
                            ),
                          ],
                        ),
                        // Popular Categories
                        // SizedBox(
                        //   height: 40.h,
                        //   child: ListView(
                        //     scrollDirection: Axis.horizontal,
                        //     children: [
                        //       _buildCategoryChip('Top 10 Opere'),
                        //       Gap(8.w),
                        //       _buildCategoryChip('Arte Africana'),
                        //       Gap(8.w),
                        //       _buildCategoryChip('Giuseppe Coco'),
                        //       Gap(8.w),
                        //       _buildCategoryChip('Collezione Portal'),
                        //       Gap(8.w),
                        //       _buildCategoryChip('Collezione Museo Civico'),
                        //     ],
                        //   ),
                        // ),
                        Consumer(
                          builder: (context, ref, child) {
                            final categoryController =
                                ref.watch(categoryControllerProvider.notifier);
                            final isLoading =
                                ref.watch(categoryControllerProvider);
                            final categories = categoryController.categories;

                            if (isLoading) {
                              return SizedBox(
                                height: 40.h,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (categories == null || categories.isEmpty) {
                              return SizedBox(
                                height: 40.h,
                                child: Center(
                                  child: Text(
                                    'No categories available',
                                    style: AppTextStyle.smallBody
                                        .copyWith(color: Colors.grey),
                                  ),
                                ),
                              );
                            }

                            return SizedBox(
                              height: 40.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                separatorBuilder: (context, index) => Gap(8.w),
                                itemBuilder: (context, index) {
                                  return _buildCategoryChip(
                                    categories[index].name,
                                    onTap: () {
                                      // Handle category selection
                                      debugPrint(
                                          'Selected category: ${categories[index].name}');
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        Gap(16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'I prodotti più venduti',
                              style: AppTextStyle.title.copyWith(
                                fontSize: 18.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('See all'),
                            ),
                          ],
                        ),
                        Gap(12.h),
                        Consumer(
                          builder: (context, ref, child) {
                            final productController =
                                ref.watch(productControllerProvider.notifier);
                            final isLoading =
                                ref.watch(productControllerProvider);
                            final products = productController.products;

                            if (isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (products == null || products.isEmpty) {
                              return Center(
                                child: Text(
                                  'No products available',
                                  style: AppTextStyle.smallBody
                                      .copyWith(color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: _buildProductCard(product),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(8.r)),
            child: SizedBox(
              width: 120.w,
              height: 120.h,
              child: product.thumbnail != null
                  ? Image.network(
                      product.thumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[400],
                            size: 30.r,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[400],
                        size: 30.r,
                      ),
                    ),
            ),
          ),

          // Información del producto
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre y marca
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '',
                        style: AppTextStyle.normalBody.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (product.brand != null)
                        Text(
                          product.brand!,
                          style: AppTextStyle.smallBody.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),

                  // Precio y botón
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.price} €',
                        style: AppTextStyle.normalBody.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                          ),
                          child: const Text('Add to cart'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          Gap(8.h),
          Text(
            title,
            style: AppTextStyle.normalBody.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyle.smallBody.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

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
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40.r),
            child: artist.thumbnail != null
                ? Image.network(
                    artist.thumbnail!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          size: 40.r,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 40.r,
                      color: Colors.grey[400],
                    ),
                  ),
          ),
        ),
        Gap(8.h),
        SizedBox(
          width: 80.w,
          child: Text(
            artist.name,
            textAlign: TextAlign.center,
            style: AppTextStyle.smallBody.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionItem(String title, String description,
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
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[400],
                            size: 30.r,
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[400],
                      size: 30.r,
                    ),
                  ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.normalBody.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyle.smallBody.copyWith(
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: AppTextStyle.smallBody,
        ),
      ),
    );
  }

  Widget _buildMasterpieceItem(Masterpiece item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: item.thumbnail != null
                ? Image.network(item.thumbnail!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.image, color: Colors.grey[400])))
                : Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey[400])),
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
}
