import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/product_controller/product_controller.dart';
import 'package:readypos_flutter/models/product_model.dart';
import 'package:readypos_flutter/views/products/components/product_card.dart';
import 'package:readypos_flutter/views/products/components/product_detail_sheet.dart';
import 'package:readypos_flutter/views/products/components/product_searchBar.dart';

class ProductLayout extends ConsumerStatefulWidget {
  const ProductLayout({super.key});

  @override
  ConsumerState<ProductLayout> createState() => _ProductLayoutState();
}

class _ProductLayoutState extends ConsumerState<ProductLayout> {
  final TextEditingController productSearchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int page = 1;
  final int perPage = 15;
  bool scrollLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(productControllerProvider.notifier).products == null) {
        ref.read(productControllerProvider.notifier).getProducts(
              page: 1,
              perPage: 15,
              search: null,
              pagination: false,
            );
      }
    });
    scrollController.addListener(_scrollListener);
    productSearchController.addListener(() {
      ref.read(productControllerProvider.notifier).getProducts(
            page: 1,
            perPage: 15,
            search: productSearchController.text.isEmpty
                ? null
                : productSearchController.text,
            pagination: false,
          );
    });
    super.initState();
  }

  @override
  void dispose() {
    productSearchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final ctrl = ref.read(productControllerProvider.notifier);
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !ref.read(productControllerProvider) &&
        ctrl.products != null &&
        ctrl.total != null &&
        ctrl.products!.length < ctrl.total!.toInt()) {
      scrollLoading = true;
      page++;
      ctrl.getProducts(
        page: page,
        perPage: perPage,
        search: null,
        pagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        // FIX: título en italiano
        title: Text('Prodotti', style: AppTextStyle.title),
        surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
      ),
      body: Column(
        children: [
          // FIX: hint en italiano
          ProductSearchBar(
            controller: productSearchController,
            onChanged: (value) {},
          ),
          Gap(14.h),
          _buildProductListWidget(),
        ],
      ),
    );
  }

  Widget _buildProductListWidget() {
    return Expanded(
      child: ref.watch(productControllerProvider) && !scrollLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                productSearchController.clear();
                page = 1;
                ref.read(productControllerProvider.notifier).getProducts(
                      page: 1,
                      perPage: 15,
                      search: null,
                      pagination: false,
                    );
              },
              child: ref
                          .watch(productControllerProvider.notifier)
                          .products
                          ?.isEmpty ==
                      true
                  ? Center(
                      child: Text('Nessun prodotto disponibile',
                          style: AppTextStyle.smallBody
                              .copyWith(color: Colors.grey)),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: ref
                              .watch(productControllerProvider.notifier)
                              .products
                              ?.length ??
                          0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final Product product = ref
                            .watch(productControllerProvider.notifier)
                            .products![index];
                        return ProductCard(
                          product: product,
                          // FIX BUG-011 + BUG-014: tap abre ProductDetailSheet
                          onTap: () => ProductDetailSheet.show(
                            context,
                            product: product,
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(
                        height: 0,
                        indent: 20,
                        endIndent: 20,
                        color: AppColor.borderColor,
                      ),
                    ),
            ),
    );
  }
}
