import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/controllers/category_controller/category.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/category/category.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/products/components/category_card.dart';
import 'package:readypos_flutter/views/products/components/product_appBar.dart';
import 'package:readypos_flutter/views/products/components/product_searchBar.dart';

class CategoriesLayout extends ConsumerStatefulWidget {
  const CategoriesLayout({super.key});
  @override
  ConsumerState<CategoriesLayout> createState() => _CategoriesLayoutState();
}

class _CategoriesLayoutState extends ConsumerState<CategoriesLayout> {
  final TextEditingController categorySearchController =
      TextEditingController();
  final ScrollController scrollController = ScrollController();

  int page = 1;
  final int perPage = 20;
  bool scrollLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if (ref
      //     .read(categoryControllerProvider.notifier)
      //     .parentCategories
      //     .isEmpty) {
      //   ref.read(categoryControllerProvider.notifier).getParentCategory();
      // }
      //if (ref.read(categoryControllerProvider.notifier).categories == null) {
      ref.read(categoryControllerProvider.notifier).getCategories(
            page: 1,
            perPage: 20,
            search: null,
            pagination: false,
          );
      //}
    });
    scrollController.addListener(() {
      scrolListener();
    });
    categorySearchController.addListener(() {
      ref.read(categoryControllerProvider.notifier).getCategories(
            page: 1,
            perPage: 20,
            search: categorySearchController.text,
            pagination: false,
          );
    });
    super.initState();
  }

  void scrolListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      if (ref.watch(categoryControllerProvider.notifier).categories!.length <
              ref.watch(categoryControllerProvider.notifier).total!.toInt() &&
          !ref.watch(categoryControllerProvider)) {
        scrollLoading = true;
        page++;
        ref.read(categoryControllerProvider.notifier).getCategories(
              page: page,
              perPage: perPage,
              search: null,
              pagination: true,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: context.isTabletLandsCape
              ? Size.fromHeight(
                  120.h - MediaQuery.of(context).padding.top,
                )
              : Size.fromHeight(
                  100.h - MediaQuery.of(context).padding.top,
                ),
          child: ProductAppBar(
            title: S.of(context).categories,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                ProductSearchBar(
                  controller: categorySearchController,
                  onChanged: (value) {},
                ),
                _buildProductListWidget(context: context),
              ],
            ),
            Positioned(
              right: 20.w,
              bottom: 20.h,
              child: _buildFloatingActionButton(context: context),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProductListWidget({required BuildContext context}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 14.h),
        color: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
        child: ref.watch(categoryControllerProvider) && !scrollLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  categorySearchController.clear();
                  ref.read(categoryControllerProvider.notifier).getCategories(
                        page: page,
                        perPage: perPage,
                        search: null,
                        pagination: false,
                      );
                },
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: ref
                          .watch(categoryControllerProvider.notifier)
                          .categories
                          ?.length ??
                      0,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    final Category category = ref
                        .watch(categoryControllerProvider.notifier)
                        .categories![index];
                    return CategoryCard(
                      category: category,
                      onTap: () {},
                    );
                  }),
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                    color: AppColor.borderColor,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildFloatingActionButton({required BuildContext context}) {
    return Material(
      shape: const CircleBorder(),
      color: AppColor.primaryColor,
      child: InkWell(
        onTap: () {
          context.nav.pushNamed(Routes.categoryAddUpdateView);
        },
        borderRadius: BorderRadius.circular(100.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: context.isTabletLandsCape ? 100.h : 60.h,
            width: context.isTabletLandsCape ? 100.h : 60.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: AppColor.whiteColor,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
