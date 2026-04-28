import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/controllers/product_controller/product_controller.dart';
import 'package:readypos_flutter/controllers/collection_controller/collection.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/category_controller/category.dart';
import 'package:readypos_flutter/views/products/components/product_card.dart';
import 'package:readypos_flutter/views/products/components/product_searchBar.dart';
import 'package:readypos_flutter/views/products/layouts/product_layout.dart';

class ProductsHubLayout extends ConsumerStatefulWidget {
  const ProductsHubLayout({super.key});
  

  @override
  ConsumerState<ProductsHubLayout> createState() => _ProductsHubLayoutState();
}

class _ProductsHubLayoutState extends ConsumerState<ProductsHubLayout> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int page = 1;
  final int perPage = 20;
  bool scrollLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
    _setupListeners();
  }

  void _initializeData() {
    // Cargar datos iniciales
    ref.read(collectionControllerProvider.notifier).getCollections(
          page: 1,
          perPage: 20,
          search: null,
          pagination: false,
        );
    ref.read(categoryControllerProvider.notifier).getCategories(
          page: 1,
          perPage: 20,
          search: null,
          pagination: false,
        );
    ref.read(brandControllerProvider.notifier).getBrands(
          page: 1,
          perPage: 20,
          search: null,
          pagination: false,
        );
    ref.read(productControllerProvider.notifier).getProducts(
          page: 1,
          perPage: 20,
          search: null,
          pagination: false,
        );
  }

  void _setupListeners() {
    scrollController.addListener(_scrollListener);
    searchController.addListener(() {
      ref.read(productControllerProvider.notifier).getProducts(
            page: 1,
            perPage: 20,
            search: searchController.text,
            pagination: false,
          );
    });
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!ref.watch(productControllerProvider) && !scrollLoading) {
        setState(() {
          scrollLoading = true;
          page++;
        });
        _loadMoreProducts();
      }
    }
  }

  Future<void> _loadMoreProducts() async {
    await ref.read(productControllerProvider.notifier).getProducts(
          page: page,
          perPage: perPage,
          search: searchController.text,
          pagination: true,
        );
    setState(() {
      scrollLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).products, style: AppTextStyle.title),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Gap(10.h),
          _buildFilterCategories(),
          Gap(10.h),
          _buildProductList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ProductSearchBar(
        controller: searchController,
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildFilterCategories() {
    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          _buildFilterChip(
            label: S.of(context).categories,
            onTap: () => _navigateToCollections(),
          ),
          Gap(8.w),
          _buildFilterChip(
            label: S.of(context).categories,
            onTap: () => _navigateToCategories(),
          ),
          Gap(8.w),
          _buildFilterChip(
            label: S.of(context).categories,
            onTap: () => _navigateToArtists(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required VoidCallback onTap}) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColor.primaryColor.withOpacity(0.1),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      child: ref.watch(productControllerProvider) && !scrollLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                searchController.clear();
                setState(() {
                  page = 1;
                });
                _initializeData();
              },
              child: ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: ref.watch(productControllerProvider.notifier).products?.length ?? 0,
                itemBuilder: (context, index) {
                  final product = ref.watch(productControllerProvider.notifier).products![index];
                  return ProductCard(
                    product: product,
                    onTap: () => {},
                  );
                },
                separatorBuilder: (_, __) => Divider(height: 1.h),
              ),
            ),
    );
  }

  void _navigateToCollections() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductLayout(),
      ),
    );
  }

  void _navigateToCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductLayout(),
      ),
    );
  }

  void _navigateToArtists() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductLayout(),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}