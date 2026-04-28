import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/brand/brand.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/products/components/brand_card.dart';
import 'package:readypos_flutter/views/products/components/product_searchBar.dart';

class BrandsLayout extends ConsumerStatefulWidget {
  const BrandsLayout({super.key});

  @override
  ConsumerState<BrandsLayout> createState() => _BrandsLayoutState();
}

class _BrandsLayoutState extends ConsumerState<BrandsLayout> {
  final TextEditingController brandSearchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int page = 1;
  final int perPage = 20;
  bool scrollLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //if (ref.read(brandControllerProvider.notifier).brands == null) {
        ref.read(brandControllerProvider.notifier).getBrands(
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
    brandSearchController.addListener(() {
      ref.read(brandControllerProvider.notifier).getBrands(
            page: 1,
            perPage: 20,
            search: brandSearchController.text,
            pagination: false,
          );
    });
    super.initState();
  }

  void scrolListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      if (ref.watch(brandControllerProvider.notifier).brands!.length <
              ref.watch(brandControllerProvider.notifier).total!.toInt() &&
          !ref.watch(brandControllerProvider)) {
        scrollLoading = true;
        page++;
        ref.read(brandControllerProvider.notifier).getBrands(
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        title: Text(
          S.of(context).brand,
          style: AppTextStyle.title,
        ),
        surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : Colors.white,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ProductSearchBar(
                controller: brandSearchController,
                onChanged: (value) {},
              ),
              Gap(14.h),
              _buildProductListWidget(),
            ],
          ),
          Positioned(
            bottom: 20.h,
            right: 20.w,
            child: _buildFloatingActionButton(context: context),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListWidget() {
    return Expanded(
      child: ref.watch(brandControllerProvider) && !scrollLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                brandSearchController.clear();
                ref.read(brandControllerProvider.notifier).getBrands(
                      page: page,
                      perPage: perPage,
                      search: null,
                      pagination: false,
                    );
              },
              child: ListView.separated(
                itemCount: ref
                        .watch(brandControllerProvider.notifier)
                        .brands
                        ?.length ??
                    0,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  final Brand brand = ref
                      .watch(brandControllerProvider.notifier)
                      .brands![index];
                  return BrandCard(
                    brand: brand,
                    onTap: () {},
                  );
                }),
                separatorBuilder: (context, index) => const Divider(
                  height: 0,
                  indent: 20,
                  endIndent: 20,
                  color: AppColor.borderColor,
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
          context.nav.pushNamed(Routes.brandAddUpdateView);
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
